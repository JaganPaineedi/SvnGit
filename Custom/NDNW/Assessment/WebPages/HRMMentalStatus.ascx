<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMMentalStatus.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMMentalStatus" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc1" %>
<div style="margin: 0px,0px,0px,0px; overflow-x: hidden">
    <table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table id="TableServerProfoundDisability" border="0" cellpadding="0" cellspacing="2"
                    width="100%">
                    <tr>
                        <td align="left">
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr class="checkbox_container">
                                    <td>
                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SevereProfoundDisability"
                                            name="CheckBox_CustomHRMAssessments_SevereProfoundDisability" onclick="DisappearSevereProfoundDisability('#CheckBox_CustomHRMAssessments_SevereProfoundDisability','#trSevereProfoundDisability');" />
                                    </td>
                                    <td>
                                        <span class="form_label">Mental Status Not Applicable:</span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr id="trSevereProfoundDisability">
                        <td align="left">
                        </td>
                        <td align="left">
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td>
                                        <span class="form_label">You have indicated client is not appropriate for a full mental
                                            status exam. Please complete a narrative mental status exam.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea class="form_textarea" id="TextArea_CustomHRMAssessments_SevereProfoundDisabilityComment"
                                            name="TextArea_CustomHRMAssessments_SevereProfoundDisabilityComment" rows="7"
                                            cols="1" style="width: 800px" spellcheck="True" datatype="String"></textarea>
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
            <td>
                <div>
                    <uc1:DynamicForms ID="DynamicForms_HRMMentalStatus" runat="server" />
                </div>
            </td>
        </tr>
    </table>
</div>
