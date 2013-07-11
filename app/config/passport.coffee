passport = require "passport"
LocalStrategy = require("passport-local").Strategy
if process.env.FB_APP_ID? and  process.env.FB_APP_SEC?
  FacebookStrategy = require("passport-facebook").Strategy
if process.env.TT_APP_ID? and process.env.TT_APP_SEC?
  TwitterStrategy = require("passport-twitter").Strategy
GoogleStrategy = require("passport-google").Strategy
if process.env.GITHUB_ID? and process.env.GITHUB_SEC? 
  GitHubStrategy = require("passport-github").Strategy
if process.env.LI_APP_ID? and process.env.LI_APP_SEC?
  LinkedInStrategy = require("passport-linkedin").Strategy

YahooStrategy = require("passport-yahoo").Strategy
PersonaStrategy = require('passport-persona').Strategy

User = require "../models/user/user"
bcrypt = require "bcrypt"
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV

switch (process.env.NODE_ENV)
  when "development"
    url = "http://"+config.APP.hostname+":"+config.PORT
  when "production"
    url = "http://"+config.APP.hostname
  when "test"
    url = "http://"+config.APP.hostname+":"+config.PORT

console.log 'passport'

emails = []

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

console.log(url+"/social/facebookcallback")


#not sure about facebook
if process.env.FB_APP_ID? and  process.env.FB_APP_SEC?
  passport.use(new FacebookStrategy
    clientID: process.env.FB_APP_ID
    clientSecret: process.env.FB_APP_SEC
    callbackURL: url+"/social/facebookcallback"
    , (accessToken, refreshToken, profile, done) ->
      process.nextTick ->
        console.log("arguments in facebook strategy");
        console.log(arguments);
        User.findOne(
          'provider': profile.provider
          'uid': profile.id
        ,
          name: profile.displayName
          active: true
        , (err, user) ->
          if err? then return done err, null, 
            message: 'authorizationfailed',
            data: '.',
            message2: 'tryagain'
          unless user
            User.create(
              'provider': profile.provider
              'uid': profile.id
              'name': profile.displayName
              'active': true
            , (err,newUser)->
              if err? then return done err, null, 
                message: 'authorizationfailed',
                data: '.',
                message2: 'tryagain'
              done null, newUser,
                message: 'authorizationsuccess'
                data: '.'
                message2: 'welcome'
            )
          else
            done null, user,
              message: 'authorizationsuccess'
              data: '.'
              message2: 'welcome'
        )
    )
#use google strategy
#google returns email in array profile.emails[]
passport.use(new GoogleStrategy
  returnURL: url+"/social/googlecallback"
  realm: url
, (token, profile, done) ->
  console.log("arguments in google strategy");
  console.log(arguments);
  for mail in profile.emails
    emails.push mail.value
  User.findOne(
    "uid": {$in: emails}
    "provider": "google"
  , (err, user) ->
    if err? then return done err, null,
      message: 'authorizationfailed',
      data: '.',
      message2: 'tryagain'
    unless user
      User.create(
        "uid": emails[0]
        "provider": "google"
        "name": profile.name.givenName
        "surname": profile.name.familyName
        "active": true
      , (err,newUser)->
        if err? then return done err, null, 
          message: 'authorizationfailed',
          data: '.',
          message2: 'tryagain'
        done null, newUser,
          message: 'authorizationsuccess'
          data: '.'
          message2: 'welcome'
      )
    else
      done null, user,
        message: 'authorizationsuccess'
        data: '.'
        message2: 'welcome'
  )
)

#use twitter strategy
# Twitter doed not return user's email!
if process.env.TT_APP_ID? and process.env.TT_APP_SEC?
  passport.use(new TwitterStrategy
    consumerKey: process.env.TT_APP_ID
    consumerSecret: process.env.TT_APP_SEC
    callbackURL: url+"/social/twittercallback"
  , (token, tokenSecret, profile, done) ->
    console.log("arguments in twitter strategy");
    console.log(arguments);
    displayName = profile.displayName.split(" ")
    User.findOne(
      "uid": profile.id
      "provider": profile.provider
    , (err, user) ->
      if err? then return done err, null, 
        message: 'authorizationfailed',
        data: '.',
        message2: 'tryagain'
      unless user
        User.create(
          "uid": profile.id
          "provider": profile.provider
          "name": displayName[0]
          "surname": displayName[1]
          "active": true
        , (err,newUser)->
          if err? then return done err, null, 
            message: 'authorizationfailed',
            data: '.',
            message2: 'tryagain'
          done null, newUser,
            message: 'authorizationsuccess'
            data: '.'
            message2: 'welcome'
        )
      else
        done null, user,
          message: 'authorizationsuccess'
          data: '.'
          message2: 'welcome'
    )
  )
