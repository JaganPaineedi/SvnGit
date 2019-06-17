// JScript File

var RefreshCalled = false;


function HideToolbar(Url)
{
 window.open("","Title","Features");
}



var UserAgent = navigator.userAgent.toLowerCase();
// Function Created by Devinder to CheckBrowser
function IsIE6()
{
    try
    {
        if(UserAgent.indexOf('msie 6.0')>0 && UserAgent.indexOf('msie 7') < 0 ){return true;}
        else{return false;}
    }
    catch(ex)
    {
     
    }
}

function check_emailAddress(e)
{
	ok = "1234567890qwertyuiop[]asdfghjklzxcvbnm.@-_QWERTYUIOPASDFGHJKLZXCVBNM";
	for(i=0; i < e.length ;i++)
	{
		if(ok.indexOf(e.charAt(i))<0) return (false);	
	}
	if (document.images)
	 {
		re = /(@.*@)|(\.\.)|(^\.)|(^@)|(@$)|(\.$)|(@\.)/;
		re_two = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		if (!e.match(re) && e.match(re_two)) return (-1);
	}
}


function CheckDiryONClose()
{
    try
    {
         var HiddenFieldIsDiry= document.getElementById('HiddenFieldIsDiry');     
       if(HiddenFieldIsDiry!=null)
       {               
           if(HiddenFieldIsDiry.value=="true" || HiddenFieldIsDiry.value==true)
           {
                ShowDivASModelPopup('DivShowDirtyMsg',200,150);
                return false;
           }
           
       }
        return true;
    }
    catch(ex)
    {
        alert('CheckDiryONClose'+ex);
        return true;
    }
}

function HandleEnterKey(ButtonUniqueID,JavaScriptValidateFunction,event)
{
    var Key 
    try
    {
    
         //if ((event.which == 13) || (event.keyCode == 13))
         //Key =  event.which? event.which : event.charCode ? event.charCode : event.keyCode;
         Key =  event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        
    }
    catch(ex)
    {
    }

try
{   
    if(Key==13)
    {
    
    //alert('IsIE7OrLater()'+IsIE7OrLater());
           if(JavaScriptValidateFunction!='')
           {
                if(eval(JavaScriptValidateFunction))
                { 
                    if(document.getElementById(ButtonUniqueID)!=null)
                    {
                     if(document.getElementById(ButtonUniqueID).disabled==false)
                          {
                           document.getElementById(ButtonUniqueID).focus();
                          }
                    }
                    if(IsIE7OrLater()==false && IsWindowSafari()==false && IsMacSafari()==false )
                    {
                        if(document.getElementById(ButtonUniqueID)!=null)
                        {
                            
                            if(!IsFirefox())
                            {
                                document.getElementById(ButtonUniqueID).click();
                            }
                            
                        }
                    }
                    else if(IsMacSafari())
                    {
                        if(document.getElementById(ButtonUniqueID)!=null)
                        {       
                                document.getElementById(ButtonUniqueID).click();                                                     
                        }
                    }
                    return true;
                }
                else {return false;}
           }
           else
           {  
           
                if(document.getElementById(ButtonUniqueID)!=null)
                {
                  if(document.getElementById(ButtonUniqueID).disabled==false)
                  {                  
                   document.getElementById(ButtonUniqueID).focus();
                  }
                 
                }
                if(IsIE7OrLater()==false && IsWindowSafari()==false && IsMacSafari()==false)
                {
                     if(document.getElementById(ButtonUniqueID)!=null)
                      {
                        if (!IsFireFox())
                        {
                            document.getElementById(ButtonUniqueID).click();
                        }
                      }
                }
                 else if(IsMacSafari())
                    {
                        if(document.getElementById(ButtonUniqueID)!=null)
                        {                                                                              
                           document.getElementById(ButtonUniqueID).click();                                                      
                        }
                    }
                return true;
           }
           
    }
    else {return true;}
    
}
catch(ex)
{
    alert(ex);
}
}

// Function Created by Devinder to CheckBrowser
function IsIE7OrLater()
{
    if(UserAgent.indexOf('msie 7') >= 0){return true;}
    else if(UserAgent.indexOf('msie')>0){return true;}
    else {return false;}
}

// Function Created by Devinder to CheckBrowser
function IsFireFox()
{
	try
	{
		if(UserAgent.indexOf('firefox')>0){return true;}
		else { return false;}
	}
	catch(ex)
	{
		alert('IsFireFox--'+ex);
	}
}

// Function Created by Devinder to CheckBrowser
function IsWindowSafari()
{
	try
	{
		if(UserAgent.indexOf('safari')>0 && UserAgent.indexOf('window')>0){return true;}
		else { return false; }
    }
    catch(ex)
    {
		alert('IsWindowSafari--'+ex);
    }
}

// Function Created by Devinder to CheckBrowser
function IsMacSafari()
{
	try
	{
		if(UserAgent.indexOf('safari')>0 && UserAgent.indexOf('mac')>0){return true;}
		else { return false;}
    }
    catch(ex)
    {
		alert('IsMacSafari--'+ex);    
    }
}

// Function Created by Devinder to Get width fo Parent Window
function GetParentWindowWidth()
{
  if(IsIE6())
  {
        return parent.document.documentElement.offsetWidth;
  }
  else if(IsIE7OrLater())
  {
        return parent.document.documentElement.offsetWidth;
  }
  else if(IsFireFox())
  {

        return parent.document.documentElement.clientWidth;
  }
  else if(IsWindowSafari())
  {
        return parent.self.innerWidth;
  }
  else if(IsMacSafari())
  {
       return parent.self.innerWidth;
  }
  else // for all other brosers
  {
       return parent.document.documentElement.offsetWidth;
  }
}

// Function Created by Devinder to Get width fo Current Window
function GetCurrentWindowWidth()
{
  if(IsIE6())
  {
        return document.documentElement.offsetWidth;
  }
  else if(IsIE7OrLater())
  {
        return document.documentElement.offsetWidth;
  }
  else if(IsFireFox())
  {
        return document.documentElement.clientWidth;
  }
  else if(IsWindowSafari())
  {
        return self.innerWidth;
  }
  else if(IsMacSafari())
  {
       return  self.innerWidth;
       //document.documentElement.innerWidth;
  }
  else // for all other brosers
  {
       return document.documentElement.offsetWidth;
  }
}

// Function Created by Devinder to Get height fo Parent Window
function GetParentWindowHeight()
{
  if(IsIE6())
  {
        return parent.document.documentElement.offsetHeight;
  }
  else if(IsIE7OrLater())
  {
 
        return parent.document.documentElement.offsetHeight;
  }
  else if(IsFireFox())
  {
        return parent.document.documentElement.clientHeight;
  }
  else if(IsWindowSafari())
  {
        return parent.self.innerHeight;
  }
  else if(IsMacSafari())
  {
       return parent.self.innerHeight;
  }
  else // for all other brosers
  {
       return parent.document.documentElement.offsetHeight;
  }
}

// Function Created by Devinder to Get width fo Current Window
function GetCurrentWindowHeight()
{
  if(IsIE6())
  {
        return document.documentElement.offsetHeight;
  }
  else if(IsIE7OrLater())
  {
        return document.documentElement.offsetHeight;
  }
  else if(IsFireFox())
  {
        return document.documentElement.clientHeight;
  }
  else if(IsWindowSafari())
  {
        return self.innerHeight;
  }
  else if(IsMacSafari())
  {
    
       return self.innerHeight;
  }
  else // for all other brosers
  {
       return document.documentElement.offsetHeight;
  }
}

// Function Created by Devinder to Set Heigth of Control
function SetControlHeight(controlObject,intHeight)
{
 
 try
 {
  if(IsIE6())
  {
      controlObject.runtimeStyle.setAttribute("height",intHeight + "px");
  }
  else if(IsIE7OrLater())
  {
      controlObject.runtimeStyle.setAttribute("height",intHeight + "px");
  }
  else if(IsFireFox())
  {
      controlObject.style.height=intHeight + "px"
  }
  else if(IsWindowSafari())
  {
      controlObject.style.height=intHeight + "px"
  }
  else if(IsMacSafari())
  {
      controlObject.style.height=intHeight + "px"
  }
  else // for all other brosers
  {
      controlObject.style.height=intHeight + "px"
  }
  }
  catch(ex)
  {
  
  }
}

