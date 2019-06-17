'use strict';
app.controller('multitableController', ['$scope', 'dbModel', 'ngAuthSettings', 'localStorageService', '$window',
    function ($scope, dbModel, ngAuthSettings, localStorageService, $window) {
        //$window.location.reload();
        $scope.title = "Multi Table";
        $scope.databasename = '';
        var CreateCustomTable = function () {
          
            if (dbModel.instance !== null && 'close' in dbModel.instance) {
                dbModel.instance.close();
            }
            var _dbInfo = localStorageService.get('db');
            _dbInfo['version'] = _dbInfo['version'] + 1;
            localStorageService.set('db', _dbInfo);
            alert(_dbInfo['version']);
            var request = indexedDB.open(dbModel.name, _dbInfo['version'].toString());
            request.onupgradeneeded = function (e) {
                var _dbInfo = localStorageService.get('db');
                _dbInfo['version'] = _dbInfo['version'] - 1;
                localStorageService.set('db', _dbInfo);
                var storeName, newVersion = e.target.result;

                storeName = 'Widgets';

                if (!newVersion.objectStoreNames.contains(storeName)) {

                    console.log('Creating <code>' + storeName + '</code> store');

                    var people = newVersion.createObjectStore(
                                                storeName,
                                                {
                                                    autoIncrement: true
                                                });
                }
                else {
                    var _dbInfo = localStorageService.get('db');
                    _dbInfo['version'] = _dbInfo['version'] - 1;
                    localStorageService.set('db', _dbInfo);
                }
            }
            request.onsuccess = function (e) {
                dbModel.instance = e.target.result;
            }
            request.onblocked = function () {
                var _dbInfo = localStorageService.get('db');
                _dbInfo['version'] = _dbInfo['version'] - 1;
                localStorageService.set('db', _dbInfo);

                if (dbModel.instance !== null && 'close' in dbModel.instance) {
                    dbModel.instance.close();
                }
                CreateCustomTable();
                $window.location.reload();
            };

        }
        CreateCustomTable();
    }]);