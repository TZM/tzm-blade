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

logger = require "./utils/logger"
logCategory = "APP config"

#  Create Server
app = express()

#Exports
module.exports = ->
  
  #  Load Environmental Settings
  #environments app
  
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
