require('es6-promise').polyfill()

YoutubeAdapter = require './youtube'
co = require 'co'

do -> co ->
  yt = new YoutubeAdapter()
  yield yt.init()
  yt.play "https://www.youtube.com/watch?v=YqeW9_5kURI"
