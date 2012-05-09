module.exports = (http) ->

  "user":
    desc: "gets the current user's information"
    run: ->
      http.get "/user/current-user"

  "account":
    desc: "gets the current user's account information"
    run: ->
      http.get "/user/current-user/account/default-account"

  "location":
    desc: "gets the current user's location information"
    run: ->
      http.get "/user/current-user/account/default-account/location/default-location"

  "location-profile":
    desc: "gets the current user's location profile information"
    run: ->
      http.get "/user/current-user/account/default-account/location/default-location/profile"
