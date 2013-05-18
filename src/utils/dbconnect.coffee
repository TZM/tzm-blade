
# Connecting to database on mongodb
logger = require("./logger")
mongoose = require("mongoose")
mongoose.set "debug", true

logCategory = "DATABASE Connection"
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


db_connect_mongo = init: (callback) ->
  self = this
  mongo_options = db:
      safe: true
  mongoose.connect DB_URL, mongo_options
  db = self.db_mongo = mongoose.connection

  db.on "error", (error) ->
    logger.error "ERROR connecting to: " + DB_URL, logCategory
    callback error, null

  db.on "connected", ->
    logger.info "SUCCESSFULLY connected to: " + DB_URL, logCategory
    callback true, db

  db.on "disconnected", ->
    logger.info "DISCONNECTED from the database: " + DB_URL, logCategory

# check and connect to Redis

exports = module.exports = db_connect_mongo