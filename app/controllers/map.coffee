# Just renders map.blade

exports.map = (req, res) ->
    res.render "map"
      user: req.user