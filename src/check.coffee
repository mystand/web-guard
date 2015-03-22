path = require 'path'
fs = require 'fs'
sitesPath = path.join(__dirname, '../config', 'sites.json')
sitesPath = path.join(__dirname, '../config', 'sites.json')


storage = require "./storage"

checkSite = (site, errorCallback) ->
  setTimeout ->
    request = require 'sync-request'
    try
      res = request("GET", site.url)
    catch
      res = {}
      res.statusCode = 404
    if res.statusCode != site.statusCode && site.statusCode == 200
      errorCallback? site
    site.statusCode = res.statusCode
    storage.push "sites", site
  , 0

checkSites = (errorCallback) ->
  console.log("check sites...")
  sites = storage.get "sites"
  if !sites || sites.length is 0
    sites = JSON.parse(fs.readFileSync(sitesPath)).sites
  storage.set "sites", []
  for site in sites
    checkSite site, errorCallback

module.exports = checkSites