express = require('express')
config = require('./init')

module.exports = (db) ->
  app = express();
  require '../models/checkin'
  require('../routes/checkin')(app)
  return app