// Function Created by Devinder to Set Width of Control
function SetControlWidth(controlObject,intWidth)
{
  if(IsIE6())
  {
      controlObject.runtimeStyle.setAttribute("width",intWidth + "px");
  }
  else if(IsIE7OrLater())
  {
      controlObject.runtimeStyle.setAttribute("width",intWidth + "px");
  }
  else if(IsFireFox())
  {
      controlObject.style.width=intWidth + "px"
  }
  else if(IsWindowSafari())
  {
      controlObject.style.width=intWidth + "px"
  }
  else if(IsMacSafari())
  {
      controlObject.style.width=intWidth + "px"
  }
  else // for all other brosers
  {
      controlObject.style.width=intWidth + "px"
  }
}
      
 
 
 // Function Created by Devinder Pal Singh on 12 March 2008 to handle the height/widht of controls in diff browsers.
       function HandleAppPageControlsResize(ControlId,IE6Heigth,IE6Width,IE7Height,IE7Width,firefoxHeight,firefoxWidth,WinSafariHeight,WinSafariWidth,MacSafariHeight,MacSafariWidth)
       {
          try
          {
          
      
           var UserControl=document.getElementById(ControlId);
      
            if(UserControl!=null)
            {
                if(IsIE6())
                {
                    if(IE6Heigth  !='')
                    {
                        SetControlHeight(UserControl,GetCurrentWindowHeight()-IE6Heigth);
                        //UserControl.runtimeStyle.setAttribute("height", parent.document.documentElement.offsetHeight-IE6Heigth + "px");
                    }
                    if(IE6Width  != '')
                    {
                        SetControlWidth(UserControl,GetCurrentWindowWidth()-IE6Width);
                        //UserControl.runtimeStyle.setAttribute("width", parent.document.documentElement.offsetWidth-IE6Width + "px");
                    }
                }
                else if(IsIE7OrLater() ) // All other IE browsers like 7.1,
                {
                    if(IE7Height  !='')
                    {
                        SetControlHeight(UserControl,GetCurrentWindowHeight()-IE7Height); 
                        //UserControl.runtimeStyle.setAttribute("height", parent.document.documentElement.offsetHeight-IE7Height  + "px");
                    
                 
                    }
                    if(IE7Width  != '')
                    {
                        SetControlWidth(UserControl,GetCurrentWindowWidth()-IE7Width);  
                        //UserControl.runtimeStyle.setAttribute("width", parent.document.documentElement.offsetWidth-IE7Width + "px");
                    }
                }
                else if(IsFireFox())
                {
                    if(firefoxHeight !='')
                    {
                        SetControlHeight(UserControl,GetCurrentWindowHeight()-firefoxHeight);  
                       // UserControl.style.height=parent.document.documentElement.clientHeight- firefoxHeight + "px"; 
                    }
                    if(firefoxWidth !='')
                    {
                        SetControlWidth(UserControl,GetCurrentWindowWidth()-firefoxWidth); 
                        //UserControl.style.width=parent.document.documentElement.clientWidth- firefoxWidth  + "px"; 
                    }
                }
                else if(IsWindowSafari()) // Window Safari
                {
                    if(WinSafariHeight  !='')
                    {
                        SetControlHeight(UserControl,GetCurrentWindowHeight()-WinSafariHeight);
                        //UserControl.style.height=parent.document.documentElement.innerHeight- WinSafariHeight  + "px"; 
                    }
                    if(WinSafariWidth  !='')
                    {
                        SetControlWidth(UserControl,GetCurrentWindowWidth()-WinSafariWidth);
                        //UserControl.style.width=parent.document.documentElement.innerWidth- WinSafariWidth   + "px"; 
                    }
                }
                else if(IsMacSafari()) // MAC Safari.
                {
                    if(MacSafariHeight  !='')
                    {
                        
                        SetControlHeight(UserControl,GetCurrentWindowHeight()-MacSafariHeight);
                        //UserControl.style.height=parent.document.documentElement.innerHeight- MacSafariHeight  + "px"; 
                       
                    }
                    if(MacSafariWidth  !='')
                    {
                        SetControlWidth(UserControl,GetCurrentWindowWidth()-MacSafariWidth);
                        //UserControl.style.width=parent.document.documentElement.innerWidth- MacSafariWidth  + "px"; 
                    }
                }
            }
          }
          catch(ex)
          {
            
          }
        
       }
      
       
       
       // Function Created by Devinder Pal Singh on 12 March 2008 to handle the height/widht of controls in diff browsers.
       function HandleBasePageControlsResize(ControlId,IE6Heigth,IE6Width,IE7Height,IE7Width,firefoxHeight,firefoxWidth,WinSafariHeight,WinSafariWidth,MacSafariHeight,MacSafariWidth)
       {
          
           try
          {          
          
           var UserControl=document.getElementById(ControlId);
           
          
           
        
            if(UserControl!=null)
            {
         
                 if(IsIE6())
                {
                    if(IE6Heigth  !='')
                    {
                        SetControlHeight(UserControl,GetParentWindowHeight()-IE6Heigth);
                        //UserControl.runtimeStyle.setAttribute("height", parent.document.documentElement.offsetHeight-IE6Heigth + "px");
                    }
                    if(IE6Width  != '')
                    {
                        SetControlWidth(UserControl,GetParentWindowWidth()-IE6Width);
                        //UserControl.runtimeStyle.setAttribute("width", parent.document.documentElement.offsetWidth-IE6Width + "px");
                    }
                }
                else if(IsIE7OrLater() ) // All other IE browsers like 7.1,
                {
                    if(IE7Height  !='')
                    {
                        SetControlHeight(UserControl,GetParentWindowHeight()-IE7Height); 
                        //UserControl.runtimeStyle.setAttribute("height", parent.document.documentElement.offsetHeight-IE7Height  + "px");
                    }
                    if(IE7Width  != '')
                    {
                        SetControlWidth(UserControl,GetParentWindowWidth()-IE7Width);  
                        //UserControl.runtimeStyle.setAttribute("width", parent.document.documentElement.offsetWidth-IE7Width + "px");
                    }
                }
                else if(IsFireFox())
                {
              
                
                    if(firefoxHeight !='')
                    {
                        SetControlHeight(UserControl,GetParentWindowHeight()-firefoxHeight);  
                       // UserControl.style.height=parent.document.documentElement.clientHeight- firefoxHeight + "px"; 
                    }
                    if(firefoxWidth !='')
                    {
                        SetControlWidth(UserControl,GetParentWindowWidth()-firefoxWidth); 
                        //UserControl.style.width=parent.document.documentElement.clientWidth- firefoxWidth  + "px"; 
                    }
                }
                else if(IsWindowSafari()) // Window Safari
                {
                    if(WinSafariHeight  !='')
                    {
                        SetControlHeight(UserControl,GetParentWindowHeight()-WinSafariHeight);
                        //UserControl.style.height=parent.document.documentElement.innerHeight- WinSafariHeight  + "px"; 
                    }
                    if(WinSafariWidth  !='')
                    {
                        SetControlWidth(UserControl,GetParentWindowWidth()-WinSafariWidth);
                        //UserControl.style.width=parent.document.documentElement.innerWidth- WinSafariWidth   + "px"; 
                    }
                }
                else if(IsMacSafari()) // MAC Safari.
                {
                    if(MacSafariHeight  !='')
                    {
                        SetControlHeight(UserControl,GetParentWindowHeight()-MacSafariHeight);
                        //UserControl.style.height=parent.document.documentElement.innerHeight- MacSafariHeight  + "px"; 
                    }
                    if(MacSafariWidth  !='')
                    {
                        SetControlWidth(UserControl,GetParentWindowWidth()-MacSafariWidth);
                        //UserControl.style.width=parent.document.documentElement.innerWidth- MacSafariWidth  + "px"; 
                    }
                }
            }
            }
            catch(ex)
            {
               alert('HandleBasePageControlsResize'+ex);
            }
        
       }     

// Created by:Devinder
// Created Date:12 June 2008
// Purpose : This function appends the event with control
function addEvent(obj, eventType, afunction, isCapture)
{
    if (obj.addEventListener) 
    {
        obj.addEventListener(eventType, afunction, isCapture);
        return true;
    }
    else if (obj.attachEvent) 
    {
        return obj.attachEvent("on"+eventType, afunction);
    }
    else return false;
}

// Created by:Devinder
// Created Date:30 April 2008
// Purpose : This function Closes the div opened as model popup through function 'ShowDivASModelPopup()'
// obj - Control, evnetType - eg change/click , afunction - function on raise on event , iscapture - true
function removeEvent(obj, eventType, afunction, isCapture)
{
    if (obj.removeEventListener) 
    {
        obj.removeEventListener(eventType, afunction, isCapture);
        return true;
    }
    else if (obj.detachEvent)
    {
        return obj.detachEvent("on"+eventType, afunction);
    }
    else return false;
}
 
 function StopEvents(ev) {
	ev || (ev = window.event);
	if (IsIE6 || IsIE7OrLater ) {
		ev.cancelBubble = true;
		ev.returnValue = false;
	} else {
		ev.preventDefault();
		ev.stopPropagation();
	}
	return false;
};
 
// Created by:Devinder
// Created Date:30 April 2008
// Purpose : Set the Hiddenvalue for Dirty'
function SetDirty()
{
      var HiddenFieldIsDiry= document.getElementById('HiddenFieldIsDiry');
      if(HiddenFieldIsDiry!=null)
      {
        HiddenFieldIsDiry.value='true';
      }
      
}

// Created by:Devinder
// Created Date:16 June 2008
// Purpose : Close the Show Dirty Dialog.
function SaveDirtyCheck()
{
    try
    {
            try
            {
              Page_ClientValidate()
            }
            catch(e){}
     //       Page_ClientValidate();
        var HiddenFieldIsDiry= document.getElementById('HiddenFieldIsDiry');
        if(HiddenFieldIsDiry!=null)
        {
             HiddenFieldIsDiry.value="";
        }
//        var ButtonUpdate=document.getElementById('ButtonUpdate');
//        if(ButtonUpdate!=null)
//        {
//            ButtonUpdate.focus();
//            ButtonUpdate.click();
//        }
       HideDivASModelPopup('DivShowDirtyMsg');
       
       return true;
    
    }
    catch(ex)
    {
        alert('SaveDirtyCheck'+ex);
        return false;
    }
}
// Created by:Devinder
// Created Date:16 June 2008
// Purpose : Close the Show Dirty Dialog.
function CancelDirtyCheck()
{
    try
    {
        HideDivASModelPopup('DivShowDirtyMsg');
        return false;
    }
    catch(ex)
    {
        alert(ex);
    }

}

