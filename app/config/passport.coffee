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
