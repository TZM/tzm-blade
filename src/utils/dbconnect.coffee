"use strict"
# Connecting to database on mongodb
config = require "../config/index"
logger = require("./logger")
mongoose = require("mongoose")
mongoose.set "debug", true

logCategory = "DATABASE Connection"

dbconnect = initialize: (callback) ->
  self = this
  mongo_options = db:
      safe: true

  boundServices = if process.env.VCAP_SERVICES then JSON.parse(process.env.VCAP_SERVICES) else null
  db_config = null
  unless boundServices
      if config.DB_USER and config.DB_PASS
          db_config = "mongodb://#{config.DB_USER}:#{config.DB_PASS}@#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"
      else
          db_config = "mongodb://#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"
  else
      credentials = boundServices["mongodb-1.8"][0]["credentials"]
      db_config = "mongodb://" + credentials["username"] + ":" + credentials["password"] + "@" + credentials["hostname"] + ":" + credentials["port"] + "/" + credentials["db"]

  mongoose.connect db_config, mongo_options
  db = self.db = mongoose.connection

  db.on "error", (error) ->
    logger.error "ERROR connecting to: " + db_config, logCategory
    callback error, null

  db.on "connected", ->
    logger.info "SUCCESSFULLY connected to: " + db_config, logCategory
    callback true, db

  db.on "disconnected", ->
    logger.info "DISCONNECTED from the database: " + db_config, logCategory

exports = module.exports = dbconnect