# Just renders map.blade
mapHelper = require("./maphelper")
d3 = require("d3")
xy = d3.geo.mercator()
	.translate([-600, 4800])
	.scale(25000)
path = d3.geo.path().projection(xy)

chartDiv = d3.select("body").append("div") #.attr("id", "chart")
chartSvg = chartDiv.append("svg").attr("id", "chartsvg").attr("width", 750).attr("height", 750)
rect = chartSvg.append("rect").attr("class", "background").attr("width", 750).attr("height", 750)
iconGroup = chartSvg.append("g").attr("class", "map-tools").attr("transform", "translate(300 500) scale(0.5)")

iconGroup.append("svg:path").attr("class", "group-icon").attr("d", mapHelper.groupIcon)
iconGroup.append("svg:path").attr("class", "projects-icons").attr("d", mapHelper.projectsIcon).attr("transform", "translate(100)")
iconGroup.append("svg:path").attr("class", "skill-share-icon").attr("d", mapHelper.skillShareIcon).attr("transform", "translate(220)")

worldJsonData = require('../../data/topo/world.json')

exports.map = (req, res) ->
    res.render "map"
    	user: req.user
    	worldJsonData: worldJsonData
    	chart: chartDiv.html()
