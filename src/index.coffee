#Load dependencies
express = require("express")
stylus = require("stylus")
mongoose = require("mongoose")
i18next = require "i18next"

models = require("./config/models")
i18n = require("./config/i18n")
config = require("./config/config")
routes = require("./config/routes")
environments = require("./config/environments")
#errors = require("./errors")
#hooks = require("./hooks")
dbconnection = require "./utils/dbconnect"
logger = require "./utils/logger"
# Initialize logger
logger.configure()
logCategory = "APP config"

#  Create Server
app = express()
logger.info "---- App server created ----", logCategory
#Exports
module.exports = ->
  
  #  Load Environmental Settings
  environments app

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
  
  #  Load error routes + pages
  #errors app
  
  #  Load hooks
  #hooks app
  app

logger.info "---- Modules loaded into namespace ----", logCategory
console.log "---- ZZZZZ ----  "
# Connect to database
dbconnection.init (result) ->
  "use strict"
  if result
    logger.info "Database initialized", logCategory
  else
    logger.error "Database not initialized " + result + ". ", logCategory
    process.exit 1
