app.controller('customServicesController', ['$scope','commonService', function ($scope, commonService) {
    var serviceId, customFields;
    if ($scope.cs) {
        serviceId = $scope.cs.serviceId;
        cf = $scope.cs.cf;
    } else { if ($scope.$parent.customFields) { cf = $scope.$parent.customFields; serviceId = $scope.$parent.serviceId; } }

    if (serviceId < 0 && !cf) {
        $scope.cf = {};
    } else {
        $scope.cf = cf;
    }
    commonService.InitializeControls('customfield');
}]);