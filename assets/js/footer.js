$(function($) {

  // project toggle
  var projectToggle = $( ".projects" ).on( "click", function( event ) {
    event.preventDefault();

    if ( projectToggle.hasClass( "active" ) ) {
      projectToggle.removeClass( "active" );
      $( "body" ).css( "marginTop", 0 );
      $( "#page" ).css( "padding-top", 30 );
    } else {
      projectToggle.addClass( "active" );
      // if on Guide page, we need to close the #nav-container
      if ($( "#nav-toggle" ).hasClass( "" )) {
          $( "#nav-toggle" ).addClass( "active" ).css( "marginLeft", -5 );
          $( "#nav-container" ).css( "marginLeft", -235 );
          $( ".content" ).toggleClass("open");
      }
      $( "body" ).css( "marginTop", 191 );
      $( "#page" ).css( "padding-top", 10 );
      
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
  
  //don't close login form
  $(".forgot-password").click(function(e){
  //do something
  console.log("click")
  //e.preventDefault();
  });

  $('.user-login-register-form').click(function (e) {
      e.preventDefault(); $(this).tab('show');
  });
  $('.user-login-register-form a:first').tab('show');
  
  //$('.user-login-form').click(function (e) {
  //    e.preventDefault(); $(this).tab('show');
  //});
  //$('.user-login-form a:first').tab('show');

  // SPA page loads
  $('.forums').on('click', function() {
    console.log('click on forums button');
    //ZmgcClient();
    blade.Runtime.loadTemplate("guide/page0.blade", function(err, tmpl) {
        tmpl({}, function(err, html) {
            if(err) throw err;
                console.log(html);
                $('#page:first').empty().html(html);
        });
    });
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
