app = require("../../app/")()
should = require("should")
express = require("express")
request = require('../../node_modules/request')
RedisStore = require("connect-redis")(express)
assert = require('assert')
config = require("../../app/config/config")
Imap = require("imap")
mailparser = require("mailparser")

if config.APP.hostname is 'localhost'
  Url = "http://"+config.APP.hostname+":"+config.PORT
else
  Url= config.APP.hostname

mailer =
  username: "zmgc.test@gmail.com"
  password: "b0ff25e16d22"

user = 
  email: "zmgc.test@gmail.com"
  password: "asdasdasd"

server = new Imap.ImapConnection(
  user: mailer.username
  password: mailer.password
  host: "imap.gmail.com",
  port: 993,
  secure: true
)
box = null
Token = ''
csrf_token = ""
actionLink = ""
parser = (cb)->  
  server.on "mail", (count) ->
    console.log("new mail count: ",count);
    if count isnt 0
      server.seq.fetch box.messages.total + ":*",
        struct: false
      ,
        body: true
        headers: false
        cb: (fetch) ->
          fetch.on "message", (msg) ->
            parser = new mailparser.MailParser
              showAttachmentLinks: true
            _text = ''

            msg.on "data", (data) ->
              parser.write data
              _text += data.toString()
            msg.on "end", ->
              parser.end()
              parser.on "end", (data)->
                index1 = _text.indexOf('/user/')
                __text = _text.substring(index1,_text.length)
                index2 = __text.indexOf('>')
                link = __text.substring(0,index2)
                console.log(link.toString());
                a1 = link.split('/')
                a1length = a1.length
                str = a1[a1length-1]
                token = str
                # __params = link.substring(str.length, linklength)
                Token = token
                actionLink = link
                console.log("token: "+ token);
                console.log('0');
                server.addFlags msg.uid, 'deleted', (err) ->
                  console.log('1');
                  unless err
                    console.log('add flags ok');
                    cb null, link, token
                  else
                    console.log("marking messages as deleted error: ", err);
                  server.closeBox (err)->
                    server.logout()
              console.log "Finished message no. " + msg.seqno
          
          fetch.on "end", ->
           console.log("fetch end"); 
            

        , (err) ->
          cb err if err

          console.log "Done fetching all messages!"
          
    else
      setTimeout(parser, 1000)

before (done)->
  this.timeout(10000)
  server.connect (err) ->
    console.log('connect err:',err) if err     
    server.openBox "INBOX", false, (err,_box) ->
      console.log('0box',_box);
      box = _box
      console.log('openbox err:',err) if err
      console.log "You have #{box.messages.total} messages in your INBOX"
      server.on 'error',(err)->
        console.log(err);
      done()

describe "app", ->
  it "should expose app settings", (done) ->
    obj = app.settings
    obj.should.have.property "env", "test"
    done()

describe "sessions", ->
  store = new RedisStore
  sessionData =
    cookie:
      maxAge: 2000
    name: "tj"
  # TODO: Find out why this before statement times out
  # Is there a risk that the store will not be instantiated when the tests run
  # before (done) ->
  #   store.client.on "connect", ->
  #     done()

  it "should be able to store sessions", (done) ->
    store.set "123", sessionData, (err, ok) ->
      should.not.exist err
      should.exist ok
      done()

  it "should be able to retrieve sessions", (done) ->
    store.get "123", (err, data) ->
      should.not.exist err
      
      # console.log data
      data.should.be.a("object").and.have.property "name", sessionData.name
      data.cookie.should.be.a("object").and.have.property "maxAge", sessionData.cookie.maxAge
      done()

  after (done) ->
    store.set "123", sessionData, ->
      store.destroy "123", ->
        store.client.end()
        done()

