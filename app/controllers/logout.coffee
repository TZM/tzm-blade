exports.logout = (req, res) ->
  console.log req
  if req.user
    if req.signedCookies.logintoken
      cookie = JSON.parse(req.signedCookies.logintoken)
      if not cookie.email or not cookie.series or not cookie.token
        req.logOut()
        res.redirect 'login'
      else
        LoginToken.remove
          email: cookie.email
          series: cookie.series
          token: cookie.token
        , (err, user) ->
          res.clearCookie "logintoken"
          req.logOut()
          res.redirect 'login'

    else
      req.logOut()
      res.redirect 'login'
  else
    res.redirect 'login'