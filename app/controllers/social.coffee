User = require "../models/user/user"
config = require "../config/config"
config.setEnvironment process.env.NODE_ENV
passport = require "passport"
# Set up passport auth middleware
Route =
    # Local auth strategy
    # ----------------------------
    facebook: (req, res, next) ->
        if process.env.FB_APP_ID? and  process.env.FB_APP_SEC?
            passport.authenticate("facebook", { failureRedirect: "/" }) req,res,next
        else
            req.flash("info", "FB_APP_ID and FB_APP_SEC are required")
            res.statusCode = 401
            res.redirect "/"
            # Successful authentication, redirect home.
    facebookcallback: (req, res, next) ->
        console.log("FACEBOOK CALLBACK ", process.env.FB_APP_ID? and  process.env.FB_APP_SEC? )
        if process.env.FB_APP_ID? and  process.env.FB_APP_SEC?
            passport.authenticate("facebook", (err, user, info)->
                console.log err if err
                if user?
                    req.logIn user, (err) ->
                        unless err
                            req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                                " + req.i18n.t("ns.msg:flash." + info.message2))
                            res.statusCode = 201
                            res.redirect "/"
                        else
                            console.log("user login error: ", err)
                            req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                            res.statusCode = 403
                            res.redirect "/"
            ) req,res,next
        else
            req.flash("info", "FB_APP_ID and FB_APP_SEC are required")
            res.statusCode = 401
            res.redirect "/"

    google: (req,res,next) ->
        passport.authenticate("google") req,res,next
    googlecallback: (req, res, next) ->
        passport.authenticate("google", (err, user, info)->
            console.log err if err
            if user?
                req.logIn user, (err) ->
                    unless err
                        req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                          " + req.i18n.t("ns.msg:flash." + info.message2))
                        res.statusCode = 201
                        res.redirect "/"
                    else
                        console.log("user login error: ", err)
                        req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                        res.statusCode = 403
                        res.redirect "/"
        ) req,res,next

    twitter: (req,res,next) ->
        if process.env.TT_APP_ID? and process.env.TT_APP_SEC?
            passport.authenticate("twitter", { failureRedirect: "/" }) req,res,next
        else
            req.flash("info", "TT_APP_ID and TT_APP_SEC are required")
            res.statusCode = 401
            res.redirect "/"
    twittercallback: (req, res, next) ->
        if process.env.TT_APP_ID? and process.env.TT_APP_SEC?
            passport.authenticate("twitter", (err, user, info)->
                console.log err if err
                if user?
                    req.logIn user, (err) ->
                        unless err
                            req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                                " + req.i18n.t("ns.msg:flash." + info.message2))
                            res.statusCode = 201
                            res.redirect "/"
                        else
                            console.log("user login error: ", err)
                            req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                            res.statusCode = 403
                            res.redirect "/"
            ) req,res,next
        else
            req.flash("info", "TT_APP_ID and TT_APP_SEC are required")
            res.statusCode = 401
            res.redirect "/"

    github: (req,res,next) ->
        if process.env.GITHUB_ID? and process.env.GITHUB_SEC?
            passport.authenticate("github", { failureRedirect: "/" , scope: ["user:email"]}) req,res,next
        else
            req.flash("info", "GITHUB_ID and GITHUB_SEC are required")
            res.statusCode = 401
            res.redirect "/"
    githubcallback: (req, res, next) ->
        if process.env.GITHUB_ID? and process.env.GITHUB_SEC?
            passport.authenticate("github", (err, user, info)->
                console.log err if err
                if user?
                    req.logIn user, (err) ->
                        unless err
                            req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                                " + req.i18n.t("ns.msg:flash." + info.message2))
                            res.statusCode = 201
                            res.redirect "/"
                        else
                            console.log("user login error: ", err)
                            req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                            res.statusCode = 403
                            res.redirect "/"
            ) req,res,next
        else
            req.flash("info", "GITHUB_ID and GITHUB_SEC are required")
            res.statusCode = 401
            res.redirect "/"

    linkedin: (req,res,next) ->
        if process.env.LI_APP_ID? and process.env.LI_APP_SEC?
            passport.authenticate("linkedin", { failureRedirect: "/" }) req,res,next
        else
            req.flash("info", "LI_APP_ID and LI_APP_SEC are required")
            res.statusCode = 401
            res.redirect "/"
    linkedincallback: (req, res, next) ->
        if process.env.LI_APP_ID? and process.env.LI_APP_SEC?
            passport.authenticate("linkedin", (err, user, info)->
                console.log err if err
                if user?
                    req.logIn user, (err) ->
                        unless err
                            req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                              " + req.i18n.t("ns.msg:flash." + info.message2))
                            res.statusCode = 201
                            res.redirect "/"
                        else
                            console.log("user login error: ", err)
                            req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                            res.statusCode = 403
                            res.redirect "/"
            ) req,res,next
        else
            req.flash("info", "LI_APP_ID and LI_APP_SEC are required")
            res.redirect "/"
            res.statusCode = 401

    yahoo: (req,res,next) ->
        passport.authenticate("yahoo", { failureRedirect: "/" }) req,res,next
    
    yahoocallback: (req, res, next) ->
        passport.authenticate("yahoo", (err, user, info)->
            console.log err if err
            if user?
                req.logIn user, (err) ->
                    unless err
                        req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                            " + req.i18n.t("ns.msg:flash." + info.message2))
                        res.statusCode = 201
                        res.redirect "/"
                    else
                        console.log("user login error: ", err)
                        req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                        res.statusCode = 403
                        res.redirect "/"
        ) req,res,next

    #persona: (req,res,next) ->
    #    passport.authenticate("persona", { failureRedirect: "/" }) req,res,next
      
    persona: (req, res, next) ->
        passport.authenticate("persona", (err, user, info)->
            console.log "arguments in router"
            console.log arguments
            console.log err if err
            if user?
                req.logIn user, (err) ->
                    unless err
                        console.log "unless err"
                        req.flash("info", req.i18n.t("ns.msg:flash." + info.message) + info.data + "
                            " + req.i18n.t("ns.msg:flash." + info.message2))
                        res.statusCode = 200
                        res.render "index",
                            user: req.user
                    else
                        console.log("user login error: ", err)
                        req.flash("info", req.i18n.t("ns.msg:flash.authorizationfailed"))
                        res.statusCode = 403
                        res.redirect "/"
        ) req,res,next

module.exports = Route