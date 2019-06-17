'use strict';

app.factory('remotePersistenceStrategy', ['$http', '$q', 'ngAuthSettings', 'localPersistenceStrategy', 'commonService', 'authService', '$location', 'dbModel', '$route',
function ($http, $q, ngAuthSettings, localPersistenceStrategy, commonService, authService, $location, dbModel, $route) {

    var serviceBase = ngAuthSettings.apiServiceBaseUri;
    var remotePersistenceStrategyFactory = {
        save: function (objectStoreObjects, objectName) {
            var processedResults = [];
            var deferred = $q.defer();
            var queryString = '?StaffId=' + authService.GetCurrentStaffId();
            var result;
            var arrObject = [];

            $http.post(serviceBase + 'api/' + objectName + queryString, objectStoreObjects)
                .success(function (results) {
                    for (var i = 0; i < results.length; i++) {
                        localPersistenceStrategy.delete(results[i].unsavedId, dbModel.objectStoreName.objectstorenames).then(function (res) {
                            result = $.grep(results, function (value, index) {
                                return (value.unsavedId === res);
                            })[0];
                            //After deleting the existing entry from IndexedDb, it will create a new entry in the 'objectstorenames'
                            if (!result.deleteUnsavedChanges) {
                                var details = {
                                    objectstorename: result.localstoreName,
                                    localName: result.localName,
                                    showDetails: true,
                                    id: result.savedId,
                                    details: result.details,
                                    hasNotification: true,
                                    notification: result.serviceValidationMessages
                                };
                                localPersistenceStrategy.insert(details, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                                    if (!result) {
                                        commonService.UpdateLocalChangesCount();
                                        if ($location.path() === '/sync')
                                            $route.reload();
                                    }
                                });
                            }
                            else {
                                commonService.UpdateLocalChangesCount();
                                if ($location.path() === '/sync')
                                    $route.reload();
                            }
                            //Delete unsaved entry from saved localstoreName
                            localPersistenceStrategy.delete(res, result.localstoreName).then(function (Obj2) {
                                result = $.grep(results, function (value, index) {
                                    return (value.unsavedId === Obj2);
                                })[0];
                                if (result.savedResult !== null) {
                                    var res = result.savedResult;
                                    arrObject.push(res);
                                    if (arrObject.length === objectStoreObjects.length) {
                                        //Put the saved record into indexeddb
                                        localPersistenceStrategy.put(undefined, result.localstoreName, arrObject).then(function (Obj1) {
                                            deferred.resolve(arrObject);
                                            //Can be watched to perform any action on other screens.(Scenario:In MyCalendar to Refresh the Calendar)
                                            remotePersistenceStrategyFactory.actioncompleted = true;
                                        });
                                    }
                                }
                                else //Else statement is added incase if the SavedResult comes back as Null(Scenario : Delete Calendar will not return anything in the SavedResult)
                                    remotePersistenceStrategyFactory.actioncompleted = true;
                            });
                            commonService.HideProcessing();
                        });
                    }
                    //Delete unsaved entry from objectstorenames

                })
                .error(function (err) { deferred.reject(err); });

            return deferred.promise;
        },

        saveIndividual: function (primaryKey, objectStoreName) {
            var deferred = $q.defer();
            localPersistenceStrategy.getById(Number(primaryKey), objectStoreName).then(function (obj) {
                var queryString = '?StaffId=' + authService.GetCurrentStaffId();
                var results = [];
                results.push(obj.target.result);
                $http.post(serviceBase + 'api/' + objectStoreName + queryString, results)
                    .success(function (results) {
                        for (var i = 0; i < results.length; i++) {
                            var result = results[i];
                            localPersistenceStrategy.delete(result.unsavedId, dbModel.objectStoreName.objectstorenames).then(function () {
                                if (!result.deleteUnsavedChanges) {
                                    var details = {
                                        objectstorename: result.localstoreName,
                                        localName: result.localName,
                                        showDetails: true,
                                        id: result.savedId,
                                        details: result.details,
                                        hasNotification: true,
                                        notification: result.serviceValidationMessages
                                    };
                                    localPersistenceStrategy.insert(details, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                                        if (!result) {
                                            commonService.UpdateLocalChangesCount();
                                            if ($location.path() === '/sync')
                                                $route.reload();
                                        }
                                    });
                                }
                                else {
                                    commonService.UpdateLocalChangesCount();
                                    if ($location.path() === '/sync')
                                        $route.reload();
                                }

                                localPersistenceStrategy.delete(result.unsavedId, result.localstoreName).then(function () {
                                    if (result.savedResult !== null) {
                                        var res = result.savedResult;
                                        var arrObject = [];
                                        arrObject.push(res);
                                        //Put the saved record into indexeddb
                                        localPersistenceStrategy.put(undefined, result.localstoreName, arrObject).then(function () {
                                            deferred.resolve(result);
                                            //Can be watched to perform any action on other screens.(Scenario:In MyCalendar to Refresh the Calendar)
                                            remotePersistenceStrategyFactory.actioncompleted = true;
                                        });
                                    }
                                    else //Else statement is added incase if the SavedResult comes back as Null(Scenario : Delete Calendar will not return anything in the SavedResult)
                                        remotePersistenceStrategyFactory.actioncompleted = true;
                                });
                                commonService.HideProcessing();


                                //commonService.UpdateLocalChangesCount();
                                //localPersistenceStrategy.delete(result.unsavedId, result.localstoreName).then(function () {
                                //    var res = result.savedResult;
                                //    var arrObject = [];
                                //    arrObject.push(res);
                                //    localPersistenceStrategy.put(undefined, result.localstoreName, arrObject).then(function () {
                                //        if ($location.path() === '/sync')
                                //            $route.reload();
                                //        deferred.resolve(result);
                                //    });
                                //});
                            });
                        }


                    });
            });
            return deferred.promise;
        }
    };
    return remotePersistenceStrategyFactory;
}]);


