unless process.env.NODE_ENV?
	process.env.NODE_ENV = 'development'

cluster = require("cluster")
numCPUs = require("os").cpus().length
if cluster.isMaster 
  # Fork workers.
  i = 0

  while i < numCPUs
    cluster.fork()
    i++
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
else
	init = require("./index")()
	port = init.port
	server = init.listen(port)
	console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server.")
