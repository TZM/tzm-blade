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

    function setLanguage() {
        // save to use translation function as resources are fetched
        $("#page").i18n();
        $(".tzm-i18n").i18n();
        $(".project-select").i18n();
        $(".menu").i18n();
        $(".user-menu").i18n();
        //$(".search-form").i18n();
        $("#footer").i18n();
        //$(".section").i18n();
        //$(".sub-section").i18n();
        $("#language-menu").hide();
    }

    i18n.init({
        lng: language,
        debug: true
    }, setLanguage);

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
            window.location.href = "/index.html?setLng=" + language;
        } else {
            i18n.init({
                lng: language,
                debug: true
            }, setLanguage);
        }

        $("#language-menu a").removeClass("selected-language");
        $this.addClass("selected-language");

        return false;
    });
});
