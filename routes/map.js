/*
* GET D3 gets a model which has an array of Chapters, Projects and Members
* Generates the initial map view on the server to improve performance
*/

exports.blade = function(req, res, next){
  res.render('map.blade');
};