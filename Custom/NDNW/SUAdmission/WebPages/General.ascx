<%@ Control Language="C#" AutoEventWireup="true" CodeFile="General.ascx.cs" Inherits="Custom_SUAdmission_WebPages_General" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
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
                                        Admission Information
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
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 60%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 45%">
                                                    Admission Entry Date
                                                </td>
                                                <td style="height: 18px">
                                                    <asp:Label ID="CurrentdatetimeText" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Assessment Date
                                                </td>
                                                <td>
                                                    <div id="divDate">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr class="date_Container">
                                                                <td>
                                                                    <input type="text" id="TextBox_CustomDocumentSUAdmissions_AssessmentDate" required="True"
                                                                        datatype="Date" style="height: 13px" tabindex="1" />
                                                                </td>
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    <img id="imgDynamicDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                        onclick="return showCalendar('TextBox_CustomDocumentSUAdmissions_AssessmentDate', '%m/%d/%Y');" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Admission Type
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_AdmissionType"
                                                        EnableViewState="false" AddBlankRow="true" Category="xAdminType" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="3">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Admission Program Type
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_AdmissionProgramType"
                                                        EnableViewState="false" AddBlankRow="true" Category="xAdminProgType" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="4">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Referral Type
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_ReferralSource"
                                                        EnableViewState="false" AddBlankRow="true" Category="REFERRALTYPE" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="5">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Expected Primary Source of Payment
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_SourceOfPayment"
                                                        EnableViewState="false" AddBlankRow="true" Category="xTEDIncomeSource" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="6">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Pregnant at Time of Admission?
                                                </td>
                                                <td>
                                                    <table border="0" style="width: 68%">
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_Y"
                                                                    value="Y" name="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission" style="cursor: default"
                                                                    tabindex="7" />
                                                            </td>
                                                            <td style="width: 7%; padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_Y" style="cursor: default">
                                                                    Yes</label>
                                                            </td>
                                                            <td align="left" style="width: 2%; padding-left: 3px">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_N"
                                                                    value="N" name="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission" style="cursor: default"
                                                                    tabindex="8" />
                                                            </td>
                                                            <td style="padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_N" style="cursor: default">
                                                                    No</label>
                                                            </td>
                                                            <td align="left" style="width: 2%; padding-left: 3px">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_A"
                                                                    value="A" name="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission" style="cursor: default"
                                                                    tabindex="9" />
                                                            </td>
                                                            <td style="padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUAdmissions_PregnantAdmission_A" style="cursor: default">
                                                                    Not Applicable</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <%--<tr>
                                                <td>
                                                    Prior Episode
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_PriorEpisode"
                                                        EnableViewState="false" AddBlankRow="true" Category="xPriorEpisode" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="10">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>--%>
                                            <%--<tr>
                                                <td class="height2">
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td>
                                                    Number of Self-Help Groups Attending in Past 30 Days Preceding Admission
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_SocialSupports"
                                                        EnableViewState="false" AddBlankRow="true" Category="xDaysSocialSupports" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="11">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 40%" valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 40%; height: 20px">
                                                    Program
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_ProgramId" EnableViewState="false"
                                                        AddBlankRow="true" Category="XPROGRAM" BlankRowText="" runat="server" Width="180px"
                                                        TabIndex="2">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px">
                                                    SSN
                                                </td>
                                                <td>
                                                    <span id="label_CustomDocumentSUAdmissions_SSN" name="label_CustomDocumentSUAdmissions_SSN"
                                                        class="form_label"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <%--<tr>
                                                <td>
                                                    SAMHIS ID
                                                </td>
                                                <td>
                                                    <span id="label_CustomDocumentSUAdmissions_SamhisId" name="label_CustomDocumentSUAdmissions_SamhisId"
                                                        class="form_label"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Title XX No.
                                                </td>
                                                <td>
                                                    <span id="label_CustomDocumentSUAdmissions_TitleXXNo" name="label_CustomDocumentSUAdmissions_TitleXXNo"
                                                        class="form_label"></span>
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Veteran Status
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_VeteransStatus"
                                                        EnableViewState="false" AddBlankRow="true" Category="FQHCVeteran" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="12">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Admitted Population
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation"
                                                        EnableViewState="false" AddBlankRow="true" Category="xAdmittedPopulation" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="13" onchange="ChangeAdmittedPopulation();">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Admitted ASAM
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_AdmittedASAM"
                                                        EnableViewState="false" AddBlankRow="true" Category="xAdmittedAsam" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="14">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Referred ASAM
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_ReferredASAM"
                                                        EnableViewState="false" AddBlankRow="true" Category="XINDICATEDLEVEL" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="15" Enabled="false">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    State Code
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_StateCode" EnableViewState="false"
                                                        AddBlankRow="true" Category="xStateCode" BlankRowText="" runat="server" Width="180px"
                                                        TabIndex="16">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Prior Episode
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_PriorEpisode"
                                                        EnableViewState="false" AddBlankRow="true" Category="xPriorEpisode" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="10">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
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
                </table>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
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
                                        Legal Information
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
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 60%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 45%">
                                                    Number of Arrests in Past 30 days
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUAdmissions_NumberOfArrests" style="width: 40px"
                                                        class="form_textareaWithoutWidth" maxlength="3" tabindex="17" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Number of Arrests in past 12 Months
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUAdmissions_NumberOfArrestsLast12Months"
                                                        style="width: 40px" class="form_textareaWithoutWidth" maxlength="3" tabindex="17" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Drug Court Participation
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_DrugCourtParticipation"
                                                        EnableViewState="false" AddBlankRow="true" Category="xSUDrugCourt" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="18">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <%-- <td>
                                                    DORA Status
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_DoraStatus"
                                                        EnableViewState="false" AddBlankRow="true" Category="xDORAStatus" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="19">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>--%>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 53%">
                                                    Currently on Probation
                                                </td>
                                                <td align="left" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_Y"
                                                        value="Y" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation"
                                                        style="cursor: default" tabindex="20" />
                                                </td>
                                                <td style="width: 7%; padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_Y" style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_N"
                                                        value="N" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation"
                                                        style="cursor: default" tabindex="21" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_N" style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_U"
                                                        value="U" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation"
                                                        style="cursor: default" tabindex="22" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnProbation_U" style="cursor: default">
                                                        Unknown</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Currently under DCFS Jurisdiction
                                                </td>
                                                <td align="left" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_Y" value="Y"
                                                        name="RadioButton_CustomDocumentSUAdmissions_Jurisdiction" style="cursor: default"
                                                        tabindex="23" />
                                                </td>
                                                <td style="width: 7%; padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_Y" style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_N" value="N"
                                                        name="RadioButton_CustomDocumentSUAdmissions_Jurisdiction" style="cursor: default"
                                                        tabindex="24" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_N" style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_U" value="U"
                                                        name="RadioButton_CustomDocumentSUAdmissions_Jurisdiction" style="cursor: default"
                                                        tabindex="25" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_Jurisdiction_U" style="cursor: default">
                                                        Unknown</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Currently on Parole
                                                </td>
                                                <td align="left" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_Y"
                                                        value="Y" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole" style="cursor: default"
                                                        tabindex="26" />
                                                </td>
                                                <td style="width: 7%; padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_Y" style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_N"
                                                        value="N" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole" style="cursor: default"
                                                        tabindex="27" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_N" style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left" style="width: 2%; padding-left: 3px">
                                                    <input type="radio" id="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_U"
                                                        value="U" name="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole" style="cursor: default"
                                                        tabindex="28" />
                                                </td>
                                                <td style="padding-left: 3px">
                                                    <label for="RadioButton_CustomDocumentSUAdmissions_CurrentlyOnParole_U" style="cursor: default">
                                                        Unknown</label>
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
                </table>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
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
                                        Household Information
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
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 10%">
                                        Household Composition
                                    </td>
                                    <td style="padding-left: 3px">
                                        <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_LivingArrangement"
                                            EnableViewState="false" AddBlankRow="true" Category="xSUHouseholdComp" BlankRowText=""
                                            runat="server" Width="150px" TabIndex="29">
                                        </cc2:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" width="70%">
                                            <tr>
                                                <td style="width: 20%">
                                                    # in Household
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUAdmissions_Household" style="width: 60px"
                                                        class="form_textareaWithoutWidth" maxlength="7" tabindex="30" />
                                                </td>
                                                <td>
                                                    # of Children 17 or Under
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUAdmissions_Children" style="width: 60px"
                                                        class="form_textareaWithoutWidth" maxlength="7" tabindex="31" />
                                                </td>
                                                <td>
                                                    Household Income
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUAdmissions_HouseholdIncome" style="width: 60px"
                                                        class="form_textareaWithoutWidth" datatype="Currency"  maxlength="7" tabindex="32" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
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
                </table>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
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
                                        Demographics Information Update
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
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 60%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 45%">
                                                    Marital Status
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_MaritalStatus"
                                                        EnableViewState="false" AddBlankRow="true" Category="MARITALSTATUS" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="33">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Employment Status
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_EmploymentStatus"
                                                        EnableViewState="false" AddBlankRow="true" Category="EMPLOYMENTSTATUS" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="34">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Primary Source of Income
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_PrimarySourceOfIncome"
                                                        EnableViewState="false" AddBlankRow="true" Category="XINQUIRYPSOURCE" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="35">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Education Status
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_EnrolledEducation"
                                                        EnableViewState="false" AddBlankRow="true" Category="xTEDSEnrolledEd" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="36">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    Education Completed
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_EducationCompleted"
                                                        EnableViewState="false" AddBlankRow="true" Category="xEducationCompleted" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="37">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Gender
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_Gender" EnableViewState="false"
                                                        AddBlankRow="true" Category="xTEDSGender" onchange="ChangeGender();" BlankRowText=""
                                                        runat="server" Width="180px" TabIndex="37">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trGenderOther" style="display: none">
                                                <td>
                                                    
                                                </td>
                                                <td>
                                                    <input type="text" id="TextBox_CustomDocumentSUAdmissions_GenderOther" style="width: 60px"
                                                        class="form_textareaWithoutWidth" maxlength="50" TabIndex="38"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Race
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_Race" EnableViewState="false"
                                                        AddBlankRow="true" Category="xTEDSRACE" BlankRowText="" runat="server" Width="180px"
                                                        TabIndex="38">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Ethnicity
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUAdmissions_Ethnicity" EnableViewState="false"
                                                        AddBlankRow="true" Category="xTEDSETHNICITY" BlankRowText="" runat="server" Width="180px"
                                                        TabIndex="39">
                                                    </cc2:DropDownGlobalCodes>
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
            <td class="height2">
            </td>
        </tr>
    </table>
</div>
