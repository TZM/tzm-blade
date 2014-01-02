User = require "../models/user/user"
sanitize = require("validator").sanitize
validator = require("../utils/validation").validator()
config = require("../config/config")
validation = require("../utils/validation")
messages = require "../utils/messages"
Emailer = require ("../utils/emailer")
passport = require("passport")
  
logger = require "../utils/logger"
logCat = "USER controller"
validationEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/


# User model's CRUD controller.
Route = 
  # Lists all users
  index: (req, res) ->
    # FIXME set permissions to see this - only admins
    if req.user.groups is 'admin'
      User.find {}, (err, users) ->
        res.send users

  _sendMail: (req, res, options, data, linkinfo) ->
    console.log("sending message to: ", options.to.email);
    mailer = new Emailer(options, data);
    mailer.send (err,message)->
      unless err
        res.statusCode = 201
        req.flash('info', linkinfo)
        res.redirect "index"
          
      else
        console.log err
        res.statusCode = 400
        req.flash('info', req.i18n.t('ns.msg:flash.sendererror')+".")
        res.redirect "index"
  
  # Creates new user with data from `req.body`
  # Or reset his password and send link to email
  create: (req, res, next) ->
    # FIXME - have a better error page
    delete req.body.remember_me
    console.log("server csrf: "+ req.session._csrf);
    if req.body?
      req.body.email = req.body.email.toLowerCase()
      if validationEmail.test(req.body.email)
        # check if user email exists
        User.findOne { email:req.body.email }, (err,user) ->
          unless err
            if user
              # setting up flash message about link info.
              linkinfo = req.i18n.t('ns.msg:flash.resetlink')+"."
              options = 
                template: "reset"
                subject: "reseting your password"
                to: 
                  name: user.name
                  surname: user.surname
                  email: user.email
              #check if user is already active then reset password if not then send activation link again
              if user.active is true
                console.log("user exist and activeted");
                action = '/user/resetpassword/'
              else
                console.log("user exist but not activated");
                linkinfo = req.i18n.t('ns.msg:flash.activationlink')+"."
                action = '/user/activate/'
                options.template = "activation"
                options.subject = "account activation"
              
              if config.APP.hostname is 'localhost'
                console.log("is locals host");
                data = 
                  link: "http://"+config.APP.hostname+":"+config.PORT+action+user.tokenString
              else
                console.log("isnt localhost");
                data = 
                  link: config.APP.hostname+action+user.tokenString
              user.resetLoginAttempts (cb) ->
                console.log("wrong login attempts reseted to 0");
              Route._sendMail(req, res, options, data, linkinfo);
            else
              User.register req.body, (err,user)->
                unless err
                  linkinfo = req.i18n.t('ns.msg:flash.activationlink')+"." 
                  options = 
                    template: "activation"
                    subject: "account activation"
                    to: 
                      name: user.name
                      surname: user.surname
                      email: user.email
                  if config.APP.hostname is 'localhost'
                    console.log("is localhost");
                    data = 
                      link: "http://"+config.APP.hostname+":"+config.PORT+"/user/activate/"+user.tokenString
                  else
                    console.log("isnt localhost");
                    data = 
                      link: config.APP.hostname+"/user/activate/"+user.tokenString
                  
                  Route._sendMail(req, res, options, data, linkinfo);
                else
                  console.log("user register error");
                  req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err.message)
                  res.statusCode = 500
                  res.redirect("index")
          else
            console.log("user find error");
            req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err.message)
            res.statusCode = 500
            res.redirect("index")
            
      else
        console.log("email is not valid");
        res.statusCode = 400
        res.redirect("index")
        req.flash('info', req.i18n.t('ns.msg:flash.validemail'))
    else
      console.log("req.body is empty");
      res.statusCode = 400
      res.redirect("index")
  activate: (req, res, next) ->
    console.log "activate"
    User.activate req.params.id, (err, user) ->
      console.log('end of activate');
      unless err
        if user
          console.log 'activate. user', user
          if user.active is true
            req.logIn user, (err) ->
              console.log('login err') if err
              next(err)  if err
              req.flash('info', 'Activation success')
              res.redirect "user/resetpassword/"+user.tokenString
          else
            res.statusCode = 400
            req.flash('info', req.i18n.t('ns.msg:flash.alreadyactivated'))
            res.redirect "index"
        else
          res.statusCode = 400
          req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
          res.redirect "index"
      else if err is "token-expired-or-user-active"
        console.log "token-expired-or-user-active" 
        res.statusCode = 403
        req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
        res.redirect "index"
  resetpassword: (req, res) ->
    console.log 'resetpass'
    console.log(req.params.id);
    if req.params.id?

      User.findOne {tokenString: req.params.id}, (err,user)->
        unless err
          if user
            req.logIn user, (err)->
              unless err
                req.flash('info', 'Enter your new password')
                res.render "user/resetpassword",
                  token: req.params.id
                  user: req.user
              else
                res.statusCode = 403
                req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
                res.redirect "index"
          else
            res.statusCode = 403
            req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
            res.redirect "index"
        else
          res.statusCode = 403
          req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
          res.redirect "index"
    else
      res.statusCode = 403
      req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
      res.redirect "index"
  changepassword: (req, res,next) ->
    console.log 'changepassword'
    console.log(req.body);
    if req.body.password_new is req.body.password_confirm and req.body.password_new.length >=6
      User.findOne { tokenString: req.body.token },  (err, user) ->
        unless err
          console.log('user',user);
          if user
            user.password = req.body.password_new
            user.loginAttempts = 0
            user.lockUntil = 0
            user.save (err) ->
              unless err
                req.logIn user, (err) ->
                  next(err)  if err
                  req.flash('info', 'Password changed')
                  res.redirect "/user/get"
              else
                res.statusCode = 400
                req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err.message)
                res.redirect "/"
          else
            res.statusCode = 400
            req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
            res.redirect "index"
        else
          console.log err
          res.statusCode = 400
          res.render "/user/resetpassword",
            token: req.body.token
            user: req.user
    else
      res.statusCode = 400
      res.render "/user/resetpassword",
        token: req.body.token
        user: req.user
  get: (req, res) ->
    logger.info "controller start", logCat
    if req.session.passport.user?
      User.findById req.session.passport.user, (err, user) ->
        unless err
          res.render "user/user",
            user: user
    else if req.params.id?
      User.findById req.params.id, (err, user) ->
        unless err
          if user
            res.render "user/user",
              user: user
          else
            res.statusCode = 400
            req.flash('info', req.i18n.t('ns.msg:flash.tokenexpires'))
            res.redirect "index"
        else
          res.statusCode = 400
          req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err)
          res.redirect "index"
    else
      res.statusCode = 403
      req.flash('info', req.i18n.t('ns.msg:flash.unauthorized'))
      res.redirect "index"
  # Updates user with data from `req.body`
  update: (req, res) ->
    if req.body.name.length >= 3 or req.body.password_old.length >= 6 or req.body.surname.length >= 3
      console.log('update');
      console.log('body', req.body);
      User.findById req.user.id, (err, user) ->
        unless err
            if user
              if req.body.password_old.length >= 6
                if req.body.password_new is req.body.password_confirm
                  user.comparePassword req.body.password_old, (err,isMatch)->
                    unless err
                      if isMatch
                        user.password = req.body.password_new
                        user.name = req.body.name if req.body.name
                        user.surname = req.body.surname if req.body.surname
                        user.save (err) ->
                          unless err
                            req.flash('info', req.i18n.t('ns.msg:flash.profilesaved'))
                            res.redirect '/user/get'
                          else
                            #res.statusCode = 500
                            req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err)
                            res.redirect '/user/get'
                      else
                        console.log('1');
                        req.flash('info', req.i18n.t('ns.msg:flash.invalidoldpass'))
                        res.redirect "/user/get"
                        #res.statusCode = 400
                    else
                      console.log('2');
                      req.flash('info', req.i18n.t('ns.msg:flash.invalidoldpass'))
                      res.redirect "/user/get"
                      #res.statusCode = 400
                else
                  console.log('3');
                  req.flash('info', req.i18n.t('ns.msg:flash.invalidconfirmpass'))
                  #res.statusCode = 400
                  res.redirect "/user/get"
              else if req.body.name isnt '' or req.body.surname isnt ''
                user.name = req.body.name if req.body.name
                user.surname = req.body.surname if req.body.surname
                user.save (err) ->
                  unless err
                    console.log('4');
                    req.flash('info', req.i18n.t('ns.msg:flash.profilesaved'))
                    res.redirect '/user/get'
                  else 
                    #res.statusCode = 500
                    req.flash('info', req.i18n.t('ns.msg:flash.dberr')+err)
                    res.redirect '/user/get'
              else
                console.log('5');
                req.flash('info', req.i18n.t('ns.msg:flash.invalidoldpass'))
                res.redirect '/user/get'
                #res.statusCode = 400
        else
          console.log('6');
          req.flash('info', err)
          res.redirect "index"
          #res.statusCode = 400
    else
      console.log('7');
      req.flash('info', req.i18n.t('ns.msg:flash.saveerr'))
      res.redirect '/user/get'
      #res.statusCode = 400
      console.log("body is not valid");
  # Deletes user by id
  delete: (req, res) ->
    User.remove {_id: req.params.id}, (err, ok) ->
      unless err
        req.flash('info', req.i18n.t('ns.msg:flash.userdeleted'))
        res.redirect '/user/get'
        res.statusCode = 400
  login: (req, res, next) ->
    console.log 'authenticate'
    if req.isAuthenticated()
      req.flash('info', req.i18n.t('ns.msg:flash.alreadyauthorized'))
      res.redirect "index"
    else if req.body.email?
      console.log('not logged in. authenticate');
      req.body.email = req.body.email.toLowerCase()
      console.log(req.body);
      if validationEmail.test(req.body.email)
        passport.authenticate("local", (err, user, info) ->
          unless err
            if user
              req.logIn user, (err) ->
                unless err
                  req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
                  res.statusCode = 201
                  res.redirect '/user/get'

                else
                  console.log(5);
                  console.log("inactiveuser");
                  req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
                  res.redirect "index"
                  res.statusCode = 403
            else
              console.log(4);
              req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
              res.statusCode = 403
              res.redirect "index"
              
          else
            console.log(3);
            next(err)
        ) req, res, next
      else
        console.log('email is not valid');
        req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
        res.redirect "index"
        res.statusCode = 403
    else
      console.log(1);
      res.redirect "index",
        user: req.user
      res.statusCode = 403

module.exports = Route