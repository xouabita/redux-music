C = require './constants'

YoutubeHandler = require './youtube'
_yt = new YoutubeHandler()
_yt.init()

module.exports.addSong = (url) ->
  type: C.ADD_SONG
  payload: url
