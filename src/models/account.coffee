# 
# User model
# Ideas from http://blog.mongodb.org/post/32866457221/password-authentication-with-mongoose-part-1
# and http://devsmash.com/blog/implementing-max-login-attempts-with-mongoose
# 

mongoose = require "mongoose"
bcrypt = require "bcrypt"
crypto = require "crypto"
SALT_WORK_FACTOR = 10
# default to a max of 5 attempts, result in a 2 hour lock
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 2 * 60 * 60 * 1000
# token alive time is 24 hours
TOKEN_TIME = 24 * 60 * 60 * 1000

exports.mongoose = mongoose

# Database schema
Schema = mongoose.Schema

# Account schema
accountSchema = new Schema(
  email:
    type: String
    required: true
    index:
      unique: true

  password:
    type: String
    required: true

  active:
    type: Boolean
    require: true
    default: false

  groups: # [guest, member, reviewer, admin]
    type: String
    enum: ["guest", "member", "reviewers", "admin"]
    default: "guest"
  
  loginAttempts:
    type: Number
    required: true
    default: 0

  lockUntil:
    type: Number

  tokenString:
    type: String

  tokenExpires:
    type: Number
)

# expose enum on the model, and provide an internal convenience reference
# TODO: replace the error message with this enum, then show messages from views
accountSchema.statics.failedLogin =
  NOT_FOUND: 0
  PASSWORD_INCORRECT: 1
  MAX_ATTEMPTS: 2
  INACTIVE: 3
  TOKEN_UNMATCH: 4
  TOKEN_EXPIRES: 5

accountSchema.virtual("isLocked").get ->
  # check for a future lockUntil timestamp
  !!(@lockUntil and @lockUntil > Date.now())


# Bcrypt middleware
accountSchema.pre "save", (next) ->
  user = this
  # only hash the password if it has been modified (or is new)
  return next()  unless account.isModified("password")
  
  # generate a salt
  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    return next(err)  if err
    
    # hash the password along with our new salt
    bcrypt.hash account.password, salt, (err, hash) ->
      return next(err)  if err
      
      # override the cleartext password with the hashed one
      account.password = hash
      
      # update token
      crypto.randomBytes 32, (ex, buf) ->
        account.tokenString = buf.toString("hex")
        account.tokenExpires = Date.now() + TOKEN_TIME
        next()

# Password verfication
accountSchema.methods.comparePassword = (accountPassword, cb) ->
  bcrypt.compare accountPassword, @password, (err, isMatch) ->
    return cb(err)  if err
    cb null, isMatch

accountSchema.methods.incLoginAttempts = (cb) ->
  
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

  # lock the account if we've reached max attempts and it's not locked already
  updates.$set = lockUntil: Date.now() + LOCK_TIME  if @loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS and not @isLocked
  @update updates, cb

# Static methods
# Register new account
accountSchema.statics.register = (user, cb) ->
  self = new this(account)
  @findOne
    email: user.email
  , (err, existingAccount) ->
    return cb(err)  if err
    return cb("Account already exists: " + account.email)  if existingUser
    self.save (err) ->
      return cb(err)  if err
      cb null, self

# Activate new account
accountSchema.statics.activate = (token, cb) ->
  @findOne
    tokenString: token
    active: false
  , (err, existingAccount) ->
    return cb(err)  if err
    if existingAccount
      if existingAccount.tokenExpires > Date.now()
        existingAccount.update
          $set:
            active: true
        , cb
      
      # return cb(null, existingUser);
      else
        cb "Account token has expired."
    else
      cb "Account token doesn't exist or is already active."

# Export user model
Account = mongoose.model("Account", accountSchema)
exports = module.exports = Account

