var http = require('http')
    ,https = require('https')
    ,fs = require('fs'),json;

//var GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;
//
////var TABLE_ID = "1epTUiUlv5NQK5x4sgdy1K47ACDTpHH60hbng1qw";
//var TABLE_ID ="1obpi0bmSDILX1cIQcVRNi1lUkm2K5xBFztmRFiM"
//
//var GOOGLE_PATH = "/fusiontables/v1/query?sql=SELECT%20*%20FROM%20"+TABLE_ID+"&key="+GOOGLE_API_KEY;
//var GOOGLE_DRIVE_PATH = "/drive/v2/files/"+TABLE_ID+"?key="+GOOGLE_API_KEY;
//
//var options = {
//    hostname: 'www.googleapis.com'
//    ,port: 443
//    ,method: 'GET'
//};
//
//var fileID = 'translation.json'
//
//var lastModifiedDate = '';
//
//TZMNetwork(TABLE_ID);
//
//function TZMNetwork(fileId) {
//    if (fs.existsSync("../data/chapters.json")) {
//        // node.js is asynchronous and callback doesn't fire until later (next).
//        var x = '';
//        options["path"] = GOOGLE_DRIVE_PATH;
//        var req = https.request(options, function(res) {
//          res.on('data', function(d) {
//              x += d.toString();
//              //console.log(d.toString());
//          }).on('end', next);
//        });
//        req.end();
//        
//        req.on('error', function(e) {
//          console.error(e);
//        });
//        
//        function next() {
//            var l = JSON.parse(x);
//            var modifiedDate = l.modifiedDate.toString();
//            if (!lastModifiedDate === modifiedDate) {
//                console.log('chapters.json is out of date');
//                getChapters();
//            }
//            lastModifiedDate = l.modifiedDate.toString();
//        }
//        console.log('OK');
//    } else {
//        getChapters();
//    }
//}
//
//function getChapters() {
//    options["path"] = GOOGLE_PATH;
//    var file = fs.createWriteStream("data/chapters.json");
//    var req = https.request(options, function(res) {
//      res.on('data', function(data) {
//          file.write(data);
//      }).on('end', function() {
//          file.end();
//          console.log("chapters.json created");
//      });
//    });
//    req.end();
//    
//    req.on('error', function(e) {
//      console.error(e);
//    });
//}
//function dumpError(err) {
//  if (typeof err === 'object') {
//    if (err.message) {
//      console.log('\nMessage: ' + err.message)
//    }
//    if (err.stack) {
//      console.log('\nStacktrace:')
//      console.log('====================')
//      console.log(err.stack);
//    }
//  } else {
//    console.log('dumpError :: argument is not an object');
//  }
//}
//
//module.exports = function (app) {
//
//    app.configure(function () {
//        try {
//            app.set('chapters', require(__dirname + '/data/chapters.json'));
//        } catch(err) {
//          dumpError(err);
//          console.log('there is no /data/chapters.json');
//          app.set('chapters', []);
//        }
//    })
//}
//