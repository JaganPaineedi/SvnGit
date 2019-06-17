<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewMedicationHistory.aspx.cs"
    Inherits="ViewMedicationHistory" EnableViewState="false" %>

<%@ OutputCache Location="None" VaryByParam="None" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register TagPrefix="UI" TagName="MedicationList" Src="UserControls/MedicationList.ascx" %>
<html>
<body>
        <div id="dvProgress" style="display: none; left: 0; position: absolute; right: inherit; top: 47px; width: 224px" class="progress">
       <%-- <font size="Medium" color="#1c5b94"><b><i>Communicating with Server...</i></b></font>
        <img src="App_Themes/Includes/Images/Progress.gif" title="Progress" />--%>
             <img src="App_Themes/Includes/Images/ajax-loader.gif" />
    </div>
</body>
</html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script type="text/javascript" language="javascript">
  
            function fnHideParentDiv1() {

                try {
      var objdvProgress=document.getElementById('dvProgress');
      if(objdvProgress!=null)
      objdvProgress.style.display='none';
                } catch(Exception) {
   alert(Exception.message);
   ShowError(Exception.description,true);
    }

}


            function fnShowTemp() {

                try {
                    fnShowParentDiv("Processing...", 150, 25);
                } catch(Exception) {
   ShowError(Exception.description,true);
   }
}

            function fnShowParentDiv(msgText, progMsgLeft, progMsgTop) {

                try {
  
    var objdvProgress=document.getElementById("dvProgress");
    objdvProgress.style.left=progMsgLeft;
    objdvProgress.style.top=progMsgTop;
    objdvProgress.style.display='';
                } catch(Exception) {
   ShowError(Exception.description,true);
    }

}

            function SetFilterValue(DropDownMedication) {
                try {
                    document.getElementById('<%= HiddenFieldMedication.ClientID %>').value = document.getElementById('<%= DropDownMedication.ClientID %>').value;
                } catch(Exception) {
     ShowError(Exception.description,true);
   } 
  }
  
            function SetPrescriberFilterValue() {
                try {
                    document.getElementById('<%= HiddenFieldPrescriber.ClientID %>').value = document.getElementById('<%= DropDownListPrescriber.ClientID %>').value;
                } catch(Exception) {
     ShowError(Exception.description,true);
   } 
  }

            function SetDateFilterValue() {
                try {
                    document.getElementById('<%= HiddenFieldDateFilter.ClientID %>').value = document.getElementById('<%= DropDownListDateFilter.ClientID %>').value;
                } catch(Exception) {
     ShowError(Exception.description,true);
   } 
  }

            function SetDiscontinueReasonFilterValue() {
                try {
                    document.getElementById('<%= HiddenFieldDiscontineReasonFilter.ClientID %>').value = document.getElementById('<%= DropDownListDiscontinuedReason.ClientID %>').value;
                } catch(Exception) {
     ShowError(Exception.description,true);
    } 
  }
  
    </script>

