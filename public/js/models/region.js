//var country = function(regions, feature) {
//    this.regions = regions;
//    this.topojson = feature;
//}
// 
//// regions object containing the name, code of a specific region.
//// Also contains the topojson for this specific region.
//
//var regions = function(name, code, feature)  {
//    this.name = name;
//    this.code = code;
//    this.topojson = feature;
//};

//Define a model
var model = new blade.Model({
  "clicks": 0
});
//Render the view, passing the model along
$("body").render("buttonClick", model);