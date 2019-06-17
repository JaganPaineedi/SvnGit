var __aspxInvalidDimension = -10000;
var __aspxInvalidPosition = -10000;
var __aspxAbsoluteLeftPosition = -10000;
var __aspxAbsoluteRightPosition = 10000;
var __aspxMenuZIndex = 21998;
var __aspxPopupControlZIndex = 11998;
var __aspxCheckSizeCorrectedFlag = true;
var __aspxCallbackSeparator = ":";
var __aspxItemIndexSeparator = "i";
var __aspxCallbackResultPrefix = "/*^^^DX^^^*/";
var __aspxItemClassName = "dxi";
var __aspxAccessibilityEmptyUrl = "javascript:;";
var __aspxClassesScriptParsed = false;
var __aspxDocumentLoaded = false;
var __aspxEmptyAttributeValue = new Object();
var __aspxEmptyCachedValue = new Object();
var __aspxCachedRules = new Object();
var __aspxCultureInfo = {
    twoDigitYearMax: 2029,
    ts: ":",
    ds: "/",
    am: "AM",
    pm: "PM",
    monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
    genMonthNames: null,
    abbrGenMonthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""],
    abbrDayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    numDecimalPoint: ".",
    numPrec: 2,
    numGroupSeparator: ",",
    numGroups: [3],
    numNegPattern: 1,
    numPosInf: "Infinity",
    numNegInf: "-Infinity",
    numNan: "NaN",
    currency: "$",
    currDecimalPoint: ".",
    currPrec: 2,
    currGroupSeparator: ",",
    currGroups: [3],
    currPosPattern: 0,
    currNegPattern: 0,
    percentPattern: 0,
    shortTime: "h:mm tt",
    longTime: "h:mm:ss tt",
    shortDate: "M/d/yyyy",
    longDate: "dddd, MMMM dd, yyyy",
    monthDay: "MMMM dd",
    yearMonth: "MMMM, yyyy"
};
__aspxCultureInfo.genMonthNames = __aspxCultureInfo.monthNames;
function _aspxGetInvariantDateString(date) {
    if (!date)
        return "01/01/0001";
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    var result = "";
    if (month < 10)
        result += "0";
    result += month.toString() + "/";
    if (day < 10)
        result += "0";
    result += day.toString() + "/" + year.toString();
    return result;
}
function _aspxGetInvariantDateTimeString(date) {
    var dateTimeString = _aspxGetInvariantDateString(date);
    var time = {
        h: date.getHours(),
        m: date.getMinutes(),
        s: date.getSeconds()
    };
    for (var key in time) {
        var str = time[key].toString();
        if (str.length < 2)
            str = "0" + str;
        time[key] = str;
    }
    dateTimeString += " " + time.h + ":" + time.m + ":" + time.s;
    var msec = date.getMilliseconds();
    if (msec > 0)
        dateTimeString += "." + msec.toString();
    return dateTimeString;
}
function _aspxExpandTwoDigitYear(value) {
    value += 1900;
    if (value + 99 < __aspxCultureInfo.twoDigitYearMax)
        value += 100;
    return value;
}
function _aspxToUtcTime(date) {
    var result = new Date();
    result.setTime(date.valueOf() + 60000 * date.getTimezoneOffset());
    return result;
}
function _aspxToLocalTime(date) {
    var result = new Date();
    result.setTime(date.valueOf() - 60000 * date.getTimezoneOffset());
    return result;
}
var ASPxKey = {
    F1: 112,
    F2: 113,
    F3: 114,
    F4: 115,
    F5: 116,
    F6: 117,
    F7: 118,
    F8: 119,
    F9: 120,
    F10: 121,
    F11: 122,
    F12: 123,
    Ctrl: 17,
    Shift: 16,
    Alt: 18,
    Enter: 13,
    Home: 36,
    End: 35,
    Left: 37,
    Right: 39,
    Up: 38,
    Down: 40,
    PageUp: 33,
    PageDown: 34,
    Esc: 27,
    Space: 32,
    Tab: 9,
    Backspace: 8,
    Delete: 46,
    Insert: 45,
    ContextMenu: 93,
    Windows: 91,
    Decimal: 110
};
var ASPxCallbackType = {
    Data: "d",
    Common: "c"
};
var __aspxServerForm = null;
function _aspxGetServerForm() {
    if (typeof (window.__aspxServerFormID) == "undefined")
        return null;
    if (!_aspxIsExistsElement(__aspxServerForm))
        __aspxServerForm = _aspxGetElementById(window.__aspxServerFormID);
    return __aspxServerForm;
}
function _aspxGetActiveElement() {
    try {
        return document.activeElement;
    } catch (e) {
    }
    return null;
}
var __aspxUserAgent = navigator.userAgent.toLowerCase();
var __aspxMozilla,
 __aspxIE,
 __aspxFirefox,
 __aspxNetscape,
 __aspxSafari,
 __aspxChrome,
 __aspxOpera,
 __aspxBrowserVersion,
 __aspxBrowserMajorVersion,
 __aspxWindowsPlatform,
 __aspxMacOSPlatform,
 __aspxWebKitFamily,
 __aspxNetscapeFamily;
