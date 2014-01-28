logger = require "../utils/logger"

logCategory = "ERRORS"

module.exports = (app) ->
    NotFound = (msg) ->
        @name = "NotFound"
        Error.call this, msg
        Error.captureStackTrace this, arguments_.callee
    NotFound::__proto__ = Error::
    #  Catch all
    app.all "*", notFound = (req, res, next) ->
        throw new NotFound
    #  Load 404 page
    app.error (err, req, res, next) ->
        if err instanceof NotFound
            res.render "404"
        else
            next err
    #  Load 500 page
    app.error (err, req, res) ->
        logger.warn "files not found " + e, logCategory
        res.render "500",
            error: err
  app
