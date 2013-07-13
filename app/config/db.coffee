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
      cfRedis =
        hostname: "localhost"
        host: "127.0.0.1"
        port: 6379
        name: "zmgc-redis"
        password: null
    else
      # Redis settings
      cfRedis: boundServices["redis-2.2"][0]["credentials"]
  riak:
    cfRiak =
      host: RIAK_DB_HOST
      port: RIAK_DB_PORT
