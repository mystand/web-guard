app = angular.module 'guard', []

app.controller "SitesListController", ($scope, $http)->
  @sites = []

  req =
    method: "GET"
    url: "/sites"
    headers:
      "Content-Type": "application/json"

  successCallback = (data) =>
    @sites = data.sites

  $http(req).success successCallback