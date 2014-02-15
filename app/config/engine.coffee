urlParse = require('url').parse
User = require '../models/user/user'

io = null
app = null

handler = module.exports = new (require('events').EventEmitter)

handler.use = (_app) ->
  app = _app
  app.use (req, res, next) ->
    req.io = io
    next()

handler.attach = (server) ->
  console.log 'engine.io attached'

  io = require('engine.io').attach server
  io = require('engine.io-rooms')(io)
  io.room = room.bind @

  handler.emit 'ready', io

  sOpt = app.get 'sessionOptions'

  io.on 'connection', require('engine.io-session')
    cookieParser: require('express').cookieParser()
    store: sOpt.store
    key: sOpt.key
    secret: sOpt.secret

  io.on 'session', (socket, session) ->
    path = urlParse(socket.request.headers.referer).pathname
    socket.session = session

    handler.emit 'socket', socket

    if session.passport?.user
      User.findById session.passport.user, (err, user) ->
        return if err

        socket.user = user if !err and user

        # return if user?.groups isnt 'admin'

        socket.join path
        handler.emit 'join:'+path, socket

room = (name) ->
  a = @._adapter
  rooms = []
  rooms.push name if name

  return {
    broadcast: (data, opts) ->
      opts = opts || {}
      opts.rooms = opts.rooms || [name]
      a.broadcast data, opts
    clients: a.clients.bind a
  }