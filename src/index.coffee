#Load external dependencies
express = require "express"
stylus = require "stylus"
mongoose = require "mongoose"
i18next = require "i18next"

#Load local dependencies
models = require "./config/models"
i18n = require "./config/i18n"
config = require "./config/config"
routes = require "./config/routes"
environments = require "./config/environments"
#errors = require "./config/errors"
#hooks = require "./config/hooks"

#Load logger
logger = require "./utils/logger"
logCategory = "APP"

#Exports
module.exports = ->
  
  #  Create Server
  app = express()
  
  #  Load Environmental Settings
  environments app
  
  #  Load Mongoose Models
  models app
  
  # Load i18next config
  i18n app
  #  Load Expressjs config
  config app
  
  #  Load routes config
  routes app
  
  #  Load error routes + pages
  #errors app
  
  #  Load hooks
  #hooks app
  console.log app.i18n
  logger.info "App initialized", logCategory
  app