jQuery(function($) {

  // project toggle
  var projectToggle = $( ".projects" ).on( "click", function( event ) {
    event.preventDefault();

    if ( projectToggle.hasClass( "active" ) ) {
      projectToggle.removeClass( "active" );
      $( "body" ).css( "marginTop", 0 );
    } else {
      projectToggle.addClass( "active" );
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
      if ($.browser.opera) {
        $('html').animate({
          scrollTop: scrollPos + 'px'
        }, 300);
      } else {
        $('html, body').animate({
          scrollTop: scrollPos + 'px'
        }, 300);
      }
      slide = true;
    } else {
      slide = false;
    }
  });
  $('.map').on('click', function() {
    console.log('click on map button');
    //$('#page:first').empty().load('map.html');
    //ZmgcClient();
    blade.Runtime.loadTemplate("map.blade", function(err, tmpl) {
        tmpl({
        }, function(err, html) {
            if(err) throw err;
                console.log(html);
                $('#page:first').empty().html(html);
        });
    });
  });
  $('.guide').on('click', function() {
    console.log('click on guide button');
    blade.Runtime.loadTemplate("guide.blade", function(err, tmpl) {
        tmpl({
            'nav1': {
                'Home': '/',
                'About Us': '/about',
                'Contact': '/contact'
            }
        }, function(err, html) {
            if(err) throw err;
                console.log(html);
                $('#page:first').empty().html(html);
        });
    });
  });
});


//function loadPage(evt){
//
//}
