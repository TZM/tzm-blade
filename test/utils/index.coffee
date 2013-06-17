app = require("../../app/")()
express = require("express")
RedisStore = require("connect-redis")(express)
should = require("should")

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