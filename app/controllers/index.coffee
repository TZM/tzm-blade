# Just renders index.blade
cldr = require "cldr"
fs = require "fs"
i18n = require "i18next"



exports.index = (req, res) ->
  countries = []
  code = i18n.lng().substr(0, 2)
  countries = cldr.extractTerritoryDisplayNames(code)
    
  tmpl = 
    "hello": ["world", "xxxx"]
  console.log("server/index csrf: ", req.session._csrf);
  res.render "index",
    _tmpl: tmpl
    user: req.user
    port: 3001
    allCountries: countries
    # chapters: official
      
    #res.send data