Jsdom = require "jsdom"
$ = require("jquery")(Jsdom.jsdom().createWindow())
Http = require "http"
Async = require "async"
Hapi = require "hapi"

Http.globalAgent.maxSockets = 10;

leagues = [
    {leagueName: "Spain",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=spain-liga-2000000037/standings/index.html",
    numberOfTeams: 3},
    {leagueName: "England",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=england-premier-league-2000000000/standings/index.html",
    numberOfTeams: 4},
    {leagueName: "Germany",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=germany-bundesliga-2000000019/standings/index.html",
    numberOfTeams: 3},
    {leagueName: "Italy",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=italy-serie-a-2000000026/standings/index.html",
    numberOfTeams: 3},
    {leagueName: "Portugal",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=portugal-liga-2000000033/standings/index.html",
    numberOfTeams: 2},
    {leagueName: "France",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=france-ligue-1-2000000018/standings/index.html",
    numberOfTeams: 2},
    {leagueName: "Netherlands",
    url: "http://www.fifa.com/world-match-centre/nationalleagues/nationalleague=netherlands-eredivisie-2000000022/standings/index.html",
    numberOfTeams: 1}
  ]

exports.getUefaClubs = (done) ->
  startTime = new Date()
  teams = []
  console.log "getUefaClubs started #{new Date()}"
  Async.each leagues, (league, next) ->
    console.log "Fetching #{league.numberOfTeams} teams for #{league.leagueName} from #{league.url}"
    html = ""
    httpRequest = Http.get league.url, (response) ->
      response.on "data", (chunk) ->
        html += chunk
      response.on "end", ->
        return done(new Hapi.error.internal("Error getting webpage from #{league.url}"), null) if html is ""
        for i in [0...league.numberOfTeams]
          teamParentElement = $(html).find("tr td.rnk:eq(#{i})").parent()
          teamName = teamParentElement.children("td.team").text()
          teamFullID = teamParentElement.attr('data-filter')
          teamID = teamFullID.split('_')[1]
          teams.push
            teamName: teamName
            teamID: teamID
            image_src:
              1: "http://www.fifa.com/mm/teams/#{teamID}/#{teamID}x1.png"
              2: "http://www.fifa.com/mm/teams/#{teamID}/#{teamID}x2.png"
              3: "http://www.fifa.com/mm/teams/#{teamID}/#{teamID}x3.png"
              4: "http://www.fifa.com/mm/teams/#{teamID}/#{teamID}x4.png"
              5: "http://www.fifa.com/mm/teams/#{teamID}/#{teamID}x5.png"
            league: league.leagueName
            position: i + 1
         next()
    httpRequest.on 'error', (err) ->
      console.log("Got error: " + err.message)
      return done(new Hapi.error.internal(err), null)
  , (err) ->
    return done(new Hapi.error.internal(err), null) if err
    console.log "getUefaClubs finished in #{new Date() - startTime}ms"
    console.log "clubs selected: #{JSON.stringify(teams.map (team) -> team.teamName)}"
    done(null, teams)

