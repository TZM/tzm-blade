User = require "../models/user/user"
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV
passport = require("passport")
# Set up passport auth middleware
Route = 
  # Local auth strategy
  # ----------------------------
  facebook: (req, res, next) ->
    passport.authenticate("facebook", { failureRedirect: '/' }) req,res,next
      # Successful authentication, redirect home.
  facebookcallback: (req, res, next) ->
    passport.authenticate("facebook", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log(5);
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.redirect "/"
            res.statusCode = 403
    ) req,res,next
      # ----------------------------
  google: (req,res,next) ->
    passport.authenticate('google', { failureRedirect: '/' }) req,res,next
  
  googlecallback: (req, res, next) ->
    passport.authenticate("google", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log(5);
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.redirect "/"
            res.statusCode = 403
    ) req,res,next
  twitter: (req,res,next) ->
    passport.authenticate('twitter', { failureRedirect: '/' }) req,res,next
  
  twittercallback: (req, res, next) ->
    passport.authenticate("twitter", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.redirect "/"
            res.statusCode = 403
    ) req,res,next
  github: (req,res,next) ->
    passport.authenticate('github', { failureRedirect: '/' }) req,res,next
  
  githubcallback: (req, res, next) ->
    passport.authenticate("github", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.statusCode = 403
            res.redirect "/"
            
    ) req,res,next
  linkedin: (req,res,next) ->
    passport.authenticate('linkedin', { failureRedirect: '/' }) req,res,next
  
  linkedincallback: (req, res, next) ->
    passport.authenticate("linkedin", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.redirect "/"
            res.statusCode = 403
    ) req,res,next
  yahoo: (req,res,next) ->
    passport.authenticate('yahoo', { failureRedirect: '/' }) req,res,next
  
  yahoocallback: (req, res, next) ->
    passport.authenticate("yahoo", (err, user, info)->
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.statusCode = 403
            res.redirect "/"
            
    ) req,res,next
  # persona: (req,res,next) ->
  #   passport.authenticate('persona', { failureRedirect: '/' }) req,res,next
    
  persona: (req, res, next) ->
    passport.authenticate('persona', (err, user, info)->
      console.log("arguments in router");
      console.log(arguments);
      console.log err if err
      if user?
        req.logIn user, (err) ->
          unless err
            req.flash('info', req.i18n.t('ns.msg:flash.'+info.message)+info.data+" "+req.i18n.t('ns.msg:flash.'+info.message2))
            res.statusCode = 201
            res.redirect '/'

          else
            console.log("user login error: ", err);
            req.flash('info', req.i18n.t('ns.msg:flash.authorizationfailed'))
            res.statusCode = 403
            res.redirect "/"
            
    ) req,res,next


module.exports = Route