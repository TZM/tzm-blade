mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
bcrypt = require("bcrypt")
User = mongoose.model("User")
module.exports = (passport) ->
  
  # serialize sessions
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne
      _id: id
    , (err, user) ->
      done err, user

  # use a local strategy
  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    User.getAuthenticated email, password, (err, user, reason) ->
      return done(err)  if err
      return done(null, user)  if user
      if reason is 2
        done null, false,
          message: "User account locked too many failed attempts!"

      else
        done null, false,
          message: "Invalid email or password!"

  )