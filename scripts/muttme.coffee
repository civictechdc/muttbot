# Description:
#   Mutt me
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot mutt me - Mutt Badley
#   hubot mutt bomb N - more Mutt Badleys

module.exports = (robot) ->

  robot.respond /mutt( me)?/i, (msg) ->
    msg.send "https://pbs.twimg.com/profile_images/466736666074308608/b3w4v4Zx.jpeg"

  robot.respond /mutt bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    for n in count
      msg.send "https://pbs.twimg.com/profile_images/466736666074308608/b3w4v4Zx.jpeg"
