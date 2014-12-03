# Description:
#   ¯\_(ツ)_/¯
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   what's the deal - What is the DEAL
#
# Author:
#   stvnrlly
module.exports = (robot) ->
  robot.hear /what's\sthe\sdeal\b/i, (message) ->
    probability = Math.random()
    if probability < 0.95
        message.send "https://i.imgur.com/ozk9WuG.jpg"
    else
        message.send "https://i.imgur.com/OkP6G9Z.jpg"
