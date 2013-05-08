"use strict"
# Connecting to database on mongodb
config = require "../config"
logger = require("./logger")
mongoose = require("mongoose")
mongoose.set "debug", true

logCategory = "Mongo Connection"

mongo = initialize: (callback) ->
  self = this
  logger.debug "Initializing Database Connection", LogCategory
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

  #mongoose.connect db_config, mongo_options, (err, res) ->
  #    if err
  #        console.log "ERROR connecting to: " + db_config + ". " + err
  #    else
  #        console.log "Successfully connected to: " + db_config
          
  mongoose.connect db_config, mongo_options
  db = self.db = mongoose.connection
  db.on "error", (error) ->
    logger.debug "ERROR XXX connecting to: ", logCategory
    console.log "ERROR connecting to: " + db_config + ". " + error
    callback error, null

  #db.on "connected", ->
  #  logger.info "Successfully XXX connected to: " + db_config, logCategory
  #  console.log "Successfully connected to: " + db_config
  #  callback true, db
  #
  #db.on "disconnected", ->
  #  logger.info "Disconnected XXX from the MongoDB database: " + db_config, logCategory
  #  console.log "Disconnected from the MongoDB database: " + db_config


exports = module.exports = mongo