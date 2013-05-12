#### Config file
# Sets application config parameters depending on `env` name

logger = require "../utils/logger"
logCategory = "Server config"

DB_HOST = "localhost"
DB_PORT = "27017"
DB_NAME = "zmgc"
DB_URL = null
DB_USER = null
DB_PASS = null


# Connecting to dexies database on mongodb
boundServices = if process.env.VCAP_SERVICES then JSON.parse(process.env.VCAP_SERVICES) else null
unless boundServices
    if DB_USER and DB_PASS
        DB_URL = "mongodb://#{DB_USER}:#{DB_PASS}@#{DB_HOST}:#{DB_PORT}/#{DB_NAME}"
    else
        DB_URL = "mongodb://#{DB_HOST}:#{DB_PORT}/#{DB_NAME}"
else
    service_type = "mongodb-1.8"
    credentials = boundServices["mongodb-1.8"][0]["credentials"]
    DB_URL = "mongodb://" + credentials["username"] + ":" + credentials["password"] + "@" + credentials["hostname"] + ":" + credentials["port"] + "/" + credentials["db"]


#Set the current environment to true in the env object
exports.setEnvironment = (env) ->
  logger.info "Set app environment: #{env}", logCategory

  switch(env)
    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.DB_URL = DB_URL

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.DB_URL = DB_URL

    when "staging"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.DB_URL = DB_URL

    when "production"
      exports.DEBUG_LOG = false
      exports.DEBUG_WARN = false
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = false
      exports.DB_URL = DB_URL
    else
      logger.info "Environment #{env} not found", logCategory

# Exports

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
