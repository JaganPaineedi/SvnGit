// JScript File
var XmlHttp;
function CreateXmlHttp()
{
	try
	{
		XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		Browser="IE";
	}
	catch(e)
	{
		try
		{
			XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			Browser="IE";
		} 
		catch(oc)
		{
			XmlHttp = null;
		}
	}
	if(!XmlHttp && typeof XMLHttpRequest != "undefined") 
	{
		XmlHttp = new XMLHttpRequest();
		Browser="FX";
	}
}





    function SetDateFormat(dtval)
    {

        try
        {
            Streamline.SmartClient.WebServices.ClientMedications.SetDateFormat1(dtval.value,onSetFormatDateSucceeded,onFailure,dtval);
          
        } 
        catch(Err)
        {
           Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, Err);
        }   
    }
    
    function onSetFormatDateSucceeded(result,context)
    {
       context.value=result;
    
    }
    
    
    function handleSetDateFormat(dtval)
    {
       
         if(XmlHttp.readyState == 4)
	    {
		    if(XmlHttp.status == 200)
		    {	
		       
		      dtval.value=XmlHttp.responseText;
		    
		            
		    }
		}   
    }
    
    /// <summary>
/// Author Sonia Dhamija
/// It is called when  error occurs.
/// </summary>       
function onFailure(error)
{
  //  fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
  //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
    if(error.get_message() =="Session Expired" || error.get_message() =="There was an error processing the request.")
    {       
        location.href="./MedicationLogin.aspx?SessionExpires='yes'";
    }
    else
    {
        alert(error.get_message());
    }
}
 
