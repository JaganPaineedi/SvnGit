<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricNoteGeneral.ascx.cs"
    Inherits="Custom_PsychiatricNote_WebPages_PsychiatricNoteGeneral" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<asp:Panel ID="PanelMain" runat="server">
    <div id="divMedNoteGeneralTab" class="DocumentScreen">
        <table id="table_history_problem" width="820px" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" align="left">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="height2">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>General
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%">
                                            <div style="padding-left: 100px; padding-bottom: 2px;">
                                                <table>
                                                    <tr>
                                                        <td  align="left" width="23%">Goals/Objectives
                                                        </td>
                                                        <td ><img id="infoicon" style="vertical-align: top;margin-bottom:3px" title="Goals / Objectives" alt="" src="<%=Page.ResolveUrl("~/")%>App_Themes/Includes/images/info.png" /></td>
                                                        <%--<td width="1%">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                height="26" alt="" />
                                                        </td>
                                                        <td class="content_tab_top" width="78%"></td>
                                                        <td width="1%">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                                height="26" alt="" />
                                                        </td>--%>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr class="checkbox_container">
                                        <td width="2%">
                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_A"
                                                value="A" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent"
                                                style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 6%">
                                            <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_A"
                                                style="cursor: default">
                                                Adult</label>
                                        </td>
                                        <td width="2%">
                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_C"
                                                value="C" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent"
                                                style="cursor: default" />
                                        </td>
                                        <td align="left">
                                            <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_C"
                                                style="cursor: default">
                                                Child/Adolescent</label>
                                        </td>
                                        <%--<td width="2%">
                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType_W"
                                                value="W" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType"
                                                style="cursor: default" />
                                        </td>
                                        <td align="left">
                                            <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType_W" style="cursor: default">
                                                Walk-in</label>
                                        </td>
                                        <td width="2%">
                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType_S"
                                                value="S" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType"
                                                style="cursor: default" />
                                        </td>
                                        <td align="left">
                                            <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AppointmentType_S" style="cursor: default">
                                                Scheduled Appointment</label>
                                        </td>--%>
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Persons Present other than Consumer
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%">
                                            <div style="padding-left: 100px; padding-bottom: 2px;">
                                            </div>
                                        </td>
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="form_label_text" align="left" valign="top">Person Present and Providing History other than consumer for exam
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteGenerals_PersonPresent" runat="server" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_PersonPresent" rows="4" 
                                                style="width:95%;" spellcheck="True"></textarea>
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Today's Chief Complaint/Reason for Visit
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%">
                                            <div style="padding-left: 100px; padding-bottom: 2px;">
                                            </div>
                                        </td>
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="form_label_text" align="left" valign="top">Today's Chief Complaint/Reason for Visit
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteGenerals_ChiefComplaint" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_ChiefComplaint" rows="4"
                                                style="width:95%;" spellcheck="True"></textarea>
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                       
                        <tr>
                            <td class="height2"></td>
                        </tr>
                        <tr>
                            <td class="height2"></td>
                        </tr>

                         <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Initial Psychiatric Evaluation Presenting Problem
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%">
                                            <div style="padding-left: 100px; padding-bottom: 2px;">
                                            </div>
                                        </td>
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="form_label_text" align="left" valign="top">Initial Presenting Problem
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem" class="form_textareaWithoutWidth" name="TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem" 
                                                rows="4" style="width:95%;" spellcheck="True" ></textarea>
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                                            <img onclick="deleteProblem(s8s2s3s)" style="vertical-align: top; cursor: pointer"
                                                                height="17" width="16" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />&nbsp;
                                                            <span id="Span_s8s2s3s_ProblemTitle">Problem</span>&nbsp;<span section="spannumber"
                                                                id="Span_s8s2s3s_ProblemNumber">1</span>
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
                                                            <div>
                                                                <table style="width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 7%; padding-left: 1px;" align="right">
                                                                            <input type="button" myvalue="s8s2s3s" id="Button_CustomPsychiatricNoteProblems_s8s2s3s_Problem"
                                                                                name="Button_CustomPsychiatricNoteProblems_s8s2s3s_Problem" class="more_detail_btn_120"
                                                                                value="Problem…." />&nbsp;
                                                                        </td>
                                                                        <td align="left" style="width: 93%;">
                                                                            <textarea id="TextArea_CustomPsychiatricNoteProblems_s8s2s3s_SubjectiveText" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems','SubjectiveText','text');"
                                                                                class="form_textarea" rows="4" style="width: 97%;" spellcheck="True" datatype="String"
                                                                                bindsetformdata="False" bindautosaveevents="False"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" style="width: 100%;">
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td align="left" style="width: 12%;">
                                                                        <span>Type Of Problem *</span>
                                                                    </td>
                                                                    <td align="left" style="width: 14%;">
                                                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_TypeOfProblem"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems','TypeOfProblem','select');"
                                                                            Style="width: 89%;" runat="server" Category="XPROBLEMTYPE" AddBlankRow="true"
                                                                            CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                    </td>
                                                                    <td align="left" style="width: 6%;">
                                                                        <span>Severity</span>
                                                                    </td>
                                                                    <td align="left" style="width: 12%;">
                                                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Severity"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems','Severity','select');"
                                                                            Style="width: 89%;" runat="server" Category="XPSYCHEVALSEVERITY" AddBlankRow="true"
                                                                            CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                    </td>
                                                                    <td align="right" style="width: 13%; padding-right: 10px">
                                                                        <span>Modifying Factors</span>
                                                                    </td>
                                                                    <td align="left" style="width: 18%;">
                                                                         <input type="text" id="TextBox_CustomPsychiatricNoteProblems_s8s2s3s_ModifyingFactors"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems', 'ModifyingFactors', 'text');"
                                                                            class="form_textbox" style="height: 13px; width: 85%;" maxlength="150" bindsetformdata="False"
                                                                            bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="right" style="width: 7%; padding-right: 10px">
                                                                        <span>Duration</span>
                                                                    </td>
                                                                    <td align="left" style="width: 18%;">
                                                                       <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Duration"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems','Duration','text');"
                                                                            Style="width: 89%;" runat="server" Category="XPSYCHEVALDURATION" AddBlankRow="true"
                                                                            CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
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
                                                                    <td align="left" style="width: 10%;">
                                                                        <span>Time of Day</span>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayAllday"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'TimeOfDayAllday', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayAllday" style="cursor: default">
                                                                            All Day</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayMorning"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'TimeOfDayMorning', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayMorning" style="cursor: default">
                                                                            Morning</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayAfternoon"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'TimeOfDayAfternoon', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 9%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayAfternoon" style="cursor: default">
                                                                            Afternoon</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayNight"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'TimeOfDayNight', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 5%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_TimeOfDayNight" style="cursor: default">
                                                                            Night</label>
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="Label_CustomPsychiatricNoteProblems_s8s2s3s_ContextText" style="cursor: default">
                                                                            Context</label>
                                                                    </td>
                                                                    <td align="left" style="width: 35%;">
                                                                        <input type="text" id="TextBox_CustomPsychiatricNoteProblems_s8s2s3s_ContextText"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems', 'ContextText', 'text');"
                                                                            class="form_textbox" style="height: 13px; width: 85%;" maxlength="150" bindsetformdata="False"
                                                                            bindautosaveevents="False" />
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
                                                                         <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                  <tr>
                                                                              <td style="width: 11%;">

                                                                               </td>
                                                                               <td style="width:86%" align="left" >
                                                                             
                                                                    </td>

                                                                    <td style="width: 3%;">

                                                                    </td>
                                                                             </tr>
                                                                             <tr>
                                                                              <td style="width: 11%;">
                                                                                   <span>Associated signs/systems </span>
                                                                               </td>
                                                                               <td style="width:86%" >
                                                                               <textarea id="TextArea_CustomPsychiatricNoteProblems_s8s2s3s_AssociatedSignsSymptomsOtherText" onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems','AssociatedSignsSymptomsOtherText','text');"
                                                                                class="form_textarea" rows="4" style="width: 97%;" spellcheck="True" datatype="String"
                                                                                bindsetformdata="False" bindautosaveevents="False"></textarea>
                                                                    </td>

                                                                    <td style="width: 3%;">

                                                                    </td>
                                                                             </tr>
                                                                         </table>
                                                                    </td>
                                                                  

                                                                </tr>
                                                               <%-- <tr>
                                                                    <td align="left" style="width: 10%;">
                                                                        <span>Location where problem occurs</span>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationHome"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'LocationHome', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationHome" style="cursor: default">
                                                                            Home</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationSchool"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'LocationSchool', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationSchool" style="cursor: default">
                                                                            School</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationWork"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'LocationWork', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 8%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationWork" style="cursor: default">
                                                                            Work</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationEveryWhere"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'LocationEveryWhere', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                    <td align="left" style="width: 10%; padding-left: 2px">
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationEveryWhere" style="cursor: default">
                                                                            Everywhere</label>
                                                                    </td>
                                                                    <td align="left" style="width: 2%" colspan="2"  class="checkbox_container">
                                                                        <input type="checkbox" id="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationOther"
                                                                            onclick="updateProblem(s8s2s3s, this, 'CustomPsychiatricNoteProblems', 'LocationOther', 'checkbox');"
                                                                            style="cursor: default" bindsetformdata="False" bindautosaveevents="False" />
                                                                        <label for="CheckBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationOther" style="cursor: default">
                                                                            Other</label>
                                                                        <input type="text" id="TextBox_CustomPsychiatricNoteProblems_s8s2s3s_LocationOtherText"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems', 'LocationOtherText', 'text');"
                                                                            class="form_textbox" style="height: 13px; width: 70%; display: none;margin-left:20px;" maxlength="130"
                                                                            bindsetformdata="False" bindautosaveevents="False" />
                                                                    </td>
                                                                </tr>--%>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                          
                                                                             <tr>
                                                                                 <td colspan="3"></td>
                                                                             </tr>
                                                                              <tr>
                                                                        <td align="left" style="width:11%">
                                                                        <span>Status</span>
                                                                    </td>
                                                                    <td align="left" style="width:30%">
                                                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_ProblemStatus"
                                                                            onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems', 'ProblemStatus', 'select');"
                                                                            Style="width: 89%;" runat="server" Category="XPROBLEMSTATUS" AddBlankRow="true"
                                                                            CssClass="form_dropdown" bindsetformdata="False" bindautosaveevents="False"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                                    </td>
                                                                                  <td style="width:61%">

                                                                                  </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                               
                                                                    
                                                                </tr>
                                                      
                                                      
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <%--<tr>
                                                        <td align="left" style="width: 100%;">
                                                            <span>Modifying Factors</span>
                                                        </td>
                                                    </tr>--%>
                                                    <tr>
                                                        <td class="height1" style="width: 100%;"></td>
                                                    </tr>
                                                    <%--<tr>
                                                        <td align="left" style="width: 100%;">
                                                            <textarea class="form_textarea" id="TextArea_CustomPsychiatricNoteProblems_s8s2s3s_ModifyingFactors"
                                                                onchange="updateProblem(s8s2s3s,this,'CustomPsychiatricNoteProblems', 'ModifyingFactors', 'text');"
                                                                rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String" bindsetformdata="False"
                                                                bindautosaveevents="False"></textarea>
                                                        </td>
                                                    </tr>--%>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td align="right" class="right_bottom_cont_bottom_bg" width="2">
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
                        <tr>
                            <td class="height2"></td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Side Effects
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
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="form_label_text" align="left" width="10%">Side Effects
                                        </td>
                                        <td>
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr class="checkbox_container">
                                                    <td width="2%">
                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects_N"
                                                            value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects" onchange="NursemoniterOther();"
                                                            style="cursor: default" />
                                                    </td>
                                                    <td align="left" style="width:10%" >
                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects_N" style="cursor: default">
                                                            None</label>
                                                    </td>
                                                    <td width="2%">
                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects_S"
                                                            value="S" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects" onchange="NursemoniterOther();"
                                                            style="cursor: default" /> 
                                                    </td>
                                                    <td align="left" width="7%">
                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects_S" style="cursor: default">
                                                            Specify</label>
                                                    </td>
                                                    <td >
                                                        <input type="text" class="form_textbox element" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SideEffectsComments"
                                                            style="width: 97%; display:none;" />
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Plan – Last Visit
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
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="form_label_text" align="left" valign="top">Plan – Last Visit
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteGenerals_PlanLastVisit" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_PlanLastVisit" rows="4"
                                                style="width:95%;" disabled="disabled"></textarea>
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
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Past/Family/Social History
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
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="height2" style="width: 100%;"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <table border="0" width="80%">
                                                <tr>
                                                    <td style="width: 15%">
                                                        <span id="Span_CustomPsychiatricHistory">Past History *</span>
                                                    </td>
                                                    <td style="width: 85%; padding-left: 15px">
                                                        <table id="tableMedicalHistory" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                            <tr>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory_N"
                                                                        value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 25%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory_N"
                                                                        style="cursor: default">
                                                                        Reviewed No Changes</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory_C"
                                                                        value="C" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 71%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistory_C"
                                                                        style="cursor: default">
                                                                        Reviewed With Changes</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height1" style="width: 100%;"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistoryComments"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_PsychiatricHistoryComments"
                                                rows="4" spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <table border="0" width="80%">
                                                <tr>
                                                    <td style="width: 15%">
                                                        <span id="Span_CustomFamilyHistory">Family History *</span>
                                                    </td>
                                                    <td style="width: 85%; padding-left: 10px">
                                                        <table id="tableFamilyHistory" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                            <tr>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory_N"
                                                                        name="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory" value="N"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 25%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory_N" style="cursor: default">
                                                                        Reviewed No Changes</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory_C"
                                                                        value="C" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 71%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_FamilyHistory_C" style="cursor: default">
                                                                        Reviewed With Changes</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height1" style="width: 100%;"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_FamilyHistoryComments"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_FamilyHistoryComments" rows="4"
                                                spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%">
                                            <table border="0" style="width: 80%;">
                                                <tr>
                                                    <td style="width: 15%">
                                                        <span id="Span_CustomSocialHistory">Social History *</span>
                                                    </td>
                                                    <td style="width: 85%; padding-left: 10px">
                                                        <table id="tableSocialHistory" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                            <tr>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory_N"
                                                                        value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 25%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory_N" style="cursor: default">
                                                                        Reviewed No Changes</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory_C"
                                                                        value="C" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 71%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_SocialHistory_C" style="cursor: default">
                                                                        Reviewed With Changes</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height1" style="width: 100%;"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_SocialHistoryComments"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_SocialHistoryComments" rows="4"
                                                spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                        </td>
                                    </tr>

                                     <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td align="left" style="width: 100%">
                                            <table border="0" style="width: 80%;">
                                                <tr>
                                                    <td style="width: 15%">
                                                        <span id="Span1">Medical History</span>
                                                    </td>
                                                    <td style="width: 85%; padding-left: 10px">
                                                        <table id="table1" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                            <tr>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory_N"
                                                                        value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 25%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory_N" style="cursor: default">
                                                                        Reviewed No Changes</label>
                                                                </td>
                                                                <td align="center" style="width: 2%">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory_C"
                                                                        value="C" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory"
                                                                        style="cursor: default" />
                                                                </td>
                                                                <td align="left" style="width: 71%; padding-left: 2px">
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_MedicalHistory_C" style="cursor: default">
                                                                        Reviewed With Changes</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height1" style="width: 100%;"></td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td align="left" style="width: 100%;">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_MedicalHistoryComments"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_MedicalHistoryComments" rows="4"
                                                spellcheck="True" datatype="String" style="width:95%;"></textarea>
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Review of Systems & Active Medical Problems
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
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                      <tr>
                                        <td class="height2"></td>
                                    </tr>
                                      <tr>
                                        <td class="height2" colspan="4">
                                            <label>Check box indicate that it is negative unless specified below in the comment section</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    
                                    <tr>
                                        <td class="checkbox_container" width="25%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewPsychiatric"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewPsychiatric" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewPsychiatric" style="cursor: default">
                                                Psychiatric</label>
                                        </td>
                                        <td class="checkbox_container" width="25%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewMusculoskeletal"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewMusculoskeletal" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewMusculoskeletal"
                                                style="cursor: default">
                                                Musculoskeletal</label>
                                        </td>
                                        <td class="checkbox_container" width="25%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewConstitutional"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewConstitutional" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewConstitutional"
                                                style="cursor: default">
                                                Constitutional (wt loss, etc.)</label>
                                        </td>
                                        <td class="checkbox_container">
                                             <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEndocrine"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEndocrine" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEndocrine" style="cursor: default">
                                                Endocrine</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGenitourinary"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGenitourinary" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGenitourinary" style="cursor: default">
                                                Genitourinary</label>
                                        </td>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGastrointestinal"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGastrointestinal" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewGastrointestinal"
                                                style="cursor: default">
                                                Gastrointestinal</label>
                                        </td>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewIntegumentary"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewIntegumentary" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewIntegumentary" style="cursor: default">
                                                Skin/Breast</label>
                                        </td>
                                        <td class="checkbox_container">
                                           <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewRespiratory"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewRespiratory" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewRespiratory" style="cursor: default">
                                                Respiratory</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewNeurological"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewNeurological" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewNeurological" style="cursor: default">
                                                Neurological</label>
                                        </td>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewImmune"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewImmune" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewImmune" style="cursor: default">
                                                Allergic/Immunologic</label>
                                        </td>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEyes"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEyes" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewEyes" style="cursor: default">
                                                Ear, Eye, Nose, Mouth, Throat</label>
                                        </td>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewHemLymph"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewHemLymph" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewHemLymph" style="cursor: default">
                                                Hem/Lymph
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewCardio"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewCardio" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewCardio" style="cursor: default">
                                                Cardio/Vascular</label>
                                        </td>
                                        <td class="checkbox_container">
                                            
                                        </td>
                                        <td class="checkbox_container" style="display:none">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewOthersNegative"
                                                name="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewOthersNegative" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_ReviewOthersNegative"
                                                style="cursor: default">
                                                All others negative</label>
                                        </td>
                                        <td class="checkbox_container"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <label>
                                                Comments</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_ReviewComments"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_ReviewComments" rows="6"
                                                spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td align="right" class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Allergies/Substance Use Hx
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
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td style="width: 85%">Allergies
                                                                </td>
                                                                <td>
                                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="glow_lt">&nbsp;
                                                                                </td>
                                                                                <td class="glow_mid">
                                                                                    <input id="Button_CustomDocumentPsychiatricNoteGenerals_Allergyopen" style="width: auto;" value="Open Allergy" type="button" class="Button" />
                                                                                </td>
                                                                                <td class="glow_rt">&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td></td>
                                                                <td>
                                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="glow_lt">&nbsp;
                                                                                </td>
                                                                                <td class="glow_mid">
                                                                                    <input id="Button_CustomDocumentPsychiatricNoteGenerals_Allergyrefresh" style="width: auto;" value="Refresh" type="button" class="Button" />
                                                                                </td>
                                                                                <td class="glow_rt">&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>



                                                </tr>
                                                <tr>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                                        <div id="divCurrentAllergies" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 797px">
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td >
                                            <table cellspacing="0" cellpadding="0" border="0">
                                                <tr>
                                                    <td>
                                                        Substance Use
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
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAlcohol" 
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAlcohol" onclick="ShowSubstanceUsesPopup(this, 'SUAlcohol')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAlcohol" style="cursor: default">
                                        Alcohol</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUAlcoholDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUAlcoholDiagnosis"
                                                    disabled="disabled" />
                                </td>

                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAmphetamines"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAmphetamines" onclick="ShowSubstanceUsesPopup(this, 'SUAmphetamines')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUAmphetamines" style="cursor: default">
                                        Amphetamines</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUAmphetaminesDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUAmphetaminesDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUBenzos"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUBenzos" onclick="ShowSubstanceUsesPopup(this, 'SUBenzos')"  />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUBenzos" style="cursor: default">
                                        Benzos or Prescription Meds</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUBenzosDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUBenzosDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUCocaine"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUCocaine" onclick="ShowSubstanceUsesPopup(this, 'SUCocaine')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUCocaine" style="cursor: default">
                                        Cocaine</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUCocaineDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUCocaineDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUMarijuana"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUMarijuana" onclick="ShowSubstanceUsesPopup(this, 'SUMarijuana')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUMarijuana" style="cursor: default">
                                        Marijuana</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUMarijuanaDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUMarijuanaDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOpiates"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOpiates" onclick="ShowSubstanceUsesPopup(this, 'SUOpiates')"  />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOpiates" style="cursor: default">
                                        Opiates</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUOpiatesDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUOpiatesDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                                <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUHallucinogen"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUHallucinogen" onclick="ShowSubstanceUsesPopup(this, 'SUHallucinogen')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUHallucinogen" style="cursor: default">
                                        Hallucinogen</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUHallucinogenDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUHallucinogenDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                                <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUInhalant"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUInhalant"  onclick="ShowSubstanceUsesPopup(this, 'SUInhalant')" />
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUInhalant" style="cursor: default">
                                        Inhalant</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
                                    <input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUInhalantDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUInhalantDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td class="checkbox_container" style="padding-left: 5px;width:20%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOthers"
                                        name="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOthers"   onclick="ShowSubstanceUsesPopup(this, 'SUOthers')"/>
                                    <label for="CheckBox_CustomDocumentPsychiatricNoteGenerals_SUOthers" style="cursor: default">
                                        Others</label>
                                </td>
                                <td style="padding-left: 10px;width:80%">
