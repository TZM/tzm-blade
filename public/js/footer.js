jQuery(function($) {

  // project toggle
  var projectToggle = $( ".projects" ).on( "click", function( event ) {
    event.preventDefault();

    if ( projectToggle.hasClass( "active" ) ) {
      projectToggle.removeClass( "active" );
      $( "body" ).css( "marginTop", 0 );
    } else {
      projectToggle.addClass( "active" );
      // if on Guide page, we need to close the #nav-container
      if ($( "#nav-toggle" ).hasClass( "" )) {
          $( "#nav-toggle" ).addClass( "active" ).css( "marginLeft", -5 );
          $( "#nav-container" ).css( "marginLeft", -235 );
          $( ".content" ).toggleClass("open");
      }
      $( "body" ).css( "marginTop", 150 );
      
    }
  });

  $( document ).click(function( event ) {
    var target = $( event.target );
    if ( target.closest( ".project-select, .projects" ).length ||
    !projectToggle.hasClass( "active" ) ) {
      return;
    }

    projectToggle.removeClass( "active" );
    $( "body" ).css( "marginTop", 0 );
  });
  
  // open login form
  $('#login').click(function (e) {
    console.log('click on login');
    $('#user-login-register-form').toggleClass( "show" ).load('/users/login.html');
    e.stopPropagation();
  });

  // footer navigation
  var slide = false;
  var height = $('#footer').height();
  $('#footer_trigger').click(function() {
    var docHeight = $(document).height();
    var windowHeight = $(window).height();
    var scrollPos = docHeight - windowHeight + height;
    $('#footer').animate({
      height: "toggle"
    }, 300);
    $("#footer_trigger").toggleClass("trigger_active");
    if (slide == false) {
        $('html, body').animate({
          scrollTop: scrollPos + 'px'
        }, 300);
      slide = true;
    } else {
      slide = false;
    }
  });

});


//function loadPage(evt){
//
//}
