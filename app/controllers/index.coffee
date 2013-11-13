# Just renders index.blade

exports.index = (req, res) ->
  res.render "index",
    clicks: 0
