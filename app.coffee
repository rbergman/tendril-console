app = require "commander"
async = require "async"
config = require "./config"

app.auth = {}

configure = (next) ->
  require("fs").readFile "#{__dirname}/package.json", "utf8", (err, data) ->
    json = JSON.parse data
    app.version json.version
    app.option "-u, --username [value[:password]]", "a username appropriate to the configured OAuth x-route"
    app.option "-v, --verbose", "default to verbose HTTP output"
    app.parse process.argv
    console.log "Connecting to Tendril Connect host '#{config.route}'."
    next()

username = (next) ->
  if app.username
    app.auth.username = app.username
    next()
  else
    app.prompt "Username: ", (value) ->
      app.auth.username = value
      next()

password = (next) ->
  [user, pass] = app.auth.username.split ":"
  if pass
    app.auth.username = user
    app.auth.password = pass
    next()
  else
    app.password "Password: ", (value) ->
      app.auth.password = value
      next()

login = (next) ->
  console.log "Logging in as #{app.auth.username}..."
  oauth = require "./oauth"
  oauth.login app.auth, (err, oauth) ->
    throw err if err
    console.log "Ready."
    oauth.username = app.auth.username
    app.auth = oauth
    next()

repl = ->
  require("./repl").run app

async.series [
  configure
  username
  password
  login
  repl
]
