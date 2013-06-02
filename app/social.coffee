LocalStrategy = require('passport-local').Strategy
FacebookStrategy = require('passport-facebook').Strategy
TwitterStrategy = require('passport-twitter').Strategy
GoogleStrategy = require('passport-google').Strategy
User = require('./models/user').User
config = require "./config"

# Set up passport auth middleware
exports.setup = (passport) ->

  passport.serializeUser (user, done) ->
    console.log('social, serialize');
    done null, user.id

  passport.deserializeUser (id, done) ->
    console.log('social, deserialize');
    User.findById id, (err, user) ->
      done err, user

  # Local auth strategy
  # ----------------------------
  passport.use(new LocalStrategy
    usernameField: 'user[email]'
    passwordField: 'user[password]'
  , (email, password, done) ->
    User.findOne(email: email, (err, user) ->
      if err? then return done err
      if not user? or not user.validatePassword password
        return done null, false, message: 'Login failed'
      done null, user
    )
  )

  # Facebook auth strategy
  # ----------------------------
  passport.use(new FacebookStrategy
    clientID: config.SOCIAL.facebook.id
    clientSecret: config.SOCIAL.facebook.secret
    callbackURL: config.SOCIAL.facebook.callback
  , (accessToken, refreshToken, profile, done) ->
    process.nextTick ->
      User.findOneAndUpdate(
        'accounts.provider': profile.provider
        'accounts.uid': profile.id
      ,
        name: profile.displayName
        accounts: [
          provider: profile.provider
          accessToken: accessToken
          uid: profile.id
          displayName: profile.displayName
          name: profile.name
          emails: profile.emails
        ]
      ,
        upsert: true
      , (err, user) ->
        if err? then return done err
        done null, user
      )
  )

  # Twitter auth strategy
  # ----------------------------
  passport.use(new TwitterStrategy
    consumerKey: config.SOCIAL.twitter.consumerKey
    consumerSecret: config.SOCIAL.twitter.consumerSecret
    callbackURL: config.SOCIAL.twitter.callback
  , (token, tokenSecret, profile, done) ->
    User.findOneAndUpdate(
      'accounts.provider': profile.provider
      'accounts.uid': profile.id
    ,
      name: profile.displayName
      accounts: [
        provider: profile.provider
        accessToken: token
        uid: profile.id
        displayName: profile.displayName
        name: profile.name
        emails: profile.emails
      ]
    ,
      upsert: true
    , (err, user) ->
      if err? then return done err
      done null, user
    )
  )

  # Google auth strategy
  # ----------------------------
  passport.use(new GoogleStrategy
    returnURL: config.SOCIAL.google.returnURL
    realm: config.SOCIAL.google.realm
  , (identifier, profile, done) ->
    User.findOneAndUpdate(
      'accounts.provider': profile.provider
      'accounts.uid': profile.id
    ,
      name: profile.displayName
      accounts: [
        provider: profile.provider
        accessToken: identifier
        uid: profile.id
        displayName: profile.displayName
        name: profile.name
        emails: profile.emails
      ]
    ,
      upsert: true
    , (err, user) ->
      if err? then return done err
      done null, user
    )
  )
