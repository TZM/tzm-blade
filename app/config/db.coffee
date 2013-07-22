url = require('url')

boundServices = if process.env.VCAP_SERVICES then JSON.parse(process.env.VCAP_SERVICES) else null
console.log boundServices
DB_HOSTNAME = "localhost"
DB_HOST = "127.0.0.1"
MONGO_DB_PORT = 27017
MONGO_DB_NAME = "zmgc-mongo"
MONGO_DB_URL = null
MONGO_DB_USER = null
MONGO_DB_PASS = null
# MongoDB settings
RIAK_DB_HOST = "127.0.0.1"
RIAK_DB_PORT = 8098
if process.env.REDISTOGO_URL
  try 
    redurl = url.parse(process.env.REDISTOGO_URL)
  catch e
    redurl = url.parse("redis://redistogo:5cc5cc379727f8913be12722de841452@beardfish.redistogo.com:9858/")

  redisUrl = redurl
  redisAuth = redisUrl.auth.split(':')
 
# RIAK_DB_PORT = 10018

module.exports =
  mongo:
    unless boundServices
      if MONGO_DB_USER and MONGO_DB_PASS
          MONGO_DB_URL: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || "mongodb://#{MONGO_DB_USER}:#{MONGO_DB_PASS}@#{DB_HOST}:#{MONGO_DB_PORT}/#{MONGO_DB_NAME}"
      else
          MONGO_DB_URL: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || "mongodb://#{DB_HOST}:#{MONGO_DB_PORT}/#{MONGO_DB_NAME}"
    else
      # MongoDB settings
      cfMongo = boundServices["mongodb-1.8"][0]["credentials"]
      MONGO_DB_URL: "mongodb://" + cfMongo["username"] + ":" + cfMongo["password"] + "@" + cfMongo["hostname"] + ":" + cfMongo["port"] + "/" + cfMongo["db"]
  redis:
    unless boundServices
      # Redis settings
      if process.env.REDISTOGO_URL?
        cfRedis = 
          hostname: redisUrl.hostname
          port: redisUrl.port
          name: redisAuth[0]
          password: redisAuth[1]  
          maxAge: 86400000 * 30
      else
        cfRedis =
          hostname: "localhost"
          host: "127.0.0.1"
          port: 6379
          name: "zmgc-redis"
          password: null
          maxAge: 86400000 * 30
    else
      # Redis settings
      cfRedis: boundServices["redis-2.2"][0]["credentials"]
  riak:
    cfRiak =
      host: RIAK_DB_HOST
      port: RIAK_DB_PORT