// Created by:Devinder
// Created Date:16 June 2008
// Purpose : Close the Show Dirty Dialog. and fire the close button event
function CloseDirtyCheck()
{
    try
    {   
         var HiddenFieldIsDiry= document.getElementById('HiddenFieldIsDiry');         
        if(HiddenFieldIsDiry!=null)
        {
            HiddenFieldIsDiry.value="";
        }        
        var ButtonCancel=document.getElementById('ButtonCancel');
        if(ButtonCancel!=null)
        {         
            ButtonCancel.focus();
            ButtonCancel.click();
        }
       
       HideDivASModelPopup('DivShowDirtyMsg');
       
       return false;
    }
    catch(ex)
    {
        alert('CancelDirtyCheck'+ex)
        return false;
    }

}
// Created by:Devinder
// Created Date:30 April 2008
// Purpose : Attach change event on all cotrols
function SetEventsForDiryCheck()
{
    try
    {
    
       var HiddenFieldIsDiry= document.getElementById('HiddenFieldIsDiry');
       if(HiddenFieldIsDiry!=null)
       {
         HiddenFieldIsDiry.value='false';
        }
        var inputs= document.getElementsByTagName("input");
        for (i = 0; i < inputs.length; i++)
        { 
            addEvent(inputs[i],'change',SetDirty,true);
        }
        
        inputs= document.getElementsByTagName("select");
        for (i = 0; i < inputs.length; i++)
        { 
            addEvent(inputs[i],'change',SetDirty,true);
        }
        
        inputs= document.getElementsByTagName("TextArea");
        for (i = 0; i < inputs.length; i++)
        { 
            addEvent(inputs[i],'change',SetDirty,true);
        }
        
//        inputs= document.getElementsByTagName("radio");
//        for (i = 0; i < inputs.length; i++)
//        { 
//            alert('radio'+inputs[i].id);
//            addEvent(inputs[i],'change',SetDirty,true);
//        }
//        
//        inputs= document.getElementsByTagName("checkboxs");
//        for (i = 0; i < inputs.length; i++)
//        { 
//            alert('checkboxes'+inputs[i].id);
//            addEvent(inputs[i],'change',SetDirty,true);
//        }
        
        
        


    }
    catch(ex)
    {
        alert('IsDirty'+ex);
    }
}




//Function to check special Characters
//Created by Manmeet on Oct 30,2008
function IgnoreSpecialCharacters(txtBox)
{
    try
    {    
    var checkOK = "\~!@#%^*+={}<>?/";
    var checkStr = document.getElementById(txtBox);
    var allValid = true;
    var allNum = "";
    for (i = 0; i< checkStr.value.length; i++)
    {
        ch = checkStr.value.charAt(i);        
        for (j = 0; j < checkOK.length; j++)
        {        
            if (ch == checkOK.charAt(j))
            {
                allValid = false;
                break;
            }
            if (j == checkOK.length-1)
            {
                break;
            }
        }
        if(allValid==false)
        {
            checkStr.value = '';
            break;
        }
    }
    if (!allValid)
    return (false);
    }
    catch(ex)
    {
		//alert('IgnoreSpecialCharacters--'+ex);
    }
}


//Function to check special Characters in Company Name,proposalName,in Admin Program Name
//Created by Damanpreet on Jan 07 2008
//Modified by Damanpreet on July 08 2008
//to avoid  " ' "
//Modified by Damanpreet on Sep 03 2008
/// <Version No=2>To allow allow single quotes</Version>
/// <Ace Desc>Task #296 Company/Proposal Name does not allow single quotes</Ace>
function AllowSpecialCharacters(str)
{
    try
    {
    var checkOK = "~!@#%^*+={}<>?";
    var checkStr = str;
    var allValid = true;
    var allNum = "";
    for (i = 0; i< checkStr.length; i++)
    {
        ch = checkStr.charAt(i);        
        for (j = 0; j < checkOK.length; j++)
        {        
            if (ch == checkOK.charAt(j))
            {
                allValid = false;
                break;
            }
            if (j == checkOK.length-1)
            {
                break;
            }
        }
        if(allValid==false)
        {
            break;
        }
    }
    if (!allValid)
    return (false);
    }
    catch(ex)
    {
		alert('AllowSpecialCharacters--'+ex);
    }
}
//Function to check First Character Alphabet in Company Name,ProposalName,PLan Name etc
//Created by Damanpreet on Jan 07 2008
function FirstCharacterAlphabet(str)
{
    try
    {    
    var checkStr = str;
    var allValid = true;
    var allNum = "";
    if( checkStr.length>0)
    {
        var chr=checkStr.substring(0, 1);
       // ch = checkStr.charAt(1);
       if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z"))        
          {
                allValid = true;                
          } 
       else
       {
                allValid = false;
       }
    }
    if (!allValid)
    return (false);
    }
    catch(ex)
    {
      alert('FirstCharacterAlphabet--'+ex);
    }
}
// Removes leading whitespaces
//Written by Devinder on 6/3/08
function LTrim( value )
{
	var re = /((\s*\S+)*)\s*/;
	var oldval=value;
	return oldval.toString().replace(/\s*((\S+\s*)*)/, '$1');
}

// Removes ending whitespaces
//Written by Devinder on 6/3/08
function RTrim( value )
 {
	var re = /((\s*\S+)*)\s*/;
	var oldval=value;
	return oldval.toString().replace(/((\s*\S+)*)\s*/, '$1');
}

//Temporary commented by Damanpreet on April 04 2008
// Function Created By Devinder to Removes leading and ending whitespaces
//function trim( strvalue ) 
//{
//    try
//    {
//       //if(strvalue==0) return 0; // Temp solution, Need to fix this issue
//	    var oldval=strvalue;
//	    var newval= oldval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
//	    return newval;
//	}
//	catch(ex)
//	{
//	   
//	}
//}


function trim(str)
		{
			var i,j,strText;
			i = 0;
			j=str.length-1;
			str = str.split("");
			while(i < str.length)
			{
				if(str[i]==" ")
					str[i] = "";
				else
					break;
				i++;
			}
			while(j > 0)
			{
				if(str[j]== " ")
					str[j]="";
				else
					break;
				j--;
			}
			return str.join("");
		}


/// Function created by Devinder to encode the test. like @,&,=,? 
 function encodeText(TextToEncode) 
 {
    try
    {
     var encodedHtml = escape(TextToEncode);
     ///encodedHtml = encodedHtml.replace(/\//g,"%2F");
     //encodedHtml = encodedHtml.replace(/%/g,"%25");
     encodedHtml = encodedHtml.replace(/\?/g,"%3F");
     encodedHtml = encodedHtml.replace(/=/g,"%3D");
     encodedHtml = encodedHtml.replace(/&/g,"%26");
     encodedHtml = encodedHtml.replace(/@/g,"%40");
     
     encodedHtml = encodedHtml.replace(/\+/g,"%2B");
//     encodedHtml = encodedHtml.replace(/~/g,"%7E");
//     encodedHtml = encodedHtml.replace(/%/g,"%25");
     //encodedHtml = encodedHtml.replace(/ /g,"%25");
     
     return encodedHtml;
    }
    catch(ex)
    {
        alert('encodeText'+ex);
    }
 }

// Function created by devinder to set the value of label.
function SetLabelValue(LabelObject,value,htmlFormat)
{

        var NewValue=value.toString();
        try
        {
            if (window.navigator.appVersion.indexOf('MSIE')>0) // IE
            {
                var  intIndexOfMatch = NewValue.indexOf('<BR>');
                while (intIndexOfMatch != -1)
                {
                    NewValue = NewValue.replace( "<BR>", "\n" )
                    intIndexOfMatch = NewValue.indexOf('<BR>');
                }
                var intIndexOfMatch = NewValue.indexOf('<br>');
                while (intIndexOfMatch != -1)
                {
                    NewValue = NewValue.replace( "<br>", "\n" );
                    intIndexOfMatch = NewValue.indexOf('<br>');
                }
            }
            else if (window.navigator.appVersion.indexOf('MSIE')<=0) // FireFox
            {
            var intIndexOfMatch = NewValue.indexOf('\n');
                while (intIndexOfMatch != -1)
                {
                    NewValue = NewValue.replace( "\n", "<BR>" );
                    intIndexOfMatch = NewValue.indexOf('\n');
                }
                var intIndexOfMatch = NewValue.indexOf('\n');
                while (intIndexOfMatch != -1)
                {
                    NewValue = NewValue.replace( "\n", "<BR>" );
                    intIndexOfMatch = NewValue.indexOf('\n');
                }
            }
          
            
         if (UserAgent.indexOf('safari')>0 )
         {
             LabelObject.innerHTML=NewValue; 
         }
         else if(UserAgent.indexOf('firefox')>0 )
         {
            if(htmlFormat==true){ LabelObject.innerHTML=NewValue; }
                else {LabelObject.textContent=NewValue }; 
         }
         else if(UserAgent.indexOf("msie")>0)
         {
           LabelObject.innerText=NewValue;
         }
         else // for other browsers
         {
            LabelObject.innerHTML=NewValue; 
         }
       }
       catch(ex)
       {
     
       }
    }

// function created by devinder to get the value of label
function GetLabelValue(LabelObject)
{

    try
    {

         var UserAgent = navigator.userAgent.toLowerCase();
         if (UserAgent.indexOf('safari')>0 )
         {
            return LabelObject.innerHTML;
         }
         else if(UserAgent.indexOf('firefox')>0 )
         {
            return LabelObject.textContent;
         }
         else if(UserAgent.indexOf("msie")>0)
         {
           return LabelObject.innerText;
         }
    }
    catch(ex)
    {
    
    }
//    if (document.all){ return LabelObject.innerText;}
//    else{ return LabelObject.innerHTML;}; 

}


/// Used In : ClaimEntryProfessional
/// This function is used to Set the focus of any control
/// <Author>Pralyankar Kumar Singh</Author>
/// <Created>5st-Sp-2007</Created>
function SetFocus(TextBoxControl)
{
    var _TextBoxControl = document.getElementById(TextBoxControl);
    _TextBoxControl.focus();            
}

