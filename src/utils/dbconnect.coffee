# Connecting to database on mongodb
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV

logger = require "./logger"
mongoose = require "mongoose" 
mongoose.set "debug", config.DEBUG_LOG

logCategory = "DATABASE Connection"

DB_URL = config.MONGO_DB_URL

db_connect_mongo = init: (callback) ->
  self = this
  mongo_options = db:
      safe: true
      #auto_reconnect: true
  mongoose.connect DB_URL, mongo_options
  db = self.db_mongo = mongoose.connection

  db.on "error", (error) ->
    logger.error "ERROR connecting to: " + DB_URL, logCategory
    callback error, null

  db.on "connected",  ->
    logger.info "SUCCESSFULLY connected to: " + DB_URL, logCategory
    callback null, db

  db.on "disconnected", ->
    logger.info "DISCONNECTED from the database: " + DB_URL, logCategory

# check and connect to Redis

exports = module.exports = db_connect_mongo