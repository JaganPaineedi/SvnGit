window.indexedDB = window.indexedDB ||
    window.mozIndexedDB ||
    window.webkitIndexedDB ||
    window.msIndexedDB ||
    window.shimIndexedDB;

window.IDBTransaction = window.IDBTransaction ||
    window.webkitIDBTransaction ||
    window.msIDBTransaction;

window.IDBKeyRange = window.IDBKeyRange ||
    window.webkitIDBKeyRange ||
    window.msIDBKeyRange;


var app = angular.module('SmartCare', ['ngRoute', 'LocalStorageModule', 'ngIdle', 'ui.bootstrap', 'ui-notification', 'signature'])

    .filter('replaceDot', function () {
        return function (text) {
            if (!text) {
                return text;
            }

            return text.replace(/\./g, 'dot') // Replaces all occurences
        };
    }).directive('convertNumber', function () {// Convert to Integer
        return {
            require: 'ngModel',
            link: function (scope, el, attr, ctrl) {
                ctrl.$parsers.push(function (value) {
                    return parseInt(value, 10);
                });

                ctrl.$formatters.push(function (value) {
                    if (value)
                        return value.toString();
                    else
                        return "0";
                });
            }
        }
    });
var serviceBase = "http://localhost:52960/";
var virtualDirectoryURL = "";
var unlockretryCount = 4;
var clientId = "SmartCare";

app.config(function ($routeProvider) {
    $routeProvider.when('/dashboard', {
        controller: "dashboardController",
        templateUrl: virtualDirectoryURL + "/app/views/dashboard.html"
    });

    $routeProvider.when('/login', {
        controller: "loginController",
        templateUrl: virtualDirectoryURL + "/app/views/login.html"
    });

    $routeProvider.when('/login/:type', {
        controller: "loginController",
        templateUrl: virtualDirectoryURL + "/app/views/login.html"
    });

    $routeProvider.when("/caseloads", {
        controller: "caseloadController",
        templateUrl: virtualDirectoryURL + "/app/views/caseloads.html"
    });

    $routeProvider.when("/caseloads/:id", {
        controller: 'caseloaddetailController',
        templateUrl: virtualDirectoryURL + '/app/views/caseloaddetails.html'
    });

    $routeProvider.when("/", {
        controller: "dashboardController",
        templateUrl: virtualDirectoryURL + "/app/views/dashboard.html"
    });

    $routeProvider.when("/createservice", {
        templateUrl: virtualDirectoryURL + "/app/views/createservice.html"
    });

    $routeProvider.when("/createservice/:clientId", {
        templateUrl: virtualDirectoryURL + "/app/views/createservice.html"
    });

    $routeProvider.when("/service/:serviceId", {
        templateUrl: virtualDirectoryURL + "/app/views/createservice.html"
    });

    $routeProvider.when("/mycalendar", {
        controller: "myCalendarController",
        templateUrl: virtualDirectoryURL + "/app/views/mycalendar.html"
    });

    $routeProvider.when("/teamcalendar", {
        controller: "teamCalendarController",
        templateUrl: virtualDirectoryURL + "/app/views/teamcalendar.html"
    });

    $routeProvider.when("/mypreferences", {
        controller: "myPreferencesController",
        templateUrl: virtualDirectoryURL + "/app/views/mypreferences.html"
    });

    $routeProvider.when("/sync", {
        controller: "syncController",
        templateUrl: virtualDirectoryURL + "/app/views/sync.html"
    });

    $routeProvider.when("/refresh", {
        controller: "refreshController",
        templateUrl: virtualDirectoryURL + "/app/views/refresh.html"
    });

    $routeProvider.when("/documents/:clientId", {
        controller: "documentsController",
        templateUrl: virtualDirectoryURL + "/app/views/documentlist.html"
    });

    $routeProvider.when("/document/:documentVersionId", {
        controller: "documentController",
        templateUrl: virtualDirectoryURL + "/app/views/document.html"
    });

    $routeProvider.when("/document/:documentVersionId", {
        controller: "documentController",
        templateUrl: virtualDirectoryURL + "/app/views/document.html"
    });

    //$routeProvider.otherwise({ redirectTo: "/login" });
});


app.constant('ngAuthSettings', {
    apiServiceBaseUri: serviceBase,
    clientId: clientId,
    indexedDB: window.indexedDB,
    //Offline: window.Offline,
    virtualDirectoryURL: virtualDirectoryURL,
    unlockRetryCount: unlockretryCount
});

