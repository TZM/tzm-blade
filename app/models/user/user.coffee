#
# User model
# Ideas from http://blog.mongodb.org/post/32866457221/password-authentication-with-mongoose-part-1
# and http://devsmash.com/blog/implementing-max-login-attempts-with-mongoose
#

mongoose = require "mongoose"
bcrypt = require "bcrypt"
crypto = require "crypto"
base64url = require "base64url"
sanitize = require("validator").sanitize
validator = require("../../utils/validation").validator()
validation = require("../../utils/validation")
messages = require "../../utils/messages"

SALT_WORK_FACTOR = 10
# default to a max of 5 attempts, result in a 2 hour lock
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 2 * 60 * 60 * 1000
# token alive time is 24 hours
TOKEN_TIME = 24 * 60 * 60 * 1000

# Database schema
Schema = mongoose.Schema

# User Groups schema
#UserGroupSchema = new Schema(
#  name:
#    type: String
#    required: true
#    index:
#      unique: true
#    default: "guest"
#  group:
#    type: "ObjectId"
#)

# User schema
UserSchema = new Schema(
  email:
    type: String
    unique: true
    # index:


  password:
    type: String
    required: true
    default: base64url(crypto.randomBytes 48)

  active:
    type: Boolean

    default: false
  name:
    type: String
    required: false
    default: 'user'
  surname:
    type: String
    required: false
    default: ''
  #groups: [UserGroupSchema]
  groups: # [guest, member, reviewer, admin]
    type: String
    enum: ["guest", "member", "reviewers", "admin"]
    default: "guest"

  loginAttempts:
    type: Number
    default: 0

  lockUntil:
    type: Number
    default: 0

  tokenString:
    type: String


  tokenExpires:
    type: Number


  provider:
    type: Array
    enum: ["facebook", "google", "yahoo", "local", "github", "persona", "linkedin", "twitter"]
    required: false

  awaitConfirm:
    type: Boolean
)

# expose enum on the model, and provide an internal convenience reference
# TODO: replace the error message with this enum, then show messages from views
UserSchema.statics.failedLogin =
  NOT_FOUND: 0
  PASSWORD_INCORRECT: 1
  MAX_ATTEMPTS: 2
  INACTIVE: 3
  TOKEN_UNMATCH: 4
  TOKEN_EXPIRES: 5

UserSchema.virtual("isLocked").get ->
  # check for a future lockUntil timestamp
  !!(@lockUntil and @lockUntil > Date.now())


# Bcrypt middleware
UserSchema.pre "save", (next) ->
  user = this

  # Reset changepassword token.
  user.resetToken (err) ->
    return next err if err

    # only hash the password if it has been modified (or is new)
    return next() unless user.isModified("password")

    # generate a salt
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      return next(err)  if err

      # hash the password along with our new salt
      bcrypt.hash user.password, salt, (err, hash) ->
        return next(err)  if err

        # override the cleartext password with the hashed one
        user.password = hash

        next()


UserSchema.methods.resetToken = (next) ->
  user = @
  crypto.randomBytes 48, (ex, buf) ->
    return next ex if ex
    user.tokenString = base64url buf
    user.tokenExpires = Date.now() + TOKEN_TIME
    next()

# Password verfication
UserSchema.methods.comparePassword = (userPassword, cb) ->
  bcrypt.compare userPassword, @password, (err, isMatch) ->
    return cb(err)  if err
    cb null, isMatch

UserSchema.methods.incLoginAttempts = (cb) ->

  #if we have a previous lock that has expired, restart at 1
  if @lockUntil and @lockUntil < Date.now()
    return @update(
      $set:
        loginAttempts: 1

      $unset:
        lockUntil: 1
    , cb)

  # otherwise were incrementing
  updates = $inc:
    loginAttempts: 1

  # lock the user if we've reached max attempts and it's not locked already
  updates.$set = lockUntil: Date.now() + LOCK_TIME  if @loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS and not @isLocked
  @update updates, cb

