C      = require './constants'
assign = require 'object-assign'

_first_state =
  playlist: [] # Queue of url
  playing: no  # yes if music is playing
  index: -1    # Index of the playlist

radio = (state = _first_state, action) ->

  state = assign {}, state

  switch action.type

    when C.ADD_SONG
      state.playlist.push action.payload
      if state.index is -1 then state.index++

    when C.PLAY then state.playing = yes

    when C.PAUSE then state.playing = no

    when C.NEXT
      state.index++
      if state.index == state.playlist.length
        state.index = -1

    when C.PREV
      if state.index > 0 then state.index--

  return state

module.exports = radio
