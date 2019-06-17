app.controller('customNoteController', ['$scope', 'commonService', function ($scope, commonService) {
    var documentVersionId, serviceNote;
    if ($scope.cs)
    {
        documentVersionId = $scope.cs.documentVersionId;
        serviceNote = $scope.cs.note;
    } else { if ($scope.$parent.serviceNote) { serviceNote = $scope.$parent.serviceNote; documentVersionId = $scope.$parent.documentVersionId; } }
    
    for (var key in serviceNote) {
        if (serviceNote && serviceNote[key] && typeof (serviceNote[key]) == "string") {
            serviceNote[key] = $.parseJSON(serviceNote[key])[0];
        } else { serviceNote[key] = serviceNote[key]; }
    }
    
    if (documentVersionId < 0 && !serviceNote) {
        $scope.serviceNote = {};
    } else {
        $scope.serviceNote = serviceNote;
    }

    commonService.InitializeControls('noteDocument');
}]);
