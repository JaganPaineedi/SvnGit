'use strict';
app.controller('documentsController', ['$scope', 'ngAuthSettings', 'briefcaseService', 'localDBService', 'dbModel',
    'authService', '$location', 'persistenceService', function ($scope, ngAuthSettings, briefcaseService, localDBService, dbModel,
        authService, $location, persistenceService) {
        if (authService.getprivatekeyrequired() === true) {
            $location.path('/login/UL');
            return;
        }
        var getClientId = function () {
            var parts = $location.absUrl().split('/');
            return Number(parts[parts.length - 1]);
        }

        var parts = $location.absUrl().split('/');
        var ID = getClientId();

        $scope.title = "Documents";


        persistenceService.getById(ID, dbModel.objectStoreName.caseload).then(function (caseload) {
            if (caseload.target.result.currentDocuments) {
                $scope.currentDocuments = $.parseJSON(caseload.target.result.currentDocuments.replace(/'/g, '"'));
            }
        }, function (error) {
            $scope.error = error;
        });
    }]);
