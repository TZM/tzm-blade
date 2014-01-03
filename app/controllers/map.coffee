# Just renders map.blade
d3 = require("d3")
xy = d3.geo.mercator()
	.translate([-600, 4800])
	.scale(25000)
path = d3.geo.path().projection(xy)
l = d3.select("body").append("div")
	.attr("id", "chart")
	.append("svg")
	.attr("id", "background")
	.attr("width", 750)
	.attr("height", 750)

map = d3.select("body").node().innerHTML
console.log map

worldJsonData = require('../../data/topo/world.json')

exports.map = (req, res) ->
    res.render "map"
    	user: req.user
    	worldJsonData: worldJsonData
