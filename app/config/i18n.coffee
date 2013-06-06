module.exports =
  I18N =
    detectLngQS: "lang"
    ns: { namespaces: ['ns.common', 'ns.layout', 'ns.forms', 'ns.msg'], defaultNs: 'ns.common'}
    resSetPath: "./locales/__lng__/new.__ns__.json"
    ignoreRoutes: ["images/", "public/", "css/"]
    extension:".json"
    debug: false