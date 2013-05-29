User = require "../models/user/user"
sanitize = require("validator").sanitize
validator = require("../utils/validation").validator()
config = require("../config/config")
validation = require("../utils/validation")
messages = require "../utils/messages"
Login = require ("./login")
Emailer = require ("../utils/emailer")

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
module.exports = 

  # Lists all users
  index: (req, res) ->
    # FIXME set permissions to see this - only admins
    User.find {}, (err, users) ->
      res.send users

  # Creates new user with data from `req.body`
  create: (req, res) ->
    # FIXME - have a better error page
    delete req.body.remember_me
    password = randomPassword(6)
    req.body.password = password
    # check if user email exists
    User.findOne req.body.email, (err,user) ->
      unless err
        if user
          # email user verification token
          options = 
            template: "reset"
            subject: "reseting your password"
            to: 
              name: ""
              surname: ""
              email: user.email
          if config.APP.hostname is 'localhost'
            data = 
              link: "http://localhost:3000/user/resetpassword/"+user.tokenString
          else
            data = 
              link: config.APP.hostname+"/user/resetpassword/"+user.tokenString
          mailer = new Emailer(options, data);
          mailer.send (err,ok)->
            unless err
              res.render "user/create", _csrf: req.session._csrf
              res.statusCode = 200
            else
              res.send err
              res.statusCode = 500
              console.log err
        else
          user = new User req.body
          user.save (err, user) ->
            unless err
              if user
                console.log 'user', user
                # email user verification token
                options = 
                  template: "register"
                  subject: "registration"
                  to: 
                    name: ""
                    surname: ""
                    email: user.email
                if config.APP.hostname is 'localhost'
                  data = 
                    link: "http://localhost:3000/user/activate/"+user.tokenString
                else
                  data = 
                    link: config.APP.hostname+"/user/activate/"+user.tokenString
                mailer = new Emailer(options, data);
                console.log 'data!!!!!!!!!!!!!!!!', data
                mailer.send (err,ok)->
                  unless err
                    console.log "EMAIL " + user.email
                    res.statusCode = 201
                    res.render "user/create", _csrf: req.session._csrf
                    console.log ok    
                  else
                    res.send err
                    res.statusCode = 500
                    console.log err
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
        if user
          res.redirect "user/get/"+req.params.id
        else
          console.log err
          res.render "user/login"
      else if err is "token-expired-or-user-active"
        console.log "token-expired-or-user-active" 
        res.render "user/login"

  # Gets user by id

  resetpassword: (req, res) ->
    console.log 'resetpass'
    console.log req.body
    console.log 1
    console.log req.params.id
    res.render "user/login"
      token: req.params.id


  changepassword: (req, res) ->
    console.log 'changepass'
    console.log 1
    console.log req.body
    if req.body.password? and req.body.password is req.body.password_confirm
      User.update req.body.token, password: req.body.password,  (err, user) ->
        unless err
          console.log 2
          if user
            console.log 3
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
        res.render "user/user"
          user: 
            user
      else
        User.findOne tokenString: req.params.id, (err, user) ->
          unless err
            if user
              res.render "user/user"
                user: user
            else
              res.statusCode = 400
          else
            res.send err
            res.statusCode = 500
             
  # Updates user with data from `req.body`
  update: (req, res) ->
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
        
  # Login user
  login: (req, res, next) ->
    #console.log 'BODY!!!', req.body
    #req.logIn user, (err) ->
      #if err
        #console.log err
      #else
        #console.log arguments

    #if req.body.remember_me is 'on'
      ##Login.login(req,res,next)
      #User.findOne req.body.email, (err,user) ->
        #unless err
          #if user
            #res.send user
          #else
            #console.log 'wrong login or password'
            ##res.redirect 'user/create'
        #else
          #res.send err
          #res.statusCode = 500
            ##console.log 'user not found'
        ##else
          ##res.send err
          ##console.log 'user find error'
    #else
      #console.log 'huyedy',req.body
      #console.log (_csrf: req.session._csrf)
      #res.send 200, req.body
      
