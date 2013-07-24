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

redisService =  process.env.REDISTOGO_URL || process.env.REDISCLOUD_URL
if redisService
  try 
    redurl = url.parse(redisService)
  redisUrl = redurl
  redisAuth = redisUrl.auth.split(':')
 
# RIAK_DB_PORT = 10018

module.exports =
  mongo:
    if MONGO_DB_USER and MONGO_DB_PASS
        MONGO_DB_URL: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || "mongodb://#{MONGO_DB_USER}:#{MONGO_DB_PASS}@#{DB_HOST}:#{MONGO_DB_PORT}/#{MONGO_DB_NAME}"
    else
        MONGO_DB_URL: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || "mongodb://#{DB_HOST}:#{MONGO_DB_PORT}/#{MONGO_DB_NAME}"
  redis:
    # Redis settings
    if redisService?
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
    
  riak:
    cfRiak =
      host: RIAK_DB_HOST
      port: RIAK_DB_PORT
