# Just renders translate.blade
fs = require "fs"
__ = require "underscore"

exports.translate = (req, res) ->
	try
    	fs.readdir "./locales/dev", (err,locales) ->
    	    EXCLUDE = [ "translation.json" ]
    	    files = []
    	    results = __.reject locales, (value, index, list) ->
    	        return EXCLUDE.indexOf(value) != -1
    	    locale = __.each results, (value, index, list) ->
    	        files.push value
    	    res.render "translate"
    	    	user: req.user
    	    	files: files
	catch e
    	logger.warn "files not found " + e, logCategory
