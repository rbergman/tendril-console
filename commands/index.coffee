files = ["devices", "repl", "user"]
module.exports = exports = (prompt, app, http) ->
  commands = {}
  commands[k] = v for own k, v of require("./#{f}")(prompt, app, http) for f in files
  commands
