<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMSummary.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMSummary" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<div style="overflow-x: hidden;">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>

                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td width="49%" style="vertical-align: top;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Treatment
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td style="width: 60%">
                                                                <span id="FundedServicesSpanText" class="form_label">Does client meet criteria for services?</span>
                                                            </td>
                                                            <td style="width: 10%" class="RadioText">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_Y"
                                                                    name="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment" value="Y" onclick="DisableTreatmentSection()" />
                                                                <label for="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 1%"></td>
                                                            <td class="RadioText">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_N"
                                                                    name="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment" value="N" onclick="EnableTreatmentSection()" />
                                                                <label for="RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table id="TableClientTreatment" border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr class="RadioText">
                                                                        <td style="width: 60%">
                                                                            <span class="form_label">If client does not meet criteria, was </span>
                                                                        </td>
                                                                        <td style="width: 10%" class="RadioText">
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_Y"
                                                                                name="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided" value="Y" />
                                                                            <%--onclick="EnableSummaryTreatmentComment();"/>--%>
                                                                            <label for="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td style="width: 1%"></td>
                                                                        <td class="RadioText">
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_N"
                                                                                name="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided" value="N" />
                                                                            <%--onclick="DisableSummaryTreatmentComment();"/>--%>
                                                                            <label for="RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_N">
                                                                                No</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 60%">
                                                                            <span class="form_label">referral or other options offered?</span>
                                                                        </td>
                                                                        <td style="width: 10%"></td>
                                                                        <td></td>
                                                                        <td></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="form_label">Discuss treatment focus and client preferences.</span>
                                                                <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_TreatmentNarrative"
                                                                    name="TextArea_CustomHRMAssessments_TreatmentNarrative" rows="10" spellcheck="True"
                                                                    cols="73"></textarea>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                        <td width="2%"></td>
                        <td width="49%" style="vertical-align: top;">
                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                    Referrals
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr >
                                            <td style="width: 32%">
                                                <span class="form_label">Outside referrals given?</span>
                                            </td>
                                            <td style="width: 10%" class="RadioText">
                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_OutsideReferralsGiven_Y"
                                                    name="RadioButton_CustomHRMAssessments_OutsideReferralsGiven" value="Y" />
                                                <label for="RadioButton_CustomHRMAssessments_OutsideReferralsGiven_Y">
                                                    Yes</label>
                                            </td>
                                            <td style="width: 1%">
                                            </td>
                                            <td class="RadioText">
                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_OutsideReferralsGiven_N"
                                                    name="RadioButton_CustomHRMAssessments_OutsideReferralsGiven" value="N" />
                                                <label for="RadioButton_CustomHRMAssessments_OutsideReferralsGiven_N">
                                                    No</label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_ReferralsNarrative"
                                        name="TextArea_CustomHRMAssessments_ReferralsNarrative" rows="8" spellcheck="True"
                                        cols="72"></textarea>
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
            </table>--%>
                            <table width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap="nowrap">Accommodations
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">Indicate any accommodations client requires for treatment</span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_TreatmentAccomodation"
                                                                    name="TextArea_CustomHRMAssessments_TreatmentAccomodation" rows="3" spellcheck="True"
                                                                    cols="73"></textarea>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" width="40%">Level of Care
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr class="RadioText">
                                                                        <td class="padding_label1">
                                                                            <span class="form_label">Client level of care as determined by this assessment.</span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr>

                                                            <td class="padding_label1">
                                                                <span class="form_label">Level of Care</span>&nbsp;&nbsp;
