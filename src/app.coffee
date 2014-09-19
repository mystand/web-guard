http = require("http")
fs = require("fs")
path = require "path"
bodyParser = require 'body-parser'
express = require 'express'
logfile = (data) ->
  console.log("LOG - #{data}")
  fs.appendFileSync("./production.log", data.toString() + "\n")
app = express()
app.use(bodyParser())
logfile "APP INIT"

app.get '/', (req, res) ->
  logfile "GET index"
  res.sendFile(path.join(__dirname, '../public', 'index.html'))

app.post '/results', (req, res) ->
  logfile "POST results"
  url = req.body.url
  applySpooky = require "build/spooky-parser"
  applySpooky url, logfile
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

app.listen 8000
