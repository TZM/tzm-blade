"use strict"
mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
bcrypt = require("bcrypt")
account = mongoose.model("Account")
module.exports = (passport) ->
  
  # serialize sessions
  passport.serializeUser (account, done) ->
    done null, contributor.id

  passport.deserializeUser (id, done) ->
    Account.findOne
      _id: id
    , (err, contributor) ->
      done err, contributor

  # use a local strategy
  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    Account.getAuthenticated email, password, (err, account, reason) ->
      return done(err)  if err
      return done(null, account)  if account
      if reason is 2
        done null, false,
          message: "Account Locked Too Many Failed Attempts."

      else
        done null, false,
          message: "Invalid email or password."

  )