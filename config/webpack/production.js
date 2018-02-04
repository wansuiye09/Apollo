const environment = require('./environment')
const WebpackHtmlPlugin = require('html-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

environment.plugins.append(
  'CopyWebpackPlugin',
  new CopyWebpackPlugin([{ from: 'app/browser/static', to: '..' }])
)

environment.plugins.append(
  'WebpackHtmlPlugin',
  new WebpackHtmlPlugin({
    chunks: ['main'],
    template: 'app/browser/html/main.pug',
    filename: '../main.html'
  })
)

module.exports = environment.toWebpackConfig()
