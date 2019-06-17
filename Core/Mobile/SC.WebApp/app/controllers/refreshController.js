'use strict';
app.controller('refreshController', ['$scope', '$q', '$location', 'authService', 'localStorageService', 'ngAuthSettings', 'commonService', 'commonServiceDB',
    'localDBService', 'dbModel', 'Idle', 'syncService','briefcaseService',
    function ($scope, $q, $location, authService, localStorageService, ngAuthSettings, commonService, commonServiceDB, localDBService, dbModel, Idle, syncService, briefcaseService) {
        if (authService.getprivatekeyrequired() === true) {
            $location.path('/login/UL');
            return;
        }
        commonService.HideProcessing();
        Idle.unwatch();
        var authenticated = false;
        var buttonText = "Login";
        authService.authentication.isAuth = false;
        var authData = localStorageService.get('authorizationData');
        var username = '';

        if (authData) {
            $scope.refreshnotrequired = true;
            username = authData.userName;
        }

        $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;

        $scope.loginData = {
            userName: username,
            password: "",
            smartkey: "",
            useRefreshToken: true,
            showsmartkey: true,
            buttonText: buttonText
        };

        $scope.login = function () {
            authService.relogin($scope.loginData).then(function (response) {
                if (!commonService.localChangesCount) {
                    briefcaseService.GetBriefcaseData().then(function () { setHomeScreen(); });
                    syncService.Syncing = false;
                }
                else {
                    syncService.Syncing = false;
                    setHomeScreen();
                }
            },
            function (err) {
                var authData = localStorageService.get('authorizationData');

                if (authData) {
                    $scope.refreshnotrequired = true;
                    username = authData.userName;
                }
                authenticated = false;
                $scope.loginData = {
                    userName: username,
                    password: "",
                    useRefreshToken: "",
                    smartkey: "",
                    showsmartkey: authenticated,
                    buttonText: buttonText
                };
                $scope.message = err.error_description;
            });
        };

        $scope.lock = function () {
            var deferred = $q.defer();

            authData = localStorageService.get('authorizationData');

            if (authData) {
                localStorageService.set('expiredToken', authData.token);

                localDBService.Open(dbModel).then(function () {
                    localDBService.GetAll(dbModel.objectStoreName.caseload).then(function (result) {
                        if (result) {
                            var encrCaseload = { Caseload: commonService.Encrypt(JSON.stringify(result), authData.encryptedToken) };
                            localStorageService.set('encrCaseload', encrCaseload);
                            localStorageService.remove('authorizationData');

                            localDBService.Clear(dbModel.objectStoreName.caseload).then(function () { deferred.resolve(); });
                        }
                    });
                });
            }

            return deferred.promise;
        };

        function setHomeScreen() {
            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (result) {
                    if (result.length > 0) {
                        commonServiceDB.SetHomeScreen('login', result[0]);

                        var lastExpiredToken = localStorageService.get('expiredToken');
                        var encrCaseload = localStorageService.get('encrCaseload');

                        var caseloadData = commonService.Decrypt(encrCaseload.Caseload, commonService.Encrypt(lastExpiredToken, $scope.loginData.smartkey));

                        if (caseloadData) {
                            localDBService.Put(dbModel.objectStoreName.caseload, $.parseJSON(caseloadData)).then(function () {
                                if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true) {
                                    Idle.watch();
                                }
                            });
                        }
                    }
                },
                function (error) {
                    $scope.error = error;
                });
            });
        }

        $scope.lock();
    }]);