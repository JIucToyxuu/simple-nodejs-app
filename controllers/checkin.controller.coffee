mongoose = require('mongoose')
Checkin = mongoose.model('Checkin')


exports.create = (req, res) ->
  if req.query.username? && req.query.location?
    params =
      username: req.query.username,
      location: req.query.location

    Checkin.create params, (err, checkin) ->
      if err?
        res.send(err)
      else
        res.send(checkin)
  else if req.query.username?
    res.send('Empty location')
  else if req.query.location?
    res.send('Empty username')
  else
    res.send('Empty data')

exports.search = (req, res) ->
  if req.query.username? && req.query.location?
    res.send('Invalid query. Please, use correct parameter for search.')
  else if !req.query.username? && !req.query.location?
    res.send('Empty query. Please, use one parameter for search.')
  else
    if req.query.username?
      query =
        username: req.query.username

    if req.query.location?
      query =
        location: req.query.location

    Checkin.find query, (err, results) ->
      if err?
        res.send(err)
      else
        res.send(results)
