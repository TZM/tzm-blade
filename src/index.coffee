#Load external dependencies
express = require("express")
stylus = require("stylus")
mongoose = require("mongoose")
i18next = require "i18next"

#Load local dependencies
models = require("./config/models")
i18n = require("./config/i18n")
config = require("./config/config")
routes = require("./config/routes")

#Load database dependencies
dbconnection = require "./utils/dbconnect"

#Load logger
logger = require "./utils/logger"

# Initialize logger
logger.configure()
logCategory = "APP config"

logger.info "---- App server created ----", logCategory

#Exports
module.exports = ->
  #  Create Server
  app = express()
  
  #  Load Mongoose Models
  models app
  
  # Load i18next config
  i18n app
  # Init i18next
  i18next.init(app.i18n)
  i18next.registerAppHelper(app)
  #  Load Expressjs config
  config app
  
  #  Load routes config
  routes app
  
  app

logger.info "---- Modules loaded into namespace ----", logCategory
# Connect to database
dbconnection.init (result) ->
  if result
    logger.info "Database initialized", logCategory
