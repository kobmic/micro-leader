amqp = require 'amqp'

local =
    host: 'localhost'

laburl = {url: 'amqp://kwiwswxf:2buomLESEgNRRdMWXJ-fFLbpP61mX8Pu@striped-ibex.rmq.cloudamqp.com/kwiwswxf'}

rabbitMqConnection = amqp.createConnection(laburl)
#rabbitMqConnection = amqp.createConnection(local)



onlineMsg =
    createdBy: "Mike",
    description: "Leaderboard UI service, listening to leaderboard messages",
    sourceUrl:"https://github.com/kobmic/micro-leader",
    serviceUrl:"http://someurl1.com"


options =
    headers: {appId: 'leaderboard-ui', streamId: 'leaderboard-ui', timestamp: new Date(), messageId: 1, type: 'ServiceOnlineEvent'}






class Leaderboard

    constructor: () ->
        rabbitMqConnection.on 'ready', () ->
            console.log 'Connected!'
            exchange = rabbitMqConnection.exchange('lab', options: {type: 'topic'});
            queue = rabbitMqConnection.queue('leaderboard-ui-queue');
            queue.bind(exchange, '#')

            console.log "publish service online message..."
            exchange.publish(queue.name, { body: onlineMsg }, options);

            queue.subscribe (msg, headers, deliveryInfo) ->
                console.log "Headers:", headers
                console.log msg.body


    current: () ->
        result =
            leaders: [{name: "mike", wins: "5"},{name: "mattias", wins: "3"}]
        return result

module.exports = Leaderboard
