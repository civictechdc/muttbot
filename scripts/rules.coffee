# Description:
#   Make sure that hubot knows the rules.
#
# Commands:
#   hubot the rules - Make sure hubot still knows the rules.
#
# Notes:
#   DON'T DELETE THIS SCRIPT! ALL ROBAWTS MUST KNOW THE RULES

rules = [
  "1. Agnostic on the same",
  "2. On earth, on this. Lest people taking a totally sure the first class on their absurdly slow you have some other members have to compile all do I guess",
  "3. To review, why redundancy"
  ]

module.exports = (robot) ->
  robot.respond /(what are )?the (three |3 )?(rules|laws)/i, (msg) ->
    text = msg.message.text
    if text.match(/apple/i) or text.match(/dev/i)
      msg.send otherRules.join('\n')
    else
      msg.send rules.join('\n')

