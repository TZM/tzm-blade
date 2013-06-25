jQuery(function($) {

    var socket;

    socket = io.connect("http://localhost:3000");

    socket.on("change", function(data) {
      var text;
      if (data.message) {
        console.log(data.message);
        console.log(data.file);
      } else {
        return console.log("There is a problem:", data);
      }
    });

});
