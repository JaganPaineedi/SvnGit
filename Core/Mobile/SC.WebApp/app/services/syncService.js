'use strict';

app.factory('syncService', ['ngAuthSettings', '$http', 'dbModel', 'localDBService', '$q', 'remotePersistenceStrategy', 'localPersistenceStrategy',
    'persistenceService', 'localStorageService', 'authService', function (ngAuthSettings, $http, dbModel, localDBService, $q, remotePersistenceStrategy, localPersistenceStrategy,
        persistenceService, localStorageService, authService) {

        var syncService = {};
        var _syncing = false;

        var _check = function () {
            var hasLocalChanges = localStorageService.get('hasLocalChanges');

            return hasLocalChanges === null ? false : hasLocalChanges;
        };

        var _monitorUp = function () {
            var deferred = $q.defer();

            Offline.on('confirmed-up', function () {
                syncService.Check().then(function (result) {
                    deferred.resolve(result);
                }, deferred.reject);
            });

            return deferred.promise;
        };

        var _monitorDown = function () {
            var deferred = $q.defer();

            Offline.on('confirmed-down', function () {
                syncService.Check().then(function (result) {
                    deferred.resolve(false);
                });
            });

            return deferred.promise;
        };

        var _sync = function () {
            var deferred = $q.defer();

            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (myPreference) {

                    remotePersistenceStrategy.Save(myPreference).then(function (result) {
                        if (result) {
                            //Clear the Data after sync
                            localStorageService.set('hasLocalChanges', false);
                        }
                    });
                },
                    function (error) {
                        $scope.error = error;
                    });
            });
        };

        var _automaticSync = function () {
            var deferred = $q.defer();

            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.objectstorenames).then(function (unsavedChanges) {
                    var data = [];
                    var objectList = [];
                    if (unsavedChanges.length > 0) {
                        $.map(unsavedChanges, function (i, j) { if ($.inArray(i.objectstorename, data) < 0) { data.push(i.objectstorename); } });
                    }

                    for (var item in data) {


                        objectList = $.grep(unsavedChanges, function (value, index) {
                            return (value['objectstorename'] === data[item]);
                        });
                        if (objectList) {
                            localDBService.Open(dbModel).then(function () {
                                var objectStore = [];
                                localPersistenceStrategy.getById(Number(objectList[0]['id']), objectList[0]['objectstorename']).then(function (result) {
                                    objectStore.push(result.target.result);
                                    //syncService.Syncing = true;
                                    //localStorageService.set('syncing', true);

                                    persistenceService.action.save(objectStore, data[item]).then(function (val) { deferred.resolve(val) });
                                });
                            });
                        }
                    }
                });
            });
            return deferred.promise;
        };

        var _automaticErrorSync = function () {
            syncService.Syncing = true;
            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.errorlog).then(function (results) {
                    if (results.length > 0) {

                        var serviceBase = ngAuthSettings.apiServiceBaseUri;
                        var queryString = '?StaffId=' + authService.GetCurrentStaffId();
                        $http.post(serviceBase + 'api/ErrorLog' + queryString, results[0])
                            .success(function (result) {
                                if (result && result.deleteUnsavedChanges && result.unsavedId) {
                                    localDBService.Delete(dbModel.objectStoreName.errorlog, result.unsavedId).then(function (results) {
                                        syncService.Syncing = false;
                                    });
                                }
                            })
                            .error(function (err) { syncService.Syncing = false; });
                    }
                    else { syncService.Syncing = false; }
                });
            });
        };

        var _autoSyncFromNativeApp = function () {
            syncService.Syncing = false;
            if (localStorage.getItem("authorizationData") !== null) {

                var lclStrgeDateAuth = JSON.parse(localStorage["authorizationData"]);

                localStorageService.set('authorizationData', lclStrgeDateAuth);
                authService.authentication.isAuth = true;
                authService.authentication.userName = lclStrgeDateAuth.userName;
                authService.authentication.userNameDisplayAs = lclStrgeDateAuth.userNameDisplayAs;
                authService.authentication.useRefreshTokens = true;
                authService.authentication.privateKeyRequired = false;
                authService.authentication.newTokenIssuedOn = new Date();
                authService.authentication.loginfromNativeApp = lclStrgeDateAuth.loginfromNativeApp;

                if (lclStrgeDateAuth.loginfromNativeApp)
                    authService.authentication.hideHeaderandFooter = true;
                else
                    authService.authentication.hideHeaderandFooter = false;

                localStorage.removeItem('authorizationData');
            }
        };


        syncService.Check = _check;
        syncService.MonitorUp = _monitorUp;
        syncService.MonitorDown = _monitorDown;
        syncService.Sync = _sync;
        syncService.AutoSync = _automaticSync;
        syncService.AutoErrorSync = _automaticErrorSync;
        syncService.Syncing = _syncing;
        syncService.AutoSyncFromNativeApp = _autoSyncFromNativeApp;

        return syncService;
    }]);