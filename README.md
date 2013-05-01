#TZM Chapters code, migration to Node.js and Blade

[Node.js](http://nodejs.org/)

[Blade HTML Compiler](https://github.com/bminer/node-blade)

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
    