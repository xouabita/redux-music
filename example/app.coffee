React = require 'react'

# Import dependencies for redux
{ reducer, actions } = require '../src/index'
{ createStore, applyMiddleware } = require 'redux'

thunk        = require 'redux-thunk'
createLogger = require 'redux-logger'

# Create the store
logger = createLogger()
createStoreWithMiddlewares = applyMiddleware(thunk, logger) createStore
store = createStoreWithMiddlewares reducer

store.dispatch actions.addSong("https://www.youtube.com/watch?v=YqeW9_5kURI")
store.dispatch actions.play()
