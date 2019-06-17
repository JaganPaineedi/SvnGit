'use strict';

app.controller('indexController', ['$scope', '$q', '$location', 'authService', 'briefcaseService', '$window', 'localStorageService', 'ngAuthSettings', 'persistenceService', '$route', 'commonService', 'localDBService', 'dbModel', 'localPersistenceStrategy', 'syncService', 'remotePersistenceStrategy', 'Idle', '$http', 'commonServiceDB',
    function ($scope, $q, $location, authService, briefcaseService, $window, localStorageService, ngAuthSettings, persistenceService, $route, commonService, localDBService, dbModel, localPersistenceStrategy, syncService, remotePersistenceStrategy, Idle, $http, commonServiceDB) {

        var authData = localStorageService.get('authorizationData');
        $scope.status = true;
        $scope.HideHeaderandFooter = true;
        var syncing = false;

        //Show the Header and Footer on Controller load.
        $('#divNavBar').show();
        $('#divFooter').show();
        if (authData !== null && authData.privateKeyRequired) {
            $scope.lockText = "Unlock";
            $scope.lockIcon = "fa fa-unlock";
        }
        else { $scope.lockText = "Lock"; $scope.lockIcon = "fa fa-lock"; }

        $scope.logOut = function () {
            $scope.lock();
        };

        $scope.redirect = function (url) {
            _hideNavBar();
            $location.path(url);
        };

        $scope.updateBriefCase = function () {
            authService.SetLoginActionType("UB");
            _hideNavBar();
            if ($scope.status === true && !authService.getprivatekeyrequired()) {
                if (commonService.localChangesCount * 1 > 0) {
                    commonService.ShowMessageBox('Information', 'Please Sync you local changes before you update the briefcase.');
                }
                else {
                    var syncData = { hasLocalChanges: false, localChangesCount: commonService.localChangesCount };
                    localStorageService.set('syncData', syncData);
                    var authData = localStorageService.get('authorizationData');

                    if (authData.LoginActionType)
                        $location.path('/login/' + authData.LoginActionType);
                    else
                        $location.path('/login/LN');

                    authData.updatebriefcase = true;
                    localStorageService.set('authorizationData', authData);
                    //var briefcase = { 'update': true };
                    //localStorageService.set('briefcase', briefcase);
                }
            }
        };

        $scope.SetHomeScreen = function () {
            localDBService.GetAll('mypreference').then(function (preference) {
                commonServiceDB.SetHomeScreen("login", preference[0]);
            });
        };

        $scope.downloadTemplate = function () {
            _hideNavBar();
            //var serviceBase = ngAuthSettings.apiServiceBaseUri;
            var queryString = '?StaffId=' + authService.GetCurrentStaffId();
            commonService.ShowProcessing();

            var location = $window.location.origin + $window.location.pathname;

            $http.get(location + 'utility/SmartCare.ashx' + queryString).success(function (result) {
                if ('serviceWorker' in navigator) {
                    var randomNum = Math.random();
                    navigator.serviceWorker.register($window.location.origin + $window.location.pathname + 'sw.js?rand=' + randomNum).then(function (registration) {
                        registration.update();
                        commonService.HideProcessing();
                    }).catch(function (error) {
                        commonService.HideProcessing();
                        console.log('Registration failed with ' + error);
                    });
                }
            }).error(function (err) { commonService.HideProcessing(); });
        };

        $scope.redirecttodocuments = function () {
            var id, action = '';

            var parts = $location.absUrl().split('/');
            if ($.isNumeric(parts[parts.length - 1])) {
                action = parts[parts.length - 2]
                id = Number(parts[parts.length - 1]);
                if (action === 'caseloads' && id > 0)
                    $location.path('/documents/' + id);
            }
            else authService.ShowClientContent = false;
        };

        $scope.createService = function () {
            var id, action = '';

            var parts = $location.absUrl().split('/');
            if ($.isNumeric(parts[parts.length - 1])) {
                action = parts[parts.length - 2];
                id = Number(parts[parts.length - 1]);
                if (action === 'caseloads' && id > 0)
                    $location.path('/createservice/' + id);
            }
            else authService.ShowClientContent = false;
        };

        $scope.onExit = function () {
            $scope.lock();
        };

        Offline.on('confirmed-down', function () {
            $scope.status = false;
            localStorageService.set('syncing', false);
            syncService.Syncing = false;
            commonService.HideProcessing();
            $scope.$apply();
        });

        Offline.on('confirmed-up', function () {
            $scope.status = true;
            $scope.$apply();
            if (!syncService.Syncing) {
                if (commonService.localChangesCount > 0) {
                    localStorageService.set('syncing', true);
                    syncService.Syncing = true;
                    syncService.AutoSync().then(function () {
                        syncService.Syncing = false;
                        localStorageService.set('syncing', false);
                        if (commonService.localChangesCount === 0) {
                            briefcaseService.GetBriefcaseData();
                        }
                    });
                }

                if (!syncService.Syncing) {
                    syncService.AutoErrorSync();
                }
            }

        });

        $scope.authentication = authService.authentication;

        $scope.lock = function (FromMenu) {
            if (authService.GetLoginActionType() === "ET")
                authService.SetLoginActionType("ET");
            else
                authService.SetLoginActionType("UL");

            _hideNavBar();
            Idle.unwatch();
            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.caseload).then(function (result) {
                    var authData = localStorageService.get('authorizationData');

                    if (authData.encryptedToken !== '') {
                        if (result.length > 0) {
                            var encrCaseload = { Caseload: commonService.Encrypt(JSON.stringify(result), authData.encryptedToken) };
                            localStorageService.set('encrCaseload', encrCaseload);
                        }

                        authData.encryptedToken = '';
                        authData.privateKeyRequired = true;
                        if (!authData.urlbeforelock)
                            authData.urlbeforelock = $location.$$path;
                        if (FromMenu)
                            authData.updatebriefcase = false;
                        localStorageService.set('authorizationData', authData);
                        if (authData.LoginActionType)
                            $location.path('/login/' + authData.LoginActionType);
                        else
                            $location.path('/login/LN');
                        $scope.lockText = "Unlock";
                        $scope.lockIcon = "fa fa-unlock";

                        localDBService.Clear(dbModel.objectStoreName.caseload);
                    }
                });
            });
        };

        if (commonService.IsIos()) {
            $window.onpagehide = $scope.onExit;
            $window.onunload = $scope.onExit;
        }
        else { $window.onbeforeunload = $scope.onExit; }

        var _hideNavBar = function () {
            $(".navbar-collapse").collapse('hide');
        };

        $scope.brifcaseUpdatedOn = localStorageService.get('briefcaseUpdatedOn');

        if (authData) { $scope.sessionExpiringOn = moment.utc(authData["tokenExpiresOn"]).toDate(); }
        else { $scope.sessionExpiringOn = null; }

        $scope.$watch(function () { return briefcaseService.UpdatedOn; }, function (newdate, olddate) {
            if (newdate)
                $scope.brifcaseUpdatedOn = newdate;
            else
                $scope.brifcaseUpdatedOn = localStorageService.get('briefcaseUpdatedOn');
        });

        $scope.$watch(function () { return commonService.localChangesCount; }, function (newCount, oldCount) {
            $scope.localChangesCount = newCount;
            if (newCount * 1 === 0)
                syncService.Syncing = false;
        });

        $scope.$watch(function () { return syncService.Syncing; }, function (newvalue, oldvalue) {
            if (newvalue)
                $scope.Syncing = newvalue;
            else
                $scope.Syncing = false;
        });

        $scope.$watch(function () { return remotePersistenceStrategy.actioncompleted; }, function (newValue, oldValue) {
            if (newValue) {
                syncService.Syncing = false
            }
        });

        $scope.$watch(function () { return authService.getprivatekeyrequired(); }, function (required, olddate) {
            if (!required) {
                $scope.lockText = "Lock";
                $scope.lockIcon = "fa fa-lock";
            }
            else {
                $scope.lockText = "Unlock";
                $scope.lockIcon = "fa fa-unlock";
                $scope.lock();
            }
        });

        $scope.$watch(function () { return authService.ShowClientContent; }, function (showclientContent, oldshowclientContent) {
            $scope.ShowClientContent = showclientContent;
        });

        $scope.$watch(function () { return authService.authentication.hideHeaderandFooter; }, function (hideHeaderandFooter, oldhideHeaderandFooter) {
            $scope.HideHeaderandFooter = hideHeaderandFooter;
        });

        $scope.$watch(function () { return authService.authentication.newTokenIssuedOn; }, function (newValue, oldValue) {
            var authData = localStorageService.get('authorizationData');
            if (authData && authData["tokenExpiresOn"]) {
                if (moment.utc(authData["tokenExpiresOn"]).toDate() < new Date())
                    $scope.sessionExpired = true;
                else {
                    $scope.sessionExpired = false;
                }
            }
        });

        $scope.$watch(function () { return commonService.ShowHomeButton; }, function (newValue, oldValue) {
            commonService.ShowHomeButton = newValue;
            $scope.showHomeButton = commonService.ShowHomeButton;
        });
        $(document).click(function () { _hideNavBar(); });
    }]);