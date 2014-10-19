# Description:
#	 Look at outer space
#
# Dependencies:
#	"cheerio": "0.17.0"
#
# Configuration:
#   None
#
# Commands:
#	 hubot space - Get a random picture of space.
#
# Notes:
#	 None
#
# Author:
#	 @stvnrlly
cheerio = require("cheerio")

module.exports = (robot) ->
    robot.respond /space( me)?/i, (msg) ->
        start = new Date('06/16/1995')
        today = new Date()
        date = new Date(start.getTime() + Math.random() * (today.getTime() - start.getTime()))
        day = ("0" + date.getDate()).slice(-2)
        month = ("0" + (date.getMonth() + 1)).slice(-2)
        year = ("0" + date.getYear()).slice(-2)
        url = "http://apod.nasa.gov/apod/ap"+year+month+day+".html"
        msg.http(url).get() (err, resp, body) ->
            $ = cheerio.load(body)
            msg.send "http://apod.nasa.gov/apod/" + $('img').attr('src')
