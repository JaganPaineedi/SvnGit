<%@ Control Language="C#" AutoEventWireup="true" CodeFile="General.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricEvaluation_WebPages_General" %>
<%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
<asp:Panel ID="PanelMain" runat="server">
    <div>
        <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
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
                                        <td class="content_tab_left" nowrap='nowrap'>Information
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td style="text-align: left">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="left" valign="top">
                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                            <tr>
                                                                <td align="left" width="16%">
                                                                    <span id="SpanPrimaryEpisodeWorker">Primary Episode Worker</span>
                                                                </td>
                                                                <td align="left" width="20%">
                                                                    <span id="label_CustomDocumentPsychiatricEvaluations_PrimaryEpisodeWorker"><%=PrimaryEpisodeWorker%></span>
                                                                </td>
                                                                <td valign="middle" width="5%">&nbsp;
                                                                </td>
                                                                <td valign="middle" width="9%" align="left">
                                                                    <span id="SpanAge">Clients Age</span>
                                                                </td>
                                                                <td valign="middle" align="left">
                                                                    <span id="label_CustomDocumentPsychiatricEvaluations_Age"><%=ClientAge%></span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left">
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td align="left" width="13%" valign="top">
                                                        <span id="SpanPreviousDiagnosis">Previous Diagnosis</span>
                                                    </td>
                                                    <td align="left" width="87%">
                                                        <div id="divPreviousDiagnosis" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; min-height: 100px; width: 98%"></div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" style="height: 15px;">
                                            <table id="tbl_lifeevent" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="width: 12%">
                                                        <uc3:Information ID="InformationUC" runat="server"></uc3:Information>
                                                    </td>
                                                    <td style="width: 88%">
                                                        <div id="divlifeevent"></div>
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
                                        <td class="content_tab_left" nowrap='nowrap'>Notes Flagged for Review
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
                            <td class="content_tab_bg" style="padding-left: 8px">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
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
                                        <td valign="top" class="height1"></td>
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
                </td>
            </tr>
          <%--  <tr>
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
                                        <td class="content_tab_left" nowrap='nowrap'>Incidents Reported
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="height1">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left"></td>
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
                </td>
            </tr>--%>
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
                                        <td class="content_tab_left" nowrap='nowrap'>Summary
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td align="left" width="100%">
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td align="left" width="15%">
                                                        <input type="button" id="Button_CustomDocumentPsychiatricEvaluations_OpenCalendar" name="Button_CustomDocumentPsychiatricEvaluations_OpenCalendar"
                                                            class="more_detail_btn" value="Open Calendar" />
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <span id="SpNextPsychiatricAppointment">Next Psychiatric Appointment:</span>
                                                    </td>

                                                    <td valign="top" align="left" style="width: 40%; padding-top: 2px;">
                                                        <div id="divAppointment" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 35px; width: 400px">
                                                        </div>
                                                    </td>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height1">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                <tr>
                                                    <td align="left" valign="top">Summary and Recommendations
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" width="100%">
                                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_SummaryAndRecommendations"
                                                            name="TextArea_CustomDocumentPsychiatricEvaluations_SummaryAndRecommendations" rows="4" cols="1" style="width: 98%;"
                                                            spellcheck="True" datatype="String"></textarea>
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
                                        <td class="content_tab_left" nowrap='nowrap'>Transition of Care
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
                                            <span id="Span_TransitionofCare">Medication list at the time of transition</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2" style="width: 100%;"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 100%;">
                                            <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_MedicationListAtTheTimeOfTransition"
                                                name="TextArea_CustomDocumentPsychiatricEvaluations_MedicationListAtTheTimeOfTransition" rows="4" cols="1" style="width: 98%;"
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
                    </table>
                </td>
            </tr>

        </table>
    </div>
</asp:Panel>
<asp:Panel ID="PnlSvcGrid" runat="server">
</asp:Panel>
