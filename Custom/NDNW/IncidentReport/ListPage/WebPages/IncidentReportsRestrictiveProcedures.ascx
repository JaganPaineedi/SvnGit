<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IncidentReportsRestrictiveProcedures.ascx.cs"
    Inherits="SHS.SmartCare.IncidentReportsRestrictiveProcedures" %>
 
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc5" %>
 
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/IncidentReport/ListPage/Scripts/IRRPListPage.js"></script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<div class="bottom_contanier_white_bg">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="3">
                <table border="0" cellpadding="0" cellspacing="0" width="970px">
                    <tr runat="server" id="TableFiltersContainer">
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="toplt_curve" style="width: 6px"></td>
                                                <td class="top_brd" style="width: 99%"></td>
                                                <td class="toprt_curve" style="width: 6px"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="mid_bg ltrt_brd" colspan="3">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table id="TablePageFilters" name="TablePageFilters" border="0" cellpadding="0" cellspacing="0"
                                                        width="835px">
                                                        <tr>
                                                            <td class="ListPageMiddleTable">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="835px">
                                                                    <tr>
                                                                        <td align="left">
                                                                            <table border="0" cellpadding="0" cellspacing="0" align="left">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellpadding="0" border="0" cellspacing="5" width="100%">
                                                                                            <tr>
                                                                                                <td style="padding-right: 5px" align="left">
                                                                                                    <span id="Span$$StartDate" class="form_label">From</span>
                                                                                                </td>
                                                                                                <td align="left">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr class="date_Container">
                                                                                                            <td>
                                                                                                                <input type="text" datatype="Date" id="TextBox_StartDate" name="TextBox_StartDate"
                                                                                                                    onchange="IRValidateDate(this);" />
                                                                                                            </td>
                                                                                                            <td>&nbsp;
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <img id="imgStartDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                                    onclick="return showCalendar('TextBox_StartDate', '%m/%d/%Y');" />
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                                <td style="width: 128px">
                                                                                                    <table>
                                                                                                        <tr>
                                                                                                            <td style="padding-left: 1px" align="left">
                                                                                                                <span id="Span$$EndDate" class="form_label">To</span>
                                                                                                            </td>
                                                                                                            <td align="left">
                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                    <tr class="date_Container">
                                                                                                                        <td>
                                                                                                                            <input type="text" datatype="Date" id="TextBox_EndDate" name="TextBox_EndDate" onchange="IRValidateDate(this);" />
                                                                                                                        </td>
                                                                                                                        <td>&nbsp;
                                                                                                                        </td>
                                                                                                                        <td>
                                                                                                                            <img id="imgEndDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                                                onclick="return showCalendar('TextBox_EndDate', '%m/%d/%Y');" />
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                                <td style="width: 140px">
                                                                                                    <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomDocumentIncidentReportGenerals_ProgramId"
                                                                                                        Width="150px" AddBlankRow="false" runat="server" CssClass="form_dropdown">
                                                                                                    </DotNetDropDowns:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td class="form_dropdownTD">
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_Forms" Width="150px" runat="server" AddBlankRow="False"
                                                                                                        clientinstancename="DropDownList_FormsDevXInstance" valuetype="System.Int32">
                                                                                                    </cc3:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td class="form_dropdownTD" width="200px">
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident"
                                                                                                        Width="150px" runat="server" AddBlankRow="False" BlankRowValue="" BlankRowText=""
                                                                                                        clientinstancename="DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident">
                                                                                                    </cc3:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td align="left" valign='top'>
                                                                                                    <input type="button" id="Filter" class="less_detail_btn" onclick="GetListPageWithFilters()"
                                                                                                        value="Apply Filter" tabindex="8" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellpadding="0" border="0" cellspacing="5" width="110%">
                                                                                            <tr>
                                                                                                <td style="padding-right: 5px; width: 90px;" align="left">
                                                                                                    <span id="Span$$IndividualName" class="form_label">Individual Name</span>
                                                                                                </td>
                                                                                                <td style="width: 193px; padding-left: 3px;">
                                                                                                    <input type="text" id="TextBox_ClientNameFilter" style="width: 160px" />
                                                                                                    <input type="hidden" id="HiddenField_ClientFilter" />
                                                                                                    <img alt="" style="vertical-align: middle; cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/clearImage.png"
                                                                                                        onclick="ClearClick();" title="Erase" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <cc3:StreamlineDropDowns clientinstancename="DropDownList_StaffDEvx" ID="DropDownList_Staff"
                                                                                                        runat="server" Width="150px">
                                                                                                    </cc3:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_Status" Width="150px" runat="server" AddBlankRow="False"
                                                                                                        clientinstancename="DropDownList_StatusDevXInstance" valuetype="System.Int32"
                                                                                                        Height="16px">
                                                                                                    </cc3:StreamlineDropDowns>
                                                                                                </td>

                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="right" style="width: 13%; padding-right: 15px">
                                                                                                    <span id="Span1" class="form_label">Incident Category</span>
                                                                                                </td>
                                                                                                <td style="width: 19%">
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory" Style="width: 100%"
                                                                                                        name="DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory" runat="server" valuetype="">
                                                                                                    </cc3:StreamlineDropDowns></td>
                                                                                                <td align="right" style="width: 16%; padding-right: 15px"><span id="Span2" class="form_label">Secondary Category</span></td>
                                                                                                <td style="width: 19%">
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory" Style="width: 100%"
                                                                                                        name="DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory" runat="server" AddBlankRow="True"
                                                                                                        BlankRowText="" valuetype="">
                                                                                                    </cc3:StreamlineDropDowns></td>
                                                                                                <td align="right" style="width: 14%; padding-right: 15px"><span id="spnResidentialUnit" class="form_label">Residential Unit</span></td>
                                                                                                <td style="width: 19%">
                                                                                                    <cc3:StreamlineDropDowns ID="DropDownList_ResidentialUnit" CssClass="form_dropdown"
                                                                                                        name="DropDownList_ResidentialUnit" runat="server" AddBlankRow="True"
                                                                                                        BlankRowText="" valuetype="">
                                                                                                    </cc3:StreamlineDropDowns>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="botlt_curve" style="width: 6px"></td>
                                                <td class="bot_brd" style="width: 99%"></td>
                                                <td class="botrt_curve" style="width: 6px"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:HiddenField ID="HiddenFieldPageFilters" runat="server" />
                <asp:HiddenField ID="HiddenFieldCurrentPageIndex" runat="server" />
                <asp:HiddenField ID="HiddenFieldAscDescHistory" runat="server" />
                <asp:HiddenField ID="HiddenFieldSortColumn" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:HiddenField runat="server" ID="HiddenFieldGoToDocumentList" />
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <div id="DivGridContainer">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <asp:ListView ID="lvIncidentRestrictiveProcedure" runat="server" OnLayoutCreated="LayoutCreated">
                                    <LayoutTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                            <tr>
                                                <td>
                                                    <asp:Panel ID="divHeader" runat="server" Style="width: 950px; margin-right: 18px;"
                                                        CssClass="ListPageHeader">
                                                        <table cellspacing="0" cellpadding="0" border="0" width="950px">
                                                            <tr>
                                                                <td width="14%">
                                                                    <asp:Panel ID="EffectiveFrom" runat="server" SortId="DateTime" CssClass="SortLabel">
                                                                        Date/Time
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="Individual" runat="server" SortId="Individual" CssClass="SortLabel">
                                                                        Individual
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="Program" runat="server" SortId="Program" CssClass="SortLabel">
                                                                        Program
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="LOI" runat="server" SortId="LOI" CssClass="SortLabel">
                                                                        Location of Incident
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="Status" runat="server" SortId="Status" CssClass="SortLabel">
                                                                        Status
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="RecordedBy" runat="server" SortId="RecordedBy" CssClass="SortLabel">
                                                                        Recorded By
                                                                    </asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel ID="Form" runat="server" SortId="Form" CssClass="SortLabel">
                                                                        Form
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <asp:Panel ID="divListPageContent" runat="server" Style="width: 970px; height: 350px;"
                                                        CssClass="ListPageContent">
                                                        <table width="970px" cellspacing="0" cellpadding="0">
                                                            <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow" %>'>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("DateTimes") + "\" onclick=\"OpenIRRPPage(this," + Eval("IncidentReportId") + "," + Eval("RestrictiveProcedureId") + "," + Eval("ClientId") + ");\"><u>" + Eval("DateTimes") + "</u></div>"%>                                                
                                            </td>
                                            <td width="14%">
                                                <%# "<div style=\"cursor:hand\" class=\"ellipsis\" Title=\"" + Eval("Individual") + "\" onclick=\"OpenPage(5761,'19','ClientId=" + Eval("ClientId") + "',2,'" + Page.ResolveUrl("~/") + "');\"><u>" + Eval("Individual") + "</u></div>"%>                                                
                                                 
                                            </td>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Program") + "\">" + Eval("Program") + "</div>"%>
                                            </td>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("LocationOfIncident") + "\">" + Eval("LocationOfIncident") + "</div>"%>
                                            </td>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Status") + "\">" + Eval("Status") + "</div>"%>
                                            </td>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("RecordedBy") + "\">" + Eval("RecordedBy") + "</div>"%>
                                            </td>
                                            <td width="14%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Form") + "\">" + Eval("Form") + "</div>"%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                        <asp:Panel ID="divHeader" runat="server" Style="width: 970px;">
                                            <table cellspacing="0" cellpadding="0" border="0" width="970px" class="ListPageHeader ListPageContainer">
                                                <tr>
                                                    <td width="14%">
                                                        <asp:Panel ID="EffectiveFrom" runat="server" SortId="DateTime" CssClass="SortLabel">
                                                            EffectiveFrom
                                                        </asp:Panel>
                                                    </td>
                                                    <td width="14%">
                                                        <asp:Panel ID="Individual" runat="server" SortId="Individual" CssClass="SortLabel">
                                                            Individual
                                                        </asp:Panel>
                                                    </td>
                                                    <td width="14%">
                                                        <asp:Panel ID="Program" runat="server" SortId="Program" CssClass="SortLabel">
                                                            Program
                                                        </asp:Panel>
                                                    </td>
                                                    <td width="14%">
                                                        <asp:Panel ID="LOI" runat="server" SortId="LOI" CssClass="SortLabel">
                                                            LOI
                                                        </asp:Panel>
                                                    </td>
                                                    <td width="14%">
                                                        <asp:Panel ID="Status" runat="server" SortId="Status" CssClass="SortLabel">
                                                            Status
                                                        </asp:Panel>
                                                    </td>
                                                    <td width="14%">
                                                        <asp:Panel ID="RecorderBy" runat="server" SortId="Status" CssClass="SortLabel">
                                                            Recorder By
                                                        </asp:Panel>
                                                    </td>

                                                    <td width="14%">
                                                        <asp:Panel ID="Form" runat="server" SortId="Form" CssClass="SortLabel">
                                                            Form
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table cellspacing="0" border="1" style="height: 50px" cellpadding="0" width="970px">
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
                        <tr>
                            <td align="left">
                                <asp:Panel ID="PanelPager" runat="server">
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</div>
