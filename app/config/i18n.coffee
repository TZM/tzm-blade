module.exports =
  I18N =
    detectLngQS: "lang"
    ns: { namespaces: ['ns.common', 'ns.layout', 'ns.forms'], defaultNs: 'ns.common'}
    resSetPath: "./locales/__lng__/new.__ns__.json"
    ignoreRoutes: ["images/", "public/", "css/", "js/"]
    extension:".json"
    debug: false