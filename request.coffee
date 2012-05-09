https = require "https"

module.exports = (options, next) ->

  args =
    method: options.method or "GET"
    host: "dev.tendrilinc.com"
    port: 443
    path: options.path
    headers:
      "Accept": options.accept or "application/json"
  args.headers["Access_Token"] = options.accessToken if options.accessToken
  args.headers[k] = v for own k, v of options.headers if options.headers

  req = https.request args

  timeout = setTimeout (-> req.abort()), (options.timeout or 15000)

  req.on "error", (err) -> throw err

  req.on "response", (res) ->
    code = res.statusCode
    status = require("http").STATUS_CODES[code]
    clearTimeout timeout
    body = ""
    res.on "data", (chunk) -> body += chunk
    res.on "end", ->
      json = JSON.parse body if res.headers["content-type"].indexOf("json") >= 0
      if code >= 300 or not json
        err =
          if json and json.error
            json.error
          else if json and json["@reason"]
            json["@reason"]
          else
            "#{code} #{status}"
        desc =
          if json and json.error_description
            json.error_description
          else if json and json.details
            json.details
          else
            body
        next new Error "#{err}#{if desc then '\n' + desc else ''}"
      else
        next undefined, json, res

  req.write options.body if options.body

  req.end()
  req