app.factory('localPersistenceStrategy', ['$q', 'localDBService', 'dbModel', function ($q, localDBService, dbModel) {
    var localPersistenceStrategyFactory = {
        dbModel: dbModel,

        localDBService: localDBService,
        getById: function (id, objectStoreName) {
            var deferred = $q.defer();

            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function () {
                localDBService.GetbyId(objectStoreName, id)
                              .then(deferred.resolve,
                                    deferred.reject);
            }, deferred.reject);

            return deferred.promise;
        },
        exists: function (id, objectStoreName, primaryKey) {

            var deferred = $q.defer();

            localPersistenceStrategyFactory.getById(id, objectStoreName).then(function (item) {
                if (item.target.result)
                    deferred.resolve(item.target.result[primaryKey] === id);
                else
                    deferred.resolve(false);
            }, deferred.reject);

            return deferred.promise;
        },
        save: function (model, primaryKey, objectStoreName) {

            var deferred = $q.defer();

            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function (e) {

                var id = model[primaryKey];

                if (id === null || id === undefined) {
                    localDBService.Insert(objectStoreName, model, primaryKey)
                                  .then(deferred.resolve,
                                        deferred.reject);
                } else {
                    localPersistenceStrategyFactory.exists(id, objectStoreName, primaryKey).then(function (doesExist) {
                        if (doesExist) {
                            localDBService.Update(objectStoreName, model, id)
                                          .then(deferred.resolve,
                                                deferred.reject);
                        } else {
                            localDBService.Insert(objectStoreName, model, primaryKey)
                                          .then(deferred.resolve,
                                                deferred.reject);
                        }

                    }, deferred.reject);
                }

            }, deferred.reject);

            return deferred.promise;
        },
        getAll: function () {

            var deferred = $q.defer();

            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function () {
                localDBService.getAll(localPersistenceStrategyFactory.dbModel.objectStoreName)
                              .then(deferred.resolve,
                                    deferred.reject);
            }, deferred.reject);

            return deferred.promise;
        },
        'delete': function (id, objectStoreName) {

            var deferred = $q.defer();

            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function () {
                localDBService.Delete(localPersistenceStrategyFactory.dbModel.objectStoreName[objectStoreName], id)
                              .then(deferred.resolve,
                                    deferred.reject);
            }, deferred.reject);

            return deferred.promise;
        },
        put: function (primaryKey, objectStoreName, storeData) {
            var deferred = $q.defer();
            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function () {
                localDBService.Put(objectStoreName, storeData, primaryKey)
                              .then(deferred.resolve,
                                    deferred.reject);
            }, deferred.reject);
            return deferred.promise;
        },
        insert: function (model, primaryKey, objectStoreName) {

            var deferred = $q.defer();

            localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function (e) {

                var id = model[primaryKey];


                localPersistenceStrategyFactory.exists(id, objectStoreName, primaryKey).then(function (doesExist) {
                    if (doesExist) {
                        deferred.resolve(true);
                    } else {
                        localDBService.Insert(objectStoreName, model, primaryKey)
                                      .then(deferred.resolve(false),
                                            deferred.resolve(false));
                    }

                }, deferred.reject);

            }, deferred.reject);

            return deferred.promise;
        }
    };

    return localPersistenceStrategyFactory;
}]);