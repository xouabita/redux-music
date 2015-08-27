co = require "co"

_api_iframe_init = no
_player_init     = no

player = null

waitForApiInit = -> new Promise (resolve, reject) ->
  rec = ->
    if _api_iframe_init then resolve()
    else setTimeout rec, 10
  rec()

waitForPlayerInit = ->

global.onYouTubeIframeAPIReady = ->
  _api_iframe_init = yes

createPlayer = -> new Promise (resolve, reject) ->
  new YT.Player 'player',
    videoId: 'YqeW9_5kURI'
    height: 0
    width: 0
    events:
      onReady: (e) ->
        resolve e.target

module.exports.initPlayer = initPlayer = -> co ->
  throw Error "Need to be in browser" if not global.document

  # place the iframe
  player = document.createElement 'div'
  player.id = "player"
  player.style.position = 'fixed'
  player.style.top = '-9999px'

  document.body.appendChild player

  # place the script
  tag = document.createElement 'script'
  tag.src = "https://www.youtube.com/iframe_api"
  document.body.appendChild tag

  yield waitForApiInit()
  player = yield createPlayer()
  player_tag = document.getElementById 'player'
  player_tag.style.display = 'none'
  player.playVideo()
