User = require "../models/user/user"
sanitize = require("validator").sanitize
validator = require("../utils/validation").validator()
config = require("../config/config")
validation = require("../utils/validation")
messages = require "../utils/messages"
Emailer = require ("../utils/emailer")
passport = require("passport")

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
    password = randomPassword(6)
    req.body.password = password
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
          user = new User req.body

          console.log('user not found create new one', user);

          user.save (err, user) ->
            unless err
              if user
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

              else
                res.send 'user create error'
                res.statusCode = 500
            else
              res.send err
              res.statusCode = 500
      else
        res.send err
        res.statusCode = 500

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
          req.flash('info', 'authentication success')
          
          res.redirect "user/resetpassword/"+req.params.id
      else if err is "token-expired-or-user-active"
        console.log "token-expired-or-user-active" 
        res.send "your activation token has expired. Please request activation another time"


  

  # Gets user by id

  resetpassword: (req, res) ->
    console.log 'resetpass'
    console.log(req.session);
    console.log(req.user);
    res.render "user/login"
      token: req.params.id


  changepassword: (req, res) ->
    console.log 'changepassword'
    if req.body.password? and req.body.password is req.body.password_confirm
      User.findOne { tokenString:req.body.token },  (err, user) ->
        unless err
          console.log 2
          if user
            user.password = req.body.password
            console.log 3
            user.save (err) ->
              unless err
                console.log('user after save:', user);
                res.redirect "user/get/"+user.tokenString
                #res.render "user/user"
              else
                res.statusCode = 500
                res.send "user save error"
          else
            res.render "user/login"
              token: req.body.token      
        else
          console.log err
          res.render "/user/login"
            token: req.body.token      
    else
      res.render "/user/login"
        token: req.body.token      

  get: (req, res) ->
    console.log req.params
    console.log 'get'
    console.log 'get2'
    console.log req.params.id
    console.log(1);
    User.findById req.params.id, (err, user) ->
      console.log(1,err,user);
      if not err
        console.log(2);
        res.render "user/user"
          user: user
            
      else
        console.log(3);
        User.findOne tokenString: req.params.id, (err, user) ->
          console.log(3,err,user);
          unless err
            if user
              res.render "user/user"
                user: user
            else
              console.log(user);
              res.statusCode = 400
              res.send user
          else
            res.statusCode = 500
            res.send err

  # Updates user with data from `req.body`
  update: (req, res) ->

    console.log('update');

    User.update { _id:req.user.id }, {"$set":req.body}, (err, user) ->
      if not err
        req.flash('info', 'data saved')
        res.redirect "/"
      else
        res.send err
        res.statusCode = 500
    
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
    console.log('here');
    passport.authenticate("local", (err, user, info) ->
      console.log(arguments);
      unless err
        'no err'
        if user
          console.log user
          req.logIn user, (err) ->
            next(err)  if err
            req.flash('info', 'authentication success')
            res.redirect "/"
        else
          console.log info
          console.log 'user not found'
          req.session.messages = [info.message]
          return res.redirect("index")
      else
        console.log 
        next(err)


    ) req, res, next

module.exports = Route