# Just renders index.blade

exports.index = (req, res) ->
    tmpl = 
      "hello": ["world", "xxxx"]
    res.render "index" 
      _tmpl: tmpl
      user: req.user
    #res.send data