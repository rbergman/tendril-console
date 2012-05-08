colors = require "colors"

try
  pygments = require "pygments"
catch ex
  pygments = colorize: (data, type, format, next) -> next data

verbose = false

exports.run = (app) ->

  commands =

    "user":
      desc: "Gets the current user's information"
      run: ->
        get "/user/current-user"

    "account":
      desc: "Gets the current user's account information"
      run: ->
        get "/user/current-user/account/default-account"

    "location":
      desc: "Gets the current user's location information"
      run: ->
        get "/user/current-user/account/default-account/location/default-location"

    "location-profile":
      desc: "Gets the current user's location profile information"
      run: ->
        get "/user/current-user/account/default-account/location/default-location/profile"

    "devices":
      desc: "Lists the current user's devices"
      run: ->
        get "/user/current-user/account/default-account/location/default-location/network/default-network/device"

    "verbose":
      desc: "Toggles verbose HTTP output"
      run: ->
        verbose = !verbose
        console.log "#{if verbose then 'Enabled' else 'Disabled'} verbose output.".green
        prompt()

    "help":
      desc: "Prints this list of commands and descriptions"
      run: ->
        pad = require "pad"
        for cmd in Object.keys(commands).sort()
          console.log "  #{pad cmd, 25}".cyan + "  #{commands[cmd].desc}"
        prompt()

    "quit":
      desc: "Exits the REPL"
      run: ->
        process.exit()

  get = (path) ->
    request = require "./request"
    args =
      path: "/connect#{path}"
      accessToken: app.auth.access_token
    request args, (err, json, req, res) ->
      if err
        console.error err.toString()
        prompt()
      else
        data = JSON.stringify json, null, 2
        pygments.colorize data, "javascript", "console", (pretty) ->
          if verbose
            header = (k) -> k.replace /(^[a-z])|((?:-|_)[a-z])/g, (c) -> c.toUpperCase()
            console.log "\u21E8 REQUEST".yellow
            console.log "HTTP/1.1 GET #{args.path}"
            for k in Object.keys(req._headers).sort()
              console.log "#{header k}: #{req._headers[k]}".grey
            console.log()
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
