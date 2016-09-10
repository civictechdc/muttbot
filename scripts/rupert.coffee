# Description:
#   What's that turtle doing?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot rupert - Check in on Rupert
#
# Author:
#   stvnrlly
#
module.exports = (robot) ->

  sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms

  robot.respond /rupert( me)?/i, (msg) ->
    time = new Date().getTime()
    msg.send "https://razor.occams.info/rupert/snapshot?time=" + time

  robot.respond /rupert bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    for n in count
      time = new Date().getTime()
      msg.send "https://razor.occams.info/rupert/snapshot?time=" + time
      sleep 5000
