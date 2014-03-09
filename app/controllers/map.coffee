# Just renders map.blade
icons = require("../utils/icons").icons
d3 = require("d3")
topojson = require("topojson")
xy = d3.geo.mercator()
  .translate([-600, 4800])
  .scale(25000)
path = d3.geo.path().projection(xy)

margin =
  top: 20
  left: 20
  bottom: 20
  right: 20

#screenWidth
##width = parseInt(d3.select("#map").style("width"))
#console.log "+++++++++"
#console.log screenWidth
#console.log "+++++++++"
#width = width - margin.left - margin.right
#mapRatio = 0.5
#height = width * mapRatio
#resize = ->
#  clientWidth = document.documentElement.clientWidth
#  console.log "we resize "
#  return
#d3.select(window).on('resize')
#screenWidth = clientWidth
#console.log clientWidth

chartDiv = d3.select("body").append("div").attr("id", "chart")
chartSvg = chartDiv.append("svg").attr("id", "chartsvg").attr("height", 100)
mapSvg = chartDiv.append("svg").attr("width", "100%")
        .attr("height", "88%")
        .attr("preserveAspectRatio", "xMidYMid")
#        .attr("viewBox", "0 0 " + width + "  "+ height)
        
iconGroup = chartSvg.append("g").attr("class", "map-tools").attr("transform", "translate(0 0) scale(0.5)")

addRect = (group) ->
  group.append("svg:rect").attr("width", 100).attr("height", 100).attr("class", "icon_background" )

g = iconGroup.append("g").attr("class", "group-icon")
  .attr("name", "groups")

addRect(g)
g.append("svg:path").attr("d", icons.groupIcon)

g = iconGroup.append("g").attr("class", "projects-icons")
  .attr("transform", "translate(110)")
  .attr("name", '#{t("ns.forms:ph.user-filter")}')

addRect(g)
g.append("svg:path").attr("d", icons.projectsIcon)

g = iconGroup.append("g").attr("class", "skill-share-icon")
  .attr("transform", "translate(220)")
  .attr("name", "share your skills with tzm")

addRect(g)
g.append("svg:path").attr("d", icons.skillShareIcon)

#pd = (d) -> d.properties.name.replace (/ /g, "_")

worldJsonData = require('../../data/topo/world.json')
#chartSvg.append("g").attr("id", "countries")
#.data(topojson.object(worldJsonData, worldJsonData.objects.countries).geometries)
#.enter().append("path").attr("d", self.path)
#.attr "id", pd d

engine = require '../config/engine'
engine.on 'join:/map', (socket) ->

  socket.on 'message', (data) ->
    console.log 'data', data    
    try
      parsed = JSON.parse data
    catch e
      return socket.send "error: #{e.message}"
    if parsed.what == "screensize"
      mapSvg
       .attr("viewBox", "0 0 " + parsed.w + "  "+ parsed.h)
      console.log chartDiv.html() + "OLOLO"
      socket.send JSON.stringify {data: chartDiv.html()}
      

exports.map = (req, res) ->
  res.render "map",
    user: req.user
    chart: chartDiv.html()