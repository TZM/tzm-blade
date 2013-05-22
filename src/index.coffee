#Load external dependencies
express = require "express"
stylus = require "stylus"
mongoose = require "mongoose"
i18next = require "i18next"
#passport = require "passport"

#Load local dependencies
config = require "./config/config"
models = require "./config/models"
i18n = require "./config/i18n"
apps = require "./config/apps"
routes = require "./config/routes"

#Load and intitialize logger
logger = require "./utils/logger"
logger.configure()
logCategory = "APP config"

# Create server and set environment
app = express()
app.configure "production", "development", "test", ->
  config.setEnvironment app.settings.env
console.log app.settings.env
logger.info "--- App server created and local env set to: "+app.settings.env+" ---", logCategory

#Define Port
app.port = config.PORT
logger.info "--- Server running on port: "+app.port+" ---", logCategory

#Connect to database
dbconnection = require "./utils/dbconnect"
dbconnection.init (result) ->
  if result
    logger.info "Database initialized: " + result, logCategory

#Exports
module.exports = ->
  
  #  Load Mongoose Models
  models app
  
  # Load i18next config
  i18n app
  # Init i18next
  i18next.init(app.i18n)
  i18next.registerAppHelper(app)
  #  Load Expressjs config
  apps app
  
  #  Load routes config
  routes app
  
  app

logger.info "--- Modules loaded into namespace ---", logCategory
