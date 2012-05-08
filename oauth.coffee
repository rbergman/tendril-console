config = require "./config"
request = require "./request"
enc = encodeURIComponent

exports.login = (options, next) ->
  params =
    grant_type: "password"
    username: options.username
    password: options.password
    client_id: config.id
    client_secret: config.secret
    scope: config.scope
  args =
    method: "POST"
    path: "/oauth/access_token"
    body: "#{(enc(k) + '=' + enc(v) for own k, v of params).join '&'}"
    headers:
      "Content-Type": "application/x-www-form-urlencoded"
      "X-Route": config.route or "sandbox"
  request args, (err, json) ->
    throw err if err
    next undefined, json