countris = [
  {countryName: "Brazil",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/bra.png"
    organiztion: "http://img.fifa.com/images/logos/s/bra.gif"
  group: "A"
  },
  {countryName: "Croatia",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/cro.png"
    organiztion: "http://img.fifa.com/images/logos/s/cro.gif"
  group: "A"
  },
  {countryName: "Mexico",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/mex.png"
    organiztion: "http://img.fifa.com/images/logos/s/mex.gif"
  group: "A"
  },
  {countryName: "Cameroon",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/cmr.png"
    organiztion: "http://img.fifa.com/images/logos/s/cmr.gif"
  group: "A"
  },
  {countryName: "Spain",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/esp.png"
    organiztion: "http://img.fifa.com/images/logos/s/esp.gif"
  group: "B"
  },
  {countryName: "Netherlands",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/ned.png"
    organiztion: "http://img.fifa.com/images/logos/s/ned.gif"
  group: "B"
  },
  {countryName: "Australia",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/aus.png"
    organiztion: "http://img.fifa.com/images/logos/s/aus.gif"
  group: "B"
  },
  {countryName: "Chile",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/chi.png"
    organiztion: "http://img.fifa.com/images/logos/s/chi.gif"
  group: "B"
  },
  {countryName: "Colombia",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/col.png"
    organiztion: "http://img.fifa.com/images/logos/s/col.gif"
  group: "C"
  },
  {countryName: "Greece",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/gre.png"
    organiztion: "http://img.fifa.com/images/logos/s/gre.gif"
  group: "C"
  },
  {countryName: "Côte d'Ivoire",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/civ.png"
    organiztion: "http://img.fifa.com/images/logos/s/civ.gif"
  group: "C"
  },
  {countryName: "Japan",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/jpn.png"
    organiztion: "http://img.fifa.com/images/logos/s/jpn.gif"
  group: "C"
  },
  {countryName: "Uruguay",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/uru.png"
    organiztion: "http://img.fifa.com/images/logos/s/uru.gif"
  group: "D"
  },
  {countryName: "Costa Rica",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/crc.png"
    organiztion: "http://img.fifa.com/images/logos/s/crc.gif"
  group: "D"
  },
  {countryName: "England",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/eng.png"
    organiztion: "http://img.fifa.com/images/logos/s/eng.gif"
  group: "D"
  },
  {countryName: "Italy",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/ita.png"
    organiztion: "http://img.fifa.com/images/logos/s/ita.gif"
  group: "D"
  },
  {countryName: "Switzerland",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/sui.png"
    organiztion: "http://img.fifa.com/images/logos/s/sui.gif"
  group: "E"
  },
  {countryName: "Ecuador",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/ecu.png"
    organiztion: "http://img.fifa.com/images/logos/s/ecu.gif"
  group: "E"
  },
  {countryName: "France",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/fra.png"
    organiztion: "http://img.fifa.com/images/logos/s/fra.gif"
  group: "E"
  },
  {countryName: "Honduras",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/hon.png"
    organiztion: "http://img.fifa.com/images/logos/s/hon.gif"
  group: "E"
  },
  {countryName: "Argentina",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/arg.png"
    organiztion: "http://img.fifa.com/images/logos/s/arg.gif"
  group: "F"
  },
  {countryName: "Bosnia and Herzegovina",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/bih.png"
    organiztion: "http://img.fifa.com/images/logos/s/bih.gif"
  group: "F"
  },
  {countryName: "Iran",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/irn.png"
    organiztion: "http://img.fifa.com/images/logos/s/irn.gif"
  group: "F"
  },
  {countryName: "Nigeria",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/nga.png"
    organiztion: "http://img.fifa.com/images/logos/s/nga.gif"
  group: "F"
  },
  {countryName: "Germany",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/ger.png"
    organiztion: "http://img.fifa.com/images/logos/s/ger.gif"
  group: "G"
  },
  {countryName: "Portugal",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/por.png"
    organiztion: "http://img.fifa.com/images/logos/s/por.gif"
  group: "G"
  },
  {countryName: "Ghana",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/gha.png"
    organiztion: "http://img.fifa.com/images/logos/s/gha.gif"
  group: "G"
  },
  {countryName: "USA",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/usa.png"
    organiztion: "http://img.fifa.com/images/logos/s/usa.gif"
  group: "G"
  },
  {countryName: "Belgium",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/bel.png"
    organiztion: "http://img.fifa.com/images/logos/s/bel.gif"
  group: "H"
  },
  {countryName: "Algeria",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/alg.png"
    organiztion: "http://img.fifa.com/images/logos/s/alg.gif"
  group: "H"
  },
  {countryName: "Russia",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/rus.png"
    organiztion: "http://img.fifa.com/images/logos/s/rus.gif"
  group: "H"
  },
  {countryName: "Korea Republic",
  image_src:
    flag: "http://img.fifa.com/images/flags/4/kor.png"
    organiztion: "http://img.fifa.com/images/logos/s/kor.gif"
  group: "H"
  }
]

exports.getWorldCupTeams = (done) ->
  done(null, countris)
