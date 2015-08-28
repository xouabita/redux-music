require('es6-promise').polyfill()

module.exports =
  actions: require './actions'
  reducer: require './reducer'
