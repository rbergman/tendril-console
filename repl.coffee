pad = require "pad"
colors = require "colors"

try
  pygments = require "pygments"
catch ex
  pygments = colorize: (data, type, format, next) -> next data

exports.run = (app) ->

  http =

    get: (path) ->
      request = require "./request"
      args =
        path: "/connect#{path}"
        accessToken: app.auth.access_token
      header = (k) -> k.replace /(^[a-z])|((?:-|_)[a-z])/g, (c) -> c.toUpperCase()
      req = request args, (err, json, res) ->
        if err
          console.error err.toString()
          prompt()
        else
          data = JSON.stringify json, null, 2
          pygments.colorize data, "javascript", "console", (pretty) ->
            if app.verbose
              code = res.statusCode
              status = require("http").STATUS_CODES[code]
              console.log "\u21E6 RESPONSE".yellow
              statusColor =
                if 200 <= code < 300 then "green"
                else if 300 <= code < 400 then "cyan"
                else if 400 <= code < 500 then "magenta"
                else if 500 <= code then "red"
                else "white"
              console.log "HTTP/1.1 " + "#{code} #{status}"[statusColor]
              for k in Object.keys(res.headers).sort()
                console.log "#{header k}: #{res.headers[k]}".grey
              console.log()
            console.log pretty.trim()
            prompt()
      if app.verbose
        console.log "\u21E8 REQUEST".yellow
        console.log "HTTP/1.1 GET #{args.path}"
        for k in Object.keys(req._headers).sort()
          console.log "#{header k}: #{if k is 'access_token' then '(hidden)' else req._headers[k]}".grey
        console.log()

  commands = require("./commands")(http)

  commands.verbose =
    desc: "toggles verbose HTTP output"
    run: ->
      app.verbose = !app.verbose
      console.log "#{if app.verbose then 'Enabled' else 'Disabled'} verbose output.".green
      prompt()

  commands.config =
    desc: "prints the current configuration settings"
    run: ->
      config = require "./config"
      for prop in Object.keys(config).sort()
        console.log "  #{pad prop, 20}".cyan + "  #{config[prop]}"
      prompt()

  commands.help =
    desc: "prints this list of commands and descriptions"
    run: ->
      for cmd in Object.keys(commands).sort()
        console.log "  #{pad cmd, 20}".cyan + "  #{commands[cmd].desc}"
      prompt()

  commands.quit =
    desc: "exits the REPL"
    run: ->
      process.exit()

  prompt = (prefix) ->
    prefix = "> " if not prefix
    app.prompt prefix, (line) ->
      line = line.trim()
      command = commands[line]
      if command
        command.run()
      else
        if line
          console.warn "Unknown command '#{line}'."
          commands.help.run()
        else
          prompt()

  prompt()
