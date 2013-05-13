#Load dependencies
express = require("express")
stylus = require("stylus")
mongoose = require("mongoose")

models = require("./models")
i18n = require("./i18n")
config = require("./config")
routes = require("./routes")
environments = require("./environments")
#errors = require("./errors")
#hooks = require("./hooks")

logger = require "../utils/logger"
logCategory = "APP config"

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