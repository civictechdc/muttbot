# Description:
#   Watch yourself, counselor
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   objection! - state your objection, get a ruling
#
# Author:
#   stvnrlly
rulings = [
    "Overruled",
    "Sustained",
    "Sustained, I've had quite enough of that for today",
    "Hmmm, I'll allow it",
    "I'll allow it, but watch yourself, counselor",
    "You're treading a fine line here",
    "Overruled, I want to see where this is going",
    "Chambers, NOW",
    "https://media.giphy.com/media/w6MNHOoLEzBVm/giphy.gif",
    "https://media.giphy.com/media/3HAYjf986boJO698zIY/giphy.gif",
    "https://media.giphy.com/media/lacBmAzmK37cQ/giphy.gif",
    "https://media.giphy.com/media/ySP41n2hS2tdS/giphy.gif",
    "https://media3.giphy.com/media/e8IBXAqD9iY1O/giphy.gif",
    "http://glitchcat.com/wp-content/uploads/2012/08/xlarge.png"
    "https://i.imgur.com/YbFUBHU.gif",
    "http://www.legaljuice.com/files/2013/09/judge-gavel-order-in-the-court.gif"
]

module.exports = (robot) ->
  robot.hear /objection!/i, (message) ->
    msg.send msg.random rulings