<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationPrintOrderDialog.aspx.cs" Inherits="MedicationPrintOrderDialog" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register TagPrefix="UI" TagName ="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

       <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>
            
         <script language="JavaScript" src="App_Themes/Includes/js/MedicationPrint.js?rel=3_5_x_4_1" type="text/javascript"></script>  
         
    <script type="text/javascript" language="javascript" src="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1"></script>
<script type="text/javascript" language="javascript">
        function EnableOkButton() {
  EnablesDisable('<%=ButtonOk.ClientID %>','<%=RadioButtonFaxToPharmacy.ClientID %>','<%=RadioButtonPrintScript.ClientID %>');

}
</script>
 

  
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />


</head>
<body onload="Javascript:addHandle(document.getElementById('topborder'), window);EnableOkButton();">
    <form id="form2" runat="server">
        <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0"
            width="100%">
            <tr>
                <td width="590px" id="topborder" class="TitleBarText">Print Medication Order</td>
                <td align="left" width="10px">
                    <img id="ImgCross" onclick="closeDiv()" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>'
                        title="Close" alt="Close" />
                </td>
            </tr>
        </table>
      
       <asp:ScriptManager ID="ScriptManager1" runat="server">
         <Services>
            <asp:ServiceReference Path="WebServices/CommonService.asmx" />
            <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
       </Services>
        </asp:ScriptManager>
        
                <div>
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="400">
                        <tr>
                            <td style="height: 5px">
                                <table border="0" cellpadding="0" cellspacing="0" width="500px">
                                    <tr>
                                        <td align="LEFT" style="height: 30px;width:3%"  valign="bottom">
                                            <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                                        </td>
                                        <td valign="middle">
                                      
                                            <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label></td>
                                <td></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <!--       <tr>
                            <td class="sep_tab" style="height: 5px">
                            </td>
                        </tr>-->
                        <tr>
                            <td valign="top" style="height: 277px">
                                <!--Source-->
                                <table border="0px" cellpadding="0" cellspacing="0" style="width: 500px;">
                                    <tr>
                                        <td style="height: 235px" valign="top">
                                       
                                            <UI:Heading ID="Heading1" runat="server" HeadingText="Script Information" />
                                        <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;"
                                        width="100%">
                                    <tr>
                                       <td>
                                            <table width="100%">
                                            <tr>
                                              <td valign="top">
                                                            <asp:RadioButton ID="RadioButtonPrintScript" runat="server" Text="Print Script" GroupName="Print" CssClass="SumarryLabel" AutoPostBack="false" />
                                             </td>
                                   
                                   <td align="left" valign="top">
                                       <asp:CheckBox ID="CheckBoxPrintDrugInformation" runat="server" Text="Print Drug Information" />
                                   </td>
                                   </tr>
                                   <!--Blank Row--> 
                                    <tr>
                                   <td colspan="2">&nbsp;
                                   </td>
                                   </tr>
                                   <tr>
                                   <td valign="top">
                                                            <asp:RadioButton ID="RadioButtonFaxToPharmacy" runat="server" GroupName="Print" Text="Fax to Pharmacy" CssClass="SumarryLabel" AutoPostBack="false" />
                                   </td>
                                   <td align="left" valign="top">
                                       <asp:Label ID="LabelFaxtoPharmacy" runat="server" CssClass="labelFont" Font-Names="verdana" Font-Size="8.25pt"
                                           Text="Fax to Pharmacy"></asp:Label>
                                       <asp:DropDownList ID="DropDownListPharmacies" runat="server"  CssClass="ddlist"
                                            Width="162px" >
                                       </asp:DropDownList></td>
                                   </tr>
                                     <!--Blank Row--> 
                                    <tr>
                                   <td colspan="2">&nbsp;
                                   </td>
                                   </tr>
                                   
                                                <!--Blank Row-->
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="LabelScriptReason" runat="server" CssClass="labelFont" Font-Names="verdana"
                                                            Font-Size="8.25pt" Text="Script Reason" Width="118px"></asp:Label>
                                                        <asp:DropDownList ID="DropDownListScriptReason" runat="server" CssClass="ddlist"
                                            Width="189px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                        <td align="center" colspan="2">&nbsp;<br />
                                                                <asp:Button ID="ButtonOk" runat="server" CssClass="btnimgexsmall" 
                                                                            Text="Ok" Width="99px" OnClick="ButtonOk_Click" />
                                                                <asp:Button ID="ButtonCancel" runat="server" CssClass="btnimgexsmall" Text="Cancel"
                                                            Width="99px"  OnClientClick="closeDiv();return false;"/>
                                                            </td>
                                                </tr>
                                                
                                                 <tr>
                                   <td colspan="2">&nbsp;
                                   </td>
                                   </tr>
                                    </table> 
                                     
                                          
                                    </td>
                                </tr>
                              
                            </table>  
                                           
                                        </td>
                                    </tr>
                                    <tr>
                                    <td colspan="3" style="border-bottom: #5b0000 1px solid; height: 1pt; padding-left: 15px"></td>
                        </tr>
                        <tr>
                            <td align="center" class="footertextbold"><b>
                             <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                            </td>
                        </tr>
                                 
                               
                                </table>
                               
                                
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                              
                                                   <asp:HiddenField ID="HiddenFieldLatestClientMedicationScriptId" runat="server" />
                                                   <asp:HiddenField ID="HiddenFieldOrderMethod" runat="server" /> 
                            </td>
                        </tr>
                    </table>
                </div>
        <rsweb:ReportViewer ID="reportViewer1" runat="server">
        </rsweb:ReportViewer>
       

    </form>
</body>
</html>