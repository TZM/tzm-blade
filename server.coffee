app = require './.app'
nowjs = require 'now'
port = app.port
server = app.listen(port || 29080)
everyone = nowjs.initialize(server)
console.log 'Server running at http://127.0.0.1:'+ port + '/'