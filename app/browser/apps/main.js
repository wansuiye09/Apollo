'use strict'
// Style
require('js/style')

// Load Elm and JS
const Elm    = require('elm/Main')
const Config = require('js/config')
const Ports  = require('js/ports')
const Auth0  = require('auth0-js')
const metas  = document.getElementsByTagName('meta')
const config = new Config(metas)

// Hack to get around Elm some how breaking "this" scoping in class methods.
window.MainConfig = config
window.WebAuth    = new Auth0.WebAuth(config.auth0Config({audience: null}))
window.Main       = Elm.Main.fullscreen(config.main)
window.MainPorts  = new Ports(window.Main.ports)