/// This function is used to validate the date value
/// <Author>Pralyankar Kumar Singh</Author>
/// <Created>25 Sep 2007</Created>
function validateDate(fld) 
{
    try
    {
        var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
        var errorMessage = 'Please enter valid date as month, day, and four digit year.\nYou may use a slash, hyphen or period to separate the values.\nThe date must be a real date. 2-30-2000 would not be accepted.\nFormay mm/dd/yyyy.';
        if ((fld.value.match(RegExPattern)) && (fld.value!='')) 
        {
            return true;
        } 
        else 
        {        
            return false;
        } 
    }
    catch(err)
    {
        return false;
    }
}

var mikExp = /[$\\@\\\#%\^\&\*\(\)\[\]\+\_\{\}\`\~\=\|]/;
function dodacheck(val)
 {
    var strPass = val.value;
    var strLength = strPass.length;
    var lchar = val.value.charAt((strLength) - 1);
    if(lchar.search(mikExp) != -1) 
    {
        var tst = val.value.substring(0, (strLength) - 1);
        val.value = tst;
    }
}


function ValidDecimal(control)
{
    try
    {
        control.value=trim(control.value);
        if(control.value.length==1)
        {
            if(control.value=='.')
            {
                control.value='';
                return;
            }
        }
        if(control.value.substring(0,1)=='.')  //   add . is at first index add 0.
        {
            control.value='0'+control.value; 
        }
        if(control.value.substring(control.value.length-1)=='.') // if . is at last index add .0
        {
            control.value=control.value+'0';
        }
        
        control.value= ReplaceAllOccurances(control.value,',','');  // Remove all occurances of ','
        control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$'
        
        for(var i=0;i<control.value.length;i++)
        {               
        if(control.value.charAt(i)=='$' )
        {
        control.value = control.value.replace("$","");            
        }              
        }  
       
        
			if( /^\d+(\.\d+)?$/.test(control.value)==false)
        {   
            control.value='';
        }
//        if(control.value.indexOf('.')>0) // round decimal values to 2 precision.
//        {

//            control.value=control.value.substring(0,control.value.indexOf('.')+3);
//        }

    control.value=formatNumber(control.value,'2',',','.','','','','');
        
    }
    catch(ex)
    {
     
    }   
    
  
}




///Used this function in calldetail page as to check decimal numbers
/// <Author>Manmeet Singh</Author>
/// <Created>15 July 2008</Created>

function ValidDecimalForCallDetail(control)
{
    try
    {
        control.value=trim(control.value);
        if(control.value.length==1)
        {
            if(control.value=='.')
            {
                control.value='';
                return;
            }
        }
        if(control.value.substring(0,1)=='.')  //   add . is at first index add 0.
        {
            control.value='0'+control.value; 
        }
        if(control.value.substring(control.value.length-1)=='.') // if . is at last index add .0
        {
            control.value=control.value+'0';
        }
        
        control.value= ReplaceAllOccurances(control.value,',','');  // Remove all occurances of ','
        control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$'
        
        for(var i=0;i<control.value.length;i++)
        {               
        if(control.value.charAt(i)=='$' )
        {
        control.value = control.value.replace("$","");            
        }              
        }  
       
     //  if(control.value='0.00')
      // {
          //  control.value='';
      // }
        
        if( /^\d+(\.\d+)?$/.test(control.value)==false)
        {   
            control.value='';
        }
//        if(control.value.indexOf('.')>0) // round decimal values to 2 precision.
//        {

//            control.value=control.value.substring(0,control.value.indexOf('.')+3);
//        }


    control.value=formatNumber(control.value,'2',',','.','','','','');
    if(control.value == '0.0' || control.value == '0.00')    
    {        
       control.value=''; 
    }
        
    }
    catch(ex)
    {
     
    }   
    
  
}




// Function ReplaceAllOccurances - Replace All ocurrances of old value with new value
// Created by Devinder on 23 Jan 2008.
//Modified by Damanpreet on March 04 2008 to trim the result
function ReplaceAllOccurances(strValue ,oldch,newchar) {
try
{
  var objRegExp = eval("/" + oldch + "/g");  
  var val =strValue.toString();
  
  if( val != 0 && val != '' && val!=null && val!=undefined)
  {
    return val.replace(objRegExp,newchar);
  }
  else
  {
    return trim(strValue);
  }
  }
  catch(ex)
  {
  
  }
}

    // Function FormatNumber
    // num - Actual Number
    // dec - Decimal places 0 for integer
    // thou - thousand seprator eg ','
    // pnt  - for decimal symblo eg '.'
    // curr1 - symbol that you want to prefix the number. eg 1) $ for currencty 2) ''(empty) for non symbol
    // curr2 - symbol that you want to postfix the number. eg 1) $ for currencty 2) ''(empty) for non symbol
    // n1, n2- sysmbol to place around the number when the value is negative
    function formatNumber(num,dec,thou,pnt,curr1,curr2,n1,n2)
    {
		try
		{
			  if( num != 0 && num != '' && num!=null && num!=undefined)
			  {
				  num= ReplaceAllOccurances(num,',','');
				  //num= ReplaceAllOccurances(num,'$','');
				  for(var i=0;i<num.length;i++)
				  {               
					if(num.charAt(i)=='$' )
					{
						num = num.replace("$","");            
					}              
				 }
				var x = Math.round(num * Math.pow(10,dec));
				if (x >= 0) n1=n2='';
				var y = (''+Math.abs(x)).split('');
				var z = y.length - dec; 
				if (z<0) z--; 
				for(var i = z; i < 0; i++) 
				y.unshift('0');
				y.splice(z, 0, pnt); 
				if(y[0] == pnt) 
				y.unshift('0'); 
				while (z > 3) 
				{
					z-=3; 
					y.splice(z,0,thou);
				}
				var r = curr1+n1+y.join('')+n2+curr2;
				return r;
			}		
			else
			{
				return num;
			}
		}
        catch(ex)
        {
           
        }
    }

function ValidInteger(control)
{

  try
  {
  control.value=trim(control.value);
    control.value= ReplaceAllOccurances(control.value,',','');
    control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$' 
   
   
    if(!/\D/.test(control.value)==false)
    {
        control.value='';
    }
   
    control.value=formatNumber(control.value,'0',',','','','','','');
  }
  catch(ex)
  {
   
  }

}
//Created By Sanvir Kumar on April 08, 2008
//If control is not having integer value thenclear the control
function ValidateNumber(control)
{

  try
  {
    control.value=trim(control.value);
    control.value= ReplaceAllOccurances(control.value,',','');
    control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$' 
   
   
    if(!/\D/.test(control.value)==false)
    {
        control.value='';
    }
   
   // control.value=formatNumber(control.value,'0',',','','','','','');
  }
  catch(ex)
  {
   
  }

}
//Created By Sanvir Kumar on May 27 2009
//If control is not having integer value thenclear the control
function ValidateDecimal(control,DecimalPlaces)
{
   try
    {
        control.value=trim(control.value);
        if(control.value.length==1)
        {
            if(control.value=='.')
            {
                control.value='';
                return;
            }
        }
        if(control.value.substring(0,1)=='.')  //   add . is at first index add 0.
        {
            control.value='0'+control.value; 
        }
        if(control.value.substring(control.value.length-1)=='.') // if . is at last index add .0
        {
            control.value=control.value+'0';
        }
        
        control.value= ReplaceAllOccurances(control.value,',','');  // Remove all occurances of ','
        control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$'
        
        for(var i=0;i<control.value.length;i++)
        {               
            if(control.value.charAt(i)=='$' )
            {
            control.value = control.value.replace("$","");            
            }              
        }  
       
        
		if( /^\d+(\.\d+)?$/.test(control.value)==false)
        {   
            control.value='';
        }
        control.value=formatNumber(control.value,DecimalPlaces,'','.','','','','');        
    }
    catch(ex)
    {     
    }  
}

function IsInteger(num)
{
    try
    {
        num = ReplaceAllOccurances(num,',','');
        num = ReplaceAllOccurances(num,'$','');  // Remove all occurances of '$' 
        if(!/\D/.test(num)==false)
        {
            return false;
        }   
        return true;
    }
    catch(ex)
    {
        return false;
    }

}
function IsDecimal(num)
{
    try
    {   
        if(num.length==1)
        {
            if(num == '.')
            {
                return false;
            }
        }
        if(num.substring(0,1)=='.')  //   add . is at first index add 0.
        {
            num = '0'+ num; 
        }
        if(num.substring(num.length-1)=='.') // if . is at last index add .0
        {
            num= num +'0';
        }
        num = ReplaceAllOccurances(num,',','');  // Remove all occurances of ','
        num = ReplaceAllOccurances(num,'$','');  // Remove all occurances of '$'
        for(var i=0;i<num.length;i++)
        {               
            if(num.charAt(i)=='$' )
            {
                num = num.replace("$","");            
            }              
        }  
        if( /^\d+(\.\d+)?$/.test(num)==false)
        { 
            return false;
        }
         return true;
        
    }
    catch(ex)
    {
         return false;
    }   
}

function  AllowValidChars(val)
{

    //var mikExp = /[$\\@\\\#%\^\&\*\(\)\[\]\+\_\{\}\`\~\=\|]/;
    var mikExp = /[$\\@\\\#%\^\*\(\)\[\]\+\_\{\}\`\~\=\|\!\<\>]/;
    if(val.search(mikExp) == -1)
    {
    
        return true;
    }
    else
    {
        return false;
    }
}

function AllowDecimal(e,control)
{
    try
    {
        var key = window.event ? e.keyCode : e.which;  
        
        if(navigator.appName == "Netscape")
        {
            if(key==0) // Allow Arrow key 
            {
                return true;
            }
        } 
      
                
         if(key==46) // Allow Decimal
         {
            if(control.value.indexOf('.')>=0) // Allow only one decimal
            {
                 return false;
            } 
            else
            {
              return true;
            }
         }
         
        
        if((key>= 48 && key<= 57) || key == 13 || key == 8 ||  key == 9 )
        { 
            return true;               
        }
        else
        {
             return false;
        }
    }
    catch(er)
    {
       
    }
}
//Added BY Sanvir on Jan 11, 2008
//Plan Information Step One BP
// To allow only numeric values
function AllowNumericOnlyExceptZero(e)
{
    try
    {
        var key = window.event ? e.keyCode : e.which;  
     
        if(navigator.appName == "Netscape")
        {
            if(key==0) // Allow Arrow key 
            {
                return true;
            }
        } 
        
        if((key> 48 && key<= 57) || key == 13 || key == 8 ||  key == 9 )
        { 
            return true;               
        }
        else
        {
             return false;
        }
    }
    catch(err)
    {
     
    }
}
//Added BY Sanvir on Jan 11, 2008
//Plan Information Step One BP
// To allow only numeric values and Alphabets
function AllowNumericAndAlphabets(e)
{
    try
    {
        var key = window.event ? e.keyCode : e.which;  
   
        if(navigator.appName == "Netscape")
        {
            if(key==0) // Allow Arrow key 
            {
                return true;
            }
        } 
        
        if((key>= 48 && key<= 57) ||(key>= 65 && key<= 90) ||(key>= 97 && key<= 122) || key == 13 || key == 8 ||  key == 9 )
        { 
            return true;               
        }
        else
        {
             return false;
        }
    }
    catch(err)
    {
     
    }
}

// To allow only numeric values
function AllowNumericOnly(e)
{
    try
    {
        var key = window.event ? e.keyCode : e.which;  
    
        if(navigator.appName == "Netscape")
        {
            if(key==0) // Allow Arrow key 
            {
                return true;
            }
        } 
        
        if((key>= 48 && key<= 57) || key == 13 || key == 8 ||  key == 9 )
        { 
            return true;               
        }
        else
        {
             return false;
        }
    }
    catch(err)
    {
    
    }
}

// Created by:Devinder
// Created Date:30 April 2008
// Purpose : This function Opens the div as model popup
//Modified By :Damanpreet Kaur
//Modified Date :27 May 2008
//Purpose : BP Task #243 --	Save As: Default cursor should on 'Enter New Proposal Name' (Mozilla FFox)
//Modified the  DivControl style. 
function ShowDivASModelPopup(DivControlName,left,top,showCoverAll,controlNameToFocus)
{
    try
    {
    
        var   UpdatePanel1=document.getElementById('UpdatePanel1');
        
        var divCover=null;
        
        divCover=document.getElementById('DivCoverBasePage');
        var iframePopup=document.getElementById('iframePopup');
        
        if(divCover==null)
        { 
            //var divCover= document.createElement("div");
            divCover= document.createElement("div");
            
            divCover.id="DivCoverBasePage";
            divCover.style.display='none';
            if(UpdatePanel1!=null)
            {
                UpdatePanel1.appendChild(divCover);
            }
            else
            {
                document.body.appendChild(divCover); 
            }
                  
        } 
            
        
//       if(IsFireFox())
//       {
//            divCover.setAttribute("class", "transparentPopup"); 
//            divCover.setAttribute("className", "transparentPopup"); 
//            divCover.style.cssText = 'position:absolute;z-index: 100;width:98%;left:1px;top:1px;filter: alpha(opacity=50);-moz-opacity: .5;background:#ccc;padding:5px;';
//       }
//       else
//       {
//            divCover.style.cssText = 'position:absolute;z-index: 100;width:98%;left:1px;top:1px;filter: alpha(opacity=50);-moz-opacity: .5;background:#ccc;padding:5px;';
//            //divCover.style.cssText = 'position:absolute;height:450px;width:100%;left:1px;top:1px;filter: alpha(opacity=50);-moz-opacity: .5;background:#ccc;padding:5px;';
//       }
       if(showCoverAll!=false || showCoverAll=='false')
       {
         divCover.style.cssText = 'position:absolute;z-index: 100;width:98%;left:1px;top:1px;filter: alpha(opacity=50);-moz-opacity: .5;background:#ccc;padding:5px;opacity: 0.5;';
          divCover.style.display='block';
          //alert(document.body.scrollHeight);
          //SetControlHeight(divCover,parent.document.body.scrollHeight-90);
          
         // SetControlHeight(divCover,document.body.clientHeight);
        }  
        
          
        //divCover.style.zIndex="100";
        //   divCover.style.zIndex=100;
        //  divCover.style.position="absolute";         
        var DivControlToPopup=document.getElementById(DivControlName);  
//          if(left=='')
//          {
//            left= (GetParentWindowWidth() - (scrollWidth/2))/2;
//          }      
//          if(top=='')
//          {
//            top= (GetParentWindowHeight()- (DivControlToPopup.style.height/2))/2;
//          }
        var height;
        var width;
        if(DivControlToPopup!=null)
        {
            //DivControl.style.cssText = 'position:absolute;left:'+left+'px;top:'+top+'px;display:block;';
            DivControlToPopup.style.cssText = 'position:absolute;z-index: 315;left:'+left+'px;top:'+top+'px;display:block;overflow:auto;';
            // DivControl.style.cssText = 'position:absolute;z-index: 300;left:80px;top:46px';
           height=DivControlToPopup.style.height;
           width=DivControlToPopup.style.width;
        }

        if(iframePopup!=null)
        {
           
          iframePopup.style.cssText = 'position:absolute;z-index: 315;left:'+left+'px;top:'+top+'px;height:'+height+'px;width:'+width +'px;display:block;overflow:auto;'
          iframePopup.style.display='block';
          
        } 
        return ;
        // DivControlToPopup.style.zIndex=divCover.style.zIndex+10;
        if(controlNameToFocus!=null)
        {
          var ctrToFocus= document.getElementById(controlNameToFocus);
          if(ctrToFocus!=null)
          {
              ctrToFocus.style.visibility='visible';
              try{ctrToFocus.focus();}catch(e){}
          }
        }
    }
    catch(ex)
    {
        alert('ShowDivASModelPopup'+ex);
    }
}
// Created by:Devinder
// Created Date:30 April 2008
// Purpose : This function Closes the div opened as model popup through function 'ShowDivASModelPopup()'
function HideDivASModelPopup(DivControlName)
{
    try
    {
        var DivControl=document.getElementById(DivControlName);
        if(DivControl !=null)
        {
            DivControl.style.display='none';
            
        }
        var iframePopup=document.getElementById('iframePopup');
        if(iframePopup!=null)
        {
          iframePopup.style.display='none';
        }
        
      
        
        var divCover=null;
     
 
        divCover=document.getElementById('DivCoverBasePage');
        
        if(divCover)
        {
            divCover.style.display='none';
               // document.body.removeChild('DivCoverPage');
        }
    }
    catch(ex)
    {
        alert('HideDivASModelPopup'+ex);
    }
}


//Validates the date and returns boolean value
function isDate(p_Expression)
{
	return !isNaN(new Date(p_Expression));	
}

function dateAdd(p_Interval, p_Number, p_Date)
{
	if(!isDate(p_Date)){return "invalid date: '" + p_Date + "'";}
	if(isNaN(p_Number)){return "invalid number: '" + p_Number + "'";}	

	p_Number = new Number(p_Number);
	var dt = new Date(p_Date);
	switch(p_Interval.toLowerCase()){
		case "yyyy": {// year
			dt.setFullYear(dt.getFullYear() + p_Number);
			break;
		}
		case "q": {		// quarter
			dt.setMonth(dt.getMonth() + (p_Number*3));
			break;
		}
		case "m": {		// month
			dt.setMonth(dt.getMonth() + p_Number);
			break;
		}
		case "y":		// day of year
		case "d":		// day
		case "w": {		// weekday
			dt.setDate(dt.getDate() + p_Number);
			break;
		}
		case "ww": {	// week of year
			dt.setDate(dt.getDate() + (p_Number*7));
			break;
		}
		case "h": {		// hour
			dt.setHours(dt.getHours() + p_Number);
			break;
		}
		case "n": {		// minute
			dt.setMinutes(dt.getMinutes() + p_Number);
			break;
		}
		case "s": {		// second
			dt.setSeconds(dt.getSeconds() + p_Number);
			break;
		}
		case "ms": {		// second
			dt.setMilliseconds(dt.getMilliseconds() + p_Number);
			break;
		}
		default: {
			return "invalid interval: '" + p_Interval + "'";
		}
	}
	return dt;
}

//////


function weekdayName(p_Date, p_abbreviate){
	if(!isDate(p_Date)){return "invalid date: '" + p_Date + "'";}
	var dt = new Date(p_Date);
	var retVal = dt.toString().split(' ')[0];
	var retVal = Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')[dt.getDay()];
	if(p_abbreviate==true){retVal = retVal.substring(0, 3)}	// abbr to 1st 3 chars
	return retVal;
}

////////////////
function monthName(p_Date, p_abbreviate){
	if(!isDate(p_Date)){return "invalid date: '" + p_Date + "'";}
	var dt = new Date(p_Date);	
	var retVal = Array('January','February','March','April','May','June','July','August','September','October','November','December')[dt.getMonth()];
	if(p_abbreviate==true){retVal = retVal.substring(0, 3)}	// abbr to 1st 3 chars
	return retVal;
}

var MONTH_NAMES=new Array('January','February','March','April','May','June','July','August','September','October','November','December','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
var DAY_NAMES=new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun','Mon','Tue','Wed','Thu','Fri','Sat');
function LZ(x) {return(x<0||x>9?"":"0")+x}
var DateFormat='MM/d/y';
    

function formatDate(date,format) 
{
	format=format+"";
	var result="";
	var i_format=0;
	var c="";
	var token="";
	var y=date.getYear()+"";
	var M=date.getMonth()+1;
	var d=date.getDate();
	var E=date.getDay();
	var H=date.getHours();
	var m=date.getMinutes();
	var s=date.getSeconds();
	var yyyy,yy,MMM,MM,dd,hh,h,mm,ss,ampm,HH,H,KK,K,kk,k;
	// Convert real date parts into formatted versions
	var value=new Object();
	if (y.length < 4) {y=""+(y-0+1900);}
	value["y"]=""+y;
	value["yyyy"]=y;
	value["yy"]=y.substring(2,4);
	value["M"]=M;
	value["MM"]=LZ(M);
	value["MMM"]=MONTH_NAMES[M-1];
	value["NNN"]=MONTH_NAMES[M+11];
	value["d"]=d;
	value["dd"]=LZ(d);
	value["E"]=DAY_NAMES[E+7];
	value["EE"]=DAY_NAMES[E];
	value["H"]=H;
	value["HH"]=LZ(H);
	if (H==0){value["h"]=12;}
	else if (H>12){value["h"]=H-12;}
	else {value["h"]=H;}
	value["hh"]=LZ(value["h"]);
	if (H>11){value["K"]=H-12;} else {value["K"]=H;}
	value["k"]=H+1;
	value["KK"]=LZ(value["K"]);
	value["kk"]=LZ(value["k"]);
	if (H > 11) { value["a"]="PM"; }
	else { value["a"]="AM"; }
	value["m"]=m;
	value["mm"]=LZ(m);
	value["s"]=s;
	value["ss"]=LZ(s);
	while (i_format < format.length) 
	{
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) 
		{
			token += format.charAt(i_format++);
		}
		if (value[token] != null) 
		{ 
		    result=result + value[token]; 
	    }
		else 
		{ 
		    result=result + token; 
		}
    }
    
	return result;
}

function compareDates(date1,dateformat1,date2,dateformat2) 
{
	var d1=getDateFromFormat(date1,dateformat1);
	var d2=getDateFromFormat(date2,dateformat2);
	
	if (d1==0) 
	{
		return -1;
	}
	else if (d2==0) 
	{
		return -2;
	}
	else if (d1 > d2) 
	{
		return 1;
	}
	return 0;
}

function getDateFromFormat(val,format) {
	val=val+"";
	format=format+"";
	var i_val=0;
	var i_format=0;
	var c="";
	var token="";
	var token2="";
	var x,y;
	var now=new Date();
	var year=now.getYear();
	var month=now.getMonth()+1;
	var date=1;
	var hh=now.getHours();
	var mm=now.getMinutes();
	var ss=now.getSeconds();
	var ampm="";
	
	while (i_format < format.length) 
	{
		// Get next token from format string
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) 
		{
			token += format.charAt(i_format++);
		}
		// Extract contents of value based on format token
		if (token=="yyyy" || token=="yy" || token=="y") 
		{
			if (token=="yyyy") { x=4;y=4; }
			if (token=="yy")   { x=2;y=2; }
			if (token=="y")    { x=2;y=4; }
			year=_getInt(val,i_val,x,y);
			if (year==null) { return 0; }
			i_val += year.length;
			if (year.length==2) 
			{
				if (year > 70) 
				{ year=1900+(year-0); }
				else { year=2000+(year-0); }
			}
		}
		else if (token=="MMM"||token=="NNN")
		{
			month=0;
			for (var i=0; i<MONTH_NAMES.length; i++) 
			{
				var month_name=MONTH_NAMES[i];
				if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) 
				{
					if (token=="MMM"||(token=="NNN"&&i>11)) 
					{
						month=i+1;
						if (month>12) { month -= 12; }
						i_val += month_name.length;
						break;
					}
				}
			}
		    if ((month < 1)||(month>12)){return 0;}
		}
		else if (token=="EE"||token=="E")
		{
			for (var i=0; i<DAY_NAMES.length; i++) 
			{
				var day_name=DAY_NAMES[i];
				if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) 
				{
					i_val += day_name.length;
					break;
				}
			}
		}
		else if (token=="MM"||token=="M") 
		{
			month=_getInt(val,i_val,token.length,2);
			if(month==null||(month<1)||(month>12)){return 0;}
			i_val+=month.length;
		}
		else if (token=="dd"||token=="d") 
		{
			date=_getInt(val,i_val,token.length,2);
			if(date==null||(date<1)||(date>31)){return 0;}
			i_val+=date.length;
		}
		else if (token=="hh"||token=="h") 
		{
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<1)||(hh>12)){return 0;}
			i_val+=hh.length;
		}
		else if (token=="HH"||token=="H")
		{
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<0)||(hh>23)){return 0;}
			i_val+=hh.length;
		}
		else if (token=="KK"||token=="K")
		{
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<0)||(hh>11)){return 0;}
			i_val+=hh.length;
		}
		else if (token=="kk"||token=="k") 
		{
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<1)||(hh>24)){return 0;}
			i_val+=hh.length;hh--;
		}
		else if (token=="mm"||token=="m") 
		{
			mm=_getInt(val,i_val,token.length,2);
			if(mm==null||(mm<0)||(mm>59)){return 0;}
			i_val+=mm.length;
		}
		else if (token=="ss"||token=="s") 
		{
			ss=_getInt(val,i_val,token.length,2);
			if(ss==null||(ss<0)||(ss>59)){return 0;}
			i_val+=ss.length;
		}
		else if (token=="a")
		{
			if (val.substring(i_val,i_val+2).toLowerCase()=="am") {ampm="AM";}
			else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") {ampm="PM";}
			else {return 0;}
			i_val+=2;
		}
		else 
		{
			if (val.substring(i_val,i_val+token.length)!=token) {return 0;}
			else {i_val+=token.length;}
		}
	}
	
	// If there are any trailing characters left in the value, it doesn't match
	if (i_val != val.length) { return 0; }
	// Is date valid for month?
	if (month==2) {
		// Check for leap year
		if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
			if (date > 29){ return 0; }
			}
		else { if (date > 28) { return 0; } }
		}
	if ((month==4)||(month==6)||(month==9)||(month==11)) {
		if (date > 30) { return 0; }
		}
	// Correct hours value
	if (hh<12 && ampm=="PM") { hh=hh-0+12; }
	else if (hh>11 && ampm=="AM") { hh-=12; }
	var newdate=new Date(year,month-1,date,hh,mm,ss);
	return newdate.getTime();
}


