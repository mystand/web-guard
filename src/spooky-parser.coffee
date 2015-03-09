path = require "path"
config = require path.join(__dirname, "config")

module.exports = (url, pages)->
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
    spooky.then [ config: config, pages: pages, ->
      casper = @

      casper.on 'remote.message', (message) ->
        casper.echo "browser: " + message

      casper.evaluate ->
        window.jq = $.noConflict yes

      casper.waitFor ->
        casper.evaluate ->
          window.googlePlusParser != undefined
      , =>
        if pages is -1 || pages > 1
          pages -= 1 if pages != -1
          loadMoreReviews parseReviews
        else
          parseReviews()

      parseReviews = ->
        data = casper.evaluate ->
          window.googlePlusParser.parseReviews()

        buildFile data

      loadMoreReviews = (callback) ->
        if pages is 0
          callback?()
          return

        pages -= 1 if pages != -1
        console.log "."

        orderBtnSelector = ".d-s.L5.r0"


        casper.click


        nextBtnSelector = ".d-s.L5.r0"
        casper.click nextBtnSelector
        casper.waitFor ->
          casper.evaluate ->
            buttonPanelSelector = '.R4.b2.gUb'
            jq(buttonPanelSelector).first().css("display") is "none"
        , callback, ->
          loadMoreReviews callback


      buildFileJSON = (data) ->
        fs = require('fs')
        fullFilename = "./tmp/#{config.filename}"
        fs.write fullFilename, JSON.stringify(data)


      buildFileCSV = (data) ->
        fs = require('fs')
        fields = ["rate", "ratingValue", "hasResponse", "username","imageLink","userLink","content","response", "time"]
        res = "#{fields.join(',')}\n"

        for obj in data
          objectValues = for field in fields
            val = obj[field] || ""
            val.toString().replace(/\s\s/g, "").replace(/\n|\r/g, "").replace(/,/g, ";")
          res += "#{objectValues.join(',')}\n"
        fullFilename = "./tmp/#{config.filename}"
        console.log fullFilename
        fs.write fullFilename, res



      buildFile = (data) ->
        if config.json
          console.log("buildFile: JSON")
          buildFileJSON data
        else
          console.log("buildFile: CSV")

          buildFileCSV data

    ]
    spooky.run()

  )

  spooky.on "error", (e, stack) ->
    console.error e
    console.log stack  if stack

  #Uncomment this block to see all of the things Casper has to say.
  #There are a lot.
  #He has opinions.
  spooky.on 'console', (line) ->
    console.log line

  spooky.on "hello", (greeting) ->
    console.log greeting

  spooky.on "log", (log) ->
    console.log log.message.replace(RegExp(" \\- .*"), "")  if log.space is "remote"