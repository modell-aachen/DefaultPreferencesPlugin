var path = require('path')
var projectRoot = path.resolve(__dirname);
var webpack = require('webpack')

var includeDirs = [
  projectRoot + '/dev',
];

module.exports = {
  resolve: {
    alias: {
      vue$: 'vue/dist/vue.common.js'
    }
  },
  babel: {
    presets: ['es2015', 'stage-2']
  },
  entry: {
    app: ['babel-polyfill', './dev/main.js']
  },
  output: {
    path: path.join(__dirname, 'pub/System/DefaultPreferencesPlugin/js'),
    filename: 'defaultPreferencesPlugin.js'
  },
  devtool: "source-map",
  module: {
    loaders: [
      {
        test: /\.vue$/,
        loader: 'vue',
        include: includeDirs
      },
      {
        test: /\.js$/,
        loader: 'babel',
        include: includeDirs
      },
      {
        test: /\.css$/,
        loader: 'style-loader!css-loader',
        include: includeDirs
      },
      {
        test: /\.json$/,
        loader: 'json',
        include: includeDirs
      },
      {
        test: /\.(woff2?|eot|ttf|otf|svg)(\?.*)?$/,
        loader: 'url',
        include: includeDirs
      }
    ]
  }
}
