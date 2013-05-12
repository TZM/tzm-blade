
# Connecting to database on mongodb
config = require "../config/index"
logger = require("./logger")
mongoose = require("mongoose")
mongoose.set "debug", true

logCategory = "DATABASE Connection"

db_connect_mongo = init: (callback) ->
  self = this
  mongo_options = db:
      safe: true
  db_url = config.DB_URL
  mongoose.connect db_url, mongo_options
  db = self.db_mongo = mongoose.connection

  db.on "error", (error) ->
    logger.error "ERROR connecting to: " + db_url, logCategory
    callback error, null

  db.on "connected", ->
    logger.info "SUCCESSFULLY connected to: " + db_url, logCategory
    callback true, db

  db.on "disconnected", ->
    logger.info "DISCONNECTED from the database: " + db_url, logCategory

# check and connect to Redis

exports = module.exports = db_connect_mongo