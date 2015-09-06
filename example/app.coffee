React = require 'react'

# Import dependencies for redux
{ reducer, actions } = require '../src/index'
{ createStore, applyMiddleware, bindActionCreators, compose } = require 'redux'

thunk        = require 'redux-thunk'
createLogger = require 'redux-logger'
stayThere    = require 'redux-staythere'

# Create the store
logger = createLogger()
finalCreateStore = compose(applyMiddleware(thunk, logger), stayThere('1')) createStore
store = finalCreateStore reducer

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
    deleteSong: T.func

  render: ->
    { state } = @props
    <ul>
      {
        if state.playlist.length is 0 then <i>No songs :'(</i>
        else
          state.playlist.map (music, i) =>
            if state.paused is music
              style = color: 'orange'
            else if state.playlist[state.index] is music and state.playing
              style = color: 'green'
            else
              style = color: 'black'
            <li style={style} key={i}>
              {music}
              <button onClick={ => @props.deleteSong i }>delete</button>
            </li>
      }
    </ul>


class App extends Component

  @propTypes:
    actions: T.object
    state: T.object

  render: ->
    { playing, playlist, paused } = @props.state
    {
      play, pause, stop, addSong, deleteSong,
      next, prev
    } = @props.actions
    <div>
      <PlayButton playing={playing} pause={pause} play={play} />
      <button onClick={stop}>stop</button>
      <button onClick={prev}><<</button>
      <button onClick={next}>>></button>
      <br/>
      <PlaylistInput addSong={addSong} />
      <Playlist state={@props.state} deleteSong={deleteSong} />
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
