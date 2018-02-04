const { resolve } = require('path')

const isProduction = process.env.NODE_ENV === 'production'

const developmentOptions = {
  pretty: true,
  locals: {
    api_url: 'http://localhost:3000'
  }
}

const productionOptions = {
  pretty: false,
  locals: {
    api_url: '/'
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
