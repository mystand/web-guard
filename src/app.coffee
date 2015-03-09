http = require("http")
fs = require("fs")
path = require "path"
bodyParser = require 'body-parser'
express = require 'express'
logfmt = require "logfmt"
config = require path.join(__dirname, "config")

app = express()
app.use(bodyParser())
app.use(logfmt.requestLogger())
port = Number(process.env.PORT || 5000);

app.get '/', (req, res) ->
  console.log "GET index"
  res.sendFile(path.join(__dirname, '../public', 'index.html'))

app.post '/results', (req, res) ->
  console.log "POST results"
  url = req.body.url
  pages = parseInt(req.body.max_pages) || -1
  applySpooky = require path.join(__dirname, "spooky-parser")
  applySpooky url, pages
  resultsTest = ->
   setTimeout ->
     resultsPath = path.join(__dirname, "../tmp", config.filename)
     if fs.existsSync(resultsPath)
       res.header "Content-Type", "application/json" if config.json
       res.sendFile resultsPath, {}, ->
         fs.unlink resultsPath
     else
       resultsTest()
    , 500
  resultsTest()

app.listen port
console.log("started on port: #{port}")
