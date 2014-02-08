# Localization of site

We use [IETF language tag][1] to specify which language the user wants to see the content in, this is done by creating a folder within the /locals/ directory containing a copy of the /locals/dev/translation.json file.


[Creating localizable web applications][2]

## How to extract all the template html content and generate the JSON file for a specific localization.

i18next-conv converts files from gettext (.mo/.po) to i18next's json format and vice versa. This will allow the translation team to use tools such as [POEdit][3] and then convert this to JSON to use within this application.

## Libraries to consider

[https://github.com/papandreou/node-cldr/][4]
[http://translationproject.org/html/welcome.html][5]

[http://unicode.org/Public/cldr/latest/core.zip][6]

## Procedure
Please replace `languageCode-countryCode` with the ones for your language and country, you can get these from [languageCode][7]-[countryCode][8]

	☺ cp -r locales/dev locales/languageCode-countryCode
	☺ subl locales/languageCode-countryCode
See the wiki for further details [https://github.com/TZM/tzm-blade/wiki/Localization-and-Intrenationalization-of-ZMGC-application][9]

## TODO
- `[ ]` [http://www.languageicon.org/][10] - use the language icon.
- `[ ]` Integrate [WebTranslate][11] into the [application][12]

[1]: http://en.wikipedia.org/wiki/IETF_language_tag
[2]: https://developer.mozilla.org/en-US/docs/Web_Localizability/Creating_localizable_web_applications
[3]: http://www.poedit.net/
[4]: https://github.com/papandreou/node-cldr/
[5]: http://translationproject.org/html/welcome.html
[6]: http://unicode.org/Public/cldr/latest/core.zip
[7]: http://www.iana.org/assignments/language-subtag-registry
[8]: http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm
[9]: https://github.com/TZM/tzm-blade/wiki/Localization-and-Intrenationalization-of-ZMGC-application
[10]: http://www.languageicon.org/
[11]: https://github.com/jamuhl/i18next-webtranslate
[12]: https://github.com/TZM/tzm-blade/issues/50
