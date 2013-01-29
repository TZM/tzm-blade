var express = require('express')
  , blade = require('blade')
	, nowjs = require( 'now' )
	, City = require( 'geoip' ).City;

var city = new City('data/GeoLiteCity.dat' );

var app = express();
//app.use(blade.middleware(__dirname + '/views') ); //for client-side templates
app.use(express.static(__dirname + "/public") ); //maybe we have some static files
app.set('views', __dirname + '/views'); //tells Express where our views are stored
app.set('view engine', 'blade'); //Yes! Blade works with Express out of the box!
app.get('/', function(req, res, next) {
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
