# Return the chapters.json based on the language
i18n = require "i18next"
fs = require "fs"
cldr = require "cldr"
__ = require "underscore"

exports.chapters = (req, res, err) ->
	#res.header 200,
  	#	"Content-Type": "application/json"
  	#	"Access-Control-Allow-Origin": "*"
  	#res.header "Access-Control-Allow-Origin", "*" # TODO - Make this more secure!!
  	#res.header "Content-Type": "application/json"
  	#res.header "Access-Control-Allow-Headers", "Access-Control-Allow-Headers\", \"Origin, X-Requested-With, Content-Type, Accept"
  	#tzmNetwork = []
	fs.readFile "./data/chapters.json", (err, chapterJSON) ->
		console.log("read file error", err) if err
		tzmChapters = JSON.parse chapterJSON
		try
			# ...
			lngCode = req.query.setLng.split("-")[0]
		catch e
			# fallback to user locale
			lngCode = i18n.lng().split("-")[1]
		allCountries = cldr.extractTerritoryDisplayNames(lngCode)
		flags = cldr.extractTerritoryDisplayNames('en')
		tzmNetwork = []
		tzm = __.each tzmChapters, (value, index, list) ->
			locale = value.desc.LOCALES.split("-")[1]
			flag = 'c_'+flags[locale].toLowerCase().replace(/\s/g, "")
			console.log flag.replace(/\s/g, "") 
			tzmNetwork.push({link:value.desc.WEBSITE,contact:value.desc.CONTACT,country: allCountries[locale], flag: flag})
		#console.log tzmNetwork
		res.json {tzmNetwork}
