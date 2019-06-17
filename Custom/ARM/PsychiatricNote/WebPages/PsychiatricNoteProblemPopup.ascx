<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricNoteProblemPopup.ascx.cs" Inherits="Custom_PsychiatricNote_WebPages_PsychiatricNoteProblemPopup" %>
<%--<input type="hidden" runat = "server" id="hiddenDiagnosis" />

<script type="text/javascript">
    $(function() {
    $('#tableProblems')[0].innerHTML = $('input[type=hidden][id$=hiddenDiagnosis]').val();
    });

    function SetProblemAndClose() {
        var selectedVal = "";
        var selected = $("#divProblems input[type='radio'][name='problemRadioBox']:checked");
        if (selected.length > 0) {
            selectedVal = selected.val();
        }
        parent.setProblemValue(selectedVal)
        parent.CloaseModalPopupWindow();
    }

</script>
<div style="position:relative;">
    <table>
    <tr>
        <td width="100%" id="tdProblems" class='checkbox_container'>
            <div style="overflow:auto;height:420px" id="divProblems">
              <table id="tableProblems"  style="height:420px" ></table>
            </div>
        </td>
    </tr>
    <tr>
    <td  width="100%" style="padding-left:20px">
       <span  type="button" text="OK" id="Button_OK" name="Button_OK" onclick="return SetProblemAndClose();">
                            </span>
    </td>
    </tr>
    </table>
</div>
--%>
<style>
    .list_tablePsycNote
{
	border: 1px solid #91a3ae; /*border-top: 1px solid #91a3ae; 	border-left: 1px solid #91a3ae; 	border-right: 1px solid #91a3ae;*/
}
.list_tablePsycNote th
{
	background: url(../App_Themes/Includes/Images/list_grid_header_bg.gif) repeat-x left top;
	height: 24px;
    border-top: 1px solid #91a3ae;
    border-left:1px solid #91a3ae;
	border-right: 1px solid #91a3ae;
	border-bottom: 1px solid #91a3ae;
	text-align: left;
	padding: 0px 0px 0px 5px;
}
.list_tablePsycNote td
{
	padding: 0px 0px 0px 5px;
	vertical-align: middle;
    border-right: 1px solid #91a3ae;
    border-left:1px solid #91a3ae;
}
</style>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script language="javascript" src="<%= WebsiteSettings.BaseUrl  %>JScripts/SystemScripts/jquery-1.3.2.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript" src="<%= WebsiteSettings.BaseUrl  %>JScripts/ApplicationScripts/CommonFunctions.js"></script>

<script language="javascript" type="text/javascript" src="<%= WebsiteSettings.BaseUrl  %>JScripts/ApplicationScripts/ApplicationCommonFunctions.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/PsychiatricNote/Scripts/PsychiatricNote.js"></script>
    
<link href="<%= WebsiteSettings.BaseUrl  %>App_Themes/Styles/smartcare_styles.css"
    rel="stylesheet" type="text/css" />
<link href="<%= WebsiteSettings.BaseUrl  %>App_Themes/Styles/smartcarestyles.css"
    rel="stylesheet" type="text/css" />
<input type="hidden" id="hddnretval" runat="server" tabindex="53" />
<input type="hidden" id="hiddenPreviousRow" runat="server" tabindex="54" />
<input type="hidden" id="hddAxis" runat="server" tabindex="58" />
<input type="hidden" id="hiddenAxisValue" runat="server" tabindex="55" />
<input type="hidden" id="hddnValue" runat="server" tabindex="56" />
<input type="hidden" id="hddDisplayGridviewName" runat="server" tabindex="53" />
<input type="hidden" id="hddDiscription" runat="server" tabindex="57" />
<input type="hidden" id="hiddenFieldForDescriptionICDCode" />
<input type="hidden" id="hiddenFieldDiagnosisSearch" runat="server" />
<input type="hidden" id="hiddenFieldDiagnosisICDCode" runat="server" />
<input type="hidden" id="hiddenFieldDiagnosisDescription" runat="server" />
<div id="divGrids" class="list_contanier_white_bg_forPopup">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table border="0" width="100%" cellpadding="0" cellspacing="0" class="list_tablePsycNote"
                    style="text-align: center;padding-top:5px;">
                 
                    <tr>
                        <td>
                            <div id="div1" style="height: 250px; overflow-x: hidden; overflow-y: auto; width: 98%;">
                             
                                            <div id="DiagnosisAxisI" style="width: 100%">
                                                <asp:GridView ID="GridViewAxisI" runat="server" AutoGenerateColumns="False" OnRowDataBound="GridViewAxisI_RowDataBound"
                                                    TabIndex="5" Width="100%">
                                                    <AlternatingRowStyle CssClass="odd_rowpopups" />
                                                    <RowStyle CssClass="even_rowpopus" />
                                                    <EmptyDataRowStyle CssClass="dxgvEmptyDataRow" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <input type="radio" name="AxisISelect" class="gridItemStyle" />
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" Width="5%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="5%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="DSM V/ ICD 10">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LabelICD10Code" CssClass="gridItemStyle" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ICD10Code") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" Width="12.5%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="12.5%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="DSM IV/ ICD 9">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LabelICD9Code" CssClass="gridItemStyle" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ICD9Code") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" Width="12.5%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="12.5%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="DSM V">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LabelDSMV" CssClass="gridItemStyle" runat="server" Text='Yes'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" Width="10%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="10%" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Description">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LabelDescription" CssClass="gridItemStyle" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"DSMDescription") %>'></asp:Label>
                                                                <asp:Label ID="LabelDSMVCodeId" Visible="false" CssClass="gridItemStyle" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ICD10Code") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Left" Width="60%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="60%" />
                                                        </asp:TemplateField>
          
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        No data to display
                                                    </EmptyDataTemplate>
                                                </asp:GridView>
                                            </div>
                            </div>
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
            <td valign="top" align="right" style="padding-right: 3px;">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td valign="top">
                            <table cellspacing="0" cellpadding="0" border="0" width="70px">
                                <tr>
                                    <td align="left">
                                        <input type="button" id="buttonok" runat="server" onkeydown="SelectRow();" onclick="SetParentReturnValue($('[id$=HiddenPopUpName]').val(), $('[id$=HiddenPageName]').val());"
                                            value="OK" class="parentchildbutton" tabindex="6" disabled="disabled" />
                                        <input type="hidden" id="HiddenPopUpName" value="<%= GetRequestParameterValue("Value") %>" />
                                        <input type="hidden" id="HiddenPageName" value="<%= GetRequestParameterValue("PageName") %>" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" style="width: 70px">
                                <tr>
                                    <td align="left">
                                        <input type="button" class="parentchildbutton" id="buttoncancel" onclick="parent.CloaseModalPopupWindow('DiagnosisIAndIIPopUp');"
                                            value="Cancel" tabindex="7" />
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

