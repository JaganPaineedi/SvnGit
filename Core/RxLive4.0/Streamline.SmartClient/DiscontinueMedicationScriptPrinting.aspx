<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="false" CodeFile="DiscontinueMedicationScriptPrinting.aspx.cs" Inherits="DiscontinueMedicationScriptPrinting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" language="javascript" src="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1"></script>
    <script type="text/javascript" language="javascript">
            function PrintMedicationScript(varScriptIds, varAllFaxed, varChartScriptIds, varFaxSendStatus) {


   var date1=new Date();
//  //window.open("Test1.aspx?varScriptIds=" +ScriptIds + "&UserName=sdfsd&hh=" + date1 )
 ShowPrintMedicationScriptDiv(varScriptIds,varAllFaxed,varChartScriptIds,varFaxSendStatus); 
}


//Modified by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
//Added a new parameter varFaxSendStatus 

            function ShowPrintMedicationScriptDiv(ScriptIds, AllFaxed, ChartScriptIds, varFaxSendStatus) {
                try {
       
    var d=new Date();     
   var myans1=window.open('MedicationScriptPrinting.aspx?varScriptIds=' +ScriptIds + '&varChartScriptIds=' + ChartScriptIds + '&varFaxSendStatus=' + varFaxSendStatus + '&varTime =' + d.getTime() , '','menubar = 0;status = 0; height=500px;width=750px;top=20px;left=170px;');       
   
   //Changes end over here
   
    if(AllFaxed=="0")  
      alert('Some Medications could not be Faxed,Please review script History!');
     //redirectToManagementPage();
     
      
                } catch(e) {
             Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
       }
    return false;
}

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
                <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;" width="100%" >
                    <tr><td>
             <asp:Panel ID="Panel1"  runat="server" Width="100%" Height="430px" ScrollBars="Vertical"  > 
                                <div id ="divReportViewer"  runat="server"  style="height: 430px; scrollbar-3dlight-color: Azure; width: 100%;"  ></div>
            </asp:Panel>
            </td></tr>
            </table>
            
    </div>
    <asp:HiddenField ID="HiddenFieldArgument" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldAllFaxed" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldShowError" runat="server" />  
           <asp:HiddenField ID="HiddenFieldStoredProcedureName" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldReportName" runat="server" /> 
           <asp:Label ID="LabelClientScript" runat="server"></asp:Label>
    </form>
</body>
</html>