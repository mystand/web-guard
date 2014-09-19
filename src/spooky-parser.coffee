module.exports = (url, logfile)->
  Spooky = require("spooky")
  spooky = new Spooky(
    child:
      transport: "http"

    casper:
      logLevel: "debug"
      verbose: true,
      clientScripts: ['bower_components/jquery/dist/jquery.js', 'build/parser.js']

  , (err) ->
    if err
      e = new Error("Failed to initialize SpookyJS")
      e.details = err
      throw e
    spooky.start url
    spooky.then ->
      casper = @

      casper.on 'remote.message', (message) ->
        casper.echo "browser: " + message

      casper.evaluate ->
        window.jq = $.noConflict yes

      casper.waitFor ->
        casper.evaluate ->
          window.googlePlusParser != undefined
      , =>
        loadMoreReviews parseReviews

      parseReviews = ->
        data = casper.evaluate ->
          window.googlePlusParser.parseReviews()
        buildFile data

      loadMoreReviews = (callback) ->
        console.log "."
        nextBtnSelector = ".d-s.L5.r0"
        casper.click nextBtnSelector

        casper.waitFor ->
          casper.evaluate ->
            buttonPanelSelector = '.R4.b2.gUb'
            jq(buttonPanelSelector).first().css("display") is "none"
        , callback, -> loadMoreReviews callback

      buildFile = (data) ->
        fs = require('fs')

        fields = ["rate", "hasResponse", "username","imageLink","userLink","content","response"]
        res = "#{fields.join(';')}\n"

        for obj in data
          objectValues = for field in fields
            val = obj[field] || ""
            val.toString().replace(/\s\s/g, "").replace(/\n|\r/g, "").replace(/;/g, "")
          res += "#{objectValues.join(';')}\n"
        fullFilename = "./tmp/results.csv"
        fs.write fullFilename, res

    spooky.run()
  )

  spooky.on "error", (e, stack) ->
    console.error e
    logfile stack  if stack

  #Uncomment this block to see all of the things Casper has to say.
  #There are a lot.
  #He has opinions.
  spooky.on 'console', (line) ->
    logfile line

  spooky.on "hello", (greeting) ->
    logfile greeting

  spooky.on "log", (log) ->
    logfile log.message.replace(RegExp(" \\- .*"), "")  if log.space is "remote"