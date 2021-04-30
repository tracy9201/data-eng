const webpack = require('webpack')
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer')
  .BundleAnalyzerPlugin
const { getWebpackDefinePlugin } = require('./utils')

const emptyFunc = () => {}

module.exports = (env = {}) => {
  const isProd = !!env.prod
  const isAnalysis = !!env.analysis
  const table = ['./src/components/table/index.js']
  const stmt = ['./src/components/statement/index.js']
  const str = ['./src/components/string/index.js']

  return {
    mode: isProd ? 'production' : 'development',
    stats: 'errors-warnings',
    target: 'web',
    entry: {
      table: table,
      stmt: stmt,
      str: str,
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../dist'),
    },
    resolve: {
      alias: {
        '@settings': path.resolve(__dirname, '../settings.js'),
        '@utils': path.resolve(__dirname, '../src/utils'),
        '@components': path.resolve(__dirname, '../src/components'),
        '@hooks': path.resolve(__dirname, '../src/hooks'),
        '@dist': path.resolve(__dirname, '../dist'),
      },
      extensions: ['.js'],
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: [
                ['@babel/preset-env', { targets: 'defaults, not ie 10-11' }],
                ['@babel/preset-react'],
              ],
              plugins: ['@babel/plugin-proposal-class-properties'],
            },
          },
        },
      ],
    },
    plugins: [
      new HtmlWebpackPlugin({
        filename: 'index.html',
        templateContent: ({ htmlWebpackPlugin }) => `
          <html>
            <head>
              ${htmlWebpackPlugin.tags.headTags}
            </head>
            <body>
              <div id="vis"></div>
              ${htmlWebpackPlugin.tags.bodyTags}
            </body>
          </html>
        `,
      }),
      new webpack.DefinePlugin(
        getWebpackDefinePlugin({
          __CLIENT__: true,
          __SERVER__: false,
          __DEV__: !isProd,
          __PROD__: isProd,
        })
      ),
      isProd ? new CompressionPlugin() : emptyFunc,
      isAnalysis ? new BundleAnalyzerPlugin() : emptyFunc,
    ],
    devtool: !isProd
      ? 'cheap-module-source-map'
      : 'hidden-cheap-module-source-map',
  }
}
