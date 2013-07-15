# Connecting to database on mongodb
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV

logger = require "./logger"
mongoose = require "mongoose"
mongoose.set "debug", config.DEBUG_LOG

logCategory = "DATABASE Connection"

if process.env.VCAP_SERVICES
  env = JSON.parse(process.env.VCAP_SERVICES)
  mongo = env["mongodb-1.8"][0]["credentials"]
else
  mongo =
    hostname: "localhost"
    port: 27017
    username: ""
    password: ""
    name: ""
    db: "zmgc-mongo"

generate_mongo_url = (obj) ->
  obj.hostname = (obj.hostname or "localhost")
  obj.port = (obj.port or 27017)
  obj.db = (obj.db or "zmgc-mongo")
  if obj.username and obj.password
    "mongodb://" + obj.username + ":" + obj.password + "@" + obj.hostname + ":" + obj.port + "/" + obj.db
  else
    "mongodb://" + obj.hostname + ":" + obj.port + "/" + obj.db

mongourl = generate_mongo_url(mongo)

#DB_URL = config.MONGO_DB_URL
console.log mongourl
DB_URL = config.MONGO_DB_URL

logger.info "MONGO DB URL: ", config.MONGO_DB_URL
db_connect_mongo = init: (callback) ->
  self = this
  mongo_options = db:
      safe: true
      #auto_reconnect: true
  mongoose.connect mongourl, mongo_options
  db = self.db_mongo = mongoose.connection

  db.on "error", (error) ->
    logger.error "ERROR connecting to: " + mongourl, logCategory
    callback error, null

  db.on "connected",  ->
    logger.info "SUCCESSFULLY connected to: " + mongourl, logCategory
    callback null, db

  db.on "disconnected", ->
    logger.info "DISCONNECTED from the database: " + mongourl, logCategory

# check and connect to Redis

exports = module.exports = db_connect_mongo
