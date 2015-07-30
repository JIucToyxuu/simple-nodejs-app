sinon = require 'sinon'
should = require 'should'
mongoose = require 'mongoose'

req =
  query:
    username: 'Anton'
    location: 'Taganrog'
res =
  send: () ->


Schema = mongoose.model('Checkin', {})
Checkin = mongoose.model('Checkin')
checkinController = require '../controllers/checkin.controller'


describe 'Controller', () ->

  beforeEach () ->
    @sandbox = sinon.sandbox.create()
    @sandbox.spy(checkinController, 'create')
    @sandbox.spy(checkinController, 'search')
    @sandbox.stub(res, 'send')
    @sandbox.stub(Checkin, 'create')
    @sandbox.stub(Checkin, 'find')

  afterEach () ->
    @sandbox.restore()

  context 'Create checkins', () ->
    it 'should return error message if input data is empty', () ->
      checkinController.create({query: {}}, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Empty data')

    it 'should return error message if username empty', () ->
      checkinController.create({query: {location:'NY'}}, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Empty username')

    it 'should return error message if location empty', () ->
      checkinController.create({query: {username:'Gandalf'}}, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Empty location')

    it 'should call Checkin.create with correct parameters', () ->
      checkinController.create(req, res)
      args = Checkin.create.args[0]
      args[0].should.be.Object().and.eql({username: 'Anton', location: 'Taganrog'})
      args[1].should.be.Function()

    it 'should return correct result if Checkin.create work without error', () ->
      Checkin.create.yields(null, {"_id": "Obj123", "username": "Anton", "location": "Taganrog"})
      checkinController.create(req, res)
      args = res.send.args[0]
      args[0].should.be.Object().and.eql({"_id": "Obj123", "username": "Anton", "location": "Taganrog"})

    it 'should return error if Checkin.create return error', () ->
      Checkin.create.yields('Achtung!', {})
      checkinController.create(req, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Achtung!')

  context 'Search checkins', () ->
    it 'should return error message if search query is empty', () ->
      checkinController.search({query: {}}, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Empty query. Please, use one parameter for search.')

    it 'should return error message if search query contain username and location', () ->
      checkinController.search(req, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Invalid query. Please, use correct parameter for search.')

    it 'should call Checkin.find with correct parameter if search do by location', () ->
      checkinController.search({query: {location:'NY'}}, res)
      args = Checkin.find.args[0]
      args[0].should.be.Object().and.eql({location: 'NY'})
      args[1].should.be.Function()

    it 'should call Checkin.find with correct parameter if search do by username', () ->
      checkinController.search({query: {username:'Gabriel'}}, res)
      args = Checkin.find.args[0]
      args[0].should.be.Object().and.eql({username: 'Gabriel'})
      args[1].should.be.Function()

    it 'should return correct results if Checkin.find work without error', () ->
      Checkin.find.yields(null, [{"_id": "Obj123", "username": "Anton", "location": "Taganrog"}])
      checkinController.search({query: {username:'Anton'}}, res)
      args = res.send.args[0]
      args[0].should.be.Array().and.eql([{"_id": "Obj123", "username": "Anton", "location": "Taganrog"}])

    it 'should return error if Checkin.find return error', () ->
      Checkin.find.yields('Achtung!', [])
      checkinController.search({query: {username:'Anton'}}, res)
      args = res.send.args[0]
      args[0].should.be.String().and.eql('Achtung!')
