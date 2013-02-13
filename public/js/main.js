//Define a model
var model = new blade.Model({
  "clicks": 0
});
//Render the view, passing the model along
$("body").render("index", model);
