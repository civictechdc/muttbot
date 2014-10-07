# Description:
#	 Deep thought generator
#
# Dependencies:
#	None
#
# Configuration:
#   None
#
# Commands:
#	 hubot deep thought - Get a random deep thought.
#
# Notes:
#	 None
#
# Author:
#	 @commadelimited

# Configures the plugin
module.exports = (robot) ->
    # waits for the string "hubot deep" to occur
    robot.respond /deep( thought)?/i, (msg) ->
        # Configures the url of a remote server
        msg.http('http://andymatthews.net/thought/')
            # and makes an http get call
            .get() (error, response, body) ->
                results = JSON.parse body
                thought = results.thought.replace /&quot;/g, '"'
                # passes back the complete reponse
                msg.send thought
