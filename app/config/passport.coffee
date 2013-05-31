passport = require "passport"
LocalStrategy = require("passport-local").Strategy
User = require "../models/user/user"
bcrypt = require "bcrypt"

console.log 'passport'

# serialize sessions
passport.serializeUser (user, done) ->
  console.log 'serialize user'
  if user.id
    done null, user.id  if user.id
  else
    console.log 'serialize user not found'

passport.deserializeUser (id, done) ->
  console.log 'deserialize'
  User.findOne _id: id, (err, user) ->
    unless err
      if user
        log.info logFrom, "success"
        done null, user.entity
      else
        log.warn logFrom, "user not found"
        done null, false
    else
      log.error logFrom, "error: ", err
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
          user.comparePassword password, (err,isMatch)->
            unless err 
              if isMatch
                return done(null,user, message: 'authorization success')
              else
                console.log 'password not match'
                return done(null,false, message: 'pass isns match')
            else
              console.log 'compare error'
              return done(err,false, message: 'comparing error')
        else
          console.log 'user not found'
          return done(null, false, message: "Unknown user")
      else
        console.log 'user find error'
        done(err,false, message: 'user.find error')
)
