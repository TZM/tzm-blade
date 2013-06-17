config = require("../../app/config/config")
request = require("../../node_modules/request")

if config.APP.hostname is 'localhost'
  Url = "http://"+config.APP.hostname+":"+config.PORT
else
  Url= config.APP.hostname

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