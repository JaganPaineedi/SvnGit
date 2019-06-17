///<Author>Sony John</Author>
Type.registerNamespace('Streamline.SmartClient.UI');
Streamline.SmartClient.UI.TextBox = function(element) 
{
    Streamline.SmartClient.UI.TextBox.initializeBase(this, [element]);
    this._ignoreEnterKey = false;
    this._onBlur=null;
    this._events=null;
    this._Numeric=false; 
    this._Decimal=false;
    this._DateTime=false; 
    this._onKeyPress=null;
    
 
}
Streamline.SmartClient.UI.TextBox.prototype = {
initialize : function() {
    Streamline.SmartClient.UI.TextBox.callBaseMethod(this, 'initialize');
//    $removeHandler(this.get_element(),{keypress:this.$onKeyPress}, this);
    $addHandlers(this.get_element(),{keypress:this.$onKeyPress}, this);
//    $removeHandler(this.get_element(),{blur:this.$onBlur}, this);
    $addHandlers(this.get_element(),{blur:this.$onBlur}, this);
},
dispose : function() {
    $clearHandlers(this.get_element());
    Streamline.SmartClient.UI.TextBox.callBaseMethod(this, 'dispose');
},

    get_ignoreEnterKey : function() {
    return this._ignoreEnterKey;
    },
    set_ignoreEnterKey : function(value) {
    this._ignoreEnterKey = value;
    },
    get_Numeric : function() {
    return this._Numeric;
    },
    set_Numeric : function(value) {
    this._Numeric = value;
    },
    get_DateTime : function() {
    return this._DateTime;
    },
    set_DateTime : function(value) {
    this._DateTime = value;
    },
    get_Decimal : function() {
    return this._Decimal;
    },
    set_Decimal : function(value) {
    this._Decimal =value;
    },
    $onKeyPress : function (evt)
    {
        //this.$raiseEvent(this._onKeyPress,evt);
        if(this._ignoreEnterKey)
        {
            if(evt.charCode==13)
            {
                evt.preventDefault();
            }
        }
        if(this._onKeyPress)
            this._onKeyPress(this,evt);
        
    },
    $onBlur: function(evt)
    {
        if((evt.target.value!=null)&&(evt.target.value!=""))
        {
            if(this._Numeric)
            {
                try
                {       
                          
                   if(isNaN(Number.parseInvariant(evt.target.value)))                  
                         evt.target.value="";          
                   else if(Number.parseInvariant(evt.target.value)<0)         
                         evt.target.value="";                     
                   else if(evt.target.value.indexOf(".") >0)
                         evt.target.value="";                             
                   
                }
                catch(e)
                {
                    evt.target.value="";
                }
            }
            if(this._Decimal)
            {
                try
                {       
                          
                   if(isNaN(Number.parseInvariant(evt.target.value)))                  
                         evt.target.value="";          
                   else if(Number.parseInvariant(evt.target.value)<0)         
                         evt.target.value=""; 
                }
                catch(e)
                {
                    evt.target.value="";
                }
            }
            if(this._DateTime)
            {
                 try
                {
                    if((!Date.parse(evt.target.value)) || (Date.parse(evt.target.value)<0))
                        evt.target.value="";
                }
                catch(e)
                {
                    evt.target.value="";
                }
            }
        }
        if(this._onBlur)
            this._onBlur(this,evt);
    },
    
     $raiseEvent : function(eventName, eventArgs) 
     {   
        // Get handler for event.   
        var handler = this.get_events().getHandler(eventName);         
                                                                            
        if (handler) {                                              
            if (!eventArgs) {                                       
                eventArgs = Sys.EventArgs.Empty;                    
            }                             
  
            // Fire event.                             
            handler(this, eventArgs);                                  
        }     
            
    },   

    
    
    add_onKeyPress : function(value) {
    this._onKeyPress = value;
    },
    
    add_onBlur:function(value){
    this._onBlur=value;
    },
    
     get_events : function() 
     {   
        try
        {
            if(!this._events) 
            {   
                   this._events = new Sys.EventHandlerList();   
            }   
      
            return this._events;   
        }
        catch(e)
        {
            alert(e);
        }
        
    }   

}
//Added by Rishu for setting maxlength property of textarea textbox-specialinstructions.
// Keep user from entering more than maxLength characters
function doKeypress(control){
    maxLength = control.attributes["maxLength"].value;
    value = control.value;
     if(maxLength && value.length > maxLength-1){
          event.returnValue = false;
          maxLength = parseInt(maxLength);
     }
}
// Cancel default behavior
function doBeforePaste(control){
    maxLength = control.attributes["maxLength"].value;
     if(maxLength)
     {
          event.returnValue = false;
     }
}
// Cancel default behavior and create a new paste routine
function doPaste(control){
    maxLength = control.attributes["maxLength"].value;
    value = control.value;
     if(maxLength){
          event.returnValue = false;
          maxLength = parseInt(maxLength);
          var oTR = control.document.selection.createRange();
          var iInsertLength = maxLength - value.length + oTR.text.length;
          var sData = window.clipboardData.getData("Text").substr(0,iInsertLength);
          oTR.text = sData;
     }
}
Streamline.SmartClient.UI.TextBox.registerClass('Streamline.SmartClient.UI.TextBox', Sys.UI.Control);