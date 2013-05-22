# Just renders index.blade

exports.index = (req, res) ->
    tmpl = 
      "hello": ["world", "xxxx"]
    res.render "index", _tmpl: tmpl
    #res.send data