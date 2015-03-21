app = angular.module 'guard', []

app.controller "SitesListController", ($scope, $http)->
  @sites = []

  @failsCount = =>
    count = 0
    for site in @sites
      count += 1 if site.statusCode != 200
    count

  req =
    method: "GET"
    url: "/sites"
    headers:
      "Content-Type": "application/json"

  successCallback = (data) =>
    @sites = data.sites

  $http(req).success successCallback