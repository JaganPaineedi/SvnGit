app.controller('caseloaddetailController', ['$scope', '$location', 'persistenceService', 'localDBService', 'dbModel', 'commonService', 'authService', function ($scope, $location, persistenceService, localDBService, dbModel, commonService, authService) {
    if (authService.getprivatekeyrequired() == true) {
        $location.path('/login/UL');
        return;
    }

    var getClientId = function () {
        var parts = $location.absUrl().split('/');
        return Number(parts[parts.length - 1]);
    }

    var parts = $location.absUrl().split('/');
    var ID = getClientId();
    var map;
    var mapURL = "http://maps.google.com/maps?z=12&t=m&q="

    $scope.IOS = commonService.IsIos();
    $scope.Android = commonService.IsAndroid();

    $scope.getMapUrl = function (geo) {
        if (geo){
            return mapURL + 'loc:' + geo.replace(',', '+');
        }
    }

    $scope.getMapUrlFromAddress = function (address) {
        if (address) {
            return mapURL + address;
        }
    }

    $scope.isUpcomingAppointmentsCollapsed = false;
    $scope.isClientDetailCollapsed = false;
    $scope.isDiagnosisCollapsed = false;
    $scope.isCurrentMedCollapsed = false;

    function initializeNewMap(longitude, latitude, label) {
        $('#myModal').modal();

        
        var mapOptions = {
            zoom: 15,
            center: new google.maps.LatLng(longitude, latitude)/*,
            mapTypeId: google.maps.MapTypeId.TERRAIN*/
        }
        document.getElementById("mapBody")
        map = new google.maps.Map(document.getElementById("mapBody"), mapOptions);

        var myMarker = new google.maps.Marker({
            position: new google.maps.LatLng(longitude, latitude), // Example Lat/Long
            map: map, // references the map object you defined earlier
            title: label // a title that will appear on hover
        });


        $('#myModal').one('shown.bs.modal', function (e) {
            $('.modal-content').css('height', $(window).height() * 0.75);
            google.maps.event.trigger(map, 'resize');
        });
    }

    var _buttonClick = function (longitudeandlatitude,label) {
        var arr = longitudeandlatitude.split(',');
        initializeNewMap(arr[0], arr[1], label);
    }
    $scope.Click = _buttonClick;

    persistenceService.getById(ID, dbModel.objectStoreName.caseload).then(function (caseload) {
        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.globalcodes).then(function (result) {
                $scope.caseload = caseload.target.result;
                if ($scope.caseload.diagnosis) {
                    $scope.diagnosis = $.parseJSON($scope.caseload.diagnosis.replace(/'/g, '"'));
                }
                if ($scope.caseload.currentmedications) {
                    $scope.currentmedications = $.parseJSON($scope.caseload.currentmedications.replace(/'/g, '"'));
                }
                //if ($scope.caseload.appointments) {
                //    $scope.appointments = $.parseJSON($scope.caseload.appointments.replace(/'/g, '"').replace("&quot;","'"));
                //}
                
                localDBService.GetAll(dbModel.objectStoreName.calendarevent).then(function (result) {
                    var currAppt = $.grep(result, function (appointment) {
                        var today = new Date();
                        today.setHours(0, 0, 0, 0); // Consider Mid night

                        if (appointment.service && new Date(appointment.startTime) >= today) {
                            return appointment.service.clientId == getClientId();
                        }
                    });
                    $scope.appointments = $.map(currAppt, function (appointment, index) {
                        return {
                            "appointmentId": appointment.appointmentId,
                            "start": new Date(appointment.startTime),
                            "procedureName": appointment.service.procedureCodeName,
                            "locationName": appointment.service.locationName,
                            "provider": appointment.service.clinicianName
                        };
                    }).sort(function (x, y) {
                        return x.start - y.start;
                    }).slice(0, 5);

                });
            },
            function (error) {
                $scope.error = error;
            });
        });
    },
    function (error) {
        $scope.error = error;
    });
}]);