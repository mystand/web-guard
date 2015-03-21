// Generated by CoffeeScript 1.7.1
(function() {
  var app;

  app = angular.module('guard', []);

  app.controller("SitesListController", function($scope, $http) {
    var req, successCallback;
    this.sites = [];
    this.failsCount = (function(_this) {
      return function() {
        var count, site, _i, _len, _ref;
        count = 0;
        _ref = _this.sites;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          site = _ref[_i];
          if (site.statusCode !== 200) {
            count += 1;
          }
        }
        return count;
      };
    })(this);
    req = {
      method: "GET",
      url: "/sites",
      headers: {
        "Content-Type": "application/json"
      }
    };
    successCallback = (function(_this) {
      return function(data) {
        return _this.sites = data.sites;
      };
    })(this);
    return $http(req).success(successCallback);
  });

}).call(this);