describe '/index', ->
  it 'get index page', (done) ->
    req = 
      uri: Url+"/index"
      method: 'GET'
    request req, (err,res) ->
      _text = ""
      _text += res.body.toString()
      index1 = _text.indexOf("_csrf")
      __text = _text.substring(index1,_text.length)
      index2 = __text.indexOf('"/>')
      csrf = __text.substring(1,index2)
      ind1 = csrf.indexOf('value="')
      ind2 = ind1+1
      _token = csrf.substring(ind2,csrf.length)
      a1 = _token.split('="')
      a1length = a1.length
      token = a1[a1length-1]
      
      csrf_token = token
      
      
      console.log(csrf_token);
      done()

describe '/user/create', ->
  it 'create test user', (done)->
    this.timeout(50000);
    req =
      uri: Url+"/user/create"
      method: 'POST'
      body: 
        _csrf: csrf_token
        email: user.email
        password: user.password
        remember_me: "on"
      json: true
      session:
        _csrf: csrf_token
    request req, (err, res, body) ->
      console.log(res.statusCode);

      assert res.statusCode isnt 403 or 400, res.statusCode
      done()

describe '/user/activate or reset password', ->
  it 'parsing email and activating user', (done)->
    this.timeout(900000);
    setTimeout(done, 90000)
    parser (err,link,token)->
      Token = token
      console.log("error: ", err) if err
      if link
        req =
          url: Url+link
          method: 'GET'
          params: 
            id: Token
        request req, (err, res, body) ->
          _text = ""
          _text += res.body.toString()
          index1 = _text.indexOf("_csrf")
          __text = _text.substring(index1,_text.length)
          index2 = __text.indexOf('"/>')
          csrf = __text.substring(1,index2)
          ind1 = csrf.indexOf('value="')
          ind2 = ind1+1
          _token = csrf.substring(ind2,csrf.length)
          a1 = _token.split('="')
          a1length = a1.length
          token = a1[a1length-1]
          
          csrf_token = token
          
          
          console.log(csrf_token);

          console.log("requested uri: "+req.url);
          console.log(res.statusCode);
          assert res.statusCode is 200, res.statusCode
          done()
      else
        console.log("error: ",err);

describe '/user/resetpassword', ->
  it 'user resetting password', (done)->
    req =
      uri: Url+"/user/resetpassword/"+Token
      method: 'POST'
      body:
        _csrf: csrf_token 
        password_new: user.password
        password_confirm: user.password
      json: true
      params:
        id: Token
      session:
        _csrf: csrf_token
    request req, (error, res) ->
      console.log("error: ", error);
      console.log("statuscode: ", res.statusCode);
      assert res.statusCode is 200 or 302, res.statusCode
      done()


describe '/user/changepassword', ->
  it 'user resetting password', (done)->
    
    req =
      uri: Url+"/user/changepassword"
      method: 'POST'
      body: 
        _csrf: csrf_token
        password_new: user.password
        password_confirm: user.password
      json: true
      params:
        id: Token
      session:
        _csrf: csrf_token
    request req, (error, res) ->
      console.log("error: ", error);
      console.log("statuscode: ", res.statusCode);
      assert res.statusCode is 200 or 302, res.statusCode
      done()

describe '/user/login', ->
  it 'success login', (done)->
    req =
      uri: Url+"/user/login"
      method: 'POST'
      body: 
        _csrf: csrf_token
        email: user.email
        password: user.password
        remember_me: "on"
      json: true
      session:
        _csrf: csrf_token
    request req, (error, res, body) ->
      console.log("ok") if !error
      console.log("error") if error
      assert res.statusCode isnt 403, res.statusCode
      done()

describe '/user/get', ->
  it 'get user', (done)->
    req =
      uri: Url+"/user/get"
      method: 'GET'
      json: true
    request req, (error, res) ->
      assert res.statusCode is 200, res.statusCode
      done()

describe '/user/delete', ->
  it 'delete user', (done)->
    req =
      uri: Url+"/user/delete"
      method: 'GET'
      json: true
    request req, (error, res) ->
      console.log(res.statusCode);
      assert res.statusCode is 400, res.statusCode
      done()