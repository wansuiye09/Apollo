const defaultConfig = require('./environment')
const merge         = require('webpack-merge');
const devConfig  = {
  module: {
    rules: [
      // Pug (Slim)
      {
        test: /\.pug$/,
        loader: 'pug-static-loader',
        options: {
          pretty: true,
          locals: {
            api_url: 'http://localhost:3000'
          }
        }
      }
    ]
  }
};

module.exports = merge(defaultConfig, devConfig);
