goodbyes = [
  "Bye, {name}.",
  "Later, {name}.",
  "Take care, {name}."
]

goodbye = (name) ->
  index = parseInt(Math.random() * goodbyes.length)
  message = goodbyes[index]
  message.replace(/{name}/, name);

module.exports = (robot) ->
  robot.hear /(bye|later|see\ ya),?\s(.*)/i, (msg) ->
    if robot.name.toLowerCase() == msg.match[2].toLowerCase()
      byeMessage = goodbye(msg.message.user.name)
      msg.send(byeMessage)
