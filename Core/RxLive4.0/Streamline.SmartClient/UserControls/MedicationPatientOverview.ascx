<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationPatientOverview.ascx.cs"
    Inherits="UserControls_MedicationPatientOverview" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<link href="../App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" type="text/css" rel="stylesheet" />
<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
<meta http-equiv="PRAGMA" content="NO-CACHE">
<table width="99%" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td style="width: 80%;" valign="top">
            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Patient Overview" />
        </td>
        <td style="width: 2%">
            &nbsp;
        </td>
        <td style="width: 100%;" valign="bottom">
            <div id="tdKnownAllergiesHeading" runat="server">
                &nbsp;</div>
        </td>
    </tr>
    <tr>
        <td style="width: 80%; border-top: #dee7ef 3px solid; border-right: #dee7ef 3px solid;
            border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid;" valign="top"
            rowspan="2">
            <div id="clientSummaryInfo" style="height:100%; width: 100%;">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                        <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                            width="30%">
                            Name:&nbsp;<a id="HyperLinkPatientName" runat="server" class="LinkLabel"></a>
                        </td>
                        <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                            width="25%">
                            DOB/Age:&nbsp;<a id="HyperLinkPatientDOB" runat="server" class="LinkLabel"></a>
                        </td>
                        <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                            width="20%">
                            Race:&nbsp; <a id="HyperLinkRace" runat="server" class="LinkLabel"></a>
                        </td>
                        <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap; width: 25%;"
                            valign="top">
                            &nbsp; Sex:&nbsp; <a id="HyperLinkSex" runat="server" class="LinkLabel"></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table style="width: 100%">
                                <tr>
                                    <td class="SumarryLabel" valign="top" align="left" style="width: 7%">
                                        Diagnosis:
                                    </td>
                                    <td class="SumarryLabel" valign="top" align="left" style="width: 93%">
                                        <a id="HyperlinkDiagnosis" runat="server" class="LinkLabel"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table style="width: 100%">
                                <tr>
                                    <td class="SumarryLabel" valign="top" align="left" style="width: 7%">
                                        Axis III:
                                    </td>
                                    <td class="SumarryLabel" valign="top" align="left" style="width: 93%">
                                        <a id="HyperLinkAxisIII" runat="server" class="LinkLabel"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td class="SumarryLabel" nowrap="nowrap" style="width: 50%;">
                                        Last Medication Visit:&nbsp;<a id="HyperLinkLastMedicationVisit" runat="server" class="LinkLabel"></a>
                                    </td>
                                    <td class="SumarryLabel" nowrap="nowrap">
                                        Next Medication Visit:&nbsp;<a id="HyperLinkNextMedicationVisit" runat="server" class="LinkLabel"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td style="width: 2%">
            &nbsp;
        </td>
        <td style="width: 18%" valign="top" rowspan="2">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            &nbsp;
            <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
        </td>
    </tr>
</table>
