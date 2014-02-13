# Just renders calendar.blade

exports.calendar = (req, res) ->
    res.render "calendar"
      user: req.user