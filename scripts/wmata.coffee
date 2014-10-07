# Description:
#   Get status information from WMATA
#
# Dependencies:
#   node-geocoder
#
# Configuration:
#   HUBOT_WMATA_API_KEY
#
# Commands:
#   hubot wmata - show status of all rail lines
#   hubot wmata <bus route> - show status for bus route
#   hubot wmata <bus stop ID> - show arrivals for bus stop
#   hubot wmata <address> - show stations and bus stops near address
#   hubot wmata <line color> - show status of rail line
#   hubot wmata <station name> - show arrivals for station
#
# Author:
#   stvnrlly
#
geocoder = require('node-geocoder').getGeocoder('google', 'http', {})

stations =
    "metro center": ["a01","c01"],
    "farragut north": "a02",
    "dupont": ["a03"],
    "woodley": "a04",
    "adams": "a04",
    "cleveland": "a05",
    "van ness": "a06",
    "udc": "a06",
    "tenleytown": "a07",
    "au": "a07",
    "american": "a07",
    "friendship": "a08",
    "bethesda": "a09",
    "medical": "a10",
    "grosvenor": "a11",
    "strathmore": "a11"
    "white": "a12",
    "twinbrook": "a13",
    "rockville": "a14",
    "shady": "a15",
    "gallery": ["b01","e01","f01"],
    "chinatown": ["b01","e01","f01"],
    "judiciary": "b02",
    "union": "b03",
    "new york": "b35",
    "gallaudet": "b35",
    "rhode": "b04",
    "brentwood": "b04",
    "brookland": "b05",
    "catholic": "b05",
    "fort": ["b06","e06"],
    "takoma": "b07",
    "silver": "b08",
    "forest": "b09",
    "wheaton": "b10",
    "glenmont": "b11",
    "mcpherson": "c02",
    "farragut west": "c03",
    "foggy": "c04",
    "george": "c04",
    "gwu": "c04",
    "rosslyn": "c05",
    "arlington": "c06",
    "pentagon": "c07",
    "pentagon city": "c08",
    "crystal": "c09",
    "ronald": "c10",
    "reagan": "c10",
    "national": "c10",
    "braddock": "c12",
    "king": "c13",
    "eisenhower": "c14",
    "huntington": "c15",
    "federal triangle": "d01",
    "smithsonian": "d02",
    "l\'enfant": ["d03","f03"],
    "federal center": "d04",
    "capitol south": "d05",
    "eastern": "d06",
    "potomac": "d07",
    "stadium": "d08",
    "minnesota": "d09",
    "deanwood": "d10",
    "cheverly": "d11",
    "landover": "d12",
    "new carrolton": "d13",
    "mt vernon": "e01",
    "convention": "e01",
    "shaw": "e02",
    "howard": "e02",
    "u st": "e03",
    "african": "e03",
    "cardozo": "e03",
    "columbia": "e04",
    "georgia": "e05",
    "petworth": "e05",
    "west hyattsville": "e07",
    "prince": "e08",
    "college park": "e09",
    "umd": "e09",
    "greenbelt": "e10",
    "archives": "f02",
    "penn": "f02",
    "waterfront": "f04",
    "seu": "f04",
    "navy": "f05",
    "anacostia": "f06",
    "congress": "f07",
    "southern": "f08",
    "naylor": "f09",
    "suitland": "f10",
    "branch": "f11",
    "benning": "g01",
    "capitol heights": "g02",
    "addison": "g03",
    "seat": "g03",
    "morgan": "g04",
    "largo": "g05",
    "van dorn": "j02",
    "franconia": "j03",
    "springfield": "j03",
    "court": "k01",
    "clarendon": "k02",
    "virginia sq": "k03",
    "george mason": "k03",
    "gmu": "k03"
    "ballston": "k04",
    "marymount": "k04",
    "mu": "k04",
    "east falls": "k05",
    "west falls": "k06",
    "dunn": "k07",
    "merrifield": "k07",
    "vienna": "k08",
    "fairfax": "k08",
    "mclean": "n01",
    "tysons": "n02",
    "greensboro": "n03",
    "spring": "n04",
    "wiehle": "n06",
    "reston": "n06"
