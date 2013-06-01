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
    # console.log('mailer', options, data);
    mailer = new Emailer(options, data);
    # console.log 'data!!!!!!!!!!!!!!!!', data
    mailer.send (err,ok)->
      unless err
        # console.log "EMAIL " + user.email
        res.statusCode = 201
        res.render "user/create", _csrf: req.session._csrf
        # console.log ok    
      else
        res.send err
        res.statusCode = 500
        # console.log err


  # Creates new user with data from `req.body`
  create: (req, res) ->
    # FIXME - have a better error page
    # console.log 'user create'
    delete req.body.remember_me
    password = randomPassword(6)
    req.body.password = password
    # console.log(req.body.email);
    # check if user email exists
    # console.log('start user create');
    User.findOne { email:req.body.email }, (err,user) ->
      unless err
        # console.log('user',user);
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
            # console.log 'user is active'
            action = '/user/resetpassword/'
          else
            # console.log 'user is not active'
            action = '/user/activate/'
            options.template = "activation"
            options.subject = "account activation"
          
          if config.APP.hostname is 'localhost'
            # console.log 'is localhost'
            data = 
              link: "http://"+config.APP.hostname+":"+config.PORT+action+user.tokenString
          else
            # console.log 'not localhost'
            data = 
              link: config.APP.hostname+action+user.tokenString

          # console.log('mailer!');
          Route._sendMail(req, res, options, data);

        else
          user = new User req.body

          console.log('user not found create new one', user);

          user.save (err, user) ->
            # console.log(err,user);
            unless err
              if user
                # console.log 'user', user
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
                
                  # console.log('mailer!');
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
      unless err
        console.log 'activate. user', user
        res.redirect "user/resetpassword/"+req.params.id
      else if err is "token-expired-or-user-active"
        console.log "token-expired-or-user-active" 
        res.send "your activation token has expired. Please request activation another time"


  

  # Gets user by id

  resetpassword: (req, res) ->
    console.log 'resetpass'
    console.log req.body
    console.log 1
    console.log req.params.id
    res.render "user/login"
      token: req.params.id


  changepassword: (req, res) ->
    console.log 'changepassword'
    console.log 1
    console.log req.body
    if req.body.password? and req.body.password is req.body.password_confirm
      User.findOne req.body.token,  (err, user) ->
        unless err
          console.log 2
          if user
            user.password = req.body.password
            console.log 3
            user.save (err) ->
              unless err
                res.redirect "user/get/"+req.body.token
                #res.render "user/user"
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
    console.log req.params.id
    User.findById req.params.id, (err, user) ->
      if not err
        console.log(user);
        res.render "user/user"
          user: user
            
      else
        User.findOne tokenString: req.params.id, (err, user) ->
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
    # change to update
    # console.log(User);
    # console.log(User.findByIdAndUpdate);
    console.log(req.query);
    console.log('============');
    console.log(req.body);
    console.log('============');
    console.log(req.params);
    User.findByIdAndUpdate req.params.id, {"$set":req.body}, (err, user) ->
      if not err
        res.send user
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