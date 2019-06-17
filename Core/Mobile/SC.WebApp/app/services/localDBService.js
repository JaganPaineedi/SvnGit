'use strict';

app.factory('localDBService', ['$q', 'ngAuthSettings', 'localStorageService', '$window', function ($q, ngAuthSettings, localStorageService, $window) {

    var localDBServiceFactory = {};
    var authData = localStorageService.get('authorizationData');
    
    var _error = {
        setErrorHandlers: function (request, errorHandler) {
            if (typeof request !== 'undefined') {
                if ('onerror' in request) request.onerror = errorHandler;
                if ('onblocked' in request) request.onblocked = errorHandler;
                if ('onabort' in request) request.onabort = errorHandler;
            }
        }
    }

    var _db = {
        instance: null,
        transactionTypes: {
            readonly: 'readonly',
            readwrite: 'readwrite'
        },
        open: function (databaseModel) {
            var _dbInfo = localStorageService.get('db');
            if (!_dbInfo) {
                var db = { version: 1, name: 'SmartCare' };
                localStorageService.set('db', db);
                _dbInfo = localStorageService.get('db');
            }
            else { _dbInfo.version = databaseModel.version; localStorageService.set('db', _dbInfo); }
            var deferred = $q.defer();
            var request = ngAuthSettings.indexedDB.open(databaseModel.name, _dbInfo['version']);

            _error.setErrorHandlers(request, deferred.reject);

            request.onupgradeneeded = databaseModel.upgrade;

            request.onsuccess = function (e) {
                _db.instance = e.target.result;
                _error.setErrorHandlers(_db.instance, deferred.reject);
                deferred.resolve();
            };

            return deferred.promise;
        },
        requireOpenDB: function (objectStorename, deferred) {
            if (_db.instance === null) {
                deferred.reject('You cannot use an object store when the database is not open. Store name: ' + objectStorename)
            }
        },
        getObjectStore: function (objectStoreName, mode) {
            var modeact = mode || _db.transactionTypes.readonly;
            var txn = _db.instance.transaction(objectStoreName, modeact);
            var store = txn.objectStore(objectStoreName);

            return store;
        },
        requireObjectStoreName: function (objectStoreName, deferred) {
            if (typeof (objectStoreName) === 'undefined' || !objectStoreName || objectStoreName.length === 0) {
                deferred.reject('An objectStoreName is required');
            }
        },
        getCount: function (objectStoreName) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName);
            var request = store.count();
            var count;

            request.onsuccess = function (e) {
                count = e.target.result;
                deferred.resolve(count);
            };

            return deferred.promise;
        },
        getAll: function (objectStoreName) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName);
            var cursor = store.openCursor();
            var data = [];

            cursor.onsuccess = function (e) {
                var result = e.target.result;

                if (result && result !== null) {
                    if (result.value.recordDeleted !== 'Y')
                        data.push(result.value);
                    result.continue();
                } else {
                    deferred.resolve(data);
                }
            };

            return deferred.promise;
        },
        insert: function (objectStoreName, data, keyName) {
            var primaryKeyValue = localStorageService.get('primaryKey');
            if (!primaryKeyValue){
                primaryKeyValue = -1;
                localStorageService.set('primaryKey', primaryKeyValue);
            }
            else{
                localStorageService.set('primaryKey', primaryKeyValue - 1);
                primaryKeyValue = parseInt(localStorageService.get('primaryKey'));
            }
            var deferred = $q.defer();
            
            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite);

            var request;

            _db.updateCreatedInformation(data);

            if (!data[keyName]) {
                data[keyName] = primaryKeyValue;
            }

            request = store.add(data);

            request.onsuccess = function () {
                deferred.resolve(data);
            }

            return deferred.promise;
        },
        'delete': function (objectStoreName, key) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite),
            request = store.delete(key);

            request.onsuccess = function () { deferred.resolve(key); }           

            return deferred.promise;
        },
        update: function (objectStoreName, data, key) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite),
                getRequest = store.get(key),
                updateRequest;

            getRequest.onsuccess = function (e) {
                var origData = e.target.result;

                if (origData !== undefined) {
                    //_db.updateModifiedInformation(data);

                    updateRequest = store.put(data);

                    updateRequest.onsuccess = function (e) {
                        deferred.resolve(data, e);
                    };
                }
            };

            return deferred.promise;
        },
        updateDeleted: function (objectStoreName, data, key) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite),
                getRequest = store.get(key),
                updateRequest;

            getRequest.onsuccess = function (e) {
                var origData = e.target.result;

                if (origData !== undefined) {
                    _db.updateDeletedinformation(origData);

                    updateRequest = store.put(origData);

                    updateRequest.onsuccess = function (e) {
                        deferred.resolve(origData, e);
                    };
                }
            };

            return deferred.promise;
        },
        getById: function (objectStoreName, key) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName);
            var request = store.get(key);

            request.onsuccess = deferred.resolve;

            return deferred.promise;
        },
        clear: function (objectStoreName) {
            var deferred = $q.defer();

            _db.requireObjectStoreName(objectStoreName, deferred);
            _db.requireOpenDB(objectStoreName, deferred);

            var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite);

            var request = store.clear();

            request.onsuccess = deferred.resolve;

            return deferred.promise;
        },
        put: function (objectStoreName, data, keyName, putSingleItem) {
            if (data) {
                var deferred = $q.defer();

                _db.requireObjectStoreName(objectStoreName, deferred);
                _db.requireOpenDB(objectStoreName, deferred);

                var store = _db.getObjectStore(objectStoreName, _db.transactionTypes.readwrite);

                var request;

                var date = new Date();

                if (putSingleItem) {
                    request = store.put(data);
                }
                else {
                    for (var item in data) {
                        request = store.put(data[item]);
                    }
                }
                if (request !== undefined) {
                    request.onsuccess = function () {
                        deferred.resolve(data);
                    }
                }

                return deferred.promise;
            }
        },
        clearAllData: function (db) {
            for (var i in db.objectStoreName) {
                _db.clear(i);
            }
            //deleteDatabase will not be preferable becasue after logout filling briefcase has issue.
            //$window.indexedDB.deleteDatabase(dbname);
        },
        getCurrentUser: function () {
            var authData = localStorageService.get('authorizationData');
            return authData.userName;
        },
        getCurrentUserId: function () {
            var authData = localStorageService.get('authorizationData');
            return parseInt(authData.staffId);
        },
        updateCreatedInformation: function (data) {
            data.createdDate = moment().format();
            data.modifiedDate = moment().format();
            data.createdBy = _db.getCurrentUser();
            data.modifiedBy = _db.getCurrentUser();
        },
        updateModifiedInformation: function (data) {
            data.modifiedDate = moment().format();
            data.modifiedBy = _db.getCurrentUser();
        },
        updateDeletedinformation: function (data) {
            data.recordDeleted = 'Y';
            data.deletedDate = moment().format();
            data.deletedBy = _db.getCurrentUser();
        },
        getLowestPrimaryKeyValue: function (objectStoreName, primaryKey) {
            var deferred = $q.defer();

            var store = _db.getObjectStore(objectStoreName);
            var cursor = store.openCursor();
            var keys = [];

            cursor.onsuccess = function (e) {
                var result = e.target.result;

                if (result && result !== null) {

                    keys.push(result.primaryKey);
                    result.continue();
                } else {
                    if (keys.length === 0)
                        keys.push(0);
                    deferred.resolve(Math.min.apply(Math, keys));
                }
            };
            return deferred.promise;
        }
    };

    localDBServiceFactory.Open = _db.open;
    localDBServiceFactory.GetAll = _db.getAll;
    localDBServiceFactory.Insert = _db.insert;
    localDBServiceFactory.Delete = _db.delete;
    localDBServiceFactory.Update = _db.update;
    localDBServiceFactory.UpdateDeleted = _db.updateDeleted;
    localDBServiceFactory.GetbyId = _db.getById;
    localDBServiceFactory.GetCount = _db.getCount;
    localDBServiceFactory.Clear = _db.clear;
    localDBServiceFactory.Error = _error.setErrorHandlers;
    localDBServiceFactory.Put = _db.put;
    localDBServiceFactory.DeleteDB = _db.deleteDB;
    localDBServiceFactory.ClearAllData = _db.clearAllData;
    localDBServiceFactory.GetCurrentUser = _db.getCurrentUser;
    localDBServiceFactory.GetCurrentUserID = _db.getCurrentUserId;
    localDBServiceFactory.GetLowestPrimaryKeyValue = _db.getLowestPrimaryKeyValue;

    return localDBServiceFactory;
}]);