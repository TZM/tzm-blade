# Localization of site

We use [IETF language tag](http://en.wikipedia.org/wiki/IETF_language_tag) to specify which language the user wants to see the content in, this is done by creating a folder within the /locals/ directory containing a copy of the /locals/dev/translation.json file.


[Creating localizable web applications](https://developer.mozilla.org/en-US/docs/Web_Localizability/Creating_localizable_web_applications)

## How to extract all the template html content and generate the JSON file for a specific localization.

i18next-conv converts files from gettext (.mo/.po) to i18next's json format and vice versa. This will allow the translation team to use tools such as [POEdit](http://www.poedit.net/) and then convert this to JSON to use within this application.

## Libraries to consider

[https://github.com/papandreou/node-cldr/](https://github.com/papandreou/node-cldr/)
[http://translationproject.org/html/welcome.html](http://translationproject.org/html/welcome.html)

[http://unicode.org/Public/cldr/latest/core.zip](http://unicode.org/Public/cldr/latest/core.zip)

## Procedure
Please replace `languageCode-countryCode` with the ones for your language and country, you can get these from [languageCode](http://www.iana.org/assignments/language-subtag-registry)-[countryCode](http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm)

	☺ cp -r locales/dev locales/languageCode-countryCode
	☺ subl locales/languageCode-countryCode
See the wiki for further details [https://github.com/TZM/tzm-blade/wiki/Localization-and-Intrenationalization-of-ZMGC-application](https://github.com/TZM/tzm-blade/wiki/Localization-and-Intrenationalization-of-ZMGC-application)