passport = require "passport"
LocalStrategy = require("passport-local").Strategy
User = require "../models/user/user"
bcrypt = require "bcrypt"

console.log 'passport'

# serialize sessions
passport.serializeUser (user, done) ->
  console.log 'serialize user'
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
  usernameField: "email",
  passwordField: "password"
  , (email, password, done) ->
    console.log 'local strategy'
    User.findOne email: email, (err, user) ->
      unless err
        if user
          if user.active is true
            attempts = user.loginAttempts
            if ((5-attempts) > 1)
              remaining = "attemptsrem"
            else
              remaining = "attemptrem"
            if user.lockUntil < Date.now()
              user.comparePassword password, (err,isMatch)->
                unless err 
                  if isMatch
                    console.log("authorization success");
                    user.resetLoginAttempts (cb) ->
                      done(null,user, 
                        message: 'authorizationsuccess'
                        data: '.'
                        message2: 'welcome')
                  else
                    if user.loginAttempts < 5
                      console.log("passmatch");
                      user.incLoginAttempts (cb)->
                        done(null,false, 
                          message: 'invalidpass',
                          data: '. '+(5-attempts),
                          message2: remaining )
                    else
                      done(null,false, 
                        message: 'lockedafter',
                        data: attempts,
                        message2: 'wrongattempts')
                else
                  console.log("pass not match");
                  attempts = user.loginAttempts
                  if user.loginAttempts < 5
                    user.incLoginAttempts (cb)->
                      done(null,false, 
                        message: 'invalidpass',
                        data: '. '+(5-attempts),
                        message2: remaining )
            else
              console.log 'user is locked'
              date = new Date(user.lockUntil)
              done(err,false, 
                message: 'lockeduntil',
                data: ": "+date+".",
                message2:'tryagainlater')
          else
            console.log 'user is '+user.name
            done(err,false, 
              message: 'inactiveuser',
              data: ". ",
              message2:'requestlinkagain')
        else
          done(null, false, 
            message: 'inactiveuser',
            data: ". ",
            message2:'requestlinkagain')
      else
        console.log 'user find error'
        done(err,false, 
          message: 'authorizationfailed',
          data: '.',
          message2: 'tryagain')
)
