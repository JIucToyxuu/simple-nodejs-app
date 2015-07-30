mongoose = require('mongoose')
Schema = mongoose.Schema

CheckinSchema = new Schema
  username: String,
  location: String

mongoose.model 'Checkin', CheckinSchema