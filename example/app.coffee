React = require 'react'

# Import dependencies for redux
{ reducer, actions } = require '../src/index'
{ createStore, applyMiddleware, bindActionCreators } = require 'redux'

thunk        = require 'redux-thunk'
createLogger = require 'redux-logger'

# Create the store
logger = createLogger()
createStoreWithMiddlewares = applyMiddleware(thunk, logger) createStore
store = createStoreWithMiddlewares reducer

{ Component, PropTypes: T } = React

class PlayButton extends Component

  @propTypes:
    playing: T.bool
    play: T.func
    pause: T.func

  render: ->
    <button onClick={ @_handleClick }>
      { if @props.playing then "pause" else "play" }
    </button>

  _handleClick: =>
    if @props.playing then @props.pause()
    else @props.play()

class StopButton extends Component

  @propTypes:
    stop: T.func

  render: ->
    <button onClick={ @props.stop }>stop</button>

class PlaylistInput extends Component

  @propTypes:
    addSong: T.func

  constructor: (props) ->
    super props
    @state = value: ''

  render: ->
    <div className="add-song">
      <input value={@state.value} onChange={@_onChange} onKeyDown={@_onKeyDown} />
      <button onClick={@_submit}>Add Song</button>
    </div>

  _onChange: (e) => @setState value: e.target.value

  _submit: =>
    @props.addSong @state.value
    @setState value: ''

  _onKeyDown: (e) => if e.key is 'Enter' then @_submit()

class Playlist extends Component

  @propTypes:
    state: T.object

  render: ->
    { state } = @props
    <ul>
      {
        if state.playlist.length is 0 then <i>No songs :'(</i>
        else
          state.playlist.map (music, i) ->
            if state.paused is music
              style = color: 'orange'
            else if state.playlist[state.index] is music and state.playing
              style = color: 'green'
            else
              style = color: 'black'
            <li style={style} key={i}>{music}</li>
      }
    </ul>


class App extends Component

  @propTypes:
    actions: T.object
    state: T.object

  render: ->
    { playing, playlist, paused } = @props.state
    { play, pause, stop, addSong } = @props.actions
    <div>
      <PlayButton playing={playing} pause={pause} play={play} />
      <StopButton stop={stop} />
      <br/>
      <PlaylistInput addSong={addSong} />
      <Playlist state={@props.state} />
    </div>

{ Provider, connect } = require 'react-redux'

mapStateToProps = (state) -> state: state

mapDispatchToProps = (dispatch) ->
  actions: bindActionCreators actions, dispatch

AppContainer = connect(mapStateToProps, mapDispatchToProps)(App)

React.render(
  <Provider store={store}>
    { -> <AppContainer /> }
  </Provider>
, document.getElementById 'app')
