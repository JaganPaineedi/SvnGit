
function CalculateEndDate()
{
   // alert(startDate);
    //Streamline.SmartClient.WebServices.CommonService.CalculateEndDate(startDate,days,refill,onSucceeded);
   
    var obj = new Array(2);
    var product = new ProductData(); 
    product.ProductName ="sony";
    product.ProductId=1;
    obj.push(product); 
    
     Streamline.SmartClient.WebServices.CommonService.serialize(onSucceeded,onError);

}
function onSucceededXml(result)
{
    alert(result);
}
function onSucceeded2(result,userContext,methodName)
{
    alert(result);
    alert(userContext);
   // var xmlNote = result.getElementsByTagName("Strength");
    //alert(xmlNote.length);
}

function onSucceeded(obj)
{
    try
    {
   // alert(<%=LinkButton2.ClientID %>);
   // var objk=document.getElementById('btnTest'); 
   alert(obj);
   Streamline.SmartClient.WebServices.CommonService.serializeeT(obj,onSucceeded,onError);
   //var obje=document.getElementById('btnTest'); 
//   var Json = Sys.Preview.Data.DataTable.parseFromJson(obj);
// //alert(obj); 
//   
//   Streamline.SmartClient.WebServices.CommonService.serializedatatable(Json,onSucceededXml,onError);
    }
    catch(ex)
    {
        alert(ex.message);
    }
}
function HelloWorld()
{
    alert('in');
}

function FillStrength(intMedicationId,object)
{
    //alert('in');
    
    var context ="hello";
    Streamline.SmartClient.WebServices.ClientMedications.GetMedicationStrength(intMedicationId,onSucceeded2,onError,context)
}

function onStrengthSucceeded(xmlData)
{
    alert('in');
}

function onError(errmsg)
{
    alert(errmsg.get_message());
}


 function ProductData()
 {
        this.ProductName;
        this.ProductId;
 }
 
 
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

 
  function GetMedicationList()
    {

        try
        {
           
            requestUrl = "AjaxScript.aspx?FunctionId=Test";
            //alert(requestUrl);
        
            CreateXmlHttp();
            if(XmlHttp)
            {
                XmlHttp.onreadystatechange = function(){ handleGetMedicationList() }
                XmlHttp.open("POST",requestUrl,true);

                XmlHttp.send(null);
            		
            }
        } 
        catch(Err)
        {
            alert(Err.description);
        }   
    }
    
    function handleGetMedicationList()
    {
         if(XmlHttp.readyState == 4)
	    {
		    if(XmlHttp.status == 200)
		    {	
		        document.getElementById("testdiv").innerHTML="";
		        var data=XmlHttp.responseText;
		        var indexofdiv= data.indexOf('</div>');
		        data=data.substring(indexofdiv+6,data.length);
    	        var ScriptStart = data.indexOf('<script');
		        var ScriptEnd = data.indexOf('</script>');
		        var Script = data.substring(ScriptStart+57,ScriptEnd);
		        var Rscript = document.createElement('script'); 
		        Rscript.text=Script;
		        
     	        document.getElementById("testdiv").appendChild(Rscript);
     	        document.getElementById("testdiv").innerHTML=data +document.getElementById("testdiv").innerHTML ;
		        
		        RegisterMedicationListControlEvents();
		        
		    }
		}   
    }
    
    function onRadioClick(sender,e)
    {
        alert(e.MedicationId);
    }

     function onDeleteClick(sender, e) 
     {
        //Streamline.SmartClient.WebServices.ClientMedications.DiscontinueMedication(e.MedicationId,'Y',onSuccessfullDeletion,onFailure,e);
        alert(e.MedicationId);
     }
    
 function ExecuteWebRequest()
{
    // Create the WebRequest object.
    wRequest =  new Sys.Net.WebRequest();
    // Set the request Url.  
    wRequest.set_url("AjaxScript.aspx?FunctionId=Test");
     // Set the Completed event handler 
    // for processing return data
    wRequest.add_completed(OnCompleted);
    wRequest.set_userContext("Sony John");
      // Clear the results area.
    //resultElementId.innerHTML = "";
    // To use executeRequest you must instantiate the
    // executor, assign it to the Web request instance,
    // then call the executeRequest function.
    // Note: Normally to make a Web request you use
    // the invoke method of the WebRequest instance.
    var executor = new Sys.Net.XMLHttpExecutor();
    wRequest.set_executor(executor); 
    executor.executeRequest();
    var started = executor.get_started();
   // alert("Executor started: " + started);
}


// This is the event handler called after 
// the Web request returns.
function OnCompleted(executor, eventArgs) 
{
   
    if(executor.get_responseAvailable()) 
   
    {

        // Get the Web request instance.
        var webReq = executor.get_webRequest();
        // Display request Url.
        alert(webReq.get_url());
        alert(executor.get_statusCode());
        alert(webReq.get_userContext());

       // Clear the previous results. 
       //resultElementId.innerHTML = "";

     
       // Display the Web request status. 
//       resultElementId.innerHTML +=
//          "Request Status: [" + executor.get_statusCode() + " " + 
//                    executor.get_statusText() + "]" + "<br/>";
     
        // Display the Web request headers.
       // resultElementId.innerHTML += "Headers: <br/>";
        
        
       
        // Get all the headers.    
//        resultElementId.innerHTML += 
//        "All Request Headers: " +
//            executor.getAllResponseHeaders() + "<br/>"; 
//       
//        // Get a specific header.
//        resultElementId.innerHTML += 
//        "Content-Type Header: " +
//            executor.getResponseHeader("Content-Type") + 
//            "<br/>";       
       
        // Display Web request body.
      //  resultElementId.innerHTML += "Body: <br/>";
        
//        if (document.all)
//            resultElementId.innerText += 
//                executor.get_responseData();
//        else
//            // Firefox 
//            resultElementId.textContent += 
//                executor.get_responseData();
   
    }
    else
    {
        if (executor.get_timedOut())
            alert("Timed Out");
        else
            if (executor.get_aborted())
                alert("Aborted");
    
    }

}

function CheckNumeric()
{
    
        //alert('in');
        alert( Number.parseInvariant("a"));
        //throwAjaxError();
    
    
}

function throwAjaxError()
{
    try
    {
        throw Error.invalidOperation('Cannot invoke this method.');
    }
    catch(e)
    {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}