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
  robot.hear /what's\sthe\sdeal\b/i, (message) ->
    probability = Math.random()
    if probability < 0.95
        message.send "https://i.imgur.com/ozk9WuG.jpg"
    else
        message.send "https://i.imgur.com/OkP6G9Z.jpg"
