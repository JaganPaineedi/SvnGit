<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReferralDocument.ascx.cs"
    Inherits="SHS.SmartCare.ReferralDocument" %>
 
<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc5" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<script src="<%=RelativePath%>Custom/Scripts/ReferralFormSender.js" type="text/javascript"></script>

<div style="width: 97%">
    <input id="HiddenField_CustomDocumentReferrals_DocumentVersionId" runat="server"
        type="hidden" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentReferrals,CustomDocumentReferralServices" />
    <%--<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentReferrals" />--%>
    <table width="100%" border="0">
        <tr>
            <td>
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 13%">
                            <span class="form_label" id="Span3">Referral Date</span>
                        </td>
                        <td align="left" width="10%">
                            <input type="text" tabindex="1" name="TextBox_CustomDocumentReferrals_ReferralSentDate"
                                class="date_text" id="TextBox_CustomDocumentReferrals_ReferralSentDate" tabindex="3"
                                datatype="Date" style="width: 100%;" />
                        </td>
                        <td style="width: 3px">
                        </td>
                        <td align="left" width="10%">
                            &nbsp;
                            <img id="Img_RequestDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('TextBox_CustomDocumentReferrals_ReferralSentDate', '%m/%d/%Y');"
                                style="cursor: hand;" filter="false" />
                        </td>
                        <td>
                        </td>
                        <td style="width: 5%;">
                            <span class="form_label" id="Span1">Status</span>
                        </td>
                        <td align="left" style="width: 10%;">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferrals_ReferralStatus"
                                name="DropDownList_CustomDocumentReferrals_ReferralStatus" runat="server" TabIndex="3"
                                Width="100%" >
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
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 13%;">
                            <span class="form_label" id="Span2">Referring Staff</span>
                        </td>
                        <td style="width: 40%;">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferrals_ReferringStaff"
                                name="DropDownList_CustomDocumentReferrals_ReferringStaff" runat="server" TabIndex="4"
                                Width="100%"  >
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
                            <span class="form_label" id="Span4">Assessed<br />
                                Need for Referral</span>
                        </td>
                        <td style="width: 77%;">
                            <textarea id="TextArea_CustomDocumentReferrals_AssessedNeedForReferral" spellcheck="True"
                                name="TextArea_CustomDocumentReferrals_AssessedNeedForReferral" tabindex="5"
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
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 13%">
                            <span class="form_label" id="Span5">Receiving Staff</span>
                        </td>
                        <td style="width: 6%">
                                    <asp:HyperLink ID="HyperLink_help" runat="server" Target="_blank"><asp:Image ID="Image_CustomDocumentTransfers_folder" ImageUrl="~/App_Themes/Includes/Images/images.jpg" runat="server" Height="20px" Width="20px"/></asp:HyperLink>  
                        </td>
                        <td style="width: 35%;">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferrals_ReceivingStaff"
                                name="DropDownList_CustomDocumentReferrals_ReceivingStaff" runat="server" TabIndex="6"
                                Width="100%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1" onchange="BindProgramDropDown()" >
                            </cc2:StreamlineDropDowns>
                        </td>
                        <td style="width: 6%;">
                        </td>
                        <td style="width: 10%;">
                            <span class="form_label" id="Span15">Receiving </span><span class="form_label" id="Span6">
                                Program</span>
                        </td>
                        <td>
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferrals_ReceivingProgram"
                                name="DropDownList_CustomDocumentReferrals_ReceivingProgram" runat="server" TabIndex="7"
                                Width="100%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                            </cc2:StreamlineDropDowns>
                             <input id="TextBox_CustomDocumentReferrals_ReceivingProgram" enabled="enabled"  type="text" style="width:100%;display:none;"  tabindex="24"  "
                                                                    class=".form_textbox"  />
                        </td>
                        <td style="width: 9%;">
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
                            <span id="Span14">Service Recommended</span>
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
                                                    <table width="100%" cellpadding="0" cellspacing="0" id="TableChildControl_CustomDocumentReferralServices">
                                                        <tr>
                                                            <td style="width: 2%;">
                                                                Service
                                                            </td>
                                                            <td style="width: 10%;">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferralServices_AuthorizationCodeId"
                                                                    name="DropDownList_CustomDocumentReferralServices_AuthorizationCodeId" runat="server"
                                                                    TabIndex="8" Width="98%" AddBlankRow="true" parentchildcontrols="True" BlankRowText=""
                                                                    BlankRowValue="-1" ClientInstanceName="DropDownList_CustomDocumentReferralServices_AuthorizationCodeIdDevxInstance">
                                                                </cc2:StreamlineDropDowns>
                                                                <%--  <input id="TextBox_CustomDocumentTransferServices_AuthorizationCodeId" name="TextBox_CustomDocumentTransferServices_AuthorizationCodeName" enabled="enabled" type="text" style="width: 100%"
                                                                                 class=".form_textbox" parentchildcontrols="True" />--%>
                                                            </td>
                                                            <td style="width: 10%;height:100%" valign="top"  >
                                                                <span id="ButtonInsert" name="ButtonInsert" runat="server" type="button" onclick="InsertGridData('TableChildControl_CustomDocumentReferralServices', 'InsertGrid','CustomGrid','ButtonInsert');" ClientIDMode="Static"
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
                                                                <table width="100%" id="TableChildControl_CustomDocumentReferralServices">
                                                                    <tr>
                                                                        <td>
                                                                            <div id="InsertGrid" runat="server" style="width: 78%; overflow-x: hidden; overflow-y: auto;height:180px; " >
                                                                                <uc1:CustomGrid ID="CustomGrid" width="100%" style="min-width:100%; " runat="server" TableName="CustomDocumentReferralServices"
                                                                                    PrimaryKey="ReferralServiceId" CustomGridTableName="TableChildControl_CustomDocumentReferralServices"
                                                                                    ColumnName="AuthorizationCodeIdText"  ColumnHeader="Service" ColumnWidth="100%" ColumnFormat=":" 
                                                                                    GridPageName="CustomDocumentReferralServices" DivGridName="InsertGrid"
                                                                                    DoNotDisplayRadio="True" InsertButtonId="ButtonInsert" DoNotDisplayDeleteImage="false" />
                                                                               
                                                                            </div>
                                                                            <input type="hidden" id="HiddenField_CustomDocumentReferralServices_ReferralServiceId"
                                                                                name="HiddenField_CustomDocumentReferralServices_ReferralServiceId" value="-1" parentchildcontrols="True" />
                                                                                
                                                                            <input type="hidden" parentchildcontrols="True"  id="HiddenFieldPrimaryKeyReferralServiceId" name="HiddenFieldPrimaryKeyReferralServiceId"
                                                                               value="ReferralServiceId"  />
                                                                              <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentReferralServices_DocumentVersionId"
                                                                                name="HiddenField_CustomDocumentReferralServices_DocumentVersionId"  value="-1" />
   
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
                            <input type="checkbox" id="CheckBox_CustomDocumentReferrals_ClientParticpatedWithReferral"
                                name="CheckBox_CustomDocumentReferrals_ClientParticpatedWithReferral" tabindex="10" />
                            <label id="Label_CustomDocumentReferrals_BenefitsHealthInsurance" style="vertical-align: top;"
                                for="CheckBox_CustomDocumentReferrals_BenefitsHealthInsurance">
                                Client has participated and is in agreement with this referral</label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                            <input type="checkbox" id="CheckBox_CustomDocumentReferrals_RemoveClientFromCaseLoad"
                                name="CheckBox_CustomDocumentReferrals_RemoveClientFromCaseLoad" tabindex="11" />
                            <label id="Label1" style="vertical-align: top;" for="CheckBox_CustomDocumentReferrals_BenefitsHealthInsurance">
                                Remove this client from the referring staff’s non-primary caseload upon referral
                                acceptance</label>
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
                <table id="table_CommentAndAction" >
                    <tr>
                        <td style="width: 3%">
                            <span class="form_label" id="Span8" >Comment</span>
                        </td>
                        <td style="width: 35%">
                            <textarea id="TextArea_CustomDocumentReferrals_ReceivingComment" spellcheck="True"
                                name="TextArea_CustomDocumentReferrals_ReceivingComment" tabindex="12" style="width: 100%;
                                height: 60px; "></textarea>
                        </td>
                        <td style="width: 4%">
                        </td>
                        <td style="width: 6%">
                            <span class="form_label" id="Span10" >Receiving Action</span>
                        </td>
                        <td style="width: 10%">
                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReferrals_ReceivingAction"
                                name="DropDownList_CustomDocumentReferrals_ReceivingAction" runat="server" TabIndex="13"
                                Width="100%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1" >
                            </cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
                <input type="hidden" runat="server" id="hiddenProgramList" name="hiddenProgramList" value="" />
            </td>
        </tr>
    </table>
</div>
