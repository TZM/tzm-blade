exports.captcha = (req, res, next) ->
  c = require "captchagen"
  captcha = c.generate()
  sess = req.session
  sess.captcha = captcha.text()
  res.type "image/png"
  res.end captcha.buffer()

