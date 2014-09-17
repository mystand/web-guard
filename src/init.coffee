casper = require("casper").create
  logLevel: "debug"

casper.on 'remote.message', (message) ->
  this.echo message

# for test many pages
# testUrl = "https://plus.google.com/111840715355681175070/about?hl=en-US"

url = "https://plus.google.com/106797324517565881930/about?hl=en-US"
ParserResults = []

init = ->
  casper.start url

  casper.then ->
    @page.injectJs('bower_components/jquery/dist/jquery.js');
    @page.injectJs('build/parser.js');
    @evaluate ->
      window.jq = $.noConflict yes

    casper.waitFor ->
      casper.evaluate ->
        window.googlePlusParser != undefined
    , ->
      loadMoreReviews parseReviews

  casper.run()

parseReviews = ->
  data = casper.evaluate ->
    window.googlePlusParser.parseReviews()
  buildFile data

loadMoreReviews = (callback) ->
  console.log(".")
  nextBtnSelector = ".d-s.L5.r0"
  casper.click nextBtnSelector

  casper.waitFor ->
    @evaluate ->
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

  fs.write "results.csv", res


init()