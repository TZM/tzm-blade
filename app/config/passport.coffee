passport = require "passport"
LocalStrategy = require("passport-local").Strategy
User = require "../models/user/user"
bcrypt = require "bcrypt"

console.log 'passport'

# serialize sessions
passport.serializeUser (user, done) ->
  console.log 'serialize user',user
  if user._id
    done null, user._id 
  else
    done 'no user'
    console.log 'serialize user not found'

passport.deserializeUser (id, done) ->
  console.log 'deserialize'
  User.findOne _id: id, (err, user) ->
    unless err
      if user
        console.log "success"
        done null, user
      else
        console.log "user not found"
        done null, false
    else
      console.log "error: ", err
      done err, false

# use local strategy
passport.use new LocalStrategy(
  usernameField: "email"
  passwordField: "password"
  , (email, password, done) ->
    console.log 'local stratagy'
    User.findOne email: email, (err, user) ->
      unless err
        if user
          unless user.lockUntil? and user.lockUntil < Date.now()
            user.comparePassword password, (err,isMatch)->
              unless err 
                if isMatch
                  user.resetLoginAttempts (cb) ->
                    done(null,user, message: 'authorization success')
                else
                  attempts = user.loginAttempts
                  if user.loginAttempts < 5
                    user.incLoginAttempts (cb)->
                      console.log 'password not match'
                      done(null,false, message: 'Invalid password. '+(5-attempts)+' Attempts remaining')
                  else
                    date = new Date(user.lockUntil)
                    done(null,false, message: 'Account is locked after 5 wrong attempts until '+date)
              else
                attempts = user.loginAttempts
                if user.loginAttempts < 5
                  user.incLoginAttempts (cb)->
                    console.log 'password not match'
                    done(null,false, message: 'Invalid password. '+(5-attempts)+' Attempts remaining')
          else
            console.log 'user is locked'
            date = new Date(user.lockUntil)
            console.log(date);
            done(err,false, message: 'Account is locked until: '+date)
        else
          console.log 'user not found'
          done(null, false, message: "Email or password invalid")
      else
        console.log 'user find error'
        done(err,false, message: 'Bad request')
)
