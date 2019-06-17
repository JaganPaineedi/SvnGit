<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewAllergiesList.aspx.cs"
    Inherits="Streamline.SmartClient.ViewAllergiesList" EnableViewState="false" EnableViewStateMac="false" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
  function checkRadioBtn(id) {
            var gv = document.getElementById('<%=DataGridAllergies.ClientID %>');

            for (var i = 0; i < gv.rows.length; i++) {
                var radioBtn = gv.rows[i].cells[0].getElementsByTagName("input");

                // Check if the id not same
                if (radioBtn[0].id != id.id) {
                    radioBtn[0].checked = false;
                }
            }
        }
        function checkShortcut() {
            if (event.keyCode == 8) {
                return false;
            }
        }

        function setFocus(objectRadio) {
        }

        function setFocus1(objectRadio) {
            document.getElementById(objectRadio).focus();
            document.getElementById('DivGridViewAllergies').scrollTop = document.getElementById('DivGridViewAllergies').scrollTop + 13;
        }
    </script>
    <style type="text/css">
        td {border: 0px solid #555;}
    </style>

</head>
<body onload="Javascript:AllergySearch.EnablesDisable();window.history.forward(1);">
    <!--onkeydown="return checkShortcut()"!-->
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/AllergySearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <asp:Label ID="LabelProgressText" runat="server" Font-Bold="True" Font-Italic="True"
                    Font-Size="Medium" ForeColor="#1C5B94" meta:resourcekey="LabelProgressTextResource1"
                    Text="Processing..."></asp:Label>
                <asp:Image ID="ImageProgressText" runat="server" ImageUrl="~/App_Themes/Includes/Images/Progress.gif"
                    meta:resourcekey="ImageProgressTextResource1" />
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="350px">
                        <tr>
                            <td valign="top">
                                <!--Source-->
                                <table border="0px" cellpadding="0" cellspacing="0" align="center">
                                    <tr>
                                        <td colspan="2">
                                            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Allergies List" />
                                            <table  cellpadding="0" cellspacing="0" style="height: 100px;"
                                                id="TableAllergies">
                                                <tr>
                                                    <td style="border:3px solid rgb(222, 231, 239); width: 340px;">
                                                        <div style="border-collapse: separate; border-width: 1px; height: 275px; overflow: auto; text-align: left; width: 338px;" id="DivGridViewAllergies" runat="server">
                                                            <asp:GridView ID="DataGridAllergies" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                                                BorderWidth="0px" CellPadding="0" GridLines="None" OnRowCreated="DataGridAllergies_RowCreated"
                                                                PageSize="100" RowStyle-Height="10px" OnRowDataBound="DataGridAllergies_RowDataBound"
                                                                EnableViewState="False" TabIndex="1"  ShowHeader="false">
                                                                <AlternatingRowStyle CssClass="GridViewAlternatingRowStyle" />
                                                                <RowStyle CssClass="GridViewRowStyle" Height="10px" />
                                                                <HeaderStyle CssClass="GridViewHeaderText" />
                                                                <PagerStyle CssClass="GridViewPagerText" />
                                                                <Columns>
                                                                    <asp:TemplateField ControlStyle-Width="5%">
                                                                        <ItemTemplate>
                                                                            <asp:RadioButton ID="RadioSelect" name="RadioSelect" GroupName="Radio" onclick="checkRadioBtn(this);"  AutoPostBack="false"
                                                                                runat="server" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle Width="2%" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ControlStyle-Width="5%" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Middle"
                                                                        ItemStyle-Wrap="false" ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" Visible="true" Text='<%# DataBinder.Eval(Container.DataItem, "ConceptDescription")%>'
                                                                                ID="lblAllergenConceptDescription">
                                                                            </asp:Label>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ControlStyle-Width="5%">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" Style="display: none" Text='<%# DataBinder.Eval(Container.DataItem, "AllergenConceptId")%>'
                                                                                ID="lblAllergenConceptId">
                                                                            </asp:Label>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                                <EmptyDataTemplate>
                                                                    <center>
                                                                        <p class="GridViewRowStyle">
                                                                            No Records Found
                                                                        </p>
                                                                    </center>
                                                                </EmptyDataTemplate>
                                                                <PagerSettings Mode="NumericFirstLast" />
                                                            </asp:GridView>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="height: 10px"></td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <UI:Heading ID="AllergyInformation" runat="server" HeadingText="Allergy Information" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table class="ArjunTesting" border="0" style="border:3px solid rgb(222, 231, 239);" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td colspan="2" style="height: 5px;"></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 5px;">
                                                        <span class="SumarryLabel">Reaction</span>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="DropDownListAllergyReaction" runat="server" CssClass="ddlist" Width="170px">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="height: 5px;"></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 5px;">
                                                        <span class="SumarryLabel">Severity</span>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="DropDownListAllergySeverity" runat="server" CssClass="ddlist" Width="170px">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                 <tr>
                                                    <td colspan="2" style="height: 5px;"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="height: 10px"></td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <UI:Heading ID="Heading1" runat="server" HeadingText="Comments" />
                                        </td>
                                    </tr>
                                    <!-- Added by Loveena in ref to Task#86 to add Comments Field!-->
                                    <tr>
                                        <td colspan="2">
                                            <asp:TextBox ID="TextBoxComments" EnableTheming="false" runat="server" TextMode="MultiLine"
                                                MaxLength="1000" Width="98%" TabIndex="2" BorderColor="#dee7ef" BorderWidth="3px" BorderStyle="Solid"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:RadioButtonList ID="RadioButtonListAllergyType" runat="server" TabIndex="3" CssClass="SumarryLabel"
                                                RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="A">Allergy</asp:ListItem>
                                                <asp:ListItem Value="I">Intolerances</asp:ListItem>
                                                <asp:ListItem Value="F">Failed Trials</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td>
                                            <div style="margin-right: 10px;">
                                                <asp:CheckBox ID="CheckBoxAllergyActive" runat="server" Checked="true" Text="Active" TextAlign="Right" TabIndex="4" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 10px" align="center" colspan="2">
                                            <asp:Button ID="btnSelect" runat="server" EnableViewState="False" OnClientClick="return AllergySearch.fnReturnValues();"
                                                Text="Select" Width="82px" CssClass="btnimgexsmall" TabIndex="5" />
                                            &nbsp;
                                        <asp:Button ID="btn1" runat="server" OnClientClick="AllergySearch.closeDiv(0,-1);" CssClass="btnimgexsmall"
                                            EnableViewState="False" Text="Cancel" Width="82px" TabIndex="6" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="CopyRightLineColor" style="height: 1px">
                                <input id="HiddenAllergyId" runat="server" type="hidden" />
                                <input id="HiddenRadioSelectedObject" runat="server" type="hidden" />
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td align="center" class="footertextbold">
                                <b>
                                    <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                                </b>
                            </td>
                        </tr>
                    </table>
                </div>
                <input id="HiddenRadioObject" runat="server" type="hidden" />
                <asp:Label ID="LabelError" runat="server" Text="Label" Visible="false"></asp:Label>
                <input id="HiddenSelectedRowNumber" runat="server" type="hidden" style="width: 77px" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script type="text/javascript">
        $("#DataGridAllergies tr:last").remove();
        parent.fnHideParentDiv();</script>

</body>
</html>
