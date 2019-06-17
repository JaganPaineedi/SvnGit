'use strict';
app.controller('dashboardController', ['$scope', 'localDBService', 'ngAuthSettings', 'dbModel', '$location', 'authService', 'commonService',
    function ($scope, localDBService, ngAuthSettings, dbModel, $location, authService, commonService) {
    if (authService.getprivatekeyrequired() === true) {
        $location.path('/login/UL');
        return;
    }

    $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;
    $scope.dashboardItems = [];

    commonService.ShowHomeButton = false;

    localDBService.Open(dbModel).then(function () {
        
        localDBService.GetAll(dbModel.objectStoreName.teamcalendarstaff).then(function (result) {
            $scope.teamstafflist = result;
        });
    });

    localDBService.Open(dbModel).then(function () {
        localDBService.GetAll(dbModel.objectStoreName.dashboards).then(function (result) {
            if (result.length > 0) {
                $scope.title = "Home";
                $scope.dashboardItems = result;
            }
            else {
                $location.path('/login/LN');
            }
        },
        function (error) {
            $scope.error = error;
        });
        localDBService.GetCount(dbModel.objectStoreName.caseload).then(function (result) {
            $scope.totalcaseload = result;
        });
    });
        
    //$scope.$on('$destroy', function () {
    //    commonService.ShowHomeButton = true;
    //})

}]);