station_regex = "("+Object.keys(stations).join("|")+")"
station_regex = new RegExp(station_regex.replace(/(\s|-|\\)/g, "\\s"), "i")

module.exports = (robot) ->

    robot.respond /(metro|wmata)(\s+(.+))?/i, (msg) ->
        key = process.env.HUBOT_WMATA_API_KEY
        if msg.match[3]
            search = msg.match[3]
            # Bus incident search by route name
            if search.match /^(\d\d|\w\d)$/i
                msg.http("http://api.wmata.com/Incidents.svc/json/BusIncidents?Route=#{search}&api_key=#{key}")
                .get() (err, resp, body) ->
                    arr = []
                    results = JSON.parse body
                    for i in results.BusIncidents
                        arr.push i.Description
                    if arr.length > 0
                        msg.send arr
                    else
                        msg.send "The #{search} bus is running on time!"

            # Bus arrivals by 7-digit stop ID
            else if search.match /^\d{7}$/i
                msg.http("http://api.wmata.com/NextBusService.svc/json/jPredictions?StopID=#{search}&api_key=#{key}")
                .get() (err, resp, body) ->
                    arr = []
                    results = JSON.parse body
                    for i in results.Predictions
                        arr.push i.Minutes
                    if arr.length > 0
                        msg.send "Bus arriving in #{arr} minutes"
                    else
                        msg.send "That's not a bus stop!"

            # Nearby bus and train stations
            else if search.match /^\d+\s.+\s(nw|ne|sw|se)/i
                results = geocoder.geocode "#{search} washington, dc", (err, resp) ->
                    arr = "Here's what's nearby:\n\n"
                    msg.http("http://api.wmata.com/rail.svc/json/jStationEntrances?lat=#{resp[0].latitude}&lon=#{resp[0].longitude}&radius=200&api_key=#{key}")
                    .get() (err, res, body) ->
                        results = JSON.parse body
                        if results.Entrances.length > 0
                            arr += "Metro Stations:\n\n"
                            s = []
                        for i in results.Entrances
                            if i.StationCode1 not in s
                                msg.http("http://api.wmata.com/Rail.svc/json/jStationInfo?StationCode=#{i.StationCode1}&api_key=#{key}")
                                .get() (err, resp, body) ->
                                    results = JSON.parse body
                                    arr += "#{results.Name}\n"
                                s.push i.StationCode1
                        msg.http("http://api.wmata.com/Bus.svc/json/jStops?lat=#{resp[0].latitude}&lon=#{resp[0].longitude}&radius=200&api_key=#{key}")
                        .get() (err, res, body) ->
                            results = JSON.parse body
                            if results.Stops.length > 0
                                arr += "\nBus Stops:\n\n"
                            for i in results.Stops
                                arr += "#{i.Name} (#{i.StopID}): #{i.Routes}\n"
                            msg.send arr

            # Train incident by line color
            else if search.match /^(red|green(?!belt)|blue|orange|yellow|silver)/i
                line = search.match /^(red|green|blue|orange|yellow|silver)/i
                lines =
                    "red": "RD;"
                    "blue": "BL;"
                    "greed": "GR;"
                    "orange": "OR;"
                    "yellow": "YL;"
                    "silver": "SV;"
                msg.http("http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    for i in results.Incidents
                        if i.LinesAffected is lines[line[0].toLowerCase()]
                            msg.send i.Description
                            delay = true
                    if !delay
                        msg.send "No problems on the #{line[0]} line!"

            # Train arrivals by station code (one letter and two numbers)
            else if search.match station_regex
                station = search.match station_regex
                arr = ""
                msg.http("http://api.wmata.com/Rail.svc/json/jStationInfo?StationCode=#{stations[station[0]][0]}&api_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    arr += "Here are the predictions for #{results.Name}:\n\n"
                    for s in stations[station[0]]
                        msg.http("http://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{s}?api_key=#{key}")
                        .get() (err, resp, body) ->
                            results = JSON.parse body
                            for i in results.Trains
                                arr += "Train to #{i.DestinationName}: #{i.Min} minutes\n"
                            msg.send arr

            else
                msg.send "I don't know what that means..."

        # Default to rail delays
        else
            msg.http("http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    for i in results.Incidents
                        msg.send i.Description
