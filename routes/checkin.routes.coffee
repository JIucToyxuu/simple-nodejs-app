checkins = require('../controllers/checkin.controller')

module.exports = (app) ->
  app.get '/checkin', (req, res) ->
    console.log 1
    checkins.create req, res
  app.get '/query', (req, res) ->
    checkins.search req, res
