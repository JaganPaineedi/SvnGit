'use strict';
app.controller('syncController', ['$scope', 'localDBService', 'dbModel', 'persistenceService', 'commonService', 'remotePersistenceStrategy', 'authService', '$location','syncService',
    function ($scope, localDBService, dbModel, persistenceService, commonService, remotePersistenceStrategy, authService, $location,syncService) {
        if (authService.getprivatekeyrequired() == true) {
            $location.path('/login/UL');
            return;
        }
        $scope.title = "Sync";

        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.objectstorenames).then(function (result) {
                if (result.length > 0)
                    $scope.objectstorenames = result;
            });
        });
        $scope.toggle = function () { alert(); };
        $scope.sync = function () {
            var objectStoreNames = [];
            if (Offline.state == 'down')
                commonService.ShowtostMessage("You are offline.", "error", 2000);
            else {
                if ($scope.objectstorenames) {
                    for (var uchange in $scope.objectstorenames) {
                        var primaryKeyValue = $scope.objectstorenames[uchange].id;
                        var objectStoreName = $scope.objectstorenames[uchange].objectstorename;
                        syncService.Syncing = true;
                        remotePersistenceStrategy.saveIndividual(primaryKeyValue, objectStoreName).then(function (result) { syncService.Syncing = false; });
                    }
                }
            }
        };

        $scope.discard = function (objectStoreName) {
            localPersistenceStrategy.delete(objectStoreName, objectStoreName).then(function () {
                commonService.ShowtostMessage("Your Home Screen preference has been saved successfully!!", "Success");
                //Check whether the mypreference table already have local changes. If not, Insert.
                localPersistenceStrategy.insert({ objectstorename: 'myPreference', localName: 'My Preferences' }, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                    if (!result) {
                        commonService.UpdateLocalChangesCount();
                    }
                });
            });
        };
    }]);