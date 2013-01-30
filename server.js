var blade = require('blade')
    ,express = require('express')
    ,http = require('http')
    ,https = require('https')
    ,fs = require('fs')
    ,nowjs = require('now')
    ,City = require('geoip').City,json;

var city = new City('data/GeoLiteCity.dat' );

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

var lastModifiedDate = '';

TZMNetwork(TABLE_ID);

function TZMNetwork(fileId) {
    if (fs.existsSync("data/chapters.json")) {
        // node.js is asynchronous and callback doesn't fire until later (next).
        var x = '';
        options["path"] = GOOGLE_DRIVE_PATH;
        var req = https.request(options, function(res) {
          res.on('data', function(d) {
              x += d.toString();
              //console.log(d.toString());
          }).on('end', next);
        });
        req.end();
        
        req.on('error', function(e) {
          console.error(e);
        });
        
        function next() {
            var l = JSON.parse(x);
            var modifiedDate = l.modifiedDate.toString();
            if (!lastModifiedDate === modifiedDate) {
                console.log('chapters.json is out of date');
                getChapters();
            }
            lastModifiedDate = l.modifiedDate.toString();
        }
        console.log('OK');
    } else {
        getChapters();
    }
}

function getChapters() {
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

function dumpError(err) {
  if (typeof err === 'object') {
    if (err.message) {
      console.log('\nMessage: ' + err.message)
    }
    if (err.stack) {
      console.log('\nStacktrace:')
      console.log('====================')
      console.log(err.stack);
    }
  } else {
    console.log('dumpError :: argument is not an object');
  }
}

var app = express();
app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));
app.use(express.static(__dirname + '/public') ); //maybe we have some static files
//app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.static(__dirname + "/public") ); //maybe we have some static files
app.set('views', __dirname + '/views'); //tells Express where our views are stored
try {
    app.set('translation', require(__dirname + '/public/locales/dev/translation.json'));
    app.set('chapters', require(__dirname + '/data/chapters.json'));
} catch(err) {
  dumpError(err);
  console.log('there is no /data/chapters.json');
  app.set('chapters', []);
}
app.set('view engine', 'blade'); //Yes! Blade works with Express out of the box!
app.get('/', function(req, res, next) {
    TZMNetwork(TABLE_ID);
    console.log(lastModifiedDate);
    res.render('index');
});

app.get( '/map', function( req, res, next ) { 
    var ip = ( req.connection.remoteAddress !== "127.0.0.1" )?
    req.connection.remoteAddress: "72.196.192.58";
    city.lookup( ip, function( err, loc ) { 
        if ( err ) { 
            loc = {};
        }
        res.render( 'map', { loc: loc } );
    });
});

app.locals.pretty=true;
app.listen(29080);
console.log('Server running at http://127.0.0.1:29080/');
