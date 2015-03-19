http = require 'http'
express = require 'express'
#fs = require 'fs'
bodyParser = require 'body-parser'
path = require 'path'
logfmt = require 'logfmt'
config = require path.join(__dirname, 'config')

app = express()
app.use(bodyParser())
app.use(logfmt.requestLogger())
app.use(express.static(__dirname + '../public'));
port = Number(process.env.PORT || 5000);

app.get '/', (req, res) ->
  console.log "GET index"
  res.sendFile(path.join(__dirname, '../public', 'index.html'))

app.get '/check', (req, response) ->
  site = {}
  site.url = req.param "url"
  site.name = req.param "name"
  site.index = req.param "index"
  request = require 'sync-request'
  try
    res = request("GET", site.url)
  catch
    res = {}
    res.statusCode = 404
  site.statusCode = res.statusCode
  response.header "Content-Type", "application/json"
  response.send JSON.stringify(site)


#  url = req.body.url
#  pages = parseInt(req.body.max_pages) || -1
#  applySpooky = require path.join(__dirname, "spooky-parser")
#  applySpooky url, pages
#  resultsTest = ->
#   setTimeout ->
#     resultsPath = path.join(__dirname, "../tmp", config.filename)
#     if fs.existsSync(resultsPath)
#       res.header "Content-Type", "application/json" if config.json
#       res.sendFile resultsPath, {}, ->
#         fs.unlink resultsPath
#     else
#       resultsTest()
#    , 500
#  resultsTest()

app.listen port
console.log("started on port: #{port}")
