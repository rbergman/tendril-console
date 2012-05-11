module.exports = (prompt, app, http) ->

  "user":
    section: "user"
    desc: "gets the current user's information"
    run: ->
      http.get "/user/current-user"

  "account":
    section: "user"
    desc: "gets the current user's account information"
    run: ->
      http.get "/user/current-user/account/default-account"

  "location":
    section: "user"
    desc: "gets the current user's location information"
    run: ->
      http.get "/user/current-user/account/default-account/location/default-location"

  "location-profile":
    section: "user"
    desc: "gets the current user's location profile information"
    run: ->
      http.get "/user/current-user/account/default-account/location/default-location/profile"
