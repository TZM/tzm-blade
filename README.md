#TZM Chapters code
* [Node.js](http://nodejs.org/)
* [Blade HTML Compiler](https://github.com/bminer/node-blade)

#Setup
Before running this application we will need to setup couple of environmental settings, in order not to add any private data within the code.

Here is a list, that is currently used add these to your .zschrc or .bashrc :

    |-------------------------------------------------------------------|
    |Provider  |  Developer API Keys  |AuthID Providers    |SMTP Access |
    |-------------------------------------------------------------------|
    |Google    |  GOOGLE_API_KEY      |GG_APP_ID           |SMTP_USER   |
    |          |                      |GG_APP_SEC          |SMTP_PASSWD |
    |Facebook  |  FB_APP_ID           |*                   |            |
    |          |  FB_APP_SEC          |*                   |            |
    |Twitter   |                      |TT_APP_ID           |            |
    |          |                      |TT_APP_SEC          |            |
    |Yahoo     |                      |YH_APP_ID           |            |
    |          |                      |YH_APP_SEC          |            |
    |LinkedIn  |                      |LI_APP_ID           |            |
    |          |                      |LI_APP_SEC          |            |
    |Github    |                      |GITHUB_ID           |            |
    |          |                      |GITHUB_SEC          |            |
    |Trello    |  TRELLO_ID           |                    |            |
    |          |  TRELLO_SECRET       |                    |            |
    |-------------------------------------------------------------------|
#Installation
After installing node.js, open terminal and navigate to your sandboxes folder

    ☺ git clone git://github.com/TZM/tzm-blade.git
    ☺ cd tzm-blade
    ☺ npm install                                                                                                                                                
    npm http GET https://registry.npmjs.org/express
    npm http GET https://registry.npmjs.org/blade
    ....
    ☺ cake dev
    Server running at http://127.0.0.1:9080/

Now you can navigate to http://127.0.0.1:9080/ and see the website.
#Deployment
The application can be deployed anywhere where you have Nodejs installed, meaning that you can run this on your local machine and setup P2P; For now, this application is running on AppFog at zero cost, as AppFog provides you with a decent enough server to run this application.

To deploy on AppFog, you will need to first create an account and then setup your machine to talk to AppFog, see the [Documentation](https://docs.appfog.com/getting-started/af-cli)

    ☺  npm install

    > zmgc@0.0.1 install /Users/khinester/Documents/Tutorials/Node/Blade
    > node node_modules/coffee-script/bin/cake build

    :)
    
    ☺ npm start
    Server running at http://127.0.0.1:9080/
#Development
To run locally for development use:

    ☺  cake dev
    Watching coffee files
    Watching js files and running server


    DEBUG: Running node-supervisor with
    ....
#Testing
To run the tests, use:

     ☺  cake test
     Assetizing footer
     ...

       app
         ✓ should expose app settings

       sessions
         ✓ should be able to store sessions
         ✓ should be able to retrieve sessions


       3 tests complete (51 ms)

     ✓ Mocha tests complete
#Warning
This application is still a work in progress and is not ready for use yet.
#Directories
* /assets         : Stylesheets and Javascripts assets (coffee and less files) managed by the asset pipeline
* /data           : Data files used by D3, GeoLite and Node-Cldr
* /docs           : Various documentations and RFCs
* /layout         : Blade layouts
* /locales        : i18next locales
* /public         : All assets not managed by the asset pipeline (ex: images and vendor libaries)
* /test/front-end : All Knockout application test files (managed by Jasmine)
* /test/apps      : All Express application test files (managed by Mocha)
* /test/lib       : All models libraries test files (managed by Mocha)
* /test/models    : All Express models test files (managed by Mocha)
* /views          : Blade views / pages

#Stats
    ☺  cloc --exclude-dir=.app,buildAssets,data,public/css/font,public/css/fonts,public/css/vendor,public/js/vendor,node_modules .
         101 text files.
          92 unique files.
       13379 files ignored.

    http://cloc.sourceforge.net v 1.56  T=1.0 s (47.0 files/s, 4957.0 lines/s)
    -------------------------------------------------------------------------------
    Language                     files          blank        comment           code
    -------------------------------------------------------------------------------
    CSS                              4            188            213           1957
    CoffeeScript                    30            191            369            984
    Javascript                      11            104            265            624
    Bourne Shell                     1              0              0             19
    make                             1             12             13             18
    -------------------------------------------------------------------------------
    SUM:                            47            495            860           3602
    -------------------------------------------------------------------------------