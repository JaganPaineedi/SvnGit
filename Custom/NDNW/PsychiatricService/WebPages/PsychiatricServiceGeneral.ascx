<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricServiceGeneral.ascx.cs" Inherits="Custom_PsychiatricService_WebPages_PsychiatricServiceGeneral" %>
<%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
<asp:Panel ID="PanelMain" runat="server">
<div id="divPsychNoteGeneralTab" style="width: 820px;">
    <table width="820px" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td valign="top" align="left">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Information
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
                                    <td style="text-align: left">
                                        <table border="0" cellpadding="0" cellspacing="0px" width="100%">
                                            <tr>
                                                <td align="left" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="left" width="15%">
                                                                <span class="form_label_text" id="SpanPrimaryEpisodeWorker" name="SpanPrimaryEpisodeWorker">
                                                                    Primary Episode Worker:</span>
                                                            </td>
                                                            <td class="LPadd5" align="left" width="20%">
                                                                <span id="label_CustomDocumentPsychiatricServiceNoteGenerals_PrimaryEpisodeWorker" name="label_CustomDocumentPsychiatricServiceNoteGenerals_PrimaryEpisodeWorker"
                                                                    class="form_label"></span>
                                                            </td>
                                                            <td valign="middle" width="5%">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="middle" width="9%" align="left">
                                                                <span class="form_label_text" id="SpanAge" name="SpanAge">Client Age:</span>
                                                            </td>
                                                            <td valign="middle"  align="left">
                                                                <span id="label_CustomDocumentPsychiatricServiceNoteGenerals_Age" name="label_CustomDocumentPsychiatricServiceNoteGenerals_Age"
                                                                    class="form_label"></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left">
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td align="left" width="15%" valign="top">
                                                    <span class="form_label_text" id="SpanPreviousDiagnosis" name="SpanPreviousDiagnosis">
                                                        Previous Diagnosis:</span>
                                                </td>
                                                <td class="LPadd8" align="left" width="85%">
                                                    <div id="divPreviousDiagnosis" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; min-height:100px; width: 660px"></div>
                                                </td>
                                            </tr>
                                             <tr>
                                                    <td class="height1">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" style="height: 15px;">
                                                        <uc3:Information ID="InformationUC" runat="server"></uc3:Information>
                                                    </td>
                                                </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="left" style="width:100%;"  >
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="height1">
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
            </td>
        </tr>
         <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td valign="top" align="left">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                       Notes Flagged for Review
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
                                    <td valign="top" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left">
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                 <td>
                                                    <asp:Panel ID="PnlServiceGrid" runat="server">
                                                    </asp:Panel>
                                                 </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="height1">
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
            </td>
        </tr>
        <tr>
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
          <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Incidents Reported
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
                        <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left">
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
                        <td class="height1">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Summary
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
                        <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td align="left" width="100%">
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td align="left" width="15%">
                                                    <input type="button" id="Button_CustomDocumentPsychiatricServiceNoteGenerals_OpenCalendar" name="Button_CustomDocumentPsychiatricServiceNoteGenerals_OpenCalendar"
                                                        class="more_detail_btn" value="Open Calendar" />
                                                </td>
                                                <td align="left" width="20%">
                                                    <span class="form_label_text" id="SpNextPsychiatricAppointment" name="SpanNextPsychiatricAppointment">
                                                        Next Psychiatric Appointment:</span>
                                                </td>
                                                
                                                <td valign="top" align="left" style="width: 40%;padding-top:2px;">
                                                    <div id="divAppointment" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                        overflow-y: scroll; height: 35px; width: 400px">
                                                    </div>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td class="form_label_text" align="left" valign="top">
                                                    Summary and Recommendations
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" width="100%" style="padding-top:2px;">
                                                    <textarea id="TextArea_CustomDocumentPsychiatricServiceNoteGenerals_SummaryAndRecommendations" class="form_textareaWithoutWidth"
                                                        name="TextArea_CustomDocumentPsychiatricServiceNoteGenerals_SummaryAndRecommendations" rows="5" cols="155" spellcheck="True"></textarea>
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
                    <tr>
                        <td class="height1">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        
           <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Transition of Care
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
                        <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td class="form_label_text" align="left" valign="top">
                                                    Medication List at the Time of Transition
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" width="100%" style="padding-top:2px;">
                                                    <textarea id="TextArea_CustomDocumentPsychiatricServiceNoteGenerals_MedicationListAtTheTimeOfTransition" class="form_textareaWithoutWidth"
                                                        name="TextArea_CustomDocumentPsychiatricServiceNoteGenerals_MedicationListAtTheTimeOfTransition" rows="5" cols="155" spellcheck="True"></textarea>
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
                    <tr>
                        <td class="height1">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
      
    </table>
</div>
 </asp:Panel>
  <asp:Panel ID="PnlSvcGrid" runat="server" >
                                </asp:Panel>