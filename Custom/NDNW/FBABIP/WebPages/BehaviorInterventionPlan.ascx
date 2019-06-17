<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BehaviorInterventionPlan.ascx.cs" Inherits="ActivityPages_Client_Detail_Documents_Threshold_FBABIP_BehaviorInterventionPlan" %>

<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms" TagPrefix="uc2" %>
<div id="DivCustomDocumentFABIPDFA">
 
  <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsCustomDocumentFABIP" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentFABIPs_DocumentVersionId" name="HiddenField_CustomDocumentFABIPs_DocumentVersionId"
        type="hidden" value="-1" />
                <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentFABIPs" />

 </div>