function ZmgcMenu() {
  var self = this;

  this.init = function() {
      self.leftNavToggle();
      self.leftMenuToggle();
  };
  // left-navigation block toggle
  this.leftNavToggle = function () {
    var leftNavToggle = $( "#nav-toggle" ).on( "click", function( event ) {
      event.preventDefault();
      if ( leftNavToggle.hasClass( "active" ) ) {
        leftNavToggle.removeClass( "active" );
        leftNavToggle.css( "marginLeft",  230 );
        $( "#nav-container" ).css( "marginLeft", 0 );
        $( ".content" ).removeClass("open");
      } else {
        leftNavToggle.addClass( "active" );
        leftNavToggle.css( "marginLeft", -15 );
        $( "#nav-container" ).css( "marginLeft", -245 );
        $( ".content" ).toggleClass("open");
      }
    });
  }
  // left menu open / close
  this.leftMenuToggle = function () {
    $('#nav-container').on('click', '.section', function( event ) {
        event.preventDefault();
        $('a.nav-link.active').removeClass('active');
        var $shortcut = $(this).next();
        $('#nav-container ul.active').not($shortcut).removeClass('active');
        $shortcut.andSelf().toggleClass('active').find(".menu-toggle").toggleClass("open");
    });
  }

  // Load page
  $('a.nav-link').on('click', function( event ) {
      event.preventDefault();
      var $this = $(this);
      var $shortcut = $(this).next();
      $('a.nav-link.active').not($shortcut).removeClass('active');
      $shortcut.andSelf().toggleClass('active');
      var section =  $this.closest('ul').prev('h3').find('span[data-content]').data('content');
      var subSection = $this.attr("data-bind");
      // we can now genrate the section content and push this into the tmpl.
      blade.Runtime.loadTemplate("guide_section.blade", function(err, tmpl) {
          tmpl({
              'sections': {
                      'section': section,
                      'subsection': subSection
                  }
          }, function(err, html) {
              if(err) throw err;
                  $('.mainarticle > .content').empty().html(html);
                  var page = "./guide/page"+subSection+".blade";
                  blade.Runtime.loadTemplate(page, function(err, tmpl) {
                      tmpl({}, function(err, html) {
                          if(err) throw err;
                            console.log(html);
                            $('.guide_content').empty().html(html);
                      });
                });
          });
      });
  });

  // Initialise
  this.init();
};

var ZmgcMenu;

jQuery(function() {
  ZmgcMenu = new ZmgcMenu();
});