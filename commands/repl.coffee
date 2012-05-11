pad = require "pad"

module.exports = (prompt, app, http) ->

  "verbose":
    section: "repl"
    desc: "enables verbose HTTP output"
    run: ->
      app.verbose = true
      console.log "Enabled verbose output.".green
      prompt()

  "quiet":
    section: "repl"
    desc: "disables verbose HTTP output"
    run: ->
      app.verbose = false
      console.log "Disabled verbose output.".green
      prompt()

  "config":
    section: "repl"
    desc: "prints the current configuration settings"
    run: ->
      config = require "../config"
      for prop in Object.keys(config).sort()
        console.log "    #{pad prop, 20}".cyan + "  #{config[prop]}"
      prompt()

  "json":
    section: "repl"
    desc: "sets the request's accept header to application/json"
    run: ->
      app.accept = "application/json"
      console.log "Requesting JSON data.".green
      prompt()

  "xml":
    section: "repl"
    desc: "sets the request's accept header to application/xml"
    run: ->
      app.accept = "application/xml"
      console.log "Requesting XML data.".green
      prompt()

  "help":
    section: "repl"
    desc: "prints this list of commands and descriptions"
    run: ->
      sections = {}
      for own k, v of app.commands
        sname = v.section or "general"
        section = sections[sname]
        sections[sname] = section = [] if not section
        section.push k
      for sname in Object.keys(sections).sort()
        console.log "  #{sname}".yellow
        for k in sections[sname].sort()
          console.log "    #{pad k, 20}".cyan + "  #{app.commands[k].desc}"
      prompt()

  "quit":
    section: "repl"
    desc: "exits the REPL"
    run: ->
      process.exit()
