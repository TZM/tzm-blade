#Load external dependencies
express = require "express"
stylus = require "stylus"
mongoose = require "mongoose"
i18next = require "i18next"
#Load local dependencies
config = require "./config/config"
models = require "./config/models"
apps = require "./config/apps"
routes = require "./config/routes"
# passport = require "passport"
riak = require('riak-js').getClient(
  host: config.RIAK_DB.host, 
  port: config.RIAK_DB.port, 
  debug: true)

console.log "riak hostname: ", config.RIAK_DB.host
console.log "riak port: ", config.RIAK_DB.port

# console.log(passport);

riak.on "error", (err)->
  console.log("RIAK ERROR:", err);
riak.on "connected", ->
  console.log("RIAK CONNECTED");

# console.log(passport);

# ---------------------------------------- delete
sanitize = require("validator").sanitize
validator = require("./utils/validation").validator()
validation = require("./utils/validation")
messages = require("./utils/messages")
{createClient} = require 'riakpbc'
{createModel} = require 'zukai'

User = createModel
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

SALT_WORK_FACTOR = 10
# default to a max of 5 attempts, result in a 2 hour lock
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 2 * 60 * 60 * 1000
# token alive time is 24 hours
TOKEN_TIME = 24 * 60 * 60 * 1000

bcrypt = require "bcrypt"
crypto = require "crypto"
base64url = require "base64url"

# Bcrypt middleware
User.pre 'put', (object, next)->
  # only hash the password if it has been modified (or is new)
  if object.doc.password
    # generate a salt
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      return next(err) if err

      # hash the password along with our new salt
      bcrypt.hash object.doc.password, salt, (err, hash) ->
        return next(err) if err

        # override the cleartext password with the hashed one
        object.doc.password = hash

        # update token
        crypto.randomBytes 48, (ex, buf) ->
          object.doc.tokenString = base64url(buf)
          object.doc.tokenExpires = Date.now() + TOKEN_TIME
          next()

# userSave.put (err, object)->
# if(!err)
# console.log 'zukai saved'
# if object
# console.log object.doc
# console.log object.key
# savedKey = object.key

# if typeof(savedKey) isnt undefined
# User.get savedKey, (error, object)->
# if(!error)
# console.log 'zukai get'
# if(object)
# # console.log object
# console.log object.doc

# # userSave.statics.register userSave, (data)->
# # console.log data
# userSave.statics.activate 'MykzD7WYkPtK51HXn2fHf3wmfeS', '6YhyXc9y71sBiXfbGyosNls_oIrpLNKjqWpL7Eg_-KMmxAX5UWFgtoSRpLBNY_2O', (data)->
# console.log 'token', data

# else
# console.log 'zukai error'
# else
# console.log 'zukai', error
# else
# console.log 'no savedKey'

# else
# console.log 'error'
# else
# console.log 'zukai', err

User.methods = {}
User.statics = {}

User.methods.isLocked =->
  # check for a future lockUntil timestamp
  !!(userSave.doc.lockUntil != undefined and userSave.doc.lockUntil > Date.now())

# Password verfication
User.methods.comparePassword = (userPassword, cb) ->
  bcrypt.compare userPassword, userSave.doc.password, (err, isMatch) ->
    return cb(err) if err
    cb null, isMatch

User.methods.incLoginAttempts = (cb) ->
  #if we have a previous lock that has expired, restart at 1
  if userSave.key
    if userSave.doc.lockUntil isnt undefined
      if userSave.doc.lockUntil < Date.now()
        if userSave.doc.lockUntil == 1
          userSave.doc.lockUntil = 0
          userSave.doc.loginAttempts = 1
          userSave.put (err, object)->
            return cb(err) if err
            if(!err)
              console.log 'zukai update'
            if object
              console.log object.doc
              console.log object.key
              savedKey = object.key
              cb savedKey

    # otherwise were incrementing
    userSave.doc.loginAttempts = userSave.doc.loginAttempts + 1

    # lock the user if we've reached max attempts and it's not locked already
    userSave.doc.lockUntil = Date.now() + LOCK_TIME if userSave.doc.loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS and not userSave.methods.isLocked()
    userSave.put (err, object)->
      return cb(err) if err
      if(!err)
        console.log 'zukai update2'
      if object
        console.log object.doc
        console.log object.key
        savedKey = object.key
        cb savedKey

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
          return cb("user-exists") if object.doc

        else

          userSave = User.create user
          console.log 'userSave', userSave

          userSave.put (err, object)->
            return cb(err) if err
            if(!err)
              console.log 'zukai create'
              if object
                console.log object.doc
                console.log object.key
                savedKey = object.key
                cb savedKey

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
                return cb("save error") if err
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
# —---------------------------------------------- delete

#Load and intitialize logger
logger = require "./utils/logger"
logCategory = "APP config"
flash = require "connect-flash"

riak.on "error", (err)->
  console.log("RIAK ERROR:", err);
riak.on "connected", ->
  console.log("RIAK CONNECTED");


# Create server and set environment
app = express()
app.configure ->
  app.use( flash() )
#   app.use(passport.initialize())
#   app.use(passport.session())
#   app.use(require "./config/passport")
 

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
  




app.configure "production", "development", "test", ->
  config.setEnvironment app.settings.env
  console.log 'environment is: ', app.settings.env


# TODO store log messages in the RIAK db
logger.configure()
logger.info "--- App server created and local env set to: "+app.settings.env+" ---", logCategory

#Define Port
app.port = config.PORT
logger.info "--- Server running on port: "+app.port+" --- ", logCategory

#Connect to database
dbconnection = require "./utils/dbconnect"
dbconnection.init (result) ->
  if result
    logger.info "Database initialized: " + result, logCategory

#Exports
module.exports = ->
  
  #  Load Mongoose Models
  models app
  # Init i18next
  i18next.init(config.I18N)
  # Load Expressjs config
  apps app
  #  Load routes config
  routes app
  # 
  app
# register i18next helpers


i18next.registerAppHelper(app)
logger.info "--- Modules loaded into namespace ---", logCategory

