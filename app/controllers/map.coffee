# Just renders map.blade
mapHelper = require("./maphelper")
d3 = require("d3")
topojson = require("topojson")
xy = d3.geo.mercator()
    .translate([-600, 4800])
    .scale(25000)
path = d3.geo.path().projection(xy)

chartDiv = d3.select("body").append("div").attr("id", "chart")
chartSvg = chartDiv.append("svg").attr("id", "chartsvg").attr("height", 100)
rect = chartSvg.append("rect").attr("class", "background").attr("width", 750).attr("height", 750)
iconGroup = chartSvg.append("g").attr("class", "map-tools").attr("transform", "translate(0 0) scale(0.5)")

addRect = (group) ->
    group.append("svg:rect").attr("width", 100).attr("height", 100).attr("style", "stroke:#006600; fill: #00cc00" )

g = iconGroup.append("g").attr("class", "group-icon")
    .attr("name", "groups")

addRect(g)
g.append("svg:path").attr("d", mapHelper.groupIcon)

g = iconGroup.append("g").attr("class", "projects-icons")
    .attr("transform", "translate(110)")
    .attr("name", "projects")

addRect(g)
g.append("svg:path").attr("d", mapHelper.projectsIcon)

g = iconGroup.append("g").attr("class", "skill-share-icon")
    .attr("transform", "translate(220)")
    .attr("name", "share your skills with tzm")

addRect(g)
g.append("svg:path").attr("d", mapHelper.skillShareIcon)

#pd = (d) -> d.properties.name.replace (/ /g, "_")

worldJsonData = require('../../data/topo/world.json')
#chartSvg.append("g").attr("id", "countries").selectAll("path")
#.data(topojson.object(worldJsonData, worldJsonData.objects.countries).geometries)
#.enter().append("path").attr("d", self.path)
#.attr "id", pd d

exports.map = (req, res) ->
    res.render "map"
        user: req.user
        worldJsonData: worldJsonData
        chart: chartDiv.html()