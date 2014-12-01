APP_KEY = "ru4mvdp20b2pzu5"

client = new Dropbox.Client {key: APP_KEY}

updateAuthenticationStatus = (err, client) ->
  console.log "ran"
  if not client.isAuthenticated()
    console.log "not logged in"
  else:
    console.log "logged in!"

  client.getAccountInfo (err, info) ->
    if err
      console.log "there was an erreor", err
    # @setState dropboxUserInfo: info._json
    window.Info = info._json

$ ->
  client.authenticate({ interactive: false }, updateAuthenticationStatus);
  window.dbclient = client
