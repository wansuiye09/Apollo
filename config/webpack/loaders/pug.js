const { resolve } = require('path')

const isProduction = process.env.NODE_ENV === 'production'

const developmentOptions = {
  pretty: true,
  locals: {
    api_url: 'http://localhost:3000/',
    auth0_domain: process.env.AUTH0_DOMAIN,
    auth0_client_id: process.env.AUTH0_CLIENT_ID,
    auth0_redirect: 'http://localhost:3000',
  }
}

const productionOptions = {
  pretty: false,
  locals: {
    api_url: '/',
    auth0_domain: process.env.AUTH0_DOMAIN,
    auth0_client_id: process.env.AUTH0_CLIENT_ID,
    auth0_redirect: process.env.AUTH0_REDIRECT,
  }
}

const pugWebpackLoader = {
  loader: 'pug-static-loader',
  options: isProduction ? productionOptions : developmentOptions
}

module.exports = {
  test: /\.pug$/,
  use: [pugWebpackLoader]
}
