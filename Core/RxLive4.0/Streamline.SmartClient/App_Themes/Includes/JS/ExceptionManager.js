var ERROR_CODE_UNHANDLED = 1;
var ERROR_CODE_BASE = 1000;
var ERROR_CODE_WEB_SERVICE = (ERROR_CODE_BASE + 1);
var ERROR_CODE_REGULAR = (ERROR_CODE_BASE + 2);
var ERROR_CODE_USER_DEFINED = (ERROR_CODE_BASE + 3);
var ERROR_CODE_UPDATE_PANEL = (ERROR_CODE_BASE + 4);

Type.registerNamespace('Streamline.SmartClient');

Streamline.SmartClient.BaseTraceListener = function(lineSeparator)
{
    this._lineSeparator = '\n';

    if (lineSeparator)
    {
        this._lineSeparator = lineSeparator;
    }
}

Streamline.SmartClient.BaseTraceListener.prototype =
{
    get_lineSeparator : function()
    {
        if (arguments.length !== 0) throw Error.parameterCount();

        return this._lineSeparator;
    },

    dispose : function()
    {
    },

    publishException : function(errorCode, exception, environmentInfo)
    {
        throw Error.notImplemented();
        fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
    },

    formatException : function(errorCode, exception)
    {
        var lineSeparator = this.get_lineSeparator();
        var errorInfo = new Sys.StringBuilder();

        errorInfo.append('Error Code: ' + errorCode.toString() + lineSeparator);

        if (typeof exception.get_exceptionType != 'undefined')
        {
            errorInfo.append(   'Message: ' + exception.get_message() + lineSeparator +
                                'Type: ' + exception.get_exceptionType() + lineSeparator +
                                'StackTrace: ' + exception.get_stackTrace() 
                               
                            );
        }
        else
        {
            errorInfo.append(   'Message: ' + exception.message + lineSeparator +
                                'Type: ' + exception.name + lineSeparator +
                                'Description: ' + exception.description 
                                
                            );

            //Only Update Panel has this field
            if (typeof exception.httpStatusCode != 'undefined')
            {
                errorInfo.append(lineSeparator + 'HttpStatusCode: ' + exception.httpStatusCode);
            }

            //Only Unhandled error have the following two field

            if (typeof exception.lineNumber != 'undefined')
            {
                errorInfo.append(lineSeparator + 'LineNumber: ' + exception.lineNumber);
            }

            if (typeof exception.url != 'undefined')
            {
                errorInfo.append(lineSeparator + 'Url: ' + exception.url);
            }
        }

        return errorInfo.toString();
    }
}

Streamline.SmartClient.BaseTraceListener.registerClass('Streamline.SmartClient.BaseTraceListener', null, Sys.IDisposable);


Streamline.SmartClient.SysDebugTraceListener = function(lineSeparator)
{
    Streamline.SmartClient.SysDebugTraceListener.initializeBase(this, [lineSeparator]);
}

Streamline.SmartClient.SysDebugTraceListener.prototype =
{
    dispose : function()
    {
        Streamline.SmartClient.SysDebugTraceListener.callBaseMethod(this, 'dispose');
    },

    publishException : function(errorCode, exception, environmentInfo)
    {
        //Calling the base class method
        var errorInfo = Streamline.SmartClient.SysDebugTraceListener.callBaseMethod(this, 'formatException', [errorCode, exception]);
       
      fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
       // Sys.Debug.traceDump(errorInfo);
    }
}

Streamline.SmartClient.SysDebugTraceListener.registerClass('Streamline.SmartClient.SysDebugTraceListener', Streamline.SmartClient.BaseTraceListener);


Streamline.SmartClient.AlertTraceListener = function(lineSeparator)
{
    Streamline.SmartClient.AlertTraceListener.initializeBase(this, [lineSeparator]);
}

Streamline.SmartClient.AlertTraceListener.prototype =
{
    dispose : function()
    {
        Streamline.SmartClient.AlertTraceListener.callBaseMethod(this, 'dispose');
    },

    publishException : function(errorCode, exception, environmentInfo)
    {
        //Calling the base class method
        var errorInfo = Streamline.SmartClient.AlertTraceListener.callBaseMethod(this, 'formatException', [errorCode, exception]);
        
      fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
        alert(errorInfo);
    }
}

Streamline.SmartClient.AlertTraceListener.registerClass('Streamline.SmartClient.AlertTraceListener', Streamline.SmartClient.BaseTraceListener);


Streamline.SmartClient.DivTraceListener = function(lineSeparator, targetElement)
{
    if (typeof targetElement == 'string')
    {
        this._element = $get(targetElement);
    }
    else
    {
        this._element = targetElement;
    }

    Streamline.SmartClient.DivTraceListener.initializeBase(this, [lineSeparator]);
}

