# Description:
#   Get status information from WMATA
#
# Dependencies:
#   node-geocoder
#   fuzzy
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
fuzzy = require('fuzzy')

stations = [
    {name: "Metro Center", code: ["a01","c01"]},
    {name: "Farragut North", code: ["a02"]},
    {name: "Dupont Circle", code: ["a03"]},
    {name: "Woodley Park–Adams Morgan–Zoo", code: ["a04"]},
    {name: "Cleveland Park", code: ["a05"]},
    {name: "Van Ness UDC", code: ["a06"]},
    {name: "Tenleytown–American University", code: ["a07"]},
    {name: "Friendship Heights", code: ["a08"]},
    {name: "Bethesda", code: ["a09"]},
    {name: "Medical Center", code: ["a10"]},
    {name: "Grosvenor Strathmore", code: ["a11"]},
    {name: "White Flint", code: ["a12"]},
    {name: "Twinbrook", code: ["a13"]},
    {name: "Rockville", code: ["a14"]},
    {name: "Shady Grove", code: ["a15"]},
    {name: "Gallery Place–Chinatown", code: ["b01","e01","f01"]},
    {name: "Judiciary Square", code: ["b02"]},
    {name: "Union Station", code: ["b03"]},
    {name: "New York Avenue–Gallaudet", code: ["b35"]},
    {name: "Rhode Island Avenue–Brentwood", code: ["b04"]},
    {name: "Brookland–Catholic CUA", code: ["b05"]},
    {name: "Fort Totten", code: ["b06","e06"]},
    {name: "Takoma Park", code: ["b07"]},
    {name: "Silver Spring", code: ["b08"]},
    {name: "Forest Glen", code: ["b09"]},
    {name: "Wheaton", code: ["b10"]},
    {name: "Glenmont", code: ["b11"]},
    {name: "McPherson Square", code: ["c02"]},
    {name: "Farragut West", code: ["c03"]},
    {name: "Foggy Bottom–George Washington GWU", code: ["c04"]},
    {name: "Rosslyn", code: ["c05"]},
    {name: "Arlington Cemetery", code: ["c06"]},
    {name: "Pentagon", code: ["c07"]},
    {name: "Pentagon City", code: ["c08"]},
    {name: "Crystal City", code: ["c09"]},
    {name: "Ronald Reagan National Airport", code: ["c10"]},
    {name: "Braddock Road", code: ["c12"]},
    {name: "King Street–Old Town", code: ["c13"]},
    {name: "Eisenhower Avenue", code: ["c14"]},
    {name: "Huntington", code: ["c15"]},
    {name: "Federal Triangle", code: ["d01"]},
    {name: "Smithsonian", code: ["d02"]},
    {name: "L'enfant Plaza", code: ["d03","f03"]},
    {name: "Federal Center SW", code: ["d04"]},
    {name: "Capitol South", code: ["d05"]},
    {name: "Eastern Market", code: ["d06"]},
    {name: "Potomac Avenue", code: ["d07"]},
    {name: "Stadium–Armory", code: ["d08"]},
    {name: "Minnesota Avenue", code: ["d09"]},
    {name: "Deanwood", code: ["d10"]},
    {name: "Cheverly", code: ["d11"]},
    {name: "Landover", code: ["d12"]},
    {name: "New Carrolton", code: ["d13"]},
    {name: "Mt. Vernon Square–Convention Center", code: ["e01"]},
    {name: "Shaw–Howard", code: ["e02"]},
    {name: "U Street–Cardozo", code: ["e03"]},
    {name: "Columbia Heights", code: ["e04"]},
    {name: "Georgia Avenue–Petworth", code: ["e05"]},
    {name: "West Hyattsville", code: ["e07"]},
    {name: "Prince George's Plaza", code: ["e08"]},
    {name: "College Park–University of Maryland UMD", code: ["e09"]},
    {name: "Greenbelt", code: ["e10"]},
    {name: "Archives", code: ["f02"]},
    {name: "Waterfront", code: ["f04"]},
    {name: "Navy Yard–Ballpark", code: ["f05"]},
    {name: "Anacostia", code: ["f06"]},
    {name: "Congress Heights", code: ["f07"]},
    {name: "Southern Avenue", code: ["f08"]},
    {name: "Naylor Road", code: ["f09"]},
    {name: "Suitland", code: ["f10"]},
    {name: "Branch Avenue", code: ["f11"]},
    {name: "Benning Road", code: ["g01"]},
    {name: "Capitol Heights", code: ["g02"]},
    {name: "Addison Road", code: ["g03"]},
    {name: "Morgan Boulevard", code: ["g04"]},
    {name: "Largo Town Center", code: ["g05"]},
    {name: "Van Dorn Street", code: ["j02"]},
    {name: "Franconia–Springfield", code: ["j03"]},
    {name: "Court House", code: ["k01"]},
    {name: "Clarendon", code: ["k02"]},
    {name: "Virginia Square–George Mason GMU", code: ["k03"]},
    {name: "Ballston", code: ["k04"]},
    {name: "East Falls Church", code: ["k05"]},
    {name: "West Falls Church", code: ["k06"]},
    {name: "Dunn Loring", code: ["k07"]},
    {name: "Vienna", code: ["k08"]},
    {name: "Mclean", code: ["n01"]},
    {name: "Tysons Corner", code: ["n02"]},
    {name: "Greensboro", code: ["n03"]},
    {name: "Wiehle–Reston East", code: ["n06"]},
]
station_regex = "("+Object.keys(stations).join("|")+")"
station_regex = new RegExp(station_regex.replace(/(\s|-|\\)/g, "\\s"), "i")

