express = require 'express'
path = require 'path'

module.exports = (initFn)->
    app = express()

    module.exports.static_route
    app.configure ->
        app.set('port', process.env.PORT || 8080);
        app.use(express.favicon())
        app.use(express.methodOverride())
        app.use(express.limit('2mb'));

    app.configure 'development', ->
        app.use express.logger({ format: 'short' })
        app.use express.errorHandler()

    app.configure 'test', ->
        app.use express.errorHandler()

    app.configure ->
        app.use(app.router)

    app.configure ->
        module.exports.static_route = path.join __dirname, 'public'
        oneYear = 1000*60*60*24*365
        app.use(express.static(path.join(__dirname, 'public'),{ maxAge: oneYear }))

        app.set 'view engine', 'html'
        app.engine 'html', require('hogan-express')
        app.set('layout', 'layout')
        app.set('partials', head: "head")
        app.set('views', __dirname + '/public/views')

    #Init Routes
    require('./routes')(app, module.exports.static_route)

    if initFn?
        http = require 'http'
        server = http.createServer app



        server.listen app.get('port'), initFn
    app


    