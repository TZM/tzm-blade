var country = function(regions, feature) {
    this.regions = regions;
    this.topojson = feature;
}
 
// regions object containing the name, code of a specific region.
// Also contains the topojson for this specific region.

var regions = function(name, code, feature)  {
    this.name = name;
    this.code = code;
    this.topojson = feature;
};