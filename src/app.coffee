http = require("http")
fs = require("fs")
path = require "path"
bodyParser = require 'body-parser'
express = require 'express'
app = express()
app.use(bodyParser());

app.get '/', (req, res) ->
  res.sendFile(path.join(__dirname, '../public', 'index.html'))

app.post '/results', (req, res) ->
  url = req.body.url
  applySpooky = require "build/spooky-parser"
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

app.listen 80
