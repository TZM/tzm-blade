function mapClient() {
    var personPath = "m 1.4194515,-160.64247 c 33.5874165,0 60.8159465,-25.97005 60.8159465,-58.00952 0,-32.0404 -27.22755,-58.0114 -60.8159465,-58.0114 -33.5883965,0 -60.8159415,25.971 -60.8159415,58.0114 0,32.0404 27.228527,58.00952 60.8159415,58.00952 z m 81.9575765,26.25762 C 70.531608,-146.64352 55.269688,-153.983 0.08110256,-153.983 c -55.19742156,0 -70.08915856,7.96609 -82.28062656,19.59815 -12.197359,11.62926 -8.081167,135.7024419 -8.081167,135.7024419 L -63.292733,-59.848397 -46.325227,122.37766 2.6291765,29.116913 48.308878,122.37766 64.467298,-59.848397 91.457218,1.3175919 c 0,-8e-4 4.76917,-123.4484419 -8.08019,-135.7024419 z"
    if (! (this instanceof arguments.callee)) {
        return new arguments.callee(arguments)
    }
    var self = this
    var width = 960,
      height = 500,
      centered, data

    this.fileExists = function(url) {
        var http = new XMLHttpRequest()
        http.open('HEAD', url, false)
        http.send()
        return http.status!=404
    }
    
    this.getBBox = function(selection) {
        // get the DOM element from a D3 selection
        // you could also use "this" inside .each()
        var element = selection.node()
            // use the native SVG interface to get the bounding box
        return element.getBBox()
    }

    this.getCentroid = function(selection) {
        // get the DOM element from a D3 selection
        // you could also use "this" inside .each()
        var element = selection.node(),
            // use the native SVG interface to get the bounding box
            bbox = element.getBBox()
        // return the center of the bounding box
        return [bbox.x + bbox.width/2, bbox.y + bbox.height/2]
    }

    this.init = function() {
        //now.receiveLocation = function(message) {
        //    console.log(message)
        //    // FIXME only push markers depending on the country/adm1 level
        //    self.drawMarker(message)
        //}
            self.drawMap()
    }

    self.tooltip = undefined

    this.initLegendLabel = function(qtype) {
        "use strict"
        var display_string
        var rect_size
        if (this.admin_level === 0) {
            display_string = 'World'
        } else if (this.admin_level === 1) {
            display_string = ZMGC.index_continent.properties.CONTINENT
        } else if (this.admin_level === 2) {
            display_string = ZMGC.index_country.properties.NAME
        }

        self.LegendLabel = d3.select("svg").append("svg:text")
            .attr("id", "LegendLabel")
            .attr("class", "LegendLabel")
            .attr("transform", "translate(0, 280)")
            .attr("text-anchor", "left")
            .text(display_string)
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
                //var display_string
                
                //if (typeof index.id === 'undefined') {
                //    display_string = index.properties.region
                //} else if (ZMGC.admin_level === 0) {
                //    display_string = index.properties.CONTINENT
                //} else if (ZMGC.admin_level === 1 || ZMGC.admin_level === 2) {
                //    display_string = index.properties.NAME
                //}
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

    // Map code
    this.drawMap = function() {
      "use strict"
      var map = d3.geo.equirectangular().scale(150)
      self.path = d3.geo.path().projection(map)

      self.svg = d3.select("#map").append("svg")
        .attr("width", "100%")
        .attr("height", "89%")
        .attr("viewBox", "0 0 " + width + "  "+ height)
        .attr("preserveAspectRatio", "xMidYMid")

      // Add a transparent rect so that zoomMap works if user clicks on SVG
      self.svg.append("rect")
        .attr("class", "background")
        .attr("width", width)
        .attr("height", height)
        .on("click", self.zoomMap)

      // Add g element to load country paths
      self.g = self.svg.append("g")
        .attr("id", "countries")
      // Load topojson data
      d3.json("./topo/world.json", function(topology) {
        self.g.selectAll("path")
        //.data(topology.features)
        .data(topojson.object(topology, topology.objects.countries).geometries)
          .enter().append("path")
          .attr("d", self.path)
          .attr("id", function(d) {
            return d.properties.name
          })
          //.attr("class", data ? self.quantize : null)
          .on("mouseover", function(d) {
            d3.select(this)
            .style("fill", "orange")
            .append("svg:title")
            .text(d.properties.name)
            //self.activateTooltip(d.properties.name)
          })
          .on("mouseout", function(d) {
            d3.select(this)
            .style("fill", "#aaa")
            //self.deactivateTooltip()
          })
          .on("click", self.zoomMap)
          // Remove Antarctica
          self.g.select("#Antarctica").remove()
        })
    } // end drawMap

    this.zoomMap = function(d) {
      "use strict"
      var x, y, k

      if (d && centered !== d) {
        var centroid = self.path.centroid(d)
        x = centroid[0]
        y = centroid[1]
        k = 2
        centered = d
        self.loadCountry(d, x, y, k)
      } else {
        // zoom out, this happens when user clicks on the same country
        x = width / 2
        y = height / 2
        k = 1
        self.centered = null
        // as we zoom out we want to remove the country layer
        self.svg.selectAll("#country").remove()
      }

      self.g.selectAll("path")
        .classed("active", centered && function(d) { return d === centered })

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
      var adm1_path = "./topo/"+d.id+"_adm1.json"

      // check to see if country file exists
      if (!self.fileExists(adm1_path)) {
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
            .classed("country", true)
            .attr("class", "country")
            .style("stroke-width", 1.5 / k + "px")
            .on("mouseover", function(d) {
              d3.select(this)
              .style("fill", "#6C0")
              .append("svg:title")
              .text(d.properties.NAME_1)
            })
            .on("mouseout", function(d) {
              d3.select(this)
              .style("fill", "#000000")
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

        //console.log($(member.node))
        //var hoverFunc = function () {
        //    console.log('hoverFunc')
        //    //person.attr({
        //    //    fill: 'white'
        //    //})
        //    //$(title.node).fadeIn('fast')
        //    //$(subtitle.node).fadeIn('fast')
        //}
        //
        //var hideFunc = function () {
        //    console.log('hideFunc')
        //    //person.attr({
        //    //    fill: '#ff9'
        //    //})
        //    //$(title.node).fadeOut('slow')
        //    //$(subtitle.node).fadeOut('slow')
        //}
        //$(member.node).hover(hoverFunc, hideFunc)
    }
    // Initialise
    this.init()
}

var mapClient

jQuery(function() {
  mapClient = new mapClient()
  $(window).bind("load resize", mapClient.onResize)
})