app.config(['$httpProvider', '$provide', '$compileProvider', function ($httpProvider, $provide, $compileProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https|http|tel|geo):/);
    $httpProvider.interceptors.push('authInterceptorService');
    $provide.value('dbModel', {
        name: clientId,
        version: '1',
        instance: {},
        objectStoreName: {
            dashboards: 'dashboards',
            caseload: 'caseload',
            globalcodes: 'globalcodes',
            mypreference: 'mypreference',
            teamcalendarstaff: 'teamcalendarstaff',
            staffprocedurecodes: 'staffprocedurecodes',
            staffprograms: 'staffprograms',
            stafflocations: 'stafflocations',
            serviceattending: 'serviceattending',
            objectstorenames: 'objectstorenames',
            calendarevent: 'calendarevent',
            systemconfigurationkeys: 'systemconfigurationkeys',
            errorlog: 'errorlog',
            documents: 'documents',
            serviceclinicians: 'serviceclinicians'
        },
        upgrade: function (e) {
            var db = e.target.result;
            if (!db.objectStoreNames.contains('objectstorenames')) {
                db.createObjectStore('objectstorenames', {
                    keyPath: 'id' //keyPath: ['id', 'objectstorename']
                });
            }
            if (!db.objectStoreNames.contains('dashboards')) {
                db.createObjectStore('dashboards', {
                    keyPath: 'mobileDashboardId'
                });
            }
            if (!db.objectStoreNames.contains('caseload')) {
                db.createObjectStore('caseload', {
                    keyPath: 'clientId'
                });
            }
            if (!db.objectStoreNames.contains('globalcodes')) {
                db.createObjectStore('globalcodes', {
                    keyPath: 'globalCodeId'
                });
            }
            if (!db.objectStoreNames.contains('mypreference')) {
                db.createObjectStore('mypreference', {
                    keyPath: 'staffPreferenceId'
                });
            }
            if (!db.objectStoreNames.contains('teamcalendarstaff')) {
                db.createObjectStore('teamcalendarstaff', {
                    keyPath: 'staffId'
                });
            }
            if (!db.objectStoreNames.contains('staffprocedurecodes')) {
                db.createObjectStore('staffprocedurecodes', {
                    keyPath: 'procedureCodeId'
                });
            }
            if (!db.objectStoreNames.contains('staffprograms')) {
                db.createObjectStore('staffprograms', {
                    keyPath: 'programId'
                });
            }
            if (!db.objectStoreNames.contains('stafflocations')) {
                db.createObjectStore('stafflocations', {
                    keyPath: 'locationId'
                });
            }
            if (!db.objectStoreNames.contains('serviceattending')) {
                db.createObjectStore('serviceattending', {
                    keyPath: 'staffId'
                });
            }
            if (!db.objectStoreNames.contains('calendarevent')) {
                db.createObjectStore('calendarevent', {
                    keyPath: 'appointmentId'
                });
            }
            if (!db.objectStoreNames.contains('customServices')) {
                db.createObjectStore('customServices', {
                    keyPath: 'serviceId'
                });
            }
            if (!db.objectStoreNames.contains('systemconfigurationkeys')) {
                db.createObjectStore('systemconfigurationkeys', {
                    keyPath: 'key'
                });
            }
            if (!db.objectStoreNames.contains('errorlog')) {
                db.createObjectStore('errorlog', {
                    keyPath: 'errorLogId'
                });
            }
            if (!db.objectStoreNames.contains('documents')) {
                db.createObjectStore('documents', {
                    keyPath: 'documentVersionId'
                });
            }
            if (!db.objectStoreNames.contains('serviceclinicians')) {
                db.createObjectStore('serviceclinicians', {
                    keyPath: 'staffProgramId'
                });
            }
        }
    });

    function getObjectStore(store_name, mode, db) {
        var tx = db.transaction(store_name, mode);
        return tx.objectStore(store_name);
    }

    $provide.decorator('$exceptionHandler', ['$delegate', '$window', 'stacktraceService', 'dbModel',
        function ($delegate, $window, stacktraceService, dbModel) {
            return function (exception, cause) {
                $delegate(exception, cause);
                var stacktrace = stacktraceService.print({ e: exception });

                var clientSideErrorInfo = {
                    errorLogId: Math.floor((Math.random() * 1000) + 1),
                    errorMessage: exception.message,
                    dataSetInfo: $window.location.href,
                    verboseInfo: stacktrace.join('\n'),
                    errorType: 'MobileWeb'
                };
                console.log(clientSideErrorInfo);

                if (Offline.state === 'down') {
                    var db;
                    var request = indexedDB.open(clientId);
                    request.onupgradeneeded = dbModel.upgrade;

                    request.onerror = function (event) {
                        alert("Opening IndexedDb is failed !!!");
                    };
                    request.onsuccess = function (event) {
                        db = event.target.result;
                        var store = getObjectStore('errorlog', 'readwrite', db);

                        var req = store.add(clientSideErrorInfo);

                        req.onsuccess = function (evt) {
                            console.log("Insertion in DB successful");
                        };
                        req.onerror = function () {
                            console.error("Insertion in DB failed", this.error);
                        };
                    };
                }
                else {
                    var queryString = '?StaffId=0';
                    var authData = localStorage.getItem('authorizationData');
                    if (authData && authData.staffId) {
                        queryString = '?StaffId=' + authData.staffId;
                    }
                    $.ajax({
                        type: "POST",
                        url: serviceBase + "api/ErrorLog" + queryString,
                        data: clientSideErrorInfo,
                        success: function (result) { console.log('ErrorLog insert successfull!'); },
                        error: function (err) { console.log('ErrorLog insert failed!'); }
                    });
                }
            };

        }]);
}]);

