<%@ Control Language="C#" AutoEventWireup="true" CodeFile="General.ascx.cs" Inherits="Custom_Discharge_WebPages_General" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js"></script>

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
                                    <td class="content_tab_left" nowrap='nowrap'>Program Actions
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
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="2" width="100%">
                                            <tr class="RadioText">
                                                <td nowrap='nowrap' style="padding-left: 5px;" width="15%">
                                                    <input type="radio" id="RadioButton_CustomDocumentDischarges_DischargeType_P" name="RadioButton_CustomDocumentDischarges_DischargeType"
                                                        value="P" checked=checked/>
                                                    <label for="RadioButton_CustomDocumentDischarges_DischargeType_P" style="outline: 0;">
                                                        Program Discharge</label>
                                                </td>
                                                <td width="15%">
                                                    <input type="radio" id="RadioButton_CustomDocumentDischarges_DischargeType_A" name="RadioButton_CustomDocumentDischarges_DischargeType"
                                                        value="A" bindautosaveevents='False' />
                                                    <label for="RadioButton_CustomDocumentDischarges_DischargeType_A" style="outline: 0;">
                                                        Agency Discharge</label>
                                                </td>
                                                <td width="35%">&nbsp;
                                                </td>
                                                <td>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="45%">
                                                        <tr>
                                                            <td class="expandable_btn_left" align="center">
                                                                <input type="button" id="ButtonCurrentTeamList" name="Get Current Program List" value="Get Current Program List"
                                                                    class="form_btn_left1" onclick="GetClientProgramsList('')" />
                                                            </td>
                                                            <td class="expandable_btn_right">&nbsp;
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
                                    <td style="padding-left: 11px;">Specify the program(s) that the client is to be discharged from and which will remain
                                        open.
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 10px">
                                        <div id="divScrollHead" style="width: 800px; display: none">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <thead>
                                                    <tr>
                                                        <th align="left" class="dxgvHeader" style="width: 276px">
                                                            <span class="form_label">Currently Enrolled Program(s)</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 198px">
                                                            <span class="form_label">Action Taken</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 152px">
                                                            <span class="form_label">Primary Program</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 174px">
                                                            <span class="form_label">Enrolled Date</span>
                                                        </th>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                        <div id="divNonScrollHead" style="width: 98%; display: none">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                <thead>
                                                    <tr>
                                                        <th align="left" class="dxgvHeader" style="width: 35%">
                                                            <span class="form_label">Currently Enrolled Program(s)</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 25%">
                                                            <span class="form_label">Action Taken</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 20%">
                                                            <span class="form_label">Primary Program</span>
                                                        </th>
                                                        <th align="left" class="dxgvHeader" style="border-left: 0px; width: 20%">
                                                            <span class="form_label">Enrolled Date</span>
                                                        </th>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                        <div style="overflow: auto; width: 98%; overflow-x: hidden; max-height: 200px">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                <tbody id="myTableDischarge" class="dxgvControl">
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
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
            <td class="height1"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height3"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Client Information
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
                                <tr class="RadioText">
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" >
                                            <tr>
                                                <td>Co-Occurring health problem
                                                </td>
                                                <td></td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td nowrap='nowrap' style="padding-left: 5px;">
                                                                <input type="radio" id="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem_Y" name="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem"
                                                                    value="Y" />
                                                                <label for="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem_Y" style="outline: 0;">
                                                                    Yes</label>
                                                            </td>
                                                            <td></td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem_N" name="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem"
                                                                    value="N" />
                                                                <label for="RadioButton_CustomDocumentDischarges_CoOccurringHealthProblem_N" style="outline: 0;">
                                                                    No</label>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>


                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" >
                                            <tr>
                                                <td width="143px">Client Type
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0"  width="100%">
                                                        <tr>
                                                            <td nowrap='nowrap' style="padding-left: 5px;" colspan="3">
                                                                <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_ClientType"
                                                                    name="DropDownList_CustomDocumentDischarges_ClientType" runat="server"
                                                                    CssClass="form_dropdown" Width="250px" Category="Xdischargeclientype" AddBlankRow="true"
                                                                    BlankRowText="">
                                                                </cc2:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>

                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td valign="top">Health Insurance</td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>

                                    <td>
                                        <textarea rows="4" cols="153" id="DropDownList_CustomDocumentDischarges_HealthInsurance"
                                            class="form_textareaWithoutWidth element" spellcheck="True">
                                        </textarea></td>



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
                                        <img style="vertical-align: top;" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
            <td class="height1"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height3"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Discharge
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
                                    <td>Discharge Reason
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_TransitionDischarge"
                                            name="DropDownList_CustomDocumentDischarges_TransitionDischarge" runat="server"
                                            CssClass="form_dropdown" Width="250px" Category="xPROGDISCHARGEREASON" AddBlankRow="true"
                                            BlankRowText="">
                                        </cc2:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td valign="top">Discharge Details
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea rows="4" cols="153" id="TextArea_CustomDocumentDischarges_DischargeDetails"
                                            class="form_textareaWithoutWidth element" spellcheck="True">
                                        </textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td>Summary of Services Provided
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea rows="4" cols="153" id="TextArea_CustomDocumentDischarges_SummaryOfServicesProvided"
                                            name="TextArea_CustomDocumentDischarges_SummaryOfServicesProvided" class="form_textareaWithoutWidth element"
                                            spellcheck="True" readonly="readonly">
                                        </textarea>
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
                                        <img style="vertical-align: top;" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
            <td class="height1"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height3"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Presenting Problem
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
                                    <td>
                                        <textarea rows="4" cols="153" id="TextArea_CustomDocumentDischarges_PresentingProblems" name="TextArea_CustomDocumentDischarges_PresentingProblems"
                                            class="form_textareaWithoutWidth element" spellcheck="True" readonly="readonly">
                                        </textarea>
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
                                        <img style="vertical-align: top;" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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