&nbsp;                                   
                                                                <input class="LPadd8 form_textbox" style="width: 65%" type="text" disabled="disabled" id="TextBox_CustomHRMAssessments_LevelOfCare" />
                                                            </td>

                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <span style='cursor: pointer; text-decoration: underline; color: Blue; font-size: 11px; font-weight: bold; width: 58%' onclick="ShowLevelofCareDiv('DeterminationDescription')">How is level of care determined?</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <span style='cursor: pointer; text-decoration: underline; color: Blue; font-size: 11px; font-weight: bold; width: 58%' onclick="ShowLevelofCareDiv('Description')">Level of Care Description</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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

                        </td>
                    </tr>
                    <tr>
                        <td width="49%">
                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                    Accommodations
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr>
                                            <td>
                                                <span class="form_label">Indicate any accommodations client requires for treatment</span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_TreatmentAccomodation"
                                        name="TextArea_CustomHRMAssessments_TreatmentAccomodation" rows="9" spellcheck="True"
                                        cols="72" ></textarea>
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
            </table>--%>
                        </td>
                        <td width="2%"></td>
                        <td width="49%">
                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" width="50%">
                                    Recommended Services
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr>
                                            <td style="width: 75%">
                                                <span class="form_label">List services recommended for identified </span>
                                            </td>
                                            
                                            <td width="15%">                                                
                                                <table cellspacing="0" cellpadding="0" border="0" >
                                                    <tr>
                                                        <td >                                                            
                                                                 <span valign="top" type="button" style="width: 100px;"  id="buttonServiceLookup" onclick="OpenServiceLookupPopUp('<%=RelativePath%>');"
                                                                                name="buttonServiceLookup" text="Service Lookup">
                                                                            </span>
                                                        </td>
                                                        <td >
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 75%">
                                                <span class="form_label"> treatment needs</span>
                                            </td>
                                            
                                            <td width="15%">                                                
                                                
                                            </td>
                                            <td width="10%">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td >
                                    <table cellspacing="0" cellpadding="0" border="0" width="300" id="TableChildControl_CustomHRMAssessmentLevelOfCareOptions"
                                        parentchildcontrols="True">
                                        <tr>
                                            <td align="left">
                                                <div id="InsertGridServiceLookup" runat="server" style="width: 98%; padding-left: 6px;
                                                    padding-right: 2px; overflow-x: hidden; overflow-y: auto; height: 100px">
                                                    <uc1:CustomGrid ID="CustomGridServiceLookup" runat="server" TableName="CustomHRMAssessmentLevelOfCareOptions"
                                                        PrimaryKey="HRMAssessmentLevelOfCareOptionId" CustomGridTableName="TableChildControl_CustomHRMAssessmentLevelOfCareOptions"
                                                        ColumnWidth="250" ColumnName="ServiceChoiceLabel" ColumnHeader="Service Lookup" DivGridName="InsertGridServiceLookup"
                                                        GridPageName="ServiceLookup" DoNotDisplayRadio="True" DoNotDisplayDeleteImage="False" InsertButtonId="buttonServiceLookup" />
                                                </div>
                                                <input type="hidden" id="HiddenField_CustomHRMAssessmentLevelOfCareOptions_DocumentVersionId"
                                                    name="HiddenField_CustomHRMAssessmentLevelOfCareOptions_DocumentVersionId" value="-1"
                                                    parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomHRMAssessmentLevelOfCareOptions_HRMAssessmentLevelOfCareOptionId"
                                                    name="HiddenField_CustomHRMAssessmentLevelOfCareOptions_HRMAssessmentLevelOfCareOptionId"
                                                    value="0" parentchildcontrols="True" />                                                
                                                <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="HRMAssessmentLevelOfCareOptionId" />
                                                <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="HRMLevelOfCareOptionId" />
                                                <input id="ButtonInsert" type="submit" style="display: none" value="Insert" />
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
            </table>--%>
                        </td>
                    </tr>


                    <tr>
                        <td width="49%" align="top">
                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" width="60%">
                                    Additional Information
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
                                <td>
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr class="RadioText">
                                            <td class="padding_label1">
                                                <span class="form_label">Any additional information not already covered in this assessment.</span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_AssessmentAddtionalInformation" name="TextArea_CustomHRMAssessments_AssessmentAddtionalInformation"
                                        rows="8" spellcheck="True" cols="72"></textarea>
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
            </table>--%>
                        </td>
                        <td width="2%"></td>
                        <td width="49%">
                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" width="40%">
                                    Level of Care
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
                                <td>
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr class="RadioText">
                                            <td class="padding_label1">
                                                <span class="form_label">Client level of care as determined by this assessment.</span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                            
                                <td class="padding_label1">
                                    <span  class="form_label">Level of Care</span>&nbsp;&nbsp;
