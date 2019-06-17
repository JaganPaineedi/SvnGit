<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HealthData.aspx.cs" Inherits="HealthData" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script language="javascript" type="text/javascript">
            function closeHealthPage(val) {
        
        var DivHealthSearch=parent.document.getElementById('DivHealthSearch');
        DivHealthSearch.style.display='none';
        window.close();
        
         
     }
     
        function CalShow(ImgCalID, TextboxID) {
            try {
       Calendar.setup({
       inputField     :    TextboxID,           
       ifFormat       :    "%m/%d/%Y",
       showsTime      :    false,
       button         :    ImgCalID,        
       step           :    1,
       onUpdate       :     function (obj){if(obj.targetElement!=null)obj.targetElement.focus();}
       });	   
       // document.getElementById('buttonInsert').disabled=false;     
                } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }  
}

//Call the function to generate the HealthData Contorl
//Task #34 Mohit Madaan 

        function pageLoad() {
    //RegisterHealthListControlEvents();
}

        function FillHealthDataList() {
    GetFillHelthDataList('<%=PanelHelthDataControl.ClientID%>','<%=DropDownListHealthData.ClientID%>');
}

function doKeyPress() {  
  
    if (event.keyCode == 8) {
        for (var i = 0; i < $("input[id*=TextBoxItemValue]").length; i++) {
            if ($("input[id*=TextBoxItemValue]")[i].readOnly == true) {
                event.returnValue = false;
        }
        
        }
    }
            if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 8) || (event.keyCode == 46)) {
    event.returnValue=true; 
                } else {
   event.returnValue =  false;
 }
}

//Added By priya Ref:Task No:2885

function checkEnterKeyPress() {
    if (event.keyCode == 13)
        return false;
}

function SaveHealthData(HealthDataId) {    
    var hiddenDropDown = document.getElementById('<%=HiddenDropDownObject.ClientID%>').value;
    var hiddenPanelHealthDataList =  document.getElementById('<%=HiddenPanelHealthDataList.ClientID%>').value;
    var DropDownObject = parent.window.document.getElementById(hiddenDropDown);
    var PanelHealthDataList = parent.window.document.getElementById(hiddenPanelHealthDataList);
    SaveHealthDataCategories('<%=TextBoxDate.ClientID %>','<%=DropDownListHealthData.ClientID%>',DropDownObject,PanelHealthDataList,HealthDataId);
    closeHealthPage('btnCancel');
 }
  
    </script>

</head>
<body onkeydown="return checkEnterKeyPress()">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <%--<asp:ServiceReference Path="WebServices/CommonService.asmx" />--%>
                <asp:ServiceReference Path="WebServices/UserPreferences.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                    <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <div>
            <table width="100%" cellpadding="4" cellspacing="0" border="0">
                <tr>
                    <td>
                        <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <UI:Heading ID="Heading" runat="server" HeadingText="Health Data" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; height: 150px; width: 100%;"
                                        cellspacing="0"
                                        cellpadding="0">
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0" width="100%" >
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:Label ID="lblMessage" runat="server" ForeColor="red"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 168px" class="labelFont">Date Recorded</td>
                                                        <td colspan="">
                                                            <asp:TextBox ID="TextBoxDate" TabIndex="1" runat="server" Width="139px" MaxLength="10"></asp:TextBox>
                                                            <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" onclick="CalShow( this, '<%=TextBoxDate.ClientID%>')"
                                                                onmouseover="CalShow( this, '<%=TextBoxDate.ClientID%>')" alt="" align="middle" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" style="width: 174px"></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="labelFont" style="width: 168px">Data
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList Width="98%" TabIndex="2" ID="DropDownListHealthData" runat="server">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                        <div style='display:none'><font color="white">#####START#####</font></div>
                                                            <asp:Panel ID="PanelHelthDataControl" runat="server" Height="150px">
                                                            </asp:Panel>
                                                            <input type="hidden" id="HiddenFormula" runat="server" value=""/>                                                            
                                                            <input type="hidden" id="HiddenDecimal" runat="server" />
                                                            <div style='display:none'><font color="white">#####END#####</font></div>
                                                             
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" colspan="2">
                                                            <input type="button" id="ButtonSave" value="Save" tabindex="8" class="btnimgexsmall" runat="server" style="height: 23px; width: 55px" />
                                                            <asp:Button ID="btnCancel" runat="server" TabIndex="9" CssClass="btnimgexsmall" OnClientClick="closeHealthPage('btnCancel');return false;"
                                                                Text="Cancel" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                 
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>


<input type="hidden" id="HiddenDropDownObject" runat="server" />
<input type="hidden" id="HiddenPanelHealthDataList" runat="server" />



<script>
Sys.Application.add_load(pageLoad)
</script>

</html>