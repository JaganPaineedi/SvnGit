<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HealthDataListManagement.aspx.cs"
    Inherits="HealthDataListManagement" %>

<%@ Register TagName="GraphInfo" TagPrefix="UI" Src="~/UserControls/GraphControl.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="~/App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" type="text/css" rel="stylesheet" />

    <script type="text/javascript" language="javascript">
        function HealthDataListPageLoad() {
            try {
                //RegisterHealthDataListControlEvents();
            } catch (ex) {

                //Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
            }
        }
    </script>

</head>
<body>

    <form id="form1" runat="server">

        <div id="DivHealthDataList" runat="server" visible="true" style="overflow-x: hidden; overflow-y: auto;">
            <div style='display: none'>
                <font color="white">#####START#####</font>
            </div>
            <asp:Panel ID="PanelHealthDataList" Style="height: 100%; width: 100%;" runat="server">
            </asp:Panel>
            <div style='display: none'>
                <font color="white">#####END#####</font>
            </div>
        </div>


        <div id="DivReconciliationDataList" runat="server" visible="true" style="overflow-x: hidden; overflow-y: hidden;">
            <div style='display: none'>
                <font color="white">#####STARTRECONCILIATION#####</font>
            </div>

            <asp:Panel ID="PanelReconciliationDataList" Style="height: 170px; float: left" runat="server">
                <table id="TableRecList" align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="left" width="100%" style="min-width:400px">
                            <div id="DivRecList">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:ListView ID="lvReconciliationHeader" runat="server">
                                                <LayoutTemplate>
                                                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                </LayoutTemplate>
                                                <ItemTemplate>
                                                        <table width="100%" cellspacing="0" cellpadding="0" class="ListPageContainer">
                                                            <tr align="left" class="GridViewHeaderText">
                                                                <td width="5%" align="left">
                                                                    <%if (status == "Discontinued")
                                                                     {%>
                                                                    <%# "<input type='CheckBox' name='reconciliationcbsHeader' disabled=true Status='" + Eval("Status") + "'/>"%>
                                                                <%} else { %>
                                                                     <%# "<input type='CheckBox' name='reconciliationcbsHeader' Status='" + Eval("Status") + "'/>"%>
                                                                <%} %>

                                                                </td>
                                                                <td width="95%" align="left">
                                                                    <%# "<div name=\"divId\" class=\"ellipsis\" Title=\"" + Eval("MedicationName") + " " + Eval("StrengthDescription") + "\">" + Eval("MedicationName") + " " + Eval("StrengthDescription") + (Eval("Status").ToString() == "Discontinued" ? " - Discontinued" : "") + "</div>"%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                </ItemTemplate>
                                            </asp:ListView>
                                            
                                            <asp:ListView ID="lvReconciliation" runat="server">
                                                <LayoutTemplate>
                                                    <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                                        <tr>
                                                            <td valign="top">
                                                                <asp:Panel ID="divListPageContent" runat="server" Style="height: 145px; width: 100%;"
                                                                    CssClass="ListPageContent">
                                                                    <table width="100%" cellspacing="0" cellpadding="0">
                                                                        <tr align="left" class="GridViewHeaderText">
                                                                            <%--<td width="5px"></td>
                                                                            <td width="50px">
                                                                                <asp:Panel runat="server" ID="Medication" SortId="Medication" CssClass="SortLabel">Medication</asp:Panel>
                                                                            </td>--%>
                                                                            <td width="13%">
                                                                                <asp:Panel runat="server" ID="Quantity" SortId="Quantity" CssClass="SortLabel">Quantity</asp:Panel>
                                                                            </td>
                                                                            <td width="18%">
                                                                                <asp:Panel runat="server" ID="StartDate" SortId="StartDate" CssClass="SortLabel">StartDate</asp:Panel>
                                                                            </td>
                                                                            <td width="18%">
                                                                                <asp:Panel runat="server" ID="EndDate" SortId="EndDate" CssClass="SortLabel">EndDate</asp:Panel>
                                                                            </td>
                                                                            <td width="51%">
                                                                                <asp:Panel runat="server" ID="Panel3" SortId="EndDate" CssClass="SortLabel">Instructions</asp:Panel>
                                                                            </td>
                                                                        </tr>

                                                                        <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                    </table>
                                                                </asp:Panel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </LayoutTemplate>
                                                <ItemTemplate>
                                                    <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
