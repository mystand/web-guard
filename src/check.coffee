path = require 'path'
fs = require 'fs'
sitesPath = path.join(__dirname, '../config', 'sites.json')
storage = require "./storage"

checkSite = (site) ->
  request = require 'sync-request'
  try
    res = request("GET", site.url)
  catch
    res = {}
    res.statusCode = 404
  console.log("code: #{res.statusCode}")
  site.statusCode = res.statusCode
  storage.push "sites", site

(->
  sites = JSON.parse(fs.readFileSync sitesPath).sites
  storage.set "sites", []
  for site in sites
    console.log("check #{site.url}")
    checkSite(site)
)()