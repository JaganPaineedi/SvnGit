<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMAssessmentMedicationArea.ascx.cs"
    Inherits="ActivityPages_Client_Detail_Assessment_HRMAssessmentMedicationArea" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>

<table id="TableMedication" border="0" cellpadding="0" cellspacing="0" width="98%" notgroup="Health">
    <tr>
        <td class="height2"></td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span>Medications</span>
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
        <td class="content_tab_bg" style="padding-left: 6px;">
            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                                <td class="RadioText" style="width: 16%" nowrap="nowrap">
                                    <input type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_I" name="RadioButton_CustomHRMAssessments_PsMedications"
                                        value="I" onclick="IntializeMedication('#RadioButton_CustomHRMAssessments_PsMedications_I', '#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications', 'CustomHRMAssessments', 'PsMedicationsListToBeModified');" />
                                    <label for="RadioButton_CustomHRMAssessments_PsMedications_I">
                                        Initialize Medications</label>
                                </td>
                                <td width="8px">&nbsp;
                                </td>
                                <td style="width: 12%" class="RadioText">
                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_L"
                                        name="RadioButton_CustomHRMAssessments_PsMedications" value="L" onclick="DisappearMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                    <label for="RadioButton_CustomHRMAssessments_PsMedications_L">
                                        List Medications</label>
                                </td>
                                <td width="8px">&nbsp;
                                </td>
                                <td style="width: 12%" class="RadioText">
                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_N"
                                        name="RadioButton_CustomHRMAssessments_PsMedications" value="N" onclick="DisableMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                    <label for="RadioButton_CustomHRMAssessments_PsMedications_N">
                                        No Medications</label>
                                </td>
                                <td width="8px">&nbsp;
                                </td>
                                <td style="width: 10%" class="RadioText">
                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_U"
                                        name="RadioButton_CustomHRMAssessments_PsMedications" value="U" onclick="DisableMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                    <label for="RadioButton_CustomHRMAssessments_PsMedications_U">
                                        Unknown</label>
                                </td>
                                <td width="8px">&nbsp;
                                </td>
                                <td class="checkbox_container">
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList"
                                        name="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList" onchange="HRMNeedList('136',this,'PsychosocialAdult','');" />
                                    <label for="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList">
                                        Add Medications to Needs List
                                    </label>
                                    <span id="Group_Medications"></span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="7" class="height2"></td>
                </tr>
                <tr>
                    <td colspan="7">
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                            <tr>
                                <td>
                                    <table id="Table4" border="0" cellpadding="0" cellspacing="0" style="width: 100%"
                                        parentchildcontrols="True">
                                        <tr>
                                            <td align="left">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                    <tr>
                                                        <td style="padding-left: 5px" align="left" width="7%">
                                                            <span class="form_label" id="Span9">Name</span>
                                                        </td>
                                                        <td width="14%">
                                                            <input type="text" name="TextBox_CustomHRMAssessmentMedications_Name" parentchildcontrols="True" id="TextBox_CustomHRMAssessmentMedications_Name"
                                                                class="form_textbox" tabindex="20" maxlength="11" style="width: 100px" />
                                                        </td>

                                                        <td align="left" width="14%">
                                                            <span class="form_label" id="Span1">Dosage/Freequency</span>
                                                        </td>
                                                        <td width="10%">
                                                            <input type="text" name="TextBox_CustomHRMAssessmentMedications_Dosage" parentchildcontrols="True" id="TextBox_CustomHRMAssessmentMedications_Dosage"
                                                                class="form_textbox" tabindex="20" maxlength="11" style="width: 100px" />
                                                        </td>

                                                        <td align="left" width="10%">
                                                            <span class="form_label" id="Span2">Purpose</span>
                                                        </td>
                                                        <td width="8%">
                                                            <input type="text" name="TextBox_CustomHRMAssessmentMedications_Purpose" parentchildcontrols="True" id="TextBox_CustomHRMAssessmentMedications_Purpose"
                                                                class="form_textbox" tabindex="20" maxlength="11" style="width: 100px" />
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <span class="form_label" id="Span11">Prescribing Physician</span>
                                                        </td>
                                                        <td width="16%">
                                                            <input type="text" parentchildcontrols="True" name="TextBox_CustomHRMAssessmentMedications_PrescribingPhysician" class="form_textbox"
                                                                tabindex="22" id="TextBox_CustomHRMAssessmentMedications_PrescribingPhysician" datatype="text" style="width: 95%"
                                                                value="" />
                                                        </td>

                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td align="right">

                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input class="parentchildbutton" type="button" id="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert"
                                                                tabindex="23" name="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert" baseurl="<%=ResolveUrl("~") %>"
                                                                value="Insert"   onclick="InsertGridData('TableChildControl_CustomHRMAssessmentMedications', 'InsertGridRefund', 'CustomGridRefund', this);"  />
                                                            &nbsp&nbsp
                                                      
                                                            <input class="parentchildbutton" type="button" id="ButtonClear" name="ButtonClear"
                                                                tabindex="24" value="Clear"  onclick=" ClearTable('TableChildControl_CustomHRMAssessmentMedications');"/>
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
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <div id="InsertGridRefund" runat="server" style="width: 98%; height: 120px; overflow-x: hidden; overflow-y: auto; padding-left: 8px; padding-right: 2px">
                                                                <uc1:customgrid id="CustomGridRefund" width="100%" height="120px" runat="server"
                                                                    tablename="CustomHRMAssessmentMedications" primarykey="RefundId" customgridtablename="TableChildControl_CustomHRMAssessmentMedications"
                                                                    columnheader="CustomHRMAssessmentMedications:Amount:User:Date:Comment" columnformat=":Currency::Date"
                                                                    columnname="Name:Dosage/Frequency:Purpose:PrescribingPhysician" donotdisplaydeleteimage="true"
                                                                    donotdisplayradio="true" columnwidth="25%:25%:25%:25%"
                                                                    divgridname="InsertGrid" insertbuttonid="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert" />
                                                            </div>
                                                            <input type="hidden" id="HiddenField_CustomHRMAssessmentMedications_HRMAssessmentMedicationId" parentchldcontrols="True"
                                                                name="HiddenField_CustomHRMAssessmentMedications_HRMAssessmentMedicationId" includeinparentchildxml="true" value="-1" />
                                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="HRMAssessmentMedicationId"
                                                                parentchildcontrols="True" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomHRMAssessmentMedications_DocumentVersionId"
                                                                name="HiddenField_CustomHRMAssessmentMedications_DocumentVersionId" />
                                                            <input id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" type="hidden" value="DocumentVersionId" />

                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>


                    </td>
                </tr>

                <tr>
                    <td colspan="7" class="height2"></td>
                </tr>

                <tr>
                    <td>
                        <div id="DivMedications">
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr class="RadioText">
                                    <td width="42%" nowrap="nowrap">
                                        <span class="form_label">List has been reviewed with client. Does the list need to be
                                            modified?</span>
                                    </td>
                                    <td width="8px">&nbsp;
                                    </td>
                                    <td width="5%" class="RadioText">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y"
                                            name="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified" value="Y"
                                            onclick="EnabledMedicationsList('#RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y', '#TextArea_CustomHRMAssessments_PsMedicationsComment')" />
                                        <label for="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y">
                                            Yes</label>
                                    </td>
                                    <td width="8px">&nbsp;
                                    </td>
                                    <td class="RadioText">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N"
                                            name="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified" value="N"
                                            onclick="DisabledMedicationsList('#RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N', '#TextArea_CustomHRMAssessments_PsMedicationsComment')" />
                                        <label for="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N">
                                            No
                                        </label>
                                    </td>
                                    <td width="30%"></td>
                                </tr>

                                <tr colspan="6" class="height2">
                                    <td colspan="7" class="height2">&nbsp;
                                    </td>
                                </tr>
                                <tr colspan="6" class="height2">
                                    <td>Medications</td>
                                </tr>
                            </table>
                        </div>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td colspan="8" width="100%">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsMedicationsComment"
                                        name="TextArea_CustomHRMAssessments_PsMedicationsComment" rows="5" spellcheck="True"
                                        cols="154" onblur="UpdateNeedsXML(136,'Medications');"></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="7" class="height2"></td>
                </tr>
                <tr>
                    <td colspan="7" class="height2">Note efficacy of current and historical medications and their side effect:
                    </td>
                </tr>
                <tr>
                    <td colspan="7" class="height2"></td>
                </tr>
                <tr>
                    <td colspan="7" class="height2">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td colspan="8" width="100%">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsMedicationsSideEffects"
                                        name="TextArea_CustomHRMAssessments_PsMedicationsSideEffects" rows="5" spellcheck="True"
                                        cols="154" onblur="UpdateNeedsXML(136,'Medications');"></textarea>
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
