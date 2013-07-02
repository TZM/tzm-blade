
async = require("async")
request = require("request")
fs = require("fs")
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV
spawn = require("child_process").spawn




###
JSON parser
to save only cards only from official chapter list
###



get = (io)->
  

 
  async.forever ((callback) ->
    official_chapter_list = 'https://api.trello.com/1/lists/51c19fb532a9eb417100309d?cards=open&fields=name&card_fields=desc&key=4e2912efa3fa9e7a92d0557055ca3aa2'
    request official_chapter_list, (error, response, body)->
      unless error
        newcontacts = []
        # try to parse recieved list
        try
          chapter_cards = JSON.parse body
          cards = chapter_cards.cards
          # parsing string to JSON object
          for card in cards
            obj = {}
            if card.desc isnt ''
              descriptions = card.desc.split '\n'
              for description in descriptions
                descvalue = description.split "**"
                if descvalue[1]?
                  descvalue[1] = descvalue[1].substr(0, descvalue[1].length - 1)
                  obj[descvalue[1]] = descvalue[2].replace(/^\s+|\s+$/g, "")
                  card.desc = obj
              # if chpter LOCALES not specified it sets to "en-EN"
              if card.desc.LOCALES
                newcontacts.push card 
          # connect socket
          io.sockets.on "connection", (socket) ->
            console.log 'socket connected'
            socket.emit "change",
              message: "changed"
              file: newcontacts
          #try to read chapters.json
          try
            file = fs.readFileSync "./data/chapters.json"
            fs.readFile "./data/chapters.json", (err, oldcontacts)->
              if err
                console.log "./data/chapters.json does not exist"
                throw err
              else
                # check for update
                jsonString = JSON.stringify(newcontacts,null,2)
                oldjson = JSON.parse(oldcontacts)
                oldjsonString = JSON.stringify(oldjson,null,2)
                # console.log("Is new file equals old file?: ", jsonString is oldjsonString);
                if jsonString isnt oldjsonString
                  # console.log JSON.parse jsonString
                    # update json file
                    fs.writeFile "./data/chapters.json", jsonString, (err) ->
                      unless err
                        console.log "Official chapter list saved"
                        #pushing to github origin / master (branch)
                        #$git add data/chapters.json   first
                        #gitAdd = spawn("git", ["add", "data/chapters.json"])
                        #gitAdd.stdout.on "data", (data) ->
                        #  console.log "Git add stdout: " + data
                        #gitAdd.stderr.on "Git add dataerr", (data) ->
                        #  console.log "stderr: " + data
                        #gitAdd.on "close", (code) ->
                        #  console.log "file added" if code is 0
                        #  console.log "Something wrong with add: ",code if code isnt 0
                        #  #if added is done then $git commit -m "hapters.json update"
                        #  gitCommit = spawn("git", ["commit", "-m", "chapters.json update"]) 
                        #  gitCommit.stdout.on "data", (data) ->
                        #    console.log "Git commit stdout: " + data
                        #  gitCommit.stderr.on "dataerr", (data) ->
                        #    console.log "Git commit stderr: " + data
                        #  gitCommit.on "close", (code) ->
                        #    console.log "Commit success" if code is 0
                        #    console.log "Something wrong with commit: ", code if code isnt 0
                        #    #if commited then $git push origin master
                        #    gitPush = spawn("git", ["push", "origin", "master"])
                        #    gitPush.stdout.on "data", (data) ->
                        #      console.log "Git push stdout: " + data
                        #    gitPush.stderr.on "dataerr", (data) ->
                        #      console.log "Git push stderr: " + data
                        #    gitPush.on "close", (code) ->
                        #      console.log "Push success" if code is 0
                        #      console.log "Something wrong with push: ", code if code isnt 0
                      else
                        console.log "cannot writeFile: "+err
                else
                  console.log("nothing to to update");
          catch e
            fs.open "./data/chapters.json", "w", (err, fd) ->
              console.log("OPENING FILE ERROR: ",err)  if err
              unless err
                jsonString = JSON.stringify(newcontacts,null,2)
                fs.writeFile "./data/chapters.json", jsonString, (err)->
                  console.log("WRITING FILE ERROR: ",err)  if err
                  console.log("chapter.json created")  if !err         
        catch e
          console.log "Invalid JSON format error: ", e
          throw e          
  ), (err) ->
    console.log err  if err

getCards = (io)->
  setInterval(get, config.PARSE_INTERVAL, io)

exports = module.exports = getCards