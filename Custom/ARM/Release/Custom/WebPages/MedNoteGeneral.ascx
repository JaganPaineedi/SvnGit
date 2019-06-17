<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedNoteGeneral.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNoteGeneral" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 5px">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" width="30%">
                        Patient Identification
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
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width:19%" >
                                    <input type="text" id="TextBox_CustomDocumentMedicationReviewNotes_ClientName" name="TextBox_CustomDocumentMedicationReviewNotes_ClientName"
                                      style="width:140px"   class="form_textbox_readonly" disabled="true" readonly="readonly"  maxlength="100" />
                                </td>
                                <td style="width:3%" >
                                    <span class="form_label">is a</span>
                                </td>
                                <td class="form_label" style="width:5%" >
                                    <input type="text" id="TextBox_CustomDocumentMedicationReviewNotes_ClientAge" name="TextBox_CustomDocumentMedicationReviewNotes_ClientAge"
                                     style="width:25px"   class="form_textbox_readonly" disabled="true" datatype="Numeric" readonly="readonly" maxlength="3" />
                                </td>
                                <td style="width:6%" >
                                    <span class="form_label">year old</span>
                                </td>
                                <td class="form_label" style="width:6%" >
                                    <input type="text" id="TextBox_CustomDocumentMedicationReviewNotes_ClientGender" name="TextBox_CustomDocumentMedicationReviewNotes_ClientGender"
                                     style="width:35px"   class="form_textbox_readonly" disabled="true" readonly="readonly" maxlength="10" />
                                </td>
                                <td style="width:9%" >
                                    <span class="form_label">presenting on</span>
                                </td>
                                <td class="form_label" style="width:9%">
                                    <input type="text" id="TextBox_DateofService" name="TextBox_DateofService" style="width:70px"
                                     class="form_textbox_readonly" disabled="true" readonly="readonly" maxlength="10" />
                                </td>
                                <td style="width:43%" class="form_label">
                                    <span class="form_label">for a medication visit.</span>
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
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <span class="form_label">Current Medications</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea rows="6" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_CurrentMedications"
                                        tabindex="1" class="form_textarea" >
                        </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="form_label">Treatment Recommendations / Orders at Last Visit</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea rows="6" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_PreviousTreatmentRecommendationsAndOrders" class="form_textarea" readonly="readonly">
                       </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="form_label">Client Status / Clinical Observations at Last Visit</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea rows="6" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_PreviousChangesSinceLastVisit" class="form_textarea" readonly="readonly">
                        </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="form_label">Client Status / Clinical Observations Today</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea rows="6" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_ChangesSinceLastVisit"
                                      required="true"   tabindex="2" class="form_textarea">
                        </textarea>
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
