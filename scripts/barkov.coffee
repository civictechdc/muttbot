# Description:
#   Barkov
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot barkov - bark
#
# Author:
#   stvnrlly
barks = ['bark ', 'bark, bark ', 'bark. Bark ', 'bark bark ', 'bark bark, bark ', 'bark? Bark ']

module.exports = (robot) ->
  robot.respond /barkov/i, (msg) ->
    bark = 'Bark '
    loops = Math.floor(Math.random() * 8) + 1
    bark += msg.random barks while loops -=1
    msg.send bark + 'bark.'
