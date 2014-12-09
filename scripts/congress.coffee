# Description:
#   Get information about Congress
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot congress - find out about Congress
#
# Author:
#   stvnrlly
module.exports = (robot) ->

    robot.respond /congress\svotes/i, (msg) ->
        key = "fe69c34dcbc54e6e9617628920da0ad7"
        msg.http("https://congress.api.sunlightfoundation.com/votes?order=voted_at&apikey=#{key}")
        .get() (err, resp, body) ->
            votes = JSON.parse body
            for i in votes.results
                chamber = (i.chamber.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
                votetime = new Date(i.voted_at).toDateString()
                msg.send chamber + " @ " + votetime + " | " + i.question + ": " + i.result
