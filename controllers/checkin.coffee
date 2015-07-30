mongoose = require('mongoose')
Checkin = mongoose.model('Checkin')


exports.create = (req, res) ->
  if !req.query.username && !req.query.location
    return res.status(400).send('Empty data')
  if !req.query.username
    return res.status(400).send('Empty username')
  if !req.query.location
    return res.status(400).send('Empty location')

  params =
    username: req.query.username.trim()
    location: req.query.location.trim()

  Checkin.create params, (err, checkin) ->
    if err?
      return res.status(500).send(err)
    return res.status(200).send(checkin)


exports.search = (req, res) ->
  if req.query.username? && req.query.location?
    return res.status(400).send('Invalid query. Please, use one parameter for search.')
  if !req.query.username? && !req.query.location?
    return res.status(400).send('Empty query. Please, use one parameter for search.')

  if req.query.username?
    query =
      username: req.query.username

  if req.query.location?
    query =
      location: req.query.location

  Checkin.find query, (err, results) ->
    if err?
      return res.status(404).send(err)
    return res.status(200).send(results)
