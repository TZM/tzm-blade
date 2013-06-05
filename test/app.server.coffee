app = require("../app/")()
should = require("should")
express = require("express")
request = require('../node_modules/request');
RedisStore = require("connect-redis")(express)
config = require("../app/config/config")
assert = require('../node_modules/assert');

if config.APP.hostname is 'localhost'
  Url = "http://"+config.APP.hostname+":"+config.PORT
else
  Url= config.APP.hostname

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

describe '/user/create', ->
  it 'login-pass match', (done)->
    user = 
      email: "testuser"
      password: "asdasd"
    console.log 'test create'
    req =
      url: Url+"/user/create"
      method: 'POST'
      body: 
        email: user.email
        password: user.password
        remember_me: "on"
      json: true  
    request req, (error, res, body) ->
      console.log(res.statusCode);
      done()