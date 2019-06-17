<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiryDetail.ascx.cs"
    Inherits="Custom_InquiryDetails_WebPages_MemberInquiryDetail" %> 

<script src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js" type="text/javascript"></script>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=RelativePath%>Custom/InquiryDetails/Scripts/MemberInquiryDetail.js"></script>
<script type="text/javascript">
    InquiryStatusCode.completeGlobalCode = '<%=globalcodeComplete %>';
</script>
<asp:Panel ID="PanelMain" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td style="margin-left: 0; margin-right: 0">
                <dxtc:aspxpagecontrol id="inquiryTabPageInstance" clientinstancename="inquiryTabPageInstance"
                    runat="server" activetabindex="1" cssfilepath="~/App_Themes/Styles/DevExpressTabStyles.css"
                    width="100%" paddings-padding="0px" contentstyle-paddings-paddingright="0px"
                    contentstyle-paddings-paddingleft="0px" contentstyle-borderright-borderwidth="0"
                    contentstyle-borderleft-borderwidth="0px">
                    <ClientSideEvents TabClick="function(s, e) {        
        onTabSelected(s,e);      
       }" ActiveTabChanged="function(s, e) {onActiveTabChanged(s, e)}" />
                    <ContentStyle>
                        <Paddings PaddingLeft="0px" PaddingRight="0px" />
                        <BorderLeft BorderWidth="0px" />
                        <BorderRight BorderWidth="0px" />
                    </ContentStyle>
                    <TabPages>
                        <dxtc:TabPage Text="Initial" Name="/Custom/InquiryDetails/WebPages/MemberInquiryDetailGeneral.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlCarePlanGeneral" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                         <dxtc:TabPage Text="Insurance" Name="/Custom/InquiryDetails/WebPages/MemberInquiryInsurance.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlMemberInquiryInsurance" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                        <dxtc:TabPage Text="Additional Information" Name="/Custom/InquiryDetails/WebPages/MemberInquiryAdditionalInformation.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlCarePlanNeeds" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
                    <Paddings Padding="0px" />
                </dxtc:aspxpagecontrol>
            </td>
        </tr>
        <tr>
            <td>
                <%--<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomDocumentCarePlans", "DiagnosesIAndII", "DiagnosesIANDIIMaxOrder", "DiagnosesIII", "DiagnosesIV", "DiagnosesV", "DiagnosesIIICodes", "CustomCarePlanDomains", "CustomCarePlanDomainNeeds", "CustomCarePlanDomainGoals", "CustomCarePlanDomainObjectives", "CustomDocumentNeeds", "CustomDocumentCarePlanGoals", "CustomDocumentCarePlanGoalNeeds", "CustomDocumentCarePlanObjectives" />--%>
            </td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>
<asp:Panel ID="MainPanelUC" runat="server">
</asp:Panel>
<input type="hidden" id="HiddenField_CustomInquiries_DefaultInquiryStatus" name="HiddenField_CustomInquiries_DefaultInquiryStatus"/>
<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomInquiries,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomInquiriesCoverageInformations" />
<asp:HiddenField runat="server" ID="HiddenFieldAppointments" />
<asp:HiddenField runat="server" ID="HiddenFieldsPlan" />
<input type="hidden" id="HiddenField_CustomInquiries_SSN" name="HiddenField_CustomInquiries_SSN"/>
<input type="hidden" id="HiddenField_CustomInquiries_DateOfBirth" name="HiddenField_CustomInquiries_DateOfBirth"/>
<input type="hidden" id="HiddenField_CustomInquiries_ClientId" name="HiddenField_CustomInquiries_ClientId"/>
