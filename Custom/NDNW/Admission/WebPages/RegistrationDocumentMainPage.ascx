<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentMainPage.ascx.cs"
    Inherits="SHS.SmartCare.RegistrationDocumentMainPage" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js" type="text/javascript"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Admission/Scripts/RegistrationDocument.js"></script>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>


<% if (HttpContext.Current == null)
   { %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<style type="text/css">
    .RadTabStrip .rtsLink,
    .RadTabStrip .rtsOut,
    .RadTabStrip .rtsIn
    {
        padding-left : 0px;
        padding-right : 0px;   
    }
</style>
<asp:Panel ID="PanelMain" runat="server">
<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="content_tab_top1">
            <telerik:radtabstrip id="RadTabStrip1" skin="Vista" width="100%" onclienttabselected="onTabSelectedClient"
               runat="server" multipageid="RegistrationDocumentTabPage"
                onclientload="StoreTabstripClientObject" enableembeddedscripts="False" enableembeddedskins="False">
                <Tabs>
                  <telerik:RadTab Text="Demographics" UcName="ClientDemographics" Path="/Custom/Admission/WebPages/RegistrationDocumentDemographics.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Client Contacts" UcName="ClientContacts" Path="/Custom/Admission/WebPages/RegistrationDocumentClientContacts.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Additional Information" UcName="AdditionalInformation" Path="/Custom/Admission/WebPages/RegistrationDocumentAdditionalInfo.ascx" runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Insurance" UcName="Insurance" Path="/Custom/Admission/WebPages/RegistrationDocumentInsurance.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Episode" UcName="Episode" Path="/Custom/Admission/WebPages/RegistrationDocumentEpisode.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Program Enrollment" UcName="ProgramEnrollment" Path="/Custom/Admission/WebPages/RegistrationDocumentProgramEnrollment.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Forms and Agreements" UcName="FormsAgreements" Path="/Custom/Admission/WebPages/RegistrationDocumentFormsAndAgreements.ascx"
                        runat="server">
                    </telerik:RadTab>
                </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RegistrationDocumentTabPage" enableembeddedscripts="false"
                runat="server" cssclass="pageView">
                <telerik:RadPageView ID="ClientDemographics" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ClientContacts" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="AdditionalInformation" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Insurance" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Episode" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ProgramEnrollment" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="FormsAgreements" runat="server">
                </telerik:RadPageView>
            </telerik:radmultipage>
            <!----------------------END------------------------------------>
        </td>
    </tr>
</table>
</asp:Panel>
<asp:Panel ID="PanelLoadUC" runat="server" Visible="false">  
</asp:Panel>

<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="<%=PageTables%>" />
<input id="HiddenField_<%=PageTables%>_DocumentVersionId" name="HiddenField_<%=PageTables%>_DocumentVersionId"
    type="hidden" value="-1" />
          <input type="hidden" id="HiddenFieldOrganization" runat="server" />
        <input type="hidden" id="HiddenFieldPhone" runat="server" />
        <input type="hidden" id="HiddenPCPEmail" runat="server" />
      <input type="hidden" id="hdnStaffcode" runat="server" />
<asp:Panel ID="PanelAjaxCall" runat="server"></asp:Panel>
