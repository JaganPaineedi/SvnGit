<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CrisisPlan.ascx.cs" Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CrisisPlan" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        General
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: -15px">
                                            <tr>
                                                <td valign="bottom" style="width: 25%; padding-left: 15px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="70%">
                                <tr>
                                    <td align="left" style="width: 1%">
                                        <input type="radio" id="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_Y"
                                            value="Y" name="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan"
                                            style="cursor: default" checked="checked"  onclick="ReInitializeCrisisPlan('Y')"/>
                                    </td>
                                    <td align="left" nowrap='nowrap' style="width: 5%">
                                        <label for="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_Y" style="cursor: default">
                                            Initial Crisis Plan</label>
                                    </td>
                                    <td align="left" style="width: 1%">
                                        <input type="radio" id="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_N"
                                            value="N" name="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan"
                                            style="cursor: default" onclick="ReInitializeCrisisPlan('N')"/>
                                    </td>
                                    <td align="left" style="width: 20%">
                                        <label for="RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_N" style="cursor: default">
                                            Review</label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Crisis Plan Demographics
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; border-collapse: separate;
                                width: 100%;">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="left" style="padding-left: 2px; width: 14%">
                                                    <span id="Span_DateOfCrisis">Date of Crisis</span>
                                                </td>
                                                <td style="width: 26%">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td>
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentSafetyCrisisPlans_DateOfCrisis"
                                                                    name="TextArea_CustomDocumentSafetyCrisisPlans_DateOfCrisis" />
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <img id="imgPatientGuradianSigned" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentSafetyCrisisPlans_DateOfCrisis', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 17%; padding-left: 35px">
                                                    <span id="Span_ProgramId">Program</span>
                                                </td>
                                                <td style="width: 26%">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId"
                                                        name="DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId" Style="width: 90%"
                                                        runat="server">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                                <td align="right" style="padding-left: 1px">
                                                    <span id="Span_DOB">DOB</span>
                                                </td>
                                                <td style="width: 12%; padding-left: 5px">
                                                    <span>
                                                        <%=DOB%></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="left" style="padding-left: 2px; width: 14%">
                                                    <span id="Span_StaffId">Staff Contact Person</span>
                                                </td>
                                                <td style="width: 26%">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSafetyCrisisPlans_StaffId"
                                                        name="DropDownList_CustomDocumentSafetyCrisisPlans_StaffId" Style="width: 90%"
                                                        runat="server">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                                <td style="width: 17%; padding-left: 35px">
                                                    <span id="Span_SignificantOther">Emergency Contact</span>
                                                </td>
                                                <td style="width: 26%">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentSafetyCrisisPlans_SignificantOther"
                                                        id="TextBox_CustomDocumentSafetyCrisisPlans_SignificantOther" datatype="String"
                                                        style="width: 87%" maxlength="50" />
                                                </td>
                                                <td style="padding-left: 1px; width: 6%">
                                                    &nbsp;
                                                </td>
                                                <td style="width: 12%">
                                                    &nbsp;
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
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Crisis Related Issues and Information
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CurrentCrisisDescription">Description of the Current Crisis</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentSafetyCrisisPlans_CurrentCrisisDescription"
                                            name="TextArea_CustomDocumentSafetyCrisisPlans_CurrentCrisisDescription" rows="4"
                                            cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Specific plan and circumstances when plan should be enacted
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CurrentCrisisSpecificactions">List specific actions that will be taken
                                            for the current crisis</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentSafetyCrisisPlans_CurrentCrisisSpecificactions"
                                            name="TextArea_CustomDocumentSafetyCrisisPlans_CurrentCrisisSpecificactions"
                                            rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Service Providers
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%" style="padding: 0px 0px 0px 0px;"
                                id="TableChildControl_CustomCrisisPlanMedicalProviders">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Medical and Mental Health Service Providers
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%">
                                                            </td>
                                                            <td width="7">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                                    width="7" height="26" alt="" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="content_tab_bg">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding: 0px 0px 0px 0px;">
                                                        <tr>
                                                            <td style="width: 7%; padding-left: 5px">
                                                                Name
                                                            </td>
                                                            <td style="width: 43%">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomCrisisPlanMedicalProviders_Name"
                                                                    required="true" style="width: 60%" id="TextBox_CustomCrisisPlanMedicalProviders_Name"
                                                                    datatype="String" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    maxlength="50" />
                                                            </td>
                                                            <td style="width: 7%">
                                                                Type
                                                            </td>
                                                            <td style="width: 43%">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomCrisisPlanMedicalProviders_AddressType"
                                                                    Style="width: 62%" name="DropDownList_CustomCrisisPlanMedicalProviders_AddressType"
                                                                    runat="server" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False">
                                                                </cc2:StreamlineDropDowns>
                                                                <%--<input type="hidden" parentchildcontrols="True" id="HiddenField_CustomCrisisPlanMedicalProviders_AddressTypeText" name="HiddenField_CustomCrisisPlanMedicalProviders_AddressTypeText" />--%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 7%; padding-left: 5px">
                                                                Address
                                                            </td>
                                                            <td style="width: 43%">
                                                                <textarea id="Textbox_CustomCrisisPlanMedicalProviders_Address" runat="server" spellcheck="True"
                                                                    name="Textbox_CustomCrisisPlanMedicalProviders_Address" class="form_textarea"
                                                                    style="width: 80%" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    onkeypress="return maxCheckLength(this,150);" onpaste="return maxCheckLengthPaste(this,150);"></textarea>
                                                            </td>
                                                            <td style="width: 7%">
                                                                Phone
                                                            </td>
                                                            <td style="width: 43%">
                                                                <input type="text" class="form_textbox" name="Textbox_CustomCrisisPlanMedicalProviders_Phone"
                                                                    style="width: 60%" onchange="PhoneFormatCheck(this);" id="Textbox_CustomCrisisPlanMedicalProviders_Phone"
                                                                    datatype="String" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    maxlength="25" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                            </td>
                                                            <td align="right" style="padding-right: 15px">
                                                                <input class="parentchildbutton" type="button" id="TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert"
                                                                    name="TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert" onclick="return InsertCrisisPlanMedicalProviders();"
                                                                    value="Insert" />
                                                                <input type="button" class="parentchildbutton" id="TableChildControl_CustomCrisisPlanMedicalProviders_ButtonClear"
                                                                    name="TableChildControl_CustomCrisisPlanMedicalProviders_ButtonClear" value="Clear"
                                                                    onclick="ClearTable('TableChildControl_CustomCrisisPlanMedicalProviders', 'TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert', false);" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; width: 100%" class="content_tab_bg">
                                                    <div id="InsertGrid_CustomCrisisPlanMedicalProviders" runat="server" style="width: 98%;
                                                        padding: 0px 0px 0px 8px">
                                                        <uc1:CustomGrid ID="CustomGrid_CustomCrisisPlanMedicalProviders" runat="server" TableName="CustomCrisisPlanMedicalProviders"
                                                            PrimaryKey="CrisisPlanMedicalProviderId" CustomGridTableName="TableChildControl_CustomCrisisPlanMedicalProviders"
                                                            ColumnName="Name:AddressTypeText:Address:Phone" width="100%" ColumnHeader="Name:Type:Address:Phone"
                                                            ColumnWidth="20%:20%:40%:20%" DivGridName="InsertGrid_CustomCrisisPlanMedicalProviders"
                                                            GridPageName="CustomCrisisPlanMedicalProviders" DoNotDisplayRadio="False" DoNotDisplayDeleteImage="False"
                                                            InsertButtonId="TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert" />
                                                    </div>
                                                    <input type="hidden" id="HiddenField_CustomCrisisPlanMedicalProviders_DocumentVersionId"
                                                        name="HiddenField_CustomCrisisPlanMedicalProviders_DocumentVersionId" parentchildcontrols="True"
                                                        includeinparentchildxml="True" />
                                                    <input type="hidden" id="HiddenField_CustomCrisisPlanMedicalProviders_CrisisPlanMedicalProviderId"
                                                        name="HiddenField_CustomCrisisPlanMedicalProviders_CrisisPlanMedicalProviderId"
                                                        parentchildcontrols="True" includeinparentchildxml="True" />
                                                    <input type="hidden" id="HiddenFieldPrimaryKeyCrisisPlanMedicalProviderId" name="HiddenFieldPrimaryKeyCrisisPlanMedicalProviderId"
                                                        value="CrisisPlanMedicalProviderId" parentchildcontrols="True" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td width="2" class="right_bottom_cont_bottom_bg">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                                    height="7" alt="" />
                                                            </td>
                                                            <td class="right_bottom_cont_bottom_bg" width="100%">
                                                            </td>
                                                            <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                    height="7" alt="" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td class="height4">
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellpadding="0" cellspacing="0" width="99%" style="padding: 0px 0px 0px 0px;"
                                id="TableChildControl_CustomCrisisPlanNetworkProviders">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td align="left">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Support Network
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%">
                                                            </td>
                                                            <td width="7">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                                    width="7" height="26" alt="" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="content_tab_bg">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding: 0px 0px 0px 0px;">
                                                        <tr>
                                                            <td style="width: 7%; padding-left: 5px">
                                                                Name
                                                            </td>
                                                            <td style="width: 43%">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomCrisisPlanNetworkProviders_Name"
                                                                    required="true" style="width: 60%" id="TextBox_CustomCrisisPlanNetworkProviders_Name"
                                                                    datatype="String" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    maxlength="50" />
                                                            </td>
                                                            <td style="width: 7%">
                                                                Type
                                                            </td>
                                                            <td style="width: 43%">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomCrisisPlanNetworkProviders_AddressType"
                                                                    Style="width: 62%" name="DropDownList_CustomCrisisPlanNetworkProviders_AddressType"
                                                                    runat="server" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False">
                                                                </cc2:StreamlineDropDowns>
                                                                <%--<input type="hidden" parentchildcontrols="True" id="HiddenField_CustomCrisisPlanNetworkProviders_AddressTypeText" name="HiddenField_CustomCrisisPlanNetworkProviders_AddressTypeText" />--%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 7%; padding-left: 5px">
                                                                Address
                                                            </td>
                                                            <td style="width: 43%">
                                                                <textarea id="TextBox_CustomCrisisPlanNetworkProviders_Address" runat="server" spellcheck="True"
                                                                    name="TextBox_CustomCrisisPlanNetworkProviders_Address" class="form_textarea"
                                                                    style="width: 80%" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    onkeypress="return maxCheckLength(this,150);" onpaste="return maxCheckLengthPaste(this,150);"></textarea>
                                                            </td>
                                                            <td style="width: 7%">
                                                                Phone
                                                            </td>
                                                            <td style="width: 43%">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomCrisisPlanNetworkProviders_Phone"
                                                                    style="width: 60%" onchange="PhoneFormatCheck(this);" id="TextBox_CustomCrisisPlanNetworkProviders_Phone"
                                                                    datatype="String" bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False"
                                                                    maxlength="25" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                            </td>
                                                            <td align="right" style="padding-right: 15px">
                                                                <input class="parentchildbutton" type="button" id="TableChildControl_CustomCrisisPlanNetworkProviders_ButtonInsert"
                                                                    name="TableChildControl_CustomCrisisPlanNetworkProviders_ButtonInsert" onclick="return InsertCrisisPlanNetworkProviders();"
                                                                    value="Insert" />
                                                                <input type="button" class="parentchildbutton" id="TableChildControl_CustomCrisisPlanNetworkProviders_ButtonClear"
                                                                    name="TableChildControl_CustomCrisisPlanNetworkProviders_ButtonClear" value="Clear"
                                                                    onclick="ClearTable('TableChildControl_CustomCrisisPlanNetworkProviders', 'TableChildControl_CustomCrisisPlanNetworkProviders_ButtonInsert', false);" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="height2">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center; width: 100%" class="content_tab_bg">
                                        <div id="InsertGrid_CustomCrisisPlanNetworkProviders" runat="server" style="width: 98%;
                                            padding: 0px 0px 0px 8px">
                                            <uc1:CustomGrid ID="CustomGrid_CustomCrisisPlanNetworkProviders" runat="server" TableName="CustomCrisisPlanNetworkProviders"
                                                PrimaryKey="CrisisPlanNetworkProviderId" CustomGridTableName="TableChildControl_CustomCrisisPlanNetworkProviders"
                                                ColumnName="Name:AddressTypeText:Address:Phone" width="100%" ColumnHeader="Name:Type:Address:Phone"
                                                ColumnWidth="20%:20%:40%:20%" DivGridName="InsertGrid_CustomCrisisPlanNetworkProviders"
                                                GridPageName="CustomCrisisPlanNetworkProviders" DoNotDisplayRadio="False" DoNotDisplayDeleteImage="False"
                                                InsertButtonId="TableChildControl_CustomCrisisPlanNetworkProviders_ButtonInsert" />
                                        </div>
                                        <input type="hidden" id="HiddenField_CustomCrisisPlanNetworkProviders_DocumentVersionId"
                                            name="HiddenField_CustomCrisisPlanNetworkProviders_DocumentVersionId" parentchildcontrols="True"
                                            includeinparentchildxml="True" />
                                        <input type="hidden" id="HiddenField_CustomCrisisPlanNetworkProviders_CrisisPlanNetworkProviderId"
                                            name="HiddenField_CustomCrisisPlanNetworkProviders_CrisisPlanNetworkProviderId"
                                            parentchildcontrols="True" includeinparentchildxml="True" />
                                        <input type="hidden" id="HiddenFieldPrimaryKeyCrisisPlanNetworkProviderId" name="HiddenFieldPrimaryKeyCrisisPlanNetworkProviderId"
                                            value="CrisisPlanNetworkProviderId" parentchildcontrols="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
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
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Review
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: -15px">
                                            <tr>
                                                <td valign="bottom" style="width: 25%; padding-left: 15px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="70%">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="80%">
                                            <tr>
                                                <td colspan="2">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentSafetyCrisisPlans_SafetyPlanNotReviewed"
                                                                    name="CheckBox_CustomDocumentSafetyCrisisPlans_SafetyPlanNotReviewed" style="cursor: default"
                                                                    value="C" />
                                                            </td>
                                                            <td align="left" valign="middle" style="padding-left: 3px; width: 30%">
                                                                <label for="CheckBox_CustomDocumentSafetyCrisisPlans_SafetyPlanNotReviewed" style="cursor: default">
                                                                    Safety Plan was not reviewed</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 28%">
                                                    <span id="Span_ReviewSafetyPlanEveryXDays">Review Crisis Plan Every</span>
                                                </td>
                                                <td align="left">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentSafetyCrisisPlans_ReviewCrisisPlanXDays"
                                                        id="TextBox_CustomDocumentSafetyCrisisPlans_ReviewCrisisPlanXDays" datatype="Numeric"
                                                        maxlength="2" style="width: 10%" />&nbsp;Days
                                                </td>
                                                <td align="left">
                                                    <%-- <span id="Span_CustomDocumentSafetyCrisisPlans_NextCrisisPlanReviewDate"
                                                        name="Span_CustomDocumentSafetyCrisisPlans_NextCrisisPlanReviewDate">
                                                    </span>--%>
                                                      <%=NextCrisisPlanReviewDate%>
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
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
