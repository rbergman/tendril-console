https = require "https"
XML = require "./xml"

module.exports = (options, next) ->

  args =
    method: options.method or "GET"
    host: "dev.tendrilinc.com"
    port: 443
    path: options.path
    headers:
      "Accept": options.accept or "application/xml"
  args.headers["Access_Token"] = options.accessToken if options.accessToken
  args.headers[k] = v for own k, v of options.headers if options.headers

  req = https.request args

  timeout = setTimeout (-> req.abort()), (options.timeout or 15000)

  req.on "error", (err) -> throw err

  req.on "response", (res) ->
    clearTimeout timeout
    body = ""
    res.on "data", (chunk) -> body += chunk
    res.on "end", ->
      code = res.statusCode
      status = require("http").STATUS_CODES[code]
      type = res.headers["content-type"]
      if body
        if type?.indexOf("json") >= 0
          type = "json"
          json = JSON.parse body
        else if type?.indexOf("xml") >= 0
          type = "xml"
          json = XML.parse body, null, true
        else
          return next new Error("Unexpected content type: #{type}"), body, res
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
        next new Error("#{err}#{if desc then '\n' + desc else ''}"), body, type, res
      else
        next undefined, json, type, res

  req.write options.body if options.body

  req.end()
  req
