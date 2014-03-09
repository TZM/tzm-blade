# Just renders map.blade
icons = require("../utils/icons").icons
d3 = require "d3"
topojson = require "topojson"
queue = require "queue-async"

margin =
  top: 20
  left: 20
  bottom: 20
  right: 20

urls = world: "../../data/topo/world.json"

type = d3.geo.equirectangular().scale(150)
projection = d3.geo.path().projection(type)
map = d3.select("body").append("div").attr("id", "map")
svg = map.append("svg")
  .attr("width", "100%")
  .attr("height", "88%")
  .attr("preserveAspectRatio", "xMidYMid")

#queue().defer(d3.json, urls.world)
# Add a transparent rect so that zoomMap works if user clicks on SVG
zoom = svg.append("rect")
  .attr("id", "zoom")
  .attr("width", "100%")
  .attr("height", "88%")

tools = svg.append("g").attr("class", "map-tools").attr("transform", "translate(0 0) scale(0.5)")

addRect = (group) ->
  group.append("svg:rect").attr("width", 100).attr("height", 100).attr("class", "icon_background" )

g = tools.append("g").attr("class", "groups-icon")
  .attr("name", "groups")

addRect(g)
g.append("svg:path").attr("d", icons.groupsIcon)

g = tools.append("g").attr("class", "projects-icon")
  .attr("transform", "translate(110)")
  .attr("name", '#{t("ns.forms:ph.user-filter")}')

addRect(g)
g.append("svg:path").attr("d", icons.projectsIcon)

g = tools.append("g").attr("class", "skills-share-icon")
  .attr("transform", "translate(220)")
  .attr("name", "share your skills with tzm")

addRect(g)
g.append("svg:path").attr("d", icons.skillsShareIcon)

#pd = (d) -> d.properties.name.replace (/ /g, "_")

worldJsonData = require "../../data/topo/world.json"

#chartSvg.append("g").attr("id", "countries")
#.data(topojson.object(worldJsonData, worldJsonData.objects.countries).geometries)
#.enter().append("path").attr("d", self.path)
#.attr "id", pd d

engine = require "../config/engine"
engine.on 'join:/map', (socket) ->

  socket.on 'message', (data) ->
    console.log 'data', data    
    try
      parsed = JSON.parse data
    catch e
      return socket.send "error: #{e.message}"
    if parsed.what == "screensize"
      svg
        .attr("viewBox", "0 0 " + parsed.w + "  "+ parsed.h)
      console.log map.html() + "OLOLO"
      socket.send JSON.stringify {data: map.html()}
      

exports.map = (req, res) ->
  res.render "map",
    user: req.user
    svg: map.html()