C  = require './constants'
co = require 'co'

YoutubeHandler = require './youtube'
_yt = new YoutubeHandler()
_yt.init()

module.exports.addSong = (url) ->
  type: C.ADD_SONG
  payload: url

module.exports.play = -> (dispatch, getState) -> co ->
  { playlist, index, paused } = getState()
  if paused then yield _yt.play()
  else yield _yt.play playlist[index]
  dispatch type: C.PLAY

module.exports.pause = -> (dispatch) ->
  _yt.pause()
  dispatch type: C.PAUSE

module.exports.stop = -> (dispatch) ->
  _yt.pause()
  dispatch type: C.STOP