function isValidDate(val) 
{
    var dt = new Date(val);
    var Arr=new Array();
    Arr=val.split('/');
    
    if(Arr.length<2)
    {
        return (false);
    }
    else if(dt.getDate()!=Arr[1])
    {
        return(false);
    }
    else if(dt.getMonth()!=Arr[0]-1)
    {
    //this is for the purpose JavaScript starts the month from 0
        return(false);
    }
    else if(dt.getFullYear()!=Arr[2])
    {
        return(false);
    }
    
    return(true);
}
//////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////

//Method for Base Pages

    function PostData(Control)
    {
       __doPostBack(Control,'');
       // __do
    }
//    //Method for toolbar Button clicked
//    function ButtonClick(Control)
//    {
//        if(Control == 'ButtonRefresh')
//        {
//            RefreshCalled = true;
//        }
//        document.getElementById("HiddenPageName").value = Control;
//        __doPostBack(Control,'');
//    }
    
    function HistroyItemClicked1(Control, PageIndex, CommonProperties)
    {
          document.getElementById("HiddenPageName").value = Control;
          document.getElementById("HiddenPageIndex").value = PageIndex;
          document.getElementById("CommonProperties").value = CommonProperties;
        __doPostBack(Control,'');
    }

    function HistroyItemClicked(Control, PageIndex)
    {
        try
        {
            document.getElementById("HiddenPageName").value = Control;
            document.getElementById("HiddenPageIndex").value = PageIndex;
            __doPostBack(Control,'');
        }
        catch(exception)
        {
            
        }
    }
    
    function OpenNewPage(Control,PageName)
    {
        try
        {
            document.getElementById("HiddenPageName").value = PageName;
            //alert(PageName + 'I am here');
            __doPostBack(Control,PageName);
        }
        catch(exception)
        {
           // alert('error --> ' + exception);
        }
    }
    
    function OpenPageWithQueryString(PageName,QueryString)
    {
    
        document.getElementById("HiddenPageName").value = PageName;
        
        document.getElementById("hdQueryString").value = QueryString;           
        __doPostBack('ButtonNavigate',PageName);
    }
    function ShowLeftPanel(Type)
    {
       parent.ShowLeftPanel(Type);
    }
   //end of BasePages methods 
