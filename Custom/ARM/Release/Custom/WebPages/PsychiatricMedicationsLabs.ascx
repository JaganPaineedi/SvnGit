<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricMedicationsLabs.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricMedicationsLabs" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:5px">
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" width="30%">
                                    Medications / Labs
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
                    <td class="content_tab_bg" style="padding-left:8px">
                        <table cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <span class="form_label">Lab Tests and Monitoring ordered</span>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <textarea rows="4" cols="160" id="TextArea_CustomDocumentPsychiatricEvaluations_LabTestsAndMonitoringOrdered"
             spellcheck='True'   class="form_textarea">
    </textarea>
        </td>
    </tr>
    <tr>
        <td style="height: 15px">
        </td>
    </tr>
    <tr>
        <td>
            <span class="form_label">Treatment Recommendations / Orders</span>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <textarea rows="4" cols="160" id="TextArea_CustomDocumentPsychiatricEvaluations_TreatmentRecommendationsAndOrders"
             spellcheck='True'   class="form_textarea">
    </textarea>
        </td>
    </tr>
    <tr>
        <td style="height: 15px">
        </td>
    </tr>
   
    <tr>
        <td>
        <table cellpadding="0" cellspacing="0"><tr><td>
         <span class="form_label">Medications Prescribed</span>
        </td>
        <td style="width:20px"></td>
        <td>
        <a href="javascript:OpenPage(5766, 105, 'DocumentNavigationName=Medications',2, '<%=RelativePath%>');" border="0" id="Medications" style="text-decoration: underline;"><span
                   class="form_label">Medications</span></a>
        </td>
        <td style="width:20px"></td>
        <td>
         <table border="0" cellspacing="0" cellpadding="0" id="TableBtn" >
                    <tbody>
                        <tr>
                            <td class="glow_lt">
                                &nbsp;
                            </td>
                            <td class="glow_mid">
                                <input id="MedicationNote" style="width: auto;" value="Pull Medications into Note"
                                    type="button" class="Button" onclick="PullMedicationNoteAjax()" />
                            </td>
                            <td class="glow_rt">
                                &nbsp;
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
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <textarea rows="4" cols="160" id="TextArea_CustomDocumentPsychiatricEvaluations_MedicationsPrescribed"
             class="form_textarea" disabled="disabled">
    </textarea>
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
            
            
