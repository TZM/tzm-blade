#### Config file
# Sets application config parameters depending on `env` name
db = require "./db"
i18next = require "./i18n"
exports.setEnvironment = (env) ->
    # General settings
    exports.SMTP =
        service: "Gmail"
        user: process.env.SMTP_USER
        pass: process.env.SMTP_PASSWD

    exports.EMAIL =
        registration: "gca-dev@zmgc.net"
        info: "info@zmgc.net"
  
    exports.PARSE_INTERVAL = 20000
    switch(env)
        when "development"
            exports.PORT = process.env.PORT or 3000
            exports.APP =
                name: "ZMGC Dev"
                hostname: process.env.HOSTNAME || "localhost"
                host: "127.0.0.1"
            exports.DEBUG_LOG = true
            exports.DEBUG_WARN = true
            exports.DEBUG_ERROR = true
            exports.DEBUG_CLIENT = true
            exports.REDIS_DB = db.redis
            exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL
            exports.RIAK_DB = db.riak
            i18next.debug = true
            exports.I18N = i18next
        when "test"
            exports.PORT = process.env.PORT or 3000
            exports.APP =
                name: "ZMGC Test"
                hostname: process.env.HOSTNAME || "localhost"
                host: "127.0.0.1"
            exports.DEBUG_LOG = false
            exports.DEBUG_WARN = false
            exports.DEBUG_ERROR = true
            exports.DEBUG_CLIENT = true
            exports.REDIS_DB = db.redis
            exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL
            exports.RIAK_DB = db.riak
            exports.I18N = i18next
        when "production"
            exports.PORT = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT
            exports.APP =
                name: "ZMGC"
                hostname: process.env.HOSTNAME || "chapter.zmgc.net"
            exports.DEBUG_LOG = false
            exports.DEBUG_WARN = false
            exports.DEBUG_ERROR = true
            exports.DEBUG_CLIENT = false
            exports.REDIS_DB = db.redis
            exports.MONGO_DB_URL = db.mongo.MONGO_DB_URL
            exports.RIAK_DB = db.riak
            exports.I18N = i18next
        else
            console.log "environment #{env} not found"

