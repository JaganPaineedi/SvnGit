
app.controller('caseloadController', ['$scope', '$location', 'authService', 'localDBService', 'dbModel', function ($scope, $location, authService, localDBService, dbModel) {
    if (authService.getprivatekeyrequired() === true) {
        $location.path('/login/UL');
        return;
    }
    
    localDBService.Open(dbModel).then(function () {
        localDBService.GetAll(dbModel.objectStoreName.caseload).then(function (result) {
            $scope.caseloads = result;
        });
    });

    $scope.startsWith = function (actual, expected) {
        var lowerStr = (actual + "").toUpperCase();
        return lowerStr.indexOf(expected.toUpperCase()) === 0;
    };
}]);