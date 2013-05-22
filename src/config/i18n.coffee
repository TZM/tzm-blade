module.exports = (app) ->
  
  app.i18n =
    detectLngQS: "lang"
    ns: { namespaces: ['ns.common', 'ns.layout', 'ns.forms'], defaultNs: 'ns.common'}
    resSetPath: "./locales/__lng__/new.__ns__.json"
    ignoreRoutes: ["images/", "public/", "css/", "js/"]
    #locales:['de', 'en', 'fr', 'pt']
    extension:".json"
    #saveMissing: true
    #sendMissingTo: 'all'
    debug: true

  app