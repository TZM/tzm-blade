jQuery(function($) {

  var user = $('[name="user"]').val();
  var csrf = $('[name="_csrf"]').val()
  
  if (navigator.id){
    navigator.id.watch({
      loggedInUser: user,
      onlogin: function(assertion) {
          
          $.ajax({ /* <-- This example uses jQuery, but you can use whatever you'd like */
            type: 'POST',
            url: '/social/persona', // This is a URL on your website.
            data: {assertion: assertion, _csrf: csrf},
            success: function(res, status, xhr) { navigator.id.request(); window.location.reload(); },
            error: function(xhr, status, err) {
              navigator.id.logout();
              alert("Login failure: " + err);
            }
          });
        
      },
      onlogout: function(assertion) {
        if (!user) return;
        var signoutLink = document.getElementById('logout');
        if (signoutLink){
          
          signoutLink.onclick = function() {
            window.location.href = "/logout"
          }
          
        }
      }
    })
  }


  var signinLink = document.getElementById('persona');
  if (signinLink) {
    signinLink.onclick = function() {
      console.log("button pressed");
      navigator.id.request(); }
  }else{
    "button not defined"
  }
  var signoutLink = document.getElementById('logout');
  if (signoutLink) {
    signoutLink.onclick = function() { navigator.id.logout(); };
  }

})
      