&nbsp;                                    <input class="LPadd8 form_textbox"  style="width: 65%" type="text" disabled="disabled" id="TextBox_CustomHRMAssessments_LevelOfCare" />
                                </td>
                                
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr>
                            <td class="padding_label1">
                            <span style='cursor: pointer; text-decoration: underline;color:Blue;font-size:11px;font-weight:bold; width:58%' onclick="ShowLevelofCareDiv('DeterminationDescription')">How is level of care determined?</span>
                            </td>
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                             <tr>
                            <td class="padding_label1">
                             <span style='cursor: pointer; text-decoration: underline;color:Blue;font-size:11px;font-weight:bold; width:58%' onclick="ShowLevelofCareDiv('Description')">Level of Care Description</span>
                            </td>
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                             <tr class="height2">
                                <td>
                                </td>
                            </tr>
                            <tr class="height2">
                                <td>
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
            </table>--%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Strengths
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                                    <span class="form_label">Strengths</span>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_Strengths"
                                                        name="TextArea_CustomHRMAssessments_Strengths" rows="6" spellcheck="True"
                                                        cols="155"></textarea>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                        <td colspan="3">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Clinical Interpretive Summary
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
                                                <td class="content_tab_top" width="100%" style="padding-bottom: 6px;">
                                                    <span id="GoToOnlineCafas" onclick="GotoGetASAM();" type="button" text="Initialize Most Recent ASAM Final Determination"></span>
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
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td>
                                                                <span class="form_label">Integrate and interpret from a broader perspective all history
                                                    and assessment information. Identify any co-occurring disabilities or disorders.
                                                    Identify needs</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td>
                                                                <span class="form_label">beyond the scope of the program and specify referrals for additional
                                                    services. Include symptoms that justify the diagnosis and strengths that could contribute</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td>
                                                                <span class="form_label">to stated outcomes. Include important biographical facts or events in the person’s life.</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_ClinicalSummary"
                                                        name="TextArea_CustomHRMAssessments_ClinicalSummary" rows="8" spellcheck="True"
                                                        cols="155"></textarea>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                        <td colspan="3">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Transition/Level of Care/Discharge Plan
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                                    <span class="form_label">Level of Care (recommendation and justification)*</span>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_TransitionLevelOfCare"
                                                        name="TextArea_CustomHRMAssessments_TransitionLevelOfCare" rows="6" spellcheck="True"
                                                        cols="155"></textarea>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <span class="form_label">Transition/Level of Care/Discharge Plan*</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <span class="form_label">Criteria –</span>
                                                    <span class="form_label" style="font-style: italic">How will the staff/client/parent/guardian know that a change in level of care is indicated?</span>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="checkbox_container" style="padding-left: 8px;">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_ReductionInSymptoms"
                                                        name="CheckBox_CustomHRMAssessments_ReductionInSymptoms" class="form_checkbox element"
                                                        onclick="EnableDisableTextArea(this, AutoSaveXMLDom);" />
                                                    <label for="CheckBox_DocumentCarePlans_ReductionInSymptoms" id="label_ReductionInSymptoms">
                                                        Reduction in symptoms as evidenced by:</label>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 8px;">
                                                    <textarea id="TextArea_CustomHRMAssessments_ReductionInSymptomsDescription" name="TextArea_CustomDocumentCarePlans_ReductionInSymptomsDescription"
                                                        cols="155" class="form_textareaWithoutWidth" spellcheck="true" rows="4"></textarea>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="checkbox_container" style="padding-left: 8px;">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_AttainmentOfHigherFunctioning"
                                                        name="CheckBox_CustomHRMAssessments_AttainmentOfHigherFunctioning" class="form_checkbox element"
                                                        onclick="EnableDisableTextArea(this, AutoSaveXMLDom);" />
                                                    <label for="CheckBox_CustomHRMAssessments_AttainmentOfHigherFunctioning" id="label_AttainmentOfHigherFunctioning">
                                                        Attainment of higher level of functioning as evidenced by:</label>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 8px;">
                                                    <textarea id="TextArea_CustomHRMAssessments_AttainmentOfHigherFunctioningDescription" name="TextArea_CustomHRMAssessments_AttainmentOfHigherFunctioningDescription"
                                                        cols="155" class="form_textareaWithoutWidth" spellcheck="true" rows="4"></textarea>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="checkbox_container" style="padding-left: 8px;">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_TreatmentNotNecessary"
                                                        name="CheckBox_CustomHRMAssessments_TreatmentNotNecessary" class="form_checkbox element"
                                                        onclick="EnableDisableTextArea(this, AutoSaveXMLDom);" />
                                                    <label for="CheckBox_CustomHRMAssessments_TreatmentNotNecessary" id="label_TreatmentNotNecessary">
                                                        Treatment is no longer medically necessary as evidenced by:</label>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 8px;">
                                                    <textarea id="TextArea_CustomHRMAssessments_TreatmentNotNecessaryDescription" name="TextArea_CustomHRMAssessments_TreatmentNotNecessaryDescription"
                                                        cols="155" class="form_textareaWithoutWidth" spellcheck="true" rows="4"></textarea>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="checkbox_container" style="padding-left: 8px;">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_OtherTransitionCriteria"
                                                        name="CheckBox_CustomHRMAssessments_OtherTransitionCriteria" class="form_checkbox element"
                                                        onclick="EnableDisableTextArea(this, AutoSaveXMLDom);" />
                                                    <label for="CheckBox_CustomHRMAssessments_OtherTransitionCriteria" id="label_OtherTransitionCriteria">
                                                        Other:</label>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 8px;" class="height2">
                                                    <textarea id="TextArea_CustomHRMAssessments_OtherTransitionCriteriaDescription" name="TextArea_CustomHRMAssessments_OtherTransitionCriteriaDescription"
                                                        cols="155" class="form_textareaWithoutWidth" spellcheck="true" rows="4"></textarea>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <label for="TextBox_CustomHRMAssessments_EstimatedDischargeDate" id="TextBox_CustomHRMAssessments_EstimatedDischargeDatelabel">
                                                        Estimated Discharge Date*
                                                    </label>
                                                    <input type="text" id="TextBox_CustomHRMAssessments_EstimatedDischargeDate" name="TextBox_CustomHRMAssessments_EstimatedDischargeDate"
                                                        datatype="Date" class="date_text" align="top" />

                                                    <img style="cursor: default" id="imgCurrentAssessmentDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomHRMAssessments_EstimatedDischargeDate', '%m/%d/%Y');"
                                                        alt="" class="cursor_default" />
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
            </td>
        </tr>
    </table>
    <div id="divLevelofCarePopUp" style="display: none; z-index: 1000; position: relative; background-color: White; border: 1">
        <table cellpadding="0" cellspacing="0" width="350px" height="100px" border="0">
            <tr>
                <td valign="top" height="5px">
                    <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="350px">
                        <tr>
                            <td id="topborder" align="center" class="TitleBarText LPadd5">Level of Care
                            </td>
                            <td align="left" width="10px">
                                <a href="#">
                                    <img id="ImgCross" src=" <%=RelativePath%>App_Themes/Includes/Images/cross.jpg" title="Close"
                                        onclick="CloseLevelofCareDiv()" alt="Close" />
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="width: 100%">
                <td valign="top" class="form_label" align="left" class="LPadd5">
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td style="height: 30px;">
                                <span id="SpnDescprition"></span>
                            </td>
                        </tr>

                    </table>
                </td>
            </tr>
        </table>
    </div>
    <input type="hidden" id="HiddenField_CustomHRMAssessments_DeterminationDescription" />
    <input type="hidden" id="HiddenField_CustomHRMAssessments_Description" />
    <input type="hidden" id="HiddenField_CustomHRMAssessments_ADTCriteria" />
    <input type="hidden" id="HiddenField_CustomHRMAssessments_ProviderQualifications" />
</div>
