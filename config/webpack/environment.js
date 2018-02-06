var { environment }     = require('@rails/webpacker')
const elm               =  require('./loaders/elm')
const pug               =  require('./loaders/pug')
const webpack           = require('webpack')

environment.loaders.append('elm', elm)
environment.loaders.append('pug', pug)

const sassEnvIndex = environment.loaders.findIndex(function(element) {
  return element.key == 'sass'
})

const sassLoaderIndex = environment.loaders[sassEnvIndex].value.use.findIndex(function(element) {
  return element.loader == 'sass-loader'
})

if (Array.isArray(environment.loaders[sassEnvIndex].value.use[sassLoaderIndex].options.includePaths)) {
  environment.loaders[sassEnvIndex].value.use[sassLoaderIndex].options.includePaths.append('node_modules')
} else {
  environment.loaders[sassEnvIndex].value.use[sassLoaderIndex].options.includePaths = ['node_modules']
}

environment.plugins.append(
  'ProvidePlugin',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Hammer: 'hammerjs/hammer'
  })
)

module.exports = environment
