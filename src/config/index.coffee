#### Config file
# Sets application config parameters depending on `env` name
exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"

  exports.SOCIAL =
    facebook:
      id: process.env.FACEBOOK_ID
      secret: process.env.FACEBOOK_SECRET
      callback: process.env.FACEBOOK_CALLBACK
    twitter:
      consumerKey: process.env.TWITTER_KEY
      consumerSecret: process.env.TWITTER_SECRET
      callback: process.env.TWITTER_CALLBACK
    google:
      returnURL: process.env.GOOGLE_RETURN_URL
      realm: process.env.GOOGLE_REALM

  switch(env)
    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.DB_HOST = 'localhost'
      exports.DB_PORT = "27017"
      exports.DB_NAME = 'zmgc'
      #exports.DB_USER = 'root'
      #exports.DB_PASS = 'root'

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true

    when "production"
      exports.DEBUG_LOG = false
      exports.DEBUG_WARN = false
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = false
    else
      console.log "environment #{env} not found"