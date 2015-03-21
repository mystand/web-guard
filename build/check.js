// Generated by CoffeeScript 1.7.1
(function() {
  var checkSite, fs, path, sitesPath, storage;

  path = require('path');

  fs = require('fs');

  sitesPath = path.join(__dirname, '../config', 'sites.json');

  storage = require("./storage");

  checkSite = function(site) {
    var request, res;
    request = require('sync-request');
    try {
      res = request("GET", site.url);
    } catch (_error) {
      res = {};
      res.statusCode = 404;
    }
    console.log("code: " + res.statusCode);
    site.statusCode = res.statusCode;
    return storage.push("sites", site);
  };

  (function() {
    var site, sites, _i, _len, _results;
    sites = JSON.parse(fs.readFileSync(sitesPath)).sites;
    storage.set("sites", []);
    _results = [];
    for (_i = 0, _len = sites.length; _i < _len; _i++) {
      site = sites[_i];
      console.log("check " + site.url);
      _results.push(checkSite(site));
    }
    return _results;
  })();

}).call(this);
