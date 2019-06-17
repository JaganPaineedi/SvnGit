<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMRiskAssessment.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMRiskAssessment" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>

<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" width="30%">Suicidality / Other Risk to Self
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
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr class="checkbox_container">
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SuicideCurrent" name="CheckBox_CustomHRMAssessments_SuicideCurrent" onclick="ShowCurrentSuicidalityList();" />
                                                    <label id="Label_CustomHRMAssessments_SuicideCurrent" for="CheckBox_CustomHRMAssessments_SuicideCurrent">Current Suicidality / Risk to Self</label>

                                                </td>
                                                <td width="8px">&nbsp;</td>
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SuicidePriorAttempt" name="CheckBox_CustomHRMAssessments_SuicidePriorAttempt" onclick="ShowCurrentSuicidalityList();" />
                                                    <label id="Label_CustomHRMAssessments_SuicidePriorAttempt" for="CheckBox_CustomHRMAssessments_SuicidePriorAttempt">Previous Attempts / History</label>
                                                </td>
                                                <td width="8px">&nbsp;</td>
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SuicideNotPresent" name="CheckBox_CustomHRMAssessments_SuicideNotPresent" />
                                                    <label id="Label_CustomHRMAssessments_SuicideNotPresent" for="CheckBox_CustomHRMAssessments_SuicideNotPresent">No Current or Previous History of Suicidality / Other Risk to Self</label>
                                                </td>
                                            </tr>

                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table id="TableSuicidality" border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <%--<tr>
                                                <td class="padding_label1">
                                                    <div id="DivCurrentSuicidality">
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr class="RadioText">
                                                                <td>
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild_A"
                                                                        name="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild" value="A" onclick="ShowOrHideAdultLTOrChildLTTab('A')" />
                                                                    <label for="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild_A">CSSRS Lifetime - Adult</label>
                                                                </td>
                                                                <td>&nbsp;&nbsp;
                                                                </td>
                                                                <td>
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild_C"
                                                                        name="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild" value="C" onclick="ShowOrHideAdultLTOrChildLTTab('C')" />
                                                                    <label for="RadioButton_CustomHRMAssessments_CSSRSAdultOrChild_C">CSSRS Lifetime - Child</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">&nbsp;
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td class="padding_label1">
                                                    <span class="form_label">Details (list current and previous behaviors, dates, method and lethality)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory"
                                                        name="TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory" rows="5" spellcheck="True"
                                                        cols="155"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr class="checkbox_container">
                                                <td class="padding_label1">
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SuicideNeedsList"
                                                        name="CheckBox_CustomHRMAssessments_SuicideNeedsList" />
                                                    <label for="CheckBox_CustomHRMAssessments_SuicideNeedsList">
                                                        Add Suicidality/ Other Risk to Self to Needs List</label>
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
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" width="50%">Physical / Sexual Aggression / Other Risk Factors
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
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr class="checkbox_container">
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_HomicideCurrent" name="CheckBox_CustomHRMAssessments_HomicideCurrent" />
                                                    <label for="CheckBox_CustomHRMAssessments_HomicideCurrent">Current Physical Agression / Sexual Agression / Risk to Others</label>
                                                </td>
                                                <td width="8px">&nbsp;</td>
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_HomicidePriorAttempt" name="CheckBox_CustomHRMAssessments_HomicidePriorAttempt" />
                                                    <label for="CheckBox_CustomHRMAssessments_HomicidePriorAttempt">Prior Physical / Sexual Aggression / Risk to Others </label>
                                                </td>
                                                <td width="8px">&nbsp;</td>
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_HomicideMeans" name="CheckBox_CustomHRMAssessments_HomicideMeans" />
                                                    <label for="CheckBox_CustomHRMAssessments_HomicideMeans">Homicidal </label>
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
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_HomicideNotPresent" name="CheckBox_CustomHRMAssessments_HomicideNotPresent" onclick="DisabledHomicidality();" />
                                                    <label id="Label_CustomHRMAssessments_HomicideNotPresent" for="CheckBox_CustomHRMAssessments_HomicideNotPresent">No Current or Previous History of Physical Agression / Sexual Agression / Risk to Others</label>


                                                </td>
                                            </tr>

                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table id="TableHomicidality" border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <span class="form_label">Details (list current and previous behaviors, dates, method and lethality)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="7" class="height1">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory"
                                                                    name="TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory" rows="5" spellcheck="True"
                                                                    cols="155"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="7" class="height1">&nbsp;
                                                            </td>


                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td class="padding_label1">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_HomicideNeedsList" name="CheckBox_CustomHRMAssessments_HomicideNeedsList" />
                                                                <label for="CheckBox_CustomHRMAssessments_HomicideNeedsList">Add Physical Aggression / Sexual Aggression / Risk to Others to Needs List</label>
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
                <table id="TableOtherRiskFactors" border="0" cellpadding="0" cellspacing="0" width="99%" group="OtherRiskFactors">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" width="50%">Other Risk Factors <span id="Group_OtherRiskFactors"></span>
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
                                        <table cellpadding="0" cellspacing="0" border="0" width="45%">
                                            <tr class="checkbox_container">
                                                <td>
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_RiskOtherFactorsNone" name="CheckBox_CustomHRMAssessments_RiskOtherFactorsNone" />
                                                    <label for="CheckBox_CustomHRMAssessments_RiskOtherFactorsNone">No Known Other Risk Factors </label>

                                                </td>
                                                <td width="8px">&nbsp;</td>
                                                <td>

                                                    <table cellspacing="0" cellpadding="0" border="0" width="120px">
                                                        <tr>
                                                            <td>
                                                                <input type="button" class="more_detail_btn_120" value="Risk Factor Lookup..." id="buttonRiskFactorLookup" name="buttonRiskFactorLookup"
                                                                    onclick="OpenOtherRiskFactorsLookupPopUp(<%=RelativePath%>);return false;" />
                                                                <%-- <span valign="top" type="button" style="width: 120px;" id="buttonRiskFactorLookup" onclick="OpenOtherRiskFactorsLookupPopUp('<%=RelativePath%>');return false;" 
                                                                                name="buttonRiskFactorLookup" text="Risk Factor Lookup">
                                                                            </span>--%>
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                    </table>

                                                </td>
                                            </tr>

                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="350px" id="TableChildControl_CustomOtherRiskFactorsLookup"
                                            clearcontrol="false" parentchildcontrols="True">
                                            <tr>
                                                <td align="left">
                                                    <div id="InsertGridOtherRiskFactorsLookup" runat="server" style="width: 98%; padding-left: 6px; padding-right: 2px; overflow-x: hidden; overflow-y: auto; height: 100px">
                                                        <uc1:CustomGrid ID="CustomGridOtherRiskFactorsLookup" runat="server" TableName="CustomOtherRiskFactors"
                                                            PrimaryKey="OtherRiskFactorId" CustomGridTableName="TableChildControl_CustomOtherRiskFactorsLookup"
                                                            ColumnWidth="250" ColumnName="CodeName" ColumnHeader="Risk Factor Lookup" DivGridName="InsertGridOtherRiskFactorsLookup"
                                                            GridPageName="OtherRiskFactors" DoNotDisplayRadio="True" DoNotDisplayDeleteImage="False" InsertButtonId="buttonRiskFactorLookup" />
                                                    </div>
                                                    <input type="hidden" id="HiddenField_CustomOtherRiskFactors_DocumentVersionId"
                                                        name="HiddenField_CustomOtherRiskFactors_DocumentVersionId" value="-1"
                                                        parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomOtherRiskFactors_OtherRiskFactorId"
                                                        name="HiddenField_CustomOtherRiskFactors_OtherRiskFactorId"
                                                        value="0" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="OtherRiskFactorId" />
                                                    <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="OtherRiskFactor" />
                                                    <input id="ButtonInsert" type="submit" style="display: none" value="Insert" />
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>

                                <tr>
                                    <td class="padding_label1">
                                        <span class="form_label">Describe Risk Factors</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="padding_label1">
                                        <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_RiskOtherFactors"
                                            name="TextArea_CustomHRMAssessments_RiskOtherFactors" rows="5" spellcheck="True"
                                            cols="155"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7" class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td class="padding_label1" id="OtherRiskFactorsNeedList" notgroup="OtherRiskFactors">
                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_RiskOtherFactorsNeedsList" name="CheckBox_CustomHRMAssessments_RiskOtherFactorsNeedsList" />
                                        <label for="CheckBox_CustomHRMAssessments_RiskOtherFactorsNeedsList">Add Other Risk Factors to Needs List</label>
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
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td style="width: 49%">
                            <table id="TablePsychiatricAdvanceDirective" border="0" cellpadding="0" cellspacing="0"
                                width="100%" group="PsychiatricAdvanceDirective">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" width="25%">Advance Directive<span id="Group_PsychiatricAdvanceDirective"></span>
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
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td width="55%">
                                                                <span class="form_label">Does client have mental health advance directive? </span>
                                                            </td>
                                                            <td width="6%">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective_Y"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="42%">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective_N"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveClientHasDirective_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td width="55%">
                                                                <span class="form_label">Does client desire a mental health advance directive plan? </span>
                                                            </td>
                                                            <td width="6%">
                                                                <input type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired_Y"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="42%">
                                                                <input type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired_N"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveDesired_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td width="55%">
                                                                <span class="form_label">Would client like more information about mental health advance directive planning? </span>
                                                            </td>
                                                            <td width="6%">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo_Y"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="42%">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo_N"
                                                                    name="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_AdvanceDirectiveMoreInfo_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>

                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <span class="form_label">What information was client given regarding mental health advance directive? </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" class="height1">&nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_AdvanceDirectiveNarrative"
                                                        name="TextArea_CustomHRMAssessments_AdvanceDirectiveNarrative" rows="5" spellcheck="True"
                                                        cols="155"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr class="checkbox_container">
                                                <td class="padding_label1" id="PsychiatricAdvanceDirectiveNeedList" notgroup="PsychiatricAdvanceDirective">
                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_AdvanceDirectiveNeedsList"
                                                        name="CheckBox_CustomHRMAssessments_AdvanceDirectiveNeedsList" />
                                                    <label for="CheckBox_CustomHRMAssessments_AdvanceDirectiveNeedsList">
                                                        Add Advance Directive to Needs List
                                                    </label>
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
</div>
