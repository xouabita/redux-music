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

mapStateToProps = (state) ->
  playing: state.playing

mapDispatchToProps = (dispatch) ->
  actions: bindActionCreators actions, dispatch

class PlayButton extends Component

  @propTypes:
    playing: T.bool
    actions: T.object

  render: ->
    <button onClick={ @_handleClick }>
      { if @props.playing then "pause" else "play" }
    </button>

  _handleClick: =>
    if @props.playing then @props.actions.pause()
    else @props.actions.play()

{ Provider, connect } = require 'react-redux'

PlayButtonContainer = connect(mapStateToProps, mapDispatchToProps)(PlayButton)

store.dispatch actions.addSong "https://www.youtube.com/watch?v=YqeW9_5kURI"

React.render(
  <Provider store={store}>
    { -> <PlayButtonContainer /> }
  </Provider>
, document.getElementById 'app')
