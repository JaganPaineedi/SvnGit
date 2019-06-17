<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PreScreenEvent.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_PreScreenEvent" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/CustomHRMAssessment.js"></script>--%>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/Diagnosis.js"></script>
<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/PreScreen.js"></script>--%>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/CrisisServiceNote/Scripts/PreScrns.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/CrisisServiceNote/Scripts/CrisisServiceNote.js"></script>

<script type="text/javascript" src="<%=RelativePath%>JScripts/SystemScripts/jquery.maskedinput-1.2.2.js"></script>
<div style="width:840px" style="overflow-x:hidden; overflow-y:hidden">

<table width="840px" border="0" cellpadding="0" cellspacing="0" style="padding-left: 0px;">
    <tr>
        <td valign="top" style="width:840px; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista" class="tableBackgound" Width="840px" OnClientLoad="StoreRadTabstripClientObject"
                OnClientTabSelected="onTabSelected" runat="server" MultiPageID="RadMultiPage1"
                SelectedIndex="1" EnableEmbeddedScripts="False" 
                EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="General" ToolTip="General"  UcName="General"
                        Path="/Custom/CrisisServiceNote/WebPages/General.ascx" runat="server">
                    </telerik:RadTab>                   
                   <%-- <telerik:RadTab Text="Referral" ToolTip="Referral" UcName="Referral"
                        Path="/Custom/CrisisServiceNote/WebPages/Referral.ascx" runat="server">
                    </telerik:RadTab>--%>
                    <telerik:RadTab Text="Suicide/Homicide Risk Assessment" ToolTip="Risk"
                        UcName="Risk" Path="/Custom/CrisisServiceNote/WebPages/Risk.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Mental Status" UcName="MentalStatus" Path="/Custom/CrisisServiceNote/WebPages/MentalStatus.ascx"
                        runat="server" ToolTip="Mental Status">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Substance Use"   UcName="Substance"  Path="/Custom/CrisisServiceNote/WebPages/Substance.ascx"
                        runat="server" ToolTip="Substance Use">
                    </telerik:RadTab>
                   <%-- <telerik:RadTab Text="Health History" UcName="HealthHistory"  Path="/Custom/CrisisServiceNote/WebPages/HealthHistory.ascx"
                        runat="server" ToolTip="Health History">
                    </telerik:RadTab>--%>
                   <%-- <telerik:RadTab Text="Severity/Intensity" UcName="Severity"  Path="/Custom/CrisisServiceNote/WebPages/Severity.ascx"
                        runat="server" ToolTip="Severity/Intensity">--%>
                   <%-- </telerik:RadTab>--%>
                    <telerik:RadTab Text="Diagnosis" UcName="Diagnosis"  Path="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx"
                        runat="server" ToolTip="Diagnosis">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Recommendations/Summary" UcName="Summary" Path="//Custom/CrisisServiceNote/WebPages/Summary.ascx"
                        runat="server" ToolTip="Recommendations/Summary">
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                SelectedIndex="1" CssClass="pageView">
                <telerik:RadPageView ID="General" runat="server">
                </telerik:RadPageView>               
                <%--<telerik:RadPageView ID="Referral" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="Risk" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MentalStatus" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Substance" runat="server">
                </telerik:RadPageView>
                <%--<telerik:RadPageView ID="HealthHistory" runat="server">
                </telerik:RadPageView>--%>
                <%--<telerik:RadPageView ID="Severity" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="Diagnosis" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Summary" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
          <input id="HiddenField_CustomAcuteServicesPrescreens_DocumentVersionId" name="HiddenField_CustomAcuteServicesPrescreens_DocumentVersionId"
        type="hidden" value="-1" />  
       
       <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomAcuteServicesPrescreens,CustomSUSubstances,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors" />
        </td>
    </tr>
</table>
</div>
