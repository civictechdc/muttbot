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
#   hubot explain yourself - Request an explanation for what just happened
#
# Author:
#   stvnrlly
#
attempts = [
    "Seemed like a good idea",
    "It makes a lot of sense to me",
    "I...don't really know",
    "I think it's pretty clear",
    "We're all having a pretty good time here",
    "Haha",
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
