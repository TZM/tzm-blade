logger = require "../utils/logger"
logCategory = "CONFIGURE: Environment"
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


#Exports
module.exports = (app) ->
  port = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT or 3000
  
  app.configure "development", ->

    @set("host", "localhost")
    .set("port", port)
    .set("ENV", "local")
    .set(DEBUG_LOG = true)           
    .set(DEBUG_WARN = true)
    .set(DEBUG_ERROR = true)
    .set(DEBUG_CLIENT = true)
    .set(DB_URL = DB_URL)

  app.configure "production", ->

    @set("host", "chapter.zmgc.net").set("port", port).set "ENV", "production"
  
  app
  

#Set the current environment to true in the env object
#exports.setEnvironment = (env) ->
#  logger.info "Set app environment: #{env}", logCategory
#
#  switch(env)
#    when "development"
#      exports.DEBUG_LOG = true
#      exports.DEBUG_WARN = true
#      exports.DEBUG_ERROR = true
#      exports.DEBUG_CLIENT = true
#      exports.DB_URL = DB_URL
#
#    when "testing"
#      exports.DEBUG_LOG = true
#      exports.DEBUG_WARN = true
#      exports.DEBUG_ERROR = true
#      exports.DEBUG_CLIENT = true
#      exports.DB_URL = DB_URL
#
#    when "staging"
#      exports.DEBUG_LOG = true
#      exports.DEBUG_WARN = true
#      exports.DEBUG_ERROR = true
#      exports.DEBUG_CLIENT = true
#      exports.DB_URL = DB_URL
#
#    when "production"
#      exports.DEBUG_LOG = false
#      exports.DEBUG_WARN = false
#      exports.DEBUG_ERROR = true
#      exports.DEBUG_CLIENT = false
#      exports.DB_URL = DB_URL
#    else
#      logger.info "Environment #{env} not found", logCategory