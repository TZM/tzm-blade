"use strict"
winston = require("winston")
_ = require("underscore")

# use the syslog levels:
#   debug
#   info
#   notice
#   warning
#   error
#   crit
#   alert
#   emerg
levels = winston.config.syslog.levels
wLogger = new (winston.Logger)(levels: levels)

# Configure the message logger.  Can be initted with no options (defaults to console/syslog in that case)
exports.configure = (options) ->
  options = {}  unless options
  level = "info"
  level = "debug"  if options.levelDebug
  
  #wLogger.level = level;
  messageLog = options.messageLog
  maxsize = options.messageLogMaxSize
  messageLog = "<consoleAndSyslog>"  if messageLog is `undefined`
  # for file transports
  maxsize = 10000000  if maxsize is `undefined`
  transports = []
  if messageLog is "<console>" or messageLog is "<consoleAndSyslog>"
    transports.push
      t: winston.transports.Console
      args:
        level: level
        json: false
        colorize: true

  else if process.platform is "linux" and (messageLog is "<syslog>" or messageLog is "<consoleAndSyslog>")
    
    # Would be nice to support this, but winston-syslog doesn't work for us now; node has dropped support
    # for unix dgram sockets, udp sockets require a bind to port 514 (root), and tcp sockets don't appear to work
    # with rsyslog (what we use).  So punting for now.
    console.log "syslog not supported"
  else
    
    # assume its a file
    transports.push
      t: winston.transports.File
      args:
        level: level
        filename: messageLog
        json: false
        colorize: false
        maxsize: maxsize
        prettyPrint: false
        timestamp: true

  
  # remove previous transports
  wLogger.clear()
  if transports.length > 0
    _.each transports, (params) ->
      wLogger.add params.t, params.args

  else
    console.log "Warning: No message log initialized"
  wLogger.exitOnError = false


# export the level functions
_.each levels, (i, k) ->
  exports[k] = (msg, meta, callback) ->
    logCat = "NoCategory"
    
    # prepend the category, if defined
    if typeof (meta) is "string"
      logCat = meta
      meta = `undefined`
    else if meta and meta.cat
      logCat = meta.cat
      delete meta.cat
    msg = "[" + logCat + "] " + msg
    wLogger[k].call wLogger, msg, meta, callback
