<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticPresentingProblem.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPresentingProblem" %>
    
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<div>
    <table cellpadding="0" cellspacing="0" width="840px">
        <tr>
            <td class="height4">
            </td>
        </tr>
        
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                           Initial / Update?
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
                <table cellpadding="0" cellspacing="0" width="100%">
                   <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr class="checkbox_container">
                                    <td style="width: 1%" align="left">
                                     </td>
                                    <td style="width: 2%;" align="left">
                                        <input  type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I"
                                            value="I" name="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate" onclick="ReInitializeDiagnosticAssessment(this.id)"
                                            tabindex="1" bindautosaveevents="False"/>
                                    </td>
                                    <td style="width: 5%" align="left">
                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I">
                                                       Initial</label>
                                        <%--<span class="form_label"></span>--%>
                                    </td>
                                    <td style="width: 2%;" align="left">
                                        <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U" onclick="ReInitializeDiagnosticAssessment(this.id)"
                                            value="U" name="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate"
                                            tabindex="2" bindautosaveevents="False"/>
                                    </td>
                                    <td style="width: 78%" align="left">
                                     <label for="RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U">
                                                       Update</label>
                                       <%-- <span class="form_label">Update</span>--%>
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
                        <td>
                            <table cellpadding="0" cellspacing="0" width="100%" id="TblUpdateReason">
                                <tr>
                                    <td style="padding-left: 8px;" align="left">
                                        <span class="form_label">Reason for update:</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="padding_label1">
                                        <textarea id="TextArea_CustomDocumentDiagnosticAssessments_ReasonForUpdate" cols="157"
                                            rows="5" tabindex="3" name="TextArea_CustomDocumentDiagnosticAssessments_ReasonForUpdate"
                                            class="form_textareaNarrative" spellcheck="True"></textarea>
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
        <%--Added for LOC--%>
        
        <tr>
            <td class="height4">
            </td>
        </tr>
        
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
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
                <table cellpadding="0" cellspacing="0" width="100%">
                   <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr class="checkbox_container">
                                    <%--<td style="width: 1%" align="left">
                                     </td>--%>
                                    <td style="width: 1%; padding-left: 8px;" align="left" >
                                        Current Level of Care :
                                    </td>
                                    <td style="width: 5%" align="left">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare"
                                            name="DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare" runat="server"
                                            TabIndex="8" Width="30%" AddBlankRow="true"  BlankRowText="" BlankRowValue=""> <%--parentchildcontrols="True"--%>
                                        </cc2:StreamlineDropDowns>
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
        <%--End of LOC--%>
        <tr>
            <td class="height4">
            </td>
        </tr>
        
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Type of Assessment (select one):
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
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr class="checkbox_container">
                                    <td style="width: 2%; padding-left: 8px;" align="left">
                                        <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A"
                                            value="A" name="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment"
                                            tabindex="4"  /> <%--onclick="SetTabsAssessmentType();"--%>
                                    </td>
                                    <td style="width: 15%" align="left">
                                     <label for="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A">Adult Behavioral Health</label>
                                       <%-- <span class="form_label">Adult Behavioral Health</span>--%>
                                    </td>
                                    <td style="width: 2%; padding-left: 8px;" align="left">
                                        <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M"
                                            name="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment" value="M"
                                            tabindex="5"  /> <%--onclick="SetTabsAssessmentType();"--%>
                                    </td>
                                    <td style="width: 15%" align="left">
                                     <label for="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M">Minor Behavioral Health</label>
                                       <%-- <span class="form_label">Minor Behavioral Health</span>--%>
                                    </td>
                                    <td style="width: 2%; padding-left: 8px;" align="left">
                                        <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E"
                                            value="E" name="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment"
                                            tabindex="6"   /> <%--onclick="SetTabsAssessmentType();"--%>
                                    </td>
                                    <td style="width: 66%" align="left">
                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E">Employee Assistance Programming</label>
                                       <%-- <span class="form_label">Employee Assistance Programming</span>--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height3">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table>
                                <tr class="checkbox_container">
                                    <td style="padding-left: 6px; width: 2%;" align="left">
                                        <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C"
                                            value="C" name="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment"
                                            tabindex="7" /> <%--onclick="SetTabsAssessmentType();" --%>
                                    </td>
                                    <td style="width: 98%;" align="left">
                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C">Early Childhood / Developmental Pediatric Assessment</label>
                                       <%-- <span class="form_label">Early Childhood / Developmental Pediatric Assessment</span>--%>
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
        <tr>
            <td class="height4">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Presenting Problem
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td class="padding_label1">
                                        <textarea id="TextArea_CustomDocumentDiagnosticAssessments_PresentingProblem" cols="157"
                                            rows="14" tabindex="8" name="TextArea_CustomDocumentDiagnosticAssessments_PresentingProblem"
                                            class="form_textareaNarrative" spellcheck="True" onkeypress="javascript:return CheckAssessmentsSelected();"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="display: none;" id="tblEarlyChildHood">
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">What options have you/ the family already tried to address
                                                        the problem(s) (include physical, occupational, and speech therapy as applicable)?</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaNarrative" id="TextArea_CustomDocumentDiagnosticAssessments_OptionsAlreadyTried"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_OptionsAlreadyTried" rows="5"
                                                        spellcheck="True" tabindex="9" cols="157"></textarea>
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
                                    <td>
                                        <table style="display: none;" id="tblEPA">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr class="checkbox_container">
                                                            <td style="width: 25%;" class="padding_label1">
                                                                <span class="form_label">Does the client have a legal guardian?</span>
                                                            </td>
                                                            <td style="width: 2%;" align="left" class="padding_2px">
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian_Y"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian"
                                                                    value="Y" tabindex="10"  />
                                                            </td>
                                                            <td style="width: 3%;">
                                                            <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian_Y">Yes</label>
                                                                <%--<span class="form_label">Yes</span>--%>
                                                            </td>
                                                            <td colspan="2" style="width: 2%;" align="left" class="padding_2px">
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian_N"
                                                                    value="N" name="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian"
                                                                    tabindex="11"  />
                                                            </td>
                                                           
                                                            <td style="width: 68%;" align="left">
                                                               <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasLegalGuardian_N">No</label>
                                                               <%-- <span class="form_label">No</span>--%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1" colspan="6">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1" colspan="6">
                                                    <span class="form_label"><em>If yes, Name of guardian: Also describe the extent/ type
                                                        of guardianship and any specific custody/ rights details </em></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaNarrative" id="TextArea_CustomDocumentDiagnosticAssessments_LegalGuardianInfo"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_LegalGuardianInfo" rows="5"
                                                        spellcheck="True" tabindex="12" cols="157"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height4">
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
</div>
