module.exports =

  entry: "./src/index.coffee"
  output:
    path: __dirname
    filename: "index.js"
  resolve:
    moduleDirectories: ['node_modules']
    extensions: ['', '.webpack.js', '.web.js', '.js', '.coffee']
  module:
    loaders: [
      test: /\.coffee$/
      loaders: ["regenerator", "coffee"]
      exclude: "node_modules"
    ]
