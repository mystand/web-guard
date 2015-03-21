path = require 'path'
fs = require 'fs'
sitesPath = path.join(__dirname, '../config', 'sites.json')
storage = require "./storage"

checkSite = (site) ->
  setTimeout ->
    request = require 'sync-request'
    try
      res = request("GET", site.url)
    catch
      res = {}
      res.statusCode = 404
    site.statusCode = res.statusCode
    storage.push "sites", site
  , 0

checkSites = ->
  sites = JSON.parse(fs.readFileSync sitesPath).sites
  storage.set "sites", []
  checkSite(site) for site in sites

module.exports = checkSites