<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Locus.ascx.cs" Inherits="SHS.SmartCare.Custom_LOCUS_WebPages_Locus" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/LOCUS/Scripts/Locus.js"></script>
<div id="DivCustomAssessmentLocusDFA">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsCustomDocumentLOCUSs" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentLOCUSs_DocumentVersionId" name="HiddenField_CustomDocumentLOCUSs_DocumentVersionId"
        type="hidden" value="-1" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentLOCUSs" />
</div>
