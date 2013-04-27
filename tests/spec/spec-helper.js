(function() {
  var Requester, request;

  request = require("request");

  Requester = (function() {

    function Requester() {}

    Requester.prototype.get = function(path, callback) {
      return request("http://localhost:9080" + path, callback);
    };

    Requester.prototype.post = function(path, body, callback) {
      return request.post({
        url: "http://localhost:9080" + path,
        body: body
      }, callback);
    };

    return Requester;

  })();

  exports.withServer = function(callback) {
    var app, stopServer;
    asyncSpecWait();
    app = require("../../lib/app.coffee").app;
    stopServer = function() {
      app.close();
      return asyncSpecDone();
    };
    app.listen(3000);
    return callback(new Requester, stopServer);
  };

}).call(this);
