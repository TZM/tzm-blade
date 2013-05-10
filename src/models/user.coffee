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

# User schema
UserSchema = new Schema(
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
  # only hash the password if it has been modified (or is new)
  return next()  unless user.isModified("password")
  
  # generate a salt
  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    return next(err)  if err
    
    # hash the password along with our new salt
    bcrypt.hash user.password, salt, (err, hash) ->
      return next(err)  if err
      
      # override the cleartext password with the hashed one
      user.password = hash
      
      # update token
      crypto.randomBytes 32, (ex, buf) ->
        user.tokenString = buf.toString("hex")
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

# Static methods
# Register new user
UserSchema.statics.register = (user, cb) ->
  self = new this(user)
  @findOne
    email: user.email
  , (err, existingUser) ->
    return cb(err)  if err
    return cb("User already exists: " + user.email)  if existingUser
    self.save (err) ->
      return cb(err)  if err
      cb null, self

# Activate new user
UserSchema.statics.activate = (token, cb) ->
  @findOne
    tokenString: token
    active: false
  , (err, existingUser) ->
    return cb(err)  if err
    if existingUser
      if existingUser.tokenExpires > Date.now()
        existingUser.update
          $set:
            active: true
        , cb
      
      # return cb(null, existingUser);
      else
        cb "User token has expired."
    else
      cb "User token doesn't exist or is already active."

# Export user model
User = mongoose.model("User", UserSchema)
exports = module.exports = User

