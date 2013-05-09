path = require("path")
fs = require("fs")
_ = require("underscore")
logger = require "./logger"
logCategory = "i18next"

Locales = initialize: (callback) ->
  logger.debug "Folder: "
  #self = this
  #localesDIR = '../../locales'
  #logger.debug "Folder: " + localesDIR
  #_.each localesDIR, (folder) ->
  #  logger.debug "Folder: " + logCategory

exports = module.exports = Locales