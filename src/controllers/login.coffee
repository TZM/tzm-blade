# Just renders login.blade
exports.login = (req, res) ->
  console.log (_csrf: req.session._csrf)
  console.log req.body
  res.render "user/login", _csrf: req.session._csrf
exports.login = (req, res, next) ->
  console.log('LOGIN');
  if req.isAuthenticated()
   next()
  
  # login request with cookie
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
   
   #wipe out req.newUser
   newUser = req.newUser
   req.newUser = {}
   req.login newUser, (err) ->
     return res.redirect(routes.login.url)  if err
     if req.body.remember_me
       agent = useragent.parse(req.headers["user-agent"])
       
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
  
         res.redirect "login", _csrf: req.session._csrf
  
     else
       res.redirect "login", _csrf: req.session._csrf
  
  else
   next()
