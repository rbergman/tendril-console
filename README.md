# About

This is an experimental REPL app based on Node.js for exploring the Tendril HTTP APIs.  This is an early work in progress.

# Installation

With Node.js v 0.6.x:

    npm install -g coffee-script # if not already installed
    npm install

Next:

    cp config.coffee.sample config.coffee

Then at Tendril's developer site, create an app to acquire an OAuth2 app id and key. Further edit config.coffee to add your app id and secret.

# Usage

Launch the REPL like so:

    coffee app.coffee

The command line also takes some optional arguments.  Use the '-h' argument for more information.

Unless specified as a command line argument, you'll be prompted to add a username and password -- when connecting to the Tendril developer sandbox, you may use one of the standard users defined [here](https://dev.tendrilinc.com/docs/sample_users).

Once in the app at the command prompt, type 'help' to get a list of commands.  Currently only a few simple read operations are supported, but they can still be useful for seeing the HTTP requests and responses used to achieve useful interactions with the Tendril APIs.

See the CLI and in-app help for more information.
