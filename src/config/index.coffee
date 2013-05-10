#### Config file
# Sets application config parameters depending on `env` name
logger = require "../utils/logger"
logCategory = "Server config"
exports.setEnvironment = (env) ->
  logger.info "Set app environment: #{env}", logCategory

  exports.I18N =
    detectLngQS: "lang"
    ,ns: { namespaces: ['ns.common', 'ns.layout', 'ns.forms'], defaultNs: 'ns.common'}
    ,resSetPath: "./locales/__lng__/new.__ns__.json"
    ,ignoreRoutes: ["images/", "public/", "css/", "js/"]
    #,locales:['de', 'en', 'fr', 'pt']
    ,extension:".json"
    #,saveMissing: true
    #,sendMissingTo: 'all'
    ,debug: true

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

  exports.SMTP =
      GMAIL:
        id: process.env.SMTP_USER
        passwd: process.env.SMTP_PASSWD

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
      logger.info "Environment #{env} not found", logCategory