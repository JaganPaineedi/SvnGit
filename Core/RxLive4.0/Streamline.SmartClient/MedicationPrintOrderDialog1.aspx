<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationPrintOrderDialog1.aspx.cs" Inherits="MedicationPrintOrderDialog1" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/js/MedicationPrint.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <script type="text/javascript" language="javascript" src="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1"></script>
    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        function EnableOkButton() {
            EnablesDisable('<%=ButtonOk.ClientID %>', '<%=RadioButtonFaxToPharmacy.ClientID %>', '<%=RadioButtonPrintScript.ClientID %>', '<%=CheckBoxFaxIncludeChartCopy.ClientID%>', '<%=CheckBoxFaxDrugInformation.ClientID%>', '<%=RadioButtonPrintChartCopy.ClientID%>');
}
// Adding New parameter for Fax Faild message
function PrintMedicationScript(ScriptIds, ChartScriptIds, FaxStatus) {
    var d = new Date();
    var myans1 = window.open('MedicationScriptPrinting.aspx?varScriptIds=' + ScriptIds + '&varChartScriptIds=' + ChartScriptIds + '&varFaxSendStatus=' + FaxStatus + '&varTime =' + d.getTime(), '', 'menubar = 0;status = 0; height=500px,width=750px,top=20px,left=170px,scrollbars=1');
    if (document.getElementById("HiddenFieldToBeFaxedButPrinted").value == "1")
        alert('Some Medications could not be Faxed,Please review script History!');
    closeDiv();
}

function fnShowParentDiv1(msgText, progMsgLeft, progMsgTop) {
    try {

        var objdvProgress = document.getElementById("dvProgress2");
        objdvProgress.style.left = progMsgLeft;
        objdvProgress.style.top = progMsgTop;
        objdvProgress.style.display = '';
                } catch(Exception) {
        ShowError(Exception.description, true);
    }
}

function fnShow1() {
    try {
        fnShowParentDiv1("Processing...", 150, 25);
                } catch(Exception) {
        ShowError(Exception.description, true);
    }
}
    </script>


    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />


