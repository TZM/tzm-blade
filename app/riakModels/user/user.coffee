# 
# User model
# zukai Model schema for riak
#

mongoose = require "mongoose"
bcrypt = require "bcrypt"
crypto = require "crypto"
base64url = require "base64url"
sanitize = require("validator").sanitize
validator = require("../../utils/validation").validator()
validation = require("../../utils/validation")
messages = require "../../utils/messages"
{createClient} = require 'riakpbc'
{createModel} = require 'zukai'
# nitive riak
riak = require('riak-js').getClient(
  host: config.RIAK_DB.host, 
  port: config.RIAK_DB.port, 
  debug: true)

# check, is riak start
console.log "riak hostname: ", config.RIAK_DB.host
console.log "riak port: ", config.RIAK_DB.port

# native just for test write, read
# riak.on "error", (err)->
#   console.log("RIAK ERROR:", err);
# riak.on "connected", ->
#   console.log("RIAK CONNECTED");
# riak.save "users", "user@gmail.com",
#   name: "justUser"
#   password: "simplypassword"
#   country: "NL"
#   active: false

# riak.get "users", "user@gmail.com", (err, user, meta) ->
#   unless err
#     console.log("RIAK user found: ", user);
#     user.active = true
#     meta.links.push
#       bucket: "users"
#       key: "user@gmail.com"
#     console.log("RIAK meta: ", meta);
#     console.log("RIAK user: ", user);
#     riak.save "flights", "user@gmail.com", user, meta
#   else
#   console.log("RIAK get error: ",err);


SALT_WORK_FACTOR = 10
# default to a max of 5 attempts, result in a 2 hour lock
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 2 * 60 * 60 * 1000
# token alive time is 24 hours
TOKEN_TIME = 24 * 60 * 60 * 1000

# using zukai (ODM)
UserSchema = createModel
  name: 'User'
  bucket: 'users'
  connection: createClient()
  schema:
    properties:
      email:
        type: 'string'
        required: true
        index:
          unique: true
      password:
        type: 'string'
        required: true
      active:
        type: 'boolean'
        require: true
        default: false
      name:
        type: 'string'
        require: false
        default: 'user'
      surname:
        type: 'string'
        require: false
        default: ''
      #groups: [UserGroupSchema]
      groups: # [guest, member, reviewer, admin]
        type: 'string'
        enum: ["guest", "member", "reviewers", "admin"]
        default: "guest"
      loginAttempts:
        type: 'number'
        required: true
        default: 0
      lockUntil:
        type: 'number'
        default: 0
      tokenString:
        type: 'string'
      tokenExpires:
        type: 'number'

UserSchema.methods = {}
UserSchema.statics = {}

# expose enum on the model, and provide an internal convenience reference
# TODO: replace the error message with this enum, then show messages from views
UserSchema.statics.failedLogin =
  NOT_FOUND: 0
  PASSWORD_INCORRECT: 1
  MAX_ATTEMPTS: 2
  INACTIVE: 3
  TOKEN_UNMATCH: 4
  TOKEN_EXPIRES: 5

# UserSchema.methods.isLocked =->
#   # check for a future lockUntil timestamp
#   !!(userSave.doc.lockUntil != undefined and userSave.doc.lockUntil > Date.now())

# Bcrypt middleware
UserSchema.pre 'put', (object, next)->
  # only hash the password if it has been modified (or is new)
  if object.doc.password
    # generate a salt
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      return next(err)  if err
    
      # hash the password along with our new salt
      bcrypt.hash object.doc.password, salt, (err, hash) ->
        return next(err)  if err

        # override the cleartext password with the hashed one
        object.doc.password = hash
        
        # update token
        crypto.randomBytes 48, (ex, buf) ->
          object.doc.tokenString = base64url(buf)
          object.doc.tokenExpires = Date.now() + TOKEN_TIME
          next()

# # Password verfication
# UserSchema.methods.comparePassword = (userPassword, cb) ->
#   bcrypt.compare userPassword, userSave.doc.password, (err, isMatch) ->
#     return cb(err)  if err
#     cb null, isMatch

# UserSchema.methods.incLoginAttempts = (cb) ->
#   #if we have a previous lock that has expired, restart at 1
#   if userSave.key
#       if userSave.doc.lockUntil isnt undefined
#         if userSave.doc.lockUntil < Date.now()
#           if userSave.doc.lockUntil == 1
#             userSave.doc.lockUntil = 0
#           userSave.doc.loginAttempts = 1
#           userSave.put (err, object)->
#             return cb(err)  if err
#             if(!err)
#               console.log 'zukai update'
#               if object
#                 console.log object.doc
#                 console.log object.key
#                 savedKey = object.key
#                 cb savedKey

#       # otherwise were incrementing
#       userSave.doc.loginAttempts = userSave.doc.loginAttempts + 1

#       # lock the user if we've reached max attempts and it's not locked already
#       userSave.doc.lockUntil = Date.now() + LOCK_TIME  if userSave.doc.loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS and not userSave.methods.isLocked()
#       userSave.put (err, object)->
#             return cb(err)  if err
#             if(!err)
#               console.log 'zukai update2'
#               if object
#                 console.log object.doc
#                 console.log object.key
#                 savedKey = object.key
#                 cb savedKey

# Static methods
# Register new user
User.statics.register = (user, cb) ->

  user = 
    name: "qqq"
    email: "user3@gmail.com"
    password: "eeeeee"
    active: false
    loginAttempts: 8

  user.email = sanitize(user.email.toLowerCase().trim()).xss()
  validator.check(user.email, messages.VALIDATE_EMAIL).isEmail()
  errors = validator.getErrors()
  if errors.length
    errorString = errors.join("<br>")
    return cb(errorString)
    console.log "Registration form failed with " + errors
    #go to the signup page
    return cb(errorString, null)
  else
    User.get user.email, (error, object)->
      if(!error)
        console.log 'zukai get'
        if(object)
          console.log object.doc
          return cb("user-exists")  if object.doc

        else

          userSave = User.create user
          console.log 'userSave', userSave

          userSave.put (err, object)->
            return cb(err)  if err
            if(!err)
              console.log 'zukai create'
              if object
                console.log object.doc
                console.log object.key
                savedKey = object.key
                cb savedKey

          console.log 'zukai error'
      else
        console.log 'zukai', error
        cb(error)

# Activate new user
User.statics.activate = (id, token, cb) ->
  User.get id, (error, object)->
      if(!error)
        console.log 'zukai get token'
        if(object)
          console.log object.doc
          if object.doc.tokenString == token
            if object.doc.active == false
              if object.doc.tokenExpires > Date.now()
                object.doc.active = true
                object.doc.groups = "member"

                object.put (err, user)->
                  return cb("save error")  if err
                  if(!err)
                    console.log 'zukai activate'
                    if user
                      console.log user.doc
                      console.log user.key
                      savedKey = user.key
                      cb null, user

              else
                cb "token-expired"
            else
              console.log "user-already-active"
              cb "user-already-active"
          else
            console.log "token-undefined"
            cb "token-undefined"

        else
          console.log "token-expired-or-user-active"
          cb "token-expired-or-user-active"

      else
        console.log 'zukai', error
        cb(error)

User.statics.register {}, (data) ->
  console.log 'data', data
User.statics.activate 'MykzD7WYkPtK51HXn2fHf3wmfeS', '6YhyXc9y71sBiXfbGyosNls_oIrpLNKjqWpL7Eg_-KMmxAX5UWFgtoSRpLBNY_2O', (data)->
  console.log 'token', data

module.exports = mongoose.model 'User', UserSchema

