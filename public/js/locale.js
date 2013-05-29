jQuery(function($) {
    var setLng = $.url().param('setLng');
    var setLngCookie = $.cookie('i18next');
    var language;

    if (setLngCookie) {
        language = setLngCookie;
    } else {
        if (setLng) {
            language_complete = setLng.split("-");
        } else {
            language_complete = navigator.language.split("-");
        }

        language = (language_complete[0]);
    }

    $("#remember_me").click(function(e) {
      if ($("#remember_me").val() == "off"){
        $("#password").attr("disabled", true)
        $(".btn-continue").removeClass("hidden")
        $(".btn-login").addClass("hidden")
        $("#email").focus()
        $("#form_login_user").attr("action", "user/create")
        $("#remember_me").val("on")
      }else{
        $("#password").attr("disabled", false)
        $(".btn-continue").addClass("hidden")
        $(".btn-login").removeClass("hidden")
        $("#form_login_user").attr("action", "user/login")
        $("#remember_me").val("off")
      }
    })

    function setLanguage() {
        // save to use translation function as resources are fetched
        $("title").i18n();
        $(".welcome").i18n();
        $("#nav-container").i18n();
        $(".project-select").i18n();
        $(".menu").i18n();
        $(".user-menu").i18n();
        $(".sub-section").i18n();
        $("#remember_me").i18n()
        $("#footer").i18n();
        $("#language-menu").hide();

    }

   // language selector
   $("li.language-menu").on("click", function() {
       $("#language-menu").toggle();
       return false;
   });
    $("#language-menu a").on("click", function() {
        var windowReload = false; // TRUE = reload the page; FALSE = do not reload the page
        var $this = $(this);
        var value = $this.attr("id");
        var arrValueParts = value.split("-");
        var language = arrValueParts[0];

        if (windowReload) {
            window.location.href = "/?lang=" + language;
        } else {
            console.log(language);
            i18n.setLng(language, location.reload());
            i18n.init({
                lng:language
                ,debug:true
            }, setLanguage);
        }

        $("#language-menu a").removeClass("selected-language");
        $this.addClass("selected-language");

        return false;
    });
});
