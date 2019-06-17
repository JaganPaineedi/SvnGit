'use strict';

app.factory('briefcaseService', ['$http', 'ngAuthSettings', 'localDBService', 'dbModel', 'localStorageService', '$filter', 'persistenceService',
    'commonService', 'commonServiceDB', '$q', 'authService', function ($http, ngAuthSettings, localDBService, dbModel, localStorageService, $filter,
        persistenceService, commonService, commonServiceDB, $q, authService) {

        var serviceBase = ngAuthSettings.apiServiceBaseUri;

        var briefcaseFactory = {};

        var _getBriefcaseData = function (action, smartkey) {
            var deferred = $q.defer();
            commonService.ShowProcessing();
           
            if (localStorage.getItem("authorizationData") != null) {
                if (localStorageService.get('authorizationData') == null) {
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
            }
            var authData = localStorageService.get('authorizationData');
            if (authData) {
                var data = "staffId=" + authData.staffId;

                var briefcase = $http.get(serviceBase + 'api/Briefcase?' + data).then(function (results) {
                    localDBService.Open(dbModel).then(function () {
                        _clearBriefcase();
                        _insertBriefcase(results, action, smartkey);
                        _updateBriefcaseInfo();

                        var authData = localStorageService.get('authorizationData');
                        if (authData.loginfromNativeApp) {
                            authService.SetMobileOfflieCheck();
                            if (commonService.Decrypt(authData.encryptedToken, smartkey) === authData.token) {
                                angular.element(document.body).injector().get('caseloadService').DecryptCaseload(smartkey);
                            }
                            else
                                authService.authentication.privateKeyRequired = true;
                        }
                    });
                    return deferred.resolve(briefcase);
                });
            }
            return deferred.promise;
        };

        var _clearBriefcase = function () {
            localDBService.Clear(dbModel.objectStoreName.dashboards);
            localDBService.Clear(dbModel.objectStoreName.globalcodes);
            localDBService.Clear(dbModel.objectStoreName.caseload);
            localDBService.Clear(dbModel.objectStoreName.mypreference);
            localDBService.Clear(dbModel.objectStoreName.teamcalendarstaff);
            localDBService.Clear(dbModel.objectStoreName.staffprocedurecodes);
            localDBService.Clear(dbModel.objectStoreName.staffprograms);
            localDBService.Clear(dbModel.objectStoreName.stafflocations);
            localDBService.Clear(dbModel.objectStoreName.serviceattending);
            localDBService.Clear(dbModel.objectStoreName.calendarevent);
            localDBService.Clear(dbModel.objectStoreName.systemconfigurationkeys);
            localDBService.Clear(dbModel.objectStoreName.documents);
            localDBService.Clear(dbModel.objectStoreName.serviceclinicians);
        };

        var _insertBriefcase = function (results, action) {
            persistenceService.put('mobileDashboardId', dbModel.objectStoreName.dashboards, results.data.dashboards).then(function (dashboard) {
                commonServiceDB.SetHomeScreen(action, results.data.myPreference);
            });

            if (results.data.globalCodes)
                localDBService.Put(dbModel.objectStoreName.globalcodes, results.data.globalCodes);

            if (results.data.caseload) {
                var caseloads = commonService.ConvertArrayColumnToInteger($.parseJSON(results.data.caseload), ['clientId', 'phoneType', 'primaryProgramId', 'addressType']);
                localDBService.Put(dbModel.objectStoreName.caseload, caseloads);
            }

            if (results.data.myPreference) {
                var myPreference = results.data.myPreference;
                localDBService.Put(dbModel.objectStoreName.mypreference, myPreference, undefined, true);
            }
            if (results.data.teamCalendarStaff) {
                var teamCalendar = commonService.ConvertArrayColumnToInteger($.parseJSON(results.data.teamCalendarStaff), ['staffId']);
                localDBService.Put(dbModel.objectStoreName.teamcalendarstaff, teamCalendar);
            }
            if (results.data.events) {
                localDBService.Put(dbModel.objectStoreName.calendarevent, results.data.events);
            }

            if (results.data.serviceDropdownValues) {
                if (results.data.serviceDropdownValues.procedureCodes && results.data.serviceDropdownValues.procedureCodes.length > 0)
                    localDBService.Put(dbModel.objectStoreName.staffprocedurecodes, results.data.serviceDropdownValues.procedureCodes);

                if (results.data.serviceDropdownValues.programs && results.data.serviceDropdownValues.programs.length > 0)
                    localDBService.Put(dbModel.objectStoreName.staffprograms, results.data.serviceDropdownValues.programs);

                if (results.data.serviceDropdownValues.locations && results.data.serviceDropdownValues.locations.length > 0)
                    localDBService.Put(dbModel.objectStoreName.stafflocations, results.data.serviceDropdownValues.locations);

                if (results.data.serviceDropdownValues.serviceAttending && results.data.serviceDropdownValues.serviceAttending.length > 0)
                    localDBService.Put(dbModel.objectStoreName.serviceattending, results.data.serviceDropdownValues.serviceAttending);

                if (results.data.serviceDropdownValues.clinicians && results.data.serviceDropdownValues.clinicians.length > 0)
                    localDBService.Put(dbModel.objectStoreName.serviceclinicians, results.data.serviceDropdownValues.clinicians);
            }

            if (results.data.configurations) {
                localDBService.Put(dbModel.objectStoreName.systemconfigurationkeys, results.data.configurations);
            }
            if (results.data.clientDocuments) {
                localDBService.Put(dbModel.objectStoreName.documents, results.data.clientDocuments);
            }
        };

        var _updateBriefcaseInfo = function () {
            localStorageService.remove('briefcaseUpdatedOn');
            var updatedDate = $filter('date')(new Date(), 'MM/dd/yyyy hh:mm a');
            localStorageService.set('briefcaseUpdatedOn', updatedDate);
            briefcaseFactory.UpdatedOn = updatedDate;
            commonService.HideProcessing();
        };

        briefcaseFactory.GetBriefcaseData = _getBriefcaseData;
        briefcaseFactory.UpdateBriefcaseInfo = _updateBriefcaseInfo;

        return briefcaseFactory;
    }]);