<%--                                                        <td width="5px">
                                                            <%# "<input type='CheckBox' name='reconciliationcbs' id='MedicationImport_" + Eval("MedicationNameId") + "' MedicationNameId='" + Eval("MedicationNameId") + "' Quantity='" + Eval("Quantity") + "' UnitId='" + Eval("UnitId") + "' StrengthId='" + Eval("StrengthId") + "' ScheduleId='" + Eval("ScheduleId") + "' MedicationStartDate='" + Eval("MedicationStartDate") + "' MedicationEndDate='" + Eval("MedicationEndDate") + "' AdditionalInformation='" + Eval("AdditionalInformation") + "'/>"%>
                                                        </td>
                                                        <td width="50px" class="ellipsis">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("MedicationName") + " " + Eval("Quantity") + " " + Eval("Unit") + " " + Eval("StrengthDescription") + " " + Eval("Schedule") + "\">" + Eval("MedicationName") + " " + Eval("Quantity") + " " + Eval("Unit") + " " + Eval("StrengthDescription") + " " + Eval("Schedule") + "</div>"%>
                                                        </td>--%>
                                                        <td width="10%" class="ellipsis" align="center">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("Quantity") + "\">" + Eval("Quantity") + "</div>"%>
                                                        </td>
                                                        <td width="18%" class="ellipsis" align="center">
                                                            <%# "<input type='CheckBox' checked='true' style='display:none' name='reconciliationcbs' id='MedicationImport_" + Eval("MedicationNameId") + "' MedicationNameId='" + Eval("MedicationNameId") + "' Quantity='" + Eval("Quantity") + "' UnitId='" + Eval("UnitId") + "' StrengthId='" + Eval("StrengthId") + "' ScheduleId='" + Eval("ScheduleId") + "' MedicationStartDate='" + Eval("MedicationStartDate") + "' MedicationEndDate='" + Eval("MedicationEndDate") + "' Comment='" + Eval("Comment")  + "' UserDefinedMedication='" + Eval("UserDefinedMedication") + "'/>"%>
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("MedicationStartDate")+ "\">" + Eval("MedicationStartDate") + "</div>"%>
                                                        </td>
                                                        <td width="18%" class="ellipsis" align="center">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("MedicationEndDate")+ "\">" + Eval("MedicationEndDate") + "</div>"%>
                                                        </td>
                                                        <td width="54%" class="ellipsis" align="left">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("AdditionalInformation")+ "\">" + Eval("AdditionalInformation") + "</div>"%>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <EmptyDataTemplate>
                                                    <asp:Panel ID="Panel1" runat="server" Style="width: 100%;" CssClass="ListPageHeader">
                                                        <table cellspacing="0" border="1" style="height: 50px" cellpadding="0" width="100%">
                                                            <tr>
                                                                <td height="20px" align="center" valign="middle">
                                                                    <asp:Label ID="Label2" runat="server" Style="color: Gray">No data to display</asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </EmptyDataTemplate>
                                            </asp:ListView>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>

            </asp:Panel>

            <div style='display: none'><font color="white">#####ENDRECONCILIATION#####</font></div>
        </div>
        <div id="DivMedReconciliationList" runat="server" visible="true" style="overflow-x: hidden; overflow-y: hidden;">
            <div style='display: none'>
                <font color="white">#####STARTMEDRECONCILIATION#####</font>
            </div>
            <asp:Panel ID="PanelMedReconciliation" Style="height: 170px; float: right;" runat="server">
                <table id="tblMedReconciliation" align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="left" width="100%">
                            <div id="DivGridContainer">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:ListView ID="lvMedReconciliation" runat="server">
                                                <LayoutTemplate>
                                                    <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                                        <tr>
                                                            <td>
                                                                <asp:Panel runat="server" ID="divHeader" Style="width: 100%;">
                                                                    <table cellpadding="0" cellspacing="0" width="100%" id="MedReconciliationHeader">
                                                                        <tr class="GridViewHeaderText">
                                                                            <td width="30%">
                                                                                <asp:Panel runat="server" ID="DateandTime" SortId="DateandTime" CssClass="SortLabel">Date Time</asp:Panel>
                                                                            </td>
                                                                            <td width="20%">
                                                                                <asp:Panel runat="server" ID="Reason" SortId="Reason" CssClass="SortLabel">Reason</asp:Panel>
                                                                            </td>
                                                                            <td width="20%">
                                                                                <asp:Panel runat="server" ID="StaffName" SortId="StaffName" CssClass="SortLabel">Staff</asp:Panel>
                                                                            </td>
                                                                            <td width="30%">
                                                                                <asp:Panel runat="server" ID="ReconciliationType" SortId="ReconciliationType" CssClass="SortLabel">Reconciliation Type</asp:Panel>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </asp:Panel>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td valign="top">
                                                                <asp:Panel ID="divMedListPageContent" runat="server" Style="height: 140px; width: 100%;"
                                                                    CssClass="ListPageContent">
                                                                    <table width="100%" cellspacing="0" cellpadding="0" id="MedReconciliationList">
                                                                        <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                    </table>
                                                                </asp:Panel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </LayoutTemplate>
                                                <ItemTemplate>
                                                    <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                                                        <td width="30%" valign="top" align="left">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DateandTime") + "\">" + Eval("DateandTime") + "</div>"%>
                                                        </td>
                                                        <td width="20%" valign="top" align="left">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("Reason") + "\">" + Eval("Reason") + "</div>"%>
                                                        </td>
                                                        <td width="20%" valign="top" align="left">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("Users") + "\">" + Eval("Users") + "</div>"%>
                                                        </td>
                                                        <td width="30%" valign="top" align="left">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("ReconciliationType") + "\">" + Eval("ReconciliationType") + "</div>"%>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <EmptyDataTemplate>
                                                    <asp:Panel ID="Panel2" runat="server" Style="margin-right: 18px; width: 100%;" CssClass="ListPageHeader">
                                                        <table cellspacing="0" border="1" style="height: 50px" cellpadding="0" width="100%">
                                                            <tr>
                                                                <td height="20px" align="center" valign="middle">
                                                                    <asp:Label ID="Label2" runat="server" Style="color: Gray">No data to display</asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </EmptyDataTemplate>
                                            </asp:ListView>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>


            </asp:Panel>
            <asp:Label ID="LabelClientScript" runat="server" CssClass="redTextError"></asp:Label>
            <div style='display: none'><font color="white">#####ENDMEDRECONCILIATION#####</font></div>
        </div>
        <%-- Added By Chandan For MultiGarph--%>
    ###STARTGRAPH###
            <asp:Panel ID="PanelGraphListInformation" Style="height: 210px; width: 720px;" runat="server">
                <UI:GraphInfo ID="GrpahInfo" runat="server" />
            </asp:Panel>
        ###ENDGRAPH###
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebServices/ClientMedications.asmx" InlineScript="true" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1"
                NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>


    </form>
</body>

<script>
    Sys.Application.add_load(HealthDataListPageLoad)
</script>

</html>
