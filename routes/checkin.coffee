checkins = require('../controllers/checkin')

module.exports = (app) ->
  app.get '/checkin', (req, res) ->
    checkins.create req, res
  app.get '/query', (req, res) ->
    checkins.search req, res
