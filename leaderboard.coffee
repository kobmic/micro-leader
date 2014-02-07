amqp = require 'amqp'

rabbitMqConnection = amqp.createConnection({ host: 'localhost' })

onlineMsg =
    createdBy: "Mike",
    description: "Leaderboard UI service, listening to leaderboard messages",
    sourceUrl:"https://github.com/kobmic/micro-leader",
    serviceUrl:"http://someurl1.com"


options =
    headers: {appId: 'leaderboard-ui', streamId: 'leaderboard-ui', timestamp: new Date(), messageId: 1, type: 'ServiceOnlineEvent'}

rabbitMqConnection.on 'ready', () ->
    console.log 'Connected!'
    exchange = rabbitMqConnection.exchange('lab');
    queue = rabbitMqConnection.queue('leaderboard-ui-queue');
    queue.bind(exchange, '#')

    exchange.publish(queue.name, { body: onlineMsg }, options);

    queue.subscribe (msg) ->
        console.log msg.body




class Leaderboard

    constructor: () ->


    current: () ->
        result =
            leaders: [{name: "mike", wins: "5"},{name: "mattias", wins: "3"}]
        return result

module.exports = Leaderboard
