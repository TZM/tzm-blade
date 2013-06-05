unless process.env.NODE_ENV?
	process.env.NODE_ENV = 'development'

init = require("./index")()
port = init.port
server = init.listen(port)
console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server.")
