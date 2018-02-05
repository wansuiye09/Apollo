const { resolve } = require('path')
const Dotenv = require('dotenv')
Dotenv.config()
Dotenv.config({path: resolve(process.cwd(), '.env.development')})

const environment = require('./environment')
const WebpackHtmlPlugin = require('html-webpack-plugin')
const root = resolve(process.cwd())

environment.plugins.append(
  'WebpackHtmlPlugin',
  new WebpackHtmlPlugin({
    chunks: ['main'],
    template: 'app/browser/html/main.pug',
    filename: 'main.html'
  })
)

environment.config.devServer.contentBase = root + '/app/browser/static'

module.exports = environment.toWebpackConfig()
