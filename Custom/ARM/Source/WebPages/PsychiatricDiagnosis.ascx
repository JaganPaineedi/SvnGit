<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricDiagnosis.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricDiagnosis" %>
<%@ Register Src="~/ActivityPages/Client/Detail/Documents/Diagnosis.ascx" TagName="Diagnosis"
    TagPrefix="uc1" %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" width="99%" class="DocumentScreen">
        <tr>
            <td style="height: 2px">
            </td>
        </tr>
        <tr>
            <td style="width: 98%">
                <uc1:Diagnosis ID="UserControl_UCDiagnosis" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%" style="margin-top: 5px">
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" width="30%">
                                        Differential Diagnosis/Formulation
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
                        <td class="content_tab_bg" style="padding-left: 8px">
                            <table cellpadding="0" cellspacing="0" >
                                <tr>
                                    <td>
                                        <textarea class="form_textarea"  name="" class="form_textarea" id="Textarea_CustomDocumentPsychiatricEvaluations_DifferentialDiagnosisFormulation" rows="4" spellcheck="True" cols="158"></textarea>
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
            <td class="height3">
            </td>
        </tr>
    </table>
</div>
