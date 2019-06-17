'use factory';

app.factory('dashboardService', ['$http', '$q', 'ngAuthSettings', 'briefcaseService', function ($http, $q, ngAuthSettings, briefcaseService) {

    var serviceBase = ngAuthSettings.apiServiceBaseUri;

    var dashboardServiceFactory = {};

    var _getDashboard = function () {
        return $http.get(serviceBase + 'api/Dashboard').then(function (results) {
            briefcaseService.GetBriefcaseData();
            return results;
        });
    };

    dashboardServiceFactory.GetDashboard = _getDashboard;

    return dashboardServiceFactory;
}]);