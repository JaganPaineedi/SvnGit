<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SPMIGeneral.ascx.cs" Inherits="Custom_SPMI_WebPages_SPMIGeneral" %>
<div class="DocumentScreen">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 98.5%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span_CustomDocumentDischarges">SPMI</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        Adults with Serious and Persistent Mental Illness (SPMI) are defined as individuals,
                                        18 or older based on the diagnoses listed below:
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 10px">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSPMIs_Schizophrenia" name="CheckBox_CustomDocumentSPMIs_Schizophrenia"
                                            class="cursor_default" onchange="javascript:CheckboxChange(this,1);" />
                                    </td>
                                    <td style="width: 96%">
                                        <label for="CheckBox_CustomDocumentSPMIs_Schizophrenia">
                                            Schizophrenia and other psychotic disorder: 295xx; 297.3; 298.8; 298.9</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSPMIs_MajorDepression" name="CheckBox_CustomDocumentSPMIs_MajorDepression"
                                            class="cursor_default" onchange="javascript:CheckboxChange(this,2);" />
                                    </td>
                                    <td style="width: 96%">
                                        <label for="CheckBox_CustomDocumentSPMIs_MajorDepression">
                                            Major Depression and Bi-Polar Disorder 296xx</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSPMIs_Anxiety" name="CheckBox_CustomDocumentSPMIs_Anxiety"
                                            class="cursor_default" onchange="javascript:CheckboxChange(this,3);" />
                                    </td>
                                    <td style="width: 96%">
                                        <label for="CheckBox_CustomDocumentSPMIs_Anxiety">
                                            Anxiety Disorders: 300.3; 309.81 (PTSD and OCD)</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSPMIs_Personality" name="CheckBox_CustomDocumentSPMIs_Personality"
                                            class="cursor_default" onchange="javascript:CheckboxChange(this,4);" />
                                    </td>
                                    <td style="width: 96%">
                                        <label for="CheckBox_CustomDocumentSPMIs_Personality">
                                            Personality disorders: 301.22; 301.83 (schizotypal and borderline)
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 8px">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        OR
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 3px">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSPMIs_Individual" name="CheckBox_CustomDocumentSPMIs_Individual"
                                            class="cursor_default" onchange="javascript:CheckboxChange(this,5);" />
                                    </td>
                                    <td style="width: 96%">
                                        <label for="CheckBox_CustomDocumentSPMIs_Individual">
                                            The individual has one or more mental illnesses recognized by the current edition
                                            of the Diagnostic and Statistical Manual, excluding substance abuse and addiction
                                            disorders, and a GAF score of 40 or less that results from such illnesses.
                                        </label>
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
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
</div>
