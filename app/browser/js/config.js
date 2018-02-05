'use strict';

class Config {

  constructor(metas) {
    this.metas = metas
  }

  get main() {
    return this.forMain();
  }

  get auth0() {
    return this.forAuth0();
  }

  get tokenKey() {
    return 'auth0_token';
  }

  get idTokenKey() {
    return 'auth0_id_token';
  }

  get profileKey() {
    return 'auth0_profile';
  }

  forMain() {
    var config = {};

    // These are in meta tags because they get passed in from ENV variables at compile time.
    for (var i = 0; i < this.metas.length; i++) {
      if (this.metas[i].getAttribute('property') === 'api-url') {
        config.apiUrl = this.metas[i].getAttribute('content');
      }
    }

    config.auth0User = this.storedAuth0();

    return config;
  }

  forAuth0() {
    var config = {};

    // These are in meta tags because they get passed in from ENV variables at compile time.
    for (var i = 0; i < this.metas.length; i++) {
      if (this.metas[i].getAttribute('property') === 'auth0-domain') {
        config.domain = this.metas[i].getAttribute('content');
      }
      if (this.metas[i].getAttribute('property') === 'auth0-client-id') {
        config.clientID = this.metas[i].getAttribute('content');
      }
      if (this.metas[i].getAttribute('property') === 'auth0-redirect') {
        config.redirectUri = this.metas[i].getAttribute('content');
      }
    }

    config.scope = 'email';
    config.responseType = 'token id_token';

    return config;
  }

  storedAuth0() {
    var storedProfile = localStorage.getItem(this.profileKey);
    var storedToken = localStorage.getItem(this.tokenKey);
    var storedIdToken = localStorage.getItem(this.idTokenKey);

    if (storedProfile && storedToken && storedIdToken) {
      return {
        profile: JSON.parse(storedProfile),
        token: storedToken,
        idToken: storedIdToken
      };
    } else {
      return null;
    }
  }
}

module.exports = Config;
