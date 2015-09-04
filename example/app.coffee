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

class App extends Component

  @propTypes:
    actions: T.object
    state: T.object

  render: ->
    { playing } = @props.state
    { play, pause, stop } = @props.actions
    <div>
      <PlayButton playing={playing} pause={pause} play={play} />
      <StopButton stop={stop} />
    </div>

{ Provider, connect } = require 'react-redux'

mapStateToProps = (state) -> state: state

mapDispatchToProps = (dispatch) ->
  actions: bindActionCreators actions, dispatch

AppContainer = connect(mapStateToProps, mapDispatchToProps)(App)

store.dispatch actions.addSong "https://www.youtube.com/watch?v=YqeW9_5kURI"

React.render(
  <Provider store={store}>
    { -> <AppContainer /> }
  </Provider>
, document.getElementById 'app')
