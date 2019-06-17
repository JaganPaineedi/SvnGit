<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreatmentPlanHarborAjaxScript.aspx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_HarborTreatmentPlan_TreatmentPlanHarborAjaxScript"
    ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
 
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script src="<%=RelativePath %>Custom/Scripts/HarborTreatmentPlan.js" type="text/javascript"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        ##STARTPAGERESPONSEVALUE##
        <asp:PlaceHolder ID="PlaceHolderControlAssociatedNeeds" runat="server"></asp:PlaceHolder>
        ##ENDPAGERESPONSEVALUE##
    </div>
    <asp:Panel ID="PanelGridView" runat="server">
    </asp:Panel>
    <asp:Panel ID="PanelGridViewProcedure" runat="server">
        <%-- <dxwgv:ASPxGridView ID="GridViewProcedureAssignProcedure" runat="server" AutoGenerateColumns="False"
                                Width="100%" CellPadding="0" ClientInstanceName="grid" 
                                KeyFieldName="TPProcedureId" 
                                OnHtmlRowPrepared=GridViewProcedureAssignProcedure_HtmlRowPrepared 
                                EnableCallBacks="False">
                                <Settings GridLines="None" />
                                <Styles AlternatingRow-BackColor="#f0f6f9" AlternatingRow-CssClass="" Row-CssClass="">
                                    <AlternatingRow BackColor="#F0F6F9">
                                    </AlternatingRow>
                                </Styles>
                             
                                <Columns>
                                    <dxwgv:GridViewDataTextColumn Width="6%" Caption="ID" FieldName="TPProcedureId" VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        <span id="HeaderTPProcedureId" onclick="javascript:SortProcedureRecord('TPProcedureId');return false;" style="text-decoration:underline">
                                        ID
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <asp:Button ID="ButtonProcedureLink" BorderStyle="None" Text='<%# Eval("TPProcedureId") %>'
                                                runat="server" BackColor="White" Font-Underline="True" ForeColor="#3399FF" onmouseover="this.style.cursor='hand'"  />
                                           
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="15%" Caption="Provider" FieldName="ProviderName"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderProviderName" onclick="javascript:SortProcedureRecord('ProviderName');return false;" style="text-decoration:underline">
                                        Provider
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                      
                                            <span id="Span_ProviderName" name="Span_ProviderName" >
                                                <%# Eval("ProviderName") %></span>
                                               
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="12%" Caption="Auth Code" FieldName="AuthorizationCodeName"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderAuthorizationCodeName" onclick="javascript:SortProcedureRecord('AuthorizationCodeName');return false;" style="text-decoration:underline">
                                        Auth Code
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_AuthorizationCodeName" name="Span_AuthorizationCodeName">
                                                <%# Eval("AuthorizationCodeName")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="9%" Caption="From" FieldName="StartDate" VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        <span id="HeaderFrom" onclick="javascript:SortProcedureRecord('StartDate');return false;" style="text-decoration:underline">
                                       From
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_StartDate" name="Span_StartDate">
                                                <%# Eval("StartDate", "{0:MM/dd/yyyy}")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="9%" Caption="To" FieldName="EndDate" VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        <span id="HeaderTo" onclick="javascript:SortProcedureRecord('EndDate');return false;" style="text-decoration:underline">
                                       To
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_EndDate" name="Span_EndDate">
                                                <%# Eval("EndDate", "{0:MM/dd/yyyy}")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="12%" Caption="Requested Units" FieldName="TotalUnits"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderUnits" onclick="javascript:SortProcedureRecord('TotalUnits');return false;" style="text-decoration:underline">
                                       Requested Units
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_TotalUnits" name="Span_TotalUnits">
                                                <%# Eval("TotalUnits")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="8%" Caption="Freq" FieldName="FrequencyRequestedName"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderFrequencyRequestedName" onclick="javascript:SortProcedureRecord('FrequencyRequestedName');return false;" style="text-decoration:underline">
                                       Freq
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_FrequencyRequestedName" name="Span_FrequencyRequestedName">
                                                <%# Eval("FrequencyRequestedName")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="9%" Caption="From" FieldName="StartDateApproved"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                         <HeaderTemplate>
                                        <span id="HeaderFrom" onclick="javascript:SortProcedureRecord('StartDateApproved');return false;" style="text-decoration:underline">
                                       From
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_StartDateApproved" name="Span_StartDateApproved">
                                                <%# Eval("StartDateApproved")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="9%" Caption="To" FieldName="EndDateApproved"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderEndDateApproved" onclick="javascript:SortProcedureRecord('EndDateApproved');return false;" style="text-decoration:underline">
                                       To
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_EndDateApproved" name="Span_EndDateApproved">
                                                <%# Eval("EndDateApproved","{0:MM/dd/yyyy}")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="15%" Caption="Approved Units" FieldName="TotalUnitsApproved"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderEndDateApproved" onclick="javascript:SortProcedureRecord('TotalUnitsApproved');return false;" style="text-decoration:underline">
                                     Approved Units
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_ApprovedUnits" name="Span_ApprovedUnits">
                                                <%# Eval("TotalUnitsApproved")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                    <dxwgv:GridViewDataTextColumn Width="6%" Caption="Freq" FieldName="FrequencyApproved"
                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                        <span id="HeaderFrequencyApproved" onclick="javascript:SortProcedureRecord('FrequencyApproved');return false;" style="text-decoration:underline">
                                     Freq
                                        </span>
                                        </HeaderTemplate>
                                        <DataItemTemplate>
                                            <span id="Span_FrequencyApproved" name="Span_FrequencyApproved">
                                                <%# Eval("FrequencyApproved")%></span>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Left">
                                        </CellStyle>
                                    </dxwgv:GridViewDataTextColumn>
                                </Columns>
                                <SettingsBehavior ColumnResizeMode="NextColumn" />
                             <SettingsBehavior AllowSort="false" />
                            </dxwgv:ASPxGridView>--%>
    </asp:Panel>
    <asp:Panel ID="PanelTxPlanMain" runat="server" CssClass="DocumentScreen" ParentChildControls='True'>
    </asp:Panel>
    ##PAGERESPONSEVALUE2##
    <asp:PlaceHolder ID="PlaceHolderBillingCodes" runat="server"></asp:PlaceHolder>
    ##PAGERESPONSEVALUE2##
    <div>
        ##STARTPAGERESPONSEVALUE3##
        <asp:PlaceHolder ID="PlaceHolderControlAssociatedTPNeeds" runat="server"></asp:PlaceHolder>
        ##ENDPAGERESPONSEVALUE3##
    </div>
    <asp:Panel ID="PanelTxPlanCustomTPNeed" runat="server" CssClass="DocumentScreen"
        ParentChildControls='True' Style="width: 450px">
        <dxwgv:ASPxGridView ID="GridViewCustomTPNeed" runat="server" AutoGenerateColumns="False"
                                        Width="100%" ClientInstanceName="grid" SettingsBehavior-AllowDragDrop="false"
                                        Paddings-PaddingLeft="5px" Paddings-PaddingRight="5px" OnHtmlRowPrepared="GridViewCustomTPNeed_HtmlRowPrepared"
                                        OnHtmlDataCellPrepared="GridViewCustomTPNeed_HtmlDataCellPrepared">
                                        <Settings ShowHorizontalScrollBar="false" ShowVerticalScrollBar="true" VerticalScrollableHeight="200"
                                            GridLines="None" />
                                        <Styles AlternatingRow-BackColor="#f0f6f9" Header-CssClass="HeaderStyle" AlternatingRow-CssClass=""
                                            Row-CssClass=" ">
                                        </Styles>
                                       
                                        <Columns>
                                        <dxwgv:GridViewDataColumn Caption="" Width="10%" VisibleIndex="0"
                                                HeaderStyle-Font-Underline="false" CellStyle-HorizontalAlign="Left">
                                                <DataItemTemplate>
                                                
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                            <dxwgv:GridViewDataColumn Caption="Need Description" Width="40%" VisibleIndex="1"
                                                HeaderStyle-Font-Underline="false" FieldName="NeedText" CellStyle-HorizontalAlign="Left" Settings-AllowSort="false">
                                                <HeaderTemplate>
                                                <span id="NeedDescription" style="color: black; font-size: 11px; cursor: hand; text-decoration: underline;" onclick="sortRows(event,'td:eq(3) label',false);" >Need Description</span>
                                                </HeaderTemplate>
                                                <DataItemTemplate>
                                                
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                            <dxwgv:GridViewDataColumn Caption="Date Identified Need Added To Plan" Width="40%" VisibleIndex="2"
                                                HeaderStyle-Font-Underline="false" FieldName="DateNeedAddedToPlan" CellStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                <span id="DateNeedAddedToPlan" style="color: black; font-size: 11px; cursor: hand; text-decoration: underline;" onclick="sortRows(event,'td:eq(4)',true);" >Date Identified Need Added To Plan</span>
                                                </HeaderTemplate>
                                                <DataItemTemplate>
                                                    <span id="SpanDate"></span>
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                        </Columns>
                                        
                                        <SettingsBehavior ColumnResizeMode="NextColumn" AllowSort="false" />
                                        <SettingsBehavior AllowSort="false" ColumnResizeMode="Disabled" />
                                        <SettingsPager Visible="false" Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <Styles Cell-Wrap="False">
                                        </Styles>
                                    </dxwgv:ASPxGridView>
    </asp:Panel>
    </form>
</body>
</html>
