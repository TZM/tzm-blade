# Return the chapters.json based on the language
i18n = require "i18next"
fs = require "fs"
cldr = require "cldr"
__ = require "underscore"

exports.chapters = (req, res, err) ->
	#res.writeHead 200,
  	#	"Content-Type": "application/json"
  	#	"Access-Control-Allow-Origin": "*"
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
		tzmNetwork = []
		tzm = __.each tzmChapters, (value, index, list) ->
			locale = value.desc.LOCALES.split("-")[1]
			tzmNetwork.push({link:value.desc.WEBSITE,contact:value.desc.CONTACT,country: allCountries[locale]})
		res.json {tzmNetwork}
