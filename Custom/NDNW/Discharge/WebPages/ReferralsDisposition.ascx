<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReferralsDisposition.ascx.cs"
    Inherits="Custom_Discharge_WebPages_ReferralsDisposition" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        Disposition Plan
                    </td>
                    <td width="17">
                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                    </td>
                    <td class="content_tab_top" width="100%">
                        <input style="padding-left: 1%" type="checkbox" id="CheckBox_CustomDocumentDischarges_NoReferral" />
                        <label for="CheckBox_CustomDocumentDischarges_NoReferral" id="labelReferral">
                            No Referral Made</label>
                    </td>
                    <td width="7">
                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg_padding">
            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="height2">
                        <tr>
                            <td valign="top">
                                If Symptoms reoccur or additional services are needed
                            </td>
                        </tr>
                        <tr>
                            <td class="height3">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <textarea rows="4" cols="157" id="TextArea_CustomDocumentDischarges_SymptomsReoccur"
                                    class="form_textareaWithoutWidth element" spellcheck="True">
                                        </textarea>
                            </td>
                        </tr>
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        Referrals
                    </td>
                    <td width="17">
                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                    </td>
                    <td class="content_tab_top" width="100%">
                    </td>
                    <td width="7">
                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg_padding">
            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table width="60%">
                            <tr>
                                <td valign="top" style="width: 30%">
                                    Referral at Discharge
                                </td>
                                <td>
                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_ReferralDischarge"
                                        name="DropDownList_CustomDocumentDischarges_ReferralDischarge" runat="server"
                                        CssClass="form_dropdown" Width="250px" Category="xReferralDischarge" AddBlankRow="true"
                                        BlankRowText="">
                                    </cc2:DropDownGlobalCodes>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="height2">
                        <tr>
                            <td valign="top">
                                Referred to(name, location, telephone number and contact info)
                            </td>
                        </tr>
                        <tr>
                            <td class="height3">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <textarea rows="4" cols="157" id="TextArea_CustomDocumentDischarges_ReferredTo" class="form_textareaWithoutWidth element"
                                    spellcheck="True">
                                        </textarea>
                            </td>
                        </tr>
                    </td>
                </tr>
                <tr>
                    <td class="height2">
                        <tr>
                            <td valign="top">
                                Reason (What Services?)
                            </td>
                        </tr>
                        <tr>
                            <td class="height3">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <textarea rows="4" cols="157" id="TextArea_CustomDocumentDischarges_Reason" class="form_textareaWithoutWidth element"
                                    spellcheck="True">
                                        </textarea>
                            </td>
                        </tr>
                    </td>
                </tr>
                <tr>
                    <td class="height2">
                        <tr>
                            <td valign="top">
                                Date and Times of Appointments(if known)
                            </td>
                        </tr>
                        <tr>
                            <td class="height3">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <textarea rows="4" cols="157" id="TextArea_CustomDocumentDischarges_DatesTimes" class="form_textareaWithoutWidth element"
                                    spellcheck="True">
                                        </textarea>
                            </td>
                        </tr>
                    </td>
                </tr>
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table id="TableChildControl_CustomDischargeReferrals" clearcontrol="true" parentchildcontrols="True"
                            border="0" width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 9px;
                            padding-right: 9px">
                            <%-- <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td>
                                                <input type="hidden" id="HiddenField_CustomDischargeReferrals_ReferralText" name="HiddenField_CustomDischargeReferrals_ReferralText"
                                                    parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDischargeReferrals_ProgramText" name="HiddenField_CustomDischargeReferrals_ProgramText"
                                                    parentchildcontrols="True" />
                                            </td>
                                        </tr>
                                    </table>
                                    </td>
                            </tr>--%>
                            <tr>
                                <td class="height3">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 12%">
                                    Discharge Referral
                                </td>
                                <td style="width: 30%; padding-left: 10px">
                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDischargeReferrals_Referral" name="DropDownList_CustomDischargeReferrals_Referral"
                                        runat="server" CssClass="form_dropdown" Width="200px" Category="xReferralOut"
                                        parentchildcontrols="True" AddBlankRow="true" BlankRowValue="-1" BlankRowText="">
                                    </cc2:DropDownGlobalCodes>
                                </td>
                                <td style="width: 5%">
                                    Program
                                </td>
                                <td style="width: 30%; padding-left: 10px">
                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDischargeReferrals_Program" name="DropDownList_CustomDischargeReferrals_Program"
                                        runat="server" Width="200px" AddBlankRow="true" parentchildcontrols="True" BlankRowText="">
                                    </cc2:DropDownGlobalCodes>
                                </td>
                                <td>
                                    <input class="parentchildbutton" type="button" id="TableChildControl_CustomDischargeReferrals_ButtonInsert"
                                        name="TableChildControl_CustomDischargeReferrals_ButtonInsert" onclick="InsertReferral('TableChildControl_CustomDischargeReferrals','InsertGridCustomDischargeReferrals','CustomGrid',this);"
                                        baseurl="<%=ResolveUrl("~") %>" value="Insert" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height3">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5">
                                    <table cellspacing="0" cellpadding="0" border="0" width="80%">
                                        <tr>
                                            <td>
                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                             Discharge Referral
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
                                            <td class="content_tab_bg" colspan="3">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 9px;
                                                    padding-right: 9px">
                                                    <tr>
                                                        <td>
                                                            <div id="InsertGridCustomDischargeReferrals" runat="server" style="width: 70%; overflow: auto;
                                                                height: 95px; padding-right: 3px">
                                                                <uc1:CustomGrid ID="CustomGrid" width="70%" runat="server" TableName="CustomDischargeReferrals"
                                                                    PrimaryKey="DischargeReferralId" CustomGridTableName="TableChildControl_CustomDischargeReferrals"
                                                                    ColumnName="ReferralText:ProgramText" ColumnFormat=":" ColumnHeader="Discharge Referral:Program"
                                                                    ColumnWidth="40%:40%" GridPageName="CustomDischargeReferrals" DivGridName="InsertGridCustomDischargeReferrals"
                                                                    InsertButtonId="TableChildControl_CustomDischargeReferrals_ButtonInsert" />
                                                            </div>
                                                            <input type="hidden" id="HiddenField_CustomDischargeReferrals_DischargeReferralId"
                                                                name="HiddenField_CustomDischargeReferrals_DischargeReferralId" parentchildcontrols="True"
                                                                value="-1" />
                                                            <input type="hidden" id="HiddenField_CustomDischargeReferrals_DocumentVersionId"
                                                                name="HiddenField_CustomDischargeReferrals_DocumentVersionId" parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="DischargeReferralId" />
                                                            <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                        </td>
                                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                                            width="2">
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
