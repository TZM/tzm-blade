
jQuery(function($) {

    var socket;

    socket = io.connect("http://localhost:3001");

    socket.on("change", function(data) {
      // console.log(arguments);
      var text;
      if (data.message) {
        document.cookie["cldr"] = data.file

      } else {
        return console.log("There is a problem:", data);
      }
    });

});
