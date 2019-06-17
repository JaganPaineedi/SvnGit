<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentFormsAndAgreements.ascx.cs"
    Inherits="Custom_Registration_WebPages_RegistrationDocumentFormsAndAgreements" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<div>
    <table cellpadding="0" cellspacing="0" border="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0px" width="100%">
                                <tr>
                                    <td class="height4">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100%;">
                                        <span class="form_label" id="Span_CustomDocumentRegistrationAgreements"><b>Forms and
                                            Agreements</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100%; padding-left: 3px">
                                        <table border="0" cellpadding="0" cellspacing="0px" width="98.7%">
                                            <tr>
                                                <td style="width: 100%">
                                                    <table border="0" cellpadding="0" cellspacing="0px" width="100%">
                                                        <tr>
                                                            <td align="center" valign="middle" style="height: 25px; width: 4%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px;">
                                                                <%--<img title="Delete" class="cursor_default" style="border-width: 0px;" alt="Delete"
                                                                    src="<%=RelativePath%>App_Themes/Includes/Images/deleteIcon.gif" parentchildcontrols="True">--%>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationForm"><b>Form</b></span>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 80%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_RegistrationFormGivenToClient"><b>Forms Given to Client
                                                                    or Guardian</b></span>
                                                            </td>
                                                            <%--   <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationEnglishForm">English</span>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationSpanishForm">Spanish</span>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationNoForm">No</span>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationDeclinedForm">Declined</span>
                                                            </td>
                                                            <td align="center" valign="middle" style="height: 25px; width: 16%; border: 1px solid #a8bac3;
                                                                background-color: #eaeff5; border-bottom: 0px; border-left: 0px">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrationNotApplicableForm">Not Applicable</span>
                                                            </td>--%>
                                                        </tr>
                                                        <tr>
                                                            <%-- <td colspan="7" style="width: 100%;">
                                                                <div id="divmain_FamilyComposition" style="width: 100%;">
                                                                </div>
                                                                <div style="display: none">
                                                                    <%=jsonFamilyComposition%>
                                                                </div>
                                                            </td>--%>
                                                            <td colspan="7" style="width: 100%;">
                                                                <div id="divmain_RegistrationFormcomposition" style="width: 100%;">
                                                                </div>
                                                                <div style="display: none">
                                                                    <%=jsonFormcomposition%>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right" valign="middle" colspan="7" style="height: 25px; border: 1px solid #a8bac3;
                                                                padding-right: 6px">
                                                                <span class="form_label" id="Span_RegistrationAddForm" style="text-decoration: underline;
                                                                    color: #3c92cf; cursor: pointer" onclick="addForm();">Add Form</span>
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
                                <tr>
                                    <td class="height4">
                                        <cc1:DropDownGlobalCodes ID="DropdownList1_CustomRegistrationFormsAndAgreements_Form"
                                            runat="server" Category="XREGISTRATIONFORM" AddBlankRow="true" BlankRowText=""
                                            BlankRowValue="-1" Style="width: 50%; display: none" bindautosaveevents='False'>
                                        </cc1:DropDownGlobalCodes>
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

