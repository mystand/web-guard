http = require 'http'
express = require 'express'
path = require 'path'
fs = require 'fs'
sitesPath = path.join(__dirname, '../config', 'sites.json')
storage = require "./storage"


app = express()
app.use express.static(path.join(__dirname + '/../public'))
app.use express.static(path.join(__dirname + '/../bower_components'))
port = Number(process.env.PORT || 5000);

app.get '/', (req, res) ->
  console.log "GET index"
  res.render 'index'

app.get '/sites', (req, response) ->
  console.log "GET sites"
  response.header "Content-Type", "application/json"
  response.send storage.json()

app.listen port
console.log("started on port: #{port}")




##  url = req.body.url
##  pages = parseInt(req.body.max_pages) || -1
##  applySpooky = require path.join(__dirname, "spooky-parser")
##  applySpooky url, pages
##  resultsTest = ->
##   setTimeout ->
##     resultsPath = path.join(__dirname, "../tmp", config.filename)
##     if fs.existsSync(resultsPath)
##       res.header "Content-Type", "application/json" if config.json
##       res.sendFile resultsPath, {}, ->
##         fs.unlink resultsPath
##     else
##       resultsTest()
##    , 500
##  resultsTest()
#

