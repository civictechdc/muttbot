# Description:
#   le tired
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   le tired - take a nap
#
# Author:
#   stvnrlly
module.exports = (robot) ->
  robot.hear /le\stired\b/i, (message) ->
    message.send "https://gs1.wac.edgecastcdn.net/8019B6/data.tumblr.com/tumblr_lsf0l8K1s41qhry5go1_500.gif"
