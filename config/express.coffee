express = require('express')
config = require('./init')

module.exports = (db) ->
  app = express();
  model = require '../models/checkin.model'
  routes = require('../routes/checkin.routes')(app)
  return app
