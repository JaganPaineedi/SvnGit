<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" CodeFile="CustomCrisisInterventionsAssessment.ascx.cs"
    Inherits="SHS.SmartCare.CustomCrisisInterventionsAssessment" %>
<%@ Register src="~/CommonUserControls/DynamicForms.ascx" tagname="DynamicForms" tagprefix="uc1" %>


<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>

<div style="width:99%;overflow-y:auto;overflow-x:hidden;">    
    <uc1:DynamicForms ID="DynamicFormsCrisisNote1" runat="server" /> 
    <uc1:DynamicForms ID="DynamicFormsMentalStatuses" runat="server" />
    <uc1:DynamicForms ID="DynamicFormsCrisisNote2" runat="server" />
       
        <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentCrisisInterventionNotes,CustomDocumentMentalStatuses" />
    <input id="Hidden1" name="HiddenField_CustomDocumentMentalStatuses_DocumentVersionId" type="hidden" value="-1" />

    
</div>


