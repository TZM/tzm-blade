var i18n = require("i18next");

i18n.init({
    lng: 'en-UK' // set language to English - UK
    ,ignoreRoutes: ['images/', 'public/', 'css/', 'js/']
    ,resSetPath: '../locales/__lng__/translation.json'
    ,locales:['en', 'de','fr']
    ,register:global
    ,extension:'.json'
    ,useCookie: true
    ,saveMissing: true
    ,debug:false
    ,verbose:false
});

module.exports = function (app) {

    app.configure(function () {
        try {
            app.set('languages', require('../locales/config.json'));
            app.set('translation', require('../locales/dev/translation.json'));
        } catch(err) {
            require('./config/utils')
            dumpError(err);
            console.log('there is no /locales/config.json');
            app.set('languages', []);
            app.set('translation', []);
        }
        app.use(i18n.handle);
        app.use(i18n.init);
    })

    i18n.registerAppHelper(app)
        .serveClientScript(app)
        .serveDynamicResources(app)
        .serveMissingKeyRoute(app);

    console.log(i18n.lng() + ' is using now')
    //i18n.setLocale ('en')
    //console.log(i18n.lng() + ' is selected now')
}
