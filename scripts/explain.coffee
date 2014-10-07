# Description:
#   Sometimes a hubot needs to explain itself
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot explain yourself - Request an explanation
#
# Author:
#   stvnrlly
#
attempts = [
    "Seemed like a good idea",
    "It makes a lot of sense to me",
    "I...don't really know",
    "I think it's pretty clear",
    "It's perfect!",
    "We're all having a pretty good time here",
    "I'm drunk",
    "Oh, oops",
    "No",
    "https://i.imgur.com/5foan.gif",
    "I will not",
    "I am a robot and lack judgment"
]

module.exports = (robot) ->
  robot.respond /.*explain (yourself|this)\?*/i, (msg) ->
    msg.send msg.random attempts
