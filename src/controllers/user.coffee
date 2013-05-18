User = require "../models/user/user"

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
    user = new User req.body
    user.save (err, user) ->
      if not err
        # check if user email exists
        # email user verification token
        console.log "EMAIL " + user.email
        res.render "user/create"
        #res.send user
        res.statusCode = 201
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
    User.activate req.params.id, (err, user) ->
      if err
        req.session.error = err
        if err is "token-expired-or-user-active"
          res.render "login"
        else
          res.render "login"
      else
        res.render "index"
        res.statusCode = 200

  # Gets user by id
  get: (req, res) ->
    User.findById req.params.id, (err, user) ->
      if not err
        res.send user
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
  login: (req, res) ->
     console.log (_csrf: req.session._csrf)
     #res.render "user/login", _csrf: req.session._csrf
      
