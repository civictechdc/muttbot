# Description:
#   Bees are insane
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   bees - Bees?
#
# Author:
#   atmos
#   forked from https://github.com/github/hubot-scripts/blob/master/src/scripts/bees.coffee to add extra fun

module.exports = (robot) ->
  robot.hear /bee+s?\b/i, (message) ->
    probability = Math.random()
    if probability < 0.95
        message.send "https://i.imgur.com/qrLEV.gif"
    else
        message.send "https://i.imgur.com/h3rC2yM.gif"
