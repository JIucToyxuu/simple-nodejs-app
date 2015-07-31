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
    @sandbox.spy(res, 'status')

  afterEach () ->
    @sandbox.restore()

  describe 'Create checkins', () ->
    beforeEach () ->
      @sandbox.stub(Checkin, 'create').yields(null, [])

    context 'if input data is empty', () =>
      beforeEach () =>
        @req = {query: {}}

      it 'should return error message', () =>
        checkinController.create(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty data')

      it 'should return 400 status code of response', () =>
        checkinController.create(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(400)

    context 'if username empty', () =>
      beforeEach () =>
        @req = {query: {location:'NY'}}

      it 'should return error message', () =>
        checkinController.create(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty username')

      it 'should return 400 status code of response', () =>
        checkinController.create(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(400)

    context 'if location empty', () =>
      beforeEach () =>
        @req = {query: {username:'Gandalf'}}

      it 'should return error message', () =>
        checkinController.create(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty location')

      it 'should return 400 status code of response', () =>
        checkinController.create(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(400)

    it 'should call Checkin.create with correct parameters', () ->
      req = {query: {username: 'Anton', location: 'Taganrog'}}
      checkinController.create(req, res)
      args = Checkin.create.args[0]
      args[0].should.be.Object().and.eql({username: 'Anton', location: 'Taganrog'})
      args[1].should.be.Function()

    context 'if Checkin.create work without error', () =>
      beforeEach () =>
        @user = {"_id": "Obj123", "username": "Anton", "location": "Taganrog"}
        Checkin.create.yields(null, @user)
        @req = {query: {username: 'Anton', location: 'Taganrog'}}

      it 'should return correct result', () =>
        checkinController.create(@req, res)
        args = res.send.args[0]
        args[0].should.be.Object().and.eql(@user)

      it 'should return 200 status code of response', () =>
        checkinController.create(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(200)

    context 'if Checkin.create return error', () =>
      beforeEach () =>
        @req = {query: {username: 'Anton', location: 'Taganrog'}}
        Checkin.create.yields('Achtung!', {})

      it 'should return error', () =>
        checkinController.create(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Achtung!')

      it 'should return 500 status code of response', () =>
        checkinController.create(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(500)

  describe 'Search checkins', () ->
    beforeEach () ->
      @sandbox.stub(Checkin, 'find')

    context 'if search query is empty', () =>
      beforeEach ()=>
        @req = {query: {}}

      it 'should return error message', () =>
        checkinController.search(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Empty query. Please, use one parameter for search.')

      it 'should return 400 status code of response', () =>
        checkinController.search(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(400)

    context 'if search query contain username and location', () =>
      beforeEach () =>
        @req = {query: {username: 'Anton', location: 'Taganrog'}}

      it 'should return error message', () =>
        checkinController.search(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Invalid query. Please, use one parameter for search.')

      it 'should return 400 status code of response', () =>
        checkinController.search(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(400)

    context 'if search do by location', () ->
      it 'should call Checkin.find with correct parameter', () =>
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

    context 'if Checkin.find work without error', () =>
      beforeEach () =>
        @user = {"_id": "Obj123", "username": "Anton", "location": "Taganrog"}
        Checkin.find.yields(null, [@user])
        @req = {query: {username:'Anton'}}

      it 'should return correct results', () =>
        checkinController.search(@req, res)
        args = res.send.args[0]
        args[0].should.be.Array().and.eql([@user])

      it 'should return 200 status code of response', () =>
        checkinController.search(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(200)

    context 'if Checkin.find return error', () =>
      beforeEach () =>
        Checkin.find.yields('Achtung!', [])
        @req = {query: {username:'Anton'}}

      it 'should return error', () =>
        checkinController.search(@req, res)
        args = res.send.args[0]
        args[0].should.be.String().and.eql('Achtung!')

      it 'should return 404 status code of response', () =>
        checkinController.search(@req, res)
        args = res.status.args[0]
        args[0].should.be.Number().and.eql(404)
