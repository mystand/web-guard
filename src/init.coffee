casper = require("casper").create
  logLevel: "debug"

casper.on 'remote.message', (message) ->
  this.echo message

url = "https://plus.google.com/106797324517565881930/about?hl=en-US"
ParserResults = []

init = ->
  casper.start url

  casper.then ->
    @page.injectJs('bower_components/jquery/dist/jquery.js');
    @page.injectJs('build/parser.js');
    @evaluate ->
      window.jq = $.noConflict yes

    nextBtnElement = @evaluate ->
      jq ".d-s.L5.r0"
    casper.waitFor ->
      casper.evaluate ->
        window.googlePlusParser != undefined
    , parseReviews
    return #TEMP
    unless nextBtnElement
      console.log("parseReviews")
      parseReviews()
    else
      console.log("loadMoreReviews")
      loadMoreReviews parseReviews

  casper.run()

parseReviews = ->
    casper.evaluate ->
      window.googlePlusParser.parseReviews()
    , ->
      console.log("parseReviews parsed")
    ,  ->
      console.log "timeout"

loadMoreReviews = (cb) ->
  nextBtnSelector = ".d-s.L5.r0"
  casper.click nextBtnSelector
  casper.waitFor ->
    @evaluate ->
      console.log(window.getComputedStyle(nextBtnSelector).display)
      window.getComputedStyle(nextBtnSelector).display is "none"

  , ->
    console.log("THEN!!!")
#  cb, ->
#    @echo "Timeout"

init()