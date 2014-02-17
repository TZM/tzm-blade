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
    ###
    return next() unless req.sessionID and io

    clients = io.room(req.sessionID).clients()

    return next() unless clients.length

    clients = clients.reduce (prev, curr) ->
      socket = io.clients[curr]

      prev.push socket if socket
      return prev
    , []

    req.ioSocket = clients[0]
    req.ioClients = clients

    console.log 'found', req.ioSocket.id if req.ioSocket

    next()
    ###

handler.attach = (server) ->
  console.log 'engine.io attached'

  io = require('engine.io').attach server
  io = require('engine.io-rooms')(io)
  io.room = room.bind io

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

    socket.sessionID = socket.request.cookies?[sOpt.key]?.split(/\W/)[1] if session
    console.log 'session', socket.sessionID

    handler.emit 'socket', socket

    console.log 'join', socket.sessionID if session and socket.sessionID
    socket.join socket.sessionID if session and socket.sessionID
    socket.join path

    handler.emit 'join:'+path, socket

    if session.passport?.user
      User.findById session.passport.user, (err, user) ->
        return if err

        socket.user = user if !err and user

        # return if user?.groups isnt 'admin'

room = (name) ->
  a = @.adapter()
  rooms = []
  rooms.push name if name

  return {
    broadcast: (data, opts) ->
      opts = opts || {}
      opts.rooms = opts.rooms || [name]
      a.broadcast data, opts
    clients: () ->
      a.clients name
  }