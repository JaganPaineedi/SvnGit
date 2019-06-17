<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomCrisisInterventionsPlans.ascx.cs" Inherits="SHS.SmartCare.CustomCrisisInterventionsPlans" %>
<%@ Register src="../../../../../CommonUserControls/DynamicForms.ascx" tagname="DynamicForms" tagprefix="uc1" %>

<script language="javascript" type="text/javascript">
    function BeforeDocumentSignedHandler() {
        //alert('Usercontrol: BeforeDocumentSigned');
    }
    function AfterDocumentSignedHandler() {
        //alert('Usercontrol: AfterDocumentSigned');
    }
</script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>

<div style="width:99%;overflow-y:auto;overflow-x:hidden;">    
    <uc1:DynamicForms ID="DynamicFormsCrisisNote" runat="server" />
    <input id="HiddenField_CustomFultonSchoolCrisisNote_DocumentVersionId" name="HiddenField_CustomFultonSchoolCrisisNote_DocumentVersionId"
        type="hidden" value="-1" />
    <input id="HiddenField_CustomFultonSchoolCrisisNote_DocumentId" name="HiddenField_CustomFultonSchoolCrisisNote_DocumentId"
        type="hidden" value="0" />
    <input id="HiddenField_CustomFultonSchoolCrisisNote_Version" name="HiddenField_CustomFultonSchoolCrisisNote_Version"
        type="hidden" value="1" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentCrisisInterventionNotes" />
</div>
