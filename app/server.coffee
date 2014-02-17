getCards = require "./utils/getcards"
config = require "./config/config"
http = require 'http'
engine = require './config/engine'


unless process.env.NODE_ENV?
  process.env.NODE_ENV = 'development'

# we want to run the test only once
if process.env.NODE_ENV is 'test'
  init = require("./index")()
  port = init.port
  server = init.listen(port)
  engine.attach server

  console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server. ")
else  
  config.setEnvironment process.env.NODE_ENV
  cluster = require("cluster")
  numCPUs = require("os").cpus().length
  
  if cluster.isMaster 
    # Fork workers.
    i = 0
  
    while i < numCPUs
      console.log("NOW USING CPU: #",i);
      if i is 0
        # console.log("socket io using port: ",config.PORT+1)
        # io = ioModule.listen(parseInt(config.PORT+1), {log:false})
        # getCards io
        getCards()
      cluster.fork()
      i++
    cluster.on "exit", (worker, code, signal) ->
      console.log "worker " + worker.process.pid + " died"
  else
    
    init = require("./index")()
    port = init.port
    server = init.listen(port)
    engine.attach server
    console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server. ")


