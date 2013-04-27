request = require "request"

class Requester
  get: (path, callback) ->
    request "http://localhost:9080#{path}", callback

  post: (path, body, callback) ->
    request.post {url: "http://localhost:9080#{path}", body: body}, callback

exports.withServer = (callback) ->
  asyncSpecWait()

  {app} = require "../../lib/app.coffee"

  stopServer = ->
    app.close()
    asyncSpecDone()

  app.listen 3000

  callback new Requester, stopServer