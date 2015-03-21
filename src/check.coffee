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
  site.statusCode = res.statusCode
  storage.push "sites", site

checkSites = ->
  sites = JSON.parse(fs.readFileSync sitesPath).sites
  storage.set "sites", []
  for site in sites
    checkSite(site)

module.exports = checkSites