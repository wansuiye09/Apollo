'use strict'

class Ports {
  constructor(ports) {
    ports.initPort.subscribe(this.initPort)
    ports.updateTextFields.subscribe(this.updateTextFields)
    ports.openModal.subscribe(this.openModal)
    ports.closeModal.subscribe(this.closeModal)
    ports.auth0Authorize.subscribe(this.auth0Authorize)
    ports.auth0Logout.subscribe(this.auth0Logout)
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    $('.modal').modal({dismissible: false})
    window.MainPorts.updateTextFields()
    window.MainPorts.initializeAuth0()
  }

  // Used when dynamically updating Materialize text fields.
  updateTextFields(input) {
    window.Materialize.updateTextFields()
  }

  openModal(input) {
    $('#' + input).modal('open')
  }

  closeModal(input) {
    $('#' + input).modal('close')
  }

  auth0Authorize(input) {
    window.WebAuth.authorize()
  }

  auth0Logout(input) {
    localStorage.removeItem(window.MainConfig.auth0ProfileKey)
    localStorage.removeItem(window.MainConfig.auth0TokenKey)
    localStorage.removeItem(window.MainConfig.auth0IdTokenKey)
    localStorage.removeItem(window.MainConfig.apiTokenKey)
    localStorage.removeItem(window.MainConfig.apiTokenTypeKey)
  }

  initializeAuth0(input) {
    window.WebAuth.parseHash({ hash: window.location.hash }, function(err, auth0Result) {
      window.location.hash = ''
      if (err) {
        return console.error(err)
      }
      if (auth0Result) {
        var authResult = { err: null, ok: null }
        window.WebAuth.client.userInfo(auth0Result.accessToken, function(err, profile) {
          if (err) {
            authResult.err = err.details
            // Ensure that optional fields are on the object
            authResult.err.name = authResult.err.name ? authResult.err.name : null
            authResult.err.code = authResult.err.code ? authResult.err.code : null
            authResult.err.statusCode = authResult.err.statusCode ? authResult.err.statusCode : null
          }
          if (auth0Result && profile) {
            var auth0Token = auth0Result.accessToken
            var auth0IdToken = auth0Result.idToken

            localStorage.setItem(window.MainConfig.auth0ProfileKey, JSON.stringify(profile))
            localStorage.setItem(window.MainConfig.auth0TokenKey, auth0Token)
            localStorage.setItem(window.MainConfig.auth0IdTokenKey, auth0IdToken)

            authResult.ok = {
              profile: profile,
              token: auth0Token,
              idToken: auth0IdToken,
            }

            window.WebAuth.checkSession(window.MainConfig.auth0Config({scope: ''}),
              function (err, organizeResult) {
                if (err) {
                  // err if automatic parseHash fails
                  return console.error(err)
                }
                var token     = organizeResult.accessToken
                var tokenType = organizeResult.tokenType

                if (token && tokenType) {
                  localStorage.setItem(window.MainConfig.apiTokenKey, organizeResult.idToken)
                  localStorage.setItem(window.MainConfig.apiTokenTypeKey, organizeResult.tokenType)
                  authResult.ok.apiToken = token
                  authResult.ok.apiTokenType = tokenType
                }

                window.Main.ports.auth0AuthResult.send(authResult)
              }
            )
          }
        })
      }
    })
  }
}

module.exports = Ports
