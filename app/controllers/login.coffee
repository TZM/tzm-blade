#Just renders login.blade
#exports.login = (req, res) ->
  #console.log (_csrf: req.csrfToken())
  #console.log 'REQ.BODY!!!!!!!!!!!!!!!!!',req.body
  #res.render "user/login", _csrf: req.csrfToken()
exports.login = (req, res, next) ->
  console.log('LOGIN');
  if req.isAuthenticated()
   next()
  
  # login request with cokie
  else if req.signedCookies.logintoken
   cookie = JSON.parse(req.signedCookies.logintoken)
   LoginToken.findOne
     email: cookie.email
     series: cookie.series
     token: cookie.token
   , (err, token) ->
     unless token
       LoginToken.remove
         email: cookie.email
         series: cookie.series
       , (err) ->
         
         # TODO: this means cookie has been compromised - warning?
         logger.error "cookie compromised " + cookie
         console.log "wipe cookie"
         res.clearCookie "logintoken"
         next()
  
     else
       User.findOne
         email: cookie.email
       , (err, user) ->
         if user
           
           #Login User
           req.login user, (err) ->
             
             #Update Token
             token.ip = req.ip
             
             #userAgent: useragent.parse(req.headers['user-agent'])
             token.save ->
               res.cookie "logintoken", token.cookieValue,
                 maxAge: 2 * 604800000
                 signed: true
                 httpOnly: true
  
               
               # locals have already been loaded so need to redirect
               next()
  
  
         else
           next()
  
  
  
  # coming from login or activation
  else if req.newUser
   console.log 'new user'
   #wipe out req.newUser
   newUser = req.newUser
   req.newUser = {}
   req.login newUser, (err) ->
     return res.redirect(routes.login.url)  if err
     if req.body.remember_me
       agent = useragent.parse(req.headers["user-agent"])
       console.log 'useragent'
       # TODO: add geo ip
       loginToken = new LoginToken(
         email: newUser.email
         ip: req.ip
         userAgent: agent
         series: uuid()
       )
       loginToken.save (err) ->
         res.cookie "logintoken", loginToken.cookieValue,
           maxAge: 2 * 604800000
           signed: true
           httpOnly: true
  
         res.redirect "login", _csrf: req.csrfToken()
  
     else
       console.log 'redirect login'
       res.redirect "login", _csrf: req.csrfToken()
  
  else
    console.log 'last next'
    next()
