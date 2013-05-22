#### Config file
# Sets application config parameters depending on `env` name

exports.setEnvironment = (env) ->
  db = require("./db")
  # General settings
  exports.SMTP =
    service: "Gmail"
    user: process.env.SMTP_USER
    pass: process.env.SMTP_PASSWD
  exports.EMAIL =
    registration: "gca-dev@zmgc.net"
    info: "info@zmgc.net"
  switch(env)
    when "development"
      exports.PORT = process.env.PORT or 3000
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.REDIS_DB = db.redis
      exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL
      exports.APP =
        name: "ZMGC Dev"
        hostname: "localhost"
        host: "127.0.0.1"

    when "test"
      exports.PORT = process.env.PORT or 3000
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.REDIS_DB = db.redis
      exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL

    when "production"
      exports.PORT = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT
      exports.DEBUG_LOG = false
      exports.DEBUG_WARN = false
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = false
      exports.REDIS_DB = db.redis
      exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL
      exports.APP =
        name: "ZMGC"
        hostname: "chapter.zmgc.net"
    else
      console.log "environment #{env} not found"

