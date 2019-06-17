'use factory';

app.factory('caseloadService', ['localStorageService', 'commonService', 'localDBService', 'dbModel', '$location','Idle',
    function (localStorageService, commonService, localDBService, dbModel, $location, Idle) {

        var caseloadServiceFactory = {};

        var _getLocalStorageData = function (lsname) {
            return localStorageService.get(lsname);
        };

        var _setLocalStorageData = function (lsname) {
            return localStorageService(lsname);
        };

        var _decryptCaseload = function (smartkey) {

            var authData = localStorageService.get('authorizationData');
            var encrCaseload = localStorageService.get('encrCaseload');
            try {
               
                if (authData.encryptedToken == '') {
                    authData.encryptedToken = commonService.Encrypt(authData.token, smartkey);
                    authData.privateKeyRequired = false;
                    
                    if (encrCaseload) {
                        var decryptedcaseload = commonService.Decrypt(encrCaseload.Caseload, authData.encryptedToken);
                        localStorageService.set('authorizationData', authData); // This will be set only of the decryption is successfull.
                        var caseloads = commonService.ConvertArrayColumnToInteger($.parseJSON(decryptedcaseload), ['clientId', 'phoneType', 'primaryProgramId', 'addressType']);

                        localDBService.Open(dbModel).then(function () {
                            localDBService.Put(dbModel.objectStoreName.caseload, caseloads).then(function () {
                                if (authData.urlbeforelock && authData.urlbeforelock.indexOf('/login') == -1) { $location.path(authData.urlbeforelock); }
                                else $location.path('/');
                                //authData.urlbeforelock = undefined;
                                authData.LoginActionType = "";
                                localStorageService.set('authorizationData', authData);
                                if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                                    Idle.watch();
                            });
                        });
                    }
                    else {
                        var decryptedToken = commonService.Decrypt(authData.encryptedToken, smartkey);
                        if (authData.urlbeforelock && authData.urlbeforelock.indexOf('/login') == -1) { $location.path(authData.urlbeforelock); }
                        else $location.path('/');
                        authData.urlbeforelock = undefined;
                        localStorageService.set('authorizationData', authData);
                        if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true)
                            Idle.watch();
                    }
                }
            }
            catch (e) {
                return false;
            }
        }

        caseloadServiceFactory.GetLocalStorageData = _getLocalStorageData;
        caseloadServiceFactory.DecryptCaseload = _decryptCaseload;

        return caseloadServiceFactory;
    }]);