module.exports = (robot) ->

    robot.respond /(metro|wmata)(\s+(.+))?/i, (msg) ->
        key = "xqv42tjfvz4abb9y9averdvd"
        if msg.match[3]
            search = msg.match[3]
            # Bus incident search by route name
            if search.match /^(\d\d|\w\d)$/i
                msg.http("http://api.wmata.com/Incidents.svc/json/BusIncidents?Route=#{search}&api_key=#{key}&subscription_key=#{key}")
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
                msg.http("http://api.wmata.com/NextBusService.svc/json/jPredictions?StopID=#{search}&api_key=#{key}&subscription_key=#{key}")
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
                    msg.http("http://api.wmata.com/rail.svc/json/jStationEntrances?lat=#{resp[0].latitude}&lon=#{resp[0].longitude}&radius=200&api_key=#{key}&subscription_key=#{key}")
                    .get() (err, res, body) ->
                        results = JSON.parse body
                        if results.Entrances.length > 0
                            arr += "Metro Stations:\n\n"
                            s = []
                        for i in results.Entrances
                            if i.StationCode1 not in s
                                msg.http("http://api.wmata.com/Rail.svc/json/jStationInfo?StationCode=#{i.StationCode1}&api_key=#{key}&subscription_key=#{key}")
                                .get() (err, resp, body) ->
                                    results = JSON.parse body
                                    arr += "#{results.Name}\n"
                                s.push i.StationCode1
                        msg.http("http://api.wmata.com/Bus.svc/json/jStops?lat=#{resp[0].latitude}&lon=#{resp[0].longitude}&radius=200&api_key=#{key}&subscription_key=#{key}")
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
                msg.http("http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{key}&subscription_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    for i in results.Incidents
                        if i.LinesAffected is lines[line[0].toLowerCase()]
                            msg.send i.Description
                            delay = true
                    if !delay
                        msg.send "No reported problems on the #{line[0]} line!"

            # Train arrivals by station code (one letter and two numbers)
            else
                fuzzy_options =
                    extract: (el) -> el.name
                fuzzy_search = fuzzy.filter(search, stations, fuzzy_options)
                station = fuzzy_search[0].string
                result = stations.filter (o) -> o.name == station
                arr = "Train times for #{result[0].name}:\n"
                msg.http("http://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{result[0].code}?api_key=#{key}&subscription_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    for i in results.Trains
                        arr += "#{i.Line} train to #{i.DestinationName}: #{i.Min} minutes\n"
                    msg.send arr

            # else
            #     msg.send "I don't know what that means..."

        # Default to rail delays
        else
            msg.http("http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{key}&subscription_key=#{key}")
                .get() (err, resp, body) ->
                    results = JSON.parse body
                    for i in results.Incidents
                        msg.send i.Description
