http = require("http")
fs = require("fs")
path = require "path"
bodyParser = require 'body-parser'
express = require 'express'
logfmt = require "logfmt"

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
  applySpooky = require "./build/spooky-parser"
  applySpooky url
  resultsTest = ->
   setTimeout ->
     resultsPath = path.join(__dirname, "../tmp", "results.csv")
     if fs.existsSync(resultsPath)
       res.sendFile resultsPath, {}, ->
         fs.unlink resultsPath
     else
       resultsTest()
    , 500
  resultsTest()

app.listen port
console.log("started on port: #{port}")
