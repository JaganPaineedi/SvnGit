<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HealthMaintenanceAlertPopup.aspx.cs"
    Inherits="Streamline.SmartClient.HealthMaintenanceAlertPopup" EnableViewState="false" EnableViewStateMac="false" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
        function checkShortcut() {
            if (event.keyCode == 8) {
                return false;
            }
        }

        function setFocus(objectRadio) {
        }

        function setFocus1(objectRadio) {
            document.getElementById(objectRadio).focus();
            document.getElementById('DivGridViewAllergies').scrollTop = document.getElementById('DivGridViewAllergies').scrollTop + 13;
        }
    </script>

</head>
<body>
    <!--onkeydown="return checkShortcut()"!-->
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/HealthMaintenanceAlertPopUp.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <asp:Label ID="LabelProgressText" runat="server" Font-Bold="True" Font-Italic="True"
                    Font-Size="Medium" ForeColor="#1C5B94" meta:resourcekey="LabelProgressTextResource1"
                    Text="Processing..."></asp:Label>
                <asp:Image ID="ImageProgressText" runat="server" ImageUrl="~/App_Themes/Includes/Images/Progress.gif"
                    meta:resourcekey="ImageProgressTextResource1" />
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <!--Source-->
                                <table border="0px" cellpadding="0" cellspacing="0" align="center">
                                    <tr>
                                        <td>
                                            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Health Maintenance Alerts" />
                                            <table cellpadding="0" cellspacing="0" style="border: 1px; border-color: Black; height: 100px;"
                                                id="TableAllergies">
                                                <tr>
                                                    <td>
                                                        <table cellpadding="0" cellspacing="0" style="width: 650px;">
                                                            <tr style="padding-bottom: 3px">
                                                                <td style="text-align: left; width: 650px; padding-bottom: 5px">
                                                                    <input class="btnimgexsmall" type="button" id="divMultipleAccept" data-clickaction="accept" style="margin: 3px;"
                                                                        value="Accept" />
                                                                    <input class="btnimgexsmall" type="button" id="divMultipleReject" data-clickaction="reject" style="margin: 3px;"
                                                                        value="Reject" />

                                                                    <div style="width: 60%; color: Black; border: solid 1px #c1cdd4; margin: 3px; overflow: auto; background-color: #f2f2f2;">
                                                                        <asp:Repeater ID="divHMTemplateAndCriteriaRepeater" runat="server">
                                                                            <HeaderTemplate>
                                                                                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                                                                    <tr class="GridViewHeaderText">
                                                                                        <td style="text-align: left; padding-left: 3px">
                                                                                            <div>
                                                                                                <input type="checkbox" id="chkAllRowsHMTemplates" />
                                                                                                <label id="labelActive" for="CheckBox_Clients_Active" style="vertical-align: top">
                                                                                                    <b>Health Maintenance Template</b></label>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <div id="divDataTemplate" style="width: 100%; height: 370px; overflow: auto">
                                                                                    <table style="width: 100%;" cellpadding="0" cellspacing="0" id="tblTemplateAndCriteria">
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <tr class='<%# Container.ItemIndex %2==0 ? "even_row": "odd_row"%> clsDetailRow'>
                                                                                    <td style="vertical-align: top; padding-top: 1px; padding-left: 3px">
                                                                                        <input type="checkbox" id="chkRowHMTemplate" runat="server" data-primarykeylist='<%# Eval("PrimaryKeyList") %>' />
                                                                                    </td>
                                                                                    <td style="vertical-align: top; padding-top: 1px; width: 97%">
                                                                                        <table cellpadding="0" cellspacing="0" style="width: 98%">
                                                                                            <tr>
                                                                                                <td style="width: 85%">
                                                                                                    <div id="divDescription" style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden; font-weight: bold; color: #24659f"
                                                                                                        runat="server" data-clientname='<%# Eval("ClientName")%>'
                                                                                                        data-primarykeylist='<%# Eval("PrimaryKeyList") %>' data-healthmaintenancetemplateid='<%# Eval("HealthMaintenanceTemplateId") %>'
                                                                                                        data-templatedescription='<%# getHMTemplateDescription(Eval("TemplateName"),Eval("FactorGroupNameList")) %>'>
                                                                                                        <%# Eval("TemplateDescription")%>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td style="width: 15%">
                                                                                                    <div id="divSingleEducationInfo" style="cursor: pointer; float: left; margin-right: 10px; float: right">
                                                                                                        <img style="vertical-align: bottom; height: 16px; width: 16px" src="App_Themes/Includes/Images/Educationinfo_Brown.png"
                                                                                                            alt="" title="<%# Eval("ResourceComment") %>" onclick="OpenCLEducationResourceDetails('<%# Eval("DocumentType") %>','<%# Eval("EducationResourceId") %>','<%# Eval("ResourceURL") %>');" />
                                                                                                    </div>
                                                                                                    <div id="divSingleReject" style="cursor: pointer; float: left; margin-right: 10px; float: right"
                                                                                                        data-clickaction="reject" runat="server" data-primarykeylist='<%# Eval("PrimaryKeyList") %>'>
                                                                                                        <img style="vertical-align: bottom; height: 12px; width: 12px" src="App_Themes/Includes/Images/Delete.png"
                                                                                                            alt="" title="Reject" />
                                                                                                    </div>
                                                                                                    <div id="divSingleAccept" style="cursor: pointer; float: left; margin-right: 10px; float: right"
                                                                                                        data-clickaction="accept" runat="server" data-primarykeylist='<%# Eval("PrimaryKeyList") %>'>
                                                                                                        <img style="vertical-align: bottom; height: 12px; width: 12px" src="App_Themes/Includes/Images/Yes.png"
                                                                                                            alt="" title="Accept" />
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="2" style="padding-top: 3px; padding-bottom: 3px;">
                                                                                                    <div id="divTemplateCriteriaDetails" runat="server" style="padding-left: 5px; width: 100%;"
                                                                                                        data-primarykeylist='<%# Eval("PrimaryKeyList") %>'>
                                                                                                        <div style="margin-bottom: 1px">
                                                                                                            <span style="color: #24659f">Template Action Criteria:</span>
                                                                                                        </div>
                                                                                                        <%# getHMTemplateCriteriaDetails(Eval("HealthMaintenanceTemplateId"))%>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                            <FooterTemplate>
                                                                                </table> </div>
            <div id="divBlankTemplate" style="display: none; width: 100%; height: 270px; text-align: center;">
                <span style="color: #24659f; font-weight: bold; display: table-cell; vertical-align: middle;">NO DATA FOUND</span>
            </div>
                                                                            </FooterTemplate>
                                                                        </asp:Repeater>
                                                                    </div>
                                                                    <div style="width: 95%; height: 20px; color: Black; margin-top: 10px; margin-left: 3%">
                                                                        <input style="float: right" class="parentchildbutton" type="button" id="divCancelHMTemplateDecisions"
                                                                            value="Cancel" />
                                                                    </div>

                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="CopyRightLineColor" style="height: 1px">
                                            <input type="hidden" id="hiddenAlertCount" value="" runat="server" />
                                            <input type="hidden" id="hiddenClientName" value="" runat="server" />
                                            <input type="hidden" id="hiddenClientId" value="" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" class="footertextbold">
                                            <b>
                                                <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                                            </b>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <asp:Label ID="LabelError" runat="server" Text="Label" Visible="false"></asp:Label>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script type="text/javascript">        parent.fnHideParentDiv();</script>

</body>
</html>
