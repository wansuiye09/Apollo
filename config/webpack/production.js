const defaultConfig = require('./environment')
const merge         = require('webpack-merge');
const prodConfig     = {
  module: {
    rules: [
      // Pug (Slim)
      {
        test: /\.pug$/,
        loader: 'pug-static-loader',
        options: {
          pretty: true,
          locals: {
            api_url: process.env.API_URL || '/'
          }
        }
      }
    ]
  }
};

module.exports = merge(defaultConfig, prodConfig);
