//jQuery(function($) {
////
//    var setLng = $.url().param('setLng');
//    var setLngCookie = $.cookie('i18next');
//    var language;
//
//    if (setLngCookie) {
//        language = setLngCookie;
//    } else {
//        if (setLng) {
//            language_complete = setLng.split("-");
//        } else {
//            language_complete = navigator.language.split("-");
//        }
//
//        language = (language_complete[0]);
//    }
//
//    function setLanguage() {
//        // save to use translation function as resources are fetched
//        $("#page").i18n();
//        $("#language-menu").hide();
//    }
//
//    i18n.init({
//        lng: language,
//        debug: true
//    }, setLanguage);
//
//    // language selector
//    $("li.language-menu").on("click", function() {
//        $("#language-menu").toggle();
//        return false;
//    });
//    $("#language-menu a").on("click", function() {
//        var booReload = false; // TRUE = reload the page; FALSE = do not reload the page
//        var $this = $(this);
//        var value = $this.attr("id");
//        var arrValueParts = value.split("-");
//        var language = arrValueParts[1];
//
//        if (booReload) {
//            window.location.href = "/index.html?setLng=" + language;
//        } else {
//            i18n.init({
//                lng: language,
//                debug: true
//            }, setLanguage);
//        }
//
//        $("#language-menu a").removeClass("selected-language");
//        $this.addClass("selected-language");
//
//        return false;
//    });
//
//});
