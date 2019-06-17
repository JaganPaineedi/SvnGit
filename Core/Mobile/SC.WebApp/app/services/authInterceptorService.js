'use strict';
app.factory('authInterceptorService', ['$q', '$injector', '$location', 'localStorageService', function ($q, $injector, $location, localStorageService) {
    var authInterceptorServiceFactory = {};
    var _request = function (config) {
        config.headers = config.headers || {};
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            if (config.url.indexOf('/token') < 0)// don't send Bearer token on new token request
                config.headers.Authorization = 'Bearer ' + authData.token;
        }

        return config;
    };

    var _responseError = function (rejection) {
        if (rejection.status === 401) {
            var authService = $injector.get('authService');
            var authData = localStorageService.get('authorizationData');

            if (authData) {
                if (authData.useRefreshTokens) {
                    if (!authData.loginfromNativeApp)
                        $location.path('/refresh');
                    return $q.reject(rejection);
                }
            }

            authService.logOut();
            $location.path('/login/LN');
        }
        return $q.reject(rejection);
    };

    authInterceptorServiceFactory.request = _request;
    authInterceptorServiceFactory.responseError = _responseError;

    return authInterceptorServiceFactory;
}]);