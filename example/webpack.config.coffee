module.exports =

  entry: "./app.coffee"
  output:
    path: __dirname
    filename: "app.js"
  resolve:
    moduleDirectories: ['node_modules']
    extensions: ['', '.webpack.js', '.web.js', '.js', '.coffee']
  module:
    loaders: [
      test: /\.coffee$/
      loaders: ["regenerator", "coffee", "cjsx"]
      exclude: "node_modules"
    ]
