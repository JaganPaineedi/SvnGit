<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InvoluntaryServices.ascx.cs"
    Inherits="InvoluntaryServices" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/InvoluntaryServices/Scripts/InvoluntaryServices.js"></script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div class="DocumentScreen">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Involuntary Services
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
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span12">SID Number</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <input name="TextBox_CustomDocumentInvoluntaryServices_SIDNumber" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentInvoluntaryServices_SIDNumber" style="width: 35%;"
                                                                    type="text" maxlength="34" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span9">Service Status</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_ServiceStatus"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInServiceStatus">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span13">Type of Petition/Notice of Mental Illness</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_TypeOfPetition"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XIntypeofpetition">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span14">Date of Petition/Notice of Mental Illness</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <input type="text" id="TextBox_CustomDocumentInvoluntaryServices_DateOfPetition"
                                                                    name="TextBox_CustomDocumentInvoluntaryServices_DateOfPetition" class="date_text"
                                                                    datatype="Date" />
                                                                <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomDocumentInvoluntaryServices_DateOfPetition', '%m/%d/%Y');"
                                                                    alt="" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span15">Hearing Recommended</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_HearingRecommended"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" AddBlankRow="true" BlankRowText=""
                                                                    Category="XInHearingRecommend">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span16">Reason for Hearing/Diversion Recommendation</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_ReasonForHearing"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInReasonforhearing">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span17">Basis for Involuntary Services</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_BasisForInvoluntaryServices"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInBasisforServices">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span18">Disposition by Judge</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_DispositionByJudge"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInDisposition">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span19">Committed?</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_InvoluntaryServicesCommitted"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInCommitted">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span4">Service Setting Assigned To</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentInvoluntaryServices_ServiceSettingAssignedTo"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    EnableViewState="false" AddBlankRow="true" BlankRowText="" Category="XInServiceSetting">
                                                                </cc1:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span20">Date of Commitment</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <input type="text" id="TextBox_CustomDocumentInvoluntaryServices_DateOfCommitment"
                                                                    name="TextBox_CustomDocumentInvoluntaryServices_DateOfCommitment" class="date_text"
                                                                    datatype="Date" />
                                                                <img id="img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomDocumentInvoluntaryServices_DateOfCommitment', '%m/%d/%Y');"
                                                                    alt="" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span1">Length of Commitment</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <input type="text" id="TextBox_CustomDocumentInvoluntaryServices_LengthOfCommitment"
                                                                    name="TextBox_CustomDocumentInvoluntaryServices_LengthOfCommitment" class="date_text"
                                                                    maxlength="8" datatype="Numeric" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="52%" align="left">
                                                                <span class="form_label" id="Span2">Last Date of 14-Day Period of Intensive Treatment
                                                                    or Diversion from Civil Commitment</span>
                                                            </td>
                                                            <td width="56%" align="left">
                                                                <input type="text" id="TextBox_CustomDocumentInvoluntaryServices_PeriodOfIntensiveTreatment"
                                                                    name="TextBox_CustomDocumentInvoluntaryServices_PeriodOfIntensiveTreatment" class="date_text"
                                                                    datatype="Date" />
                                                                <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomDocumentInvoluntaryServices_PeriodOfIntensiveTreatment', '%m/%d/%Y');"
                                                                    alt="" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
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
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
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
                <input id="HiddenField_CustomDocumentInvoluntaryServices_DocumentVersionId" name="HiddenField_CustomDocumentInvoluntaryServices_DocumentVersionId"
                    type="hidden" />
                <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentInvoluntaryServices" />
            </td>
        </tr>
    </table>
</div>
