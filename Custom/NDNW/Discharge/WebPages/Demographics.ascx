<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Demographics.ascx.cs"
    Inherits="Custom_Discharge_WebPages_Demographics" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/Discharge/Scripts/ClientDemographics.js"></script>

<div class="DocumentScreen">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 98.5%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span_CustomDocumentDischarges">Demographics Update</span>
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                    </td>
                                    <td class="content_tab_top" width="100%" />
                                    <td width="7">
                                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_EducationLevel">Education Level</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_EducationLevel"
                                            Style="width: 90%;" runat="server" Category="XCDEDUCATIONALLEVEL" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_MaritalStatus">Marital Status</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_MaritalStatus"
                                            Style="width: 90%;" runat="server" Category="MARITALSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_EducationStatus">Education Status</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_EducationStatus"
                                            Style="width: 90%;" runat="server" Category="EDUCATIONALSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_EmploymentStatus">Employment Status</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_EmploymentStatus"
                                            Style="width: 90%;" runat="server" Category="EMPLOYMENTSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_ForensicCourtOrderedTreatment">Forensic Court Ordered Treatment</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_ForensicCourtOrdered"
                                            Style="width: 90%;" runat="server" Category="XCDFORENSICTREATMENT" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_ServingMilitary">Have you ever or are you<br />
                                            currently serving in the military?</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_CurrentlyServingMilitary"
                                            Style="width: 90%;" runat="server" Category="RADIOYN" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_Legal">Legal</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_Legal"
                                            Style="width: 90%;" runat="server" Category="XCDLEGAL" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_JusticeSystemInvolvement">Justice System Involvement</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_JusticeSystem"
                                            Style="width: 90%;" runat="server" Category="XCDJUSTICEINVOLVEMEN" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_LivingArrangement">Living Arrangement</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_LivingArrangement"
                                            Style="width: 90%;" runat="server" Category="LIVINGARRANGEMENT" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_ArrestsLast30Days"># of Arrests Last 30 Days</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_Arrests" runat="server"
                                            name="TextBox_CustomDocumentDischarges_Arrests" maxlength="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_AdvanceDirective">Advance Directive</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_AdvanceDirective"
                                            Style="width: 90%;" runat="server" Category="XCDADVANCEDIRECTIVE" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_TobaccoUse">Tobacco Use</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_TobaccoUse"
                                            Style="width: 90%;" runat="server" Category="XCDTOBACCOUSE" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="left" style="width: 22%">
                                        <span id="Span_ClientHomeAddress">Client Home Address</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <span id="Span_Address" runat="server"></span><span id="Span_City" runat="server">
                                        </span><span id="Span_State" runat="server"></span><span id="Span_Zip" runat="server">
                                        </span>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        <span id="Span_AgeofFirstTobaccoUse">Age of First Tobacco Use</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_AgeOfFirstTobaccoUse" runat="server"
                                            name="TextBox_CustomDocumentDischarges_AgeOfFirstTobaccoUse" maxlength="3" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_CountyofResidence">County of Residence</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_CountyResidence"
                                            Style="width: 90%;" name="DropDownList_CustomDocumentDischarges_CountyResidence"
                                            runat="server" AddBlankRow="True" BlankRowText="" valuetype="">
                                        </cc3:StreamlineDropDowns>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        &nbsp;
                                    </td>
                                    <td align="left" style="width: 28%">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%">
                                        <span id="Span_CountyofFinancialResponsibility">County of Financial Responsibility</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                        <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility"
                                            Style="width: 90%;" name="DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility"
                                            runat="server" AddBlankRow="True" BlankRowText="" valuetype="">
                                        </cc3:StreamlineDropDowns>
                                    </td>
                                    <td align="left" style="width: 21%">
                                        &nbsp;
                                    </td>
                                    <td align="left" style="width: 29%">
                                        &nbsp;
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
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
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
                </table>
            </td>
        </tr>
    </table>
</div>