function _aspxIdentUserAgent(userAgent) {
    var browserTypesOrderedList = ["Mozilla", "IE", "Firefox", "Netscape", "Safari", "Chrome", "Opera"];
    var defaultBrowserType = "IE";
    var defaultPlatform = "Win";
    var defaultVersions = { Safari: 2, Chrome: 0.1, Mozilla: 1.9, Netscape: 8, Firefox: 2, Opera: 9, IE: 6 };
    if (!userAgent || userAgent.length == 0) {
        _aspxFillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
        return;
    }
    try {
        var platformIdentStrings = {
            "Windows": "Win",
            "Macintosh": "Mac",
            "Mac OS": "Mac",
            "Mac_PowerPC": "Mac"
        };
        var optSlashOrSpace = "(?:/|\\s*)?";
        var version = "(\\d+)(?:\\.((?:\\d+?[1-9])|\\d)0*?)?";
        var optVersion = "(?:" + version + ")?";
        var patterns = {
            Safari: "applewebkit(?:.*?(?:version/" + version + "[\\.\\w\\d]*?\\s+safari))?",
            Chrome: "chrome" + optSlashOrSpace + optVersion,
            Mozilla: "mozilla(?:.*rv:" + optVersion + ".*Gecko)?",
            Netscape: "(?:netscape|navigator)\\d*/?\\s*" + optVersion,
            Firefox: "firefox" + optSlashOrSpace + optVersion,
            Opera: "opera" + optSlashOrSpace + optVersion,
            IE: "msie\\s*" + optVersion
        };
        var browserType;
        var version = -1;
        for (var i = 0; i < browserTypesOrderedList.length; i++) {
            var browserTypeCandidate = browserTypesOrderedList[i];
            var regExp = new RegExp(patterns[browserTypeCandidate], "i");
            if (regExp.compile)
                regExp.compile(patterns[browserTypeCandidate], "i");
            var matches = regExp.exec(userAgent);
            if (matches && matches.index >= 0) {
                browserType = browserTypeCandidate;
                version = -1;
                var versionStr = "";
                if (matches[1]) {
                    versionStr += matches[1];
                    if (matches[2])
                        versionStr += "." + matches[2];
                }
                if (versionStr != "") {
                    version = parseFloat(versionStr);
                    if (version == NaN)
                        version = -1;
                }
            }
        }
        if (!browserType)
            browserType = defaultBrowserType;
        if (version == -1)
            version = defaultVersions[browserType];
        var platform;
        var minOccurenceIndex = Number.MAX_VALUE;
        for (var identStr in platformIdentStrings) {
            var occurenceIndex = userAgent.indexOf(identStr);
            if (occurenceIndex >= 0 && occurenceIndex < minOccurenceIndex) {
                minOccurenceIndex = occurenceIndex;
                platform = platformIdentStrings[identStr];
            }
        }
        if (!platform)
            platform = defaultPlatform;
        _aspxFillUserAgentInfo(browserTypesOrderedList, browserType, version, platform);
    } catch (e) {
        _aspxFillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
    }
}
function _aspxFillUserAgentInfo(browserTypesOrderedList, browserType, version, platform) {
    for (var i = 0; i < browserTypesOrderedList.length; i++) {
        var type = browserTypesOrderedList[i];
        eval("__aspx" + type + " = type == browserType");
    }
    __aspxBrowserVersion = Math.floor(10.0 * version) / 10.0;
    __aspxBrowserMajorVersion = Math.floor(__aspxBrowserVersion);
    __aspxWindowsPlatform = platform == "Win";
    __aspxMacOSPlatform = platform == "Mac";
    __aspxWebKitFamily = __aspxSafari || __aspxChrome;
    __aspxNetscapeFamily = __aspxNetscape || __aspxMozilla || __aspxFirefox;
}
_aspxIdentUserAgent(__aspxUserAgent);
function _aspxArrayPush(array, element) {
    if (_aspxIsExists(array.push))
        array.push(element);
    else
        array[array.length] = element;
}
function _aspxArrayInsert(array, element, position) {
    if (0 <= position && position < array.length) {
        for (var i = array.length; i > position; i--)
            array[i] = array[i - 1];
        array[position] = element;
    }
    else
        _aspxArrayPush(array, element);
}
function _aspxArrayRemove(array, element) {
    var index = _aspxArrayIndexOf(array, element);
    if (index > -1) _aspxArrayRemoveAt(array, index);
}
function _aspxArrayRemoveAt(array, index) {
    if (index >= 0 && index < array.length) {
        for (var i = index; i < array.length - 1; i++)
            array[i] = array[i + 1];
        array.pop();
    }
}
function _aspxArrayClear(array) {
    while (array.length > 0)
        array.pop();
}
function _aspxArrayIndexOf(array, element) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == element)
            return i;
    }
    return -1;
}
function _aspxArrayIntegerAscendingSort(array) {
    array.sort(function(i1, i2) {
        if (i1 > i2)
            return 1;
        else if (i1 < i2)
            return -1;
        else
            return 0;
    });
}
function _aspxCreateHashTableFromArray(array) {
    var hash = [];
    for (var i = 0; i < array.length; i++)
        hash[array[i]] = 1;
    return hash;
}
function _aspxCreateIndexHashTableFromArray(array) {
    var hash = [];
    for (var i = 0; i < array.length; i++)
        hash[array[i]] = i;
    return hash;
}
var __aspxDefaultBinarySearchComparer = function(arrayElement, value) {
    if (arrayElement == value)
        return 0;
    else
        return arrayElement < value ? -1 : 1;
};
function _aspxArrayBinarySearch(array, value, binarySearchComparer, startIndex, length) {
    if (!_aspxIsExists(binarySearchComparer))
        binarySearchComparer = __aspxDefaultBinarySearchComparer;
    if (!_aspxIsExists(startIndex))
        startIndex = 0;
    if (!_aspxIsExists(length))
        length = array.length - startIndex;
    var endIndex = (startIndex + length) - 1;
    while (startIndex <= endIndex) {
        var middle = (startIndex + ((endIndex - startIndex) >> 1));
        var compareResult = binarySearchComparer(array[middle], value);
        if (compareResult == 0)
            return middle;
        if (compareResult < 0)
            startIndex = middle + 1;
        else
            endIndex = middle - 1;
    }
    return -(startIndex + 1);
}
function _aspxApplyReplacement(text, replecementTable) {
    for (var i = 0; i < replecementTable.length; i++) {
        var replacement = replecementTable[i];
        text = text.replace(replacement[0], replacement[1]);
    }
    return text;
}
function _aspxEncodeHtml(html) {
    return _aspxApplyReplacement(html, [
  [/&quot;/g, '&quotx;'], [/"/g, '&quot;'],
  [/&amp;/g, '&ampx;'], [/&/g, '&amp;'],
  [/&lt;/g, '&ltx;'], [/</g, '&lt;'],
  [/&gt;/g, '&gtx;'], [/>/g, '&gt;']
 ]);
}
function _aspxDecodeHtml(html) {
    return _aspxApplyReplacement(html, [
  [/&gt;/g, '>'], [/&gtx;/g, '&gt;'],
  [/&lt;/g, '<'], [/&ltx;/g, '&lt;'],
  [/&amp;/g, '&'], [/&ampx;/g, '&amp;'],
  [/&quot;/g, '"'], [/&quotx;/g, '&quot;']
 ]);
}
function _aspxParseShortcutString(shortcutString) {
    if (!_aspxIsExists(shortcutString))
        return 0;
    var isCtrlKey = false;
    var isShiftKey = false;
    var isAltKey = false;
    var keyCode = null;
    var shcKeys = shortcutString.toString().split("+");
    if (shcKeys.length > 0) {
        for (var i = 0; i < shcKeys.length; i++) {
            var key = _aspxTrim(shcKeys[i].toUpperCase());
            switch (key) {
                case "CTRL":
                    isCtrlKey = true;
                    break;
                case "SHIFT":
                    isShiftKey = true;
                    break;
                case "ALT":
                    isAltKey = true;
                    break;
                case "F1": keyCode = ASPxKey.F1; break;
                case "F2": keyCode = ASPxKey.F2; break;
                case "F3": keyCode = ASPxKey.F3; break;
                case "F4": keyCode = ASPxKey.F4; break;
                case "F5": keyCode = ASPxKey.F5; break;
                case "F6": keyCode = ASPxKey.F6; break;
                case "F7": keyCode = ASPxKey.F7; break;
                case "F8": keyCode = ASPxKey.F8; break;
                case "F9": keyCode = ASPxKey.F9; break;
                case "F10": keyCode = ASPxKey.F10; break;
                case "F11": keyCode = ASPxKey.F11; break;
                case "F12": keyCode = ASPxKey.F12; break;
                case "ENTER": keyCode = ASPxKey.Enter; break;
                case "HOME": keyCode = ASPxKey.Home; break;
                case "END": keyCode = ASPxKey.End; break;
                case "LEFT": keyCode = ASPxKey.Left; break;
                case "RIGHT": keyCode = ASPxKey.Right; break;
                case "UP": keyCode = ASPxKey.Up; break;
                case "DOWN": keyCode = ASPxKey.Down; break;
                case "PAGEUP": keyCode = ASPxKey.PageUp; break;
                case "PAGEDOWN": keyCode = ASPxKey.PageDown; break;
                case "SPACE": keyCode = ASPxKey.Space; break;
                case "TAB": keyCode = ASPxKey.Tab; break;
                case "BACK": keyCode = ASPxKey.Backspace; break;
                case "CONTEXT": keyCode = ASPxKey.ContextMenu; break;
                case "ESCAPE":
                case "ESC":
                    keyCode = ASPxKey.Esc;
                    break;
                case "DELETE":
                case "DEL":
                    keyCode = ASPxKey.Delete;
                    break;
                case "INSERT":
                case "INS":
                    keyCode = ASPxKey.Insert;
                    break;
                case "PLUS":
                    keyCode = "+".charCodeAt(0);
                    break;
                default:
                    keyCode = key.charCodeAt(0);
                    break;
            }
        }
    } else
        alert("Invalid shortcut");
    return _aspxGetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey);
}
function _aspxGetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey) {
    var value = keyCode & 0xFFFF;
    var flags = 0;
    flags |= isCtrlKey ? 1 << 0 : 0;
    flags |= isShiftKey ? 1 << 2 : 0;
    flags |= isAltKey ? 1 << 4 : 0;
    value |= flags << 16;
    return value;
}
function _aspxGetShortcutCodeByEvent(evt) {
    return _aspxGetShortcutCode(_aspxGetKeyCode(evt), evt.ctrlKey, evt.shiftKey, evt.altKey);
}
var ASPxImageUtils = {
    IsAlphaFilterNeed: function(src) {
        return __aspxIE && __aspxBrowserVersion < 7 && this.IsPng(src);
    },
    IsPng: function(src) {
        return src.slice(-3).toLowerCase() == "png";
    },
    GetImageFilterStyle: function(src) {
        return "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + src + ", sizingMethod=scale)";
    },
    GetImageSrc: function(image) {
        if (_aspxIsAlphaFilterUsed(image)) {
            var filter = image.style.filter;
            var regSrc = new RegExp("src=", "g");
            var regPng = new RegExp(".png", "g");
            var beginIndex = regSrc.exec(filter).lastIndex;
            var endIndex = regPng.exec(filter).lastIndex;
            return filter.substring(beginIndex, endIndex);
        }
        return image.src;
    },
    SetImageSrc: function(image, src) {
        var isAlphaFilterNeed = this.IsAlphaFilterNeed(src);
        if (isAlphaFilterNeed) {
            image.src = __aspxEmptyImageUrl;
            image.style.filter = this.GetImageFilterStyle(src);
        } else {
            image.src = src;
            image.style.filter = "";
        }
    },
    SetSize: function(image, width, height) {
        image.style.width = width + "px";
        image.style.height = height + "px";
    },
    GetSize: function(image, isWidth) {
        return (isWidth ? image.offsetWidth : image.offsetHeight);
    }
};
function _aspxAddAlphaImageLoaderTarget(id, imageUrl) {
    if (!window._aspxAlphaImageLoaderTargets)
        window._aspxAlphaImageLoaderTargets = [];
    window._aspxAlphaImageLoaderTargets.push({ elementId: id, bgImageUrl: imageUrl });
}
function _aspxEnsureAlphaImageLoaderApplierRegistered() {
    if (!window._aspxPostponedAlphaImageLoaderApplierAdded) {
        var handler = function() {
            if (window._aspxAlphaImageLoaderTargets) {
                for (var i = 0; i < window._aspxAlphaImageLoaderTargets.length; i++) {
                    var target = window._aspxAlphaImageLoaderTargets[i];
                    _aspxApplyAlphaImageLoaderToBackground(target.elementId, target.bgImageUrl);
                }
                window._aspxAlphaImageLoaderTargets = [];
            }
        };
        if (typeof (aspxGetControlCollection) == "function")
            aspxGetControlCollection().ControlsInitialized.AddHandler(handler);
        else
            window.attachEvent("onload", handler);
        window._aspxPostponedAlphaImageLoaderApplierAdded = true;
    }
}
function _aspxApplyAlphaImageLoaderToBackground(elementId, bgImageUrl) {
    var element = document.all[elementId];
    if (element && element.length)
        element = document.getElementById(elementId);
    element.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + bgImageUrl + ", sizingMethod=crop)";
}
function _aspxApplyAlphaImageLoaderToImage(image) {
    if (image.alphaImageLoaderApplied)
        return;
    if (window.__aspxEmptyImageUrl) {
        image.alphaImageLoaderApplied = true;
        var imageUrl = image.src;
        image.src = window.__aspxEmptyImageUrl;
        image.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + imageUrl + ", sizingMethod=scale)";
    } else {
        var token = window.setInterval(function() {
            if (window.__aspxEmptyImageUrl) {
                _aspxApplyAlphaImageLoaderToImage(image);
                window.clearInterval(token);
            }
        }, 100);
    }
}
var __aspxVerticalScrollBarWidth;
function _aspxGetVerticalScrollBarWidth() {
    if (typeof (__aspxVerticalScrollBarWidth) == "undefined") {
        var container = document.createElement("DIV");
        container.style.cssText = "position: absolute; visibility: hidden; width: 200px; height: 150px; overflow: hidden";
        document.body.appendChild(container);
        var child = document.createElement("P");
        container.appendChild(child);
        child.style.cssText = "width: 100%; height: 200px;";
        var widthWithoutScrollBar = child.offsetWidth;
        container.style.overflow = "scroll";
        var widthWithScrollBar = child.offsetWidth;
        if (widthWithoutScrollBar == widthWithScrollBar)
            widthWithScrollBar = container.clientWidth;
        __aspxVerticalScrollBarWidth = widthWithoutScrollBar - widthWithScrollBar;
        document.body.removeChild(container);
    }
    return __aspxVerticalScrollBarWidth;
}
function _aspxGetVerticalOverflow(element) {
    if (__aspxIE || __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome)
        return element.style.overflowY;
    return element.style.overflow;
}
function _aspxSetVerticalOverflow(element, value) {
    if (__aspxIE || __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome)
        element.style.overflowY = value;
    else
        element.style.overflow = value;
}
ASPxStringBuilder = _aspxCreateClass(null, {
    constructor: function(str) {
        this.Initialize();
        if (str != null)
            this.Append(str);
    },
    Append: function(str) {
        this.value = null;
        this.length += (this.parts[this.partsCount++] = String(str)).length;
        return this;
    },
    Clear: function() {
        this.Initialize();
    },
    Initialize: function() {
        this.parts = [];
        this.partsCount = 0;
        this.length = 0;
        this.value = null;
    },
    ToString: function() {
        if (this.value != null)
            return this.value;
        var aggregate = this.parts.join('');
        this.partsCount = (this.parts = [aggregate]).length;
        this.length = aggregate.length;
        return (this.value = aggregate);
    }
});
function _aspxSetTimeout(callString, timeout) {
    return window.setTimeout(callString, timeout);
}
function _aspxClearTimer(timerID) {
    if (timerID > -1)
        window.clearTimeout(timerID);
    return -1;
}
function _aspxSetInterval(callString, interval) {
    return window.setInterval(callString, interval);
}
function _aspxClearInterval(timerID) {
    if (timerID > -1)
        window.clearInterval(timerID);
    return -1;
}
function _aspxSetInnerHtml(element, html) {
    if (__aspxIE) {
        element.innerHTML = "<em>&nbsp;</em>" + html;
        element.removeChild(element.firstChild);
    } else
        element.innerHTML = html;
}
function _aspxGetInnerText(container) {
    if (__aspxNetscapeFamily)
        return container.textContent;
    else if (__aspxWebKitFamily) {
        var filter = _aspxGetHtml2PlainTextFilter();
        filter.innerHTML = container.innerHTML;
        _aspxSetElementDisplay(filter, true);
        var innerText = filter.innerText;
        _aspxSetElementDisplay(filter, false);
        return innerText;
    } else
        return container.innerText;
}
var __aspxHtml2PlainTextFilter = null;
function _aspxGetHtml2PlainTextFilter() {
    if (__aspxHtml2PlainTextFilter == null) {
        __aspxHtml2PlainTextFilter = document.createElement("DIV");
        __aspxHtml2PlainTextFilter.style.width = "0";
        __aspxHtml2PlainTextFilter.style.height = "0";
        _aspxSetElementDisplay(__aspxHtml2PlainTextFilter, false);
        document.body.appendChild(__aspxHtml2PlainTextFilter);
    }
    return __aspxHtml2PlainTextFilter;
}
function _aspxCreateHiddenField(name, id) {
    var input = document.createElement("INPUT");
    input.setAttribute("type", "hidden");
    if (_aspxIsExists(name))
        input.setAttribute("name", name);
    if (_aspxIsExists(id))
        input.setAttribute("id", id);
    return input;
}
function _aspxCloneObject(srcObject) {
    if (typeof (srcObject) != 'object' || srcObject == null)
        return srcObject;
    var newObject = new Object();
    for (var i in srcObject)
        newObject[i] = srcObject[i];
    return newObject;
}
function _aspxIsExistsType(type) {
    return type != "undefined";
}
function _aspxIsExists(obj) {
    return (typeof (obj) != "undefined") && (obj != null);
}
function _aspxIsFunction(obj) {
    return typeof (obj) == "function";
}
function _aspxGetDefinedValue(value, defaultValue) {
    return (typeof (value) != "undefined") ? value : defaultValue;
}
function _aspxGetKeyCode(srcEvt) {
    return __aspxNetscapeFamily ? srcEvt.which : srcEvt.keyCode;
}
function _aspxSetInputSelection(input, startPos, endPos) {
    startPos = _aspxGetDefinedValue(startPos, 0);
    endPos = _aspxGetDefinedValue(endPos, input.value.length);
    if (__aspxIE) {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveStart("character", startPos);
        range.moveEnd("character", endPos - startPos);
        range.select();
    } else {
        try {
            input.setSelectionRange(startPos, endPos);
        } catch (e) { }
    }
}
function _aspxGetSelectionInfo(input) {
    var start, end;
    if (__aspxIE) {
        var range = document.selection.createRange();
        var rangeCopy = range.duplicate();
        range.move('character', -input.value.length);
        range.setEndPoint('EndToStart', rangeCopy);
        start = range.text.length;
        end = start + rangeCopy.text.length;
    } else {
        start = input.selectionStart;
        end = input.selectionEnd;
    }
    return { startPos: start, endPos: end };
}
function _aspxHasInputSelection(input) {
    var selectionInfo = _aspxGetSelectionInfo(input);
    return selectionInfo.startPos == selectionInfo.endPos;
}
function _aspxPreventElementDrag(element) {
    if (__aspxIE)
        _aspxAttachEventToElement(element, "dragstart", _aspxPreventEvent);
    else
        _aspxAttachEventToElement(element, "mousedown", _aspxPreventEvent);
}
function _aspxPreventElementDragAndSelect(element, isSkipMouseMove) {
    if (__aspxWebKitFamily)
        _aspxAttachEventToElement(element, "selectstart", _aspxPreventEventAndBubble);
    if (__aspxIE) {
        _aspxAttachEventToElement(element, "selectstart", new function() { return false; });
        if (!isSkipMouseMove)
            _aspxAttachEventToElement(element, "mousemove", _aspxClearSelectionOnMouseMove);
        _aspxAttachEventToElement(element, "dragstart", _aspxPreventDragStart);
    }
}
function _aspxSetElementAsUnselectable(element, isWithChild) {
    if (_aspxIsExists(element) && (element.nodeType == 1)) {
        element.unselectable = "on";
        if (__aspxNetscapeFamily)
            element.onmousedown = new function() { return false; };
        if (isWithChild === true) {
            for (var j = 0; j < element.childNodes.length; j++)
                _aspxSetElementAsUnselectable(element.childNodes[j]);
        }
    }
}
function _aspxClearSelection() {
    try {
        if (_aspxIsExists(window.getSelection)) {
            if (__aspxWebKitFamily)
                window.getSelection().collapse();
            else
                window.getSelection().removeAllRanges();
        }
        else if (_aspxIsExists(document.selection)) {
            if (_aspxIsExists(document.selection.empty))
                document.selection.empty();
            else if (_aspxIsExists(document.selection.clear))
                document.selection.clear();
        }
    } catch (e) {
    }
}
function _aspxClearSelectionOnMouseMove(evt) {
    if (!__aspxIE || (evt.button != 0))
        _aspxClearSelection();
}
function _aspxPreventDragStart(evt) {
    evt = _aspxGetEvent(evt);
    var element = _aspxGetEventSource(evt);
    element.releaseCapture();
    return false;
}
function _aspxFalseFunction() { return false; }
function _aspxSetElementSelectionEnabled(element, value) {
    var userSelectValue = value ? "" : "none";
    var func = value ? _aspxDetachEventFromElement : _aspxAttachEventToElement;
    if (__aspxFirefox)
        element.style.MozUserSelect = userSelectValue;
    else if (__aspxWebKitFamily)
        element.style.KhtmlUserSelect = userSelectValue;
    else if (__aspxOpera)
        func(element, "mousemove", _aspxClearSelection);
    else
        func(element, "selectstart", _aspxFalseFunction);
}
function _aspxGetElementById(id) {
    if (_aspxIsExists(document.getElementById))
        return document.getElementById(id);
    else
        return document.all[id];
}
function _aspxGetInputElementById(id) {
    var elem = _aspxGetElementById(id);
    if (!__aspxIE)
        return elem;
    if (_aspxIsExists(elem)) {
        if (elem.id == id)
            return elem;
        else {
            for (var i = 1; i < document.all[id].length; i++) {
                if (document.all[id][i].id == id)
                    return document.all[id][i];
            }
        }
    }
    return null;
}
function _aspxGetElementByIdInDocument(documentObj, id) {
    if (_aspxIsExists(documentObj.getElementById))
        return documentObj.getElementById(id);
    else
        return documentObj.all[id];
}
function _aspxGetIsParent(parentElement, element) {
    while (element != null) {
        if (element.tagName == "BODY")
            return false;
        if (element == parentElement)
            return true;
        element = element.parentNode;
    }
    return false;
}
function _aspxGetParentById(element, id) {
    element = element.parentNode;
    while (element != null) {
        if (element.id == id)
            return element;
        element = element.parentNode;
    }
    return null;
}
function _aspxGetParentByTagName(element, tagName) {
    tagName = tagName.toUpperCase();
    while (element != null) {
        if (element.tagName == "BODY")
            return null;
        if (element.tagName == tagName)
            return element;
        element = element.parentNode;
    }
    return null;
}
function _aspxGetParentByClassName(element, className) {
    while (element != null) {
        if (element.tagName == "BODY")
            return null;
        if (element.className.indexOf(className) != -1)
            return element;
        element = element.parentNode;
    }
    return null;
}
function _aspxGetParentByTagNameAndAttributeValue(element, tagName, attrName, attrValue) {
    tagName = tagName.toUpperCase();
    while (element != null) {
        if (element.tagName == "BODY")
            return null;
        if (element.tagName == tagName && _aspxIsExists(element[attrName]) && element[attrName] == attrValue)
            return element;
        element = element.parentNode;
    }
    return null;
}
function _aspxGetChildById(element, id) {
    if (!__aspxIE)
        return _aspxGetElementById(id);
    else {
        var element = element.all[id];
        if (!_aspxIsExists(element))
            return null;
        else if (!_aspxIsExists(element.length))
            return element;
        else
            return _aspxGetElementById(id);
    }
}
function _aspxGetElementsByTagName(element, tagName) {
    tagName = tagName.toUpperCase();
    if (element != null) {
        if (_aspxIsExists(element.all) && (!__aspxFirefox || __aspxBrowserVersion < 3))
            return __aspxNetscape ? element.all.tags[tagName] : element.all.tags(tagName);
        else
            return element.getElementsByTagName(tagName);
    }
    return null;
}
function _aspxGetChildByTagName(element, tagName, index) {
    if (element != null) {
        var collection = _aspxGetElementsByTagName(element, tagName);
        if (collection != null) {
            if (index < collection.length)
                return collection[index];
        }
    }
    return null;
}
function _aspxGetChildTextNode(element, index) {
    if (element != null) {
        var collection = new Array();
        _aspxGetChildTextNodeCollection(element, collection);
        if (index < collection.length)
            return collection[index];
    }
    return null;
}
function _aspxGetChildTextNodeCollection(element, collection) {
    for (var i = 0; i < element.childNodes.length; i++) {
        var childNode = element.childNodes[i];
        if (_aspxIsExists(childNode.nodeValue))
            _aspxArrayPush(collection, childNode);
        _aspxGetChildTextNodeCollection(childNode, collection);
    }
}
function _aspxGetChildsByClassName(element, className) {
    var collection = _aspxIsExists(element.all) ? element.all : element.getElementsByTagName('*');
    var ret = new Array();
    if (collection != null) {
        for (var i = 0; i < collection.length; i++) {
            if (collection[i].className.indexOf(className) != -1)
                ret.push(collection[i]);
        }
    }
    return ret;
}
function _aspxGetParentByPartialId(element, idPart) {
    while (element != null) {
        if (_aspxIsExists(element.id)) {
            if (element.id.indexOf(idPart) > -1) return element;
        }
        element = element.parentNode;
    }
    return null;
}
function _aspxGetElementsByPartialId(element, partialName, list) {
    if (!_aspxIsExists(element.id)) return;
    if (element.id.indexOf(partialName) > -1) {
        list.push(element);
    }
    for (var i = 0; i < element.childNodes.length; i++) {
        _aspxGetElementsByPartialId(element.childNodes[i], partialName, list);
    }
}
function _aspxGetElementDocument(element) {
    return _aspxIsExists(element.document) ? element.document : element.ownerDocument;
}
function _aspxIFrameWindow(name) {
    if (__aspxIE)
        return window.frames[name].window;
    else {
        var frameElement = document.getElementById(name);
        return (frameElement != null) ? frameElement.contentWindow : null;
    }
}
function _aspxIFrameDocument(name) {
    if (__aspxIE)
        return window.frames[name].document;
    else {
        var frameElement = document.getElementById(name);
        return (frameElement != null) ? frameElement.contentDocument : null;
    }
}
function _aspxIFrameDocumentBody(name) {
    var doc = _aspxIFrameDocument(name);
    return (doc != null) ? doc.body : null;
}
function _aspxIFrameElement(name) {
    if (__aspxIE)
        return window.frames[name].window.frameElement;
    else
        return document.getElementById(name);
}
function _aspxRemoveElement(element) {
    if (_aspxIsExists(element)) {
        var parent = element.parentNode;
        if (_aspxIsExists(parent))
            parent.removeChild(element);
    }
    element = null;
}
function _aspxReplaceTagName(element, newTagName) {
    if (element.nodeType != 1)
        return null;
    if (element.nodeName == newTagName)
        return element;
    var doc = element.ownerDocument;
    var newElem = doc.createElement(newTagName);
    _aspxCopyAllAttributes(element, newElem);
    for (var i = 0; i < element.childNodes.length; i++)
        newElem.appendChild(element.childNodes[i].cloneNode(true));
    element.parentNode.replaceChild(newElem, element);
    return newElem;
}
function _aspxRemoveOuterTags(element) {
    if (__aspxIE) {
        element.insertAdjacentHTML('beforeBegin', element.innerHTML);
        _aspxRemoveElement(element);
    } else {
        var docFragment = element.ownerDocument.createDocumentFragment();
        for (var i = 0; i < element.childNodes.length; i++)
            docFragment.appendChild(element.childNodes[i].cloneNode(true));
        element.parentNode.replaceChild(docFragment, element);
    }
}
function _aspxWrapElementInNewElement(element, newElementTagName) {
    var wrapElement = null;
    if (__aspxIE) {
        var wrapElement = element.ownerDocument.createElement(newElementTagName);
        wrapElement.appendChild(element.cloneNode(true));
        element.parentNode.insertBefore(wrapElement, element);
        element.parentNode.removeChild(element);
    } else {
        var docFragment = element.ownerDocument.createDocumentFragment();
        wrapElement = element.ownerDocument.createElement(newElementTagName);
        docFragment.appendChild(wrapElement);
        wrapElement.appendChild(element.cloneNode(true));
        element.parentNode.replaceChild(docFragment, element);
    }
    return wrapElement;
}
function _aspxGetEvent(evt) {
    return (typeof (event) != "undefined" && event != null) ? event : evt;
}
function _aspxPreventEvent(evt) {
    if (__aspxNetscapeFamily)
        evt.preventDefault();
    else
        evt.returnValue = false;
    return false;
}
function _aspxPreventEventAndBubble(evt) {
    _aspxPreventEvent(evt);
    if (__aspxNetscapeFamily)
        evt.stopPropagation();
    evt.cancelBubble = true;
    return false;
}
function _aspxCancelBubble(evt) {
    evt.cancelBubble = true;
    return false;
}
function _aspxGetEventSource(evt) {
    evt = _aspxGetEvent(evt);
    if (!_aspxIsExists(evt)) return null;
    return __aspxIE ? evt.srcElement : evt.target;
}
function _aspxGetEventX(evt) {
    return evt.clientX - _aspxGetIEDocumentClientOffsetInternal(true) + (__aspxSafari && __aspxBrowserVersion < 3 ? 0 : _aspxGetDocumentScrollLeft());
}
function _aspxGetEventY(evt) {
    return evt.clientY - _aspxGetIEDocumentClientOffsetInternal(false) + (__aspxSafari && __aspxBrowserVersion < 3 ? 0 : _aspxGetDocumentScrollTop());
}
function _aspxGetIEDocumentClientOffset(IsX) {
    return 0;
}
function _aspxGetIEDocumentClientOffsetInternal(IsX) {
    var clientOffset = 0;
    if (__aspxIE) {
        if (_aspxIsExists(document.documentElement))
            clientOffset = IsX ? document.documentElement.clientLeft : document.documentElement.clientTop;
        if (clientOffset == 0 && _aspxIsExists(document.body))
            var clientOffset = IsX ? document.body.clientLeft : document.body.clientTop;
    }
    return clientOffset;
}
function _aspxGetIsLeftButtonPressed(evt) {
    evt = _aspxGetEvent(evt);
    if (!_aspxIsExists(evt)) return false;
    if (__aspxIE)
        return evt.button == 1;
    else if (__aspxNetscapeFamily || __aspxWebKitFamily)
        return evt.which == 1;
    else if (__aspxOpera)
        return evt.button == 0;
    return true;
}
function _aspxGetWheelDelta(evt) {
    var ret = __aspxNetscapeFamily ? -evt.detail : evt.wheelDelta;
    if (__aspxOpera && __aspxBrowserVersion < 9)
        ret = -ret;
    return ret;
}
function _aspxDelCookie(name) {
    _aspxSetCookieInternal(name, "", new Date(1970, 1, 1));
}
function _aspxGetCookie(name) {
    name = escape(name);
    var cookies = document.cookie.split(';');
    for (var i = 0; i < cookies.length; i++) {
        var cookie = _aspxTrim(cookies[i]);
        if (cookie.indexOf(name + "=") == 0)
            return unescape(cookie.substring(name.length + 1, cookie.length));
        else if (cookie.indexOf(name + ";") == 0 || cookie === name)
            return "";
    }
    return null;
}
function _aspxSetCookie(name, value, expirationDate) {
    if (!_aspxIsExists(value)) {
        _aspxDelCookie(name);
        return;
    }
    if (!ASPxIdent.IsDate(expirationDate)) {
        expirationDate = new Date();
        expirationDate.setFullYear(expirationDate.getFullYear() + 1);
    }
    _aspxSetCookieInternal(name, value, expirationDate);
}
function _aspxSetCookieInternal(name, value, date) {
    document.cookie = escape(name) + "=" + escape(value.toString()) + "; expires=" + date.toGMTString() + "; path=/";
}
function _aspxGetElementDisplay(element) {
    return element.style.display != "none";
}
function _aspxSetElementDisplay(element, value) {
    element.style.display = value ? "" : "none";
}
function _aspxGetElementVisibility(element) {
    return element.style.visibility != "hidden";
}
function _aspxSetElementVisibility(element, value) {
    element.style.visibility = value ? "" : "hidden";
}
function _aspxAddStyleSheetLinkToDocument(doc, linkUrl) {
    var newLink = _aspxCreateStyleLink(doc, linkUrl);
    var head = _aspxGetHeadElementOrCreateIfNotExist(doc);
    head.appendChild(newLink);
}
function _aspxGetHeadElementOrCreateIfNotExist(doc) {
    var elements = _aspxGetElementsByTagName(doc, "head");
    var head = null;
    if (elements.length == 0) {
        head = doc.createElement("head");
        head.visibility = "hidden";
        doc.insertBefore(head, doc.body);
    } else
        head = elements[0];
    return head;
}
function _aspxCreateStyleLink(doc, url) {
    var newLink = doc.createElement("link");
    _aspxSetAttribute(newLink, "href", url);
    _aspxSetAttribute(newLink, "type", "text/css");
    _aspxSetAttribute(newLink, "rel", "stylesheet");
    return newLink;
}
function _aspxGetCurrentStyle(element) {
    if (__aspxIE)
        return element.currentStyle;
    else if (__aspxOpera && __aspxBrowserVersion < 9)
        return window.getComputedStyle(element, null);
    else
        return document.defaultView.getComputedStyle(element, null);
}
function _aspxIsElementRigthToLeft(element) {
    var style = _aspxGetCurrentStyle(element);
    if (__aspxIE)
        style.writingMode.toUpperCase().indexOf("RL") > -1;
    return style.direction.toUpperCase().indexOf("RTL") > -1;
}
function _aspxCreateStyleSheetInDocument(doc) {
    if (__aspxIE)
        return doc.createStyleSheet();
    else {
        var styleSheet = doc.createElement("STYLE");
        _aspxGetChildByTagName(doc, "HEAD", 0).appendChild(styleSheet);
        return doc.styleSheets[doc.styleSheets.length - 1];
    }
}
function _aspxCreateStyleSheet() {
    return _aspxCreateStyleSheetInDocument(document);
}
function _aspxGetStyleSheetRules(styleSheet) {
    try {
        return __aspxIE ? styleSheet.rules : styleSheet.cssRules;
    }
    catch (e) {
        return null;
    }
}
function _aspxGetStyleSheetRule(className) {
    if (_aspxIsExists(__aspxCachedRules[className])) {
        if (__aspxCachedRules[className] != __aspxEmptyCachedValue)
            return __aspxCachedRules[className];
        return null;
    }
    for (var i = 0; i < document.styleSheets.length; i++) {
        var styleSheet = document.styleSheets[i];
        var rules = _aspxGetStyleSheetRules(styleSheet);
        if (rules != null) {
            for (var j = 0; j < rules.length; j++) {
                if (rules[j].selectorText == "." + className) {
                    __aspxCachedRules[className] = rules[j];
                    return rules[j];
                }
            }
        }
    }
    __aspxCachedRules[className] = __aspxEmptyCachedValue;
    return null;
}
function _aspxRemoveStyleSheetRule(styleSheet, index) {
    var rules = _aspxGetStyleSheetRules(styleSheet);
    if (rules != null && rules.length > 0 && rules.length >= index) {
        if (__aspxIE)
            styleSheet.removeRule(index);
        else
            styleSheet.deleteRule(index);
    }
}
function _aspxAddStyleSheetRule(styleSheet, selector, cssText) {
    if (!_aspxIsExists(cssText) || cssText == "") return;
    if (__aspxIE)
        styleSheet.addRule(selector, cssText);
    else
        styleSheet.insertRule(selector + " { " + cssText + " }", styleSheet.cssRules.length);
}
function _aspxGetPointerCursor() {
    return "pointer";
}
function _aspxSetPointerCursor(element) {
    if (element.style.cursor == "")
        element.style.cursor = _aspxGetPointerCursor();
}
var _aspxWebKit3TDRealInfo = {
    GetOffsetTop: function(tdElement) {
        switch (_aspxGetCurrentStyle(tdElement).verticalAlign) {
            case "middle":
                return Math.round(tdElement.offsetTop - (tdElement.offsetHeight - tdElement.clientHeight) / 2 + tdElement.clientTop);
            case "bottom":
                return tdElement.offsetTop - tdElement.offsetHeight + tdElement.clientHeight + tdElement.clientTop;
        }
        return tdElement.offsetTop;
    },
    GetClientHeight: function(tdElement) {
        var valign = _aspxGetCurrentStyle(tdElement).verticalAlign;
        switch (valign) {
            case "middle":
                return tdElement.clientHeight + tdElement.offsetTop * 2;
            case "top":
                return tdElement.offsetHeight - tdElement.clientTop * 2;
            case "bottom":
                return tdElement.clientHeight + tdElement.offsetTop;
        }
        return tdElement.clientHeight;
    }
}
function _aspxGetIsValidPosition(pos) {
    return pos != __aspxInvalidPosition && pos != -__aspxInvalidPosition;
}
function _aspxGetAbsoluteX(curEl) {
    return _aspxGetAbsolutePositionX(curEl);
}
function _aspxGetAbsoluteY(curEl) {
    return _aspxGetAbsolutePositionY(curEl);
}
function _aspxSetAbsoluteX(element, x) {
    element.style.left = _aspxPrepareClientPosForElement(x, element, true) + "px";
}
function _aspxSetAbsoluteY(element, y) {
    element.style.top = _aspxPrepareClientPosForElement(y, element, false) + "px";
}
function _aspxGetAbsolutePositionX(element) {
    if (__aspxIE)
        return _aspxGetAbsolutePositionX_IE(element);
    else if (__aspxFirefox && __aspxBrowserVersion >= 3)
        return _aspxGetAbsolutePositionX_FF3(element);
    else if (__aspxOpera)
        return _aspxGetAbsolutePositionX_Opera(element);
    else if (__aspxNetscapeFamily && (!__aspxFirefox || __aspxBrowserVersion < 3))
        return _aspxGetAbsolutePositionX_NS(element);
    else if (__aspxWebKitFamily)
        return _aspxGetAbsolutePositionX_Safari(element);
    else
        return _aspxGetAbsolutePositionX_Other(element);
}
function _aspxGetAbsolutePositionX_Opera(curEl) {
    var isFirstCycle = true;
    var pos = _aspxGetAbsoluteOffsetX_OperaFFSafari(curEl);
    while (curEl != null) {
        pos += curEl.offsetLeft;
        if (!isFirstCycle)
            pos -= curEl.scrollLeft;
        curEl = curEl.offsetParent;
        isFirstCycle = false;
    }
    pos += document.body.scrollLeft;
    return pos;
}
function _aspxGetAbsolutePositionX_IE(element) {
    if (element == null || __aspxIE && element.parentNode == null) return 0;
    return element.getBoundingClientRect().left + _aspxGetDocumentScrollLeft() - _aspxGetIEDocumentClientOffsetInternal(true);
}
function _aspxGetAbsolutePositionX_FF3(element) {
    if (element == null) return 0;
    var x = element.getBoundingClientRect().left + _aspxGetDocumentScrollLeft() - _aspxGetIEDocumentClientOffsetInternal(true);
    return Math.round(x);
}
function _aspxGetAbsolutePositionX_NS(curEl) {
    var pos = _aspxGetAbsoluteOffsetX_OperaFFSafari(curEl);
    var isFirstCycle = true;
    while (curEl != null) {
        pos += curEl.offsetLeft;
        if (!isFirstCycle && curEl.offsetParent != null)
            pos -= curEl.scrollLeft;
        if (!isFirstCycle && __aspxFirefox) {
            var style = _aspxGetCurrentStyle(curEl);
            if (curEl.tagName == "DIV" && style.overflow != "visible")
                pos += _aspxPxToInt(style.borderLeftWidth);
        }
        isFirstCycle = false;
        curEl = curEl.offsetParent;
    }
    return pos;
}
function _aspxGetAbsolutePositionX_Safari(curEl) {
    var pos = _aspxGetAbsoluteOffsetX_OperaFFSafari(curEl);
    var isSafariVerNonLessThan3OrChrome = __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome;
    if (curEl != null) {
        var isFirstCycle = true;
        if (isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
            pos += curEl.offsetLeft;
            curEl = curEl.offsetParent;
            isFirstCycle = false;
        }
        while (curEl != null) {
            pos += curEl.offsetLeft;
            if (isSafariVerNonLessThan3OrChrome && !isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE"))
                pos += curEl.clientLeft;
            isFirstCycle = false;
            curEl = curEl.offsetParent;
        }
    }
    return pos;
}
function _aspxGetAbsoluteOffsetX_OperaFFSafari(curEl) {
    var pos = 0;
    var isFirstCycle = true;
    while (curEl != null) {
        if (curEl.tagName == "BODY")
            break;
        var style = _aspxGetCurrentStyle(curEl);
        if (!__aspxWebKitFamily && style.position == "absolute")
            break;
        if (!isFirstCycle && curEl.tagName == "DIV" && (__aspxWebKitFamily || style.position == "" || style.position == "static"))
            pos -= curEl.scrollLeft;
        curEl = curEl.parentNode;
        isFirstCycle = false;
    }
    return pos;
}
function _aspxGetAbsolutePositionX_Other(curEl) {
    var pos = 0;
    var isFirstCycle = true;
    while (curEl != null) {
        pos += curEl.offsetLeft;
        if (!isFirstCycle && curEl.offsetParent != null)
            pos -= curEl.scrollLeft;
        isFirstCycle = false;
        curEl = curEl.offsetParent;
    }
    return pos;
}
function _aspxGetAbsolutePositionY(element) {
    if (__aspxIE)
        return _aspxGetAbsolutePositionY_IE(element);
    else if (__aspxFirefox && __aspxBrowserVersion >= 3)
        return _aspxGetAbsolutePositionY_FF3(element);
    else if (__aspxOpera)
        return _aspxGetAbsolutePositionY_Opera(element);
    else if (__aspxNetscapeFamily && (!__aspxFirefox || __aspxBrowserVersion < 3))
        return _aspxGetAbsolutePositionY_NS(element);
    else if (__aspxWebKitFamily)
        return _aspxGetAbsolutePositionY_Safari(element);
    else
        return _aspxGetAbsolutePositionY_Other(element);
}
function _aspxGetAbsolutePositionY_Opera(curEl) {
    var isFirstCycle = true;
    if (curEl && curEl.tagName == "TR" && curEl.cells.length > 0)
        curEl = curEl.cells[0];
    var pos = _aspxGetAbsoluteOffsetY_OperaFFSafari(curEl);
    while (curEl != null) {
        pos += curEl.offsetTop;
        if (!isFirstCycle)
            pos -= curEl.scrollTop;
        curEl = curEl.offsetParent;
        isFirstCycle = false;
    }
    pos += document.body.scrollTop;
    return pos;
}
function _aspxGetAbsolutePositionY_IE(element) {
    if (element == null || __aspxIE && element.parentNode == null) return 0;
    return element.getBoundingClientRect().top + _aspxGetDocumentScrollTop() - _aspxGetIEDocumentClientOffsetInternal(false);
}
function _aspxGetAbsolutePositionY_FF3(element) {
    if (element == null) return 0;
    var y = element.getBoundingClientRect().top + _aspxGetDocumentScrollTop() - _aspxGetIEDocumentClientOffsetInternal(false);
    return Math.round(y);
}
function _aspxGetAbsolutePositionY_NS(curEl) {
    var pos = _aspxGetAbsoluteOffsetY_OperaFFSafari(curEl);
    var isFirstCycle = true;
    while (curEl != null) {
        pos += curEl.offsetTop;
        if (!isFirstCycle && curEl.offsetParent != null)
            pos -= curEl.scrollTop;
        if (!isFirstCycle && __aspxFirefox) {
            var style = _aspxGetCurrentStyle(curEl);
            if (curEl.tagName == "DIV" && style.overflow != "visible")
                pos += _aspxPxToInt(style.borderTopWidth);
        }
        isFirstCycle = false;
        curEl = curEl.offsetParent;
    }
    return pos;
}
function _aspxGetAbsolutePositionY_Safari(curEl) {
    var pos = _aspxGetAbsoluteOffsetY_OperaFFSafari(curEl);
    var isSafariVerNonLessThan3OrChrome = __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome;
    if (curEl != null) {
        var isFirstCycle = true;
        if (isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
            pos += _aspxWebKit3TDRealInfo.GetOffsetTop(curEl);
            curEl = curEl.offsetParent;
            isFirstCycle = false;
        }
        while (curEl != null) {
            pos += curEl.offsetTop;
            if (isSafariVerNonLessThan3OrChrome && !isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE"))
                pos += curEl.clientTop;
            isFirstCycle = false;
            curEl = curEl.offsetParent;
        }
    }
    return pos;
}
function _aspxGetAbsoluteOffsetY_OperaFFSafari(curEl) {
    var pos = 0;
    var isFirstCycle = true;
    while (curEl != null) {
        if (curEl.tagName == "BODY")
            break;
        var style = _aspxGetCurrentStyle(curEl);
        if (!__aspxWebKitFamily && style.position == "absolute")
            break;
        if (!isFirstCycle && curEl.tagName == "DIV" && (__aspxWebKitFamily || style.position == "" || style.position == "static"))
            pos -= curEl.scrollTop;
        curEl = curEl.parentNode;
        isFirstCycle = false;
    }
    return pos;
}
function _aspxGetAbsolutePositionY_Other(curEl) {
    var pos = 0;
    var isFirstCycle = true;
    while (curEl != null) {
        pos += curEl.offsetTop;
        if (!isFirstCycle && curEl.offsetParent != null)
            pos -= curEl.scrollTop;
        isFirstCycle = false;
        curEl = curEl.offsetParent;
    }
    return pos;
}
function _aspxPrepareClientPosForElement(pos, element, isX) {
    pos -= _aspxGetPositionElementOffset(element, isX);
    return pos;
}
function _aspxGetPositionElementOffset(element, isX) {
    var curEl = element.offsetParent;
    var offset = 0;
    var scroll = 0;
    var isThereFixedParent = false;
    var isFixed = false;
    var position = "";
    while (curEl != null) {
        var tagName = curEl.tagName;
        if (tagName == "HTML" || tagName == "BODY")
            break;
        if (tagName != "TD" && tagName != "TR") {
            var style = _aspxGetCurrentStyle(curEl);
            isFixed = style.position == "fixed";
            if (isFixed)
                isThereFixedParent = true;
            if (style.position == "absolute" || isFixed || style.position == "relative") {
                offset += isX ? curEl.offsetLeft : curEl.offsetTop;
                if (__aspxIE || __aspxOpera && __aspxBrowserVersion >= 9 || __aspxSafari && __aspxMacOSPlatform)
                    offset += _aspxPxToInt(isX ? style.borderLeftWidth : style.borderTopWidth);
            }
        }
        scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
        curEl = curEl.offsetParent;
    }
    offset -= scroll;
    if ((__aspxIE && __aspxBrowserVersion >= 7 || __aspxFirefox && __aspxBrowserVersion >= 3) && isThereFixedParent)
        offset += isX ? _aspxGetDocumentScrollLeft() : _aspxGetDocumentScrollTop();
    return offset;
}
function _aspxPxToInt(px) {
    var result = 0;
    if (px != null && px != "") {
        try {
            var indexOfPx = px.indexOf("px");
            if (indexOfPx > -1)
                result = parseInt(px.substr(0, indexOfPx));
        } catch (e) { }
    }
    return result;
}
function _aspxGetLeftRightBordersAndPaddingsSummaryValue(element) {
    var currentStyle = _aspxGetCurrentStyle(element);
    var value = _aspxPxToInt(currentStyle.paddingLeft) + _aspxPxToInt(currentStyle.paddingRight);
    if (currentStyle.borderLeftStyle != "none")
        value += _aspxPxToInt(currentStyle.borderLeftWidth);
    if (currentStyle.borderRightStyle != "none")
        value += _aspxPxToInt(currentStyle.borderRightWidth);
    return value;
}
function _aspxGetClearClientWidth(element) {
    return element.offsetWidth - _aspxGetLeftRightBordersAndPaddingsSummaryValue(element);
}
function _aspxGetClearClientHeight(element) {
    var currentStyle = _aspxGetCurrentStyle(element);
    return element.offsetHeight - _aspxPxToInt(currentStyle.paddingTop) - _aspxPxToInt(currentStyle.paddingBottom) -
  _aspxPxToInt(currentStyle.borderTopWidth) - _aspxPxToInt(currentStyle.borderBottomWidth);
}
function _aspxSetOffsetWidth(element, widthValue) {
    var currentStyle = _aspxGetCurrentStyle(element);
    var value = widthValue - _aspxPxToInt(currentStyle.marginLeft) - _aspxPxToInt(currentStyle.marginRight);
    if (__aspxIE)
        value -= _aspxGetLeftRightBordersAndPaddingsSummaryValue(element);
    if (value > -1)
        element.style.width = value + "px";
}
function _aspxSetOffsetHeight(element, heightValue) {
    var currentStyle = _aspxGetCurrentStyle(element);
    var value = heightValue - _aspxPxToInt(currentStyle.marginTop) - _aspxPxToInt(currentStyle.marginBottom);
    if (__aspxIE)
        value -= _aspxPxToInt(currentStyle.paddingTop) + _aspxPxToInt(currentStyle.paddingBottom) +
   _aspxPxToInt(currentStyle.borderTopWidth) + _aspxPxToInt(currentStyle.borderBottomWidth);
    if (value > -1)
        element.style.height = value + "px";
}
function _aspxFindOffsetParent(element) {
    if (__aspxIE && __aspxBrowserVersion < 8)
        return element.offsetParent;
    var currentElement = element.parentNode;
    while (_aspxIsExistsElement(currentElement) && currentElement.tagName != "BODY") {
        if (currentElement.offsetWidth > 0 && currentElement.offsetHeight > 0)
            return currentElement;
        currentElement = currentElement.parentNode;
    }
    return document.body;
}
function _aspxGetDocumentScrollTop() {
    if (__aspxWebKitFamily || __aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.scrollTop == 0)
        return document.body.scrollTop;
    else
        return document.documentElement.scrollTop;
}
function _aspxGetDocumentScrollLeft() {
    if (__aspxWebKitFamily || __aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.scrollLeft == 0)
        return document.body.scrollLeft;
    else
        return document.documentElement.scrollLeft;
}
function _aspxGetDocumentClientWidth() {
    if (__aspxWebKitFamily || __aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.clientWidth == 0)
        return document.body.clientWidth;
    else
        return document.documentElement.clientWidth;
}
function _aspxGetDocumentClientHeight() {
    if (__aspxWebKitFamily)
        return window.innerHeight;
    else if (__aspxOpera)
        return __aspxBrowserVersion >= 9.6 ? document.documentElement.clientHeight : document.body.clientHeight;
    else if (__aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.clientHeight == 0)
        return document.body.clientHeight;
    else
        return document.documentElement.clientHeight;
}
function _aspxSetStylePosition(element, x, y) {
    element.style.left = x + "px";
    element.style.top = y + "px";
}
function _aspxSetStyleSize(element, width, height) {
    element.style.width = width + "px";
    element.style.height = height + "px";
}
function _aspxGetDocumentWidth() {
    var bodyWidth = document.body.offsetWidth;
    var docWidth = (__aspxIE && __aspxBrowserMajorVersion != 7) ? document.documentElement.clientWidth : document.documentElement.offsetWidth;
    var bodyScrollWidth = document.body.scrollWidth;
    var docScrollWidth = document.documentElement.scrollWidth;
    return _aspxGetMaxDimensionOf(bodyWidth, docWidth, bodyScrollWidth, docScrollWidth);
}
function _aspxGetDocumentHeight() {
    var bodyHeight = document.body.offsetHeight;
    var docHeight = (__aspxIE && __aspxBrowserMajorVersion != 7) ? document.documentElement.clientHeight : document.documentElement.offsetHeight;
    var bodyScrollHeight = document.body.scrollHeight;
    var docScrollHeight = document.documentElement.scrollHeight;
    var maxHeight = _aspxGetMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight, docScrollHeight);
    if (__aspxOpera && __aspxBrowserVersion >= 9.6) {
        if (__aspxBrowserVersion < 10)
            maxHeight = _aspxGetMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight);
        var visibleHeightOfDocument = document.documentElement.clientHeight;
        if (maxHeight > visibleHeightOfDocument)
            maxHeight = _aspxGetMaxDimensionOf(window.outerHeight, maxHeight);
        else
            maxHeight = document.documentElement.clientHeight;
        return maxHeight;
    }
    return maxHeight;
}
function _aspxGetDocumentMaxClientWidth() {
    var bodyWidth = document.body.offsetWidth;
    var docWidth = document.documentElement.offsetWidth;
    var docClientWidth = document.documentElement.clientWidth;
    return _aspxGetMaxDimensionOf(bodyWidth, docWidth, docClientWidth);
}
function _aspxGetDocumentMaxClientHeight() {
    var bodyHeight = document.body.offsetHeight;
    var docHeight = document.documentElement.offsetHeight;
    var docClientHeight = document.documentElement.clientHeight;
    return _aspxGetMaxDimensionOf(bodyHeight, docHeight, docClientHeight);
}
function _aspxGetMaxDimensionOf() {
    var max = __aspxInvalidDimension;
    for (var i = 0; i < arguments.length; i++) {
        if (max < arguments[i])
            max = arguments[i];
    }
    return max;
}
function _aspxGetClientLeft(element) {
    return _aspxIsExists(element.clientLeft) ? element.clientLeft : (element.offsetWidth - element.clientWidth) / 2;
}
function _aspxGetClientTop(element) {
    return _aspxIsExists(element.clientTop) ? element.clientTop : (element.offsetHeight - element.clientHeight) / 2;
}
function _aspxRemoveBorders(element) {
    if (!_aspxIsExists(element))
        return;
    element.style.borderWidth = 0;
    for (var i = 0; i < element.childNodes.length; i++) {
        var child = element.childNodes[i];
        if (_aspxIsExists(child.style))
            child.style.border = "0";
    }
}
function _aspxSetBackground(element, background) {
    if (!_aspxIsExists(element))
        return;
    element.style.backgroundColor = background;
    for (var i = 0; i < element.childNodes.length; i++) {
        var child = element.childNodes[i];
        if (_aspxIsExists(child.style))
            child.style.backgroundColor = background;
    }
}
function _aspxSetFocus(element) {
    window.setTimeout(function() {
        try {
            element.focus();
            if (__aspxIE && document.activeElement != element)
                element.focus();
        } catch (e) {
        }
    }, 100);
}
function _aspxIsFocusableCore(element, skipContainerVisibilityCheck) {
    var current = element;
    while (_aspxIsExists(current)) {
        if (current == element || !skipContainerVisibilityCheck(current)) {
            if (current.tagName == "BODY")
                return true;
            if (current.disabled || !_aspxGetElementDisplay(current) || !_aspxGetElementVisibility(current))
                return false;
        }
        current = current.parentNode;
    }
    return true;
}
function _aspxIsFocusable(element) {
    return _aspxIsFocusableCore(element, function() { return false; });
}
function _aspxAttachEventToElement(element, eventName, func) {
    if (__aspxNetscapeFamily || __aspxWebKitFamily)
        element.addEventListener(eventName, func, true);
    else {
        if (eventName.toLowerCase().indexOf("on") != 0)
            eventName = "on" + eventName;
        element.attachEvent(eventName, func);
    }
}
function _aspxDetachEventFromElement(element, eventName, func) {
    if (__aspxNetscapeFamily || __aspxWebKitFamily)
        element.removeEventListener(eventName, func, true);
    else {
        if (eventName.toLowerCase().indexOf("on") != 0)
            eventName = "on" + eventName;
        element.detachEvent(eventName, func);
    }
}
function _aspxAttachEventToDocument(eventName, func) {
    _aspxAttachEventToElement(document, eventName, func);
}
function _aspxDetachEventFromDocument(eventName, func) {
    _aspxAttachEventToElement(document, eventName, func);
}
function _aspxCreateEventHandlerFunction(funcName, controlName, withHtmlEventArg) {
    return withHtmlEventArg ?
  new Function("event", funcName + "('" + controlName + "', event);") :
  new Function(funcName + "('" + controlName + "');");
}
function _aspxCreateClass(parentClass, properties) {
    var ret = function() {
        if (ret.preparing)
            return delete (ret.preparing);
        if (ret.constr) {
            this.constructor = ret;
            ret.constr.apply(this, arguments);
        }
    }
    ret.prototype = {};
    if (_aspxIsExists(parentClass)) {
        parentClass.preparing = true;
        ret.prototype = new parentClass;
        ret.prototype.constructor = parentClass;
        ret.constr = parentClass;
    }
    if (_aspxIsExists(properties)) {
        var constructorName = "constructor";
        for (var name in properties) {
            if (name != constructorName)
                ret.prototype[name] = properties[name];
        }
        if (properties[constructorName] && properties[constructorName] != Object)
            ret.constr = properties[constructorName];
    }
    return ret;
}
function _aspxGetAttribute(obj, attrName) {
    if (_aspxIsExists(obj.getAttribute))
        return obj.getAttribute(attrName);
    else if (_aspxIsExists(obj.getPropertyValue))
        return obj.getPropertyValue(attrName);
    return null;
}
function _aspxSetAttribute(obj, attrName, value) {
    if (_aspxIsExists(obj.setAttribute))
        obj.setAttribute(attrName, value);
    else if (_aspxIsExists(obj.setProperty))
        obj.setProperty(attrName, value, "");
}
function _aspxRemoveAttribute(obj, attrName) {
    if (_aspxIsExists(obj.removeAttribute))
        obj.removeAttribute(attrName);
    else if (_aspxIsExists(obj.removeProperty))
        obj.removeProperty(attrName);
}
function _aspxIsExistsAttribute(obj, attrName) {
    var value = _aspxGetAttribute(obj, attrName);
    return (value != null) && (value != "");
}
function _aspxSetOrRemoveAttribute(obj, attrName, value) {
    if (!value)
        _aspxRemoveAttribute(obj, attrName);
    else
        _aspxSetAttribute(obj, attrName, value);
}
function _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName) {
    if (!_aspxIsExistsAttribute(savedObj, savedAttrName)) {
        var oldValue = _aspxIsExistsAttribute(obj, attrName) ? _aspxGetAttribute(obj, attrName) : __aspxEmptyAttributeValue;
        _aspxSetAttribute(savedObj, savedAttrName, oldValue);
    }
}
function _aspxChangeAttributeExtended(obj, attrName, savedObj, savedAttrName, newValue) {
    _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName);
    _aspxSetAttribute(obj, attrName, newValue);
}
function _aspxChangeAttribute(obj, attrName, newValue) {
    _aspxChangeAttributeExtended(obj, attrName, obj, "saved" + attrName, newValue);
}
function _aspxChangeStyleAttribute(obj, attrName, newValue) {
    _aspxChangeAttributeExtended(obj.style, attrName, obj, "saved" + attrName, newValue);
}
function _aspxResetAttributeExtended(obj, attrName, savedObj, savedAttrName) {
    _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName);
    _aspxSetAttribute(obj, attrName, "");
    _aspxRemoveAttribute(obj, attrName);
}
function _aspxResetAttribute(obj, attrName) {
    _aspxResetAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
function _aspxResetStyleAttribute(obj, attrName) {
    _aspxResetAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
function _aspxRestoreAttributeExtended(obj, attrName, savedObj, savedAttrName) {
    if (_aspxIsExistsAttribute(savedObj, savedAttrName)) {
        var oldValue = _aspxGetAttribute(savedObj, savedAttrName);
        if (oldValue != __aspxEmptyAttributeValue)
            _aspxSetAttribute(obj, attrName, oldValue);
        else
            _aspxRemoveAttribute(obj, attrName);
        _aspxRemoveAttribute(savedObj, savedAttrName);
    }
}
function _aspxRestoreAttribute(obj, attrName) {
    _aspxRestoreAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
function _aspxRestoreStyleAttribute(obj, attrName) {
    _aspxRestoreAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
function _aspxCopyAllAttributes(sourceElem, destElement) {
    var attrs = sourceElem.attributes;
    for (var n = 0; n < attrs.length; n++) {
        var attr = attrs[n];
        if (attr.specified) {
            var attrName = attr.nodeName;
            var attrValue = sourceElem.getAttribute(attrName, 2);
            if (attrValue == null)
                attrValue = attr.nodeValue;
            destElement.setAttribute(attrName, attrValue, 0);
        }
    }
    if (sourceElem.style.cssText !== '')
        destElement.style.cssText = sourceElem.style.cssText;
}
function _aspxRemoveAllAttributes(element, excludedAttributes) {
    var excludedAttributesHashTable = {};
    if (_aspxIsExists(excludedAttributes))
        excludedAttributesHashTable = _aspxCreateHashTableFromArray(excludedAttributes);
    if (_aspxIsExists(element.attributes)) {
        var attrArray = element.attributes;
        for (var i = 0; i < attrArray.length; i++) {
            var attrName = attrArray[i].name;
            if (!_aspxIsExists(excludedAttributesHashTable[attrName.toLowerCase()])) {
                try {
                    attrArray.removeNamedItem(attrName);
                } catch (e) { }
            }
        }
    }
}
function _aspxRemoveStyleAttribute(element, attrName) {
    if (_aspxIsExists(element.style)) {
        if (__aspxFirefox && element.style[attrName])
            element.style[attrName] = "";
        if (_aspxIsExists(element.style.removeAttribute) && element.style.removeAttribute != "")
            element.style.removeAttribute(attrName);
        else if (_aspxIsExists(element.style.removeProperty) && element.style.removeProperty != "")
            element.style.removeProperty(attrName);
    }
}
function _aspxRemoveAllStyles(element) {
    if (_aspxIsExists(element.style)) {
        for (var key in element.style)
            _aspxRemoveStyleAttribute(element, key);
        _aspxRemoveAttribute(element, "style");
    }
}
function _aspxChangeAttributesMethod(enabled) {
    return enabled ? _aspxRestoreAttribute : _aspxResetAttribute;
}
function _aspxInitiallyChangeAttributesMethod(enabled) {
    return enabled ? _aspxChangeAttribute : _aspxResetAttribute;
}
function _aspxChangeStyleAttributesMethod(enabled) {
    return enabled ? _aspxRestoreStyleAttribute : _aspxResetStyleAttribute;
}
function _aspxInitiallyChangeStyleAttributesMethod(enabled) {
    return enabled ? _aspxChangeStyleAttribute : _aspxResetStyleAttribute;
}
function _aspxChangeEventsMethod(enabled) {
    return enabled ? _aspxAttachEventToElement : _aspxDetachEventFromElement;
}
function _aspxChangeDocumentEventsMethod(enabled) {
    return enabled ? _aspxAttachEventToDocument : _aspxDetachEventFromDocument;
}
function _aspxTrimStart(str) {
    var re = /\s*((\S+\s*)*)/;
    return str.replace(re, "$1");
}
function _aspxTrimEnd(str) {
    var re = /((\s*\S+)*)\s*/;
    return str.replace(re, "$1");
}
function _aspxTrim(str) {
    return _aspxTrimStart(_aspxTrimEnd(str));
}
function _aspxInsert(str, subStr, index) {
    var leftText = str.slice(0, index);
    var rightText = str.slice(index);
    return leftText + subStr + rightText;
}
function _aspxInsertEx(str, subStr, startIndex, endIndex) {
    var leftText = str.slice(0, startIndex);
    var rightText = str.slice(endIndex);
    return leftText + subStr + rightText;
}
function _aspxNavigateUrl(url, target) {
    var javascriptPrefix = "javascript:";
    if (url == "")
        return;
    else if (url.indexOf(javascriptPrefix) != -1)
        eval(url.substr(javascriptPrefix.length));
    else {
        if (target != "")
            _aspxNavigateTo(url, target);
        else
            location.href = url;
    }
}
function _aspxNavigateTo(url, target) {
    var lowerCaseTarget = target.toLowerCase();
    if ("_top" == lowerCaseTarget)
        top.location.href = url;
    else if ("_self" == lowerCaseTarget)
        location.href = url;
    else if ("_search" == lowerCaseTarget)
        window.open(url, 'blank');
    else if ("_media" == lowerCaseTarget)
        window.open(url, 'blank');
    else if ("_parent" == lowerCaseTarget)
        window.parent.location.href = url;
    else if ("_blank" == lowerCaseTarget)
        window.open(url, 'blank');
    else {
        var frame = _aspxGetFrame(top.frames, target);
        if (frame != null)
            frame.location.href = url;
        else
            window.open(url, 'blank');
    }
}
function _aspxGetFrame(frames, name) {
    if (_aspxIsExists(frames[name]))
        return frames[name];
    for (var i = 0; i < frames.length; i++) {
        try {
            var frame = frames[i];
            if (frame.name == name)
                return frame;
            frame = _aspxGetFrame(frame.frames, name);
            if (frame != null)
                return frame;
        } catch (e) {
        }
    }
    return null;
}
function _aspxToHex(d) {
    return (d < 16) ? ("0" + d.toString(16)) : d.toString(16);
}
function _aspxColorToHexadecimal(colorValue) {
    if (typeof (colorValue) == "number") {
        var r = colorValue & 0xFF;
        var g = (colorValue >> 8) & 0xFF;
        var b = (colorValue >> 16) & 0xFF;
        return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
    }
    if (colorValue && (colorValue.substr(0, 3).toLowerCase() == "rgb")) {
        var re = /rgb\s*\(\s*([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)\s*\)/;
        var regResult = colorValue.match(re);
        if (regResult) {
            var r = parseInt(regResult[1]);
            var g = parseInt(regResult[2]);
            var b = parseInt(regResult[3]);
            return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
        }
        return null;
    }
    if (colorValue && (colorValue.charAt(0) == "#"))
        return colorValue;
    return null;
}
function _aspxFormatCallbackArg(prefix, arg) {
    if (prefix == null && arg == null)
        return "";
    if (prefix == null) prefix = "";
    if (arg == null) arg = "";
    if (arg != null && !_aspxIsExists(arg.length) && _aspxIsExists(arg.value))
        arg = arg.value;
    arg = arg.toString();
    return [prefix, '|', arg.length, '|', arg].join('');
}
function _aspxFormatCallbackArgs(callbackData) {
    var sb = new ASPxStringBuilder();
    for (var i = 0; i < callbackData.length; i++)
        sb.Append(_aspxFormatCallbackArg(callbackData[i][0], callbackData[i][1]));
    return sb.ToString();
}
function _aspxIsValidElement(element) {
    if (__aspxIE)
        return _aspxIsExists(element.parentNode) && _aspxIsExists(element.parentNode.tagName);
    else {
        if (!__aspxOpera && element.offsetParent != null)
            return true;
        while (element != null) {
            if (_aspxIsExists(element.tagName) && element.tagName == "BODY")
                return true;
            element = element.parentNode;
        }
        return false;
    }
}
function _aspxIsValidElements(elements) {
    if (!_aspxIsExists(elements))
        return false;
    for (var i = 0; i < elements.length; i++) {
        if (_aspxIsExists(elements[i]) && !_aspxIsValidElement(elements[i]))
            return false;
    }
    return true;
}
function _aspxIsExistsElement(element) {
    return _aspxIsExists(element) && _aspxIsValidElement(element);
}
ASPxClientEvent = _aspxCreateClass(null, {
    constructor: function() {
        this.handlerInfoList = [];
    },
    AddHandler: function(handler, executionContext) {
        if (typeof (executionContext) == "undefined")
            executionContext = null;
        var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
        this.handlerInfoList.push(handlerInfo);
    },
    RemoveHandler: function(handler, executionContext) {
        for (var i = this.handlerInfoList.length - 1; i >= 0; i--) {
            var handlerInfo = this.handlerInfoList[i];
            if (handlerInfo.handler == handler && (!executionContext || handlerInfo.executionContext == executionContext)) {
                _aspxArrayRemoveAt(this.handlerInfoList, i);
                return;
            }
        }
    },
    ClearHandlers: function() {
        this.handlerInfoList.length = 0;
    },
    FireEvent: function(obj, args) {
        for (var i = 0; i < this.handlerInfoList.length; i++) {
            var handlerInfo = this.handlerInfoList[i];
            handlerInfo.handler.call(handlerInfo.executionContext, obj, args);
        }
    },
    IsEmpty: function() {
        return this.handlerInfoList.length == 0;
    }
});
ASPxClientEvent.CreateHandlerInfo = function(handler, executionContext) {
    var info = new Object();
    info.handler = handler;
    info.executionContext = executionContext;
    return info;
};
ASPxClientEventArgs = _aspxCreateClass(null, {
    constructor: function() {
    }
});
ASPxClientEventArgs.Empty = new ASPxClientEventArgs();
ASPxClientProcessingModeEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(processOnServer) {
        this.constructor.prototype.constructor.call(this);
        this.processOnServer = processOnServer;
    }
});
ASPxClientCancelEventArgs = _aspxCreateClass(ASPxClientProcessingModeEventArgs, {
    constructor: function(processOnServer) {
        this.constructor.prototype.constructor.call(this, processOnServer);
        this.cancel = false;
    }
});
ASPxClientBeginCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(command) {
        this.constructor.prototype.constructor.call(this);
        this.command = command;
    }
});
ASPxClientEndCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function() {
        this.constructor.prototype.constructor.call(this);
    }
});
ASPxClientCustomDataCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(result) {
        this.constructor.prototype.constructor.call(this);
        this.result = result;
    }
});
ASPxClientCallbackErrorEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(message) {
        this.constructor.prototype.constructor.call(this);
        this.message = message;
        this.handled = false;
    }
});
if (_aspxIsFunction(window.WebForm_InitCallbackAddField)) {
    (function() {
        var original = window.WebForm_InitCallbackAddField;
        window.WebForm_InitCallbackAddField = function(name, value) {
            if (typeof (name) == "string" && name)
                original.apply(null, arguments);
        };
    })();
}
ASPxPostHandler = _aspxCreateClass(null, {
    constructor: function() {
        this.Post = new ASPxClientEvent();
        this.ReplaceGlobalPostFunctions();
        this.HandleDxCallbackBeginning();
        this.HandleMSAjaxRequestBeginning();
    },
    OnPost: function() {
        this.Post.FireEvent(this, ASPxClientEventArgs.Empty);
    },
    ReplaceGlobalPostFunctions: function() {
        if (_aspxIsFunction(window.__doPostBack))
            this.ReplaceDoPostBack();
        if (_aspxIsFunction(window.WebForm_DoCallback))
            this.ReplaceDoCallback();
        var form = _aspxGetServerForm();
        if (form == null)
            return;
        if (form.submit)
            this.ReplaceFormSubmit(form);
        this.ReplaceFormOnSumbit(form);
        form = null;
    },
    HandleDxCallbackBeginning: function() {
        aspxGetControlCollection().BeforeInitCallback.AddHandler(function() {
            _aspxRaisePostHandlerOnPost(false, true);
        });
    },
    HandleMSAjaxRequestBeginning: function() {
        if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance) {
            var pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
            if (pageRequestManager != null && ASPxIdent.IsArray(pageRequestManager._onSubmitStatements)) {
                pageRequestManager._onSubmitStatements.unshift(function() {
                    _aspxRaisePostHandlerOnPost(true); return true;
                });
            }
        }
    },
    ReplaceDoPostBack: function() {
        var original = __doPostBack;
        __doPostBack = function(eventTarget, eventArgument) {
            _aspxRaisePostHandlerOnPost();
            original(eventTarget, eventArgument);
        };
    },
    ReplaceDoCallback: function() {
        var original = WebForm_DoCallback;
        WebForm_DoCallback = function(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {
            var postHandler = aspxGetPostHandler();
            if (postHandler.dxCallbackHandled)
                delete postHandler.dxCallbackHandled;
            else
                _aspxRaisePostHandlerOnPost();
            return original(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync);
        };
    },
    ReplaceFormSubmit: function(form) {
        var original = form.submit;
        form.submit = function() {
            _aspxRaisePostHandlerOnPost();
            var callee = arguments.callee;
            this.submit = original;
            var submitResult = this.submit();
            this.submit = callee;
            return submitResult;
        };
    },
    ReplaceFormOnSumbit: function(form) {
        var original = form.onsubmit;
        form.onsubmit = function() {
            var postHandler = aspxGetPostHandler();
            if (postHandler.msAjaxRequestBeginningHandled)
                delete postHandler.msAjaxRequestBeginningHandled;
            else
                _aspxRaisePostHandlerOnPost();
            return _aspxIsFunction(original) ? original() : true;
        };
        form = null;
    }
});
function _aspxRaisePostHandlerOnPost(isMSAjaxRequestBeginning, isDXCallbackBeginning) {
    var postHandler = aspxGetPostHandler();
    if (_aspxIsExists(postHandler)) {
        if (isMSAjaxRequestBeginning)
            postHandler.msAjaxRequestBeginningHandled = true;
        else if (isDXCallbackBeginning)
            postHandler.dxCallbackHandled = true;
        postHandler.OnPost();
    }
}
function aspxGetPostHandler() {
    if (!_aspxIsExistsType(typeof (window.__aspxPostHandler)))
        window.__aspxPostHandler = new ASPxPostHandler();
    return window.__aspxPostHandler;
}
ASPxClientControlsInitializedEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(isCallback) {
        this.isCallback = isCallback;
    }
});
ASPxClientControlCollection = _aspxCreateClass(null, {
    constructor: function() {
        this.elements = new Object();
        this.windowResizeSubscribers = [];
        this.prevWndWidth = "";
        this.prevWndHeight = "";
        this.BeforeInitCallback = new ASPxClientEvent();
        this.ControlsInitialized = new ASPxClientEvent();
    },
    Add: function(element) {
        this.elements[element.name] = element;
    },
    Get: function(name) {
        return this.elements[name];
    },
    AdjustControls: function(container, checkSizeCorrectedFlag) {
        window.setTimeout(function() {
            var collection = aspxGetControlCollection();
            collection.ProcessControlsInConatiner(container, checkSizeCorrectedFlag, function(control, check) { control.AdjustControl(check); });
        }, 0);
    },
    CollapseControls: function(container, checkSizeCorrectedFlag) {
        this.ProcessControlsInConatiner(container, checkSizeCorrectedFlag, function(control, check) {
            control.CollapseControl(check);
        });
    },
    AtlasInitialize: function(isCallback) {
        _aspxProcessScriptsAndLinks("", isCallback);
    },
    Initialize: function() {
        this.InitializeElements(false);
        if (_aspxIsExistsType(typeof (Sys)) && _aspxIsExistsType(typeof (Sys.Application)))
            Sys.Application.add_load(aspxCAInit);
        this.InitWindowSizeCache();
    },
    InitializeElements: function(isCallback) {
        for (var name in this.elements) {
            var control = this.elements[name];
            if (!ASPxIdent.IsASPxClientControl(control))
                continue;
            if (!control.isInitialized)
                control.Initialize();
        }
        if (typeof (_aspxGetEditorStretchedInputElementsManager) != "undefined")
            _aspxGetEditorStretchedInputElementsManager().Initialize();
        this.AfterInitializeElements(true);
        this.AfterInitializeElements(false);
        this.RaiseControlsInitialized(isCallback);
    },
    AfterInitializeElements: function(leadingCall) {
        for (var name in this.elements) {
            var control = this.elements[name];
            if (!ASPxIdent.IsASPxClientControl(control))
                continue;
            if (control.leadingAfterInitCall && leadingCall || !control.leadingAfterInitCall && !leadingCall) {
                if (!this.elements[name].isInitialized)
                    this.elements[name].AfterInitialize();
            }
        }
    },
    DoFinalizeCallback: function() {
        for (var name in this.elements) {
            var control = this.elements[name];
            if (!ASPxIdent.IsASPxClientControl(control))
                continue;
            control.DoFinalizeCallback();
        }
    },
    ProcessControlsInConatiner: function(container, checkSizeCorrectedFlag, processingProc) {
        for (var controlName in this.elements) {
            var control = this.elements[controlName];
            if (!ASPxIdent.IsASPxClientControl(control))
                continue;
            if (_aspxIsExists(container) && _aspxIsExists(control.GetMainElement)) {
                var mainElement = control.GetMainElement();
                if (_aspxIsExists(mainElement) && !_aspxGetIsParent(container, mainElement))
                    continue;
            }
            processingProc(control, checkSizeCorrectedFlag);
        }
    },
    RaiseControlsInitialized: function(isCallback) {
        if (!this.ControlsInitialized.IsEmpty()) {
            if (typeof (isCallback) == "undefined")
                isCallback = true;
            var args = new ASPxClientControlsInitializedEventArgs(isCallback);
            this.ControlsInitialized.FireEvent(this, args);
        }
    },
    Before_WebForm_InitCallback: function() {
        var args = new ASPxClientEventArgs();
        this.BeforeInitCallback.FireEvent(this, args);
    },
    InitWindowSizeCache: function() {
        this.prevWndWidth = document.documentElement.clientWidth;
        this.prevWndHeight = document.documentElement.clientHeight;
    },
    BrowserWindowSizeChanged: function() {
        var wndWidth = document.documentElement.clientWidth;
        var wndHeight = document.documentElement.clientHeight;
        var browserWindowSizeChanged = (this.prevWndWidth != wndWidth) || (this.prevWndHeight != wndHeight);
        if (browserWindowSizeChanged) {
            this.prevWndWidth = wndWidth;
            this.prevWndHeight = wndHeight;
            return true;
        }
        return false;
    },
    SubscribeObjectToBrowserWindowResize: function(object) {
        this.windowResizeSubscribers.push(object);
    },
    OnBrowserWindowResize: function(evt) {
        if (this.BrowserWindowSizeChanged()) {
            for (var i = 0; i < this.windowResizeSubscribers.length; i++)
                this.windowResizeSubscribers[i].OnBrowserWindowResize(evt);
        }
    }
});
ASPxClientControl = _aspxCreateClass(null, {
    constructor: function(name) {
        this.isASPxClientControl = true;
        this.name = name;
        this.uniqueID = name;
        this.enabled = true;
        this.clientEnabled = true;
        this.clientVisible = true;
        this.autoPostBack = false;
        this.allowMultipleCallbacks = true;
        this.callBack = null;
        this.savedCallbacks = null;
        this.isNative = false;
        this.requestCount = 0;
        this.isInitialized = false;
        this.initialFocused = false;
        this.leadingAfterInitCall = false;
        this.sizeCorrectedOnce = false;
        this.serverEvents = [];
        this.dialogContentHashTable = {};
        this.sizeCorrectedOnce = false;
        this.loadingPanelElement = null;
        this.loadingDivElement = null;
        this.mainElement = null;
        this.renderIFrameForPopupElements = false;
        this.Init = new ASPxClientEvent();
        this.BeginCallback = new ASPxClientEvent();
        this.EndCallback = new ASPxClientEvent();
        this.CallbackError = new ASPxClientEvent();
        this.CustomDataCallback = new ASPxClientEvent();
        aspxGetControlCollection().Add(this);
    },
    Initialize: function() {
        if (this.callBack != null)
            this.InitializeCallBackData();
    },
    InlineInitialize: function() {
    },
    InitailizeFocus: function() {
        if (this.initialFocused && this.IsVisible())
            this.Focus();
    },
    AfterInitialize: function() {
        this.AdjustControl(__aspxCheckSizeCorrectedFlag);
        this.InitailizeFocus();
        this.isInitialized = true;
        this.RaiseInit();
        if (_aspxIsExists(this.savedCallbacks)) {
            for (var i = 0; i < this.savedCallbacks.length; i++)
                this.CreateCallbackInternal(this.savedCallbacks[i].arg, this.savedCallbacks[i].command,
     false, this.savedCallbacks[i].callbackInfo);
            this.savedCallbacks = null;
        }
    },
    InitializeCallBackData: function() {
    },
    CollapseControl: function(checkSizeCorrectedFlag) {
    },
    AdjustControl: function(checkSizeCorrectedFlag, nestedCall) {
        if (checkSizeCorrectedFlag && this.sizeCorrectedOnce || ASPxClientControl.adjustControlLocked && !nestedCall)
            return;
        ASPxClientControl.adjustControlLocked = true;
        try {
            var mainElement = this.GetMainElement();
            if (!_aspxIsExists(mainElement) || !this.IsDisplayed())
                return;
            this.AdjustControlCore();
            this.sizeCorrectedOnce = true;
        } finally {
            delete ASPxClientControl.adjustControlLocked;
        }
    },
    AdjustControlCore: function() {
    },
    OnBrowserWindowResize: function(evt) {
    },
    RegisterServerEventAssigned: function(eventNames) {
        for (var i = 0; i < eventNames.length; i++)
            this.serverEvents[eventNames[i]] = true;
    },
    IsServerEventAssigned: function(eventName) {
        return _aspxIsExists(this.serverEvents[eventName]);
    },
    GetChild: function(idPostfix) {
        var mainElement = this.GetMainElement();
        return _aspxIsExists(mainElement) ? _aspxGetChildById(mainElement, this.name + idPostfix) : null;
    },
    GetItemElementName: function(element) {
        var name = "";
        if (_aspxIsExists(element.id))
            name = element.id.substring(this.name.length + 1);
        return name;
    },
    GetLinkElement: function(element) {
        if (element == null) return null;
        return (element.tagName == "A") ? element : _aspxGetChildByTagName(element, "A", 0);
    },
    GetInternalHyperlinkElement: function(parentElement, index) {
        var element = _aspxGetChildByTagName(parentElement, "A", index);
        if (element == null)
            element = _aspxGetChildByTagName(parentElement, "SPAN", index);
        return element;
    },
    GetMainElement: function() {
        if (!_aspxIsExistsElement(this.mainElement))
            this.mainElement = _aspxGetElementById(this.name);
        return this.mainElement;
    },
    IsRightToLeft: function() {
        return _aspxIsElementRigthToLeft(this.GetMainElement());
    },
    OnControlClick: function(clickedElement, htmlEvent) {
    },
    GetLoadingPanelElement: function() {
        return _aspxGetElementById(this.name + "_LP");
    },
    CloneLoadingPanel: function(element, parent) {
        var clone = element.cloneNode(true);
        clone.id = element.id + "V";
        parent.appendChild(clone);
        return clone;
    },
    CreateLoadingPanelInsideContainer: function(parentElement) {
        if (parentElement == null) return null;
        this.HideLoadingPanel();
        var element = this.GetLoadingPanelElement();
        if (element != null) {
            var width = 0;
            var height = 0;
            var itemsTable = _aspxGetChildByTagName(parentElement, "TABLE", 0);
            if (itemsTable != null) {
                width = itemsTable.offsetWidth;
                height = itemsTable.offsetHeight;
            } else if (parentElement.childNodes.length == 0) {
                var dummyDiv = document.createElement("DIV");
                parentElement.appendChild(dummyDiv);
                width = dummyDiv.offsetWidth;
            } else {
                width = parentElement.clientWidth;
                height = parentElement.clientHeight;
            }
            parentElement.innerHTML = "";
            var table = document.createElement("TABLE");
            parentElement.appendChild(table);
            table.border = 0;
            table.cellPadding = 0;
            table.cellSpacing = 0;
            table.style.height = (height > 0) ? height + "px" : "100%";
            table.style.width = (width > 0) ? width + "px" : "100%";
            var tbody = document.createElement("TBODY");
            table.appendChild(tbody);
            var tr = document.createElement("TR");
            tbody.appendChild(tr);
            var td = document.createElement("TD");
            tr.appendChild(td);
            td.align = "center";
            td.vAlign = "middle";
            element = this.CloneLoadingPanel(element, td);
            _aspxSetElementDisplay(element, true);
            this.loadingPanelElement = element;
            return element;
        } else
            parentElement.innerHTML = "&nbsp;";
        return null;
    },
    CreateLoadingPanelWithAbsolutePosition: function(parentElement, offsetElement) {
        if (parentElement == null) return null;
        this.HideLoadingPanel();
        if (!_aspxIsExists(offsetElement))
            offsetElement = parentElement;
        var element = this.GetLoadingPanelElement();
        if (element != null) {
            element = this.CloneLoadingPanel(element, parentElement);
            element.style.position = "absolute";
            _aspxSetElementDisplay(element, true);
            this.SetLoadingPanelLocation(offsetElement, element);
            this.loadingPanelElement = element;
            return element;
        }
        return null;
    },
    CreateLoadingPanelInline: function(parentElement) {
        if (parentElement == null) return null;
        this.HideLoadingPanel();
        var element = this.GetLoadingPanelElement();
        if (element != null) {
            element = this.CloneLoadingPanel(element, parentElement);
            _aspxSetElementDisplay(element, true);
            this.loadingPanelElement = element;
            return element;
        }
        return null;
    },
    HideLoadingPanel: function() {
        if (_aspxIsExistsElement(this.loadingPanelElement)) {
            _aspxRemoveElement(this.loadingPanelElement);
            this.loadingPanelElement = null;
        }
    },
    SetLoadingPanelLocation: function(offsetElement, loadingPanel, x, y, offsetX, offsetY) {
        if (!_aspxIsExists(x) || !_aspxIsExists(y)) {
            var x1 = _aspxGetAbsoluteX(offsetElement) - _aspxGetIEDocumentClientOffset(true);
            var y1 = _aspxGetAbsoluteY(offsetElement) - _aspxGetIEDocumentClientOffset(false);
            var x2 = x1;
            var y2 = y1;
            if (offsetElement == document.body) {
                x2 += _aspxGetDocumentMaxClientWidth();
                y2 += _aspxGetDocumentMaxClientHeight();
            }
            else {
                x2 += offsetElement.offsetWidth;
                y2 += offsetElement.offsetHeight;
            }
            if (x1 < _aspxGetDocumentScrollLeft())
                x1 = _aspxGetDocumentScrollLeft();
            if (y1 < _aspxGetDocumentScrollTop())
                y1 = _aspxGetDocumentScrollTop();
            if (x2 > _aspxGetDocumentScrollLeft() + _aspxGetDocumentClientWidth())
                x2 = _aspxGetDocumentScrollLeft() + _aspxGetDocumentClientWidth();
            if (y2 > _aspxGetDocumentScrollTop() + _aspxGetDocumentClientHeight())
                y2 = _aspxGetDocumentScrollTop() + _aspxGetDocumentClientHeight();
            x = x1 + ((x2 - x1 - loadingPanel.offsetWidth) / 2);
            y = y1 + ((y2 - y1 - loadingPanel.offsetHeight) / 2);
        }
        if (_aspxIsExists(offsetX) && _aspxIsExists(offsetY)) {
            x += offsetX;
            y += offsetY;
        }
        loadingPanel.style.left = _aspxPrepareClientPosForElement(x, loadingPanel, true) + "px";
        loadingPanel.style.top = _aspxPrepareClientPosForElement(y, loadingPanel, false) + "px";
    },
    GetLoadingDiv: function() {
        return _aspxGetElementById(this.name + "_LD");
    },
    CreateLoadingDiv: function(parentElement, offsetElement) {
        if (parentElement == null) return null;
        this.HideLoadingDiv();
        if (!_aspxIsExists(offsetElement))
            offsetElement = parentElement;
        var div = this.GetLoadingDiv();
        if (div != null) {
            div = div.cloneNode(true);
            parentElement.appendChild(div);
            _aspxSetElementDisplay(div, true);
            this.SetLoadingDivBounds(offsetElement, div);
            this.loadingDivElement = div;
            return div;
        }
        return null;
    },
    SetLoadingDivBounds: function(offsetElement, loadingDiv) {
        var absX = (offsetElement == document.body) ? 0 : _aspxGetAbsoluteX(offsetElement);
        var absY = (offsetElement == document.body) ? 0 : _aspxGetAbsoluteY(offsetElement);
        loadingDiv.style.left = _aspxPrepareClientPosForElement(absX, loadingDiv, true) + "px";
        loadingDiv.style.top = _aspxPrepareClientPosForElement(absY, loadingDiv, false) + "px";
        var width = (offsetElement == document.body) ? _aspxGetDocumentWidth() : offsetElement.offsetWidth;
        var height = (offsetElement == document.body) ? _aspxGetDocumentHeight() : offsetElement.offsetHeight;
        _aspxSetStyleSize(loadingDiv, width, height);
        var correctedWidth = 2 * width - loadingDiv.offsetWidth;
        if (correctedWidth <= 0) correctedWidth = width;
        var correctedHeight = 2 * height - loadingDiv.offsetHeight;
        if (correctedHeight <= 0) correctedHeight = height;
        _aspxSetStyleSize(loadingDiv, correctedWidth, correctedHeight);
    },
    HideLoadingDiv: function() {
        if (_aspxIsExistsElement(this.loadingDivElement)) {
            _aspxRemoveElement(this.loadingDivElement);
            this.loadingDivElement = null;
        }
    },
    RaiseInit: function() {
        if (!this.Init.IsEmpty()) {
            var args = new ASPxClientEventArgs();
            this.Init.FireEvent(this, args);
        }
    },
    RaiseBeginCallback: function(command) {
        if (!this.BeginCallback.IsEmpty()) {
            var args = new ASPxClientBeginCallbackEventArgs(command);
            this.BeginCallback.FireEvent(this, args);
        }
        if (_aspxIsExistsType(typeof (aspxGetGlobalEvents)))
            aspxGetGlobalEvents().OnBeginCallback(this, command);
    },
    RaiseEndCallback: function() {
        if (!this.EndCallback.IsEmpty()) {
            var args = new ASPxClientEndCallbackEventArgs();
            this.EndCallback.FireEvent(this, args);
        }
        if (_aspxIsExistsType(typeof (aspxGetGlobalEvents)))
            aspxGetGlobalEvents().OnEndCallback(this);
    },
    RaiseCallbackError: function(message) {
        if (!this.CallbackError.IsEmpty()) {
            var args = new ASPxClientCallbackErrorEventArgs(message);
            this.CallbackError.FireEvent(this, args);
            if (args.handled)
                return { isHandled: true, errorMessage: args.message };
        }
        if (_aspxIsExistsType(typeof (aspxGetGlobalEvents))) {
            var args = new ASPxClientCallbackErrorEventArgs(message);
            aspxGetGlobalEvents().OnCallbackError(this, args);
            if (args.handled)
                return { isHandled: true, errorMessage: args.message };
        }
        return { isHandled: false, errorMessage: message };
    },
    IsVisible: function() {
        var element = this.GetMainElement();
        while (_aspxIsExists(element) && element.tagName != "BODY") {
            if (!_aspxGetElementVisibility(element) || !_aspxGetElementDisplay(element))
                return false;
            element = element.parentNode;
        }
        return true;
    },
    IsDisplayed: function() {
        var element = this.GetMainElement();
        while (_aspxIsExists(element) && element.tagName != "BODY") {
            if (!_aspxGetElementDisplay(element))
                return false;
            element = element.parentNode;
        }
        return true;
    },
    Focus: function() {
    },
    GetClientVisible: function() {
        return this.GetVisible();
    },
    SetClientVisible: function(visible) {
        this.SetVisible(visible);
    },
    GetVisible: function() {
        return this.clientVisible;
    },
    SetVisible: function(visible) {
        if (this.clientVisible != visible) {
            this.clientVisible = visible;
            _aspxSetElementDisplay(this.GetMainElement(), visible);
            if (visible) {
                this.AdjustControl(__aspxCheckSizeCorrectedFlag);
                var mainElement = this.GetMainElement();
                if (_aspxIsExists(mainElement))
                    aspxGetControlCollection().AdjustControls(mainElement, __aspxCheckSizeCorrectedFlag);
            }
        }
    },
    InCallback: function() {
        return this.requestCount > 0;
    },
    DoBeginCallback: function(command) {
        if (!_aspxIsExists(command)) command = "";
        this.RaiseBeginCallback(command);
        aspxGetControlCollection().Before_WebForm_InitCallback();
        if (_aspxIsExistsType(typeof (WebForm_InitCallback)) && _aspxIsExists(WebForm_InitCallback)) {
            __theFormPostData = "";
            __theFormPostCollection = new Array();
            this.ClearPostBackEventInput("__EVENTTARGET");
            this.ClearPostBackEventInput("__EVENTARGUMENT");
            WebForm_InitCallback();
            this.savedFormPostData = __theFormPostData;
            this.savedFormPostCollection = __theFormPostCollection;
        }
    },
    ClearPostBackEventInput: function(id) {
        var element = _aspxGetElementById(id);
        if (element != null) element.value = "";
    },
    PerformDataCallback: function(arg, handler) {
        this.CreateCustomDataCallback(arg, "", handler);
    },
    CreateCallback: function(arg, command) {
        var callbackInfo = this.CreateCallbackInfo(ASPxCallbackType.Common, null);
        this.CreateCallbackByInfo(arg, command, callbackInfo);
    },
    CreateCustomDataCallback: function(arg, command, handler) {
        var callbackInfo = this.CreateCallbackInfo(ASPxCallbackType.Data, handler);
        this.CreateCallbackByInfo(arg, command, callbackInfo);
    },
    CreateCallbackByInfo: function(arg, command, callbackInfo) {
        if (_aspxIsExistsType(typeof (WebForm_DoCallback)) && _aspxIsExists(WebForm_DoCallback))
            this.CreateCallbackInternal(arg, command, true, callbackInfo);
        else {
            if (!_aspxIsExists(this.savedCallbacks))
                this.savedCallbacks = [];
            this.savedCallbacks.push({ arg: arg, command: command, callbackInfo: callbackInfo });
        }
    },
    CreateCallbackInternal: function(arg, command, viaTimer, callbackInfo) {
        if (!this.CanCreateCallback())
            return;
        this.requestCount++;
        this.DoBeginCallback(command);
        if (typeof (arg) == "undefined")
            arg = "";
        if (typeof (command) == "undefined")
            command = "";
        var callbackID = this.SaveCallbackInfo(callbackInfo);
        if (viaTimer)
            window.setTimeout("aspxCreateCallback('" + this.name + "', '" + escape(arg) + "', '" + escape(command) + "', " + callbackID + ");", 0);
        else
            this.CreateCallbackCore(arg, command, callbackID);
    },
    CreateCallbackCore: function(arg, command, callbackID) {
        __theFormPostData = this.savedFormPostData;
        __theFormPostCollection = this.savedFormPostCollection;
        this.callBack(this.GetSerializedCallbackInfoByID(callbackID) + arg);
    },
    CanCreateCallback: function() {
        return this.allowMultipleCallbacks || !this.InCallback();
    },
    DoLoadCallbackScripts: function() {
        _aspxProcessScriptsAndLinks(this.name);
    },
    DoEndCallback: function() {
        this.RaiseEndCallback();
    },
    DoFinalizeCallback: function() {
    },
    HideLoadingPanelOnCallback: function() {
        return true;
    },
    DoCallback: function(result) {
        this.requestCount--;
        if (this.HideLoadingPanelOnCallback()) {
            this.HideLoadingDiv();
            this.HideLoadingPanel();
        }
        if (result.indexOf(__aspxCallbackResultPrefix) != 0)
            this.ProcessCallbackGeneralError(result);
        else {
            var resultObj = null;
            try {
                resultObj = eval(result);
            }
            catch (e) {
            }
            if (_aspxIsExists(resultObj)) {
                if (_aspxIsExists(resultObj.redirect))
                    window.location.href = resultObj.redirect;
                else if (_aspxIsExists(resultObj.generalError))
                    this.ProcessCallbackGeneralError(resultObj.generalError);
                else {
                    var errorObj = resultObj.error;
                    if (_aspxIsExists(errorObj))
                        this.ProcessCallbackError(errorObj);
                    else {
                        if (resultObj.cp) {
                            for (var name in resultObj.cp)
                                this[name] = resultObj.cp[name];
                        }
                        var callbackInfo = this.DequeueCallbackInfo(resultObj.id);
                        if (callbackInfo.type == ASPxCallbackType.Data)
                            this.ProcessCustomDataCallback(resultObj.result, callbackInfo);
                        else
                            this.ProcessCallback(resultObj.result);
                    }
                    this.DoLoadCallbackScripts();
                }
            }
        }
    },
    DoCallbackError: function(result) {
        this.HideLoadingDiv();
        this.HideLoadingPanel();
        this.OnCallbackGeneralError(result);
    },
    DoControlClick: function(evt) {
        this.OnControlClick(_aspxGetEventSource(evt), evt);
    },
    ProcessCallback: function(result) {
        this.OnCallback(result);
    },
    ProcessCustomDataCallback: function(result, callbackInfo) {
        if (callbackInfo.handler != null)
            callbackInfo.handler(this, result);
        this.RaiseCustomDataCallback(result);
    },
    RaiseCustomDataCallback: function(result) {
        if (!this.CustomDataCallback.IsEmpty()) {
            var arg = new ASPxClientCustomDataCallbackEventArgs(result);
            this.CustomDataCallback.FireEvent(this, arg);
        }
    },
    OnCallback: function(result) {
    },
    CreateCallbackInfo: function(type, handler) {
        return { type: type, handler: handler };
    },
    GetSerializedCallbackInfoByID: function(callbackID) {
        return this.GetCallbackInfoByID(callbackID).type + callbackID + __aspxCallbackSeparator;
    },
    SaveCallbackInfo: function(callbackInfo) {
        var activeCallbacksInfo = this.GetActiveCallbacksInfo();
        for (var i = 0; i < activeCallbacksInfo.length; i++) {
            if (activeCallbacksInfo[i] == null) {
                activeCallbacksInfo[i] = callbackInfo;
                return i;
            }
        }
        activeCallbacksInfo.push(callbackInfo);
        return activeCallbacksInfo.length - 1;
    },
    GetActiveCallbacksInfo: function() {
        var persistentProperties = this.GetPersistentProperties();
        if (!persistentProperties.activeCallbacks)
            persistentProperties.activeCallbacks = [];
        return persistentProperties.activeCallbacks;
    },
    GetPersistentProperties: function() {
        var storage = _aspxGetPersistentControlPropertiesStorage();
        var persistentProperties = storage[this.name];
        if (!persistentProperties) {
            persistentProperties = {};
            storage[this.name] = persistentProperties;
        }
        return persistentProperties;
    },
    GetCallbackInfoByID: function(callbackID) {
        return this.GetActiveCallbacksInfo()[callbackID];
    },
    DequeueCallbackInfo: function(index) {
        var activeCallbacksInfo = this.GetActiveCallbacksInfo();
        if (index < 0 || index >= activeCallbacksInfo.length)
            return null;
        var result = activeCallbacksInfo[index];
        activeCallbacksInfo[index] = null;
        return result;
    },
    ProcessCallbackError: function(errorObj) {
        var data = _aspxIsExists(errorObj.data) ? errorObj.data : null;
        var result = this.RaiseCallbackError(errorObj.message);
        if (!result.isHandled)
            this.OnCallbackError(result.errorMessage, data);
    },
    OnCallbackError: function(errorMessage, data) {
        if (errorMessage)
            alert(errorMessage);
    },
    ProcessCallbackGeneralError: function(errorMessage) {
        var result = this.RaiseCallbackError(errorMessage);
        if (!result.isHandled)
            this.OnCallbackGeneralError(result.errorMessage);
    },
    OnCallbackGeneralError: function(errorMessage) {
        this.OnCallbackError(errorMessage, null);
    },
    SendPostBack: function(params) {
        __doPostBack(this.uniqueID, params);
    }
});
ASPxIdent = {};
ASPxIdent.IsDate = function(obj) {
    return _aspxIsExists(obj) && obj.constructor == Date;
};
ASPxIdent.IsRegExp = function(obj) {
    return _aspxIsExists(obj) && obj.constructor === RegExp;
};
ASPxIdent.IsArray = function(obj) {
    return _aspxIsExists(obj) && obj.constructor == Array;
};
ASPxIdent.IsASPxClientControl = function(obj) {
    return obj != null && _aspxIsExists(obj.isASPxClientControl) && obj.isASPxClientControl;
};
ASPxIdent.IsASPxClientEdit = function(obj) {
    return _aspxIsExists(obj.isASPxClientEdit) && obj.isASPxClientEdit;
};
ASPxClientControl.GetControlCollection = function() {
    return aspxGetControlCollection();
}
var __aspxControlCollection = null;
function aspxGetControlCollection() {
    if (__aspxControlCollection == null)
        __aspxControlCollection = new ASPxClientControlCollection();
    return __aspxControlCollection;
}
var __aspxPersistentControlPropertiesStorage = null;
function _aspxGetPersistentControlPropertiesStorage() {
    if (__aspxPersistentControlPropertiesStorage == null)
        __aspxPersistentControlPropertiesStorage = {};
    return __aspxPersistentControlPropertiesStorage;
}
function _aspxFunctionIsInCallstack(currentCallee, targetFunction, depthLimit) {
    var candidate = currentCallee;
    var depth = 0;
    while (candidate && depth <= depthLimit) {
        candidate = candidate.caller;
        if (candidate == targetFunction)
            return true;
        depth++;
    }
    return false;
}
function aspxCAInit() {
    var isAppInit = typeof (Sys$_Application$_doInitialize) != "undefined" &&
  _aspxFunctionIsInCallstack(arguments.callee, Sys$_Application$_doInitialize, 10);
    aspxGetControlCollection().AtlasInitialize(!isAppInit);
}
function aspxCreateCallback(name, arg, command, callbackID) {
    var control = aspxGetControlCollection().Get(name);
    if (control != null)
        control.CreateCallbackCore(unescape(arg), unescape(command), callbackID);
}
function aspxCallback(result, context) {
    var collection = aspxGetControlCollection();
    collection.DoFinalizeCallback();
    var control = collection.Get(context);
    if (control != null)
        control.DoCallback(result);
}
function aspxCallbackError(result, context) {
    var control = aspxGetControlCollection().Get(context);
    if (control != null)
        control.DoCallbackError(result, false);
}
function aspxCClick(name, evt) {
    var control = aspxGetControlCollection().Get(name);
    if (control != null) control.DoControlClick(evt);
}
var __aspxStateItemsExist = false;
var __aspxHoverStyleSheet = null;
var __aspxPressedStyleSheet = null;
var __aspxSelectedStyleSheet = null;
var __aspxDisabledStyleSheet = null;
var __aspxFocusedItemKind = "FocusedStateItem";
var __aspxHoverItemKind = "HoverStateItem";
var __aspxPressedItemKind = "PressedStateItem";
var __aspxSelectedItemKind = "SelectedStateItem";
var __aspxDisabledItemKind = "DisabledStateItem";
var __aspxStyleCount = 0;
var __aspxStyleNameCache = new Object();
function _aspxCreateImportantStyleRule(styleSheet, cssText) {
    if (_aspxIsExists(__aspxStyleNameCache[cssText]))
        return __aspxStyleNameCache[cssText];
    var newText = "";
    var attributes = cssText.split(";");
    for (var i = 0; i < attributes.length; i++) {
        if (attributes[i] != "")
            newText += attributes[i] + " !important;";
    }
    var className = "dxh" + __aspxStyleCount;
    _aspxAddStyleSheetRule(styleSheet, "." + className, newText);
    __aspxStyleCount++;
    __aspxStyleNameCache[cssText] = className;
    return className;
}
ASPxStateItem = _aspxCreateClass(null, {
    constructor: function(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, kind) {
        this.name = name;
        this.classNames = classNames;
        this.customClassNames = [];
        this.resultClassNames = [];
        this.cssTexts = cssTexts;
        this.postfixes = postfixes;
        this.imageUrls = imageUrls;
        this.imagePostfixes = imagePostfixes;
        this.kind = kind;
        this.enabled = true;
        this.needRefreshBetweenElements = false;
        this.elements = null;
        this.images = null;
        this.linkColor = null;
        this.lintTextDecoration = null;
    },
    GetCssText: function(index) {
        if (_aspxIsExists(this.cssTexts[index]))
            return this.cssTexts[index];
        return this.cssTexts[0];
    },
    CreateStyleRule: function(index) {
        if (this.GetCssText(index) == "") return "";
        var styleSheet = this.GetStyleSheet();
        if (_aspxIsExists(styleSheet))
            return _aspxCreateImportantStyleRule(styleSheet, this.GetCssText(index));
        return "";
    },
    GetClassName: function(index) {
        if (_aspxIsExists(this.classNames[index]))
            return this.classNames[index];
        return this.classNames[0];
    },
    GetResultClassName: function(index) {
        if (!_aspxIsExists(this.resultClassNames[index])) {
            if (!_aspxIsExists(this.customClassNames[index]))
                this.customClassNames[index] = this.CreateStyleRule(index);
            if (this.GetClassName(index) != "" && this.customClassNames[index] != "")
                this.resultClassNames[index] = this.GetClassName(index) + " " + this.customClassNames[index];
            else if (this.GetClassName(index) != "")
                this.resultClassNames[index] = this.GetClassName(index);
            else if (this.customClassNames[index] != "")
                this.resultClassNames[index] = this.customClassNames[index];
        }
        return this.resultClassNames[index];
    },
    GetStyleSheet: function() {
        if (!_aspxIsExists(__aspxDisabledStyleSheet))
            __aspxDisabledStyleSheet = _aspxCreateStyleSheet();
        if (!_aspxIsExists(__aspxSelectedStyleSheet))
            __aspxSelectedStyleSheet = _aspxCreateStyleSheet();
        if (!_aspxIsExists(__aspxHoverStyleSheet))
            __aspxHoverStyleSheet = _aspxCreateStyleSheet();
        if (!_aspxIsExists(__aspxPressedStyleSheet))
            __aspxPressedStyleSheet = _aspxCreateStyleSheet();
        switch (this.kind) {
            case __aspxDisabledItemKind:
                return __aspxDisabledStyleSheet;
            case __aspxHoverItemKind:
                return __aspxHoverStyleSheet;
            case __aspxPressedItemKind:
                return __aspxPressedStyleSheet;
            case __aspxSelectedItemKind:
                return __aspxSelectedStyleSheet;
        }
        return null;
    },
    GetElements: function(element) {
        if (!_aspxIsExists(this.elements) || !_aspxIsValidElements(this.elements)) {
            if (_aspxIsExists(this.postfixes) && this.postfixes.length > 0) {
                this.elements = new Array();
                var parentNode = element.parentNode;
                if (_aspxIsExists(parentNode)) {
                    for (var i = 0; i < this.postfixes.length; i++) {
                        var id = this.name + this.postfixes[i];
                        this.elements[i] = _aspxGetChildById(parentNode, id);
                        if (!_aspxIsExists(this.elements[i]))
                            this.elements[i] = _aspxGetElementById(id);
                    }
                }
            }
            else
                this.elements = [element];
        }
        return this.elements;
    },
    GetImages: function(element) {
        if (!_aspxIsExists(this.images) || !_aspxIsValidElements(this.images)) {
            this.images = new Array();
            if (_aspxIsExists(this.imagePostfixes) && this.imagePostfixes.length > 0) {
                var elements = this.GetElements(element);
                for (var i = 0; i < this.imagePostfixes.length; i++) {
                    var id = this.name + this.imagePostfixes[i];
                    for (var j = 0; j < elements.length; j++) {
                        if (!_aspxIsExists(elements[j])) continue;
                        this.images[i] = _aspxGetChildById(elements[j], id);
                        if (_aspxIsExists(this.images[i]))
                            break;
                    }
                }
            }
        }
        return this.images;
    },
    Apply: function(element) {
        if (!this.enabled) return;
        try {
            this.ApplyStyle(element);
            if (_aspxIsExists(this.imageUrls) && this.imageUrls.length > 0)
                this.ApplyImage(element);
        }
        catch (e) {
        }
    },
    ApplyStyle: function(element) {
        var elements = this.GetElements(element);
        for (var i = 0; i < elements.length; i++) {
            if (!_aspxIsExists(elements[i])) continue;
            var className = elements[i].className.replace(this.GetResultClassName(i), "");
            elements[i].className = _aspxTrim(className) + " " + this.GetResultClassName(i);
            if (!__aspxOpera || __aspxBrowserVersion >= 9)
                this.ApplyStyleToLinks(elements, i);
        }
    },
    ApplyStyleToLinks: function(elements, index) {
        var linkCount = 0;
        var savedLinkCount = -1;
        if (_aspxIsExists(elements[index]["savedLinkCount"]))
            savedLinkCount = parseInt(elements[index]["savedLinkCount"]);
        do {
            if (savedLinkCount > -1 && savedLinkCount <= linkCount)
                break;
            var link = elements[index]["link" + linkCount];
            if (!_aspxIsExists(link)) {
                link = _aspxGetChildByTagName(elements[index], "A", linkCount);
                if (!_aspxIsExists(link))
                    link = _aspxGetChildByTagName(elements[index], "SPAN", linkCount);
                if (_aspxIsExists(link))
                    elements[index]["link" + linkCount] = link;
            }
            if (_aspxIsExists(link))
                this.ApplyStyleToLinkElement(link, index);
            else
                elements[index]["savedLinkCount"] = linkCount;
            linkCount++;
        }
        while (link != null)
    },
    ApplyStyleToLinkElement: function(link, index) {
        if (this.GetLinkColor(index) != "")
            _aspxChangeAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color", this.GetLinkColor(index));
        if (this.GetLinkTextDecoration(index) != "")
            _aspxChangeAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration", this.GetLinkTextDecoration(index));
    },
    ApplyImage: function(element) {
        var images = this.GetImages(element);
        for (var i = 0; i < images.length; i++) {
            if (!_aspxIsExists(images[i]) || !_aspxIsExists(this.imageUrls[i]) || this.imageUrls[i] == "") continue;
            if (_aspxIsAlphaFilterUsed(images[i]))
                _aspxChangeAttributeExtended(images[i].style, "filter", images[i], "saved" + this.kind + "Filter",
     "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + this.imageUrls[i] + ", sizingMethod=scale)");
            else
                _aspxChangeAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src", this.imageUrls[i]);
        }
    },
    Cancel: function(element) {
        if (!this.enabled) return;
        try {
            this.CancelStyle(element);
            if (_aspxIsExists(this.imageUrls) && this.imageUrls.length > 0)
                this.CancelImage(element);
        }
        catch (e) {
        }
    },
    CancelStyle: function(element) {
        var elements = this.GetElements(element);
        for (var i = 0; i < elements.length; i++) {
            if (!_aspxIsExists(elements[i])) continue;
            var className = _aspxTrim(elements[i].className.replace(this.GetResultClassName(i), ""));
            elements[i].className = className;
            if (!__aspxOpera || __aspxBrowserVersion >= 9)
                this.CancelStyleFromLinks(elements, i);
        }
    },
    CancelStyleFromLinks: function(elements, index) {
        var linkCount = 0;
        var savedLinkCount = -1;
        if (_aspxIsExists(elements[index]["savedLinkCount"]))
            savedLinkCount = parseInt(elements[index]["savedLinkCount"]);
        do {
            if (savedLinkCount > -1 && savedLinkCount <= linkCount)
                break;
            var link = elements[index]["link" + linkCount];
            if (!_aspxIsExists(link)) {
                link = _aspxGetChildByTagName(elements[index], "A", linkCount);
                if (!_aspxIsExists(link))
                    link = _aspxGetChildByTagName(elements[index], "SPAN", linkCount);
                if (_aspxIsExists(link))
                    elements[index]["link" + linkCount] = link;
            }
            if (_aspxIsExists(link))
                this.CancelStyleFromLinkElement(link, index);
            else
                elements[index]["savedLinkCount"] = linkCount;
            linkCount++;
        }
        while (link != null)
    },
    CancelStyleFromLinkElement: function(link, index) {
        if (this.GetLinkColor(index) != "")
            _aspxRestoreAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color");
        if (this.GetLinkTextDecoration(index) != "")
            _aspxRestoreAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration");
    },
    CancelImage: function(element) {
        var images = this.GetImages(element);
        for (var i = 0; i < images.length; i++) {
            if (!_aspxIsExists(images[i]) || !_aspxIsExists(this.imageUrls[i]) || this.imageUrls[i] == "") continue;
            if (_aspxIsAlphaFilterUsed(images[i]))
                _aspxRestoreAttributeExtended(images[i].style, "filter", images[i], "saved" + this.kind + "Filter");
            else
                _aspxRestoreAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src");
        }
    },
    Clone: function() {
        return new ASPxStateItem(this.name, this.classNames, this.cssTexts, this.postfixes,
   this.imageUrls, this.imagePostfixes, this.kind);
    },
    IsChildElement: function(element) {
        if (element != null) {
            var elements = this.GetElements(element);
            for (var i = 0; i < elements.length; i++) {
                if (!_aspxIsExists(elements[i])) continue;
                if (_aspxGetIsParent(elements[i], element))
                    return true;
            }
        }
        return false;
    },
    GetLinkColor: function(index) {
        if (!_aspxIsExists(this.linkColor)) {
            var rule = _aspxGetStyleSheetRule(this.customClassNames[index]);
            this.linkColor = _aspxIsExists(rule) ? rule.style.color : null;
            if (!_aspxIsExists(this.linkColor)) {
                var rule = _aspxGetStyleSheetRule(this.GetClassName(index));
                this.linkColor = _aspxIsExists(rule) ? rule.style.color : null;
            }
            if (this.linkColor == null)
                this.linkColor = "";
        }
        return this.linkColor;
    },
    GetLinkTextDecoration: function(index) {
        if (!_aspxIsExists(this.linkTextDecoration)) {
            var rule = _aspxGetStyleSheetRule(this.customClassNames[index]);
            this.linkTextDecoration = _aspxIsExists(rule) ? rule.style.textDecoration : null;
            if (!_aspxIsExists(this.linkTextDecoration)) {
                var rule = _aspxGetStyleSheetRule(this.GetClassName(index));
                this.linkTextDecoration = _aspxIsExists(rule) ? rule.style.textDecoration : null;
            }
            if (this.linkTextDecoration == null)
                this.linkTextDecoration = "";
        }
        return this.linkTextDecoration;
    }
});
ASPxClientStateEventArgs = _aspxCreateClass(null, {
    constructor: function(item, element) {
        this.item = item;
        this.element = element;
        this.toElement = null;
        this.fromElement = null;
        this.htmlEvent = null;
    }
});
ASPxStateController = _aspxCreateClass(null, {
    constructor: function() {
        this.focusedItems = new Object();
        this.hoverItems = new Object();
        this.pressedItems = new Object();
        this.selectedItems = new Object();
        this.disabledItems = new Object();
        this.currentFocusedElement = null;
        this.currentFocusedItemName = null;
        this.currentHoverElement = null;
        this.currentHoverItemName = null;
        this.currentPressedElement = null;
        this.currentPressedItemName = null;
        this.savedCurrentPressedElement = null;
        this.savedCurrentMouseMoveSrcElement = null;
        this.AfterSetFocusedState = new ASPxClientEvent();
        this.AfterClearFocusedState = new ASPxClientEvent();
        this.AfterSetHoverState = new ASPxClientEvent();
        this.AfterClearHoverState = new ASPxClientEvent();
        this.AfterSetPressedState = new ASPxClientEvent();
        this.AfterClearPressedState = new ASPxClientEvent();
        this.AfterDisabled = new ASPxClientEvent();
        this.AfterEnabled = new ASPxClientEvent();
        this.BeforeSetFocusedState = new ASPxClientEvent();
        this.BeforeClearFocusedState = new ASPxClientEvent();
        this.BeforeSetHoverState = new ASPxClientEvent();
        this.BeforeClearHoverState = new ASPxClientEvent();
        this.BeforeSetPressedState = new ASPxClientEvent();
        this.BeforeClearPressedState = new ASPxClientEvent();
        this.BeforeDisabled = new ASPxClientEvent();
        this.BeforeEnabled = new ASPxClientEvent();
        this.FocusedItemKeyDown = new ASPxClientEvent();
    },
    AddHoverItem: function(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes) {
        this.AddItem(this.hoverItems, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, __aspxHoverItemKind);
        this.AddItem(this.focusedItems, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, __aspxFocusedItemKind);
    },
    AddPressedItem: function(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes) {
        this.AddItem(this.pressedItems, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, __aspxPressedItemKind);
    },
    AddSelectedItem: function(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes) {
        this.AddItem(this.selectedItems, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, __aspxSelectedItemKind);
    },
    AddDisabledItem: function(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes) {
        this.AddItem(this.disabledItems, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, __aspxDisabledItemKind);
    },
    AddItem: function(items, name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, kind) {
        var stateItem = new ASPxStateItem(name, classNames, cssTexts, postfixes, imageUrls, imagePostfixes, kind);
        if (_aspxIsExists(postfixes) && postfixes.length > 0) {
            for (var i = 0; i < postfixes.length; i++) {
                items[name + postfixes[i]] = stateItem;
            }
        }
        else
            items[name] = stateItem;
        __aspxStateItemsExist = true;
    },
    GetFocusedElement: function(srcElement) {
        return this.GetItemElement(srcElement, this.focusedItems, __aspxFocusedItemKind);
    },
    GetHoverElement: function(srcElement) {
        return this.GetItemElement(srcElement, this.hoverItems, __aspxHoverItemKind);
    },
    GetPressedElement: function(srcElement) {
        return this.GetItemElement(srcElement, this.pressedItems, __aspxPressedItemKind);
    },
    GetSelectedElement: function(srcElement) {
        return this.GetItemElement(srcElement, this.selectedItems, __aspxSelectedItemKind);
    },
    GetDisabledElement: function(srcElement) {
        return this.GetItemElement(srcElement, this.disabledItems, __aspxDisabledItemKind);
    },
    GetItemElement: function(srcElement, items, kind) {
        if (_aspxIsExists(srcElement) && _aspxIsExists(srcElement["cached" + kind])) {
            var cachedElement = srcElement["cached" + kind];
            if (cachedElement != __aspxEmptyCachedValue)
                return cachedElement;
            return null;
        }
        var element = srcElement;
        while (element != null) {
            var item = items[element.id];
            if (_aspxIsExists(item)) {
                this.CacheItemElement(srcElement, kind, element);
                element[kind] = item;
                return element;
            }
            element = element.parentNode;
        }
        this.CacheItemElement(srcElement, kind, __aspxEmptyCachedValue);
        return null;
    },
    CacheItemElement: function(srcElement, kind, value) {
        if (_aspxIsExists(srcElement) && !_aspxIsExists(srcElement["cached" + kind]))
            srcElement["cached" + kind] = value;
    },
    DoSetFocusedState: function(element, fromElement) {
        var item = element[__aspxFocusedItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            args.fromElement = fromElement;
            this.BeforeSetFocusedState.FireEvent(this, args);
            item.Apply(element);
            this.AfterSetFocusedState.FireEvent(this, args);
        }
    },
    DoClearFocusedState: function(element, toElement) {
        var item = element[__aspxFocusedItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            args.toElement = toElement;
            this.BeforeClearFocusedState.FireEvent(this, args);
            item.Cancel(element);
            this.AfterClearFocusedState.FireEvent(this, args);
        }
    },
    DoSetHoverState: function(element, fromElement) {
        var item = element[__aspxHoverItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            args.fromElement = fromElement;
            this.BeforeSetHoverState.FireEvent(this, args);
            item.Apply(element);
            this.AfterSetHoverState.FireEvent(this, args);
        }
    },
    DoClearHoverState: function(element, toElement) {
        var item = element[__aspxHoverItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            args.toElement = toElement;
            this.BeforeClearHoverState.FireEvent(this, args);
            item.Cancel(element);
            this.AfterClearHoverState.FireEvent(this, args);
        }
    },
    DoSetPressedState: function(element) {
        var item = element[__aspxPressedItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            this.BeforeSetPressedState.FireEvent(this, args);
            item.Apply(element);
            this.AfterSetPressedState.FireEvent(this, args);
        }
    },
    DoClearPressedState: function(element) {
        var item = element[__aspxPressedItemKind];
        if (_aspxIsExists(item)) {
            var args = new ASPxClientStateEventArgs(item, element);
            this.BeforeClearPressedState.FireEvent(this, args);
            item.Cancel(element);
            this.AfterClearPressedState.FireEvent(this, args);
        }
    },
    SetCurrentFocusedElement: function(element) {
        if (_aspxIsExists(this.currentFocusedElement) && !_aspxIsValidElement(this.currentFocusedElement)) {
            this.currentFocusedElement = null;
            this.currentFocusedItemName = "";
        }
        if (this.currentFocusedElement != element) {
            var oldCurrentFocusedElement = this.currentFocusedElement;
            var item = (element != null) ? element[__aspxFocusedItemKind] : null;
            var itemName = (item != null) ? item.name : "";
            if (this.currentFocusedItemName != itemName) {
                if (this.currentHoverItemName != "")
                    this.SetCurrentHoverElement(null);
                if (this.currentFocusedElement != null)
                    this.DoClearFocusedState(this.currentFocusedElement, element);
                this.currentFocusedElement = element;
                item = (element != null) ? element[__aspxFocusedItemKind] : null;
                this.currentFocusedItemName = (item != null) ? item.name : "";
                if (this.currentFocusedElement != null)
                    this.DoSetFocusedState(this.currentFocusedElement, oldCurrentFocusedElement);
            }
        }
    },
    SetCurrentHoverElement: function(element) {
        if (_aspxIsExists(this.currentHoverElement) && !_aspxIsValidElement(this.currentHoverElement)) {
            this.currentHoverElement = null;
            this.currentHoverItemName = "";
        }
        if (this.currentHoverElement != element) {
            var oldCurrentHoverElement = this.currentHoverElement;
            var item = (element != null) ? element[__aspxHoverItemKind] : null;
            var itemName = (item != null) ? item.name : "";
            if (this.currentHoverItemName != itemName || (item != null && item.needRefreshBetweenElements)) {
                if (this.currentFocusedItemName != "")
                    this.SetCurrentFocusedElement(null);
                if (this.currentHoverElement != null)
                    this.DoClearHoverState(this.currentHoverElement, element);
                this.currentHoverElement = element;
                item = (element != null) ? element[__aspxHoverItemKind] : null;
                this.currentHoverItemName = (item != null) ? item.name : "";
                if (this.currentHoverElement != null)
                    this.DoSetHoverState(this.currentHoverElement, oldCurrentHoverElement);
            }
        }
    },
    SetCurrentPressedElement: function(element) {
        if (_aspxIsExists(this.currentPressedElement) && !_aspxIsValidElement(this.currentPressedElement)) {
            this.currentPressedElement = null;
            this.currentPressedItemName = "";
        }
        if (this.currentPressedElement != element) {
            if (this.currentPressedElement != null)
                this.DoClearPressedState(this.currentPressedElement);
            this.currentPressedElement = element;
            var item = (element != null) ? element[__aspxPressedItemKind] : null;
            this.currentPressedItemName = (item != null) ? item.name : "";
            if (this.currentPressedElement != null)
                this.DoSetPressedState(this.currentPressedElement);
        }
    },
    SetCurrentFocusedElementBySrcElement: function(srcElement) {
        var element = this.GetFocusedElement(srcElement);
        this.SetCurrentFocusedElement(element);
    },
    SetCurrentHoverElementBySrcElement: function(srcElement) {
        var element = this.GetHoverElement(srcElement);
        this.SetCurrentHoverElement(element);
    },
    SetCurrentPressedElementBySrcElement: function(srcElement) {
        var element = this.GetPressedElement(srcElement);
        this.SetCurrentPressedElement(element);
    },
    SelectElement: function(element) {
        var item = element[__aspxSelectedItemKind];
        if (_aspxIsExists(item))
            item.Apply(element);
    },
    SelectElementBySrcElement: function(srcElement) {
        var element = this.GetSelectedElement(srcElement);
        if (element != null) this.SelectElement(element);
    },
    DeselectElement: function(element) {
        var item = element[__aspxSelectedItemKind];
        if (_aspxIsExists(item))
            item.Cancel(element);
    },
    DeselectElementBySrcElement: function(srcElement) {
        var element = this.GetSelectedElement(srcElement);
        if (element != null) this.DeselectElement(element);
    },
    SetElementEnabled: function(element, enable) {
        if (enable)
            this.EnableElement(element);
        else
            this.DisableElement(element);
    },
    DisableElement: function(element) {
        var element = this.GetDisabledElement(element);
        if (element != null) {
            var item = element[__aspxDisabledItemKind];
            if (_aspxIsExists(item)) {
                var args = new ASPxClientStateEventArgs(item, element);
                this.BeforeDisabled.FireEvent(this, args);
                if (item.name == this.currentPressedItemName)
                    this.SetCurrentPressedElement(null);
                if (item.name == this.currentHoverItemName)
                    this.SetCurrentHoverElement(null);
                item.Apply(element);
                this.SetMouseStateItemsEnabled(item.name, item.postfixes, false);
                this.AfterDisabled.FireEvent(this, args);
            }
        }
    },
    EnableElement: function(element) {
        var element = this.GetDisabledElement(element);
        if (element != null) {
            var item = element[__aspxDisabledItemKind];
            if (_aspxIsExists(item)) {
                var args = new ASPxClientStateEventArgs(item, element);
                this.BeforeEnabled.FireEvent(this, args);
                item.Cancel(element);
                this.SetMouseStateItemsEnabled(item.name, item.postfixes, true);
                this.AfterEnabled.FireEvent(this, args);
            }
        }
    },
    SetMouseStateItemsEnabled: function(name, postfixes, enabled) {
        if (_aspxIsExists(postfixes) && postfixes.length > 0) {
            for (var i = 0; i < postfixes.length; i++) {
                this.SetItemsEnabled(this.hoverItems, name + postfixes[i], enabled);
                this.SetItemsEnabled(this.pressedItems, name + postfixes[i], enabled);
            }
        }
        else {
            this.SetItemsEnabled(this.hoverItems, name, enabled);
            this.SetItemsEnabled(this.pressedItems, name, enabled);
        }
    },
    SetItemsEnabled: function(items, name, enabled) {
        if (_aspxIsExists(items[name])) items[name].enabled = enabled;
    },
    OnFocusMove: function(evt) {
        var element = _aspxGetEventSource(evt);
        aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
    },
    OnMouseMove: function(evt, checkElementChanged) {
        var srcElement = _aspxGetEventSource(evt);
        if (checkElementChanged && srcElement == this.savedCurrentMouseMoveSrcElement) return;
        this.savedCurrentMouseMoveSrcElement = srcElement;
        if (__aspxIE && !_aspxGetIsLeftButtonPressed(evt) && this.savedCurrentPressedElement != null)
            this.ClearSavedCurrentPressedElement();
        if (this.savedCurrentPressedElement == null)
            this.SetCurrentHoverElementBySrcElement(srcElement);
        else {
            var element = this.GetPressedElement(srcElement);
            if (element != this.currentPressedElement) {
                if (element == this.savedCurrentPressedElement)
                    this.SetCurrentPressedElement(this.savedCurrentPressedElement);
                else
                    this.SetCurrentPressedElement(null);
            }
        }
    },
    OnMouseDown: function(evt) {
        if (!_aspxGetIsLeftButtonPressed(evt)) return;
        var srcElement = _aspxGetEventSource(evt);
        this.OnMouseDownOnElement(srcElement);
    },
    OnMouseDownOnElement: function(element) {
        if (this.GetPressedElement(element) == null) return;
        this.SetCurrentHoverElement(null);
        this.SetCurrentPressedElementBySrcElement(element);
        this.savedCurrentPressedElement = this.currentPressedElement;
    },
    OnMouseUp: function(evt) {
        var srcElement = _aspxGetEventSource(evt);
        this.OnMouseUpOnElement(srcElement);
    },
    OnMouseUpOnElement: function(element) {
        if (this.savedCurrentPressedElement == null) return;
        this.ClearSavedCurrentPressedElement();
        this.SetCurrentHoverElementBySrcElement(element);
    },
    OnMouseOver: function(evt) {
        var element = _aspxGetEventSource(evt);
        if (_aspxIsExists(element) && element.tagName == "IFRAME")
            this.OnMouseMove(evt, true);
    },
    OnKeyDown: function(evt) {
        var element = this.GetFocusedElement(_aspxGetEventSource(evt));
        if (element != null && element == this.currentFocusedElement) {
            var item = element[__aspxFocusedItemKind];
            if (_aspxIsExists(item)) {
                var args = new ASPxClientStateEventArgs(item, element);
                args.htmlEvent = evt;
                this.FocusedItemKeyDown.FireEvent(this, args);
            }
        }
    },
    OnSelectStart: function(evt) {
        if ((this.savedCurrentPressedElement != null) &&
   (!_aspxIsExists(this.savedCurrentPressedElement.needClearSelection))) {
            _aspxClearSelection();
            return false;
        }
    },
    ClearSavedCurrentPressedElement: function() {
        this.savedCurrentPressedElement = null;
        this.SetCurrentPressedElement(null);
    }
});
var __aspxStateController = null;
function aspxGetStateController() {
    if (__aspxStateController == null)
        __aspxStateController = new ASPxStateController();
    return __aspxStateController;
}
function aspxAddStateItems(method, namePrefix, classes) {
    for (var i = 0; i < classes.length; i++) {
        for (var j = 0; j < classes[i][2].length; j++) {
            var name = namePrefix;
            if (_aspxIsExists(classes[i][2][j]) && classes[i][2][j] != "")
                name += "_" + classes[i][2][j];
            var postfixes = _aspxIsExists(classes[i][3]) ? classes[i][3] : null;
            var imageUrls = _aspxIsExists(classes[i][4]) && _aspxIsExists(classes[i][4][j]) ? classes[i][4][j] : null;
            var imagePostfixes = _aspxIsExists(classes[i][5]) ? classes[i][5] : null;
            method.call(aspxGetStateController(), name, classes[i][0], classes[i][1], postfixes, imageUrls, imagePostfixes);
        }
    }
}
function aspxAddHoverItems(namePrefix, classes) {
    aspxAddStateItems(aspxGetStateController().AddHoverItem, namePrefix, classes);
}
function aspxAddPressedItems(namePrefix, classes) {
    aspxAddStateItems(aspxGetStateController().AddPressedItem, namePrefix, classes);
}
function aspxAddSelectedItems(namePrefix, classes) {
    aspxAddStateItems(aspxGetStateController().AddSelectedItem, namePrefix, classes);
}
function aspxAddDisabledItems(namePrefix, classes) {
    aspxAddStateItems(aspxGetStateController().AddDisabledItem, namePrefix, classes);
}
function aspxAddAfterClearFocusedState(handler) {
    aspxGetStateController().AfterClearFocusedState.AddHandler(handler);
}
function aspxAddAfterSetFocusedState(handler) {
    aspxGetStateController().AfterSetFocusedState.AddHandler(handler);
}
function aspxAddAfterClearHoverState(handler) {
    aspxGetStateController().AfterClearHoverState.AddHandler(handler);
}
function aspxAddAfterSetHoverState(handler) {
    aspxGetStateController().AfterSetHoverState.AddHandler(handler);
}
function aspxAddAfterClearPressedState(handler) {
    aspxGetStateController().AfterClearPressedState.AddHandler(handler);
}
function aspxAddAfterSetPressedState(handler) {
    aspxGetStateController().AfterSetPressedState.AddHandler(handler);
}
function aspxAddAfterDisabled(handler) {
    aspxGetStateController().AfterDisabled.AddHandler(handler);
}
function aspxAddAfterEnabled(handler) {
    aspxGetStateController().AfterEnabled.AddHandler(handler);
}
function aspxAddBeforeClearFocusedState(handler) {
    aspxGetStateController().BeforeClearFocusedState.AddHandler(handler);
}
function aspxAddBeforeSetFocusedState(handler) {
    aspxGetStateController().BeforeSetFocusedState.AddHandler(handler);
}
function aspxAddBeforeClearHoverState(handler) {
    aspxGetStateController().BeforeClearHoverState.AddHandler(handler);
}
function aspxAddBeforeSetHoverState(handler) {
    aspxGetStateController().BeforeSetHoverState.AddHandler(handler);
}
function aspxAddBeforeClearPressedState(handler) {
    aspxGetStateController().BeforeClearPressedState.AddHandler(handler);
}
function aspxAddBeforeSetPressedState(handler) {
    aspxGetStateController().BeforeSetPressedState.AddHandler(handler);
}
function aspxAddBeforeDisabled(handler) {
    aspxGetStateController().BeforeDisabled.AddHandler(handler);
}
function aspxAddBeforeEnabled(handler) {
    aspxGetStateController().BeforeEnabled.AddHandler(handler);
}
function aspxAddFocusedItemKeyDown(handler) {
    aspxGetStateController().FocusedItemKeyDown.AddHandler(handler);
}
function aspxSetHoverState(element) {
    aspxGetStateController().SetCurrentHoverElementBySrcElement(element);
}
function aspxClearHoverState(evt) {
    aspxGetStateController().SetCurrentHoverElementBySrcElement(null);
}
function aspxUpdateHoverState(evt) {
    aspxGetStateController().OnMouseMove(evt, false);
}
function aspxSetFocusedState(element) {
    aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
}
function aspxClearFocusedState(evt) {
    aspxGetStateController().SetCurrentFocusedElementBySrcElement(null);
}
function aspxUpdateFocusedState(evt) {
    aspxGetStateController().OnFocusMove(evt);
}
_aspxAttachEventToElement(window, "load", aspxClassesWindowOnLoad);
function aspxClassesWindowOnLoad(evt) {
    __aspxDocumentLoaded = true;
    ASPxResourceManager.SynchronizeResources(false);
    aspxGetControlCollection().Initialize();
    _aspxInitializeScripts();
    _aspxInitializeLinks();
}
_aspxAttachEventToDocument("mousemove", aspxClassesDocumentMouseMove);
function aspxClassesDocumentMouseMove(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        aspxGetStateController().OnMouseMove(evt, true);
}
_aspxAttachEventToDocument("mousedown", aspxClassesDocumentMouseDown);
function aspxClassesDocumentMouseDown(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        aspxGetStateController().OnMouseDown(evt);
}
_aspxAttachEventToDocument("mouseup", aspxClassesDocumentMouseUp);
function aspxClassesDocumentMouseUp(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        aspxGetStateController().OnMouseUp(evt);
}
_aspxAttachEventToDocument("mouseover", aspxClassesDocumentMouseOver);
function aspxClassesDocumentMouseOver(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        aspxGetStateController().OnMouseOver(evt);
}
_aspxAttachEventToDocument("keydown", aspxClassesDocumentKeyDown);
function aspxClassesDocumentKeyDown(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        aspxGetStateController().OnKeyDown(evt);
}
_aspxAttachEventToDocument("selectstart", aspxClassesDocumentSelectStart);
function aspxClassesDocumentSelectStart(evt) {
    if (__aspxClassesScriptParsed && __aspxStateItemsExist)
        return aspxGetStateController().OnSelectStart(evt);
}
_aspxAttachEventToElement(window, "resize", aspxPopupControlWindowResize);
function aspxPopupControlWindowResize(evt) {
    aspxGetControlCollection().OnBrowserWindowResize(evt);
}
function aspxFireDefaultButton(evt, buttonID) {
    if (_aspxIsDefaultButtonEvent(evt, buttonID)) {
        var defaultButton = _aspxGetElementById(buttonID);
        if (_aspxIsExists(defaultButton) && _aspxIsExists(defaultButton.click)) {
            if (_aspxIsFocusable(defaultButton))
                defaultButton.focus();
            defaultButton.click();
            _aspxPreventEventAndBubble(evt);
            return false;
        }
    }
    return true;
}
function _aspxIsDefaultButtonEvent(evt, defaultButtonID) {
    if (evt.keyCode != ASPxKey.Enter)
        return false;
    var srcElement = _aspxGetEventSource(evt);
    if (!_aspxIsExists(srcElement) || srcElement.id === defaultButtonID)
        return true;
    var tagName = srcElement.tagName;
    var type = srcElement.type;
    return tagName != "TEXTAREA" && tagName != "BUTTON" && tagName != "A" &&
  (tagName != "INPUT" || type != "checkbox" && type != "radio" && type != "button" && type != "submit" && type != "reset");
}
ASPxResourceManager = {
    HandlerStr: "DXR.axd?r=",
    InputElements: {},
    SynchronizeResources: function(isCallback) {
        this.SynchronizeResourcesElements(_aspxGetIncludeScripts(), "src", "DXScript");
    },
    SynchronizeResourcesElements: function(elements, urlAttr, id) {
        var hash = {};
        for (var i = 0; i < elements.length; i++) {
            var resourceUrl = _aspxGetAttribute(elements[i], urlAttr);
            if (_aspxIsExists(resourceUrl)) {
                var pos = resourceUrl.indexOf(this.HandlerStr);
                if (pos > -1) {
                    var list = resourceUrl.substr(pos + this.HandlerStr.length);
                    var indexes = list.split(",");
                    for (var j = 0; j < indexes.length; j++)
                        hash[indexes[j]] = indexes[j];
                }
                else
                    hash[resourceUrl] = resourceUrl;
            }
        }
        var array = [];
        for (var key in hash)
            array.push(key);
        this.UpdateInputElement(id, array.join(","));
    },
    UpdateInputElement: function(typeName, list) {
        var inputElement = this.InputElements[typeName];
        if (!_aspxIsExistsElement(inputElement)) {
            inputElement = this.CreateInputElement(typeName);
            this.InputElements[typeName] = inputElement;
        }
        if (_aspxIsExistsElement(inputElement))
            inputElement.value = list;
    },
    CreateInputElement: function(typeName) {
        var inputElement = _aspxCreateHiddenField(typeName);
        var form = _aspxGetServerForm();
        if (_aspxIsExists(form)) {
            form.appendChild(inputElement);
            return inputElement;
        }
        return null;
    }
};
var __aspxIncludeScriptPrefix = "dxis_";
var __aspxStartupScriptPrefix = "dxss_";
var __aspxIncludeScriptsCache = {};
var __aspxCreatedIncludeScripts;
var __aspxAppendedScriptsCount;
var __aspxScriptsRestartHandlers = {};
function _aspxGetScriptCode(script) {
    var text = __aspxWebKitFamily ? script.firstChild.data : script.text;
    var comment = "<!--";
    var pos = text.indexOf(comment);
    if (pos > -1)
        text = text.substr(pos + comment.length);
    return text;
}
function _aspxAppendScript(script) {
    var parent = document.getElementsByTagName("head")[0];
    if (!_aspxIsExists(parent))
        parent = document.body;
    if (_aspxIsExists(parent)) {
        parent.appendChild(script);
    }
}
function _aspxIsAlphaFilterUsed(img) {
    return (__aspxIE && img.style.filter.indexOf("progid:DXImageTransform.Microsoft.AlphaImageLoader") > -1);
}
function _aspxIsKnownIncludeScript(script) {
    return _aspxIsExists(__aspxIncludeScriptsCache[script.src]);
}
function _aspxCacheIncludeScript(script) {
    __aspxIncludeScriptsCache[script.src] = 1;
}
function _aspxProcessScriptsAndLinks(ownerName, isCallback) {
    if (!__aspxDocumentLoaded) return;
    _aspxProcessScripts(ownerName, isCallback);
    _aspxSweepDuplicatedLinks();
    _aspxMoveLinkElements();
    __aspxCachedRules = {};
}
function _aspxGetStartupScripts() {
    return _aspxGetScriptsCore(__aspxStartupScriptPrefix);
}
function _aspxGetIncludeScripts() {
    return _aspxGetScriptsCore(__aspxIncludeScriptPrefix);
}
function _aspxGetScriptsCore(prefix) {
    var result = [];
    var scripts = document.getElementsByTagName("SCRIPT");
    for (var i = 0; i < scripts.length; i++) {
        if (scripts[i].id.indexOf(prefix) == 0)
            result.push(scripts[i]);
    }
    return result;
}
function _aspxGetLinks() {
    var result = [];
    var links = document.getElementsByTagName("LINK"); ;
    for (var i = 0; i < links.length; i++)
        result[i] = links[i];
    return result;
}
function _aspxInitializeLinks() {
    var links = _aspxGetLinks();
    for (var i = 0; i < links.length; i++)
        links[i].loaded = true;
}
function _aspxInitializeScripts() {
    var scripts = _aspxGetIncludeScripts();
    for (var i = 0; i < scripts.length; i++)
        _aspxCacheIncludeScript(scripts[i]);
    var startupScripts = _aspxGetStartupScripts();
    for (var i = 0; i < startupScripts.length; i++)
        startupScripts[i].executed = true;
}
function _aspxSweepDuplicatedLinks() {
    if (__aspxIE && __aspxBrowserVersion < 7)
        return;
    var hash = {};
    var links = _aspxGetLinks();
    for (var i = 0; i < links.length; i++) {
        var href = links[i].href;
        if (!_aspxIsExists(href) || href == "")
            continue;
        if (_aspxIsExists(hash[href])) {
            if (!hash[href].loaded && links[i].loaded) {
                _aspxRemoveElement(hash[href]);
                hash[href] = links[i];
            }
            else
                _aspxRemoveElement(links[i]);
        }
        else
            hash[href] = links[i];
    }
}
function _aspxSweepDuplicatedScripts() {
    var hash = {};
    var scripts = _aspxGetIncludeScripts();
    for (var i = 0; i < scripts.length; i++) {
        var src = scripts[i].src;
        if (!_aspxIsExists(src) || src == "") continue;
        if (_aspxIsExists(hash[src]))
            _aspxRemoveElement(scripts[i]);
        else
            hash[src] = scripts[i];
    }
}
function _aspxProcessScripts(ownerName, isCallback) {
    __aspxCreatedIncludeScripts = [];
    __aspxAppendedScriptsCount = 0;
    var scripts = _aspxGetIncludeScripts();
    var scriptsLoading = false;
    var previousCreatedScript = null;
    var firstCreatedScript = null;
    for (var i = 0; i < scripts.length; i++) {
        var script = scripts[i];
        if (script.src == "") continue;
        if (_aspxIsKnownIncludeScript(script))
            continue;
        scriptsLoading = true;
        var createdScript = document.createElement("script");
        __aspxCreatedIncludeScripts.push(createdScript);
        createdScript.type = "text/javascript";
        createdScript.src = script.src;
        createdScript.id = script.id;
        if (_aspxIsExists(script.parentElement))
            script.parentElement.removeChild(script);
        if (__aspxIE) {
            createdScript.onreadystatechange = new Function("_aspxOnScriptReadyStateChangedCallback(this, \"" + ownerName + "\");");
        } else if (__aspxWebKitFamily) {
            createdScript.onload = new Function("_aspxOnScriptLoadCallback(this, \"" + ownerName + "\");");
            if (firstCreatedScript == null)
                firstCreatedScript = createdScript;
            createdScript.nextCreatedScript = null;
            if (previousCreatedScript != null)
                previousCreatedScript.nextCreatedScript = createdScript;
            previousCreatedScript = createdScript;
        } else {
            createdScript.onload = new Function("_aspxOnScriptLoadCallback(this, \"" + ownerName + "\");");
            _aspxAppendScript(createdScript);
            _aspxCacheIncludeScript(createdScript);
        }
    }
    if (firstCreatedScript != null) {
        _aspxAppendScript(firstCreatedScript);
        _aspxCacheIncludeScript(firstCreatedScript);
    }
    if (!scriptsLoading)
        _aspxFinalizeScriptProcessing(ownerName, isCallback);
}
function _aspxFinalizeScriptProcessing(ownerName, isCallback) {
    _aspxSweepDuplicatedScripts();
    _aspxRunStartupScripts(isCallback);
    ASPxResourceManager.SynchronizeResources(true);
    var owner = aspxGetControlCollection().Get(ownerName);
    if (owner != null)
        owner.DoEndCallback();
}
function _aspxRunStartupScripts(isCallback) {
    var scripts = _aspxGetStartupScripts();
    var code;
    for (var i = 0; i < scripts.length; i++) {
        if (!scripts[i].executed) {
            code = _aspxGetScriptCode(scripts[i]);
            eval(code);
            scripts[i].executed = true;
        }
    }
    if (__aspxDocumentLoaded)
        aspxGetControlCollection().InitializeElements(isCallback);
    for (var key in __aspxScriptsRestartHandlers)
        __aspxScriptsRestartHandlers[key]();
}
function _aspxOnScriptReadyStateChangedCallback(scriptElement, ownerName) {
    if (scriptElement.readyState == "loaded") {
        _aspxCacheIncludeScript(scriptElement);
        for (var i = 0; i < __aspxCreatedIncludeScripts.length; i++) {
            var script = __aspxCreatedIncludeScripts[i];
            if (_aspxIsKnownIncludeScript(script)) {
                if (!script.executed) {
                    script.executed = true;
                    _aspxAppendScript(script);
                    __aspxAppendedScriptsCount++;
                }
            } else
                break;
        }
        if (__aspxCreatedIncludeScripts.length == __aspxAppendedScriptsCount)
            _aspxFinalizeScriptProcessing(ownerName);
    }
}
function _aspxOnScriptLoadCallback(scriptElement, ownerName) {
    __aspxAppendedScriptsCount++;
    if (_aspxIsExists(scriptElement.nextCreatedScript)) {
        _aspxAppendScript(scriptElement.nextCreatedScript);
        _aspxCacheIncludeScript(scriptElement.nextCreatedScript);
    }
    if (__aspxCreatedIncludeScripts.length == __aspxAppendedScriptsCount)
        _aspxFinalizeScriptProcessing(ownerName);
}
function _aspxAddScriptsRestartHandler(objectName, handler) {
    __aspxScriptsRestartHandlers[objectName] = handler;
}
function _aspxMoveLinkElements() {
    if (__aspxIE)
        return;
    var head = _aspxGetElementsByTagName(document, "head")[0];
    var bodyLinks = _aspxGetElementsByTagName(document.body, "link");
    for (var i = 0; i < bodyLinks.length; i++)
        head.appendChild(bodyLinks[i]);
}
_aspxToJson = function(param) {
    var paramType = typeof (param);
    if ((paramType == "undefined") || (param == null))
        return null;
    if ((paramType == "object") && (typeof (param.__toJson) == "function"))
        return param.__toJson();
    if ((paramType == "number") || (paramType == "boolean"))
        return param;
    if (param.constructor == Date)
        return "\"" + _aspxGetInvariantDateTimeString(param) + "\"";
    if (paramType == "string") {
        var result = param.replace(/"/g, "\\\"");
        result = result.replace(/</g, "\\u003c");
        result = result.replace(/>/g, "\\u003e");
        return "\"" + result + "\"";
    }
    if (param.constructor == Array) {
        var values = [];
        for (var i = 0; i < param.length; i++)
            values.push(_aspxToJson(param[i]));
        return "[" + values.join(",") + "]";
    }
    var exceptKeys = {};
    if (ASPxIdent.IsArray(param.__toJsonExceptKeys))
        exceptKeys = _aspxCreateHashTableFromArray(param.__toJsonExceptKeys);
    exceptKeys["__toJsonExceptKeys"] = 1;
    var values = [];
    for (var key in param) {
        if (_aspxIsFunction(param[key]))
            continue;
        if (exceptKeys[key] == 1)
            continue;
        values.push(_aspxToJson(key) + ":" + _aspxToJson(param[key]));
    }
    return "{" + values.join(",") + "}";
}
__aspxClassesScriptParsed = true;
function _aspxEmulateDocumentOnMouseDown(evt) {
    if (__aspxIE)
        document.fireEvent("onmousedown", evt);
    else if (!__aspxWebKitFamily) {
        var emulatedEvt = document.createEvent("MouseEvents");
        emulatedEvt.initMouseEvent("mousedown", true, true, window, 0, evt.screenX, evt.screenY,
   evt.clientX, evt.clientX, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
        document.dispatchEvent(emulatedEvt);
    }
}
ASPxClientTabControlBase = _aspxCreateClass(ASPxClientControl, {
    constructor: function(name) {
        this.constructor.prototype.constructor.call(this, name);
        this.activeTabIndex = 0;
        this.callbackCount = 0;
        this.cookieName = "";
        this.emptyHeight = false;
        this.emptyWidth = false;
        this.tabsHeight = null;
        this.tabAlign = "Left";
        this.tabPosition = "Top";
        this.tabCount = 0;
        this.tabs = [];
        this.tabsContentRequest = [];
        this.handleClickOnWholeTab = true;
        this.TabClick = new ASPxClientEvent();
        this.ActiveTabChanged = new ASPxClientEvent();
        this.ActiveTabChanging = new ASPxClientEvent();
        this.InitializeOnResize();
    },
    Initialize: function() {
        this.constructor.prototype.Initialize.call(this);
        this.CorrrectCellsBounds(true);
    },
    InlineInitialize: function() {
        this.InitializeEnabledAndVisible();
        this.CorrrectCellsBounds(true);
    },
    InitializeEnabledAndVisible: function() {
        for (var i = 0; i < this.tabs.length; i++) {
            this.SetTabVisible(i, this.tabs[i].clientVisible, true);
            this.SetTabEnabled(i, this.tabs[i].clientEnabled, true);
        }
    },
    InitializeCallBackData: function() {
        var element = this.GetContentElement(this.activeTabIndex);
        if (element != null) element.loaded = true;
    },
    InitializeOnResize: function() {
        var element = this.GetMainElement();
        if (_aspxIsExists(element))
            element.onresize = new Function("aspxTCResize(\"" + this.name + "\");");
    },
    GetTabsCell: function() {
        return this.GetChild("_TC");
    },
    GetTabElement: function(index, active) {
        return this.GetChild("_" + (active ? "A" : "") + "T" + index);
    },
    GetContentsCell: function() {
        return this.GetChild("_CC");
    },
    GetContentElement: function(index) {
        return this.GetChild("_C" + index);
    },
    GetSeparatorElement: function(index) {
        return this.GetChild("_T" + index + "S");
    },
    GetLeftAlignCellElement: function() {
        return this.GetChild("_LAC");
    },
    GetRightAlignCellElement: function() {
        return this.GetChild("_RAC");
    },
    GetTabLayoutElement: function(element) {
        if (!this.IsTopBottomTabPosition())
            return element.parentNode;
        return element;
    },
    GetActiveTabIndexInputElement: function(index) {
        return _aspxGetElementById(this.name + "ATI");
    },
    IsTopBottomTabPosition: function() {
        return (this.tabPosition == "Top" || this.tabPosition == "Bottom");
    },
    CorrrectCellsBounds: function(initialization) {
        if (this.isInitialized || initialization)
            window.setTimeout("aspxTCCorrectBounds(\"" + this.name + "\");", 1);
    },
    CorrrectCellsBoundsTimer: function() {
        var mainElement = this.GetMainElement();
        if (mainElement == null || mainElement.offsetWidth == 0 || mainElement.offsetHeight == 0) return;
        mainElement.corrected = true;
        if (__aspxIE && !this.emptyHeight && this.tabAlign != "Justify") {
            if (this.IsTopBottomTabPosition())
                this.CorrectContentCellHeight();
            else
                this.CorrectAlignCellsHeight();
        }
        if ((__aspxFirefox || __aspxWebKitFamily) && !this.emptyHeight && this.tabAlign == "Center") {
            if (!this.IsTopBottomTabPosition())
                this.CorrectAlignCellsHeight();
        }
        if ((this.emptyHeight || __aspxOpera) && !this.IsTopBottomTabPosition()) {
            this.CorrectTabsCellHeight();
            if (__aspxIE)
                this.CorrectAlignCellsHeight();
        }
        if (this.emptyWidth && this.IsTopBottomTabPosition() && this.tabAlign != "Justify")
            this.CorrectTabsCellWidth();
        this.CorrectOperaTabsCellAlignment();
        this.CorrectOperaTabCellsAlignment();
    },
    CorrectTabsCellHeight: function() {
        var mainElement = this.GetMainElement();
        var tabsCell = this.GetTabsCell();
        if (mainElement != null && tabsCell) {
            var leftAlignCell = this.GetLeftAlignCellElement();
            if (leftAlignCell != null)
                leftAlignCell.style.height = "auto";
            var rightAlignCell = this.GetRightAlignCellElement();
            if (rightAlignCell != null)
                rightAlignCell.style.height = "auto";
            var tabsTable = tabsCell.firstChild;
            var tabsTableHeightCorrectionRequired = (__aspxChrome || __aspxSafari && __aspxBrowserVersion >= 4 ||
    __aspxIE && __aspxBrowserVersion >= 8 || __aspxOpera) && !this.IsTopBottomTabPosition();
            if (tabsTableHeightCorrectionRequired)
                tabsTable.style.height = "auto";
            tabsCell.style.height = "auto";
            tabsCell.style.height = mainElement.offsetHeight + "px";
            if (tabsTableHeightCorrectionRequired)
                tabsTable.style.height = _aspxGetClearClientHeight(tabsCell) + "px";
            if (leftAlignCell != null && rightAlignCell == null)
                leftAlignCell.style.height = "100%";
            if (leftAlignCell == null && rightAlignCell != null)
                rightAlignCell.style.height = "100%";
            if (leftAlignCell != null && rightAlignCell != null) {
                leftAlignCell.style.height = "50%";
                rightAlignCell.style.height = "50%";
            }
        }
    },
    CorrectTabsCellWidth: function() {
        var mainElement = this.GetMainElement();
        var tabsCell = this.GetTabsCell();
        if (mainElement != null && tabsCell) {
            var leftAlignCell = this.GetLeftAlignCellElement();
            if (leftAlignCell != null)
                leftAlignCell.style.width = "auto";
            var rightAlignCell = this.GetRightAlignCellElement();
            if (rightAlignCell != null)
                rightAlignCell.style.width = "auto";
            tabsCell.style.width = "auto";
            tabsCell.style.width = mainElement.clientWidth;
            if (leftAlignCell != null && rightAlignCell == null)
                leftAlignCell.style.width = "100%";
            if (leftAlignCell == null && rightAlignCell != null)
                rightAlignCell.style.width = "100%";
            if (leftAlignCell != null && rightAlignCell != null) {
                leftAlignCell.style.width = "50%";
                rightAlignCell.style.width = "50%";
            }
        }
    },
    CorrectContentCellHeight: function() {
        var mainElement = this.GetMainElement();
        var tabsCell = this.GetTabsCell();
        var contentsCell = this.GetContentsCell();
        if (mainElement != null && tabsCell != null && contentsCell != null) {
            if (this.tabsHeight == null)
                this.tabsHeight = tabsCell.clientHeight;
            tabsCell.style.height = this.tabsHeight + "px";
            contentsCell.style.height = "auto";
            contentsCell.style.height = (mainElement.clientHeight - this.tabsHeight) + "px";
        }
    },
    CorrectAlignCellsHeight: function() {
        var mainElement = this.GetMainElement();
        var tabsCell = this.GetTabsCell();
        if (mainElement != null && tabsCell != null) {
            var leftAlignCell = this.GetLeftAlignCellElement();
            var rightAlignCell = this.GetRightAlignCellElement();
            var tabsTable = tabsCell.firstChild;
            if (tabsTable != null) {
                if (leftAlignCell != null || rightAlignCell != null) {
                    var tabsHeight = 0;
                    for (var i = 0; i < tabsTable.rows.length; i++) {
                        var cell = tabsTable.rows[i].cells[0];
                        if (cell != leftAlignCell && cell != rightAlignCell)
                            tabsHeight += cell.offsetHeight;
                    }
                    if (leftAlignCell != null)
                        leftAlignCell.style.height = "auto";
                    if (rightAlignCell != null)
                        rightAlignCell.style.height = "auto";
                    var correctionHeight = mainElement.clientHeight - tabsHeight;
                    if (leftAlignCell != null)
                        leftAlignCell.style.height = ((rightAlignCell != null) ? Math.round(correctionHeight / 2) : correctionHeight) + "px";
                    if (rightAlignCell != null)
                        rightAlignCell.style.height = ((leftAlignCell != null) ? Math.round(correctionHeight / 2) : correctionHeight) + "px";
                }
            }
        }
    },
    CorrectOperaTabsCellAlignment: function() {
        if (!__aspxOpera || this.tabAlign != "Justify") return;
        if (!this.IsTopBottomTabPosition() && !this.emptyHeight) return;
        var element = this.GetTabsCell();
        _aspxSetElementDisplay(element, false);
        _aspxSetElementDisplay(element, true);
    },
    CorrectOperaTabCellsAlignment: function() {
        if (!__aspxOpera || !this.IsTopBottomTabPosition()) return;
        var element = this.GetLeftAlignCellElement();
        if (element != null) {
            _aspxSetElementDisplay(element, false);
            _aspxSetElementDisplay(element, true);
        }
        element = this.GetRightAlignCellElement();
        if (element != null) {
            _aspxSetElementDisplay(element, false);
            _aspxSetElementDisplay(element, true);
        }
        for (var i = 0; i < this.tabCount; i++) {
            if (this.activeTabIndex == i) continue;
            element = this.GetTabElement(i, false);
            if (element != null) {
                _aspxSetElementDisplay(element, false);
                _aspxSetElementDisplay(element, true);
            }
        }
    },
    FixControlSize: function() {
        this.FixElementSize(this.GetMainElement());
        this.FixElementSize(this.GetContentsCell());
    },
    UnfixControlSize: function() {
        this.UnfixElementSize(this.GetMainElement());
        this.UnfixElementSize(this.GetContentsCell());
    },
    FixElementSize: function(element) {
        if (element == null) return;
        _aspxChangeStyleAttribute(element, "width", (__aspxIE ? element.clientWidth : element.offsetWidth) + "px");
        _aspxChangeStyleAttribute(element, "height", (__aspxIE ? element.clientHeight : element.offsetHeight) + "px");
    },
    UnfixElementSize: function(element) {
        if (element == null) return;
        _aspxRestoreStyleAttribute(element, "width");
        _aspxRestoreStyleAttribute(element, "height");
    },
    AdjustSize: function() {
        this.CorrrectCellsBounds(false);
    },
    ChangeTabState: function(index, active) {
        var element = this.GetTabElement(index, true);
        if (element != null) _aspxSetElementDisplay(this.GetTabLayoutElement(element), active);
        element = this.GetTabElement(index, false);
        if (element != null) _aspxSetElementDisplay(this.GetTabLayoutElement(element), !active);
        element = this.GetContentElement(index);
        if (element != null) _aspxSetElementDisplay(element, active);
    },
    ChangeActiveTab: function(index, hasLink) {
        var processingMode = this.RaiseActiveTabChanging(index);
        if (processingMode == "Client" || processingMode == "ClientWithReload") {
            var element = this.GetContentElement(index);
            if (_aspxIsFunction(this.callBack) && element != null && (!element.loaded || processingMode == "ClientWithReload")) {
                if (this.callbackCount == 0)
                    this.FixControlSize();
                this.DoChangeActiveTab(index);
                if (!element.loading) {
                    this.callbackCount++;
                    element.loading = true;
                    this.CreateLoadingPanelWithAbsolutePosition(element, this.GetContentsCell());
                    this.CreateCallback(index);
                    _aspxArrayPush(this.tabsContentRequest, index);
                }
                this.CorrectOperaTabCellsAlignment();
            }
            else {
                this.DoChangeActiveTab(index);
                this.CorrrectCellsBounds(false);
                this.CorrectOperaTabCellsAlignment();
                var activeContentElement = this.GetContentElement(this.activeTabIndex);
                var collection = aspxGetControlCollection();
                collection.AdjustControls(activeContentElement, __aspxCheckSizeCorrectedFlag);
                this.RaiseActiveTabChanged(index);
            }
        }
        else if (processingMode == "Server" && !hasLink)
            this.SendPostBack("ACTIVATE:" + index);
    },
    DoChangeActiveTab: function(index) {
        if (__aspxFirefox && __aspxBrowserVersion >= 3) {
            var contentsCell = this.GetContentsCell();
            var isContentsCellExists = _aspxIsExistsElement(contentsCell);
            if (isContentsCellExists)
                _aspxSetElementVisibility(contentsCell, false);
            this.ChangeTabState(index, true);
            this.ChangeTabState(this.activeTabIndex, false);
            this.activeTabIndex = index;
            if (isContentsCellExists)
                _aspxSetElementVisibility(contentsCell, true);
        } else {
            this.ChangeTabState(this.activeTabIndex, false);
            this.activeTabIndex = index;
            this.ChangeTabState(this.activeTabIndex, true);
        }
        this.UpdateActiveTabIndexInputElement();
        this.UpdateActiveTabIndexCookie();
    },
    SetActiveTabIndexInternal: function(index, hasLink) {
        if (this.activeTabIndex == index) return;
        var lastScrollYPos = _aspxGetDocumentScrollTop();
        this.ChangeActiveTab(index, hasLink);
        var scrollY = _aspxGetDocumentScrollTop();
        if (lastScrollYPos != scrollY)
            window.scrollTo(_aspxGetDocumentScrollLeft(), lastScrollYPos);
        this.UpdateHoverState(index);
    },
    UpdateActiveTabIndexCookie: function() {
        if (this.cookieName == "") return;
        _aspxDelCookie(this.cookieName);
        _aspxSetCookie(this.cookieName, this.activeTabIndex);
    },
    UpdateActiveTabIndexInputElement: function() {
        var element = this.GetActiveTabIndexInputElement();
        if (element != null) element.value = this.activeTabIndex;
    },
    UpdateHoverState: function(index) {
        var element = this.GetTabElement(index, true);
        if (element != null) aspxGetStateController().SetCurrentHoverElementBySrcElement(element);
    },
    OnResize: function() {
        var mainElement = this.GetMainElement();
        if (mainElement != null && !_aspxIsExists(mainElement.corrected))
            this.CorrrectCellsBounds(false);
    },
    OnTabClick: function(evt, index) {
        var processingMode = this.RaiseTabClick(index, evt);
        var clickedLinkElement = _aspxGetParentByTagName(_aspxGetEventSource(evt), "A");
        var isLinkClicked = (clickedLinkElement != null && clickedLinkElement.href != __aspxAccessibilityEmptyUrl);
        var element = this.GetTabElement(index, false);
        var linkElement = (element != null) ? _aspxGetChildByTagName(element, "A", 0) : null;
        if (linkElement != null && linkElement.href == __aspxAccessibilityEmptyUrl)
            linkElement = null;
        if (processingMode != "Handled") {
            var hasLink = isLinkClicked || linkElement != null;
            if (processingMode == "Server" && !hasLink)
                this.SendPostBack("CLICK:" + index);
            else
                this.SetActiveTabIndexInternal(index, hasLink);
            if (this.handleClickOnWholeTab && !isLinkClicked && linkElement != null)
                _aspxNavigateUrl(linkElement.href, linkElement.target);
        }
    },
    OnCallbackInternal: function(html, index, isError) {
        this.SetCallbackContent(html, index, isError);
        if (!isError)
            this.RaiseActiveTabChanged(index);
        _aspxArrayRemoveAt(this.tabsContentRequest, 0);
    },
    OnCallback: function(result) {
        this.OnCallbackInternal(result.html, result.index, false);
    },
    OnCallbackError: function(result, data) {
        this.OnCallbackInternal(result, data, true);
    },
    OnCallbackGeneralError: function(result) {
        var callbackTabIndex = (this.tabsContentRequest.length > 0) ? this.tabsContentRequest[0] : this.activeTabIndex;
        this.SetCallbackContent(result, callbackTabIndex, true);
        _aspxArrayRemoveAt(this.tabsContentRequest, 0);
    },
    SetCallbackContent: function(html, index, isError) {
        var element = this.GetContentElement(index);
        if (element != null) {
            if (!isError)
                element.loaded = true;
            element.loading = false;
            _aspxSetInnerHtml(element, html);
            this.callbackCount--;
            if (this.callbackCount == 0) {
                this.UnfixControlSize();
                this.CorrrectCellsBounds(false);
                this.CorrectOperaTabCellsAlignment();
            }
        }
    },
    CreateTabs: function(tabsProperties) {
        for (var i = 0; i < tabsProperties.length; i++) {
            var tabName = _aspxIsExists(tabsProperties[i][0]) ? tabsProperties[i][0] : "";
            var tab = new ASPxClientTab(this, i, tabName);
            if (_aspxIsExists(tabsProperties[i][1]))
                tab.enabled = tabsProperties[i][1];
            if (_aspxIsExists(tabsProperties[i][2]))
                tab.clientEnabled = tabsProperties[i][2];
            if (_aspxIsExists(tabsProperties[i][3]))
                tab.visible = tabsProperties[i][3];
            if (_aspxIsExists(tabsProperties[i][4]))
                tab.clientVisible = tabsProperties[i][4];
            _aspxArrayPush(this.tabs, tab);
        }
    },
    RaiseTabClick: function(index, htmlEvent) {
        var processingMode = this.autoPostBack || this.IsServerEventAssigned("TabClick") ? "Server" : "Client";
        if (!this.TabClick.IsEmpty()) {
            var htmlElement = this.GetTabElement(index, this.activeTabIndex == index);
            var args = new ASPxClientTabControlTabClickEventArgs(processingMode == "Server", this.GetTab(index), htmlElement, htmlEvent);
            this.TabClick.FireEvent(this, args);
            if (args.cancel)
                processingMode = "Handled";
            else
                processingMode = args.processOnServer ? "Server" : "Client";
        }
        return processingMode;
    },
    RaiseActiveTabChanged: function(index) {
        if (!this.ActiveTabChanged.IsEmpty()) {
            var args = new ASPxClientTabControlTabEventArgs(this.GetTab(index));
            this.ActiveTabChanged.FireEvent(this, args);
        }
    },
    RaiseActiveTabChanging: function(index) {
        var processingMode = this.autoPostBack ? "Server" : "Client";
        if (!this.ActiveTabChanging.IsEmpty()) {
            var args = new ASPxClientTabControlTabCancelEventArgs(processingMode == "Server", this.GetTab(index));
            this.ActiveTabChanging.FireEvent(this, args);
            if (args.cancel)
                processingMode = "Handled";
            else if (args.processOnServer)
                processingMode = "Server";
            else
                processingMode = args.reloadContentOnCallback ? "ClientWithReload" : "Client";
        }
        return processingMode;
    },
    GetActiveTab: function() {
        return (this.activeTabIndex > -1) ? this.GetTab(this.activeTabIndex) : null;
    },
    SetActiveTab: function(tab) {
        if (this.IsTabVisible(tab.index))
            this.SetActiveTabIndexInternal(tab.index, false);
    },
    GetTabCount: function() {
        return this.tabs.length;
    },
    GetTab: function(index) {
        return (0 <= index && index < this.tabs.length) ? this.tabs[index] : null;
    },
    GetTabByName: function(name) {
        for (var i = 0; i < this.tabs.length; i++)
            if (this.tabs[i].name == name) return this.tabs[i];
        return null;
    },
    IsTabEnabled: function(index) {
        return this.tabs[index].GetEnabled();
    },
    SetTabEnabled: function(index, enabled, initialization) {
        if (!this.tabs[index].enabled) return;
        if (!initialization || !enabled)
            this.ChangeTabEnabledStateItems(index, enabled);
        this.ChangeTabEnabledAttributes(index, enabled);
    },
    ChangeTabEnabledAttributes: function(index, enabled) {
        if (enabled) {
            this.ChangeTabElementsEnabledAttributes(index, _aspxRestoreAttribute, _aspxRestoreStyleAttribute);
            if (!this.IsTabEnabled(this.activeTabIndex) && this.IsTabVisible(index))
                this.SetActiveTabIndexInternal(index, false);
        }
        else {
            if (this.activeTabIndex == index) {
                for (var i = 0; i < this.GetTabCount(); i++) {
                    if (this.IsTabVisible(i) && this.IsTabEnabled(i) && i != index) {
                        this.SetActiveTabIndexInternal(i, false);
                        break;
                    }
                }
            }
            this.ChangeTabElementsEnabledAttributes(index, _aspxResetAttribute, _aspxResetStyleAttribute);
        }
    },
    ChangeTabElementsEnabledAttributes: function(index, method, styleMethod) {
        var element = this.GetTabElement(index, false);
        if (_aspxIsExists(element)) {
            method(element, "onclick");
            styleMethod(element, "cursor");
            var link = this.GetInternalHyperlinkElement(element, 0);
            if (link != null) {
                method(link, "href");
                styleMethod(link, "cursor");
            }
            link = this.GetInternalHyperlinkElement(element, 1);
            if (link != null) {
                method(link, "href");
                styleMethod(link, "cursor");
            }
        }
        var activeElement = this.GetTabElement(index, true);
        if (_aspxIsExists(activeElement)) {
            method(activeElement, "onclick");
            styleMethod(activeElement, "cursor");
        }
    },
    ChangeTabEnabledStateItems: function(index, enabled) {
        var element = this.GetTabElement(index, false);
        if (element != null)
            aspxGetStateController().SetElementEnabled(element, enabled);
        var activeElement = this.GetTabElement(index, true);
        if (activeElement != null)
            aspxGetStateController().SetElementEnabled(activeElement, enabled);
    },
    GetTabTextCell: function(index, active) {
        return this.GetChild("_" + (active ? "A" : "") + "T" + index + "T");
    },
    GetTabImageCell: function(index, active) {
        return this.GetChild("_" + (active ? "A" : "") + "T" + index + "I");
    },
    GetTabImageUrl: function(index, active) {
        var element = this.GetTabImageCell(index, active);
        if (element != null) {
            var img = _aspxGetChildByTagName(element, "IMG", 0);
            if (img != null)
                return img.src;
        }
        return "";
    },
    SetTabImageUrl: function(index, active, url) {
        var element = this.GetTabImageCell(index, active);
        if (element != null) {
            var img = _aspxGetChildByTagName(element, "IMG", 0);
            if (img != null)
                img.src = url;
        }
    },
    GetTabNavigateUrl: function(index) {
        var element = this.GetTabTextCell(index, false);
        if (element != null) {
            var link = _aspxGetChildByTagName(element, "A", 0);
            if (link != null)
                return link.href;
        }
        element = this.GetTabImageCell(index, false);
        if (element != null) {
            var link = _aspxGetChildByTagName(element, "A", 0);
            if (link != null)
                return link.href;
        }
        return "";
    },
    SetTabNavigateUrl: function(index, url) {
        var element = this.GetTabTextCell(index, false);
        if (element != null) {
            var link = _aspxGetChildByTagName(element, "A", 0);
            if (link != null)
                link.href = url;
        }
        var element = this.GetTabImageCell(index, false);
        if (element != null) {
            var link = _aspxGetChildByTagName(element, "A", 0);
            if (link != null)
                link.href = url;
        }
    },
    GetTabText: function(index) {
        var element = this.GetTabTextCell(index, false);
        if (element != null) {
            var link = this.GetInternalHyperlinkElement(element, 0);
            if (link != null)
                return link.innerHTML;
            else
                return element.innerHTML;
        }
        return "";
    },
    SetTabText: function(index, text) {
        var element = this.GetTabTextCell(index, false);
        if (element != null) {
            var link = this.GetInternalHyperlinkElement(element, 0);
            if (link != null)
                link.innerHTML = text;
            else
                element.innerHTML = text;
        }
        element = this.GetTabTextCell(index, true);
        if (element != null) {
            var link = this.GetInternalHyperlinkElement(element, 0);
            if (link != null)
                link.innerHTML = text;
            else
                element.innerHTML = text;
        }
    },
    IsTabVisible: function(index) {
        return this.tabs[index].GetVisible();
    },
    SetTabVisible: function(index, visible, initialization) {
        if (!this.tabs[index].visible) return;
        if (visible && initialization) return;
        var element = this.GetTabElement(index, false);
        if (element != null) element = this.GetTabLayoutElement(element);
        var activeElement = this.GetTabElement(index, true);
        if (activeElement != null) activeElement = this.GetTabLayoutElement(activeElement);
        var contentElement = this.GetContentElement(index);
        if (!visible) {
            if (this.activeTabIndex == index) {
                for (var i = 0; i < this.GetTabCount(); i++) {
                    if (this.IsTabVisible(i) && this.IsTabEnabled(i) && i != index) {
                        this.SetActiveTabIndexInternal(i, false);
                        break;
                    }
                }
                for (var i = 0; i < this.GetTabCount(); i++) {
                    if (this.IsTabVisible(i) && i != index) {
                        this.SetActiveTabIndexInternal(i, false);
                        break;
                    }
                }
                if (this.activeTabIndex == index) {
                    this.activeTabIndex = -1;
                    _aspxSetElementDisplay(this.GetMainElement(), false);
                }
            }
            if (element != null)
                _aspxSetElementDisplay(element, false);
            if (activeElement != null)
                _aspxSetElementDisplay(activeElement, false);
            if (contentElement != null)
                _aspxSetElementDisplay(contentElement, false);
        }
        else {
            if (element != null)
                _aspxSetElementDisplay(element, this.activeTabIndex != index);
            if (activeElement != null)
                _aspxSetElementDisplay(activeElement, this.activeTabIndex == index);
            if (contentElement != null)
                _aspxSetElementDisplay(contentElement, this.activeTabIndex == index);
            if (this.activeTabIndex == -1) {
                _aspxSetElementDisplay(this.GetMainElement(), true);
                this.SetActiveTabIndexInternal(index, false);
            }
            else if (!this.IsTabEnabled(this.activeTabIndex) && this.IsTabEnabled(index))
                this.SetActiveTabIndexInternal(index, false);
        }
        this.SetSeparatorsVisiblility();
        this.CorrrectCellsBounds(false);
    },
    SetSeparatorsVisiblility: function() {
        for (var i = 0; i < this.tabs.length; i++) {
            var separatorVisible = this.tabs[i].GetVisible() && this.HasNextVisibleTabs(i);
            var separatorElement = this.GetSeparatorElement(i);
            if (separatorElement != null) {
                separatorElement = this.GetTabLayoutElement(separatorElement);
                _aspxSetElementDisplay(separatorElement, separatorVisible);
            }
        }
    },
    HasNextVisibleTabs: function(index) {
        for (var i = index + 1; i < this.tabs.length; i++) {
            if (this.tabs[i].GetVisible())
                return true;
        }
        return false;
    }
});
ASPxClientTabControl = _aspxCreateClass(ASPxClientTabControlBase, {
});
ASPxClientPageControl = _aspxCreateClass(ASPxClientTabControlBase, {
    constructor: function(name) {
        this.constructor.prototype.constructor.call(this, name);
        this.handleClickOnWholeTab = false;
    },
    GetTabContentHTML: function(tab) {
        var element = this.GetContentElement(tab.index);
        return (element != null) ? element.innerHTML : "";
    },
    SetTabContentHTML: function(tab, html) {
        var element = this.GetContentElement(tab.index);
        if (element != null) {
            _aspxSetInnerHtml(element, html);
            this.CorrrectCellsBounds(false);
        }
    }
});
ASPxClientTab = _aspxCreateClass(null, {
    constructor: function(tabControl, index, name) {
        this.tabControl = tabControl;
        this.index = index;
        this.name = name;
        this.enabled = true;
        this.clientEnabled = true;
        this.visible = true;
        this.clientVisible = true;
    },
    GetEnabled: function() {
        return this.enabled && this.clientEnabled;
    },
    SetEnabled: function(value) {
        if (this.clientEnabled != value) {
            this.clientEnabled = value;
            this.tabControl.SetTabEnabled(this.index, value, false);
        }
    },
    GetImageUrl: function(active) {
        if (!_aspxIsExists(active)) active = false;
        return this.tabControl.GetTabImageUrl(this.index, active);
    },
    SetImageUrl: function(value, active) {
        if (!_aspxIsExists(active)) active = false;
        this.tabControl.SetTabImageUrl(this.index, active, value);
    },
    GetActiveImageUrl: function() {
        return this.tabControl.GetTabImageUrl(this.index, true);
    },
    SetActiveImageUrl: function(value) {
        this.tabControl.SetTabImageUrl(this.index, true, value);
    },
    GetNavigateUrl: function() {
        return this.tabControl.GetTabNavigateUrl(this.index);
    },
    SetNavigateUrl: function(value) {
        this.tabControl.SetTabNavigateUrl(this.index, value);
    },
    GetText: function() {
        return this.tabControl.GetTabText(this.index);
    },
    SetText: function(value) {
        this.tabControl.SetTabText(this.index, value);
    },
    GetVisible: function() {
        return this.visible && this.clientVisible;
    },
    SetVisible: function(value) {
        if (this.clientVisible != value) {
            this.clientVisible = value;
            this.tabControl.SetTabVisible(this.index, value, false);
        }
    }
});
ASPxClientTabControlTabEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
    constructor: function(tab, htmlElement, htmlEvent) {
        this.constructor.prototype.constructor.call(this);
        this.tab = tab;
    }
});
ASPxClientTabControlTabCancelEventArgs = _aspxCreateClass(ASPxClientCancelEventArgs, {
    constructor: function(processOnServer, tab) {
        this.constructor.prototype.constructor.call(this, processOnServer);
        this.tab = tab;
        this.reloadContentOnCallback = false;
    }
});
ASPxClientTabControlTabClickEventArgs = _aspxCreateClass(ASPxClientTabControlTabCancelEventArgs, {
    constructor: function(processOnServer, tab, htmlElement, htmlEvent) {
        this.constructor.prototype.constructor.call(this, processOnServer, tab);
        this.htmlElement = htmlElement;
        this.htmlEvent = htmlEvent;
    }
});
function aspxTCResize(name) {
    var tc = aspxGetControlCollection().Get(name);
    if (tc != null) tc.OnResize();
}
function aspxTCCorrectBounds(name) {
    var tc = aspxGetControlCollection().Get(name);
    if (tc != null) tc.CorrrectCellsBoundsTimer();
}
function aspxTCTClick(evt, name, index) {
    var tc = aspxGetControlCollection().Get(name);
    if (tc != null) tc.OnTabClick(evt, index);
    if (!__aspxNetscapeFamily)
        evt.cancelBubble = true;
}

