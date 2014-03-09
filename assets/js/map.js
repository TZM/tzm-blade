(function mapClient() {
    
    if (! (this instanceof arguments.callee)) {
        return new arguments.callee(arguments)
    }
    var self = this
    var margin = {top: 20, left: 20, bottom: 20, right: 20}
        , width = parseInt(d3.select('#map').style('width'))
        , width = width - margin.left - margin.right
        , mapRatio = 0.5
        , height = width * mapRatio
        , centered, data, country

    var urls = {world: "/world.json"}

    var parent = document.getElementById('map')
    
    parent.addEventListener('mousemove', self.mouseMoveOverMap, false)
    parent.addEventListener('mouseout', self.mouseOutOfMap, false)

    this.writeMouseLonLat = function(lonText, latText) {
        var infoText = ""
        infoText += "Latitude: " + latText + " Longitude: " + lonText;
        document.getElementById('LegendLabel').innerHTML = infoText;
    }

    this.fileExists = function(url) {
        var http = new XMLHttpRequest()
        http.open('HEAD', url, false)
        http.send()
        return http.status!=404
    }
    
    this.getBBox = function(selection) {
        var element = selection.node()
        return element.getBBox()
    }

    this.getCentroid = function(selection) {
        var element = selection.node(),
            bbox = element.getBBox()
        return [bbox.x + bbox.width/2, bbox.y + bbox.height/2]
    }

    this.init = function() {
        //now.receiveLocation = function(message) {
        //    console.log(message)
        //    // FIXME only push markers depending on the country/adm1 level
        //    self.drawMarker(message)
        //}
          //self.drawMap()
          //self.setMapStyle("bone");//see colormap.css for possible options: posneg, copper, greenwhitelila, posneg, jet
        //
        //var color_legend = d3.select("#color-legend-svg")
        //  .append("svg:svg")
        //  .attr("width", 225)
        //  .attr("height", 180);
        //color_legend.append("svg:rect")
        //  .attr("width", 80)
        //  .attr("height", 160)
    }

    self.tooltip = undefined

    this.initLegendLabel = function(qtype) {
        "use strict"
        var placeHolder = self.svg.append("g")
            .attr("class", "LegendLabel")
            .attr("transform", "scale(" + 0.7 + ")translate(" + 0 + "," + 0 + ")")
        //placeHolder.attr('transform', 'translate(250, 150)')
            
        var fo = placeHolder.append("svg:foreignObject")
            .attr("width", 400)
            .attr("height", 20)
            .attr("class", "LegendLabelObject")

        fo.append("xhtml:div")
            .attr("id", "LegendLabel")
        //fo.attr('transform', 'translate(25, 150)')
    }
    
    this.updateLegendLabel = function(index) {
        "use strict"
        d3.select('#LegendLabel')
            .text(function() {
                var display_string
                if (ZMGC.admin_level === 0) {
                    display_string = index.properties.CONTINENT
                } else if (ZMGC.admin_level === 3) {
                    display_string = index.properties.Name
                } else {
                    display_string = index.properties.NAME
                }
                return display_string
            })
            .transition()
            .duration(800)
    }
    
    this.hideLegendLabel = function(){ d3.select(".LegendLabel").attr("display", "none"); }
    this.showLegendLabel = function(){ d3.select(".LegendLabel").attr("display", "null"); }
    
    this.drawTooltip = function() {
        "use strict"
        console.log("drawTooltip")
        var tooltip = d3.select("body").append("g")
            .attr("id", "tooltip")
            .attr("class", "tooltip")
            .style("top", "0px")
            .style("left", "0px")
            .style("opacity", -1)
    
        tooltip.append("polygon")
            .attr("points", "-5, -7, -14, 7 5, 7")
            .attr('transform', 'translate(25, 150)')
    
        tooltip.append('rect')
            .attr('width', 180)
            .attr('height', 88)
            .attr('x', -1)
            .attr('y', 157)
            .attr('rx', 9)
        return tooltip
    }
    
    this.activateTooltip = function(index) {
        "use strict"
        //console.log(index)
        self.tooltip
            .text(function() {
                return index
            })
            .transition()
            .duration(500)
            .style("opacity", 1)
    }

    this.deactivateTooltip = function() {
        "use strict"
        self.tooltip.transition()
            .duration(500)
            .style("opacity", -1)
    }

    // Add Icons
    this.drawIcons = function() {
		var mapTools = $(".map-tools");
		//mapTools.attr("class", "map-tools greenwhitelila");
		mapTools.children()
            .on("mouseover", function(d) {
                d3.select(this)
               // .attr("class", "q30")
                .append("svg:title")
                .text(d3.select(this).attr("name"))
            })
            .on("mouseout", function(d) {
               // d3.select(this)
              //  .attr("class", "q4")
                d3.select(this).select("title").remove()
                //self.deactivateTooltip()
            })
        }

    // Map code
    this.drawMap = function() {
      "use strict"
      var map = d3.geo.equirectangular().scale(150)
      self.path = d3.geo.path().projection(map)

      self.svg = d3.select("#map").append("svg")
        .attr("width", "100%")
        .attr("height", "88%")
        .attr("viewBox", "0 0 " + width + "  "+ height)
        .attr("preserveAspectRatio", "xMidYMid")
        .on("mouseout", self.hideLegendLabel)
        .on("mouseover", self.showLegendLabel)

        queue()
            .defer(d3.json, urls.world)
            .await(self.render)
        // catch the resize
        //d3.select(window).on('resize', self.resize)

      // Add a transparent rect so that zoomMap works if user clicks on SVG
      //self.map.append("rect")
      //  .attr("class", "background")
      //  .attr("width", width)
      //  .attr("height", height)
      //  //.on("click", self.zoomMap)
      //  .on("mousemove", function(d) {
      //      var lonlat = map.invert(d3.mouse(this))
      //      var lonText = formatLongitude(lonlat[0])
      //      var latText = formatLatitude(lonlat[1])
      //      self.writeMouseLonLat(lonText, latText)
      //  })

      // Add g element to load country paths
      self.g = self.svg.append("g")
        .attr("id", "countries")
      // Load topojson data
      d3.json("/world.json", function(topology) {
        self.g.selectAll("path")
        //.data(topology.features)
        .data(topojson.object(topology, topology.objects.countries).geometries)
          .enter().append("path")
          .attr("d", self.path)
          .attr("id", function(d) {
            return d.properties.name.replace(/ /g,"_")
          })
          //.attr("class", data ? self.quantize : null)
          .on("mousemove", function(d) {
             // var lonlat = map.invert(d3.mouse(this))
            //  var lonText = formatLongitude(lonlat[0])
            //  var latText = formatLatitude(lonlat[1])
            //  self.writeMouseLonLat(lonText, latText)
          console.log("on mouse move");
          })
          .on("mouseover", function(d) {
              d3.select(this)
                .append("svg:title")
                //use CLDR to localize country name
                .text(d.properties.name)
   
          })
          .on("mouseout", function(d) {
             d3.select(this).select("title").remove()
      
          })
          .on("click", function(d) {
            var b = self.getBBox(d3.select(this))
            self.svg.selectAll("#"+self.country).style("opacity", 1)
            self.country = d.properties.name.replace(/ /g,"_")
            self.svg.selectAll("#"+self.country).style("opacity", 0)
            self.zoomMap(d, b)
          })
          // Remove Antarctica
          //self.g.select("#Antarctica").remove()
        })
      // Add icons - these go last as we want them to sit on top layer
      self.initLegendLabel()
      self.drawIcons()
    } // end drawMap
    this.render = function(err, world) {
      "use strict"
      console.log("we render")
      var countries = topojson.mesh(world, world.objects.countries)
      window.world = world
    }
    //this.resize = function() {
    //  "use strict"
    //  var clientWidth = document.documentElement.clientWidth
    //  console.log("we resize " + clientWidth)
    //}
    this.zoomMap = function(d, b) {
      "use strict"
      // get the ratio of the ViewBox height in relation to the country bbox height
      var ratio = b.height / height
      var x, y, k
      if (d && centered !== d) {
        var centroid = self.path.centroid(d)
        x = centroid[0]
        y = centroid[1]
        // FRANCE exception
        if (d.id !== "FRA") {
          k = 1/ratio - 1
        } else {
          k = 1/ratio
        }
        console.log(k, ratio)
        centered = d
        self.loadCountry(d, x, y, k)
      } else {
        // zoom out, this happens when user clicks on the same country
        x = width / 2
        y = height / 2
        k = 1
        centered = null
        // as we zoom out we want to remove the country layer
        self.svg.selectAll("#"+self.country).style("opacity", 1)
        self.svg.selectAll("#country").remove()
      }
      //select all the countries paths
      self.g.selectAll("path")
        .classed("active", centered && function(d) {
            return d === centered
            })

      self.g.transition()
        .duration(1000)
        .delay(100)
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
        .style("stroke-width", 0.5 / k + "px")
      
    } // end zoom function

    this.loadCountry = function(d, x, y, k) {
      "use strict"
      // we remove the country
      self.svg.selectAll("#country").remove()
      // load country json file
      var adm1_key = d.id+"_adm1"
      var adm1_path = "/"+d.id+"_adm1.json"
      // check to see if country file exists
      if (!self.fileExists(adm1_path)) {
        self.svg.selectAll("#"+self.country).style("opacity", 1)
        console.log("We couldn't find that country!")
      } else {
        console.log("Load country overlay")
        var country = self.svg.append("g").attr("id", "country")
        self.countryGroup = self.svg.select("#country")
        d3.json(adm1_path, function(error, topology) {
          var regions = topology.objects
          for(var adm1_key in regions) { 
            var o = regions[adm1_key]
          }
          self.countryGroup.selectAll("path")
            .data(topojson.object(topology, o).geometries)
            .enter().append("path")
            .attr("d", self.path)
            .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
            .attr("id", function(d) {
              return d.properties.NAME_1
            })
            .attr("title", function(d) {
              return d.properties.NAME_1
            })
            .classed("country", true)
            .attr("class", "country")
            .style("stroke-width", 1.5 / k + "px")
            .on("mouseover", function(d) {
              d3.select(this)
           //   .append("svg:title")
             // .text(d.properties.NAME_1)
            })
            .on("mouseout", function(d) {
              d3.select(this)
         //     d3.select(this).select("title").remove()
            })
            .on("click", function(d) {
              console.log('clicked on country')
              self.loadProjects()
            })
          })
        } // end else
    }

    this.loadProjects = function() {
      console.log('loadProjects')

    } // end loadProjects

    this.LonLat = function(d) {
      // get Lon/Lat of mouse
      console.log(map.invert(d3.mouse(d)))
    }
    this.loadMembers = function () {
        // Load data from .json file on page refresh
        var data = [{ city: 'Centreville',
              longitude: -77.46070098876953,
              latitude: 38.81589889526367,
              ip: '72.196.192.58',
              timestamp: 1342997755637 }]
        for ( var i in data ) { 
                this.drawMarker( data[i] ) 
            }
        console.log('we load members from db...')
    }

    this.drawMarker = function (message) {
        var longitude = message.longitude,
            latitude = message.latitude,
            text = message.title,
            city = message.city

        var coordinates = self.map([longitude, latitude])
            x = coordinates[0]
            y = coordinates[1]

        var member = self.svg.append("svg:path")
        member.attr("d", personPath)
        member.attr("transform", "translate(" + x + "," + y + ")scale(0.020)")
        member.style("fill", "steelblue")
        member.attr("class", "member")
        member.on("mouseover", function(){
            d3.select(this).transition()
            .style("fill", "red")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.035)")
        })
        member.on("mouseout", function() {
            d3.select(this).transition()
            .style("fill", "steelblue")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.020)")
        })

        var cityName = self.svg.append("svg:text")
            cityName.text(function(d) { return city })
            cityName.attr("x", x)
            cityName.attr("dy", y + 12)
            cityName.attr('text-anchor', 'middle')
            cityName.attr("class", "city-name")
            cityName.style("fill", "red")
            cityName.transition().delay(4000)
            .style("opacity", "0")
    }

	this.setMapStyle = function (style_name) {
		$("#countries").attr("class", style_name);
	}
    // Initialise
    this.init()
}).call(this);

jQuery(function($) {
	var socket = new eio.Socket();
  
  socket.on('open', function() {
    console.log('open');
    var data = {"what": "screensize", "w":window.innerWidth, "h":window.innerHeight};
    console.log (data);
    socket.send(JSON.stringify(data));
  });
  
  socket.on('message', function(data) {
    console.log('message received');

      try {
      var parsed = JSON.parse(data);
      }
      catch(e) {
      console.log('error', e.message);
      }
      console.log(parsed);
  });
  
  socket.on('close', function() {
      console.log('close');

      setTimeout(function() {
        socket.open();
      }, 5000);
  });
});
