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
        $("#language-menu").hide();
        // translate page
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
        var lang = i18n.lng();
        console.log(lang);
        
        var windowReload = false; // TRUE = reload the page; FALSE = do not reload the page
        var $this = $(this);
        var value = $this.attr("id");
        console.log(value);
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
