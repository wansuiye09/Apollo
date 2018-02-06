'use strict'

class Config {

  constructor(metas) {
    this.metas = metas
  }

  get main() {
    return this.forMain()
  }

  get apiTokenKey() {
    return 'api_token'
  }
  get apiTokenTypeKey() {
    return 'api_token_type'
  }

  get auth0TokenKey() {
    return 'auth0_token'
  }

  get auth0IdTokenKey() {
    return 'auth0_id_token'
  }

  get auth0ProfileKey() {
    return 'auth0_profile'
  }

  forMain() {
    var config = {}

    // These are in meta tags because they get passed in from ENV variables at compile time.
    for (var i = 0; i < this.metas.length; i++) {
      if (this.metas[i].getAttribute('property') === 'api-url') {
        config.apiUrl = this.metas[i].getAttribute('content')
      }
    }

    config.auth0User = this.storedAuth0()

    return Object.assign(config, this.storedApiToken())
  }

  auth0Config(options = {}) {
    var config = {}

    // These are in meta tags because they get passed in from ENV variables at compile time.
    for (var i = 0; i < this.metas.length; i++) {
      if (this.metas[i].getAttribute('property') === 'auth0-domain') {
        config.domain = this.metas[i].getAttribute('content')
      }
      if (this.metas[i].getAttribute('property') === 'auth0-client-id') {
        config.clientID = this.metas[i].getAttribute('content')
      }
      if (this.metas[i].getAttribute('property') === 'auth0-redirect') {
        config.redirectUri = this.metas[i].getAttribute('content')
      }
      if (this.metas[i].getAttribute('property') === 'auth0-redirect') {
        config.audience = this.metas[i].getAttribute('audience')
      }
    }

    config.scope = 'openid email profile'
    config.responseType = 'token id_token'

    return Object.assign(config, options)
  }

  storedAuth0() {
    var storedAuth0Profile = localStorage.getItem(this.auth0ProfileKey)
    var storedAuth0Token   = localStorage.getItem(this.auth0TokenKey)
    var storedAuth0IdToken = localStorage.getItem(this.auth0IdTokenKey)

    if (storedAuth0Profile && storedAuth0Token && storedAuth0IdToken) {
      return Object.assign(
        {
          profile: JSON.parse(storedAuth0Profile),
          token: storedAuth0Token,
          idToken: storedAuth0IdToken,
        },
        this.storedApiToken()
      )
    } else {
      return null
    }
  }

  storedApiToken() {
    var storedApiToken     = localStorage.getItem(this.apiTokenKey) || ''
    var storedApiTokenType = localStorage.getItem(this.apiTokenTypeKey) || ''

    return {
      apiToken: storedApiToken,
      apiTokenType: storedApiTokenType,
    }
  }
}

module.exports = Config
