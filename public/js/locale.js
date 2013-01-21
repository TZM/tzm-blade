jQuery(function($) {

  var setLng = $.url().param('setLng');
  var setLngCookie = $.cookie('i18next');
	var language;

  if (setLngCookie) {
		language = setLngCookie;
  }
  else {
		if (setLng) {
			language_complete = setLng.split("-");
		} else {
			language_complete = navigator.language.split("-");
		}

		language = (language_complete[0]);
  }

  //Build the language selector.
	$.getJSON("../locales/config.json", function(objData) {
	  var arrHtml = [];
		var strClass;

	  $.each(objData, function(strKey, objLanguage) {
			strClass = (language == objLanguage.locale) ? " class=\"selected-language\"" : ""; //Make sure the language selector has the correct language selected on initial page load.
			arrHtml.push("<a id=\"lang-" + objLanguage.locale + "\" data-i18n=\"language." + objLanguage.locale + "\"" + strClass + "></a>");
	  });

	  $("<div/>", {
			'class': 'language-list',
			html: arrHtml.join('')
	  }).appendTo('#language-menu');

		$("li.language-menu").live("click", function(){
			$("#language-menu").toggle();
			return false;
		});
	});

  function setLanguage() {
    // save to use translation function as resources are fetched
    $(".tzm-i18n").i18n();
    $(".page-i18n").i18n();
    $(".menu").i18n();
    $(".user-menu").i18n();
    $(".search-form").i18n();
    $(".footer-i18n").i18n();

		$("#language-menu").hide();
  }

  i18n.init({
    lng: language,
    debug: true
  }, setLanguage);

  // language selector
  $("#language-menu a").live("click", function() {
    var booReload = false; // TRUE = reload the page; FALSE = do not reload the page
		var $this = $(this);
    var value = $this.attr("id");
    var arrValueParts = value.split("-");
    var language = arrValueParts[1];

    if (booReload) {
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
