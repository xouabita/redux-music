co = require "co"

_api_iframe_init = no
_player_init     = no

_id              = 0

waitForApiInit = -> new Promise (resolve, reject) ->
  rec = ->
    if _api_iframe_init then resolve()
    else setTimeout rec, 10
  rec()

global.onYouTubeIframeAPIReady = ->
  _api_iframe_init = yes

createPlayer = (player_id) -> new Promise (resolve, reject) ->
  new YT.Player player_id,
    height: 0
    width: 0
    events:
      onReady: (e) ->
        resolve e.target

youTubeGetID = (url) ->
  ID = ''
  url = url.replace(/(>|<)/gi,'').split /(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/
  if url[2] isnt undefined
    ID = url[2].split /[^0-9a-z_\-]/i
    ID = ID[0]
  else
    ID = url
  return ID

class YoutubeHandler

  constructor: ->

    # Detect if not in browser
    throw Error "Need to be in browser" if not global.document

    # Init private variables
    @_player    = null
    @_ready     = no
    @_player_id = "yt_player_#{++_id}"

    # place the iframe
    player = document.createElement 'div'
    player.id = @_player_id
    player.style.position = 'fixed'
    player.style.top = '-9999px'
    document.body.appendChild player

    # place the script
    tag = document.createElement 'script'
    tag.src = "https://www.youtube.com/iframe_api"
    document.body.appendChild tag

  init: => co =>
    yield waitForApiInit()
    @_player = yield createPlayer @_player_id
    @_ready  = yes

  isReady: -> return @_ready

  waitReady: => new Promise (res, rej) =>
    rec = =>
      if @_ready then res()
      else setTimeout rec
    rec()

  play: (url, start_time = 0, stop_time) => co =>
    if not @_ready then yield waitReady()

    if not url
      @_player.playVideo()
      return

    id = youTubeGetID url

    @_player.loadVideoById
      videoId: id
      startSeconds: start_time
      endSeconds: stop_time if stop_time?

  pause: =>
    @_player.pauseVideo()


module.exports = YoutubeHandler
