# Just renders guide.blade

exports.guide = (req, res) ->
  res.render "guide",
    user: req.user
