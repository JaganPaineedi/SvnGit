<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GamblingGeneral.ascx.cs"
    Inherits="GamblingGeneral" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
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
                                        Demographics
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
                                                <td style="width: 100%" class="style2" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 26%">
                                                                <span class="form_label" id="Span8" style="width: 50px;">Date</span>
                                                                <input type="text" id="TextBox_CustomDocumentGambling_GamblingDate" name="TextBox_CustomDocumentGambling_GamblingDate"
                                                                    class="date_text" datatype="Date" />
                                                                <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomDocumentGambling_GamblingDate', '%m/%d/%Y');"
                                                                    alt="" />
                                                            </td>
                                                            <td align="left" style="width: 26%">
                                                                <span class="form_label" id="Span_CustomDocumentGambling_MaritalStatus"></span>
                                                            </td>
                                                            <td width="38%" align="left">
                                                                <span class="form_label" id="Span_CustomDocumentGambling_EmploymentStatus"></span>
                                                            </td>
                                                            <td width="6%" align="left">
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
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="36%" align="left">
                                                                <span class="form_label" id="Span9">Estimated total monthly household income before
                                                                    taxes</span>
                                                            </td>
                                                            <td width="16%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_TotalMonthlyHousehold" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_TotalMonthlyHousehold" style="width: 112px;"
                                                                    type="text" maxlength="8" datatype="Currency" />
                                                            </td>
                                                            <td width="38%" align="left">
                                                                <span class="form_label" id="Span13">Total number of dependents living with you including
                                                                    yourself</span>
                                                            </td>
                                                            <td width="6%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_TotalNumberOfDependents" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_TotalNumberOfDependents" style="width: 40px;"
                                                                    type="text" maxlength="4" datatype="Numeric" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="36%" align="left">
                                                                <span class="form_label" id="Span14">Health Insurance</span>
                                                            </td>
                                                            <td width="16%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_HealthInsurance"
                                                                    Width="120px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="38%" align="left">
                                                                <span class="form_label" id="Span16">Last grade completed</span>
                                                            </td>
                                                            <td width="6%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_LastGradeCompleted" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_LastGradeCompleted" style="width: 40px;" type="text"
                                                                    maxlength="500" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="36%" align="left">
                                                                <span class="form_label" id="Span17">Primary source of household income</span>
                                                            </td>
                                                            <td width="16%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_PrimarySourceOfIncome"
                                                                    Width="120px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="38%" align="left">
                                                                <span class="form_label" id="Span18">Total estimated debt related to gambling</span>
                                                            </td>
                                                            <td width="6%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_TotalEstimatedGamblingDebt" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_TotalEstimatedGamblingDebt" style="width: 40px;"
                                                                    type="text" maxlength="8" datatype="Currency" />
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
                                        Satisfaction
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
                                                            <td style="width: 72%">
                                                                <span class="form_label" id="Span30">In the past 6 months, how frequently were you satisfied
                                                                    with each of the following. Use the scale to score your responses </span>
                                                            </td>
                                                            <td>
                                                            <td class="form_label">
                                                                <img width="12" height="12" style="cursor: pointer; padding-left: 1px" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                                    height="7" title="Tool Tip: 1. Never; 2. Rarely; 3. Sometimes; 4. Often; 5. Always; 6. Don’t know/doesn’t apply" />
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
                                                <td style="width: 100%" class="style2" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr class="checkbox_container">
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span1">Life in general.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_LifeInGeneral" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span25">Relationship with my friends.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_RelationshipWithFriends"
                                                                    Width="140px" runat="server" EnableViewState="false" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
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
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span2">Overall physical health.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_OverallPhysicalHealth"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span3">Relationship with other family members. </span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_RelationshipWithOtherFamilyMembers"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span4">Overall emotional wellbeing.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_OverallEmotionalWellbeing"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span5">Job.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_Job" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span6">Relationship with my spouse or significant other.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_RelationshipWithSpouse"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span7">School.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_School" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span10">Relationship with my children.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_RelationshipWithChildren"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span11">Spiritual wellbeing.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_SpiritualWellbeing"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
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
                                        Activities
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
                                                            <td style="width: 72%" align="left">
                                                                <span class="form_label" id="Span26">In the past 6 months, how frequently were you satisfied
                                                                    with each of the following. Use the scale to score your responses </span>
                                                            </td>
                                                            <td>
                                                            <td class="form_label">
                                                                <img width="12" height="12" style="cursor: pointer; padding-left: 1px" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                                    height="7" title="Tool Tip: 1. Never; 2. Rarely; 3. Sometimes; 4. Often; 5. Always; 6. Don’t know/doesn’t apply" />
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
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span19">Accomplish responsibilities at work. </span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtWork"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="32%" align="left">
                                                                <span class="form_label" id="Span20">Have problems associated with my use of illegal
                                                                    drugs.</span>
                                                            </td>
                                                            <td width="17%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_ProblemsAssociatedWithIllegalDrugs"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span12">Pay bills on time.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_PaidBillsOnTime"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span15">Use tobacco – smoked or chewed.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_UseOfTobacco" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span21">Accomplish responsibilities at home.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtHome"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span22">Commit illegal acts to get money to gamble with.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_CommitIllegalActs"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span23">Have thoughts of suicide.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_HaveThoughtsOfSuicide"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span24">Maintain a supportive network of family and/or
                                                                    friends.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_MaintainSupportiveNetworkOfFamily"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span27">Attempt to commit suicide.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_AttemptToCommitSuicide"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span28">Take time off to relax and rest.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_TakeTimeToRelax"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span29">Drink alcohol.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_DrinkAlcohol" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span31">Eat healthy foods.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_EatHealthyFood"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span32">Have problems associated with my use of alcohol.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_ProblemsAssociatedWithAlcohol"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span35">Exercise.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_Exercise" Width="140px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span36">Use illegal drugs.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_UseOfIllegalDrugs"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span37">Attend community support (GA, NA, AA, etc.).</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_AttendCommunitySupport"
                                                                    Width="140px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
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
    </table>
</div>