</head>
<body onload="Javascript:addHandle(document.getElementById('topborder'), window);">
    <form id="form2" runat="server">
    <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="1010px">
        <tr>
            <td width="100%" id="topborder" class="TitleBarText" align="left">
                View Medication History
            </td>
            <td align="left" width="10px">
                <img id="ImgCross" onclick="closeDiv()" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>'
                    title="Close" alt="Close" />
            </td>
        </tr>
    </table>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="WebServices/CommonService.asmx" />
            <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/ViewMedicationHistory.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>
    <div>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="LEFT" style="height: 10px; width: 3%" valign="top">
                                       <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                            </td>
                            <td valign="top">
                                <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <!--Source-->
                    <table border="0px" cellpadding="0" cellspacing="0" style="height: 645px;">
                        <tr>
                            <td>
                                <table border="0px" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                                    <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef thin solid; border-left: #dee7ef thin solid; border-right: #dee7ef thin solid; border-top: #dee7ef thin solid; height: 1px;"
                                                align="left">
                                                <tr>
                                                    <td valign="middle" align="left" colspan="5">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="center" class="labelClass" valign="middle">
                                                                                Date&nbsp;
                                                                            </td>
                                                                            <td valign="middle">
                                                                                <asp:DropDownList ID="DropDownListDateFilter" runat="server" AutoCompleteType="Disabled"
                                                                                    CssClass="ddlist" MaxLength="30" TabIndex="6" Width="150px">
                                                                                </asp:DropDownList>
                                                                                &nbsp;
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="left" class="labelClass" valign="middle" style="width: 70px">
                                                                                Start Date&nbsp;
                                                                            </td>
                                                                            <td valign="middle">
                                                                                <asp:TextBox ID="TextBoxStartDate" runat="server" AutoCompleteType="Disabled" CssClass="TextBox"
                                                                                    MaxLength="30" TabIndex="5" Width="95px" Height="15px"></asp:TextBox>&nbsp;
                                                                            </td>
                                                                            <td align="right" valign="middle" style="width: 29px">
                                                                                <img id="Img2" src="App_Themes/Includes/Images/calender_White.jpg" onclick="CalShow( this, '<%=TextBoxEndDate.ClientID%>')"
                                                                                    onmouseover="CalShow( this, '<%=TextBoxStartDate.ClientID%>')" alt="" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="left" class="labelClass" valign="middle">
                                                                                End Date&nbsp;
                                                                            </td>
                                                                            <td valign="middle">
                                                                                <asp:TextBox ID="TextBoxEndDate" runat="server" AutoCompleteType="Disabled" CssClass="TextBox"
                                                                                    MaxLength="30" TabIndex="5" Width="95px" Height="15px"></asp:TextBox>&nbsp;
                                                                            </td>
                                                                            <td align="right" valign="middle">
                                                                                <img id="Img1" src="App_Themes/Includes/Images/calender_White.jpg" onclick="CalShow( this, '<%=TextBoxEndDate.ClientID%>')"
                                                                                    onmouseover="CalShow( this, '<%=TextBoxEndDate.ClientID%>')" alt="" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="left" class="labelClass" valign="middle">
                                                                                Medication&nbsp;
                                                                            </td>
                                                                            <td valign="top">
                                                                                <asp:DropDownList ID="DropDownMedication" runat="server" AutoCompleteType="Disabled"
                                                                                    CssClass="ddlist" MaxLength="30" TabIndex="6" Width="200px">
                                                                                </asp:DropDownList>
                                                                                &nbsp;
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="ButtonApplyFilter" runat="server" Text="Apply Filter" OnClick="ButtonApplyFilter_Click"
                                                                                        CssClass="btnimgexsmall" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" colspan="2">
                                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 600px">
                                                            <tr>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="center" class="labelClass" valign="middle">
                                                                                Prescriber&nbsp;
                                                                            </td>
                                                                            <td valign="top">
                                                                                <asp:DropDownList ID="DropDownListPrescriber" runat="server" AutoCompleteType="Disabled"
                                                                                    CssClass="ddlist" MaxLength="30" TabIndex="4" Width="200px">
                                                                                </asp:DropDownList>
                                                                                &nbsp;
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <table border="0px" cellpadding="0" cellspacing="0px">
                                                                        <tr>
                                                                            <td align="center" class="labelClass" valign="middle">
                                                                                Discontinue Reason&nbsp;
                                                                            </td>
                                                                            <td valign="top">
                                                                                <asp:DropDownList ID="DropDownListDiscontinuedReason" runat="server" AutoCompleteType="Disabled"
                                                                                    CssClass="ddlist" MaxLength="30" TabIndex="4" Width="200px">
                                                                                </asp:DropDownList>
                                                                                &nbsp;
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <td style="width: 66px">
                                                    <asp:HiddenField ID="HiddenFieldMedication" runat="server" />
                                                    &nbsp;
                                                </td>
                                                <td style="width: 215px">
                                                    &nbsp;<asp:HiddenField ID="HiddenFieldPrescriber" runat="server" />
                                                </td>
                                                <td style="width: 250px">
                                                    &nbsp;<asp:HiddenField ID="HiddenFieldDateFilter" runat="server" />
                                                </td>
                                                <td style="width: 250px">
                                                    &nbsp;<asp:HiddenField ID="HiddenFieldDiscontineReasonFilter" runat="server" />
                                                </td>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr>
                            <td valign="top">
                                <a href="abc" id="testMedHistory" target="_blank"></a>
                                <br />
                                        <input type="button" id="ButtonPrintList" name="ButtonPrintList" value="Print List" onclick=" javascript:ButtonPrintListViewHistory('Medications - View History');return false; "
                                               class="btnimgexsmall" <%= enableDisabled(Streamline.BaseLayer.Permissions.PrintList) %> />
                            </td>
                        </tr>
                        <tr>
                            <td width="990px" valign="top">
                                <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Medication List" />
                                        <table cellpadding="0" cellspacing="0" style="border: 1px; border-color: Black; height: 100px; width: 100%">
                                    <tr>
                                                <td style="border: 1px; border-color: Black; border-style: solid;">
                                            <!-- Medication List Control -->
                                                    <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:Panel ID="PanelMedicationListInformation" runat="server" BorderColor="Black"
                                                            BorderStyle="None" Height="500px" Width="100%">
                                                            <UI:MedicationList ID="MedicationList1" runat="Server" />
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px">
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 5px">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="background-color: #5b0000; height: 1pt; padding-left: 15px">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="CopyRightLineColor" style="height: 1px">
                </td>
            </tr>
            <tr>
                <td align="center" class="footertextbold">
                    <b>
                        <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    </form>

    <script type="text/javascript">parent.fnHideParentDiv();</script>

</body>
</html>

<script type="text/javascript" language="javascript">
    
     SetVariableName(document.getElementById('<%=PanelMedicationListInformation.ClientID%>'));
   
</script>