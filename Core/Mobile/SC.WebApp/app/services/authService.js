'use strict';

app.factory('authService', ['$http', '$q', 'localStorageService', 'ngAuthSettings', 'localDBService', 'dbModel', 'commonService', '$location', function ($http,
    $q, localStorageService, ngAuthSettings, localDBService, dbModel, commonService, $location) {

    var serviceBase = ngAuthSettings.apiServiceBaseUri;
    var authServiceFactory = {};

    var _authentication = {
        isAuth: false,
        userName: "",
        useRefreshTokens: true,
        privateKeyRequired: false,
        newTokenIssuedOn: new Date(),
        loginfromNativeApp: false,
        hideHeaderandFooter: true
    };

    var _externalAuthData = {
        provider: "",
        userName: "",
        externalAccessToken: ""
    };

    var _saveRegistration = function (registration) {
        _logOut();

        return $http.post(serviceBase + 'api/account/register', registration).then(function (response) {
            return response;
        });
    };

    var _login = function (loginData) {
        // 1. Validate the Username in the LocalStorage data.
        // 2. If exists, show the username as label and prompt to enter password. validate the encrypted password against indexedDB and authenticate. On 3 failed attempts, clear
        //    indexedDB.
        // 3. if not, promt to enter username and password (validate against server). If the user is logging first time, prompt to change the password. And authenticate and save
        //    the encrypted passwords against that user and fill the indexedDB/LocalStorage data.

        var data = "grant_type=password&username=" + loginData.userName + "&password=" + loginData.password;

        data = data += "&client_id=" + ngAuthSettings.clientId;


        var deferred = $q.defer();
        commonService.ShowProcessing();
        $http.post(serviceBase + 'token', data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
            localStorageService.set('authorizationData', { token: response.access_token, userName: loginData.userName, userNameDisplayAs: response.userNameDisplayAs, refreshToken: response.refresh_token, useRefreshTokens: true, privateKeyRequired: true, staffId: response.staffId, tokenIssuesOn: response[".issued"], tokenExpiresOn: response[".expires"], briefcase: true });
            _authentication.isAuth = true;
            _authentication.userName = loginData.userName;
            _authentication.userNameDisplayAs = response.userNameDisplayAs;
            _authentication.useRefreshTokens = true;
            _authentication.privateKeyRequired = true;
            _authentication.newTokenIssuedOn = new Date();
            deferred.resolve(response);
            commonService.HideProcessing();
        }).error(function (err, status) {
            _logOut();
            deferred.reject(err);
        });

        return deferred.promise;
    };

    var _relogin = function (loginData) {
        // 1. Validate the Username in the LocalStorage data.
        // 2. If exists, show the username as label and prompt to enter password. validate the encrypted password against indexedDB and authenticate. On 3 failed attempts, clear
        //    indexedDB.
        // 3. if not, promt to enter username and password (validate against server). If the user is logging first time, prompt to change the password. And authenticate and save
        //    the encrypted passwords against that user and fill the indexedDB/LocalStorage data.

        var data = "grant_type=password&username=" + loginData.userName + "&password=" + loginData.password + "&smartkey=" + loginData.smartkey;

        data = data += "&client_id=" + ngAuthSettings.clientId;


        var deferred = $q.defer();
        commonService.ShowProcessing();
        $http.post(serviceBase + 'token', data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
            //var key = CryptoJS.enc.Hex.parse(loginData.smartkey);
            //var iv = CryptoJS.enc.Hex.parse(loginData.smartkey);

            localStorageService.set('authorizationData', {
                token: response.access_token,
                userName: loginData.userName,
                userNameDisplayAs: response.userNameDisplayAs,
                refreshToken: response.refresh_token,
                useRefreshTokens: true,
                privateKeyRequired: false,
                staffId: response.staffId,
                tokenIssuesOn: response[".issued"],
                tokenExpiresOn: response[".expires"],
                encryptedToken: commonService.Encrypt(response.access_token, loginData.smartkey)
            });

            _authentication.isAuth = true;
            _authentication.userName = loginData.userName;
            _authentication.userNameDisplayAs = response.userNameDisplayAs;
            _authentication.useRefreshTokens = true;
            _authentication.privateKeyRequired = false;
            _authentication.newTokenIssuedOn = new Date();
            deferred.resolve(response);
            commonService.HideProcessing();
        }).error(function (err, status) {
            commonService.HideProcessing();
            deferred.reject(err);
        });

        return deferred.promise;
    };

    var _logOut = function () {

        localDBService.Open(dbModel).then(function () {
            localDBService.ClearAllData(dbModel.name);
            _clearAllLocalStorage();
        });
        //$window.location.reload();
        commonService.HideProcessing();
        //localDBService.Open(dbModel).then(function () {
        //    localDBService.ClearAllData(dbModel.name);
        //});       
        _authentication.isAuth = false;
        _authentication.userName = "";
        _authentication.useRefreshTokens = false;
    };

    var _fillAuthData = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            _authentication.isAuth = true;
            _authentication.userName = authData.userName;
            _authentication.useRefreshTokens = authData.useRefreshTokens;
        }
    };

    var _refreshToken = function () {

        var deferred = $q.defer();

        var authData = localStorageService.get('authorizationData');

        if (authData) {

            if (authData.useRefreshTokens) {
                var data = "grant_type=refresh_token&refresh_token=" + authData.refreshToken + "&client_id=" + ngAuthSettings.clientId;

                localStorageService.remove("authorizationData");

                $http.post(serviceBase + 'token', data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
                    _authentication.newTokenIssuedOn = new Date();
                    deferred.resolve(response);

                }).error(function (err, status) {
                    _logOut();
                    deferred.reject(err);
                });

            }
        }

        return deferred.promise;
    };

    var _obtainAccessToken = function (externalData) {

        var deferred = $q.defer();

        $http.get(serviceBase + 'api/account/ObtainLocalAccessToken', { params: { provider: externalData.provider, externalAccessToken: externalData.externalAccessToken } }).success(function (response) {

            localStorageService.set('authorizationData', { token: response.access_token, userName: response.userName, refreshToken: "", useRefreshTokens: false });

            _authentication.isAuth = true;
            _authentication.userName = response.userName;
            _authentication.useRefreshTokens = false;

            deferred.resolve(response);

        }).error(function (err, status) {
            _logOut();
            deferred.reject(err);
        });

        return deferred.promise;

    };

    var _registerExternal = function (registerExternalData) {

        var deferred = $q.defer();

        $http.post(serviceBase + 'api/account/registerexternal', registerExternalData).success(function (response) {

            localStorageService.set('authorizationData', { token: response.access_token, userName: response.userName, refreshToken: "", useRefreshTokens: false });

            _authentication.isAuth = true;
            _authentication.userName = response.userName;
            _authentication.useRefreshTokens = false;

            deferred.resolve(response);

        }).error(function (err, status) {
            _logOut();
            deferred.reject(err);
        });

        return deferred.promise;

    };

    var _getprivateKeyRequired = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            return authData.privateKeyRequired;
        }
    };

    var _setprivateKeyRequired = function (privatekeyrequired) {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            authData.privateKeyRequired = privatekeyrequired;
            if (privatekeyrequired && $location.$$path.indexOf('/login') == -1)
                authData.urlbeforelock = $location.$$path;
            localStorageService.set('authorizationData', authData);
        }
    };

    var _getLoginActionType = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData && authData.LoginActionType) {
            return authData.LoginActionType;
        }
    };

    var _setLoginActionType = function (loginActionType) {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            authData.LoginActionType = loginActionType;
            if (authData.loginfromNativeApp == true) {
                if (loginActionType == "LN")
                    authServiceFactory.authentication.hideHeaderandFooter = true;
            }
            else
                authServiceFactory.authentication.hideHeaderandFooter = false;
            localStorageService.set('authorizationData', authData);
        }
    };

    var _validateSmartKey = function (loginData) {
        var deferred = $q.defer();
        $http.post(serviceBase + 'api/Account/ValidateSmartKey', loginData).success(function (response) {
            deferred.resolve(response);
        }).error(function (err, status) {
            //_logOut();
            deferred.reject(err);
        });

        return deferred.promise;
    };

    var _clearAllLocalStorage = function () {
        for (var key in localStorage) {
            delete localStorage[key];
        }
    };

    var _getCurrentStaffId = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData && authData.staffId)
            return parseInt(authData.staffId);
        else return 0;
    };

    var _getHideHeaderandFooter = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData && authData.hideHeaderandFooter)
            return authData.hideHeaderandFooter;
    };
    var _setmobileoffliecheck = function () {
        commonService.GetSystemConfigurationKeyValue('SETMOBILEOFFLINECHECKINMILLISECONDS').then(function (value) {
            if (value) {
                setTimeout(function retry() {
                    
                    authServiceFactory.authentication.newTokenIssuedOn = new Date();
                    Offline.check();
                    setTimeout(retry, Number(value));
                }, Number(value));
            }
        });
    };

    authServiceFactory.saveRegistration = _saveRegistration;
    authServiceFactory.login = _login;
    authServiceFactory.relogin = _relogin;
    authServiceFactory.logOut = _logOut;
    authServiceFactory.fillAuthData = _fillAuthData;
    authServiceFactory.authentication = _authentication;
    authServiceFactory.refreshToken = _refreshToken;

    authServiceFactory.obtainAccessToken = _obtainAccessToken;
    authServiceFactory.externalAuthData = _externalAuthData;
    authServiceFactory.registerExternal = _registerExternal;
    authServiceFactory.getprivatekeyrequired = _getprivateKeyRequired;
    authServiceFactory.setprivatekeyrequired = _setprivateKeyRequired;
    authServiceFactory.validateSmartKey = _validateSmartKey;
    authServiceFactory.clearLocalStorageData = _clearAllLocalStorage;
    authServiceFactory.GetCurrentStaffId = _getCurrentStaffId;
    authServiceFactory.ShowClientContent = false;
    authServiceFactory.GetLoginActionType = _getLoginActionType;
    authServiceFactory.SetLoginActionType = _setLoginActionType;
    authServiceFactory.GetHideHeaderandFooter = _getHideHeaderandFooter;
    authServiceFactory.SetMobileOfflieCheck = _setmobileoffliecheck;

    return authServiceFactory;
}]);