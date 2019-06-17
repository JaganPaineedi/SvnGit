'use strict';
app.controller('myPreferencesController', ['$scope', 'ngAuthSettings', 'briefcaseService', 'localDBService', 'dbModel', '$controller',
    'persistenceService', 'commonService', 'localStorageService', 'authService', '$location','localPersistenceStrategy','remotePersistenceStrategy','syncService', function ($scope, ngAuthSettings,
     briefcaseService, localDBService, dbModel, $controller, persistenceService, commonService, localStorageService, authService, $location, localPersistenceStrategy, remotePersistenceStrategy, syncService) {
    if (authService.getprivatekeyrequired() === true) {
        $location.path('/login/UL');
        return;
    }

    $scope.title = "My Preference";
    var model = {
        title: "My Preferences",
        dashboardItems: [],
        myPreference: [],
        homepageScreen: ""
    }

    localDBService.Open(dbModel).then(function () {
        localDBService.GetAll(dbModel.objectStoreName.dashboards).then(function (result) {
            model.dashboardItems = $.map(commonService.ConvertToInteger(result, ['mobileDashboardId']), function (item, index) { if (item.showInMyPreference) return item; });
            localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (myPreferenceresult) {
                model.myPreference = myPreferenceresult[0];
                //if (model.myPreference)
                //    model.homepageScreen = model.myPreference.defaultMobileHomePageId;
                //$scope.currentContext = model;
                $scope.currentContext = model;
            })
        },
        function (error) {
            $scope.error = error;
        });
    });

    $scope.save = function () {
        commonService.ShowProcessing();
        var authData = localStorageService.get('authorizationData');
        
        localPersistenceStrategy.save($scope.currentContext.myPreference, 'staffPreferenceId', dbModel.objectStoreName.mypreference, authData).then(function (mypref) {
            //commonService.ShowtostMessage("Your Home Screen preference has been saved successfully!!", "Success");
            //Check whether the mypreference table already have local changes. If not, Insert.
            localPersistenceStrategy.insert({ objectstorename: 'mypreference', localName: 'My Preferences', showDetails: false, id: mypref.staffPreferenceId }, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                if (!result) {
                    commonService.UpdateLocalChangesCount();
                    if (Offline.state === 'down') {
                        commonService.HideProcessing();
                    }
                    else {
                        syncService.Syncing = true;
                        remotePersistenceStrategy.saveIndividual(mypref.staffPreferenceId, 'mypreference').then(function (result) {
                            syncService.Syncing = false;
                            commonService.HideProcessing();
                        });
                    }
                }
            });
        });
    }

    $scope.setHomeScreen = function (redirectUrl) {
        $location.path(redirectUrl);
    }

    $scope.currentContext = model;

}]);
