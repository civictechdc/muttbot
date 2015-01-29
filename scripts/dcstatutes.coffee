# Description:
#   DC Statutes at Large
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot dcstat -
#
# Author:
#   stvnrlly
module.exports = (robot) ->
    robot.respond /dcstat\s(search)\s(.+)/i, (msg) ->
        if msg.match[1] == "search"
            term = msg.match[2].replace(/\s/g, "%20")
            url = 'https://dcstat.dccode.gov/api/search/?q="'+term+'"'
            msg.http(url)
            .get() (err, resp, body) ->
                results = JSON.parse body
                for i in results["results"]
                    msg.send i["obj"]["title"]
