<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentClientContacts.ascx.cs"
    Inherits="SHS.SmartCare.RegistrationDocumentClientContacts" %>
<%@ Register Src="../../../CommonUserControls/AddressControl.ascx" TagName="AddressControl"
    TagPrefix="uc2" %>
<%@ Register Src="~/CommonUserControls/AddressControl.ascx" TagName="AddressControl"
    TagPrefix="ucAddressContactControl" %>
<%@ Register Src="~/CommonUserControls/ClientAddressControl.ascx" TagName="ClientAddressControl"
    TagPrefix="ucClientAddressControl" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DropDowns" Namespace="Streamline.DropDowns" TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DropDownGlobalCodes" Namespace="Streamline.DropDownGlobalCodes"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc4" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Namespace="SHS.CustomControl" TagPrefix="SHSC" %>
<div id="divContactPage" class="DocumentScreen">
    <table cellspacing="0" cellpadding="0" border="0" width="100%" id="TableChildControl_ClientContacts"
        clearcontrol="true" parentchildcontrols="True">
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td class="height2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td colspan="6" align="right" style="padding-right: 10px">
                            <div style="float: right; margin-top: -5px">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <div class="glow_lt">
                                                &nbsp;
                                            </div>
                                        </td>
                                        <td>
                                            <div class="glow_mid">
                                                <input type="button" id="ButtonInsert" name="ButtonInsert" value="Add/Edit Contacts"
                                                    onclick="OpenPage(5761, 370, 'ClientID=<%=SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId%>', null, <%=RelativePath%>, null, null, null, 3, null, null);" />
                                            </div>
                                        </td>
                                        <td>
                                            <div class="glow_rt">
                                                &nbsp;
                                            </div>
                                        </td>
                                        <td style="width: 20px">
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        List of Contacts
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                    </td>
                                    <td class="content_tab_top" width="80%" />
                                    <td width="7">
                                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" class="content_tab_bg" align="center">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%" style="padding-right: 5px;
                                padding-left: 5px">
                                <tr>
                                    <td>
                                        <div id="InsertGridContacts" runat="server" style="width: 100%; overflow-y: auto;
                                            overflow-x: hidden; height: 120px; text-align: left;">
                                            <uc1:CustomGrid ID="CustomGrid" width="800px" runat="server" TableName="ClientContacts"
                                                PrimaryKey="ClientContactId" CustomGridTableName="TableChildControl_ClientContacts"
                                                GridPageName="Contacts" ColumnName="ListAs:RelationshipText:Phone:Organization:GuardianText:EmergencyText:FinResponsibleText:HouseholdnumberText:Active"
                                                ColumnHeader="Contact:Relation:Phone:Organization:Guardian:Emergency:Financially Responsible:Household Member:Active"
                                                ColumnWidth="18%:10%:10%:12%:7%:9%:15%:13%:6%" DivGridName="InsertGridContacts"
                                                InsertButtonId="TableChildControl_ClientContacts_ButtonInsert" DoNotDisplayDeleteImage="true"
                                                DoNotDisplayRadio="true" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="right_bottom_cont_bottom_bg" width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <input type="hidden" parentchildcontrols="True" id="HiddenField_ClientContacts_ClientContactId"
                    name="HiddenField_ClientContacts_ClientContactId" value="-1" />
                <input type="hidden" parentchildcontrols="True" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey"
                    value="ClientContactId" />
                <input type="hidden" id="HiddenFieldCustomAjaxCallType" />
            </td>
        </tr>
    </table>
</div>
