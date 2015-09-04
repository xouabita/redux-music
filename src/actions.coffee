C  = require './constants'
co = require 'co'

YoutubeHandler = require './youtube'
_yt = new YoutubeHandler()
_yt.init()

module.exports.addSong = (url) ->
  type: C.ADD_SONG
  payload: url

module.exports.play = -> (dispatch, getState) -> co ->
  { playlist, index } = getState()
  yield _yt.play playlist[index]
  dispatch type: C.PLAY
