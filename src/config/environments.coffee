logger = require "../utils/logger"
logCategory = "CONFIGURE: Environment"

#Exports
module.exports = (app) ->
  port = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT or 3000
  
  app.configure "local", ->

    @set("host", "localhost").set("port", port).set "ENV", "local"

  app.configure "production", ->

    @set("host", "chapter.zmgc.net").set("port", port).set "ENV", "production"
  
  app