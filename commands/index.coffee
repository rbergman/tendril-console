files = ["devices", "user"]
module.exports = exports = (http) ->
  commands = {}
  commands[k] = v for own k, v of require("./#{f}")(http) for f in files
  commands
