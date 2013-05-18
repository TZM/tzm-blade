require("coffee-script")
app = require("./.app/")()
nowjs = require("now")
port = app.port
server = app.listen(port)
everyone = nowjs.initialize(server)
console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server.")