//////////////////////////////////////////////////////////////////////////////////////////////////

    function IsNumeric(txtTxtBox,LabelError)
    {
        //var _LabelError=document.getElementById(LabelError);
       // var _ImgError=document.getElementById('ImgError');   
        //_ImgError.style.visibility='visible';        
        //var TxtValue=document.getElementById(txtTxtBox); 
        //var TVLength;
        if(txtTxtBox.value*1!=LabelError.value)
        {
       //_ImgError.style.visibility='visible';
        //_LabelError.innerHTML='Please fill numeric value';
        //_LabelError.innerText='Please fill numeric value';
         alert("Enter Numeric Value Only")
         txtTxtBox.focus();         
         return false;
        }       
     /* if(TxtValue.value*1==TxtValue.value)
       {
        _ImgError.style.visibility='hidden';
        _LabelError.innerText='';
        _LabelError.innerHTML='';
       // _txtBMI.value='';
        return true;       
       }
      */        
      
}
/*Modified by Sudhendhu on July 15 2008
to display message instead of alert
-called from AM TeamDetails.ascx.cs*/
function CheckHTMLTags(txtBox,lblError,ErrorMessage)
{
    var MyText = document.getElementById(txtBox)
    var LabelError = document.getElementById(lblError)
    if (MyText.value.indexOf('<')>0 || MyText.value.indexOf('>')>0)
    {
        // alert('Invalid Data');
        SetLabelValue(LabelError,ErrorMessage,true);
        //MyText.value="";    
        return false;        
    }
    else
    {
        return true;
    }       
}
/*Added by Sudhendhu on July 15 2008
function to check if textbox is empty
-called from AM TeamDetails.ascx.cs*/
function IsEmptyTextBox(txtComment,lblError,ErrorMessage)
{
    try
    {
        var TextBoxComment = document.getElementById(txtComment);
        var LabelError = document.getElementById(lblError);
        var StrLocalizedMessage="";
        var ReturnFlag = false;
        
        if(trim(TextBoxComment.value) != '')
        {
            if((TextBoxComment.value.indexOf("<")!=-1) || (TextBoxComment.value.indexOf(">")!=-1))
            {
                ReturnFlag = false;           
                SetLabelValue(LabelError,"Comment contains invalid characters, like <,>",true);
            }  
            else
            {
                ReturnFlag = true;
            }
        }         
        else
        {
            ReturnFlag = false;  
            if(ErrorMessage.length>0)
            {
                SetLabelValue(LabelError,ErrorMessage,true);
            }
        }       
        return ReturnFlag;
    }
    catch(ex)
    {
       alert('IsEmptyTextBox---'+ex);
    }
}

