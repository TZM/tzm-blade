var express = require('express'),
    blade = require('blade');
//var app = express.createServer();
var app = express();
app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.static(__dirname + "/public") ); //maybe we have some static files
app.set('views', __dirname + '/views'); //tells Express where our views are stored
app.set('translation', require(__dirname + '/public/locales/dev/translation.json'));
app.set('view engine', 'blade'); //Yes! Blade works with Express out of the box!
app.get('/', function(req, res, next) {
    res.render('index');
});
app.listen(29080);
console.log('Server running at http://127.0.0.1:29080/');