<input class="form_textbox" style="width: 95%;" type="text"
                                                    name="TextBox_CustomDocumentPsychiatricNoteGenerals_SUOthersDiagnosis" id="TextBox_CustomDocumentPsychiatricNoteGenerals_SUOthersDiagnosis"
                                                    disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
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
                                           <label>
                                                Comments</label>
                                        </td>
                                    </tr>

                                   
                                     <tr>
                                        <td class="height2">
                                          
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                                                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_SubstanceUse"
                                                name="TextArea_CustomDocumentPsychiatricNoteGenerals_SubstanceUse" rows="2"
                                                spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td width="2%">
                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke_N"
                                                            value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke"
                                                            style="cursor: default" />
                                                    </td>
                                                    <td width="10%">
                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke_N" style="cursor: default">
                                                            Non-Smoker *</label>
                                                    </td>
                                                    <td width="2%">
                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke_S"
                                                            value="S" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke"
                                                            style="cursor: default" />
                                                    </td>
                                                    <td width="6%">
                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_AllergiesSmoke_N" style="cursor: default">
                                                            Smoker</label>
                                                    </td>
                                                    <td width="8%">How Much?
                                                    </td>
                                                    <td>
                                                        <input type="text" id="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesSmokePerday" name="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesSmokePerday"
                                                            class="form_textbox" maxlength="100" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td width="20%">Other Tobacco Use
                                                    </td>
                                                    <td>
                                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesTobacouse"
                                                            name="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesTobacouse" rows="2"
                                                            spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td width="20%">Caffeine Consumption
                                                    </td>
                                                    <td>
                                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesCaffeineConsumption"
                                                            name="TextArea_CustomDocumentPsychiatricNoteGenerals_AllergiesTobacouse" rows="2"
                                                            spellcheck="True" datatype="String" style="width:95%;"></textarea>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td width="8%">Pregnant *
                                                    </td>
                                                    <td>
                                                        <table cellpadding="0" cellspacing="0" width="30%">
                                                            <tr>
                                                                <td class="checkbox_container">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_Y"
                                                                        value="Y" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant" />
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_Y" style="cursor: default">
                                                                        Yes</label>
                                                                </td>
                                                                <td class="checkbox_container">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_N"
                                                                        value="N" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant" />
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_N" style="cursor: default">
                                                                        No
                                                                    </label>
                                                                </td>
                                                                <td class="checkbox_container">
                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_A"
                                                                        value="A" name="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant"  />
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_A" style="cursor: default">
                                                                        N/A</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td width="15%">Last Menstrual Period
                                                    </td>
                                                    <td>
                                                        <input style="width: 50%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteGenerals_LastMenstrualPeriod"
                                                            name="Textbox_CustomDocumentPsychiatricNoteGenerals_LastMenstrualPeriod" />
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
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td align="right" class="right_bottom_cont_bottom_bg" width="2">
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
                <td class="height2"></td>
            </tr>
            <tr>
                <td>


                    <div style="display: none">
                        <table>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td align="left" class="content_tab_left" nowrap="nowrap">PCP/Other Providers </td>
                                            <td width="17">
                                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                            </td>
                                            <td class="content_tab_top" width="100%"></td>
                                            <td width="7">
                                                <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="content_tab_bg">

                                    <table id="TableChildControl_ExternalReferralProviders" border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                                    <tr>
                                                        <td align="left" style="width: 15%; padding-left: 7px"><span id="Span3" class="form_label">Type of Provider</span> </td>
                                                        <td align="left" width="15%">
                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_ExternalReferralProviders_Type" runat="server" AddBlankRow="true" BlankRowText="" Category="PCProviderType" CssClass="form_dropdown" onchange="javascript:LoadProvidersByType(this);" parentchildcontrols="True" Width="200px"></DropDownGlobalCodes:DropDownGlobalCodes>
                                                        </td>
                                                        <td align="left" width="50%"><span id="Span10" class="form_label">Provider Name</span>
                                                            <cc2:StreamlineDropDowns ID="DropDownList_ExternalReferralProviders_ExternalProviderId" runat="server" AddBlankRow="True" CssClass="form_dropdown" DataTextField="ExternalProviderIdText" DataValueField="ExternalReferralProviderId" onchange="GetProviderDetails()" parentchildcontrols="True" Width="180px"></cc2:StreamlineDropDowns>
                                                            <span id="span_modiyProviderReferral" onclick="ModifyProvider(this)" style="color: blue; cursor: pointer; display: none">Edit Provider...</span> </td>
                                                        <td style="padding-left: 10px; width: 5%;">
                                                            <input class="parentchildbutton" type="button" id="TableChildControl_ExternalReferralProviders_ButtonInsert"
                                                                name="TableChildControl_ExternalReferralProviders_ButtonInsert" onclick="javascript: InsertGridData('TableChildControl_ExternalReferralProviders', 'InsertGridExternalReferralProviders', 'CustomGridExternalReferralProviders', this);"
                                                                baseurl="<%=ResolveUrl("~") %>" value="Add" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="visibility: hidden;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td>
                                                            <input name="TextBox_ExternalReferralProviders_OrganizationName" class="form_textbox"
                                                                id="TextBox_ExternalReferralProviders_OrganizationName" style="width: 40%;" type="text"
                                                                maxlength="100" parentchildcontrols="True" runat="server" />
                                                        </td>
                                                        <td>
                                                            <input name="TextBox_ExternalReferralProviders_PhoneNumber" class="form_textbox"
                                                                id="TextBox_ExternalReferralProviders_PhoneNumber" style="width: 40%;" type="text"
                                                                maxlength="9" parentchildcontrols="True" runat="server" />
                                                        </td>
                                                        <td>
                                                            <input name="TextBox_ExternalReferralProviders_Email" class="form_textbox" id="TextBox_ExternalReferralProviders_Email"
                                                                style="width: 40%;" type="text" maxlength="100" parentchildcontrols="True" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-left: 7px">
                                                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                                    <tr>
                                                        <td align="left" class="content_tab_left" nowrap="nowrap">Medication History </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-left: 7px">
                                                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                                    <tr>
                                                        <td>
                                                            <div id="InsertGridExternalReferralProviders" runat="server" style="overflow-y: auto; overflow-x: hidden; height: 138px">
                                                                <uc1:CustomGrid ID="CustomGridExternalReferralProviders" runat="server" columnformat=":::::" columnheader="Type of Provider:Organization:Name:Phone Number:Email" columnname="TypeText:OrganizationName:ExternalProviderIdText:PhoneNumber:Email" columnwidth="153:100:100:140:200" customgridtablename="TableChildControl_ExternalReferralProviders" divgridname="InsertGridExternalReferralProviders" gridpagename="ExternalReferralProviders" insertbuttonid="TableChildControl_ExternalReferralProviders_ButtonInsert" primarykey="ExternalReferralProviderId" tablename="ExternalReferralProviders" width="100%" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%--  <input type="hidden" parentchildcontrols="True" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey"
                                                                    value="PrimaryCarePhysician" />--%>
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenField_ExternalReferralProviders_ExternalReferralProviderId"
                                                                name="HiddenField_ExternalReferralProviders_ExternalReferralProviderId" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey"
                                                                value="ExternalReferralProviderId" />
                                                            <input type="hidden" id="HiddenfieldProviderId" runat="server" name="HiddenfieldProviderId"
                                                                value="" />
                                                        </td>
                                                    </tr>
                                                </table>
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
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="right_bottom_cont_bottom_bg" width="2">
                                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                            </td>
                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                            <td align="right" class="right_bottom_cont_bottom_bg" width="2">
                                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>


                    </div>
                </td>
            </tr>
        </table>

    </div>



</asp:Panel>
<asp:Panel ID="PanelGoalsObjectives" runat="server">
</asp:Panel>
