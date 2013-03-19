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
    ☺ node server.js
    Server running at http://127.0.0.1:29080/
    
Now you can navigate to http://127.0.0.1:29080/ and see the website.

#Deployment

The application can be deployed anywhere where you have Nodejs installed, meaning that you can run this on your local machine and setup P2P; For now, this application is running on AppFog at zero cost, as AppFog provides you with a decent enough server to run this application.

To deploy on AppFog, you will need to first create an account and then setup your machine to talk to AppFog, see the [Documentation](https://docs.appfog.com/getting-started/af-cli)
    