#use github strategy
#gitgub returs email in profile.emails[]
if process.env.GITHUB_ID? and process.env.GITHUB_SEC?   
  passport.use(new GitHubStrategy
    clientID: process.env.GITHUB_ID
    clientSecret: process.env.GITHUB_SEC
    callbackURL: url+"/social/githubcallback"
  , (accessToken, refreshToken, profile, done) ->
    console.log("arguments in github strategy");
    console.log(arguments);
    User.findOne(
      "uid": profile.id
      "provider": profile.provider
    , (err, user) ->
      console.log("user arguments at github strategy");
      console.log(arguments);
      if err? then return done err, null,
        message: 'authorizationfailed',
        data: '.',
        message2: 'tryagain'
      unless user
        Name = ''
        if profile.displayName?
          Name = profile.displayName
        else 
          Name = profile.username
        User.create(
          "uid": profile.id
          "provider": profile.provider
          "name": Name
          "surname": ""
          "active": true
        , (err,newUser)->

          if err? then return done err, null, 
            message: 'authorizationfailed',
            data: '.',
            message2: 'tryagain'
          done null, newUser,
            message: 'authorizationsuccess'
            data: '.'
            message2: 'welcome'
        )
      else
        done null, user,
          message: 'authorizationsuccess'
          data: '.'
          message2: 'welcome'
    )
  )

#linked-in does not returns email
if process.env.LI_APP_ID? and process.env.LI_APP_SEC?
  #use linked-in strategy
  passport.use(new LinkedInStrategy
    consumerKey: process.env.LI_APP_ID
    consumerSecret: process.env.LI_APP_SEC
    callbackURL: url+"/social/linkedincallback"
  , (accessToken, refreshToken, profile, done) ->
    console.log("arguments in linkedin strategy");
    console.log(arguments);
    User.findOne(
      "uid": profile.id
      "provider": profile.provider
    , (err, user) ->
      if err? then return done err, null,
        message: 'authorizationfailed',
        data: '.',
        message2: 'tryagain'
      unless user
        User.create(
          "uid": profile.id
          "provider": profile.provider
          "name": profile.name.givenName
          "surname": profile.name.familyName
          "active": true
        , (err,newUser)->
          if err? then return done err, null, 
            message: 'authorizationfailed',
            data: '.',
            message2: 'tryagain'
          done null, newUser,
            message: 'authorizationsuccess'
            data: '.'
            message2: 'welcome'
        )
      else
        done null, user,
          message: 'authorizationsuccess'
          data: '.'
          message2: 'welcome'
    )
  )


#use yahoo strategy
#Yahoo returns users emal
passport.use(new YahooStrategy
  returnURL: url+"/social/yahoocallback"
  realm: url
, (identifier, profile, done) ->
  for mail in profile.emails
    emails.push mail.value
  console.log("arguments in yahoo strategy");
  console.log(arguments);
  displayName = profile.displayName.split(" ")
  User.findOne(
    "uid": {$in: emails}
    "provider": "yahoo"
  , (err, user) ->
    if err? then return done err, null,
      message: 'authorizationfailed',
      data: '.',
      message2: 'tryagain'
    unless user
      User.create(
        "uid": emails[0]
        "provider": "yahoo"
        "name": displayName[0]
        "surname": displayName[1]
        "active": true
      , (err,newUser)->
        if err? then return done err, null, 
          message: 'authorizationfailed',
          data: '.',
          message2: 'tryagain'
        done null, newUser,
          message: 'authorizationsuccess'
          data: '.'
          message2: 'welcome'
      )
    else
      done null, user,
        message: 'authorizationsuccess'
        data: '.'
        message2: 'welcome'
  )
)


# use persona strategy
# Persona returns only email
passport.use(new PersonaStrategy
  audience: url
  , (email, done) ->
    # console.log("arguments in persona strategy");
    # console.log(arguments);
    process.nextTick ->
      User.findOne(
        'provider': "persona"
        'uid': email
      , (err, user) ->
        if err? then return done err, null, 
          message: 'authorizationfailed',
          data: '.',
          message2: 'tryagain'
        unless user
          User.create(
            "uid": email
            "provider": "persona"
            "name": email
            "active": true
          , (err,newUser)->
            if err? then return done err, null, 
              message: 'authorizationfailed',
              data: '.',
              message2: 'tryagain'
            done null, newUser,
              message: 'authorizationsuccess'
              data: '.'
              message2: 'welcome'
          )
        else
          done null, user,
            message: 'authorizationsuccess'
            data: '.'
            message2: 'welcome'
      )
  )


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
                      console.log("pass not match");
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



  # Twitter auth strategy
  # ----------------------------


# Google auth strategy
# ----------------------------
