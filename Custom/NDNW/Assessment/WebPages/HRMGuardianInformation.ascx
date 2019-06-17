<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMGuardianInformation.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMGuardianInformation" %>

<%--<script type="text/javascript" language="javascript" src="../../../../../JScripts/SystemScripts/jquery-1.3.2.js"></script>--%>

<script type="text/javascript" src="<%=RelativePath%>JScripts/SystemScripts/jquery.mcdropdown.js"></script>

<script type="text/javascript" src="<%=RelativePath%>JScripts/SystemScripts/jquery.bgiframe.js"></script>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/AssessmentGuardianInfo.js"></script>
<div style="width: 97%;">
    <table cellpadding="0" cellspacing="0" width="100%" class="LPadd5">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="height1"></td>
                    </tr>
                    <tr>
                        <td class="content_tab_left" align="left" nowrap="nowrap">Guardian Information
                        </td>
                        <td width="17">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                width="17" height="26" alt="" />
                        </td>
                        <td class="content_tab_top" width="100%"></td>
                        <td width="7">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                width="7" height="26" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg">
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td style="width: 86%">
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="LPadd5" style="width: 30%; padding-left: 6px;">
                                        <span id="Span$$CustomHRMAssessments$$GuardianName" class="form_label">Name</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <input type="text" id="TextBox_CustomHRMAssessments_GuardianName" name="TextBox_CustomHRMAssessments_GuardianName"
                                            class="form_textbox" datatype="String" tabindex="1" runat="server" maxlength="150" bindautosaveevents="False"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td id="Span$$CustomHRMAssessments$$GuardianAddress" class="LPadd5" style="padding-left: 6px;">
                                        <span class="form_label">Address</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <textarea id="TextArea_CustomHRMAssessments_GuardianAddress" name="TextArea_CustomHRMAssessments_GuardianAddress"
                                            tabindex="2" cols="20" rows="5" class="form_textarea" datatype="String" runat="server" bindautosaveevents="False"
                                            style="width: 80%"></textarea>


                                        <%--<input type="text" id="TextBox_CustomHRMAssessments_GuardianAddress" name="TextBox_CustomHRMAssessments_GuardianAddress"
                                            tabindex="2" textmode="multiline" maxlength="100" class="form_textarea" datatype="String"
                                            runat="server" style="width: 200px; height: 70px; overflow-x: hidden; overflow-y: scroll;">--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left: 6px;">
                                        <span id="Span$$CustomHRMAssessments$$GuardianPhone" class="form_label">Phone</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <input type="text" id="TextBox_CustomHRMAssessments_GuardianPhone" name="TextBox_CustomHRMAssessments_GuardianPhone"
                                            tabindex="3" class="form_textbox" datatype="PhoneNumber" bindautosaveevents="False"
                                            runat="server" maxlength="50" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left: 6px;">
                                        <span id="Span$$CustomHRMAssessments$$GuardianType" class="form_label">Type of Guardian</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomHRMAssessments_GuardianType"
                                            EnableViewState="false" runat="server" TabIndex="4" Style="width: 82%" bindautosaveevents="False">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" style="width: 14%" align="left" class="RPadd2">
                            <table cellpadding="0" width="30%" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <input type="button" id="buttonOk" name="buttonOk" value="OK" class="less_detail_btn"
                                            tabindex="5" onclick="CheckAddressMaxLength('buttonOk','<%=this.externalURL%>','<%=isPopUp%>');" />
                                        <%--<table cellspacing="0" cellpadding="0" border="0" width="75px">
                                            <tr>
                                                <td class="expandable_btn_left" align="center">
                                                    <%--<input type="button" value="OK" id="buttonOk" name="buttonOk" tabindex="5" onclick="UpdateScreen('buttonUpdate',<%=this.externalURL%>,<%=isPopUp%>);" />-
                                                    <input type="button" value="OK" id="buttonOk" name="buttonOk" tabindex="5" onclick="UpdateScreen('buttonOk','<%=this.externalURL%>','<%=isPopUp%>');" />
                                                </td>
                                                <td class="expandable_btn_right">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" id="buttonCancel" name="buttonCancel" value="Cancel" tabindex="6"
                                            class="less_detail_btn" onclick="parent.CloaseModalPopupWindow();" />

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
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="2" class="right_bottom_cont_bottom_bg">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                height="7" alt="" />
                        </td>
                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                height="7" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomHRMAssessments" />
            </td>
        </tr>
    </table>
</div>