<script id="clientTemplate" type="text/html">
    <tr class='dxgvDataRow'>
        <td class='dxgv' align='left' style="border-left: 1px solid #cfcfcf; width: 35%">${ProgramCode}
        </td>
        <td class='dxgv' align='left' style="width: 25%">
            <table class='checkbox_container' id='test'>
                <tr>
                    <td>
                        <input type='radio' name='Radio_ClientPrograms_${ClientProgramId}' bindautosaveevents='False'
                            id='Radio_ClientPrograms_R_${ClientProgramId}' value='R' onclick="SetDischargeProgram(${ClientProgramId},'R');" />
                        <label valign='top' for='Radio_ClientPrograms_R_${ClientProgramId}'>
                            Remain Open</label>
                    </td>
                    <td>
                        <input type='radio' name='Radio_ClientPrograms_${ClientProgramId}' bindautosaveevents='False'
                            id='Radio_ClientPrograms_D_${ClientProgramId}' value='D' onclick="SetDischargeProgram(${ClientProgramId},'D');" />
                        <label valign='top' for='Radio_ClientPrograms_D_${ClientProgramId}'>
                            Discharge</label>
                    </td>
                </tr>
            </table>
        </td>
        <td class='dxgv' align='left' style="width: 20%">
            <table>
                <tr class='checkbox_container'>
                    <td>{{if PrimaryAssignment == 'Y'}}
                    <input type='checkbox' checked='checked' programid='${ClientProgramId}' bindautosaveevents='False'
                        id='Checkbox_ClientPrograms_${ClientProgramId}' name='Checkbox_ClientPrograms_${ClientProgramId}'
                        class='cursor_default' onclick="SetPrimaryAssignment(${ClientProgramId},checked);" />
                        {{else}}
                    <input type='checkbox' programid='${ClientProgramId}' bindautosaveevents='False'
                        id='Checkbox_ClientPrograms_${ClientProgramId}' name='Checkbox_ClientPrograms_${ClientProgramId}'
                        class='cursor_default' onclick="SetPrimaryAssignment(${ClientProgramId},checked);" />
                        {{/if}}
                    </td>
                    <td>
                        <label for='Checkbox_ClientPrograms_${ClientProgramId}'>
                            Primary
                        </label>
                    </td>
                </tr>
            </table>
        </td>
        <td class='dxgv' align='left' style="width: 20%">
            <table cellpadding='0' cellspacing='0'>
                <tr>
                    <td>
                        <input class='form_textbox_readonly' type='text' id='TextBox_ClientPrograms_${ClientProgramId}_EnrolledDate'
                            name='TextBox_ClientPrograms_${ClientProgramId}_EnrolledDate' datatype='Date'
                            style='width: 70px; background-color: #f5f5f5; border: 1px solid #a8bac3; font-size: 11px; color: #dad4d4' value='${EnrolledDate}' disabled='disabled' readonly='readonly' />
                    </td>
                    <td style='padding-left: 2px'>
                        <img style='cursor: default' id='imgFromDate_${ClientProgramId}' src='<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif'
                            alt='Calendar' />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</script>

