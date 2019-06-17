'use strict';
app.controller('loginController', ['$scope', '$location', 'authService', 'ngAuthSettings', 'briefcaseService', 'localDBService', 'dbModel', 'localStorageService', '$window', 'Idle', 'commonService', '$http', '$route',
    function ($scope, $location, authService, ngAuthSettings, briefcaseService, localDBService, dbModel, localStorageService, $window, Idle, commonService, $http, $route) {
        var authenticated = false;

        var parts = $location.absUrl().split('/');
        var action = parts[parts.length - 1];

        if (action == "login") {
            $location.path('/login/LN'); return
        }

        if (localStorage.getItem("authorizationData") != null) {
            if (localStorageService.get('authorizationData') == null) {
                var lclStrgeDateAuth = JSON.parse(localStorage["authorizationData"]);

                localStorageService.set('authorizationData', lclStrgeDateAuth);
                authService.authentication.isAuth = true;
                authService.authentication.userName = lclStrgeDateAuth.userName;
                authService.authentication.userNameDisplayAs = lclStrgeDateAuth.userNameDisplayAs;
                authService.authentication.useRefreshTokens = true;
                authService.authentication.privateKeyRequired = true;
                authService.authentication.newTokenIssuedOn = new Date();
                authService.authentication.loginfromNativeApp = lclStrgeDateAuth.loginfromNativeApp;

                if (lclStrgeDateAuth.loginfromNativeApp)
                    authService.authentication.hideHeaderandFooter = true;
                else
                    authService.authentication.hideHeaderandFooter = false;


                localStorage.removeItem('authorizationData');
            }
        }
        var authData = localStorageService.get('authorizationData');
        if (authData == null) {
            authService.authentication.hideHeaderandFooter = true;
            authService.authentication.isAuth = false;
            authService.authentication.userName = '';
            authService.authentication.userNameDisplayAs = '';
        }

        var unlocktrycount = 0;
        var buttonText = "Login";
        var buttonStatus = "LN";

        var db = localStorageService.get('db');
        var syncData = localStorageService.get('syncData');

        if (db === null) {
            db = { version: 1, name: 'SmartCare' };
            localStorageService.set('db', db);
        }
        $scope.loginData = {
            userName: "",
            password: "",
            smartkey: "",
            useRefreshToken: false,
            showsmartkey: authService.authentication.isAuth,
            buttonText: buttonText,
            buttonStatus: buttonStatus
        };

        if (syncData === null) {
            syncData = { hasLocalChanges: false, localChangesCount: 0 };
            localStorageService.set('syncData', syncData);
        }
        if (action == 'LN') buttonText = "Login";
        else buttonText = "Enter SmartKey";

        if (action == "UL") {
            authService.setprivatekeyrequired(true); buttonStatus = action;
            authService.SetLoginActionType(action);
        }
        else if (action == "ET" || action == "LN" || action == "UB") {
            buttonStatus = action;
            authService.SetLoginActionType(action);
        }

        $scope.loginData = {
            userName: authService.authentication.userName,
            password: "",
            smartkey: "",
            useRefreshToken: false,
            showsmartkey: authService.authentication.isAuth,
            buttonText: buttonText,
            buttonStatus: buttonStatus
        };

        $scope.message = "";

        $scope.login = function () {
            if ($scope.loginData.buttonStatus === "ET") {
                //validate SmartKey with Server
                commonService.ShowProcessing();
                authService.validateSmartKey($scope.loginData).then(function (response) {
                    var authData = localStorageService.get('authorizationData');

                    authData.encryptedToken = commonService.Encrypt(authData.token, $scope.loginData.smartkey);

                    authData.privateKeyRequired = false;
                    localStorageService.set('authorizationData', authData);
                    //ajax
                    //Success
                    briefcaseService.GetBriefcaseData('login', $scope.loginData.smartkey)
                        .then(function () {
                            commonService.GetSystemConfigurationKeyValue('SETMOBILEOFFLINECHECKINMILLISECONDS').then(function (value) {
                                if (value) {
                                    setTimeout(function retry() {
                                        authService.authentication.newTokenIssuedOn = new Date();
                                        Offline.check();
                                        setTimeout(retry, Number(value));
                                    }, Number(value));
                                }
                            });
                            commonService.GetSystemConfigurationKeyValue('SETMOBILEIDLETIMEINSECONDS').then(function (value) {
                                if (value) {
                                    if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true) {
                                        Idle.setIdle(Number(value));
                                        Idle.watch();
                                    }
                                }
                            });
                            commonService.GetSystemConfigurationKeyValue('SETMOBILETIMEOUTINSECONDS').then(function (value) {
                                if (value) {
                                    if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true) {
                                        Idle.setTimeout(Number(value));
                                        Idle.watch();
                                    }
                                }
                            });
                            authService.SetLoginActionType("");
                        });
                }, function (err) { $scope.message = err.message; commonService.HideProcessing(); });
            }
            else if ($scope.loginData.buttonStatus === "LN") {
                authService.login($scope.loginData).then(function (response) {
                    authenticated = true;
                    $scope.message = "";
                    if (authService.getprivatekeyrequired()) {
                        buttonText = "Enter SmartKey";
                        buttonStatus = "ET";
                        $location.path('/login/ET');
                        if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                            Idle.unwatch();
                    }
                    $scope.loginData = {
                        userName: $scope.loginData.userName,
                        password: $scope.loginData.password,
                        smartkey: "",
                        showsmartkey: authenticated,
                        buttonText: buttonText,
                        buttonStatus: buttonStatus
                    };
                },
                    function (err) {
                        if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                            Idle.unwatch();
                        authenticated = false;
                        buttonText = "Login";
                        buttonStatus = "LN";
                        $scope.loginData = {
                            userName: "",
                            password: "",
                            useRefreshToken: "",
                            smartkey: "",
                            showsmartkey: authenticated,
                            buttonText: buttonText,
                            buttonStatus: buttonStatus
                        };
                        $scope.message = err.error_description;
                    });
            }
            else if ($scope.loginData.buttonStatus === "UB") {
                var authData = localStorageService.get('authorizationData');
                try {
                    if (commonService.Decrypt(authData.encryptedToken, $scope.loginData.smartkey) === authData.token) {
                        briefcaseService.GetBriefcaseData('login', $scope.loginData.smartkey).then(function () {
                            if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                                Idle.watch();
                        });
                    }
                } catch (e) {
                    $scope.message = "Please enter a valid SmartKey!"
                }

            }
            else if ($scope.loginData.buttonStatus === "UL") {

                unlocktrycount++
                var retrycount = ngAuthSettings.unlockRetryCount - unlocktrycount;
                if (retrycount >= 0) {
                    authData = localStorageService.get('authorizationData');
                    var encrCaseload = localStorageService.get('encrCaseload');
                    try {
                        authData.encryptedToken = commonService.Encrypt(authData.token, $scope.loginData.smartkey);
                        authData.privateKeyRequired = false;
                        localStorageService.set('authorizationData', authData);
                        if (encrCaseload) {
                            var decryptedcaseload = commonService.Decrypt(encrCaseload.Caseload, authData.encryptedToken);
                            var caseloads = commonService.ConvertArrayColumnToInteger($.parseJSON(decryptedcaseload), ['clientId', 'phoneType', 'primaryProgramId', 'addressType']);
                            localDBService.Open(dbModel).then(function () {
                                localDBService.Put(dbModel.objectStoreName.caseload, caseloads).then(function () {
                                    if (authData.urlbeforelock && authData.urlbeforelock.indexOf('/login') == -1) { $location.path(authData.urlbeforelock); }
                                    else $location.path('/');
                                    //authData.urlbeforelock = undefined;
                                    authData.LoginActionType = "";
                                    localStorageService.set('authorizationData', authData);
                                    if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                                        Idle.watch();
                                    unlocktrycount = 0;
                                });
                            });
                        }

                        //unlock issue
                        else {

                            try {
                                if ($scope.loginData.smartkey != "") {
                                    var decryptedToken = commonService.Decrypt(authData.encryptedToken, $scope.loginData.smartkey);
                                    if (authData.urlbeforelock && authData.urlbeforelock.indexOf('/login') == -1) { $location.path(authData.urlbeforelock); }
                                    else $location.path('/');
                                    authData.urlbeforelock = undefined;
                                    localStorageService.set('authorizationData', authData);
                                    if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                                        Idle.watch();
                                    unlocktrycount = 0;
                                }
                                else {
                                    $scope.message = "Please enter a Smartkey"
                                }
                            } catch (e) { throw e; }
                        }

                    } catch (e) {
                        if (retrycount === 0) {
                            localStorageService.remove('authorizationData');
                            localStorageService.remove('syncData');
                            localStorageService.remove('encrCaseload');
                            localStorageService.remove('db');
                            localStorageService.remove('briefcase');
                            localDBService.Open(dbModel).then(function () {
                                localDBService.ClearAllData(dbModel);
                                authService.authentication.isAuth = false;
                                authService.authentication.hideHeaderandFooter = true;
                                authService.authentication.userName = "";
                                $location.path('/login/LN');
                                $route.reload();
                            });
                        }
                        $scope.message = "Please enter a valid SmartKey!"
                        if (retrycount > 0)
                            $scope.retryCountMessage = "(" + (retrycount) + ")";
                    }
                }
                else {
                    localStorageService.remove('authorizationData');
                    localStorageService.remove('syncData');
                    localDBService.Open(dbModel).then(function () {
                        localDBService.ClearAllData(dbModel.name);
                        authService.authentication.isAuth = false;
                        $route.reload();
                    });

                }
            }
        }

        $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;
        if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
            Idle.unwatch();
    }]);