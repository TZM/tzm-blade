var blade = require('blade')
    ,express = require('express')
    ,http = require('http')
    ,https = require('https')
    ,fs = require('fs'),json;

var GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;

var TABLE_ID = "1epTUiUlv5NQK5x4sgdy1K47ACDTpHH60hbng1qw";
//var TABLE_ID ="1obpi0bmSDILX1cIQcVRNi1lUkm2K5xBFztmRFiM"

var GOOGLE_PATH = "/fusiontables/v1/query?sql=SELECT%20*%20FROM%20"+TABLE_ID+"&key="+GOOGLE_API_KEY;
var GOOGLE_DRIVE_PATH = "/drive/v2/files/"+TABLE_ID+"?key="+GOOGLE_API_KEY;

var options = {
    hostname: 'www.googleapis.com'
    ,port: 443
    ,method: 'GET'
};

function TZMNetwork(fileId) {
    if (fs.existsSync("data/chapters.json")) {
        // ... put code if "data/chapters.json" has changed!
        console.log('OK');
    } else {
        options["path"] = GOOGLE_PATH;
        
        var file = fs.createWriteStream("data/chapters.json");
        var req = https.request(options, function(res) {
          res.on('data', function(data) {
              file.write(data);
          }).on('end', function() {
              file.end();
              console.log("chapters.json created");
          });
        });
        req.end();
        
        req.on('error', function(e) {
          console.error(e);
        });
    }
}

var app = express();
app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));
app.use(express.static(__dirname + '/public') ); //maybe we have some static files
app.set('views', __dirname + '/views'); //tells Express where our views are stored
app.set('translation', require(__dirname + '/public/locales/dev/translation.json'));
app.set('chapters', require(__dirname + '/data/chapters.json'));
app.set('view engine', 'blade'); //Yes! Blade works with Express out of the box!
app.get('/', function(req, res, next) {
    TZMNetwork(TABLE_ID);
    res.render('index');
});
app.listen(29080);
console.log('Server running at http://127.0.0.1:29080/');