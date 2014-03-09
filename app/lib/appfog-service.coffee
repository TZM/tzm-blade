config = require "../config/index"
redis = require "redis"
mongoose = require("mongoose")
logger = require "../utils/logger"
logCategory = "Server config"


getAppFogCredentials = (service_type) ->
  json = JSON.parse(process.env.VCAP_SERVICES)
  json[service_type][0]["credentials"]

doOnce = (f, label) ->
  err = null
  result = null
  (callback) ->
    if err or result
      callback err, result
    else
      f (e, r) ->
      err = e
      result = r
      callback err, result

exports.redisConnect = (callback) ->
  if process.env.VCAP_SERVICES
    service_type = "redis-2.2"
    credentials = getCredentials(service_type)
    client = new redis.createClient(credentials["port"], credentials["host"])
    client.auth credentials["password"], (err) ->
      callback err, client

  else
    callback null, new redis.createClient(host: "localhost", port: 6379)

exports.redis = ->
  getConnection = doOnce(exports.redisConnect, "redis")
  (req, res, next) ->
    getConnection (err, connection) ->
      req.redis = connection
      next()

exports.mongoURL = ->
  # Connecting to dexies database on mongodb
  boundServices = if process.env.VCAP_SERVICES then JSON.parse(process.env.VCAP_SERVICES) else null
  unless boundServices
    if DB_USER and DB_PASS
      DB_URL = "mongodb://#{config.DB_USER}:#{config.DB_PASS}@#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"
    else
      DB_URL = "mongodb://#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"

  else
    service_type = "mongodb-1.8"
    credentials = getCredentials(service_type)
    DB_URL = "mongodb://" + credentials["username"] + ":" + credentials["password"] + "@" + credentials["hostname"] + ":" + credentials["port"] + "/" + credentials["db"]

#exports.mongoConnect = (callback) ->
#  self = this
#  mongo_options = db:
#    safe: true
#  db_url = exports.mongoURL
#  mongoose.connect db_url, mongo_options
#  db = self.db = mongoose.connection
#
#  db.on "error", (error) ->
#    logger.error "ERROR connecting to: " + db_url, logCategory
#    callback error, null
#
#  db.on "connect", ->
#    logger.info "SUCCESSFULLY connected to: " + db_url, logCategory
#    callback true, db_mongo
#
#  db.on "disconnect", ->
#    logger.info "DISCONNECTED from the database: " + db_url, logCategory
#
#exports.mongo = ->
#  getConnection = doOnce(exports.mongoConnect, "mongo")
