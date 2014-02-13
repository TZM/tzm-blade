User = require "../models/user/user"
sanitize = require("validator").sanitize
validator = require("../utils/validation").validator()
config = require("../config/config")
validation = require("../utils/validation")
messages = require "../utils/messages"
Emailer = require ("../utils/emailer")
passport = require("passport")
async = require('async')
  
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
    console.log("server csrf: "+ req.csrfToken());
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
            delete user.awaitConfirm
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
  list: (req, res, next) ->
    console.log 'list', req.user && req.user.groups
    #if !req.user || req.user.groups isnt 'admin'
    #  return res.send(403)

    if req.method is 'POST'

      body = req.body
      if !body?
        return res.send 400, 'Must provide data.'

      action = body.action
      user = body.user
      users = body.users

      console.log 'list post', body

      return res.send 400, 'Must provide valid action type.' unless action

      if action is 'update'
        user = body.user

        return res.send 400, 'Missing user data.' unless user
        return res.send 400, 'Must provide valid email address.' unless user.email

        return listUpdateUser user, (err, result) ->
          return res.send 500, err.message || err if err

          res.send result
      else if action is 'updateall'
        users = body.users

        if !users
          return res.send 400, 'Invalid user data.'

        for user in users
          return res.send 400, 'Invalid email address.' unless user.email

        return async.map users, listUpdateUser, (err, results) ->
          return res.send 500, err.message || err if err

          res.send results
      else if action is 'create'
        user = body.user

        return res.send 400, 'Missing user data.' unless user
        return res.send 400, 'Invalid email address.' unless user.email

        listCreateUser user, (err, result1) ->
          return res.send 500, err.message || err if err

          listSendMail user.email, (err, result2) ->
            return res.send 500, err.message || err if err

            res.send result1
      else if action is 'resendall'
        emails = body.emails

        return res.send 400, 'Need emails.' unless emails and emails.length

        async.map emails, listSendMail, (err, results) ->
          return res.send 500, err.message || err if err

          res.send results
      else if action is 'state'
        email = body.email
        state = body.state

        return res.send 400, 'Must provide valid email address.' unless email

        if state is email
          return listSendMail email, (err, result) ->
            return res.send 500, err.message || err if err

            res.send result

        return res.send 400, 'Must set a proper state.' unless state in ['active', 'inactive']

        data = email:email

        data.active = state is 'active'

        return listUpdateUser data, (err, result) ->
          return res.send 500, err.message || err if err

          res.send result
      else
        return res.send 400, 'Invalid action type.'

    else if req.method is 'GET'
      #if req.users.groups is 'admin'
      q = req.query.q
      filter = req.query.filter
      sort = req.query.sort
      order = req.query.order
      count = req.query.count

      data = {}

      if q
        if filter is 'email'
          data.email = new RegExp('^'+q, 'i')
        else if filter is 'name'
          data.$or = [ {name: new RegExp('^'+q, 'i')}, {surname: new RegExp('^'+q, 'i')}]

      if count
        query = User.count data
      else
        limit = Math.min(req.query.limit ? 20, 200)
        skip = req.query.skip ? 0

        query = User.find(data, listFields).skip(skip).limit(limit)

        if order and sort in ['email', 'name', 'surname', 'groups', 'state']
          sortObj = {}

          order = 1 if order is 'asc'
          order = -1 if order is 'desc'

          if sort is 'state'
            query.sort({active:order, awaitConfirm:order});
          else
            sortObj[sort] = order
            query.sort(sortObj)
        else
          query.sort {_id:1}

      query.exec (err, results) ->
        return res.send 500, err.message || err if err

        if count
          return res.json {count:results}

        User.count(data).exec (err, count) ->
          return res.send 500, err.message || err if err

          if req.xhr
            res.json
              users: results
              count: count
          else
            listHelper = require('./listhelper')
            res.render 'user/list'
              users: results
              count: count
              iconDefs: listHelper.defs.html()
              icons: listHelper.icons

listFields = 'email name surname groups active provider awaitConfirm -_id'

listSendMail = (email, cb) ->
  User.findOneAndUpdate {email:email}, {awaitConfirm:true}, (err, user) ->
    return cb err if err
    return cb if !user

    options =
      template: "reset"
      subject: "reseting your password"
      to:
        name: user.name
        surname: user.surname
        email: user.email
    #check if user is already active then reset password if not then send activation link again
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
    user.resetLoginAttempts (cb) ->
      console.log("login attempts reset to 0");

    console.log("sending message to: ", options.to.email);
    mailer = new Emailer(options, data);
    mailer.send (err,message)->
      return cb err if err

      cb null, message


listCreateUser = (data, cb) ->
  User.register data, (err, result) ->
    return cb err if err

    listUpdateUser data, cb

listUpdateUser = (data, cb) ->
  email = data?.email
  if !email
    return cb(new Error('Must provide valid email address to update.'));

  validator.check(email, messages.VALIDATE_EMAIL).isEmail()

  where = {email: email};
  update = {}

  if data.newEmail?
    validator.check(data.newEmail, messages.VALIDATE_EMAIL).isEmail()
    update.email = data.newEmail

  errors = validator.getErrors()
  if errors.length
    return cb errors[0]

  update.name = data.name if data.name?
  update.surname = data.surname if data.surname?
  update.groups = data.groups if data.groups?
  update.awaitConfirm = true if data.state is 'email'

  if data.state is 'active'
    update.active = true
  else if data.state is 'inactive'
    update.active = false

  console.log 'pre update', where, update

  User.findOneAndUpdate where, update, {select: listFields}, (err, user) ->
    return cb(err) if err

    obj = user.toObject()
    obj.origEmail = email

    cb(null, obj)

module.exports = Route