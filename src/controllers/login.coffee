# Just renders login.blade

exports.login = (req, res) ->
  console.log (_csrf: req.session._csrf)
  res.render "user/login", _csrf: req.session._csrf