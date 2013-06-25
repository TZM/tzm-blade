unless process.env.NODE_ENV?
  process.env.NODE_ENV = 'development'

# we want to run the test only once
if process.env.NODE_ENV is 'test'
  init = require("./index")()
  port = init.port
  server = init.listen(port)
  console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server. ")
else  
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
  	console.log("Server running at http://127.0.0.1: "+ port  + "\nPress CTRL-C to stop server. ")
  	
io = require("socket.io").listen(server)
async = require("async")
request = require("request")
fs = require("fs")

async.forever ((callback) ->
  official_chapter_list = 'https://api.trello.com/1/lists/51c19fb532a9eb417100309d?cards=open&fields=name&card_fields=desc&key=4e2912efa3fa9e7a92d0557055ca3aa2'
  request official_chapter_list, (error, response, body)->
    unless error
      newcontacts = {}
      chapter_cards = JSON.parse body
      cards = chapter_cards.cards
      #console.log cards
      for card in cards
        #console.log card
        obj = {}
        if card.desc isnt ''
          descriptions = card.desc.split '\n'
          for description in descriptions
            descvalue = description.split "**"
            if descvalue[1]?
              descvalue[1] = descvalue[1].substr(0, descvalue[1].length - 1)
              obj[descvalue[1]] = descvalue[2].replace(/^\s+|\s+$/g, "")
              card.desc = obj
          newcontacts[cards.indexOf(card)] = card
      console.log newcontacts
      io.sockets.on "connection", (socket) ->
        console.log 'socket connected'
        socket.emit "change",
          message: "changed"
          file: newcontacts

      fs.writeFile "./data/chapters.json", JSON.stringify(newcontacts,null,2),(err) ->
        console.log "It's saved!"
), (err) ->
  console.log err  if err

