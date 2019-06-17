'use strict';
app.controller('teamCalendarController', ['$scope', '$q', 'ngAuthSettings', 'authService', '$location', 'localDBService', 'dbModel', 'localStorageService', 'commonService',
    function ($scope, $q, ngAuthSettings, authService, $location, localDBService, dbModel, localStorageService, commonService) {
        if (authService.getprivatekeyrequired() === true) {
            $location.path('/login/UL');
            return;
        }

        $scope.title = "Team Calendar";
        $scope.dateofService = "";

        var authData = localStorageService.get('authorizationData');

        $scope.staffId = Number(authData.staffId);

        $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;

        $scope.applyfilter = function () {
            var date = $scope.dateofService === "" ? $('#filter-date').val() : $scope.dateofService;
            var programId = $scope.programId;

            _reset().then(function (teams) {
                $scope.teamstafflist = $.grep(teams, function (team, index) {
                    if (team.ServiceDetail && team.programId == programId) {
                        team.ServiceDetail = $.grep(team.ServiceDetail, function (service, sindex) {
                            var dateofService = new Date(service.DateOfService);
                            var dateformatted = commonService.FormatDateMMDDYYYY(dateofService);
                            if (date && dateformatted === date)
                                return service;
                        });
                        return team;
                    }
                });
            });;
        };

        $scope.reset = function () {
            $('input[datatype=date]').datetimepicker({ format: 'MM/DD/YYYY' }).on("dp.change", function () { $scope.dateofService = $(this).val(); $scope.$apply(); });
            $scope.programId = $scope.staffPrograms ? $scope.staffPrograms[0].programId : '';
            $scope.dateofService = "";
            if ($('#filter-date').val() !== "")
                $('#filter-date').val('');

            localDBService.GetAll(dbModel.objectStoreName.caseload).then(function (results) {
                //$scope.ClientIds = $.grep(result, function (cl) { return cl.clientId; });
                $scope.ClientIds = results.map(function (a) { return a.clientId; });
                _reset().then(function (teams) {
                    $scope.teamstafflist = teams;
                });
            });
        };

        $scope.isCaseLoadClient = function (clientId) {
            var clientId
            if ($.inArray(Number(clientId), $scope.ClientIds) > -1)
                return true;
            else false;
        }

        var _reset = function () {
            var deferred = $q.defer();
            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.teamcalendarstaff).then(function (result) {
                    var teamresult = $.grep(result, function (team, index) {
                        if (team.ServiceDetail) {
                            team.ServiceDetail = $.parseJSON(team.ServiceDetail.replace(/'/g, '"').replace(/'/g, '"'));
                            return team;
                        }
                    });
                    deferred.resolve(teamresult);
                });

                localDBService.GetAll(dbModel.objectStoreName.staffprograms).then(function (staffPrograms) {
                    $scope.staffPrograms = staffPrograms;
                    $scope.programId = $scope.staffPrograms[0].programId;
                });

               
            });
            return deferred.promise;
        };

        $scope.$watch('dateofService', function (newValue, oldValue) {
            $('#filter-date').val(newValue);
        });

        $scope.reset();
    }]);