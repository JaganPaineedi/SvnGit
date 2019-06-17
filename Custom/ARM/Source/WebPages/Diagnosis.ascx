<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" CodeFile="Diagnosis.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Documents_Diagnosis" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DropDownGlobalCodes" Namespace="Streamline.DropDownGlobalCodes"
    TagPrefix="cc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/Diagnosis.js"></script>
<div style="width:830px">
<table cellpadding="0" cellspacing="0" border="0" style="width: 99.5%">
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td valign="top" align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Axis I-II
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%" />
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg" style="padding-right: 8px">
                                                <table cellspacing="0" id="TableChildControl_DiagnosesIAndII" parentchildcontrols="True"
                                                    clearcontrol="true" cellpadding="0" border="0" width="99%">
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" width="41%" class="RadioText">
                                                            <span class="form_label" style="padding-left: 10px">Mental Health/Development Diagnosis
                                                                (Axis I-II)</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2" />
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                <tr>
                                                                    <td>
                                                                        <input parentchildcontrols="True" type="hidden" id="HiddenFieldOrder" name="HiddenFieldOrder" />
                                                                        <input parentchildcontrols="True" type="hidden" id="HiddenFieldHighestOrder" name="HiddenFieldHighestOrder" />
                                                                        <input parentchildcontrols="false" type="hidden" id="HiddenFieldMaximumRecords" name="HiddenFieldMaximumRecords" />
                                                                        <input parentchildcontrols="false" type="hidden" id="HiddenField_DiagnosesIANDIIMaxOrder_DiagnosesMaxOrder"
                                                                            name="HiddenField_DiagnosesIANDIIMaxOrder_DiagnosesMaxOrder" />
                                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                            <tr>
                                                                                <td valign="middle" align="left" style="width: 10%">
                                                                                    <span class="form_label" id="SpanCode" style="padding-left: 10px" name="SpanCode">Code</span>
                                                                                </td>
                                                                                <td valign="middle" align="left" style="width: 30%;">
                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <input parentchildcontrols="True" bindautosaveevents="False" style="width: 50px;"
                                                                                                    class="form_textbox" type="text" id="TextBox_DiagnosesIAndII_DSMCode" baseurl="<%=ResolveUrl("~") %>"
                                                                                                    name="TextBox_DiagnosesIAndII_DSMCode" onchange="return openDiagnosisIandIIPopUp(this,'<%=ResolveUrl("~") %>');"
                                                                                                    required="true" onkeypress="ToggleDescriptionLabelAndTextBox(this);" />
                                                                                            </td>
                                                                                            <td align="left" valign="middle">
                                                                                                <span class="form_label" id="SpanAxis" name="SpanAxis"></span>
                                                                                            </td>
                                                                                            <td align="center" valign="middle">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_DiagnosesIAndII_RuleOut" bindautosaveevents="False"
                                                                                                                parentchildcontrols="True" name="CheckBox_DiagnosesIAndII_RuleOut" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label id="Out" name="Out" for="CheckBox_DiagnosesIAndII_RuleOut">
                                                                                                                Rule Out</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td align="left" valign="middle" style="width: 10%;">
                                                                                    <span id="SpanType" class="form_label" name="SpanType">Type</span>
                                                                                </td>
                                                                                <td align="left" valign="middle" style="width: 50%;">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                        <tr>
                                                                                            <td style="width: 33%;">
                                                                                                <asp:DropDownList ParentChildControls="True" bindautosaveevents="False" EnableViewState="false"
                                                                                                    ID="DropDownList_DiagnosesIAndII_DiagnosisType" runat="server" Width="100%" CssClass="form_dropdown"
                                                                                                    required="true">
                                                                                                </asp:DropDownList>
                                                                                            </td>
                                                                                            <td style="width: 33%;" align="center">
                                                                                                <%--<span id="SpanSaverity" class="form_label" name="SpanSaverity">Severity</span>--%>
                                                                                                <span id="SpanRemission" class="form_label" name="SpanRemission">Remission</span>
                                                                                            </td>
                                                                                            <td style="width: 34%;">
                                                                                                <%--<cc1:DropDownGlobalCodes Category="DxRemissionType" AddBlankRow="true" ID="DropDownList_DiagnosesIAndII_Remission"
                                                                                            runat="server" CssClass="form_dropdownWithoutWidth" TabIndex="2">
                                                                                        </cc1:DropDownGlobalCodes>--%>
                                                                                                <asp:DropDownList ParentChildControls="True" bindautosaveevents="False" EnableViewState="false"
                                                                                                    ID="DropDownList_DiagnosesIAndII_Remission" runat="server" Width="100%" CssClass="form_dropdown">
                                                                                                </asp:DropDownList>
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
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 100%">
                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                <tr>
                                                                    <td style="width: 10%;" align="left" valign="top">
                                                                        <span class="form_label" name="SpanDescription" style="padding-left: 10px" id="SpanDescription">
                                                                            Description</span>
                                                                    </td>
                                                                    <td valign="top" align="left" style="width: 30%;">
                                                                        <span id="Span_DiagnosesIAndII_DSMDescription" parentchildcontrols="True" class="form_label_dfa"
                                                                            name="Span_DiagnosesIAndII_DSMDescription" bindautosaveevents="False"></span>
                                                                        <textarea rows="4" cols="42" bindautosaveevents="False" class="form_textareaWithoutWidth" onblur="return openDiagnosisIWindowForDescription(this,'<%=ResolveUrl("~") %>');"
                                                                            id="TextBoxDSMDescription" baseurl="<%=ResolveUrl("~") %>" name="TextBoxDSMDescription"></textarea>
                                                                    </td>
                                                                    <td align="left" valign="top" style="width: 10%;">
                                                                        <span class="form_label" id="SpanSource" name="SpanSource">Source</span>
                                                                    </td>
                                                                    <td valign="top">
                                                                        <textarea id="TextArea_DiagnosesIAndII_Source" bindautosaveevents="False" parentchildcontrols="True"
                                                                            class="form_textareaWithoutWidth" name="TextArea_DiagnosesIAndII_Source" rows="4" cols="76"
                                                                            spellcheck="True"></textarea>
                                                                    </td>
                                                                </tr>
                                                                <!-- Added by Anuj on 13July,2010-->
                                                                <tr>
                                                                    <td class="height2" colspan="4">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width: 10%;" align="left" valign="top">
                                                                        <span class="form_label" name="SpanOrder" style="padding-left: 10px" id="SpanOrder">
                                                                            Order</span>
                                                                    </td>
                                                                    <td valign="top" align="left" style="width: 30%;">
                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td style="width: 25%;">
                                                                                    <input style="width: 50px;" runat="server" class="form_textbox" type="text" id="TextBox_DiagnosesIAndII_DiagnosisOrder"
                                                                                        donotclear="true" onkeypress="RetainOrderForDiagnosisIandII(this);" parentchildcontrols="True"
                                                                                        bindautosaveevents="False" name="TextBox_DiagnosesIAndII_DiagnosisOrder" maxlength="2"
                                                                                        value="1" />
                                                                                </td>
                                                                                <td style="width: 75%;">
                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr>
                                                                                            <td align="left" valign="middle">
                                                                                                <span id="Billable" class="form_label" name="Billable">Billable</span>
                                                                                            </td>
                                                                                            <td align="left">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="radio" parentchildcontrols="True" bindautosaveevents="False" checked="checked"
                                                                                                                id="RadioButton_DiagnosesIAndII_BillableYes_Y" name="RadioButton_DiagnosesIAndII_Billable"
                                                                                                                value="Y" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="RadioButton_DiagnosesIAndII_BillableYes_Y">
                                                                                                                Yes</label>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <input type="radio" parentchildcontrols="True" id="RadioButton_DiagnosesIAndII_BillableNo_N"
                                                                                                                name="RadioButton_DiagnosesIAndII_Billable" bindautosaveevents="False" value="N" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="RadioButton_DiagnosesIAndII_BillableNo_N">
                                                                                                                No</label>
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
                                                                    <td colspan="2">
                                                                        <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td valign="top" align="right" style="width: 80%;">
                                                                                    <table cellspacing="0" cellpadding="0" border="0" width="70px">
                                                                                        <tr>
                                                                                            <td align="center">
                                                                                                <input type="button" id="TableChildControl_DiagnosesIAndII_ButtonInsert" name="TableChildControl_DiagnosesIAndII_ButtonInsert"
                                                                                                    baseurl="<%=ResolveUrl("~") %>" onclick="return  InsertDiagnosesIAndIIGridData(this,'TableChildControl_DiagnosesIAndII','InsertGrid','CustomGrid','<%=ResolveUrl("~") %>');"
                                                                                                    value="Insert" class="parentchildbutton" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td style="width: 1%;">
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td style="width: 19%;">
                                                                                    <table cellspacing="0" cellpadding="0" border="0" style="width: 70px">
                                                                                        <tr>
                                                                                            <td align="center">
                                                                                                <input type="button" id="ButtonClear" onclick="ClearDiagnosisIandII();ClearTable('TableChildControl_DiagnosesIAndII','TableChildControl_DiagnosesIAndII_ButtonInsert',false);"
                                                                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <!-- Ended over here -->
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2" />
                                                    </tr>
                                                    <tr>
                                                        <td align="left" style="padding-left: 8px" id="CustomGridContainer">
                                                            <div id="InsertGrid" style="overflow-x: hidden; overflow-y: auto; height: 100px;
                                                                width: 100%;">
                                                                <%--/*Added By: Amit Kumar Srivastava, 
                                                                 From: Javed Husain [mailto:jhusain@streamlinehealthcare.com]
                                                                Sent: 30 June 2012 02:45
                                                                To: Devinder Pal Singh
                                                                Subject: Diagnosis Order
                                                                Hi Devinder,
                                                                    We need to get a fix for the Diagnosis Order issue tomorrow.
                                                                    Also, I am thinking that we should display the order and also allow for duplicates so user has complete control on how they wish to order them.
                                                                Thanks,
                                                                */ --%>
                                                                <%--<uc1:CustomGrid ID="CustomGrid" runat="server" TableName="DiagnosesIAndII" PrimaryKey="DiagnosisId"
                                                                    CustomGridTableName="TableChildControl_DiagnosesIAndII" GridPageName="diagnosis"
                                                                    ColumnName="Axis:DSMCode:RuleOutText:DSMDescription:Source" ColumnHeader="Axis:DSM Code:Rule Out:DSM Description:Source"
                                                                    ColumnWidth="80:90:90:130:240" DivGridName="InsertGrid" InsertButtonId="TableChildControl_DiagnosesIAndII_ButtonInsert" ValidateClientSideMethodName="ValidateParentChildDiagnosis()" />--%>
                                                                <uc1:CustomGrid ID="CustomGrid" runat="server" TableName="DiagnosesIAndII" PrimaryKey="DiagnosisId"
                                                                    CustomGridTableName="TableChildControl_DiagnosesIAndII" GridPageName="diagnosis"
                                                                    ColumnName="Axis:DiagnosisOrder:DSMCode:RuleOutText:DSMDescription:Source" ColumnHeader="Axis:Order:DSM Code:Rule Out:DSM Description:Source"
                                                                    ColumnWidth="40:40:90:90:130:240" DivGridName="InsertGrid" InsertButtonId="TableChildControl_DiagnosesIAndII_ButtonInsert"  OrderByQuery="PrimaryColumn, DiagnosisOrder"  />                                                                   
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenField_DiagnosesIAndII_DiagnosisId"
                                                                name="HiddenField_DiagnosesIAndII_DiagnosisId" value="" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenField_DiagnosesIAndII_DSMNumber"
                                                                name="HiddenField_DiagnosesIAndII_DSMNumber" />
                                                            <input type="hidden" id="HiddenField_DiagnosesIAndII_DocumentVersionId" value="-1"
                                                                name="HiddenField_DiagnosesIAndII_DocumentVersionId" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey"
                                                                value="DiagnosisId" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey"
                                                                value="DocumentVersionId" />
                                                            <input type="hidden" parentchildcontrols="True" id="HiddenField_DiagnosesIAndII_Axis"
                                                                name="HiddenField_DiagnosesIAndII_Axis" />
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
                            <tr>
                                <td>
                                    <table id="TableAxisIII" cellspacing="0" cellpadding="0" border="0" width="100%"
                                        group="AxisIII">
                                        <tr>
                                            <td class="height4">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Axis III <span id="Group_AxisIII"></span>
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%" />
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg_padding">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left">
                                                            <span class="form_label_text">General Medical Conditions (Axis III)</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height3">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                <tr>
                                                                    <td class="form_label_text" align="left">
                                                                        Specify
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height1">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" valign="top">
                                                                        <input type="hidden" id="HiddenField_DiagnosesIII_DocumentVersionId" value="-1" name="HiddenField_DiagnosesIII_DocumentVersionId" />
                                                                        <textarea class="form_textareaWithoutWidth" id="TextArea_DiagnosesIII_Specification" name="TextArea_DiagnosesIII_Specification"
                                                                            cols="155" rows="5" spellcheck="True"></textarea>
                                                                    </td>
                                                                </tr>
                                                                <!--Added By Anuj to Change Diagnosis III-->
                                                                <tr>
                                                                    <td id="TdHRMAssesmentAxisIII" style="display: none;" visible="false">
                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td class="height2">
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="left">
                                                                                    <span class="form_label" style="padding-left: 0px" id="SpanHRMAssessment" name="SpanHRMAssessment">
                                                                                        The Client has the following non-temporary physical condition that impact(s) their
                                                                                        ability to engage in activites of daily living?</span>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="height2">
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="left">
                                                                                    <table width="100%" cellpadding="2" cellspacing="5" border="0">
                                                                                        <tr>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionQuadriplegic"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionQuadriplegic" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionQuadriplegic">
                                                                                                                Quadriplegic</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionMultipleSclerosis"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionMultipleSclerosis" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionMultipleSclerosis">
                                                                                                                Multiple Sclerosis</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionBlindness"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionBlindness" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionBlindness">
                                                                                                                Blindness</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionDeafness"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionDeafness" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionDeafness">
                                                                                                                Deafness</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionParaplegic"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionParaplegic" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionParaplegic">
                                                                                                                Paraplegic</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionCerebral"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionCerebral" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionCerebral">
                                                                                                                Cerebral Palsy</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionMuteness"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionMuteness" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionMuteness">
                                                                                                                Muteness</label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td align="left" valign="top" class="RadioText">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr class="checkbox_container">
                                                                                                        <td>
                                                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalConditionOtherHearingImpairment"
                                                                                                                name="CheckBox_CustomHRMAssessments_PhysicalConditionOtherHearingImpairment" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <label for="CheckBox_CustomHRMAssessments_PhysicalConditionOtherHearingImpairment">
                                                                                                                Other Hearing Impairment</label>
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
                                                                    <td class="height1">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr id="RowICDCodes" notgroup="AxisIII">
                                                                    <td class="form_label_text" align="left">
                                                                        <a id="AddICDCodes" onclick="javascript:ShowHideIcdCodes();" style="cursor: pointer;
                                                                            color: Blue;" title="Add ICD Codes">Add ICD Codes</a>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height1">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" align="left">
                                                                        <div id="divICDCodes" style="display: none;">
                                                                            <table id="TableICDCodes" cellpadding="0" cellspacing="0" border="0" width="100%"
                                                                                notgroup="AxisIII">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                                                    ICD Codes (Not Required)
                                                                                                </td>
                                                                                                <td width="17">
                                                                                                    <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                                                                </td>
                                                                                                <td class="content_tab_top" width="100%" />
                                                                                                <td width="7">
                                                                                                    <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="content_tab_bg" align="left" style="padding-left: 5px">
                                                                                        <table cellspacing="0" id="TableChildControl_DiagnosesIIICodes" parentchildcontrols="True"
                                                                                            clearcontrol="true" cellpadding="0" style="padding-right: 5px" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td valign="middle" align="left" style="width: 25%">
                                                                                                    <span class="form_label" id="SpanICDCode" style="padding-left: 5px;" name="SpanICDCode">
                                                                                                        ICD Code</span>
                                                                                                </td>
                                                                                                <td align="left" style="width: 75%; padding-left: 5px; vertical-align: top;">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                        <tr>
                                                                                                            <td style="width: 14%;" align="left">
                                                                                                                <input parentchildcontrols="True" bindautosaveevents="False" style="width: 50px;"
                                                                                                                    class="form_textbox" type="text" id="TextBox_DiagnosesIIICodes_ICDCode" baseurl="<%=ResolveUrl("~") %>"
                                                                                                                    name="TextBox_DiagnosesIIICodes_ICDCode" onblur="return OpenDiagnosisIIIPopUp(this,'<%=ResolveUrl("~") %>');"
                                                                                                                    required="true" onkeypress="ToggleICDDescriptionLabelAndTextBox(this);" />
                                                                                                            </td>
                                                                                                            <td style="width: 86%;" align="center" valign="middle">
                                                                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                                    <tr class="checkbox_container">
                                                                                                                        <td style="width: 3%;" align="left">
                                                                                                                            <input type="checkbox" id="CheckBox_DiagnosesIIICodes_Billable" parentchildcontrols="True"
                                                                                                                                name="CheckBox_DiagnosesIIICodes_Billable" bindautosaveevents="False" />
                                                                                                                        </td>
                                                                                                                        <td style="width: 97%;" align="left">
                                                                                                                            <label id="ICDBillable" name="ICDBillable" for="CheckBox_DiagnosesIIICodes_Billable">
                                                                                                                                Billable</label>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height1" colspan="2">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td valign="top" align="left" style="width: 25%">
                                                                                                    <span class="form_label" name="SpanICDDescription" style="padding-left: 5px;" id="SpanICDDescription">
                                                                                                        Description</span>
                                                                                                </td>
                                                                                                <td style="width: 75%; padding-left: 5px; padding-right: 5px;" align="left" valign="top">
                                                                                                    <span id="Span_DiagnosesIIICodes_ICDDescription" parentchildcontrols="True" class="form_label_dfa"
                                                                                                        name="Span_DiagnosesIIICodes_ICDDescription" bindautosaveevents="False" style="width: 689px;">
                                                                                                    </span>
                                                                                                    <textarea rows="4" cols="10" style="width: 689px;" class="form_textarea" onblur="return openDiagnosisIIIWindowForDescription(this,'<%=ResolveUrl("~") %>');"
                                                                                                        id="TextBoxICDDescription" baseurl="<%=ResolveUrl("~") %>" name="TextBoxICDDescription"
                                                                                                        bindautosaveevents="False"></textarea>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height1" colspan="2">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="width: 25%" align="left">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td align="right" style="width: 75%; padding-right: 10px;">
                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td valign="top">
                                                                                                                <table cellspacing="0" cellpadding="0" border="0" width="70px">
                                                                                                                    <tr>
                                                                                                                        <td align="center">
                                                                                                                            <input type="button" id="TableChildControl_DiagnosesIIICodes_ButtonInsert" name="TableChildControl_DiagnosesIIICodes_ButtonInsert"
                                                                                                                                baseurl="<%=ResolveUrl("~") %>" onclick="return  InsertDiagnosesIIIGridData(this,'TableChildControl_DiagnosesIIICodes','InsertICDGrid','CustomICDGrid','<%=ResolveUrl("~") %>');"
                                                                                                                                value="Insert" class="parentchildbutton" />
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                            <td style="width: 10px;">
                                                                                                            </td>
                                                                                                            <td style="padding-right: 5px">
                                                                                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 70px">
                                                                                                                    <tr>
                                                                                                                        <td align="center">
                                                                                                                            <input type="button" id="ButtonICDClear" onclick="ClearDiagnosisIII();ClearTable('TableChildControl_DiagnosesIIICodes','TableChildControl_DiagnosesIIICodes_ButtonInsert',false);"
                                                                                                                                name="ButtonICDClear" value="Clear" class="parentchildbutton" />
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td align="left" colspan="2" style="padding-left: 5px;">
                                                                                                    <span class="form_label" name="SpanICDHeading" style="font-style: italic; font-weight: bold;"
                                                                                                        id="SpanICDHeading">Click 'X' to remove, Select radio button to modify.</span>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height1" colspan="2">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="2" align="left" style="padding-left: 5px">
                                                                                                    <div id="InsertICDGrid" style="overflow-y: auto; overflow-x: hidden; height: 100px;
                                                                                                        width: 98%;">
                                                                                                        <uc1:CustomGrid ID="CustomICDGrid" runat="server" TableName="DiagnosesIIICodes" PrimaryKey="DiagnosesIIICodeId"
                                                                                                            CustomGridTableName="TableChildControl_DiagnosesIIICodes" GridPageName="diagnosis"
                                                                                                            width="100%" ColumnName="ICDCode:ICDDescription:Billable" ColumnHeader="ICD Code:Description:Billable"
                                                                                                            ColumnWidth="180:290:164" DivGridName="InsertICDGrid" InsertButtonId="TableChildControl_DiagnosesIIICodes_ButtonInsert" />
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="2">
                                                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_DiagnosesIIICodes_DiagnosesIIICodeId"
                                                                                                        name="HiddenField_DiagnosesIIICodes_DiagnosesIIICodeId" value="" />
                                                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey"
                                                                                                        value="DiagnosesIIICodeId" />
                                                                                                    <input type="hidden" id="HiddenField_DiagnosesIIICodes_DocumentVersionId" value="-1"
                                                                                                        name="HiddenField_DiagnosesIIICodes_DocumentVersionId" />
                                                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey"
                                                                                                        value="DocumentVersionId" />
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
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <!--Ended over here-->
                                                            </table>
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
                            <tr>
                                <td>
                                    <table id="TableAxisIV" cellspacing="0" cellpadding="0" border="0" width="100%" group="AxisIV">
                                        <tr>
                                            <td class="height4">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Axis IV <span id="Group_AxisIV"></span>
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
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg_padding" align="center">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 100%;">
                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                <tr>
                                                                    <td align="left" style="width: 40%">
                                                                        <span class="form_label_text">Current Psychosocial and Environmental Stressors</span>
                                                                    </td>
                                                                    <td align="left" style="width: 10%; padding-left: 5px;">
                                                                        <input type="hidden" id="HiddenField_DiagnosesIV_DocumentVersionId" value="-1" name="HiddenField_DiagnosesIV_DocumentVersionId" />
                                                                        <table cellspacing="0" cellpadding="0" border="0">
                                                                            <tr>
                                                                                <td width="109">
                                                                                    <%--<input class="form_btn_left1" type="button" style="width: 110px;" id="ButtonAxisIV"
                                                                                            onclick="OpenDiagnosisIVValues(this);" baseurl="<%=ResolveUrl("~") %>" name="ButtonAxisIV"
                                                                                            value="Axis IV Legend..." />--%>
                                                                                    <span type="button" style="width: 110px;" id="ButtonAxisIV" onclick="OpenDiagnosisIVValues(this,'<%=ResolveUrl("~") %>');"
                                                                                        name="ButtonAxisIV" text="Axis IV Legend..."></span>
                                                                                </td>
                                                                                <td width="30">
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td align="left">
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td style="width: 35%">
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height3">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="form_label_text" align="left" colspan="3">
                                                            Select All That Apply
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <table cellspacing="5" cellpadding="1" border="0" width="100%">
                                                                <tr>
                                                                    <td align="left" valign="top" class="RadioText">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="1" id="CheckBox_DiagnosesIV_PrimarySupport" name="CheckBox_DiagnosesIV_PrimarySupport" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_PrimarySupport">
                                                                                        Problems with primary support group</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="2" id="CheckBox_DiagnosesIV_SocialEnvironment"
                                                                                        name="CheckBox_DiagnosesIV_SocialEnvironment" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_SocialEnvironment" class="form_label_text">
                                                                                        Problems related to social environment</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="3" id="CheckBox_DiagnosesIV_Educational" name="CheckBox_DiagnosesIV_Educational" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Educational">
                                                                                        Educational problems</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="4" id="CheckBox_DiagnosesIV_Occupational" name="CheckBox_DiagnosesIV_Occupational" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Occupational">
                                                                                        Occupational problems</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left" class="RadioText">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="5" id="CheckBox_DiagnosesIV_Housing" name="CheckBox_DiagnosesIV_Housing" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Housing">
                                                                                        Housing problems</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="6" id="CheckBox_DiagnosesIV_Economic" name="CheckBox_DiagnosesIV_Economic" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Economic">
                                                                                        Economic problems</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" valign="top">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input style="vertical-align: top" type="checkbox" categoryid="7" id="CheckBox_DiagnosesIV_HealthcareServices"
                                                                                        name="CheckBox_DiagnosesIV_HealthcareServices" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_HealthcareServices">
                                                                                        Problems with access to health care services</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left" valign="top" class="RadioText">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="8" id="CheckBox_DiagnosesIV_Legal" name="CheckBox_DiagnosesIV_Legal" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Legal">
                                                                                        Problems related to interaction with the legal system/crime</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left" valign="top">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class="checkbox_container">
                                                                                <td>
                                                                                    <input type="checkbox" categoryid="9" id="CheckBox_DiagnosesIV_Other" name="CheckBox_DiagnosesIV_Other" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <label for="CheckBox_DiagnosesIV_Other">
                                                                                        Other psychosocial and environmental problems</label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="form_label_text" align="left" colspan="3">
                                                            Specify
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" colspan="3">
                                                            <textarea class="form_textareaWithoutWidth" id="TextArea_DiagnosesIV_Specification" name="TextArea_DiagnosesIV_Specification"
                                                                cols="155" rows="5" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
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
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height4">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table id="TableAxisV" cellspacing="0" cellpadding="0" border="0" width="100%" group="AxisV">
                                        <tr>
                                            <td class="height1">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Axis V <span id="Group_AxisV"></span>
                                                            <input type="hidden" id="HiddenField_DiagnosesV_DocumentVersionId" value="-1" name="HiddenField_DiagnosesV_DocumentVersionId" />
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
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td id="TdDiagnosesAxixV" valign="top" style="display: block;" visible="true" class="content_tab_bg"
                                                align="center">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td colspan="4" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" width="40%" style="padding-left: 8px">
                                                            <span class="form_label_text">Client’s Current Global Assessment of Functioning</span>
                                                        </td>
                                                        <td align="left" width="7%">
                                                            <%--<input type="hidden" id="HiddenField_DiagnosesV_DocumentVersionId" value="-1" name="HiddenField_DiagnosesV_DocumentVersionId" />--%>
                                                            <input class="form_textbox" style="width: 25px;" type="text" id="TextBox_DiagnosesV_AxisV"
                                                                name="TextBox_DiagnosesV_AxisV" onkeypress="changeVal(this);" onblur="CheckAxisVLegend(this);"
                                                                maxlength="2" datatype="Numeric"/>
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <table cellspacing="0" cellpadding="0" border="0" width="100px">
                                                                <tr>
                                                                    <td style="width: 107px;" align="left">
                                                                        <%-- <input class="form_btn_left1" style="width: 107px;" type="button" value="Axis V Legend..."
                                                                    id="ButtonAxisVRanges" name="ButtonAxisVRanges" onclick="OpenAxisVLegend('V',this,<%=ResolveUrl("~") %>);" />--%>
                                                                        <span type="button" type="button" text="Axis V Legend..." id="ButtonAxisVRanges"
                                                                            name="ButtonAxisVRanges" onclick="OpenAxisVLegend('V',this,'<%=ResolveUrl("~") %>');">
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width: 38%">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td id="TdHRMAssesmentSAAxisV" valign="top" class="content_tab_bg" align="center"
                                                style="display: none;" visible="false">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td colspan="4" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" align="left" style="padding-left: 8px">
                                                            <span class="form_label">Please click save to calculate axis V from DLA</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" width="40%" style="padding-left: 8px">
                                                            <span class="form_label">Client Current Global Assessment of Functioning(Axis V)</span>
                                                        </td>
                                                        <td align="left" width="7%" colspan="3">
                                                            <input type="hidden" id="HiddenField_DiagnosesV5_DocumentVersionId5" value="-1" name="HiddenField_DiagnosesV5_DocumentVersionId5" />
                                                            <input class="form_textbox" style="width: 25px;" disabled="disabled" type="text"
                                                                id="TextBox_DiagnosesV_AxisV5" name="TextBox_DiagnosesV_AxisV5" maxlength="2" />
                                                            <input type="hidden" id="HiddenField_DiagnosesV_AxisV" name="HiddenField_DiagnosesV_AxisV" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" width="40%" style="padding-left: 8px;">
                                                            <span class="form_label">Staff Assigned Global Assessment of Functioning</span>
                                                        </td>
                                                        <td align="left" width="7%">
                                                            <input type="hidden" id="HiddenField_CustomHRMAssessments_DocumentVersionId" value="-1"
                                                                name="HiddenField_CustomHRMAssessments_DocumentVersionId" />
                                                            <input class="form_textbox" style="width: 25px;" type="text" id="TextBox_CustomHRMAssessments_StaffAxisV"
                                                                name="TextBox_CustomHRMAssessments_StaffAxisV" maxlength="2" onkeypress="changeStaffAxisVal(this);"
                                                                onblur="CheckStaffAxisVLegend(this);" />
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <table cellspacing="0" cellpadding="0" border="0" width="100px">
                                                                <tr>
                                                                    <td style="width: 107px;" align="left">
                                                                        <span type="button" type="button" text="Axis V Legend..." id="ButtonStaffAxisVRanges"
                                                                            name="ButtonStaffAxisVRanges" onclick="OpenStaffAxisVLegend('StaffAxisV',this,'<%=ResolveUrl("~") %>');">
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width: 38%">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" style="padding-left: 8px;" colspan="4">
                                                            <span class="form_label">Reason for Staff Assigned Value (if different from DLA generated
                                                                score)</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" style="padding-left: 8px;" colspan="4">
                                                            <textarea id="textarea_CustomHRMAssessments_StaffAxisVReason" name="textarea_CustomHRMAssessments_StaffAxisVReason"
                                                                cols="80" rows="3">
                                                
                                                </textarea>
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
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                        </td>
                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
</div>