<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MadicationPatientContent.ascx.cs"
    Inherits="UserControls_MadicationPatientContent" %>
<asp:ScriptManagerProxy runat="server" ID="SMP2">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ClientSearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script language="javascript" type="text/javascript">

function redirectToPage() {    
    if ($("[id*=HiddenPage]").val() == 'ViewConsentHistory')
      redirectToViewConsentHistoryPageClearSession();
      else
      redirectToManagementPage();
}

    window.load = function() {
        document.getElementById('dvWaiting').style.display = 'none';
    };

</script>

<a id="anchorId" runat="server" onclick="return true" onserverclick="GetStandardRDLCContents">
</a>
<div id="dvWaiting" style="display: none; position: absolute; z-index: 999; left: 280px;
    top: 25px; white-space: nowrap">
    <%--<font size="Medium" color="#1c5b94"><b><i><span id="spConnMsg">Communicating with Server...</span></i></b></font><img
        src="App_Themes/Includes/Images/Progress.gif" />--%>
     <img src="App_Themes/Includes/Images/ajax-loader.gif" />
</div>
<div id="Parda" style="display: none; position: absolute; top: 0; left: 0; width: 300px;
    background-color: #ffffff; border: 1px solid #cccc99; filter: Alpha(Opacity=0)">
</div>
<div>
    <asp:HiddenField ID="HiddenFieldSignedBy" runat="server" />
    <asp:HiddenField ID="HiddenFieldDocumentVersionId" runat="server" />
    <table width="100.7%" border="0" cellpadding="0" cellspacing="0">
         <tr>
       
             <td class="header" style="width: 40%">
        <asp:Label ID="LabelTitleBar" runat="server" Visible="true" style ="color: white; " 
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
            </td>           
            <td style="width: 30%; padding-right:0.7%;" align="right" class="header">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="right" style="width: 70%">
                            <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" Style="display: none; color:white;"
                                runat="server" OnClientClick="redirectToStartPage(); this.disabled=true;return false;"></asp:LinkButton>
                        </td>
                        <td align="right" style="width: 30%">
                            <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                                Style="display: none"> <asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                             <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 1pt; border-bottom: #5b0000 1px solid;" colspan="2">
            </td>
        </tr>
        <tr>
            <td style="height: 25px; width: 30%">
                <asp:Label ID="Label1" runat="server" CssClass="TittleBarBase" Text="Patient Consent"></asp:Label>
            </td>
             </tr>
          <tr>
            <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif">
            </td>
        </tr>
           <%-- <td align="center" style="width: 30%">
                <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" CssClass="SamrtCareTittleBarBase"
                    Text="SmartCareRx"></asp:Label>
            </td>
            <td style="width: 30%" align="right">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="right" style="width: 50%">
                            <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" Style="display: none;"
                                runat="server" OnClientClick="redirectToStartPage(); this.disabled=true;return false;"></asp:LinkButton>
                        </td>
                        <td align="right" style="width: 50%">
                            <asp:LinkButton ID="LinkButtonLogout" Text="Logout" runat="server" OnClick="LinkButtonLogout_Click"
                                Style="display: none"></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>--%>
        <%--<tr>
            <td style="height: 1pt; border-bottom: #5b0000 1px solid;" colspan="3">
            </td>
        </tr>--%>
        <tr>
            <td colspan="2" style="padding-left:8px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="left" nowrap="nowrap">
                            <asp:Label ID="LabelClientName"  runat="server"></asp:Label>,
                            <%--<asp:Label ID="LabelDOB" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server" Text="DOB:"></asp:Label>
                            <asp:Label ID="LabelClientDOB" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server"></asp:Label>,
                            <asp:Label ID="LabelSex" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server" Text="Sex:"></asp:Label>
                            <asp:Label ID="LabelClientSex" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server"></asp:Label>,
                            <asp:Label ID="LabelRace" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server" Text="Race:"></asp:Label>
                            <asp:Label ID="LabelClientRace" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                                runat="server"></asp:Label>--%>
                        </td>
                        <td align="right">
                            &nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; margin-left:8px;">
        <tr>
            <td colspan="9">
                <table border="0" cellpadding="0" cellspacing="0" style="height: 1px">
                    <tr>
                        <td valign="bottom">
                            <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                                Style="display: none; vertical-align: middle" />
                        </td>
                        <td valign="bottom">
                            &nbsp;
                            <asp:Label ID="LabelErrorMessage" runat="server" Style="vertical-align: middle" CssClass="redTextError"
                                Height="18px"></asp:Label>
                        </td>
                        <%--<td valign="bottom">
                        <div id="DivErrorMessage" runat="server" style="display: none; width: 22px; height: 12px">
                        </div>
                    </td>--%>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <!-- Made the Visibility false of Titrate and Suggested Protocols buttons as per Task #36 1.5.1 - New Order, Change Order: Remove Titrate and Sugst Prot Buttons-->
            <td style="height: 25px" align="left">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="labelFont">
                            Consent Form :
                        </td>
                        <td width="10px">
                        </td>
                        <td>
                            <asp:DropDownList ID="DropDownConsentList" runat="server" Width="193px" OnSelectedIndexChanged="DropDownConsentList_SelectedIndexChanged"
                                AutoPostBack="true" Enabled="false">
                            </asp:DropDownList>
                        </td>
                        <td style="width: 20px">
                        </td>
                        <td class="labelFont">
                            Medical Staff Name :
                        </td>
                        <td width="10px">
                        </td>
                        <td colspan="2" nowrap>
                            <asp:Label ID="LabelMedicalStaffName" runat="server" CssClass="Label"></asp:Label>
                        </td>
                        <td style="width: 20px">
                        </td>
                        <td colspan="1" nowrap="nowrap" class="labelFont">
                            Status :
                        </td>
                        <td width="10px">
                        </td>
                        <td colspan="1" nowrap="nowrap">
                            <asp:Label class="Label" ID="LabelSignedNotSigned" runat="server" Text="Not Signed"></asp:Label>
                        </td>
                        <!--Addsed by anuj for task ref:2932 MedicationManagement-->
                        <td width="10px">
                        </td>
                        <td colspan="1" nowrap="nowrap">
                            <input type="button" id="ButtonConsentEdit" value="Edit" class="btnimgexsmall" onclick="javascript:ChangeConsentFormMode(this);" />
                        </td>
                        <!--Ended over here-->
                        <td width="15px">
                        </td>
                        <td colspan="1" nowrap="nowrap">
                            <input type="button" id="ButtonPrint" value="Print..." class="btnimgexsmall" 
                                onclick="CommonFunctions.ShowPrintPatientConsentDiv('<%= Session["ImgIdForMDSigned"] %>','1','',true);" />
                        </td>
                        <td width="15px">
                        </td>
                        <td colspan="1" nowrap="nowrap">
                            <asp:Literal runat="server" ID="ButtonRevokeHolder"></asp:Literal>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table id="Table1"  runat="server" cellpadding="0" cellspacing="0" style="border: #dee7ef 3px solid;
        width: 100%; height: 200px; overflow: scroll; margin-left:8px;">
        <tr>
            <td valign="top" height="400px">
                <iframe id="IFrameDocuments" width="100%" height="100%" style="border:0;"></iframe>
            </td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
        <tr>
            <td colspan="5" style="height: 19px" class="LabelClaimline">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 130px; height: 24px">
                        </td>
                        <td style="width: 32px; height: 24px">
                            &nbsp;<asp:RadioButton ID="RadioButtonMedicalStaff" runat="server" Width="185px"
                                GroupName="rdo" />
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 130px; height: 24px">
                        </td>
                        <td style="width: 32px; height: 24px">
                            &nbsp;<asp:RadioButton ID="RadioButtonPatient" runat="server" Width="184px" GroupName="rdo" />
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 130px; height: 24px">
                        </td>
                        <td style="width: 25px; height: 24px">
                           <asp:RadioButton ID="RadioButtonRelation" runat="server" Width="20px" Text=" "
                                GroupName="rdo" />
                        </td>
                        <td style="width: 32px; height: 24px">
                            <asp:DropDownList ID="DropDownRelationShip" runat="server" Width="176px">
                            </asp:DropDownList>
                        </td>
                        <td width="10px">
                        </td>
                        <td style="width: 32px; height: 24px">
                            <asp:TextBox ID="TextBoxSignatureName" runat="server"></asp:TextBox>
                        </td>
                        <td width="10px">
                        </td>
                        <td style="height: 25px">
                            <input type="button" id="ButtonSign" class="btnimgexsmall" onclick="OpensignaturePad();return false;"
                                value="Sign" runat="server" />
                        </td>
                        <td style="width: 10px">
                        </td>
                        <td style="height: 25px">
                            <input type="button" id="ButtonCancel" class="btnimgexsmall" onclick="redirectToPage();return false;"
                                value="Close" />
                        </td>
                        <asp:HiddenField ID="HiddenFieldDataSet" runat="server" />
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="HiddenFieldReportUrl" runat="server" />
    <asp:HiddenField ID="HiddenFieldDocumentSignaturesNoPassword" runat="server" />
    <asp:HiddenField ID="HiddenFieldStaffPassword" runat="server" />
</div>
