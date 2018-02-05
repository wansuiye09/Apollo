'use strict';

class Ports {
  constructor(ports) {
    ports.initPort.subscribe(this.initPort);
    ports.updateTextFields.subscribe(this.updateTextFields);
    ports.openModal.subscribe(this.openModal);
    ports.closeModal.subscribe(this.closeModal);
    ports.auth0Authorize.subscribe(this.auth0Authorize);
    ports.auth0Logout.subscribe(this.auth0Logout);
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    $('.modal').modal({dismissible: false});
    window.MainPorts.updateTextFields();
    window.MainPorts.initializeAuth0();
  }

  // Used when dynamically updating Materialize text fields.
  updateTextFields(input) {
    window.Materialize.updateTextFields();
  }

  openModal(input) {
    $('#' + input).modal('open');
  }

  closeModal(input) {
    $('#' + input).modal('close');
  }

  auth0Authorize(input) {
    window.WebAuth.authorize();
  }

  auth0Logout(input) {
    localStorage.removeItem(window.MainConfig.profileKey);
    localStorage.removeItem(window.MainConfig.tokenKey);
    localStorage.removeItem(window.MainConfig.idTokenKey);
  }

  initializeAuth0(input) {
    window.WebAuth.parseHash({ hash: window.location.hash }, function(err, authResult) {
      if (err) {
        return console.error(err);
      }
      if (authResult) {
        window.WebAuth.client.userInfo(authResult.accessToken, function(err, profile) {
          var result = { err: null, ok: null };
          var token = authResult.accessToken;
          var idToken = authResult.idToken;

          if (err) {
            result.err = err.details;
            // Ensure that optional fields are on the object
            result.err.name = result.err.name ? result.err.name : null;
            result.err.code = result.err.code ? result.err.code : null;
            result.err.statusCode = result.err.statusCode ? result.err.statusCode : null;
          }
          if (authResult) {
            result.ok = { profile: profile, token: token, idToken: idToken };
            localStorage.setItem(window.MainConfig.profileKey, JSON.stringify(profile));
            localStorage.setItem(window.MainConfig.tokenKey, token);
            localStorage.setItem(window.MainConfig.idTokenKey, idToken);
          }
          window.Main.ports.auth0AuthResult.send(result);
        });
        window.location.hash = '';
      }
    });
  }
}

module.exports = Ports;
