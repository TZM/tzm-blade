jQuery(function($) {
  
  var user = $('[name="user"]').val();
  var csrf = $('[name="_csrf"]').val()
  
  if (navigator.id){
    navigator.id.watch({
      loggedInUser: user,
      onlogin: function(assertion) {
        if (user) return;
          $.ajax({ /* <-- This example uses jQuery, but you can use whatever you'd like */
            type: 'POST',
            url: '/social/persona', // This is a URL on your website.
            data: {assertion: assertion, _csrf: csrf},
            success: function(res, status, xhr) { 
              window.location.reload(); },
            error: function(xhr, status, err) {
              navigator.id.logout();
              alert("Login failure: " + err);
            }
          });
        
      },
      onlogout: function() {
        if (!user) return;
        $.ajax({ /* <-- This example uses jQuery, but you can use whatever you'd like */
            type: 'get',
            url: '/logout', // This is a URL on your website.
            success: function(res, status, xhr) { 
              window.location.reload() 
            },
            error: function(xhr, status, err) { 
              alert("Logout failure: " + err) 
            }
          });
        }
    })
  }


  var signinLink = document.getElementById('persona');
  if (signinLink) {
    signinLink.onclick = function() {
      navigator.id.request(); }
  }

  var signoutLink = document.getElementById('logout');
  if (signoutLink) {
    signoutLink.onclick = function() { navigator.id.logout(); };
  }

})
      