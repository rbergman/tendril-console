module.exports = (prompt, app, http) ->

  "devices":
    section: "devices"
    desc: "lists the current user's devices"
    run: ->
      http.get "/user/current-user/account/default-account/location/default-location/network/default-network/device"
