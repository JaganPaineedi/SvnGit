'use strict';

app.factory('commonService', ['$q', 'dbModel', 'localDBService', 'localStorageService', 'Notification',
function ($q, dbModel, localDBService, localStorageService, Notification) {

    var commonFactory = {};
    
    var _showHomeButton = true;

    var _getGlobalCodes = function (categoryName, result) {
        var globalCodes = $.grep(result, function (globalcode, index) {
            return (globalcode.category.trim() === categoryName);
        });
        return globalCodes;
    };

    var _getGlobalCodesOnId = function (id, result) {
        var globalCodes = $.grep(result, function (globalcode, index) {
            return (globalcode.globalCodeId.trim() === id);
        });
        return globalCodes;
    };

    var _showtostMessage = function (message, type, delay) {
        Notification.clearAll()
        var notificationOptions = {
            message: '<ul><li>' + message + '</li></ul>',
            delay: delay
        };

        Notification(notificationOptions, type);
    };

    var _isIOS = function () {
        var ag = navigator.userAgent || navigator.vendor || window.opera;
        if (ag.match(/iPad/i) || ag.match(/iPhone/i) || ag.match(/iPod/i)) {
            return true;
        }
        else {
            return false;
        }
    };

    var _isAndroid = function () {
        var ag = navigator.userAgent || navigator.vendor || window.opera;
        if (ag.match(/Android/i)) {
            return 'Android';
        }
        else {
            return false;
        }
    };

    var _showProcessing = function () {
        // This is to restrict the nav actions on processing.
        $("#divNavBarContainer a").unbind('click').bind('click', function () {
            return false;
        });

        $('#processingImage').show();
    };

    var _hideProcessing = function () {
        $('#processingImage').hide();
        $("#divNavBarContainer a").unbind('click');
    };

    var _initializeControls = function (parentControl) {
        //Added dp.show event to show the widget on parent control.
        if (typeof parentControl === 'string') {
            parentControl = $('#' + parentControl);
        }

        if (parentControl) {
            $('input[datatype=date]', parentControl).datetimepicker({ format: 'DD/MM/YYYY', showClose: true }).on("dp.show", function (f) {
                _setCalendarWidgetPosition(f);
            });

            $('input[datatype=time]', parentControl).datetimepicker({ format: 'hh:mm A', showClose: true }).on("dp.show", function (f) {
                _setCalendarWidgetPosition(f);
            });

            $('input[datatype=datetime]', parentControl).datetimepicker({ showClose: true }).on("dp.show", function (f) {
                _setCalendarWidgetPosition(f);
            });
        }
    };

    var _setCalendarWidgetPosition = function (f) {
        var widget = $('div.bootstrap-datetimepicker-widget');
        var component = false;
        var element = $('#' + f.currentTarget.id);
        var position = (component || element).position(),
                offset = (component || element).offset(),
                parent;
        var vertical = 'auto';
        var horizontal = 'auto';
        parent = element;
        element.children().first().after(widget);

        // Left and right logic
        if (horizontal === 'auto') {
            if (parent.width() < offset.left + widget.outerWidth() / 2 &&
                offset.left + widget.outerWidth() > $(window).width()) {
                horizontal = 'right';
            } else {
                horizontal = 'left';
            }
        }
        if (vertical === 'top') {
            widget.addClass('top').removeClass('bottom');
        } else {
            widget.addClass('bottom').removeClass('top');
        }
        if (horizontal === 'right') {
            widget.addClass('pull-right');
        } else {
            widget.removeClass('pull-right');
        }
        if (parent.css('position') !== 'relative') {
            parent = parent.parents().filter(function () {
                return $(this).css('position') === 'relative';
            }).first();
        }

        widget.css({
            top: vertical === 'top' ? 'auto' : position.top + element.outerHeight(),
            bottom: vertical === 'top' ? position.top + element.outerHeight() : 'auto',
            left: horizontal === 'left' ? (parent === element ? 0 : position.left) : 'auto',
            right: horizontal === 'left' ? 'auto' : parent.outerWidth() - element.outerWidth() - (parent === element ? 0 : position.left)
        });
    };

    var _calculateDuration = function (startDate, endDate, durationAs) {
        if (startDate && endDate) {
            var sDate = moment(startDate);
            var eDate = moment(endDate);
            var duration = eDate.diff(sDate, durationAs);
            return duration;
        }
    };

    var _convertToInteger = function (obj, colList) {
        for (var i = 0; i < colList.length; i++) {
            if (obj[colList[i]])
                obj[colList[i]] = obj[colList[i]] * 1;
        }
        return obj;
    };

    var _convertArrayColumnsToInteger = function (obj, colList) {
        for (var j = 0; j < obj.length; j++) {
            for (var i = 0; i < colList.length; i++) {
                if (obj[j][colList[i]])
                    obj[j][colList[i]] = obj[j][colList[i]] * 1;
            }
        }

        return obj;
    };

    var _getMyPreferenceValue = function (key) {
        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (myPreferenceresult) {
                return myPreferenceresult[0][key];
            },
                function (error) {
                    $scope.error = error;
                });
        });
    };

    var _manageToolBar = function (toolbarIcon, hide) {
        for (var i = 0; i < toolbarIcon.length; i++) {
            if (hide)
                $('#' + toolbarIcon[i]).hide();
            else
                $('#' + toolbarIcon[i]).show();
        }
    };

    var _getLocalStorageData = function (storageName, keyName) {
        var storageData = localStorageService.get(storageName);
        if (storageData) {
            return storageData[keyName];
        }
    };

    var _setLocalStorageData = function (storageName, keyName, keyValue) {
        var storageData = localStorageService.get(storageName);
        if (storageData) {
            storageData[keyName] = keyValue;
            localStorageService.set(storageName, storageData);
        }
    };

    var _incrementLocalChangesCount = function () {
        var syncData = localStorageService.get('syncData');
        if (syncData) {
            commonFactory.hasLocalChanges = syncData.hasLocalChanges = true;
            syncData.localChangesCount = syncData.localChangesCount * 1 + 1;
            if (syncData.localChangesCount < 0)
                syncData.localChangesCount = 1;
            commonFactory.localChangesCount = syncData.localChangesCount;
            localStorageService.set('syncData', syncData);
        }
    };

    var _decrementLocalChangesCount = function () {
        var syncData = localStorageService.get('syncData');
        if (syncData) {
            commonFactory.localChangesCount = syncData.localChangesCount = syncData.localChangesCount * 1 - 1;
            if (commonFactory.localChangesCount > 0)
                commonFactory.hasLocalChanges = syncData.hasLocalChanges = true;
            else
                commonFactory.hasLocalChanges = syncData.hasLocalChanges = false;
            localStorageService.set('syncData', syncData);
        }
    };

    var _updateLocalChangesCount = function () {
        var syncData = localStorageService.get('syncData');
        if (syncData) {
            localDBService.GetAll(dbModel.objectStoreName.objectstorenames).then(function (results) {
                var res = $.grep(results, function (item, index) { return !item.hasNotification; });
                if (res.length > 0) {
                    commonFactory.hasLocalChanges = syncData.hasLocalChanges = true;
                    syncData.localChangesCount = commonFactory.localChangesCount = res.length;
                    localStorageService.set('syncData', syncData);
                }
                else {
                    commonFactory.hasLocalChanges = syncData.hasLocalChanges = false;
                    syncData.localChangesCount = commonFactory.localChangesCount = 0;
                    localStorageService.set('syncData', syncData);
                    localStorageService.remove('syncing');
                }
            });

            //localDBService.GetCount(dbModel.objectStoreName.objectstorenames).then(function (result) {
            //    if (result >= 0) {
            //        commonFactory.hasLocalChanges = syncData.hasLocalChanges = true;
            //        syncData.localChangesCount = commonFactory.localChangesCount = result;
            //        localStorageService.set('syncData', syncData);
            //        if (result == 0)
            //            localStorageService.remove('syncing');
            //    }
            //});
        }
    };

    var _showMessageBox = function (title, message, cancelButtonText, mainButtonText) {
        var options = {
            show: true
        };
        var $model = $('#scModal');
        if (title)
            $('#scModalLabel', $model).text(title)
        if (message)
            $('#scModelContent', $model).text(message)

        $model.modal(options);
    };

    var _insertObjectStoreNameToSync = function (objectStoreName, primaryKey, model) {
        localDBService.Open(localPersistenceStrategyFactory.dbModel).then(function (e) {
            var id = model[primaryKey];
            localPersistenceStrategyFactory.exists(id, objectStoreName, primaryKey).then(function (doesExist) {
                if (!doesExist) {
                    localDBService.Insert(objectStoreName, model, primaryKey)
                        .then(deferred.resolve,
                            deferred.reject);
                }

            }, deferred.reject);

        }, deferred.reject);
    };

    var _incrementDataVersionCount = function () {
        var _dbInfo = localStorageService.get('db');
        _dbInfo['version'] = _dbInfo['version'] + 1;
        localStorageService.set('db', _dbInfo);

        return _dbInfo['version'];
    };

    var _decrementDataVersionCount = function () {
        var _dbInfo = localStorageService.get('db');
        _dbInfo['version'] = _dbInfo['version'] - 1;
        localStorageService.set('db', _dbInfo);

        return _dbInfo['version'];
    };

    var _formatDateMMDDYYYY = function (date) {
        var year = date.getFullYear();
        var month = (1 + date.getMonth()).toString();
        month = month.length > 1 ? month : '0' + month;
        var day = date.getDate().toString();
        day = day.length > 1 ? day : '0' + day;
        return month + '/' + day + '/' + year;
    };

    var _encrypt = function (data, smartkey) {
        var key = CryptoJS.enc.Base64.parse(smartkey);
        var iv = CryptoJS.enc.Base64.parse(smartkey);

        return CryptoJS.AES.encrypt(data, key, { iv: iv }).toString();
    };

    var _decrypt = function (data, smartkey) {
        var key = CryptoJS.enc.Base64.parse(smartkey);
        var iv = CryptoJS.enc.Base64.parse(smartkey);

        return CryptoJS.AES.decrypt(data, key, { iv: iv }).toString(CryptoJS.enc.Utf8);
    };

    var _getSystemConfigurationKeyValue = function (key) {
        var deferred = $q.defer();

        localDBService.Open(dbModel).then(function () {
            localDBService.GetbyId(dbModel.objectStoreName.systemconfigurationkeys, key).then(function (result) {
                result = result.target.result;
                if (result && result['value']) {
                    deferred.resolve(result['value']);
                }
            });
        });
        return deferred.promise;
    };

    var _getMobileOperatingSystem = function () {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;

        // Windows Phone must come first because its UA also contains "Android"
        if (/windows phone/i.test(userAgent)) {
            return "Windows Phone";
        }
        if (/android/i.test(userAgent)) {
            return "Android";
        }
        // iOS detection from: http://stackoverflow.com/a/9039885/177710
        if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
            return "iOS";
        }
        return "unknown";
    };

    var _RegExISO8601 = function (valueIn) {
        var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
            "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
            "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
        return valueIn.match(new RegExp(regexp));
    };

    var _ISO8601Time = function (isoDateTimIn) {
        function pad(n) {
            n = parseInt(n, 10);
            return n < 10 ? '0' + n : n
        }
        if (isoDateTimIn !== null && isoDateTimIn !== undefined) {
            var d = _RegExISO8601(isoDateTimIn);
            if (d !== null && d !== undefined) {
                if (d[7] >= 13 && d[7] <= 23) {
                    return pad((d[7] - 12)) + ':' + d[8] + ' PM'; //added space before PM/AM for cross browser
                    //Code modified by Veena on 10/12/15 for WMU Support Go Live #20
                } else if (d[7] == 12) {
                    return '12:' + d[8] + ' PM';
                } else if (d[7] == 0) {
                    return '12:' + d[8] + ' AM';
                }
                else {
                    return pad(d[7]) + ':' + d[8] + ' AM';
                }
            } else {
                return "";
            }
        } else {
            return "";
        }
    };

    var _ISO8601Date = function (isoDateTimIn) {
        if (isoDateTimIn !== null && isoDateTimIn !== undefined) {
            var d = _RegExISO8601(isoDateTimIn);
            if (d !== null && d !== undefined) {
                return d[3] + '/' + d[5] + '/' + d[1];
            } else {
                return "";
            }
        } else {
            return "";
        }
    };

    var _ISO8601DateTime = function (isoDateTimIn) {
        return _ISO8601Date(isoDateTimIn) + " " + _ISO8601Time(isoDateTimIn);
    };

    var encodeText = function (TextToEncode) {
        if (!TextToEncode) return "";

        var _textToEncode = "";
        if (typeof TextToEncode == "object") {
            _textToEncode = String(TextToEncode);
        }
        else {
            _textToEncode = TextToEncode;
        }
        if (_textToEncode != "" && _textToEncode != undefined && _textToEncode != null && _textToEncode != 'undefined' && $.trim(_textToEncode) != "") {
            return escape(_textToEncode)
                .replace(/\?/g, "%3F")
                .replace(/=/g, "%3D")
                .replace(/&/g, "%26")
                .replace(/@/g, "%40")
                .replace(/\+/g, "%2B")
                .replace(/&/g, "%26")
                .replace(/,/g, "%2C")
                .replace(/:/g, "%3A")
                .replace(/:/g, "%3B")
                .replace(/#/g, "%23");
        }
        else {
            return _textToEncode;
        }
    };

    commonFactory.GetGlobalCodes = _getGlobalCodes;
    commonFactory.GetGlobalCodeOnId = _getGlobalCodesOnId;
    commonFactory.ShowtostMessage = _showtostMessage;
    commonFactory.IsIos = _isIOS;
    commonFactory.IsAndroid = _isAndroid;
    commonFactory.GetMobileOperatingSystem = _getMobileOperatingSystem;
    commonFactory.ShowProcessing = _showProcessing;
    commonFactory.HideProcessing = _hideProcessing;
    commonFactory.InitializeControls = _initializeControls;
    commonFactory.CalculateDuration = _calculateDuration;
    commonFactory.ConvertToInteger = _convertToInteger;
    commonFactory.ConvertArrayColumnToInteger = _convertArrayColumnsToInteger;
    commonFactory.GetMyPreferenceValue = _getMyPreferenceValue;
    commonFactory.ManageToolbarItem = _manageToolBar;
    commonFactory.GetLocalStorageData = _getLocalStorageData;
    commonFactory.SetLocalStorageData = _setLocalStorageData;
    commonFactory.IncrementLocalChangesCount = _incrementLocalChangesCount;
    commonFactory.DecrementLocalChangesCount = _decrementLocalChangesCount;
    commonFactory.ShowMessageBox = _showMessageBox;
    commonFactory.InsertObjectStoreNameToSync = _insertObjectStoreNameToSync;
    commonFactory.IncrementDataVersionCount = _incrementDataVersionCount;
    commonFactory.DecrementDataVersionCount = _decrementDataVersionCount;
    commonFactory.UpdateLocalChangesCount = _updateLocalChangesCount;
    commonFactory.ShowHomeButton = _showHomeButton;
    commonFactory.FormatDateMMDDYYYY = _formatDateMMDDYYYY;
    commonFactory.Encrypt = _encrypt;
    commonFactory.Decrypt = _decrypt;
    commonFactory.GetSystemConfigurationKeyValue = _getSystemConfigurationKeyValue;
    commonFactory.RegExISO8601 = _RegExISO8601;
    commonFactory.ISO8601Time = _ISO8601Time;
    commonFactory.ISO8601Date = _ISO8601Date;
    commonFactory.ISO8601DateTime = _ISO8601DateTime;
    commonFactory.EncodeText = encodeText;

    return commonFactory;
}]);