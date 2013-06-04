User = require "../models/user/user"
sanitize = require("validator").sanitize
validator = require("../utils/validation").validator()
config = require("../config/config")
validation = require("../utils/validation")
messages = require "../utils/messages"
Emailer = require ("../utils/emailer")
passport = require("passport")

validationEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/

randomPassword = (length) ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz".split("")
    length = Math.floor(Math.random() * chars.length)  unless length
    str = ""
    i = 0

    while i < length
        str += chars[Math.floor(Math.random() * chars.length)]
        i++
    return str



# User model's CRUD controller.
Route = 

  # Lists all users
  index: (req, res) ->
    # FIXME set permissions to see this - only admins
    User.find {}, (err, users) ->
      res.send users



  _sendMail: (req, res, options, data) ->
    mailer = new Emailer(options, data);
    mailer.send (err,ok)->
      unless err
        res.statusCode = 201
        res.render "user/create", _csrf: req.session._csrf

        console.log ok    
      else
        res.send err
        res.statusCode = 500
        console.log err


  # Creates new user with data from `req.body`
  create: (req, res) ->
    # FIXME - have a better error page
    delete req.body.remember_me
    password = randomPassword(26)
    req.body.password = password if !req.body.password 
    req.body.email = req.body.email.trim()
    if validationEmail.test(req.body.email)
      # check if user email exists
      User.findOne { email:req.body.email }, (err,user) ->
        unless err
          if user
            console.log 'user found'

            # email user verification token
            options = 
              template: "reset"
              subject: "reseting your password"
              to: 
                name: ""
                surname: ""
                email: user.email

            if user.active is true
              action = '/user/resetpassword/'
            else
              action = '/user/activate/'
              options.template = "activation"
              options.subject = "account activation"
            
            if config.APP.hostname is 'localhost'
              data = 
                link: "http://"+config.APP.hostname+":"+config.PORT+action+user.tokenString
            else
              data = 
                link: config.APP.hostname+action+user.tokenString

            Route._sendMail(req, res, options, data);

          else
            User.register req.body, (err,user)->
              console.log(arguments);
              unless err
            # console.log('user not found create new one', user);
            # user.save (err, user) ->
            #   unless err
                # if user
                  # email user verification token
                options = 
                  template: "activation"
                  subject: "account activation"
                  to: 
                    name: ""
                    surname: ""
                    email: user.email

                console.log(options);
                
                if config.APP.hostname is 'localhost'
                  data = 
                    link: "http://"+config.APP.hostname+":"+config.PORT+"/user/activate/"+user.tokenString
                else
                  data = 
                    link: config.APP.hostname+"/user/activate/"+user.tokenString
                
                Route._sendMail(req, res, options, data);
                # else
                #   req.flash('info', 'user save error')
                #   res.statusCode = 400
                #   res.redirect('/')
              else
                req.flash('info', err.message)
                res.statusCode = 500
                res.redirect('/')
        else
          req.flash('info', err.message)
          res.statusCode = 500
          res.redirect('/')
          
    else
      res.statusCode = 400
      res.redirect('/')
      req.flash('info', 'please enter a valid email')
  # Routing middleware to call the user activation
  # Receives error or activated user
  # @param  {object}   req  Request.
  # @param  {object}   res  Response.
  # @param  {object}   next Middleware chain.
  # @return {mixed}         Error: Redirects to Login Screen - User active
  #                         Error: Redirects to resend activation - user inactive
  #                         Success: Falls through.
  


  activate: (req, res, next) ->
    console.log "activate"
    User.activate req.params.id, (err, user) ->
      console.log('end of activate');
      unless err
        console.log 'activate. user', user
        req.logIn user, (err) ->
          next(err)  if err
          req.flash('info', 'Activation success')
          res.redirect "user/resetpassword/"+req.params.id
      else if err is "token-expired-or-user-active"
        console.log "token-expired-or-user-active" 
        res.statusCode = 403
        req.flash('info', 'Your activation token has expired. Please request activation another time')
        res.render '/'


  # Gets user by id

  resetpassword: (req, res) ->
    console.log 'resetpass'
    if req.user?
      req.flash('info', 'Enter your new password')
      res.render "user/resetpassword"
        token: req.params.id
    else
      req.flash('info', 'Your activation token has expired. Please request activation another time')
      res.render '/'

  changepassword: (req, res) ->
    console.log 'changepassword'
    if req.body.password_new is req.body.password_confirm and req.body.password_new isnt ''
      User.findOne { tokenString: req.body.token },  (err, user) ->
        unless err
          console.log 2
          if user
            user.password = req.body.password_new
            console.log 3
            user.save (err) ->
              unless err
                req.logIn user, (err) ->
                  next(err)  if err
                  req.flash('info', 'Password changed')
                  res.redirect "/user/get"
                #res.render "user/user"
              else
                req.flash('info', err)
                res.redirect "/"
          else
            req.flash('info', 'Token has expired, please request link again')
            res.redirect "/"
        else
          console.log err
          res.render "/user/resetpassword"
            token: req.body.token      
    else
      res.render "/user/resetpassword"
        token: req.body.token      

  get: (req, res) ->
    if req.session.passport.user
      User.findById req.session.passport.user, (err, user) ->
        console.log(1,err,user);
        unless err
          console.log(2);
          res.render "user/user" 
            user: user
        else
          console.log(3);
          User.findOne tokenString: req.params.id, (err, user) ->
            console.log(3,err,user);
            unless err
              if user
                res.render "user/user",
                  user: user
              else
                req.flash('info', 'user not found')
                res.redirect '/'
            else
              req.flash('info', err)
              res.redirect '/'
    else
      req.flash('info', 'You are not logged in')
      res.redirect '/'
  # Updates user with data from `req.body`
  update: (req, res) ->
    if req.body
      console.log('update');
      console.log(req.user.id);
      User.findById req.user.id, (err, user) ->
        unless err
            if user
              console.log(1);
              if req.body.password_old >= 6
                user.comparePassword req.body.password_old, (err,isMatch)->
                  unless err
                    console.log(3);
                    if isMatch
                      console.log(4);
                      user.password = req.body.password_new is req.body.password_confirm
                      user.name = req.body.name if req.body.name
                      user.save (err) ->
                        req.flash('info', 'Profile saved')
                        res.redirect '/user/get'
                    else
                      console.log(5);
                      req.flash('info', 'Invalid old password')
                      res.redirect "/user/get"
                  else
                    console.log(6);
                    req.flash('info', 'Invalid old password')
                    res.redirect "/user/get"
              else if req.body.name isnt ''
                console.log(7);
                user.name = req.body.name
                user.save (err) ->
                  req.flash('info', 'Profile saved')
                  res.redirect 'user/get'
              else 
                req.flash('info', 'Nothing to save')
                res.redirect 'user/get'
        else
          console.log(8);
          req.flash('info', err)
          res.redirect '/'
    else
      console.log(9);
      req.flash('info', 'nothing to save')
      console.log(req.body.does not exists);

  # Deletes user by id
  delete: (req, res) ->
    User.findByIdAndRemove req.params.id, (err) ->
      if not err
        res.send {}
      else
        res.send err
        res.statusCode = 500
        
  login: (req, res, next) ->
    console.log 'authenticate'
    console.log(req.body)
    console.log('here');
    req.body.email = req.body.email.trim()
    if validationEmail.test(req.body.email)
      passport.authenticate("local", (err, user, info) ->
        console.log(arguments);
        unless err
          console.log('no err');
          if user
            console.log user
            req.logIn user, (err) ->
              unless err
                req.flash('info', 'Authentication success')
                res.redirect '/user/get'
          else
            console.log info
            console.log 'user not found'
            req.session.messages = info.message
            req.flash('info', info.message)
            res.redirect('/')
        else
          console.log 
          next(err)

      ) req, res, next
    else
      console.log('email is not valid');
      res.send
        message: 'please enter a valid email'
module.exports = Route