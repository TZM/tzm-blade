function ZmgcClient() {
    var personPath = "m 1.4194515,-160.64247 c 33.5874165,0 60.8159465,-25.97005 60.8159465,-58.00952 0,-32.0404 -27.22755,-58.0114 -60.8159465,-58.0114 -33.5883965,0 -60.8159415,25.971 -60.8159415,58.0114 0,32.0404 27.228527,58.00952 60.8159415,58.00952 z m 81.9575765,26.25762 C 70.531608,-146.64352 55.269688,-153.983 0.08110256,-153.983 c -55.19742156,0 -70.08915856,7.96609 -82.28062656,19.59815 -12.197359,11.62926 -8.081167,135.7024419 -8.081167,135.7024419 L -63.292733,-59.848397 -46.325227,122.37766 2.6291765,29.116913 48.308878,122.37766 64.467298,-59.848397 91.457218,1.3175919 c 0,-8e-4 4.76917,-123.4484419 -8.08019,-135.7024419 z";
    if (! (this instanceof arguments.callee)) {
        return new arguments.callee(arguments);
    }
    var self = this;

    this.init = function( initialLocation ) {
        now.receiveLocation = function(message) {
            self.drawMarker(message);
        };
        if ($('#map').length > 0) {
            console.log('we have a map id');
            self.drawMap();
            self.loadMembers();
        }
        if ( initialLocation ) { 
            self.drawMarker( initialLocation );
        }
    };

    this.drawMap = function() {
        var cw = 1024;
        var ch = 768;
      var data;
      var width = $("#map").width();

      // Most parts of D3 don"t know anything about SVG—only DOM.
      self.svg = d3.select("#map").append("svg:svg")
        .attr({
            class:"svg", 
            width:"100%", 
            height:"92%"
        })
        .attr("viewBox", "0, 0, " + [cw, ch])
        .append("g")
            .attr("transform", "translate(" + [0, 0] + ")");
      
      //circle
      self.svg.append("circle")
        .attr({
          cx: cw/2,
          cy: ch/2,
          r: 350,
          fill: "#DDD9C5",
          "stroke-width": 0
        });

      self.svg.append("g")
        .attr("id", "countries");

      self.svg.append("g")
        .attr("id", "points");
        
      self.map = d3.geo.equirectangular()
          .scale(225)
          .translate([cw/2, ch/2]);
      
      self.projection = d3.geo.path().projection(self.map);
      
      self.countriesGroup = self.svg.select("#countries");
      // Load data from .json file
      d3.json("../world-countries.json", function(json) {
          self.countriesGroup.selectAll("path") // select all the current path nodes
          .data(json.features) // bind these to the features array in json
          .enter().append("path") // if not enough elements create a new path
          .attr("d", self.projection) // transform the supplied jason geo path to svg
          .attr("id", function(d) {
              return d.properties.name;
          })
          .classed("country", true)
          .attr("class", "country")
          .on("mouseover", function(d) {
              d3.select(this)
                .style("fill", "#6C0")
                .append("svg:title")
                .text(d.properties.name);
          }).on("mouseout", function(d) {
              d3.select(this)
                .style("fill", "#000000");
          })
          self.countriesGroup.select("#Antarctica").remove();
      });
    }

    this.loadMembers = function () {
        // Load data from .json file on page refresh
        var data = [{ city: 'Centreville',
              longitude: -77.46070098876953,
              latitude: 38.81589889526367,
              ip: '72.196.192.58',
              timestamp: 1342997755637 },
          { city: 'Leeds',
              longitude: -1.583299994468689,
              latitude: 53.79999923706055,
              ip: '86.160.103.204',
              timestamp: 1343029940099 }];
        for ( var i in data ) { 
                this.drawMarker( data[i] ) ;
            }
        console.log('we load members from db...')
    }

    this.drawMarker = function (message) {
        var longitude = message.longitude,
            latitude = message.latitude,
            text = message.title,
            city = message.city;

        var coordinates = self.map([longitude, latitude]);
            x = coordinates[0];
            y = coordinates[1];

        var member = self.svg.append("svg:path");
        member.attr("d", personPath)
        member.attr("transform", "translate(" + x + "," + y + ")scale(0.035)")
        member.style("fill", "steelblue")
        member.attr("class", "member")
        member.on("mouseover", function(){
            d3.select(this).transition()
            .style("fill", "red")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.07)")
        })
        member.on("mouseout", function() {
            d3.select(this).transition()
            .style("fill", "steelblue")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.035)")
        });

        $(member.node).hover(console.log('hover'));

        var cityName = self.svg.append("svg:text");
            cityName.text(function(d) { return city; })
            cityName.attr("x", x)
            cityName.attr("dy", y + 12)
            cityName.attr('text-anchor', 'middle')
            cityName.attr("class", "city")
            cityName.transition().delay(4000)
            .style("opacity", "0");

        //var hoverFunc = function () {
        //  member.attr({fill:"#ff9"});
        //  $(cityName.node).fadeIn("fast");
        //$(subtitle.node).fadeIn("fast");
        //};
        //var hideFunc = function () {
        //  member.attr({fill:"red"});
        //  $(cityName.node).fadeOut("slow");
        //  //$(subtitle.node).fadeOut("slow");
        //};
        //
        //$(member.node).hover(hoverFunc, hideFunc);

        //member.animate(2000, "elastic", function () {
        //  $(cityName.node).fadeOut(5000);
        //  //$(subtitle.node).fadeOut(5000);
        //});
    }
    this.enlargeMarker = function mouseover(d) {
        this.parentNode.appendChild(this);
        d3.select(this).transition()
        .duration(750)
        .attr("transform", "translate(480,480)scale(23)rotate(180)")
        .transition()
        .delay(1500)
        .attr("transform", "translate(240,240)scale(10)")
        .style("fill-opacity", 10)
        //.remove();
    }
    // Initialise
    this.init();
};

var ZmgcClient;

jQuery(function() {
  ZmgcClient = new ZmgcClient();
});