<script id="formCompositionTmpl" type="text/html">
<table id="Table_{{:CustomRegistrationFormAndAgreementId}}_FormComposition" cellpadding="0"
    cellspacing="0" border="0" style="width: 100%">
    <tr>
        <td align="center" valign="middle" style="height: 25px; width: 4%; border-left: 1px solid #a8bac3;
            border-top: 1px solid #a8bac3;">
            <img alt="Delete" class="cursor_default" style="border-width: 0px;" src="<%=RelativePath%>App_Themes/Includes/Images/deleteIcon.gif"
                parentchildcontrols="True" onclick="deleteForm({{:CustomRegistrationFormAndAgreementId}});" />
        </td>
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <select id="DropdownList1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_Form"
                class="form_dropdown" style="width: 95%; height: 20px; color: black;" bindautosaveevents='False'
                onchange="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'Form')">
            </select>
        </td>
        
        
        
       
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 60%">
                <tr>
                    <td align="left" style="width: 10%">
                        {{if EnglishForm == 'Y'}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_EnglishForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" checked="checked" value="Y" style="cursor: default" bindautosaveevents='False'
                            onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'EnglishForm_Y')" />
                        {{else}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_EnglishForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" value="Y" style="cursor: default" bindautosaveevents='False' onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'EnglishForm_Y')" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 20%; padding-left: 3px">
                        <label for="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_EnglishForm_Y"
                            style="cursor: default">
                            English</label>
                    </td>
                    
                </tr>
            </table>
        </td>
      
      
      
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 60%">
                <tr>
                    <td align="left" style="width: 10%">
                        {{if SpanishForm == 'Y'}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_SpanishForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" checked="checked" value="Y" style="cursor: default" bindautosaveevents='False'
                            onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'SpanishForm_Y')" />
                        {{else}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_SpanishForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" value="Y" style="cursor: default" bindautosaveevents='False' onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'SpanishForm_Y')" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 20%; padding-left: 3px">
                        <label for="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_SpanishForm_Y"
                            style="cursor: default">
                            Spanish</label>
                    </td>
                    
                </tr>
            </table>
        </td>
      
      
      
      
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 60%">
                <tr>
                    <td align="left" style="width: 10%">
                        {{if NoForm == 'Y'}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NoForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" checked="checked" value="Y" style="cursor: default" bindautosaveevents='False'
                            onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'NoForm_Y')" />
                        {{else}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NoForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" value="Y" style="cursor: default" bindautosaveevents='False' onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'NoForm_Y')" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 20%; padding-left: 3px">
                        <label for="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NoForm_Y"
                            style="cursor: default">
                            No</label>
                    </td>
                    
                </tr>
            </table>
        </td>
      
      
      
      
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 60%">
                <tr>
                    <td align="left" style="width: 10%">
                        {{if DeclinedForm == 'Y'}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_DeclinedForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" checked="checked" value="Y" style="cursor: default" bindautosaveevents='False'
                            onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'DeclinedForm_Y')" />
                        {{else}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_DeclinedForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" value="Y" style="cursor: default" bindautosaveevents='False' onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'DeclinedForm_Y')" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 20%; padding-left: 3px">
                        <label for="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_DeclinedForm_Y"
                            style="cursor: default">
                            Declined</label>
                    </td>
                    
                </tr>
            </table>
        </td>
      
      
      
      
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 60%">
                <tr>
                    <td align="left" style="width: 10%">
                        {{if NotApplicableForm == 'Y'}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NotApplicableForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" checked="checked" value="Y" style="cursor: default" bindautosaveevents='False'
                            onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'NotApplicableForm_Y')" />
                        {{else}}
                        <input id="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NotApplicableForm_Y"
                            name="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}"
                            type="radio" value="Y" style="cursor: default" bindautosaveevents='False' onclick="updateForm(this,{{:CustomRegistrationFormAndAgreementId}},'NotApplicableForm_Y')" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 20%; padding-left: 3px">
                        <label for="RadioButton1_CustomRegistrationFormsAndAgreements_{{:CustomRegistrationFormAndAgreementId}}_NotApplicableForm_Y"
                            style="cursor: default">
                            Not Applicable</label>
                    </td>
                    
                </tr>
            </table>
        </td>
        
        
      </tr>
       
       
       
    <tr id="TableRow_{{:CustomRegistrationFormAndAgreementId}}_FormComposition" style="display: none;">
        <td align="center" valign="middle" style="height: 25px; width: 4%; border-left: 1px solid #a8bac3;
            border-top: 1px solid #a8bac3;">
            &nbsp;
        </td>

        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            &nbsp;
        </td>
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            &nbsp;
        </td>
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            &nbsp;
        </td>
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;">
            &nbsp;
        </td>
        <td align="center" valign="middle" style="height: 25px; width: 16%; border-top: 1px solid #a8bac3;
            border-right: 1px solid #a8bac3;">
            &nbsp;
        </td>
    </tr>
</table>
</script>