</head>
<body onload="Javascript:EnableOkButton();window.history.forward(1);">
        <div id="dvProgress2" style="display: none; left: 150px; position: absolute; top: 25px; white-space: nowrap; z-index: 999;">
        <%--<font size="Medium" color="#1c5b94"><b><i><span id="spConnMsg">Communicating with Server...</span></i></b></font><img
            src="App_Themes/Includes/Images/Progress.gif" />--%>
             <img src="App_Themes/Includes/Images/ajax-loader.gif" />
    </div>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/CommonService.asmx" />
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
        </asp:ScriptManager>

        <div>
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="715px">
                <tr>
                    <td style="height: 5px">
                        <table border="0" cellpadding="0" cellspacing="0" width="500px">
                            <tr>
                                <td align="LEFT" style="height: 30px; width: 3%" valign="bottom">
                                            <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                                </td>
                                <td valign="top">

                                    <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label></td>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="height: 277px">
                        <!--Source-->
                        <table border="0px" cellpadding="0" cellspacing="0" style="width: 715px;">
                            <tr>
                                <td style="height: 235px" valign="top">

                                    <UI:Heading ID="Heading1" runat="server" HeadingText="Script Information" />
                                        <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;"
                                        width="100%">
                                        <tr>
                                            <td>
                                                <table width="100%">
                                                    <tr>
                                                        <td valign="top">&nbsp;
                                              
                                                        </td>

                                                        <td align="left" valign="top">&nbsp;
                                       
                                                        </td>
                                                        <td align="left" valign="top">&nbsp;
                                       
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">
                                                            <asp:RadioButton ID="RadioButtonPrintScript" runat="server" Text="Print Script" GroupName="Print" CssClass="SumarryLabel" AutoPostBack="false" />
                                                        </td>
                                                        <td align="left" valign="top">
                                                            <asp:CheckBox ID="CheckBoxPrintIncludeChartCopy" runat="server" Text="Include Chart Copy" />
                                                        </td>
                                                        <td align="left" valign="top">
                                                            <asp:CheckBox ID="CheckBoxPrintDrugInformation" runat="server" Text="Print Drug Information" />
                                                        </td>
                                                    </tr>
                                                    <!--Blank Row-->
                                                    <tr>
                                                        <td valign="top">
                                                            <asp:RadioButton ID="RadioButtonPrintChartCopy" runat="server" Text="Print Chart Copy" GroupName="Print" CssClass="SumarryLabel" AutoPostBack="false" />
                                                        </td>
                                                        <td colspan="1">&nbsp;
                                                        </td>
                                                        <td align="left" valign="top">
                                                            <asp:CheckBox ID="CheckBoxPrintChartCopyDrugInformation" runat="server" Text="Print Drug Information" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">
                                                            <asp:RadioButton ID="RadioButtonFaxToPharmacy" runat="server" GroupName="Print" Text="Fax to Pharmacy" CssClass="SumarryLabel" AutoPostBack="false" />
                                                        </td>
                                                        <td align="left" valign="top">
                                                            <asp:CheckBox ID="CheckBoxFaxIncludeChartCopy" runat="server" Text="Include Chart Copy" />
                                                        </td>
                                                        <td align="left" valign="top">
                                                            <asp:CheckBox ID="CheckBoxFaxDrugInformation" runat="server" Text="Print Drug Information" />
                                                        </td>
                                                    </tr>
                                                    <!--Blank Row-->
                                                    <tr>
                                                        <td align="left" valign="top" colspan="3">
                                                            <asp:Label ID="LabelFaxtoPharmacy" runat="server" Width="100px" CssClass="labelFont" Font-Names="verdana" Font-Size="8.25pt"
                                                                Text="Fax to Pharmacy"></asp:Label>
                                                            <asp:DropDownList ID="DropDownListPharmacies" runat="server" CssClass="ddlist"
                                                                Width="490px">
                                                            </asp:DropDownList></td>
                                                    </tr>

                                                    <!--Blank Row-->
                                                    <tr>
                                                        <td colspan="3">
                                                            <asp:Label ID="LabelScriptReason" runat="server" CssClass="labelFont" Font-Names="verdana"
                                                                Font-Size="8.25pt" Text="Script Reason" Width="100px"></asp:Label>
                                                            <asp:DropDownList ID="DropDownListScriptReason" runat="server" CssClass="ddlist"
                                                                Width="189px">
                                                            </asp:DropDownList></td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" colspan="3">&nbsp;<br />
                                                                <asp:Button ID="ButtonOk" runat="server" CssClass="ButtonWebBold"
                                                                            Text="Ok" Width="99px" />
                                                                <asp:Button ID="ButtonCancel" runat="server" Text="Cancel" CssClass="btnimgexsmall"
                                                                Width="99px" OnClientClick="closeDiv();return false;" />
                                                            <a id="anchorOk" runat="server" onclick="false" onserverclick="ButtonOk_Click"></a>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td colspan="2" align="center">
                                                            <asp:Label ID="LabelDenialReason" runat="server" CssClass="redTextError"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <!--Blank Row-->
                                                <tr>
                                                    <td colspan="2">&nbsp;
                                                    </td>
                                                </tr>

                                            </td>
                                        </tr>

                                    </table>

                                </td>
                            </tr>
                            <tr>
                                <td align="center" class="footertextbold" valign="bottom">&nbsp;
                           
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="background-color: #5b0000; height: 1pt; padding-left: 15px"></td>
                            </tr>
                            <tr>
                                <td align="center" class="footertextbold"><b>
                                    <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                                </td>
                            </tr>


                        </table>


                    </td>
                </tr>
                <tr>
                    <td align="center">

                        <asp:HiddenField ID="HiddenFieldLatestClientMedicationScriptId" runat="server" />
                        <asp:HiddenField ID="HiddenFieldOrderMethod" runat="server" />
                        <asp:HiddenField ID="HiddenFieldToBeFaxedButPrinted" runat="server" />
                        <asp:HiddenField ID="HiddenFieldReprintAllowed" runat="server" />
                        <asp:HiddenField ID="HiddenFieldMedicationOrderStatus" runat="server" />
                    </td>
                </tr>
            </table>
        </div>

    </form>
    <script type="text/javascript">parent.fnHideParentDiv();</script>
</body>
</html>