function loginFromNativeApp(token, userName, smartKey, userNameDisplayAs, refreshToken, staffId, tokenIssuesOn, tokenExpiresOn, loginfromNativeApp) {
    var authData = {
        token: token,
        userName: userName,
        userNameDisplayAs: userNameDisplayAs,
        refreshToken: refreshToken,
        useRefreshTokens: true,
        privateKeyRequired: true,
        staffId: staffId,
        tokenIssuesOn: tokenIssuesOn,
        tokenExpiresOn: tokenExpiresOn,
        loginfromNativeApp: loginfromNativeApp,
        updatebriefcase: true,
        hideHeaderandFooter: true,
        encryptedToken: ''
    };
    var validateStatus = false;

    var loginData = {
        password: '',
        smartKey: smartKey,
        userName: userName
    };

    $.ajax({
        url: serviceBase + "api/Account/ValidateSmartKey",
        type: "POST",
        async: false,
        data: loginData,
        success: function (obj) {
            authData.encryptedToken = angular.element(document.body).injector().get('commonService').Encrypt(token, smartKey);
            authData.privateKeyRequired = false;

            var data = [];
            data.push(JSON.stringify(authData));
            localStorage.setItem('authorizationData', data);

            var DBOpenRequest = window.indexedDB.open(clientId, 1);

            DBOpenRequest.onsuccess = function (event) {
                db = DBOpenRequest.result;
                getCountofUnsavedChangeData(db, smartKey, authData.staffId);
            };

            validateStatus = true;
        },
        error: function (err) { validateStatus = false; }
    });

    return validateStatus;
}

function getCountofUnsavedChangeData(db, smartKey, staffId) {
    var transaction = db.transaction(["objectstorenames"], "readwrite");
    var objectStore = transaction.objectStore("objectstorenames");

    var countRequest = objectStore.count();
    countRequest.onsuccess = function () {
        if (countRequest.result === 0) {
            var briefcase = { 'update': true };
            localStorage.setItem('briefcase', JSON.stringify(briefcase));
            angular.element(document.body).injector().get('briefcaseService').GetBriefcaseData('login', smartKey);
        }
        else { angular.element(document.body).injector().get('syncService').AutoSyncFromNativeApp(); }
    };
}

function lockFromNativeApp() {
    location.href = location.origin + location.pathname + '#/login/UL';
}

function unlockFromNativeApp(smartkey) {
    var unlockResult = { unlocked: false, retriesRemaining: unlockretryCount };
    
    if (unlockretryCount > 0 && localStorage["ls.authorizationData"]) {
        var authData = JSON.parse(localStorage["ls.authorizationData"]);
        var encCaseload = JSON.parse(localStorage["ls.encrCaseload"]);

        var key = CryptoJS.enc.Base64.parse(smartkey);
        var iv = CryptoJS.enc.Base64.parse(smartkey);

        var encryptedToken = CryptoJS.AES.encrypt(authData.token, key, { iv: iv }).toString();

        key = CryptoJS.enc.Base64.parse(encryptedToken);
        iv = CryptoJS.enc.Base64.parse(encryptedToken);

        try {
            CryptoJS.AES.decrypt(encCaseload.Caseload, key, { iv: iv }).toString(CryptoJS.enc.Utf8);
            angular.element(document.body).injector().get('caseloadService').DecryptCaseload(smartkey);
            unlockResult.unlocked = true;
            unlockResult.retriesRemaining = unlockretryCount;
        }
        catch (e) {
            unlockretryCount = unlockretryCount - 1;
            unlockResult.unlocked = false;
            unlockResult.retriesRemaining = unlockretryCount;
            if (unlockretryCount == 0)
                wipeLocalDataFromNativeApp();
        }
    }
    return unlockResult;
}

function updateBriefcaseFromNativeApp(smartKey) {
    angular.element(document.body).injector().get('briefcaseService').GetBriefcaseData('login', smartKey);
}

function downloadTemplateFromNativeApp(staffId) {
    var loctn = window.location.origin + window.location.pathname;
    var queryString = '?StaffId=' + staffId;
    showProcessingFromNativeApp();
    $.ajax({
        url: loctn + '/utility/SmartCare.ashx' + queryString,
        type: 'GET',
        success: function () {
            if ('serviceWorker' in navigator) {
                var randomNum = Math.random();
                navigator.serviceWorker.register(window.location.origin + window.location.pathname + 'sw.js?rand=' + randomNum).then(function (registration) {
                    registration.update();
                    hideProcessingFromNativeApp();
                }).catch(function (error) {
                    hideProcessingFromNativeApp();
                    alert('Registration failed with ' + error);
                });
            }
        }
    });
}

function showProcessingFromNativeApp() {
    $("#divNavBarContainer a").unbind('click').bind('click', function () {
        return false;
    });

    $('#processingImage').show();
}

function hideProcessingFromNativeApp() {
    $('#processingImage').hide();
    $("#divNavBarContainer a").unbind('click');
}

function getCurrentUrlFromNativeApp() {
    return window.location.href;
}

var objCount = 0;
var objActualCount = 0;

function wipeLocalDataFromNativeApp() {
    var dbName = clientId;
    //Clear localstorage
    for (var key in localStorage) {
        delete localStorage[key];
    }
    //Clear indexedDB
    var dbObject;
    var DBOpenRequest = window.indexedDB.open(dbName, 1);

    DBOpenRequest.onerror = function (event) {
        console.log('Error loading database.');
    };

    DBOpenRequest.onsuccess = function (event) {
        var objList = event.target.result.objectStoreNames;
        dbObject = DBOpenRequest.result;

        objActualCount = objList.length;
        for (var objstore in objList) {
            if (objstore >= 0)
                clearData(clientId, objList[objstore], dbObject);
        }
    };
}

function clearData(clientId, objectStore, dbObject) {

    var transaction = dbObject.transaction([objectStore], "readwrite");

    transaction.oncomplete = function (event) {
        objCount++;

        if (objCount === objActualCount)
            location.href = location.origin + location.pathname + '#/login/LN';
    };

    transaction.onerror = function (event) {
        console.log('Transaction not opened due to error: ' + transaction.error);
    };

    // create an object store on the transaction
    var objectStr = transaction.objectStore(objectStore);

    // Make a request to clear all the data out of the object store
    var objectStoreRequest = objectStr.clear();

    objectStoreRequest.onsuccess = function (event) {
        console.log(event.target.source.name + ' is successfull');
    };
}