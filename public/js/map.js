function mapClient() {
    var personPath = "m 1.4194515,-160.64247 c 33.5874165,0 60.8159465,-25.97005 60.8159465,-58.00952 0,-32.0404 -27.22755,-58.0114 -60.8159465,-58.0114 -33.5883965,0 -60.8159415,25.971 -60.8159415,58.0114 0,32.0404 27.228527,58.00952 60.8159415,58.00952 z m 81.9575765,26.25762 C 70.531608,-146.64352 55.269688,-153.983 0.08110256,-153.983 c -55.19742156,0 -70.08915856,7.96609 -82.28062656,19.59815 -12.197359,11.62926 -8.081167,135.7024419 -8.081167,135.7024419 L -63.292733,-59.848397 -46.325227,122.37766 2.6291765,29.116913 48.308878,122.37766 64.467298,-59.848397 91.457218,1.3175919 c 0,-8e-4 4.76917,-123.4484419 -8.08019,-135.7024419 z";
    if (! (this instanceof arguments.callee)) {
        return new arguments.callee(arguments);
    }
    var self = this;
    var cw = 100,
        ch = 260;

    this.init = function() {
        now.receiveLocation = function(message) {
            console.log(message);
            self.drawMarker(message);
        };
            self.drawMap();
    };

    this.drawSVG = function(x, y, k) {
        // Most parts of D3 don"t know anything about SVG—only DOM.
        var width = $("#map").width();
        self.svg = d3.select("#map").append("svg:svg")
        .attr({
            class:"svg", 
            width:"100%", 
            height:"92%"
        })
        .attr("viewBox", "0 0 " + cw + "  "+ ch);

        self.map = d3.geo.equirectangular().translate([50, 100]) 
              .scale(80) 
              .rotate([-8, 0]) 
              .center([0, 37.7750]);

        self.projection = d3.geo.path().projection(self.map);
        self.svg.on("click", function() {
           var p = d3.mouse(this);                                                                     
           console.log(p+" "+self.map.invert(p));                                                          
           self.map.center(self.map.invert(p));
           self.svg.selectAll("path").attr("d", path);                                                      

        });
    }

    this.drawMap = function() {
        var x = 0,
            y = 0,
            k = 120;
        self.drawSVG(x, y, k);
        //self.map.translate([50, 150]);
        //self.svg.attr("viewBox", "0 0 " + cw + "  "+ ch);
        self.svg.append("g")
            .attr("id", "countries");

        self.svg.on("click", function() {
            var p = d3.mouse(this);                                                                     
            console.log(p+" "+self.map.invert(p));                                                          
            self.map.center(self.map.invert(p));
            // self.svg.selectAll("path").attr("d", path);                                                      

        });
        self.countriesGroup = self.svg.select("#countries");
        // Load data from .json file
        d3.json("../topo/world.json", function(error, topology) {
            self.countriesGroup.selectAll("path") // select all the current path nodes
                .data(topojson.object(topology, topology.objects.countries).geometries)
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
            })
            .on("mouseout", function(d) {
                d3.select(this)
                .style("fill", "#000000");
            })
            self.countriesGroup.select("#Antarctica").remove();
        });
        self.loadMembers();
    }

    this.clickCountry = function(d) {
        var x = 0,
            y = 0,
            k = 150;
        //d3.select("#map").remove();
        self.drawSVG(x, y, k);
        self.map.translate([50, 150]);
        self.svg.attr("viewBox", "0 0 " + cw/2 + "  "+ ch);
        //self.map.translate([cw, ch]);
        self.svg.append("g")
            .attr("id", "country");
        self.svg.append("g")
            .attr("id", "points");
        self.regionsGroup = self.svg.select("#country");
        d3.json("../topo/"+d.id+"_adm1.json", function(json) {
            console.log(json.features);
            self.regionsGroup.selectAll("path")
            .data(topojson.object(topology, topology.objects.regions).geometries)
            .enter().append("path")
            .attr("d", self.projection)
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
            })
            .on("mouseout", function(d) {
                d3.select(this)
                .style("fill", "#000000");
            })
            .on("click", function(d) {
                console.log('clicked on country')
            });
        });
        //self.loadMembers();
    }
    
    this.loadMembers = function () {
        // Load data from .json file on page refresh
        var data = [{ city: 'Centreville',
              longitude: -77.46070098876953,
              latitude: 38.81589889526367,
              ip: '72.196.192.58',
              timestamp: 1342997755637 }];
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
        });

        var cityName = self.svg.append("svg:text");
            cityName.text(function(d) { return city; })
            cityName.attr("x", x)
            cityName.attr("dy", y + 12)
            cityName.attr('text-anchor', 'middle')
            cityName.attr("class", "city-name")
            cityName.style("fill", "red")
            cityName.transition().delay(4000)
            .style("opacity", "0");

        //console.log($(member.node));
        //var hoverFunc = function () {
        //    console.log('hoverFunc');
        //    //person.attr({
        //    //    fill: 'white'
        //    //});
        //    //$(title.node).fadeIn('fast');
        //    //$(subtitle.node).fadeIn('fast');
        //};
        //
        //var hideFunc = function () {
        //    console.log('hideFunc');
        //    //person.attr({
        //    //    fill: '#ff9'
        //    //});
        //    //$(title.node).fadeOut('slow');
        //    //$(subtitle.node).fadeOut('slow');
        //};
        //$(member.node).hover(hoverFunc, hideFunc);
    }
    // Initialise
    this.init();
};

var mapClient;

jQuery(function() {
  mapClient = new mapClient();
});