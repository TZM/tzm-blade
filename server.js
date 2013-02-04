var blade = require('blade')
    ,express = require('express')
    ,http = require('http')
    ,https = require('https')
    ,fs = require('fs')
    ,nowjs = require('now')
    ,City = require('geoip').City,json;

var city = new City('data/GeoLiteCity.dat' );

var GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;

//var TABLE_ID = "1epTUiUlv5NQK5x4sgdy1K47ACDTpHH60hbng1qw";
var TABLE_ID ="1obpi0bmSDILX1cIQcVRNi1lUkm2K5xBFztmRFiM"

var GOOGLE_PATH = "/fusiontables/v1/query?sql=SELECT%20*%20FROM%20"+TABLE_ID+"&key="+GOOGLE_API_KEY;
var GOOGLE_DRIVE_PATH = "/drive/v2/files/"+TABLE_ID+"?key="+GOOGLE_API_KEY;

var options = {
    hostname: 'www.googleapis.com'
    ,port: 443
    ,method: 'GET'
};

var fileID = 'translation.json'

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
app.enable('trust proxy') // client ip address
app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.favicon(__dirname + '/public/images/favicon.ico'));
app.use(express.static(__dirname + '/public') ); //maybe we have some static files

//app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.static(__dirname + "/nowjs") );
app.set('views', __dirname + '/views'); //tells Express where our views are stored
try {
    app.set('languages', require(__dirname + '/public/locales/config.json'));
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

app.get('/stat/1.gif', function( req, res, next ) {
    var time = +new Date();
    var origin;
    res.writeHead(200, {'Content-Type': 'image/gif'});
    origin = /\/(.*)\.gif/.exec(req.url);
    if (origin) {
        var ip = req.headers['x-real-ip'];
        if (ip === null || ip === "127.0.0.1") {
            ip = "82.246.239.187";
        }
        city.lookup(ip, function(err, location) {
            var obj;
            if ( !err && location ) {
                obj = {
                    city: location.city
                    ,longitude: location.longitude
                    ,latitude: location.latitude
                    ,ip: ip
                    ,timestamp: time
                };
            } else { 
                console.log( 'server fake location' );
                obj ={ 
                    city: 'Bexleyheath',
                    longitude: 0.15000000596046448,
                    latitude: 51.45000076293945,
                    ip: '86.173.61.119',
                    timestamp: 1343054092459 
                };
            }
            everyone.now.receiveLocation(obj);
            console.log(obj);
        });
    console.log(origin[1], req.connection.remoteAddress, req.headers['user-agent']);
    } else {
        console.log( 'fixme no origin' );
    }
});

//app.get('/stat/1.gif', function( req, res ) {
//    var time = +new Date();
//    var origin;
//    res.writeHead(200, {'Content-Type': 'image/gif'});
//    origin = /\/(.*)\.gif/.exec(req.url);
//    console.log(origin);
//    if (origin) {
//        var ip = req.ip;
//        if (ip === null || ip === "127.0.0.1") {
//            ip = "82.246.239.187";
//        }
//        location = geoip.lookup(ip);
//        console.log(location);
//        var obj;
//        console.log(location.city);
//        console.log(location.ll[1]);
//        console.log(location.ll[0]);
//        obj = {
//            city: location.city
//            ,longitude: location.ll[1]
//            ,latitude: location.ll[0]
//            ,ip: ip
//            ,timestamp: time
//        };
//        console.log(obj);
//    everyone.now.receiveLocation(obj);
//    } else {
//        console.log( 'fixme no origin' );
//    }
//});



app.locals.pretty=true;
var server = app.listen(29080);
var everyone = nowjs.initialize(server);
console.log('Server running at http://127.0.0.1:29080/');
