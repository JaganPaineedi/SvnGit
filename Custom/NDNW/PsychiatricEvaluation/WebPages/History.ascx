<%@ Control Language="C#" AutoEventWireup="true" CodeFile="History.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricEvaluation_WebPages_History" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes" TagPrefix="DropDownGlobalCodes" %>
<div>
    <%--<table id="table_problem_loading" border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td valign="middle" align="center" style="height: 100px">
                <span>Loading problem section, Please wait...</span><br />
                <img style="padding-top: 4px;" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/ajax-loader.gif">
            </td>
        </tr>
    </table>--%>
    <table id="table_history_problem" border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Identifying Information/Reason for Visit
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_IdentifyingInformationReasonforVisit">Identifying Information/Reason for Visit</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_IdentifyingInformation"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_IdentifyingInformation" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
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
                                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>History
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_FamilyHistory">Family History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_FamilyHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_FamilyHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_PastPsychiatricHistory">Past Psychiatric History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_PastPsychiatricHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_PastPsychiatricHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_DevelopmentalHistory">Developmental History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_DevelopmentalHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_DevelopmentalHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_SubstanceAbuseHistory">Substance Abuse History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_SubstanceAbuseHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_SubstanceAbuseHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_MedicalHistory">Medical History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_MedicalHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_MedicalHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_HistoryofPresentIllness">History of Present Illness</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_HistoryofPresentIllness"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_HistoryofPresentIllness" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_SocialHistory">Social History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_SocialHistory"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_SocialHistory" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
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
                                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <div id="divProblemTemplate" style="width: 100%; display: none">
                                <table id="table_s8s2s3s_Problem" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td class="content_tab_left" nowrap='nowrap'>
                                                        <img onclick="deleteProblem(s8s2s3s)" style="vertical-align: top; cursor: pointer" height="17" width="16" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />&nbsp;<span id="Span_s8s2s3s_ProblemTitle">Problem</span>&nbsp;<span section="spannumber" id="Span_s8s2s3s_ProblemNumber">1</span>
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
                                        <td class="content_tab_bg" style="padding-left: 10px">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td class="height2" style="width: 100%;"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <span>Problem</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1" style="width: 100%;"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <textarea id="TextArea_CustomPsychiatricEvaluationProblems_s8s2s3s_ProblemText" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems','ProblemText','text');" class="form_textarea" rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String" bindsetformdata="False" bindautosaveevents="False"></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td align="left" style="width: 10%;"><span>Severity</span></td>
                                                                <td align="left" style="width: 20%;">
                                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricEvaluationProblems_s8s2s3s_Severity" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems','Severity','select');" Style="width: 89%;" runat="server" Category="XPSYCHEVALSEVERITY" AddBlankRow="true" CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                </td>
                                                                <td align="right" style="width: 10%; padding-right: 10px"><span>Duration</span></td>
                                                                <td align="left" style="width: 20%;">
                                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricEvaluationProblems_s8s2s3s_Duration" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems','Duration','text');" Style="width: 89%;" runat="server" Category="XPSYCHEVALDURATION" AddBlankRow="true" CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                </td>
                                                                <td align="right" style="width: 10%; padding-right: 10px"><span>Intensity</span></td>
                                                                <td align="left" style="width: 20%;">
                                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricEvaluationProblems_s8s2s3s_Intensity" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems','Intensity','select');" Style="width: 89%;" runat="server" Category="XPSYCHEVALINTENSITY" AddBlankRow="true" CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                </td>
                                                                <td align="left" style="width: 10%;">&nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td align="left" style="width: 10%;"><span>Time of Day</span></td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayMorning" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'TimeOfDayMorning', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 8%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayMorning" style="cursor: default">Morning</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayNoon" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'TimeOfDayNoon', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 6%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayNoon" style="cursor: default">Noon</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayAfternoon" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'TimeOfDayAfternoon', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 9%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayAfternoon" style="cursor: default">Afternoon</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayEvening" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'TimeOfDayEvening', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 8%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayEvening" style="cursor: default">Evening</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayNight" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'TimeOfDayNight', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 8%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_TimeOfDayNight" style="cursor: default">Night</label>
                                                                </td>
                                                                <td align="left" style="width: 41%;">&nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td align="left" style="width: 10%;"><span>Context</span></td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextHome" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'ContextHome', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 8%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextHome" style="cursor: default">Home</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextSchool" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'ContextSchool', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 6%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextSchool" style="cursor: default">School</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextWork" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'ContextWork', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 9%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextWork" style="cursor: default">Work</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextCommunity" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'ContextCommunity', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 8%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextCommunity" style="cursor: default">Community</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="checkbox" id="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextOther" onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricEvaluationProblems', 'ContextOther', 'checkbox');" style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                                <td align="left" style="width: 6%; padding-left: 2px">
                                                                    <label for="CheckBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextOther" style="cursor: default">Other</label>
                                                                </td>
                                                                <td align="left" style="width: 43%;">
                                                                    <input type="text" id="TextBox_CustomPsychiatricEvaluationProblems_s8s2s3s_ContextOtherText" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems', 'ContextOtherText', 'text');" class="form_textbox" style="height: 13px; width: 85%; display: none" maxlength="150" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td align="left" style="width: 20%;"><span>Associated Signs/Symptoms</span></td>
                                                                <td align="left" style="width: 25%">
                                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricEvaluationProblems_s8s2s3s_AssociatedSignsSymptoms" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems', 'AssociatedSignsSymptoms', 'select');" Style="width: 89%;" runat="server" Category="XHISTORYSYMPTOMS" AddBlankRow="true" CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                </td>
                                                                <td align="left" style="width: 55%;">
                                                                    <input type="text" id="TextBox_CustomPsychiatricEvaluationProblems_s8s2s3s_AssociatedSignsSymptomsOtherText" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems', 'AssociatedSignsSymptomsOtherText', 'text');" class="form_textbox" style="height: 13px; width: 88.3%; display: none" maxlength="150" bindsetformdata="False" bindautosaveevents="False" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <span>Modifying Factors</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1" style="width: 100%;"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <textarea class="form_textarea" id="TextArea_CustomPsychiatricEvaluationProblems_s8s2s3s_ModifyingFactors" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems', 'ModifyingFactors', 'text');" rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String" bindsetformdata="False" bindautosaveevents="False"></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <span>Reason Resolved</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1" style="width: 100%;"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <textarea class="form_textarea" id="TextArea_CustomPsychiatricEvaluationProblems_s8s2s3s_ReasonResolved" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricEvaluationProblems', 'ReasonResolved', 'text');" rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String" bindsetformdata="False" bindautosaveevents="False"></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
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
                            </div>
                            <div id="divMainProblem" style="width: 100%;">
                            </div>
                        </td>
                    </tr>
                    <tr id="trAfterProblem" section="AfterProblem" style="display: none">
                        <td class="height2"></td>
                    </tr>
                    <tr section="AfterProblem" style="display: none">
                        <td align="right" style="padding-right: 10px">
                            <span onclick="appendNewProblem();" style="text-decoration: underline; color: #0000ff; cursor: pointer">Add Problem</span>
                        </td>
                    </tr>
                    <tr section="AfterProblem" style="display: none">
                        <td class="height2"></td>
                    </tr>
                    <tr section="AfterProblem" style="display: none">
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Review of Systems & Active Medical Problems
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
                    <tr section="AfterProblem" style="display: none">
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CheckReviewed">Check = reviewed and negative if pertinent positives are not commented on below</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemPsych"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemPsych" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 18%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemPsych" style="cursor: default">
                                                        PSYCH</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemSomaticConcerns"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemSomaticConcerns" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemSomaticConcerns" style="cursor: default">
                                                        Somatic Concerns</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemConstitutional"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemConstitutional" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 28%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemConstitutional" style="cursor: default">
                                                        Constitutional (wt loss, etc.)</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEarNoseMouthThroat"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEarNoseMouthThroat" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEarNoseMouthThroat" style="cursor: default">
                                                        Ear, Nose, Mouth, Throat</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGI"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGI" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 18%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGI" style="cursor: default">
                                                        GI</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGU"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGU" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemGU" style="cursor: default">
                                                        GU</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemIntegumentary"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemIntegumentary" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 28%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemIntegumentary" style="cursor: default">
                                                        Integumentary (Skin, Breast)</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEndo"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEndo" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEndo" style="cursor: default">
                                                        Endo</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemNeuro"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemNeuro" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 18%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemNeuro" style="cursor: default">
                                                        Neuro</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemImmune"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemImmune" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemImmune" style="cursor: default">
                                                        Immune</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEyes"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEyes" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 28%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemEyes" style="cursor: default">
                                                        Eyes</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemResp"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemResp" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemResp" style="cursor: default">
                                                        Resp</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemCardioVascular"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemCardioVascular" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 18%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemCardioVascular" style="cursor: default">
                                                        Cardio/Vascular</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemHemLymph"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemHemLymph" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemHemLymph" style="cursor: default">
                                                        Hem/Lymph</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemMusculo"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemMusculo" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 28%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemMusculo" style="cursor: default">
                                                        Musculo</label>
                                                </td>
                                                <td align="center" style="width: 2%">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemAllOthersNegative"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemAllOthersNegative" style="cursor: default" />
                                                </td>
                                                <td align="left" style="width: 23%; padding-left: 2px">
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ReviewOfSystemAllOthersNegative" style="cursor: default">
                                                        All others negative</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CustomHistoryComments">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_ReviewOfSystemComments"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_ReviewOfSystemComments" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr section="AfterProblem" style="display: none">
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
</div>