Streamline.SmartClient.DivTraceListener.prototype =
{
    dispose : function()
    {
        this._element = null;
        Streamline.SmartClient.DivTraceListener.callBaseMethod(this, 'dispose');
    },

    publishException : function(errorCode, exception, environmentInfo)
    {
        //Calling the base class methods
        var errorInfo = Streamline.SmartClient.DivTraceListener.callBaseMethod(this, 'formatException', [errorCode, exception]);
        var lineSeparator = Streamline.SmartClient.DivTraceListener.callBaseMethod(this, 'get_lineSeparator')

        if (this._element.innerHTML.length > 0)
        {
            //Put some extra breaks
            this._element.innerHTML = lineSeparator + lineSeparator + this._element.innerHTML;
        }

        this._element.innerHTML = errorInfo + this._element.innerHTML;
      
      fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
    }
}

Streamline.SmartClient.DivTraceListener.registerClass('Streamline.SmartClient.DivTraceListener', Streamline.SmartClient.BaseTraceListener);


Streamline.SmartClient.WebServiceTraceListener = function(lineSeparator)
{
    Streamline.SmartClient.WebServiceTraceListener.initializeBase(this, [lineSeparator]);
}

Streamline.SmartClient.WebServiceTraceListener.prototype =
{
    dispose : function()
    {
        Streamline.SmartClient.WebServiceTraceListener.callBaseMethod(this, 'dispose');
    },

    publishException: function(errorCode, exception, environmentInfo)
    {
        //Calling the base class method
        var errorInfo = Streamline.SmartClient.WebServiceTraceListener.callBaseMethod(this, 'formatException', [errorCode, exception]);

      fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
        //Invoking the WebService
        //Streamline.SmartClient.WebServices.CommonService.WriteToDatabase(errorInfo,'JavaScriptError',null);
        //SimpleService.LogException (errorCode, errorInfo, environmentInfo.url, environmentInfo.referrer, environmentInfo.scripts);
    }
}

Streamline.SmartClient.WebServiceTraceListener.registerClass('Streamline.SmartClient.WebServiceTraceListener', Streamline.SmartClient.BaseTraceListener);

Streamline.SmartClient.ExceptionManager = function()
{
    this._listeners = new Array();
    Streamline.SmartClient.ExceptionManager.initializeBase(this);
}

Streamline.SmartClient.ExceptionManager.prototype =
{
    initialize : function()
    {
        Streamline.SmartClient.ExceptionManager.callBaseMethod(this, 'initialize');
    },

    dispose : function()
    {
        if (this._listeners.length > 0)
        {
            for(var i = 0; i < this._listeners.length; i++)
            {
                this._listeners[i].dispose();
            }
        }

        delete this._listeners;

        Streamline.SmartClient.ExceptionManager.callBaseMethod(this, 'dispose');
    },

    addListener : function(listener)
    {
        var e = Function._validateParams(arguments, [{name: 'listener', type: Streamline.SmartClient.BaseTraceListener}]);
        if (e) throw e;

        Array.add(this._listeners, listener);
    },

    removeListener : function(listener)
    {
        var e = Function._validateParams(arguments, [{name: 'listener', type: Streamline.SmartClient.BaseTraceListener}]);
        if (e) throw e;

        listener.dispose();

        Array.remove(this._listeners, listener);
    },

    publishException : function(errorCode, exception)
    {
   
        
        fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
        var e1 = Function._validateParams(arguments, [{name: 'errorCode', type: Number}, {name: 'exception', type: Error}]);
        var e2 = Function._validateParams(arguments, [{name: 'errorCode', type: Number}, {name: 'exception', type: Sys.Net.WebServiceError}]);
        
        if ((e1) && (e2))
        {
            throw e1;
        }

        if (this._listeners.length > 0)
        {
            var environmentInfo = this._getEnvironmentInfo();

            for(var i = 0; i < this._listeners.length; i++)
            {
                this._listeners[i].publishException(errorCode, exception, environmentInfo);
            }
        }
    },

    _getEnvironmentInfo : function()
    {
        var scriptTags = document.getElementsByTagName('script');
        var scripts = new Array(); 

        if (scriptTags)
        {
            for(var i = 0; i < scriptTags.length; i++)
            {
                var scriptTag = scriptTags[i];

                if (typeof scriptTag.src != 'undefined')
                {
                    if (scriptTag.src.length > 0)
                    {
                        Array.add(scripts, scriptTag.src + ' : ' + scriptTag.readyState);
                    }
                }
            }
        }

        var url = window.location.href;

        var referrer = '';

        if (document.referrer)
        {
            if (document.referrer.length > 0)
            {
                referrer = document.referrer;
            }
        }

        return {url:url, referrer:referrer, scripts:scripts};
    }
}

Streamline.SmartClient.ExceptionManager.registerClass('Streamline.SmartClient.ExceptionManager', Sys.Component);

//Making the ExceptionManager a Singleton Class, but unfortunately
//there is no way to restrict its constructor to be called.

Streamline.SmartClient.ExceptionManager._staticInstance = $create(Streamline.SmartClient.ExceptionManager, {'id':'exceptionManager'});

Streamline.SmartClient.ExceptionManager.getInstance = function()
{
    return Streamline.SmartClient.ExceptionManager._staticInstance;
}

if (typeof(Sys) != 'undefined')
{
    Sys.Application.notifyScriptLoaded();
}