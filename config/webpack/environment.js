var { environment }     = require('@rails/webpacker')
const elm               =  require('./loaders/elm')
const webpack           = require('webpack');
const merge             = require('webpack-merge');
const WebpackHtmlPlugin = require( 'html-webpack-plugin' );
const CopyWebpackPlugin = require('copy-webpack-plugin');


environment.loaders.append('elm', elm);
environment = environment.toWebpackConfig();

const commonConfig = {
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Hammer: 'hammerjs/hammer'
    }),
    new WebpackHtmlPlugin({
      chunks: ['main'],
      template: 'app/browser/html/main.pug',
      filename: '../main.html',
    }),
    new CopyWebpackPlugin([{ from: 'app/browser/static', to: '..' }])
  ],
  module: {
    rules: [
      // CSS Loader
      {
        test: /\.(scss|sass)$/i,
        loaders: [
          { loader: 'sass-loader', options: { includePaths: ['node_modules'] } }
        ]
      },
      {
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff'
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/octet-stream'
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader'
      }
    ]
  }
};

module.exports = merge(environment, commonConfig);