//Added by vindu on 26/08/2008 to check valid negative decimal (Task# Brokers' Portal Application 284)
    function ValidNegDecimal(control)
    {
        try
        {
            control.value=trim(control.value);
            if(control.value.length==1)
            {
                if(control.value=='.')
                {
                    control.value='';
                    return;
                }
            }
            if(control.value.substring(0,1)=='.')  //   add . is at first index add 0.
            {
                control.value='0'+control.value; 
            }
            if(control.value.substring(control.value.length-1)=='.') // if . is at last index add .0
            {
                control.value=control.value+'0';
            }
            
            control.value= ReplaceAllOccurances(control.value,',','');  // Remove all occurances of ','
            control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$'
            
            for(var i=0;i<control.value.length;i++)
            {               
            if(control.value.charAt(i)=='$' )
            {
            control.value = control.value.replace("$","");            
            }              
            }  
           
            
            if( /^[-+]?[0-9]\d+(\.\d+)?$/.test(control.value)==false)
            {   
                control.value='';
            }
    //        if(control.value.indexOf('.')>0) // round decimal values to 2 precision.
    //        {

    //            control.value=control.value.substring(0,control.value.indexOf('.')+3);
    //        }

        
            control.value=formatNegNumber(control.value,'2',',','.','','','','');
        
            
        }
        catch(ex)
        {
         
        }   
        
    }
    
    //Added by vindu on 26/08/2008 to format negative decimal number (Task# Brokers' Portal Application 284)
    // Function FormatNumber
    // num - Actual Number
    // dec - Decimal places 0 for integer
    // thou - thousand seprator eg ','
    // pnt  - for decimal symblo eg '.'
    // curr1 - symbol that you want to prefix the number. eg 1) $ for currencty 2) ''(empty) for non symbol
    // curr2 - symbol that you want to postfix the number. eg 1) $ for currencty 2) ''(empty) for non symbol
    // n1, n2- sysmbol to place around the number when the value is negative
    function formatNegNumber(num,dec,thou,pnt,curr1,curr2,n1,n2)
    {
            try
        {
              num= ReplaceAllOccurances(num,',','');
              //num= ReplaceAllOccurances(num,'$','');
              for(var i=0;i<num.length;i++)
              {               
                if(num.charAt(i)=='$' )
                {
                    num = num.replace("$","");            
                }              
             }
            var x = Math.round(num * Math.pow(10,dec));if (x < 0){n1='-';}else if (x >= 0){n1=n2='';}var y = (''+Math.abs(x)).split('');var z = y.length - dec; if (z<0) z--; for(var i = z; i < 0; i++) y.unshift('0');y.splice(z, 0, pnt); if(y[0] == pnt) y.unshift('0'); while (z > 3) {z-=3; y.splice(z,0,thou);}var r = curr1+n1+y.join('')+n2+curr2; return r;
        }
        catch(ex)
        {
           
        }
}
function OpenWeeklyReportingPageWithQueryString(PageName, QueryString)
{
    try
    {
        // alert("PreventionProfile.aspx?PageName=" + PageName + "&" + QueryString +"&DT="+ today.getMinutes()+ today.getSeconds());
        var today = new Date();
        // alert("PreventionProfile.aspx?PageName=" + PageName + "&" + QueryString +"&DT="+today.getMinutes()+ today.getSeconds());
        //location.href = "WeeklyReporting.aspx?EnrolleeID=rTW6VUKx7uI=#";
        location.href = "WeeklyReporting.aspx?PageName=" + PageName + "&" + QueryString;
        //location.href = "WeeklyReporting.aspx?PageName=" + PageName + "&" + QueryString +"&DT="+ today.getMinutes()+ today.getSeconds();
        //document.getElementById("HiddenPageName").value = PageName;
        //document.getElementById("hdQueryString").value = QueryString;           
        //__doPostBack('ButtonNavigate',PageName);
    }
    catch(exception)
    {
        //alert(exception);
    }
}
//Function to print a required element of the page
function CallPrint(strid,VarHiddenField)
{
        try
        {
             var printContent = document.getElementById(strid);
             var windowUrl = 'about:blank';
             var uniqueName = new Date();
             var windowName = 'Print' + uniqueName.getTime();
             var printWindow = window.open(windowUrl, windowName, 'scrollbars =1,left=0,top=0,width=1000px,height=720px');             
             var PrintPage= printContent.innerHTML; 
             PrintPage = trim(ReplaceAllOccurances(PrintPage,'onclick','click'));                 
             
             //PrintPage = trim(ReplaceAllOccurances(PrintPage,'IMG','IMG'));             
             //alert(PrintPage);
             var _hiddenField = document.getElementById(VarHiddenField);
             if(_hiddenField != null)
             {
                 if(_hiddenField.value == 'SMALL')
                 {
                    PrintPage = trim(ReplaceAllOccurances(PrintPage,'<IMG','<IMG Width=50 Height=20'));             
                 }
             }
             
             PrintPage="<link href='../App_Themes/Theme/css/Common.css' type='text/css' rel='stylesheet' media='all' />" + PrintPage;  
             
             printWindow.document.write(PrintPage);
             
             //if(IsIE6() == true || IsIE7OrLater()== true )
             //{
                 var divs = printWindow.document.getElementsByTagName('div');
                 var imgs=  printWindow.document.getElementsByTagName('img');
                 var Anchor=  printWindow.document.getElementsByTagName('a');
                 
                 if(Anchor != null)
                 {
                   // Anchor[0].style.cursor ='default';                  
                 }
                 
                 if(imgs!= null)
                 {
                    if(imgs[0]!= null)
                    {         
                    //    imgs[0].className="landScapeImage";
                        var imgW=imgs[0].width;
                        var imgH=imgs[0].height;
                        var aspRatio=imgW/imgH;
                        //imgs[0].width = imgW * document.body.clientWidth / 800;
                        imgs[0].style.width ='95%';                 
                        imgs[0].height= imgs[0].width / aspRatio;
                    }
                 }
                 if(divs!= null)
                 {
                    if(divs[0] != null)
                    {
                      
                    }
                 }
             //} 
             
             //printWindow.document.write(PrintPage); 
              
             printWindow.document.close();
             printWindow.focus();
             printWindow.print();
             printWindow.close();
        }
        catch(ex)
        {
        }
}
 //<Description>this function returns false if value of passed text box contains Html Tag,Otherwise true</Description>
 //Used in PP/MyAccount,
 // Created by:Pradeep
 // Created Date:Nov 15,2008
function CheckHtmlTag(TextBox)
{
  try
  {
     var _TextBox=document.getElementById(TextBox);
     var _Valid=true;
     if(_TextBox!=null)
     {
        if(_TextBox.value!='')
        {
           if(_TextBox.value.indexOf('<')>0 || _TextBox.value.indexOf('>')>0)
           {
             _Valid=false;
            
           }
        }
     }
     return _Valid 
  }
  catch(ex )
  {
    
    alert('CommonFunction.js--CheckHtmlTag()'+ex);
  }
}
//Function created by DamanPreet Kaur to open ConfirmMessage User control
//function ShowConfirmMessage(funName,DisplayText)//(type,CalledFrom,HeaderText,ConfirmationMessage)
function ShowConfirmMessage(LabelHeaderText,LabelDisplaytext,ButtonConfirmYesText,ButtonConfirmNoText,ReturnFunctionName)
{
	try
	{     
		var divConfirmMessage = document.getElementById('ConfirmMessage1_DivMainConfirmMessage');
		var LabelHeader = document.getElementById('ConfirmMessage1_LabelHeaderText');
		var LabelDisplay = document.getElementById('ConfirmMessage1_LabelDisplaytext');
		var ButtonConfirmYes = document.getElementById('ConfirmMessage1_ButtonConfirmYes');
		var ButtonConfirmNo = document.getElementById('ConfirmMessage1_ButtonConfirmNo');
		
		SetLabelValue(LabelHeader,LabelHeaderText,true);
		SetLabelValue(LabelDisplay,LabelDisplaytext,true);
		ButtonConfirmYes.value = ButtonConfirmYesText;
		ButtonConfirmNo.value = ButtonConfirmNoText;
		
		var CallingFunction = document.getElementById('ConfirmMessage1_HiddenFieldCallingFunction');
		CallingFunction.value = ReturnFunctionName;		
		
		if(divConfirmMessage!=null)
		{            
			divConfirmMessage.style.cssText = 'background-color: White; vertical-align: middle;position: absolute; z-index: 315; left: 60px; top: 250px; display: block; overflow: auto;';

			height = divConfirmMessage.style.height;
			width = divConfirmMessage.style.width; 
		}	
		return false;
	}
	catch(ex)
	{
		alert('ShowConfirmMessage--'+ex.message);
	}
	
}
//Function created by DamanPreet Kaur to hide ConfirmMessage User control on click of No button
function HideConfirmMessage()//(type,CalledFrom,HeaderText,ConfirmationMessage)
{
    try
    {     
       var divConfirmMessage = document.getElementById('ConfirmMessage1_DivMainConfirmMessage');
       divConfirmMessage.style.display='none';       
    }
    catch(ex)
    {
		alert('HideConfirmMessage--'+ex.message);
    }
    return false
}
//Function created by DamanPreet Kaur on Nov 20 2008
//This will be called on click of Yes button in Confirmation message
function buttonYesClick()
{
	try
	{
		var CallingFunction = document.getElementById('ConfirmMessage1_HiddenFieldCallingFunction');
		var CallingFunctionName = CallingFunction.value;
		eval(CallingFunctionName+'()');
	}
	catch(ex)
	{
		alert('buttonYesClick--'+ex.message);
	}
}	

