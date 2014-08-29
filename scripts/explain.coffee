# Description:
#   Sometimes a hubot needs to explain itself
#
# Commands:
#   hubot explain yourself - Request an explanation
#

attempts = [
    "Seemed like a good idea",
    "It makes a lot of sense to me",
    "I...don't really know",
    "I think it's pretty clear",
    "No",
    "https://i.imgur.com/5foan.gif",
    "I will not",
    "I am a robot and lack judgment"
]

module.exports = (robot) ->
  robot.respond /.*explain (yourself|this)\?*/i, (msg) ->
    msg.reply msg.random attempts
