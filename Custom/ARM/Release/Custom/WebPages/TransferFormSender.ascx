<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TransferFormSender.ascx.cs"
    Inherits="SHS.SmartCare.TransferFormSender" %>

<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc5" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<script src="<%=RelativePath%>Custom/Scripts/TransferFormSender.js" type="text/javascript"></script>

<div style="width: 97%">
 <input id="HiddenField_CustomDocumentTransfers_DocumentVersionId" name="HiddenField_CustomDocumentTransfers_DocumentVersionId" runat="server"
        type="hidden" />
          
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentTransfers" />
    <table width="100%" border="0">
        <tr>
            <td>
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 13%">
                            <span class="form_label" id="Span3">Request Date</span>
                        </td>
                        <td align="left" width="10%">
                            <input type="text" tabindex="3" name="TextBox_CustomDocumentTransfers_ReceivingActionDate"
                                class="date_text" id="TextBox_CustomDocumentTransfers_ReceivingActionDate" tabindex="3"
                                datatype="Date" style="width: 100%;" />
                        </td>
                        <td style="width: 3px">
                        </td>
                        <td align="left" width="10%">
                            &nbsp;
                            <img id="Img_RequestDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('TextBox_CustomDocumentTransfers_ReceivingActionDate', '%m/%d/%Y');"
                                style="cursor: hand;" filter="false" />
                        </td>
                        <td>
                        </td>
                        <td style="width: 5%;">
                            <span class="form_label" id="Span1">Status</span>
                        </td>
                        <td align="left" style="width: 10%;">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_TransferStatus"
                                name="DropDownList_CustomDocumentTransfers_TransferStatus" runat="server" TabIndex="8"
                                Width="100%"   Enabled="false"  >
                            </cc2:StreamlineDropDowns>
                        </td>
                        <td width="50%">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 13%;">
                            <span class="form_label" id="Span2">From Staff</span>
                        </td>
                        <td style="width: 40%;">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_TransferringStaff"
                                name="DropDownList_CustomDocumentTransfers_TransferringStaff" runat="server"
                                TabIndex="8" Width="100%" BlankRowText="" >
                            </cc2:StreamlineDropDowns>
                        </td>
                        <td style="width: 50%;">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 13%; vertical-align: top;">
                            <span class="form_label" id="Span4">Reason / Assessed<br />
                                &nbsp;Need for Transfer</span>
                        </td>
                        <td style="width: 77%;">
                            <textarea id="TextArea_CustomDocumentTransfers_AssessedNeedForTransfer" spellcheck="True"
                                name="TextArea_CustomDocumentTransfers_AssessedNeedForTransfer" tabindex="25"
                                style="width: 100%; height: 60px;"></textarea>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="width: 13%">
                                    <span class="form_label" id="Span5">Receiving Staff</span>
                                </td>
                                <td style="width: 3%">
                                    <asp:HyperLink ID="HyperLink_help" runat="server" Target="_blank"><asp:Image ID="Image_CustomDocumentTransfers_folder" ImageUrl="~/App_Themes/Includes/Images/images.jpg" runat="server" Height="20px" Width="20px"/></asp:HyperLink>  
                                </td>
                                <td style="width: 35%;">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_ReceivingStaff"
                                        name="DropDownList_CustomDocumentTransfers_ReceivingStaff" runat="server" TabIndex="8"
                                        Width="100%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td style="width: 6%;">
                                </td>
                                <td style="width: 8%;">
                                    <span class="form_label" id="Span6">Rec. Program</span>
                                    <input id="TextBox_CustomDocumentTransfers_ReceivingProgram" enabled="enabled"  type="text" style="width:100%;display:none;"  tabindex="24" 
                                                                    class=".form_textbox"  />
                                </td>
                                <td>
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_ReceivingProgram"
                                        name="DropDownList_CustomDocumentTransfers_ReceivingProgram" runat="server" TabIndex="8"
                                        Width="98%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td style="width: 9%;">
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span7">Level of Care</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" colspan="4">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr style="height: 3px;">
                                    <td colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 3px;">
                                    </td>
                                    <td>
                                        <table width="100%"  cellspacing="0">
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="0" cellspacing="0" id="Table1">
                                                        <tr>
                                                            <td style="width: 12%;padding-left:5px;">
                                                               Current Level of Care
                                                            </td>
                                                            <td style="width: 40%;">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_LevelofCare"
                                                                    name="DropDownList_CustomDocumentTransfers" runat="server"
                                                                    TabIndex="9" Width="98%" AddBlankRow="true" BlankRowText=""
                                                                    BlankRowValue="">
                                                                </cc2:StreamlineDropDowns>
                                                                <%--  <input id="TextBox_CustomDocumentTransferServices_AuthorizationCodeId" name="TextBox_CustomDocumentTransferServices_AuthorizationCodeName" enabled="enabled" type="text" style="width: 100%"
                                                                                 class=".form_textbox" parentchildcontrols="True" />--%>
                                                            </td>
                                                            <td style="width: 48%;height:100%" valign="top"  >
                                                            
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
                        <td colspan="4">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="right_bottom_cont_bottom_bg" width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span14">Service Recommended(Specify if client is not currently receving services
                                from receiving staff)</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" colspan="4">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr style="height: 3px;">
                                    <td colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 3px;">
                                    </td>
                                    <td>
                                        <table width="100%"  cellspacing="0">
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="0" cellspacing="0" id="TableChildControl_CustomDocumentTransferServices">
                                                        <tr>
                                                            <td style="width: 1%;padding-left:5px;">
                                                                Service
                                                            </td>
                                                            <td style="width: 10%;">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransferServices_AuthorizationCodeId"
                                                                    name="DropDownList_CustomDocumentTransferServices_AuthorizationCodeId" runat="server"
                                                                    TabIndex="10" Width="98%" AddBlankRow="true" parentchildcontrols="True" BlankRowText=""
                                                                    BlankRowValue="-1">
                                                                </cc2:StreamlineDropDowns>
                                                                <%--  <input id="TextBox_CustomDocumentTransferServices_AuthorizationCodeId" name="TextBox_CustomDocumentTransferServices_AuthorizationCodeName" enabled="enabled" type="text" style="width: 100%"
                                                                                 class=".form_textbox" parentchildcontrols="True" />--%>
                                                            </td>
                                                            <td style="width: 10%;height:100%" valign="top"  >
                                                                <span id="ButtonInsert" name="ButtonInsert" runat="server" type="button" onclick="InsertGridData('TableChildControl_CustomDocumentTransferServices', 'InsertGrid','CustomGrid','ButtonInsert');"
                                                                    style="width: 100%;" text="Insert"></span>
                                                                <span id="ButtonInsertDummy"  type="button" onclick="" style="width: 100%;display:none;" text="Insert"></span>
                                                            </td>
                                                        </tr>
                                                        <tr style="height: 3px;">
                                                            <td colspan="3">
                                                            </td>
                                                        </tr>
                                                        
                                                        <tr style="height: 3px;">
                                                            <td colspan="3">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <table width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <div id="InsertGrid" runat="server" style="width: 78%; overflow-x: hidden; overflow-y: auto;height:180px; "
                                                                                >
                                                                                <uc1:CustomGrid ID="CustomGrid" width="100%" style="min-width:100%; " runat="server" TableName="CustomDocumentTransferServices"
                                                                                    PrimaryKey="TransferServiceId" CustomGridTableName="TableChildControl_CustomDocumentTransferServices"
                                                                                    ColumnName="AuthorizationCodeIdText" ColumnFormat=":" ColumnHeader="Service"
                                                                                    ColumnWidth="100%" GridPageName="CustomDocumentTransferServices" DivGridName="InsertGrid"
                                                                                    DoNotDisplayRadio="True" InsertButtonId="ButtonInsert" DoNotDisplayDeleteImage="false" />
                                                                               
                                                                            </div>
                                                                            <input type="hidden" id="HiddenField_CustomDocumentTransferServices_TransferServiceId"
                                                                                name="HiddenField_CustomDocumentTransferServices_TransferServiceId" value="-1" parentchildcontrols="True" />
                                                                                
                                                                            <input type="hidden" parentchildcontrols="True"  id="HiddenFieldPrimaryKeyTransferServiceId" name="HiddenFieldPrimaryKeyTransferServiceId"
                                                                                value="TransferServiceId" />
                                                                              <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentTransferServices_DocumentVersionId"
                                                                                name="HiddenField_CustomDocumentTransferServices_DocumentVersionId"  value="-1" />
   
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
                        <td colspan="4">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="right_bottom_cont_bottom_bg" width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 3px;">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                            <input type="checkbox" id="CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer"
                                name="CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer" tabindex="16" />
                            <label id="Label_CustomDocumentTransfers_ClientParticpatedWithTransfer" style="vertical-align: top;"
                                for="CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer">
                                Client has participated and is in agreement with this transfer</label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 50%;">
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table id="table_CommentAndAction">
                    <tr>
                        <td style="width: 3%">
                            <span class="form_label" id="Span8">Comment</span>
                        </td>
                        <td style="width: 35%">
                            <textarea id="TextArea_CustomDocumentTransfers_ReceivingComment" spellcheck="True"
                                name="TextArea_CustomDocumentTransfers_ReceivingComment" tabindex="25" style="width: 100%;
                                height: 60px;"></textarea>
                        </td>
                        <td style="width: 4%">
                        </td>
                        <td style="width: 5%">
                            <span class="form_label" id="Span10">Receiving Action</span>
                        </td>
                        <td style="width: 9%">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTransfers_ReceivingAction"
                                name="DropDownList_CustomDocumentTransfers_ReceivingAction" runat="server" TabIndex="8"
                                Width="100%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                            </cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <input type="hidden" runat="server" id="hiddenProgramList" name="hiddenProgramList" value="" />
</div>
