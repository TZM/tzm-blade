# Just renders index.blade

exports.index = (req, res) ->
	
    tmpl = 
      "hello": ["world", "xxxx"]
    console.log("server/index csrf: ", req.session._csrf);
    res.render "index",
      _tmpl: tmpl
      user: req.user
      port: 3001
      
    #res.send data