app = require("./.app/")()
nowjs = require "now"
process.env.NODE_ENV = "local" unless process.env.NODE_ENV
port = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT or 3000
server = app.listen(port)
everyone = nowjs.initialize(server)
console.log "Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server."