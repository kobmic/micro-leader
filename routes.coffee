
path = require 'path'

Leaderboard = require './leaderboard'

board = new Leaderboard()

module.exports = (app, static_route) ->
    #static_route is the path the the application static resources

    app.get '/', (req,res)->
        res.render 'index',
            board.current()


    return {}
    
