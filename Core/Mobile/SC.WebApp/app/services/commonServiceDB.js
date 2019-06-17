'use strict';

app.factory('commonServiceDB', ['dbModel','persistenceService','$location','localStorageService',
    function (dbModel, persistenceService, $location, localStorageService) {
        var commonDBFactory = {};
        
        var _setHomeScreen = function (action, result) {
            if (action === "login") {
                var myPreference = result;
                if (myPreference && myPreference.defaultMobileHomePageId) {
                    persistenceService.getById(myPreference.defaultMobileHomePageId, dbModel.objectStoreName.dashboards).then(function (dashboard) {
                        if (dashboard.target.result.redirectUrl !== "") {
                            $location.path(dashboard.target.result.redirectUrl.replace('#', ''));
                            //setting the url before lock
                            var authdata = localStorageService.get('authorizationData');
                            authdata.urlbeforelock = $location.$$path;
                            localStorageService.set('authorizationData', authdata);
                        }
                        else {
                            $location.path("/mycalendar");
                        }
                    });
                }
                else {
                    $location.path("/mycalendar");
                }
            }
        };

        commonDBFactory.SetHomeScreen = _setHomeScreen;
        return commonDBFactory;
    }]);