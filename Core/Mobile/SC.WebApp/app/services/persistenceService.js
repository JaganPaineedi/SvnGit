'use strict';

app.factory('persistenceService', ['$q', 'localPersistenceStrategy', 'remotePersistenceStrategy',
    function ($q, localPersistenceStrategy, remotePersistenceStrategy) {

        var persistenceServiceFactory = {};

        var self = this;

        self.persistenceType = 'remote';

        self.action = remotePersistenceStrategy;

        Offline.on('confirmed-down', function () {
            self.action = localPersistenceStrategy;
            self.persistenceServiceType = 'local';
        });

        Offline.on('confirmed-up', function () {
            self.action = remotePersistenceStrategy;
            self.persistenceServiceType = 'remote';
        });

        self.getDetailData = function (id, objectStoreName) {
            return localPersistenceStrategy.getById(id, objectStoreName);
        };

        self.getById = function (id, objectStoreName) {
            var deferred = $q.defer();

            var localData = {};

            self.getDetailData(id, objectStoreName).then(function (result) {

                localData = result;

                deferred.resolve(localData);

            }, deferred.reject);

            return deferred.promise;
        };

        self.put = function (primaryKey, objectStoreName, storeData) {
            return localPersistenceStrategy.put(primaryKey, objectStoreName, storeData);
        };

        persistenceServiceFactory = self;

        return persistenceServiceFactory;
    }]);