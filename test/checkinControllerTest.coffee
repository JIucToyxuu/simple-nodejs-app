sinon = require 'sinon'
should = require 'should'
mongoose = require 'mongoose'

res =
  status: () ->
    return res
  send: () ->

Schema = mongoose.model('Checkin', {})
Checkin = mongoose.model('Checkin')
checkinController = require '../controllers/checkin'

describe 'Controller', () ->

  beforeEach () ->
    @sandbox = sinon.sandbox.create()
    @sandbox.spy(res, 'send')

  afterEach () ->
    @sandbox.restore()

  describe 'Create checkins', () ->
    beforeEach () ->
      @sandbox.stub(Checkin, 'create')

    context 'if input data is empty', () ->
      it 'should return error message', () ->
        req = {query: {}}
        checkinController.create(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty data')

    context 'if username empty', () ->
      it 'should return error message', () ->
        req = {query: {location:'NY'}}
        checkinController.create(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty username')

    context 'if location empty', () ->
      it 'should return error message', () ->
        req = {query: {username:'Gandalf'}}
        checkinController.create(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty location')

    it 'should call Checkin.create with correct parameters', () ->
      req = {query: {username: 'Anton', location: 'Taganrog'}}
      checkinController.create(req, res)
      args = Checkin.create.args[0]
      args[0].should.be.Object().and.eql({username: 'Anton', location: 'Taganrog'})
      args[1].should.be.Function()

    context 'if Checkin.create work without error', () ->
      it 'should return correct result', () ->
        user = {"_id": "Obj123", "username": "Anton", "location": "Taganrog"}
        req = {query: {username: 'Anton', location: 'Taganrog'}}
        Checkin.create.yields(null, user)
        checkinController.create(req, res)
        args = res.send.args[0]
        args[0].should.be.Object().and.eql(user)

    context 'if Checkin.create return error', () ->
      it 'should return error', () ->
        req = {query: {username: 'Anton', location: 'Taganrog'}}
        Checkin.create.yields('Achtung!', {})
        checkinController.create(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Achtung!')

  describe 'Search checkins', () ->
    beforeEach () ->
      @sandbox.stub(Checkin, 'find')

    context 'if search query is empty', () ->
      it 'should return error message', () ->
        req = {query: {}}
        checkinController.search(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty query. Please, use one parameter for search.')

    context 'if search query contain username and location', () ->
      it 'should return error message', () ->
        req = {query: {username: 'Anton', location: 'Taganrog'}}
        checkinController.search(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Invalid query. Please, use one parameter for search.')

    context 'if search do by location', () ->
      it 'should call Checkin.find with correct parameter', () ->
        req = {query: {location:'NY'}}
        checkinController.search(req, res)
        args = Checkin.find.args[0]
        args[0].should.be.Object().and.eql({location: 'NY'})
        args[1].should.be.Function()

    context 'if search do by username', () ->
      it 'should call Checkin.find with correct parameter', () ->
        req = {query: {username:'Gabriel'}}
        checkinController.search(req, res)
        args = Checkin.find.args[0]
        args[0].should.be.Object().and.eql({username: 'Gabriel'})
        args[1].should.be.Function()

    context 'if Checkin.find work without error', () ->
      it 'should return correct results', () ->
        user = {"_id": "Obj123", "username": "Anton", "location": "Taganrog"}
        Checkin.find.yields(null, [user])
        req = {query: {username:'Anton'}}
        checkinController.search(req, res)
        args = res.send.args[0]
        args[0].should.be.Array().and.eql([user])

    context 'if Checkin.find return error', () ->
      it 'should return error', () ->
        req = {query: {username:'Anton'}}
        Checkin.find.yields('Achtung!', [])
        checkinController.search(req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Achtung!')
