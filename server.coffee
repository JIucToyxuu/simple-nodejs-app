'use strict';

express = require('express')
config = require('./config/init')
mongoose = require('mongoose')
chalk = require('chalk')

db = mongoose.connect config.db, (err) ->
  if err?
    console.error(chalk.red('Could not connect to MongoDB!'))
    console.log(chalk.red(err))

app = require('./config/express')(db)

server = app.listen config.port, () ->
  host = server.address().address
  port = server.address().port
  console.log('Simple NodeJS app listening at http://%s:%s', host, port)
