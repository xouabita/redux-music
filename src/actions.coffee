C  = require './constants'
co = require 'co'

YoutubeHandler = require './youtube'
_yt = new YoutubeHandler()
_yt.init()

module.exports.addSong = addSong = (url) ->
  if url.match /watch\?v=([a-zA-Z0-9\-_]+)/
    type: C.ADD_SONG
    payload: url
  else throw Error 'invalid youtube url'

module.exports.play = play = -> (dispatch, getState) -> co ->
  { playlist, index, paused } = getState()
  if paused then yield _yt.play()
  else yield _yt.play playlist[index]
  dispatch type: C.PLAY

module.exports.pause = pause = ->
  _yt.pause()
  return type: C.PAUSE

module.exports.stop = stop = ->
  _yt.pause()
  return type: C.STOP

module.exports.deleteSong = deleteSong = (index) ->
  type: C.DELETE_SONG
  payload: index