app.config(function (IdleProvider, KeepaliveProvider) {
    IdleProvider.idle(30);
    IdleProvider.timeout(30);
    KeepaliveProvider.interval(30);
});

app.run(['authService', '$rootScope', 'localStorageService', 'Idle', '$route', '$location', 'localDBService', 'commonService', function (authService, $rootScope, localStorageService, Idle, $route, $location, localDBService, commonService) {
    authService.fillAuthData();
    //moved Sync and DB localstorage to Login Cotntroller

    $rootScope.$watch(function detectIdle() {
        $rootScope.$on('IdleTimeout', function () {
            authService.setprivatekeyrequired(true);
            //localDBService.Clear('caseload');
            $route.reload();
        });
    });

    var history = [];

    $rootScope.$on('$routeChangeSuccess', function () {
        history.push($location.$$path);
        if ($location.$$path.indexOf("/login") > -1 || $location.$$path === "/refresh" || $location.$$path === "/") {
            $rootScope.hideClose = true;
            if ($location.$$path === "/") {
                var authData = localStorageService.get('authorizationData');
                if (authData)
                    authData.urlbeforelock = $location.$$path;
                localStorageService.set('authorizationData', authData);
            }
        }
        else {
            var authData = localStorageService.get('authorizationData');
            if (authData)
                authData.urlbeforelock = $location.$$path;
            localStorageService.set('authorizationData', authData);
            $rootScope.hideClose = false;
        }

        var id, action = '';

        var parts = $location.absUrl().split('/');
        if ($.isNumeric(parts[parts.length - 1])) {
            action = parts[parts.length - 2]
            id = Number(parts[parts.length - 1]);
            if (action === 'caseloads' && id > 0)
                authService.ShowClientContent = true;
            else
                authService.ShowClientContent = false;
        }
        else authService.ShowClientContent = false;
    });

    $rootScope.back = function () {
        if (history.length > 1) {
            var prevUrl = history.length > 1 ? history.splice(-2)[0] : "/";
            if (prevUrl.indexOf("/login") == -1) {
                $location.path(prevUrl);
                $rootScope.hideClose = false;
            }
        }
    };
    if (commonService.GetLocalStorageData('authorizationData', 'loginfromNativeApp') !== true) {
        Idle.watch();
    }

}]);

window.addEventListener('load', function () {
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('./sw.js')
            .then(waitUntilInstalled)
            .catch(function (error) {
                console.log('ServiceWorker caching failed: ', error);
            });
    } else {
        console.log('ServiceWorker registration failed: ', err);
    }
});

function waitUntilInstalled(registration) {
    return new Promise(function (resolve, reject) {
        if (registration.installing) {
            // If the current registration represents the "installing" service worker, then wait
            // until the installation step (during which the resources are pre-fetched) completes
            // to display the file list.
            registration.installing.addEventListener('statechange', function (e) {
                if (e.target.state == 'installed') {
                    resolve();
                } else if (e.target.state == 'redundant') {
                    reject();
                }
            });
        } else {
            // Otherwise, if this isn't the "installing" service worker, then installation must have been
            // completed during a previous visit to this page, and the resources are already pre-fetched.
            // So we can show the list of files right away.
            resolve();
        }
    });
}