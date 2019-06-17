// JScript File
 var TextBoxNeed;
   var DropDownStats;
   var TextBoxDate;
   var TextBoxDiscription;
   var TextBoxcomment;
   var ButtonAdd;
   var SessionKey;
//this function will Call Ajax function that will add row to dataset and return 
//Html for row added gridview
function AddRowToGrid(objNeed,ObjStatus,ObjDate,ObjDiscription,objComment,objCheckbox,ObjDiv,ObjSession)
{
try
    {
        Need=document.getElementById(objNeed).value;
        Status=document.getElementById(ObjStatus).value;
        //Getting Selected text from DropDownList
        if(document.getElementById(ObjStatus).selectedIndex>=0)
        {
        StatusText=document.getElementById(ObjStatus).options[document.getElementById(ObjStatus).selectedIndex].text;
        }
        
        Date=document.getElementById(ObjDate).value;
        Discription=document.getElementById(ObjDiscription).value;
        Comment=document.getElementById(objComment).value;
        CheckBox=document.getElementById(objCheckbox).value;
       // If it is Add then Calling Add method
        if(ButtonAdd.value=="Add")
        {
         requestUrl = "AjaxScript.aspx?FunctionId=AddRowToGridNeed&Need=" + Need+"&Status="+Status+"&StatusText="+StatusText+"&Date="+Date+"&Discription="+Discription+"&Comment="+Comment+"&CheckBox="+CheckBox+"&SessionKey="+SessionKey.value;
            //alert(requestUrl);
            CreateXmlHttp();
            if(XmlHttp)
	        {
		        XmlHttp.onreadystatechange = function(){ SetGridHtml(ObjDiv,objNeed,ObjStatus,ObjDate,ObjDiscription,objComment,objCheckbox) }
		        XmlHttp.open("POST",requestUrl,true);
		        XmlHttp.send(null);		
	        }
        
        }
        else //if user has Clicked on Update
        {
         requestUrl = "AjaxScript.aspx?FunctionId=Update&Need=" + Need+"&Status="+Status+"&StatusText="+StatusText+"&Date="+Date+"&Discription="+Discription+"&Comment="+Comment+"&CheckBox="+CheckBox+"&SessionKey="+SessionKey.value+"&RadioButton="+ObjRadio.id;
            //alert(requestUrl);
            CreateXmlHttp();
            if(XmlHttp)
	        {
		        XmlHttp.onreadystatechange = function(){ SetGridHtml(ObjDiv,objNeed,ObjStatus,ObjDate,ObjDiscription,objComment,objCheckbox) }
		        XmlHttp.open("POST",requestUrl,true);
		        XmlHttp.send(null);		
	        }
        
        }
       
        
        
        ButtonAdd.value="Add";
        return false;
    }
    catch(Ex)
    {
    
    alert(Ex);
    }
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
///Created By Pramod Prakash
/// Created On 24 Jan 2007
///This function Get Html for grid from ajax function and set html to inner html of div
   function SetGridHtml(objDiv,Need,Status,Date,Discription,Comment,CheckBox)
   {
   
    if(XmlHttp.readyState == 4)
	    {
		    if(XmlHttp.status == 200)
		    {	
		       var objHTML=XmlHttp.responseText;
		       //getting Gridview Html
		       objHTML=objHTML.substring(objHTML.indexOf("<table"),objHTML.length );
		       //setting Innerhtml
		       try
		       {
		         document.getElementById(objDiv).innerHTML=objHTML;
		         //Clearing All Control that was Priviously filled by the user
		          ClearAllControls();
		       }
		       catch(Ex)
		       {
		          //Clearing All Control that was Priviously filled by the user
		          ClearAllControls();
		       }
		        
		            
		    }
		}   
  
   
        //Clearing All Controls Value
		ClearAllControls();
        document.getElementById(CheckBox).checked=false;
   }
   //Declaring a variable that will hold the ClientId of Selected RadioButton
   var ObjRadio='';
   function RadioSelect(ObjRadioNeed,ObjNeed,ObjDiscription,ObjStatus,ObjComment,ObjDate,ObjStatusId)
   {
       //Checking Radiobutton is Clicked First Time
       if(ObjRadio=='')
       {
           document.getElementById(ObjRadioNeed).checked=true;
           ObjRadio=document.getElementById(ObjRadioNeed);
       }
       //If user has Clicked on Same radio button then do nothing otherwise Setting Priviously selected radio to false;
       else if(ObjRadio.id!=ObjRadioNeed)
       {
        document.getElementById(ObjRadioNeed).checked=true;
        ObjRadio.checked=false;
        ObjRadio=document.getElementById(ObjRadioNeed);
       
       } 
       TextBoxNeed.value=document.getElementById(ObjNeed).innerHTML;
       //Selecting status dropdownlist
         for(i=0;i<DropDownStats.options.length;i++)
                    {
                        if(DropDownStats.options[i].value==document.getElementById(ObjStatusId).value)
                            {
                                DropDownStats.options[i].selected=true;
                                 break;
                             }
                     } 
       
       TextBoxDate.value= document.getElementById(ObjDate).value;   
       TextBoxDiscription.value=document.getElementById(ObjDiscription).innerHTML;
       TextBoxcomment.value=document.getElementById(ObjComment).innerHTML;
       //Setting Button Text to Update
       ButtonAdd.value="Update";
   
   }
   function DeletedRecord(ObjDelete)
   {
   var DeleteRow=confirm('Do you want to delete ?');
   //if user select no then return without deleting record
   if(DeleteRow!=true)
   {
   return false;
   }
   requestUrl = "AjaxScript.aspx?FunctionId=DeletedRecordGridNeed&SessionKey="+SessionKey.value+"&ImageButtonDelete="+ObjDelete;
    CreateXmlHttp();
            if(XmlHttp)
	        {
		        XmlHttp.onreadystatechange = function(){ GridAfterDeleted() }
		        XmlHttp.open("POST",requestUrl,true);
		        XmlHttp.send(null);		
	        }
        return false;
   }
   ///Created By Pramod Prakash
/// Created On 24 Jan 2007
///This function Get Html for grid from ajax function and set html to inner html of div
   function GridAfterDeleted()
   {
     if(XmlHttp.readyState == 4)
	    {
		    if(XmlHttp.status == 200)
		    {	
		       var objHTML=XmlHttp.responseText;
		       //Checking Return output has Table(Gridview)
		       if(objHTML.indexOf('<table')>-1)
		           {
		           
		             objHTML=objHTML.substring(objHTML.indexOf("<table"),objHTML.length );
		           }
		       else
		            {
		                objHTML='';
		               
		            }
		       try
		       {
		       document.getElementById('DivNeed').innerHTML=objHTML;
		       //Clearing All Controls Value
		       ClearAllControls();
		       }
		       catch(Ex)
		       {
		       //Clearing All Controls Value
		       ClearAllControls();
		       }
		    
		            
		    }
		}
     
        
   }
   
   
  
   //Setting Clientid of Controls into global variables it is called on page load and Binging gridiew
   function GetClientId(ObjTextBoxNeed,ObjDropDownStats,ObjDate,ObjDiscription,Objcomment,objSessionKey,ObjAdd)
   {
        TextBoxNeed=document.getElementById(ObjTextBoxNeed);
        DropDownStats=document.getElementById(ObjDropDownStats);
        TextBoxDate=document.getElementById(ObjDate);
        TextBoxDiscription=document.getElementById(ObjDiscription);
        TextBoxcomment=document.getElementById(Objcomment);
        ButtonAdd=document.getElementById(ObjAdd);
        SessionKey=document.getElementById(objSessionKey);
       
         requestUrl = "AjaxScript.aspx?FunctionId=GridNeedBind&SessionKey="+SessionKey.value;
            //alert(requestUrl);
            CreateXmlHttp();
            if(XmlHttp)
	        {
		        XmlHttp.onreadystatechange = function(){ GridAfterDeleted() }
		        XmlHttp.open("POST",requestUrl,true);
		        XmlHttp.send(null);		
	        }
      return false;
   }
   
   function ClearAllControls()
   {
   
    TextBoxNeed.value='';
    DropDownStats.options[0].selected=true;
    TextBoxDate.value='';
    TextBoxDiscription.value='';
    TextBoxcomment.value='';
    ButtonAdd.value='Add';
    ObjRadio='';
   }