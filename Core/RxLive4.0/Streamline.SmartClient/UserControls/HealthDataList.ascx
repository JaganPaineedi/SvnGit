<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HealthDataList.ascx.cs"
    Inherits="UserControls_HealthDataList" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="UI" Src="~/BasePages/UI/Heading.ascx" TagName="Heading" %>

<script type="text/javascript" language="javascript">

    //Show the add health popup
    function OpenHealthPopUp() {
        var DivHealthSearch = parent.document.getElementById('DivHealthSearch');
        DivHealthSearch.style.display = 'block';
        var iFrameHealthSearch = parent.document.getElementById('iFrameHealthSearch');
        iFrameHealthSearch.contentWindow.document.body.innerHTML = "<div></div>";
        var DropDownHealthCategory = document.getElementById('<%=DropDownHealthDataCategory.ClientID%>').id;
        var PanelHealthDataList = document.getElementById('<%=PanelHealthDataList.ClientID%>').id
        iFrameHealthSearch.src = 'HealthData.aspx?DropDownObject=' + DropDownHealthCategory + '&PanelHealthDataList=' + PanelHealthDataList;
        iFrameHealthSearch.style.positions = 'absolute';
        DivHealthSearch.style.left = -300;
        DivHealthSearch.style.top = 150;
        DivHealthSearch.style.height = 350;
        DivHealthSearch.style.width = 800;
        iFrameHealthSearch.style.width = 500;
        iFrameHealthSearch.style.height = 310;
    }

    function FillHealthDataListControl() {
        var PanelHealthDataList = document.getElementById('<%=PanelHealthDataList.ClientID %>');
        var DropDownObject = document.getElementById('<%=DropDownHealthDataCategory.ClientID %>');
        FillHealthDataList(PanelHealthDataList, DropDownObject);
    }
</script>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td>
            <table id="TableHealthDataList" runat="server" border="0" cellpadding="0" cellspacing="0"
                width="100%">
                <tr>
                    <td style="width: 30%;">
                        <asp:DropDownList ID="DropDownHealthDataCategory" onChange="FillHealthDataListControl();"
                            runat="server" Width="99%">                           
                        </asp:DropDownList>
                    </td>
                    <td style="width: 70%;" align="left">
                        <input id="ButtonAddHealthData" type="button" onclick="OpenHealthPopUp();" value="Add"
                            class="btnimgexsmall" <%=enableDisabled(Streamline.BaseLayer.Permissions.HealthData)%> />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Panel ID="PanelHealthDataList" Style="height: 100%; overflow-y: auto; overflow-x: hidden" runat="server">
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:HiddenField ID="HiddenHealthDataList" runat="server" Value="" />
<input type="hidden" runat="server" id="hiddenHealthDataCategory" />
<input type="hidden" runat="server" id="hiddenHealthItemName" />&nbsp; 