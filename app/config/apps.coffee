express = require "express"
csrf = express.csrf()
assets = require "connect-assets"
jsPaths = require "connect-assets-jspaths"
flash = require "connect-flash"
RedisStore = require("connect-redis")(express)
blade = require "blade"
i18n = require "i18next"
logger = require "winston"
passport = require "passport"
LocalStrategy = require("passport-local").Strategy
cldr = require "cldr"
i18n = require "i18next"
fs = require "fs"
__ = require "underscore"

thirdParty = ["google","yahoo","persona"]
if process.env.FB_APP_ID? and  process.env.FB_APP_SEC?
  thirdParty.push("facebook")
# if process.env.TT_APP_ID? and process.env.TT_APP_SEC?
#   thirdParty.push("twitter")
if process.env.GITHUB_ID? and process.env.GITHUB_SEC? 
  thirdParty.push("github")
if process.env.LI_APP_ID? and process.env.LI_APP_SEC?
  thirdParty.push("linkedin")



logCategory = "CONFIGURE"
maxAges = 86400000 * 30

config = require "../config/config"
config.setEnvironment process.env.NODE_ENV or "development"
redisService =  process.env.REDISTOGO_URL || process.env.REDISCLOUD_URL
# Redis session stores
rediska = (if redisService? then require("redis-url").connect(redisService) else require("redis").createClient())


options =
  unless redisService
    hosts: [new RedisStore(
      hostname: config.REDIS_DB.hostname
      host: config.REDIS_DB.host
      port: config.REDIS_DB.port
      name: config.REDIS_DB.name
      password: config.REDIS_DB.password
      maxAge: config.REDIS_DB.maxAge # 30 days
    ), new RedisStore(
      hostname: config.REDIS_DB.hostname
      host: config.REDIS_DB.host
      port: config.REDIS_DB.port
      name: config.REDIS_DB.name
      password: config.REDIS_DB.password
      maxAge: config.REDIS_DB.maxAge # 30 days
    )]
    session_secret: "f2e5a67d388ff2090dj7Q2nC53pF"
    cookie:
      maxAge: 86400000 * 1 # 30 days 
  else
    hosts: [new RedisStore(
      client: rediska
    ),new RedisStore(
      client: rediska
    )]
    session_secret: "f2e5a67d388ff2090dj7Q2nC53pF"
    cookie:
      maxAge: 86400000 * 1 # 30 days 
    

console.log "options: ",options.hosts[0]
module.exports = (app) ->
  logger.info "Configure expressjs", logCategory
  # FIXME use _.each to loop for each dirs and Gzip
  #dirs = ["/assets", "/public", "/locales", "/data/topo"]

  app.configure ->
      app.use assets(build : true)
      jsPaths assets, console.log
      @use(express.favicon(process.cwd() + "/assets/images/favicon.ico", {maxAge:maxAges}))
      .use(express.compress())
      .use(express.static(process.cwd() + "/assets", {maxAge:maxAges}))
      .use(express.static(process.cwd() + "/public", {maxAge:maxAges}))
      .use(express.static(process.cwd() + "/js", {maxAge:maxAges}))
      .use(express.static(process.cwd() + "/locales", {maxAge:maxAges}))
      .use(express.static(process.cwd() + "/data/topo", {maxAge:maxAges}))
      .use(express.logger('dev'))
      .use(express.errorHandler(
            dumpException: true
            showStack: true
      ))
      #app.use express.static(process.cwd() + folder, maxAge:maxAges) for folder in ["/assets", "/public", "/locales", "/data/topo"]
  #  Add template engine
  app.configure ->
    @set("views", process.cwd() + "/views")
    .set("view engine", "blade")
    #.use(stylus.middleware(
    #  src: process.cwd() + "/assets"
    #  compile: compile
    #))

  # FIXME - see if we can do this differently
  app.configure ->
    try
      require ('./passport.coffee')
      app.set "languages", require(process.cwd() + "/locales/config.json")
      app.set "translation", require(process.cwd() + "/locales/dev/translation.json")
      app.set "chapters", require(process.cwd() + "/data/chapters.json")
      fs.readdir "./locales", (err,locales) ->
        #console.log locales
        #results = []
        EXCLUDE = [ 'dev', 'README.md', 'config.json' ]
        languages = new Array()
        #languages = {}
        results = __.reject locales, (value, index, list) ->
          return EXCLUDE.indexOf(value) != -1
        locales = __.each results, (value, index, list) ->
          locale = value.split("-")[0]
          #console.log locale
          language = cldr.extractLanguageDisplayNames(locale)[locale]
          #console.log language
          #languages.locale = language
          languages.push[locale: language]
        console.log languages
    catch e
      logger.warn "files not found " + e, logCategory
      require ('./passport.coffee')
      app.set("chapters", [])
      app.set "languages", []
      app.set "translation", []
      next()
      return


  # arr = [];
  
  multipleRedisSessions = require("connect-multi-redis")(app, express.session)
  # Set sessions and middleware
  app.configure ->
    @use(express.bodyParser())
    .use(express.methodOverride())
    .use(express.cookieParser('90dj7Q2nC53pFj2b0fa81a3f663fd64'))
    .use(multipleRedisSessions(options))
    .use(express.session(
      key: 'zmgc-connect.sid'
      store: options.hosts[0]
      secret: 'f2e5a67d388ff2090dj7Q2nC53pF'
      cookie:
        maxAge: 86400000 * 30     # 90 days
    ))
    .use(passport.initialize())
    .use(passport.session())
    #csrf protection
    # .use (req, res, next) ->
      # Only use CSRF if user is logged in
      # if req.session.passport and req.session.passport and req.session.passport.user
      #   console.log('session');
      #   # console.log(req.session._csrf);
      #   arr.push(req.session._csrf);
      #   console.log(arr);
      #   csrf req, res, next
      # else
      #   next()
    .use(i18n.handle)
    .use(blade.middleware(process.cwd() + "/views"))
    .use(express.csrf())
    #Configure dynamic helpers
    .use (req, res, next) ->
      
      fs.readFile "./data/chapters.json", (err,chapterJSON) ->
        console.log("read file error", err) if err
        chapters = JSON.parse chapterJSON
        formData = req.session.formData or {}
        code = i18n.lng().substr(0, 2)
        countries = cldr.extractTerritoryDisplayNames(code) 
        delete req.session.formData
        res.locals
          #for use in templates
          appName: config.APP.name
          #for connect-flash
          message: req.flash("info")
          # needed for csrf support
          csrf_token: req.session._csrf
          # needed for coutry list localization
          allCountries: countries

          chapterJSON: chapters
          #socials
          socials: thirdParty

        # res.cookie.
        next()
  app
