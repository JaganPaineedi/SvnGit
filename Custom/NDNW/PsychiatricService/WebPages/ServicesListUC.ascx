<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ServicesListUC.ascx.cs" Inherits="Custom_PsychiatricService_WebPages_ServicesListUC" %>
<div style="width:810px">
<table cellpadding="0" cellspacing="0" border="0" width="100%" style="padding-top: 5px;cursor: default;">
<tr style="height: 4px;"></tr>
<tr>
    <td>
        <table cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr>
               
                <td align="left"  style ="font-size: 0px; vertical-align: bottom;">
                    <img style="vertical-align: bottom;" height="5" width="100%" alt="" src="<%=RelativePath1%>App_Themes/Includes/images/top.jpg" />
                </td>
            </tr>
        </table>
    </td>
   </tr>
<tr>
<td class="content_tab_bg_padding">
<table width="100%">
    <tr>
        <td width="100%">
        <div id="Div1" width="100%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="100%">
                       <asp:ListView ID="lvServices" runat="server" OnLayoutCreated="LayoutCreated"
                        OnItemDataBound="lvServices_ItemDataBound">
                        <LayoutTemplate>
                            <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                <tr>
                                    <td>
                                        <asp:Panel ID="divHeader" runat="server" Style="width: 100%; margin-right: 18px;
                                            padding-top: 0px" CssClass="ListPageHeader">
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                 <tr>
                                                    <td width="14%">
                                                        <div id="DateOfService" style="float: left;" runat="server">
                                                            <span  style="cursor:pointer;text-decoration: underline;" onclick ="SortColumn('DOS','imgsort')">DOS</span>
                                                            <img id="imgsort" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                    <td width="8%">
                                                        <div id="Status" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;"onclick ="SortColumn('Status','imgSortStatus')">Status</span>
                                                            <img id="imgSortStatus" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                     <td width="20%">
                                                        <div id="Document" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;" onclick ="SortColumn('Document','imgSortDocument')">Document</span>
                                                            <img id="imgSortDocument" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                    <td width="20%">
                                                        <div id="Procedure" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;" onclick ="SortColumn('ProcedureCode','imgSortProcedureCode')">Procedure</span>
                                                            <img id="imgSortProcedureCode" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                    <td width="16%">
                                                        <div id="Clinician" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;"  onclick ="SortColumn('Clinician','imgSortClinician')">Clinician</span>
                                                             <img id="imgSortClinician" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                    <td width="12%">
                                                        <div id="Program" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;"  onclick ="SortColumn('Program','imgSortProgram')">Program</span>
                                                            <img id="imgSortProgram" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                     <td width="10%">
                                                        <div id="Comment" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;"  onclick ="SortColumn('Comment','imgSortComment')">Comment</span>
                                                            <img id="imgSortComment" src="<%=RelativePath1%>MySkins/Grid/SortDesc.gif" alt="show" style="display: none;
                                        float:right " /></div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:Panel ID="divListPageContent" runat="server" Style="width: 100%; height: 100px;"
                                            CssClass="ListPageContent">
                                            <table width="100%" cellspacing="0" cellpadding="0">
                                                <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                               
                                <td width="14%" align="left">
                                    <%# Eval("DOS")%>
                                </td>
                                <td width="8%" align="left">
                                    <%# Eval("Status")%>
                                </td>
                                <td width="21%" align="left">
                                   <span style="text-decoration: underline;" onclick="OpenDocumentPage(<%# Eval("ServiceId")%>, <%# Eval("DocumentId")%>);" > <%# Eval("Document")%></span>
                                </td>
                                 <td width="20%" align="left">
                                    <%# Eval("ProcedureCode")%>
                                </td>
                                 <td width="17%" align="left">
                                    <%# Eval("Clinician")%>
                                </td>
                                <td width="12%" align="left">
                                    <%# Eval("Program")%>
                                </td>
                                <td width="10%" align="left">
                                    <%# Eval("Comment")%>
                                </td>
                            </tr>
                          
                        </ItemTemplate>
                         <EmptyDataTemplate>
                            <asp:Panel ID="divHeader" runat="server" Style="width: 100%;">
                                <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                    <tr>
                                        <td>
                                            <asp:Panel ID="Panel2" runat="server" Style="width: 100%; padding-top: 0px" CssClass="ListPageHeader">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                     <tr>
                                                        <td width="14%">
                                                        <div id="DateOfService" style="float: left;" runat="server">
                                                            <span  style="cursor:pointer;text-decoration: underline;">DOS</span>
                                                            </div>
                                                    </td>
                                                    <td width="8%">
                                                        <div id="Status" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;">Status</span>
                                                            </div>
                                                    </td>
                                                        <td width="20%">
                                                        <div id="Document" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;">Document</span>
                                                            </div>
                                                    </td>
                                                    <td width="20%">
                                                        <div id="Procedure" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;">Procedure</span>
                                                            </div>
                                                    </td>
                                                    <td width="16%">
                                                        <div id="Clinician" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;">Clinician</span>
                                                             </div>
                                                    </td>
                                                    <td width="12%">
                                                        <div id="Program" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;">Program</span>
                                                           </div>
                                                    </td>
                                                     <td width="10%">
                                                        <div id="Comment" style="float: left;" runat="server">
                                                            <span style="text-decoration: underline;" >Comment</span>
                                                            </div>
                                                    </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
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
                <tr>
                    <td align="left">
                        <asp:Panel ID="Panel1" runat="server">
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
        </td> 
    </tr> 
</table> 
</td> 
</tr> 
<tr>
<td>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
        <td class="right_bottom_cont_bottom_bg" width="2">
            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath1%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
        </td>
        <td class="right_bottom_cont_bottom_bg" width="100%">
        </td>
        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath1%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
        </td>
    </tr>
</table>
</td>
</tr>
</table> 
</div> 