UserSchema.methods.resetLoginAttempts = (cb) ->

  #if we have a previous lock that has expired, restart at 1
  if @lockUntil and @lockUntil < Date.now()
    return @update(
      $set:
        loginAttempts: 0
    , cb)

  # reset login attempts to zero
  updates = $set:
    loginAttempts: 0

  @update updates, cb

# Static methods
# Register new user
UserSchema.statics.register = (user, cb) ->
  self = new this(user)
  self.awaitConfirm = true
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
    @findOne
      email: user.email
    , (err, existingUser) ->
      return cb(err)  if err
      return cb("user-exists")  if existingUser
      self.save (err) ->
        return cb(err) if err
        cb null, self

#UserSchema.statics.register = (email, cb) ->
#  console.log "======="
#  console.log email
#  console.log "======="
#  # check the validity of the input
#  #validator.check(user.first, messages.VALIDATE_FIRST_NAME).notEmpty()
#  #validator.check(user.last, messages.VALIDATE_LAST_NAME).notEmpty()
#  validator.check(email, messages.VALIDATE_EMAIL).isEmail()
#  #validator.check(user.password, messages.VALIDATE_PASSWORD).len 6, 128
#  errors = validator.getErrors()
#  console.log errors
  #if user.email
  #  validation.disposableEmail user.email.trim(), (err, disposable) ->
  #    errors.push messages.DISPOSABLE_EMAIL  if err or disposable
  #
  #if errors.length
  #  errorString = errors.join("<br>")
  #  return cb(errorString)
  #  logger.info "Registration form failed with " + errors
  #
  #  #go to the signup page
  #  return cb(errorString, null)
  #
  ## validate if an account for the email already exists
  #exports.findUserByEmail user.email, (err, existingUser) ->
  #  console.log user.email
  #  # if user exists validate if active or not and notify user
  #  if existingUser isnt null
  #    logger.info "registerUser - User:" + user.email + " already exists"
  #    if existingUser.active
  #
  #      #go to the login page
  #      cb messages.USER_REGISTERED_AND_ACTIVE, null
  #    else
  #
  #      #go to the resent activation link
  #      cb messages.USER_REGISTERED_NOT_ACTIVE, null
  #  else
  #
  #    # create a new user ready to save.
  #    newUser = new User()
  #    newUser.email = sanitize(user.email.toLowerCase().trim()).xss()
  #
  #    newUser.password = sanitize(user.password.trim()).xss()
  #    newUser.auth.activationKey = uuid()
  #
  #    # Save the new user and pass the cb.
  #    newUser.save (err) ->
  #      if err
  #        logger.error err
  #        return cb(messages.DATABASE_USER_NOT_SAVED, null)
  #      console.log "EMAIL newUser " + newUser.email
  #      ## email user
  #      #options =
  #      #  template: "validation"
  #      #  from: "Global Chapter Administration <gca@zmgc.net>"
  #      #  subject: "Email validation"
  #      #
  #      #data =
  #      #  email: newUser.email
  #      #  activationLink: config.domain + "/user/activate/" + newUser.auth.activationKey
  #      #
  #      #emailer.send options, data, (err, response) ->
  #      #
  #      #  #TODO: what should happen if this email fails???
  #      #  logger.error "activation mail failed with " + err  if err
  #      #
  #      #
  #      ## throw new Error(err);
  #      #
  #      ## do not wait for mail cb to proceed. Can take a few seconds
  #      cb null, newUser



# Activate new user
UserSchema.statics.activate = (token, cb) ->
  @findOne
    tokenString: token
    active: false
  , (err, existingUser) ->
    return cb(err)  if err
    if existingUser
      if existingUser.tokenExpires > Date.now() and existingUser.awaitConfirm
        existingUser.active = true
        delete existingUser.awaitConfirm
        existingUser.groups = "member"
        (existingUser.provider = existingUser.provider || []).push('local')
        existingUser.save (err, user)->
          unless err
            cb null, user
          else
            cb "save error"
      else
        cb "token-expired"
    else
      cb "token-expired-or-user-active"

module.exports = mongoose.model 'User', UserSchema