//Function written by Damanpreet Kaur
//Called in EngagementHelthcare\App_Code\CommonLoadControl.cs
//Moved the function from ASPX pages to Javascript file.
	function  ReturnFalseOpenPageWithQueryString(PageName, QueryString)
	{
		try
		{
			var today = new Date();
			location.href = "PreventionProfile.aspx?PageName=" + PageName + "&" + QueryString +"&DT="+ today.getMinutes()+ today.getSeconds();
			//  OpenPageWithQueryString(PageName, QueryString);
			return false;
		}
		catch(ex)
		{
			alert('ReturnFalseOpenPageWithQueryString--'+ex.message);
		}
}


// Created by:Sanvir Kumar
// Created Date:March 10, 2009
// Purpose : To open popup for reregistration from HomePage and AMApplication page
function ShowPopUpDivWithCover(DivCover,DivPopup, ButtonRegisterNowClientID, IsVisible, LabelPopupMessageWithRegistrationDateClientId, RegistrationEndDateText)
{
    var ButtonRegisterNowControl = document.getElementById(ButtonRegisterNowClientID);
    var LabelPopupMessageWithRegistrationDateControl = document.getElementById(LabelPopupMessageWithRegistrationDateClientId);
    try
    {
        var DivPopupControl = document.getElementById(DivPopup);
        var DivCoverControl = document.getElementById(DivCover); 
        
        if(IsVisible=='Y')
        { 
            if(LabelPopupMessageWithRegistrationDateControl !=null)
            {
                SetLabelValue(LabelPopupMessageWithRegistrationDateControl, RegistrationEndDateText, true); 
            }        
            if(DivPopupControl!=null && DivCoverControl !=null)
            {
                SetDivSizeForReregistraton(DivCover, DivPopup);
               
                DivCoverControl.style.display='block';
                DivPopupControl.style.display='block';
            }                
            if(ButtonRegisterNowControl!=null && DivPopupControl!=null)
            {
               ButtonRegisterNowControl.focus();
            }
        }
    }
    catch(ex)
    {
       // alert('ShowPopUpDivWithCover'+ex);
    }
}
// Created by:Sanvir Kumar
// Created Date:March 10, 2009
// Purpose: To Set Reregistration popup size and location
// Modified By: Sanvir Kumar on March 17, 2009
// Modification: if newleft and newtop value is less than 0 then set to 0
function SetDivSizeForReregistraton(DivCover, DivPopup)
{
    try
    {
        var currentWindowWidth = GetCurrentWindowWidth();
        var currentWindowHeight = GetCurrentWindowHeight();    
        var DivPopupControl = document.getElementById(DivPopup);
        var DivCoverControl = document.getElementById(DivCover); 
        var divDisplayValue='none';
        var yWithScroll=300, xWithScroll = 350;
         
        if(DivPopupControl!=null && DivCoverControl !=null)
        {
            if (window.innerHeight && window.scrollMaxY) 
            {// Firefox 
                    yWithScroll = window.innerHeight + window.scrollMaxY;
                    xWithScroll = window.innerWidth + window.scrollMaxX;
             } 
             else if (document.body.scrollHeight > document.body.offsetHeight)
             { // all but Explorer Mac         
                yWithScroll = document.body.scrollHeight;         
                xWithScroll = document.body.scrollWidth;     
            } 
            else 
            {    // works in Explorer 6 Strict, Mozilla (not FF) and Safari         
                yWithScroll = document.body.offsetHeight;         
                xWithScroll = document.body.offsetWidth;       
            }                 
            var objectWidth = "400";//parseInt(DivPopupControl.style.width);
            var objectHeight ="300";// parseInt(DivPopupControl.style.height);
            var newLeft ="0px";
            if((currentWindowWidth - objectWidth) / 2>0)            
            {
                newLeft =(currentWindowWidth - objectWidth) / 2+"px";// "100px";//(xWithScroll - objectWidth) / 2;
            }
            var newTop="0px";
            if((currentWindowHeight - objectHeight) / 2>0)
            {
                newTop = (currentWindowHeight - objectHeight) / 2+"px";//"100px";//(yWithScroll - objectHeight) / 2;
            }
            xWithScroll=xWithScroll-15;
            var SetPopupControlWidth =objectWidth+'px';
            var SetPopupControlHeight =objectHeight+'px';
            
            var setcss='background-color:#fff;width:'+ SetPopupControlWidth + ';height:'+ SetPopupControlHeight +';position:absolute;z-index: 500;left:'+newLeft + ';top:'+newTop+';';
            //alert(setcss);
            divDisplayValue=DivCoverControl.style.display;
            if(divDisplayValue=="")
            {
                divDisplayValue='none';
            }
            DivCoverControl.style.cssText = 'position:absolute;z-index: 100;width:'+xWithScroll+'px;left:3px;top:1px;filter: alpha(opacity=50);-moz-opacity: .5;background:#ccc;padding:5px;opacity: 0.5;'+'height:'+ yWithScroll + "px;";
            DivPopupControl.style.cssText = setcss;
            DivCoverControl.style.display=divDisplayValue;
            DivPopupControl.style.display=divDisplayValue;  
        }
    }
    catch(ex)
    {
    }
}
// Created by:Sanvir Kumar
// Created Date:March 10, 2009
// Purpose : To open Prevention profile in new window. Called from Reregistration Popup (On AMApplication page(Task #199, #200 PP2.5))
function OpenPreventionProfileWindowFromRegistrationPopup(Querystring, WindowKey)
{
    try
    {
        var DivCoverControl = document.getElementById('divReregistrationCover');
        var DivPopupControl = document.getElementById('divReregistrationPopup');
        if(DivCoverControl!=null)
        {
            DivCoverControl.style.display='none';
        }
        if(DivPopupControl!=null)
        {
            DivPopupControl.style.display='none';
        }
        window.open('Application.aspx?EnrolleeID=' + Querystring, 'mywindow' + WindowKey,'status=1,toolbar=1,directories =1,location=1,scrollbars=1,resizable=1,menubar=1');
        if( navigator.appName != 'Microsoft Internet Explorer')
        { 
            return false; 
        } 
        else
        {  
            if(event)
            {
                event.returnValue = false;
            }
            return false; 
        }
    }
    catch(ex){}
}
 //To close Re-Registration pop up if not saved new participant information
 //Used: usercontrols/Reregistrationpopup.ascx.cs
//CreateBy Sanvir Kumar on Apr 16, 2009
function CloseReregistrationPopup()
{
    try
    {
        var DivCoverControl = document.getElementById('divReregistrationCover');
        var DivPopupControl = document.getElementById('divReregistrationPopup');
        if(DivCoverControl!=null)
        {
            DivCoverControl.style.display='none';
        }
        if(DivPopupControl!=null)
        {
            DivPopupControl.style.display='none';
        }
    }
    catch(ex){}
}


function ValidDecimalWithPercent(control)
{
    try
    {
        control.value=trim(control.value);
        if(control.value.length==1)
        {
            if(control.value=='.')
            {
                control.value='';
                return;
            }
        }
        if(control.value.substring(0,1)=='.')  //   add . is at first index add 0.
        {
            control.value='0'+control.value; 
        }
        if(control.value.substring(control.value.length-1)=='.') // if . is at last index add .0
        {
            control.value=control.value+'0';
        }
        
        control.value= ReplaceAllOccurances(control.value,',','');  // Remove all occurances of ','
        control.value= ReplaceAllOccurances(control.value,'$','');  // Remove all occurances of '$'
        control.value= ReplaceAllOccurances(control.value,'%','');
        
        for(var i=0;i<control.value.length;i++)
        {               
        if(control.value.charAt(i)=='$' )
        {
        control.value = control.value.replace("$","");            
        }              
        }  
       
        
			if( /^\d+(\.\d+)?$/.test(control.value)==false)
        {   
            control.value='';
        }
//        if(control.value.indexOf('.')>0) // round decimal values to 2 precision.
//        {

//            control.value=control.value.substring(0,control.value.indexOf('.')+3);
//        }

    control.value=formatNumber(control.value,'2',',','.','','%','','');
        
    }
    catch(ex)
    {
     
    }   
    
  
}









