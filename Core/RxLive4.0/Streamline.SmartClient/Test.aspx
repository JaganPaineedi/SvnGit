<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%-- <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
                <Services>
                    <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
                </Services>
            </asp:ScriptManager>--%>
    </div>
    <%-- <input type="Button" id="Button3" onclick="getDataTable()" value="MedicationStrength" />--%>

    <script language="javascript" type="text/javascript">

        function DisplayText() {
            var textboxId = '<% = txtDisplay.ClientID %>';
            var comboBoxId = '<% = ddSelect.ClientID %>';
            document.getElementById(textboxId).value = document.getElementById(comboBoxId).value;
            document.getElementById(textboxId).focus();
        } 
    </script>

    <asp:TextBox Style="width: 120px; position: absolute" ID="txtDisplay" runat="server"></asp:TextBox>
    <asp:DropDownList ID="ddSelect" Style="width: 140px" runat="server">
        <asp:ListItem Value="test1">test1</asp:ListItem>
        <asp:ListItem Value="test2">test2</asp:ListItem>
    </asp:DropDownList>
    </div>
    </form>
    
    
     <div id='DIVAllergies' style='width: 100%; height: 67px; overflow: auto'>
     <div>
     <table class='SumarryLabel' cellspacing='0'  cellpadding='0' border='0' id='Control_ASP.usercontrols_medicationmgt_ascx_MedicationClientPersonalInformation1_GridViewAllergies' style='width:90%;border-collapse:collapse;'><tr class='GridViewRowStyle' ><td valign='top' style='height:15px;' ><table cellspacing='0' cellpadding='0' >
     <tr>
     <td   style='width:10%;height:5px;background-color:#ffffff' valign='top' ></td>
     <td align='center' valign='top' style='width:5%'>
     <IMG  Width='15px' Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl0$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl0$btnDelete' ALT='Delete' src='App_Themes/Includes/Images/deleteIcon.gif'  style='cursor:hand' onclick=DeleteAllergy(2542,'Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl0$btnDelete');return false;  style='border-width:0px;' /></td>
     <td align='center' valign='top' style='width:15%'>
     <IMG Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl0$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl0$btnDelete' ALT='gdgdfgfdg' src='App_Themes/Includes/Images/comment.png' onclick=OpenAllergyComment(2542,'A','gdgdfgfdg');return false;  style='cursor:hand ;border-width:0px;' /></td>
     <td valign='top' style='width:85%' align='left' >A & D Emollient (Allergy)</td></tr></table>
     
     
     
     </td></tr><tr class='GridViewRowStyle' ><td valign='top' style='height:15px;' ><table cellspacing='0' cellpadding='0' ><tr><td   style='width:10%;height:5px;background-color:#ffffff' valign='top' ></td><td align='center' valign='top' style='width:5%'><IMG  Width='15px' Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl1$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl1$btnDelete' ALT='Delete' src='App_Themes/Includes/Images/deleteIcon.gif'  style='cursor:hand' onclick=DeleteAllergy(2540,'Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl1$btnDelete');return false;  style='border-width:0px;' /></td><td align='center' valign='top' style='width:15%'><IMG Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl1$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl1$btnDelete' ALT='asddsadav dgfdg fdgfdg fdg' src='App_Themes/Includes/Images/comment.png' onclick=OpenAllergyComment(2540,'A','asddsadav dgfdg fdgfdg fdg');return false;  style='cursor:hand ;border-width:0px;' /></td><td valign='top' style='width:85%' align='left' >Aqua Glycolic Astringent (Allergy)</td></tr></table></td></tr><tr class='GridViewRowStyle' ><td valign='top' style='height:15px;' ><table cellspacing='0' cellpadding='0' ><tr><td   style='width:10%;height:5px;background-color:#ffffff' valign='top' ></td><td align='center' valign='top' style='width:5%'><IMG  Width='15px' Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl2$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl2$btnDelete' ALT='Delete' src='App_Themes/Includes/Images/deleteIcon.gif'  style='cursor:hand' onclick=DeleteAllergy(2541,'Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl2$btnDelete');return false;  style='border-width:0px;' /></td><td align='center' valign='top' style='width:15%'><IMG Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl2$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl2$btnDelete' ALT='fgfgfgfgfggfgfgfgfgfgfgfgfgfgfg ghfhgfhgfh' src='App_Themes/Includes/Images/comment.png' onclick=OpenAllergyComment(2541,'A','fgfgfgfgfggfgfgfgfgfgfgfgfgfgfg ghfhgfhgfh');return false;  style='cursor:hand ;border-width:0px;' /></td><td valign='top' style='width:85%' align='left' >St. John's Wort (Allergy)</td></tr></table></td></tr><tr class='GridViewRowStyle' ><td valign='top' style='height:15px;' ><table cellspacing='0' cellpadding='0' ><tr><td   style='width:10%;height:5px;background-color:#ffffff' valign='top' ></td><td align='center' valign='top' style='width:5%'><IMG  Width='15px' Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl3$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl3$btnDelete' ALT='Delete' src='App_Themes/Includes/Images/deleteIcon.gif'  style='cursor:hand' onclick=DeleteAllergy(2539,'Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl3$btnDelete');return false;  style='border-width:0px;' /></td><td align='center' valign='top' style='width:15%'><IMG Height='15px' name='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl3$btnDelete' id='Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl3$btnDelete' ALT='comment comment fgghfghfghf jghfghfghfhg ghjghjghjghjg fgghfghfghf fgfghfhgfgh fghfghfgf fghfhfghfhfgh fghfhfgfhfghf ghfhfhgffghfghf ghfhgfghfhgfhgf' src='App_Themes/Includes/Images/comment.png' onclick="OpenAllergyComment(2539,'A','comment comment fgghfghfghf jghfghfghfhg ghjghjghjghjg fgghfghfghf fgfghfhgfgh fghfghfgf fghfhfghfhfgh fghfhfgfhfghf ghfhfhgffghfghf ghfhgfghfhgfhgf');return false;"  style='cursor:hand ;border-width:0px;' /></td><td valign='top' style='width:85%' align='left' >Whey (Allergy)</td></tr></table></td></tr></table></div></div>
    
</body>
</html>
