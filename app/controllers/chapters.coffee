# Return the chapters.json based on the language
i18n = require "i18next"
fs = require "fs"
cldr = require "cldr"
__ = require "underscore"

exports.chapters = (req, res, err) ->
	fs.readFile "./data/chapters.json", (err, chapterJSON) ->
		console.log("read file error", err) if err
		tzmChapters = JSON.parse chapterJSON
		try
			# ...
			lngCode = req.query.setLng.split("-")[0]
		catch e
			# fallback to user locale
			lngCode = req.locale.split("-")[1]
		console.log lngCode
		allCountries = cldr.extractTerritoryDisplayNames(lngCode)
		flags = cldr.extractTerritoryDisplayNames('en')
		tzmNetwork = []
		tzm = __.each tzmChapters, (value, index, list) ->
			locale = value.desc.LOCALES.split("-")[1]
			flag = 'c_'+flags[locale].toLowerCase().replace(/\s/g, "")
			console.log flag.replace(/\s/g, "") 
			tzmNetwork.push({link:value.desc.WEBSITE,contact:value.desc.CONTACT,country: allCountries[locale], flag: flag})

		res.json {tzmNetwork}
