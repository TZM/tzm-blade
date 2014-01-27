# Just renders map.blade
mapHelper = require("./maphelper")
d3 = require("d3")
xy = d3.geo.mercator()
	.translate([-600, 4800])
	.scale(25000)
path = d3.geo.path().projection(xy)
chartDiv = d3.select("body").append("div") #.attr("id", "chart")
chartSvg = chartDiv.append("svg").attr("id", "chartsvg")
rect = chartSvg.append("rect").attr("class", "background").attr("width", 750).attr("height", 750)
iconGroup = chartSvg.append

map = d3.select("body").node().innerHTML
console.log map

worldJsonData = require('../../data/topo/world.json')

exports.map = (req, res) ->
    res.render "map"
    	user: req.user
    	worldJsonData: worldJsonData
    	chart: chartDiv.html()
