<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientMedicationDrug.aspx.cs"
    Inherits="UserControls_ClientMedicationDrug" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <base target="_self" />
    <title>Client Search</title>

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        var ClientMedicationDrugs = {
            EnablesDisable: function () {
                $("#btnSelect").prop('disabled', ($('[type=radio]:checked', $("#DivGridViewDrug").length > 0)));
            },
            closeDiv: function () {
                try {
                    parent.$("#DivSearch").css('display', 'none');
                } catch (Err) {
                    alert("ClientMedicationDrugs.closeDiv" + Err.message);
                }
            },
            //Closes the drug popup through select button and not from cross button.
                closeDivSelect: function(MedicationNameId, MedicationName, MedicationId, ExternalMedicationNameId, ExternalMedicationId) {
                try {
                    parent.$("#DivSearch").css('display', 'none');
                    parent.window.FillDrug(MedicationNameId, MedicationName);
                        parent.window.SetId(MedicationNameId, MedicationName, MedicationId, ExternalMedicationNameId, ExternalMedicationId);

                } catch (Err) {
                    alert("ClientMedicationDrugs.closeDivSelect" + Err.message);
                }
            },
            onClickClientMedicationDrugSelection: function (event, obj) {
                var $obj = $(obj);
                $('.GridViewRowStyleSelected', $obj).removeClass('GridViewRowStyleSelected').addClass('GridViewRowStyle');
                var target = event.target || event.srcElement;
                if ($(target).attr('id') == $obj.attr('id')) return;
                switch (target.tagName.toUpperCase()) {
                    case 'DIV':
                        $('input', $(target)).attr('checked', 'checked');
                        $(target).removeClass('GridViewRowStyle').addClass('GridViewRowStyleSelected');
                        break;
                    case 'LABEL':
                        $('input', $(target).parent()).attr('checked', 'checked');
                        $(target).parent().removeClass('GridViewRowStyle').addClass('GridViewRowStyleSelected');
                        break;
                    default:
                        $(target).parent().removeClass('GridViewRowStyle').addClass('GridViewRowStyleSelected');
                        break;
                }
                $("#btnSelect").prop('disabled', false);
            },
            fnReturnValues: function (objList) {
                var $radioSelected = $('[type=radio]:checked', $(objList));
                if ($radioSelected.length > 0) {
                    var ExternalMedicationId = $radioSelected.attr('externalmedicationid');
                    var MedicationId = $radioSelected.attr('medicationid');
                    var MedicationNameId = $radioSelected.attr('medicationnameid');
                    var ExternalMedicationNameId = $radioSelected.attr('externalmedicationnameid');
                    if (ExternalMedicationId && ExternalMedicationNameId && MedicationId && MedicationNameId) {
                            ClientMedicationDrugs.closeDivSelect(MedicationNameId, $radioSelected.attr('medicationname'), MedicationId, ExternalMedicationNameId, ExternalMedicationId);
                    }
                }
            }
        }
    </script>

</head>
<body enableviewstate="false" scroll="no" topmargin="0" onload="ClientMedicationDrugs.EnablesDisable();window.history.forward(1);">
    <form id="form1" runat="server">
        <!--Ref to Task#2590 !-->
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/CommonService.asmx" />
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/ClientMedicationOrder.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <div>
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="height: 1pt;" colspan="2">
                                    <asp:PlaceHolder ID="PlaceHolderScript" runat="server"></asp:PlaceHolder>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td align="center">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <div style="border-collapse: separate; border-width: 1px; height: 255px; overflow-x: hidden; overflow-y: auto; text-align: left; width: 400px;" id="DivGridViewDrug" onclick="ClientMedicationDrugs.onClickClientMedicationDrugSelection(event, this);">
                                                                <asp:ListView runat="server" ID="lvDrugData">
                                                                    <LayoutTemplate>
                                                                        <div style="text-align: left;">
                                                                            <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                            <div height="100%"></div>
                                                                        </div>
                                                                    </LayoutTemplate>
                                                                            <ItemTemplate>
                                                                        <div class='ListPageHLRow GridViewRowStyle'>
                                                                            <input type="radio" name="medicationselection" id="medication_<%# Container.DisplayIndex %>"
                                                                                medicationid='<%# DataBinder.Eval(Container.DataItem, "MedicationId") %>'
                                                                                externalmedicationid='<%# DataBinder.Eval(Container.DataItem, "ExternalMedicationId") %>'
                                                                                medicationnameid='<%# DataBinder.Eval(Container.DataItem, "MedicationNameId") %>'
                                                                                externalmedicationnameid='<%# DataBinder.Eval(Container.DataItem, "ExternalMedicationNameId") %>'
                                                                                medicationname='<%# DataBinder.Eval(Container.DataItem, "OriginalMedicationName") %>' />
                                                                            <label style="width: 100%;"><%# DataBinder.Eval(Container.DataItem, "MedicationName") %></label>
                                                                        </div>
                                                                            </ItemTemplate>
                                                                    <EmptyDataTemplate>
                                                                        <div style="color: red; text-align: center;"><b>No Medication Found</b></div>
                                                                    </EmptyDataTemplate>
                                                                </asp:ListView>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 2px" colspan="2"></td>
                                        </tr>
                                        <tr style="height: 50px;">
                                            <td colspan="3" align="center">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="padding-bottom: 10px; padding-top: 10px;">
                                                    <tr>
                                                        <td valign="top" align="center" style="height: 20px; width: 71px;">
                                                            <input id="btnSelect" type="button" value="Select" class="btnimgexsmall" onclick="return ClientMedicationDrugs.fnReturnValues('#DivGridViewDrug');" /></td>
                                                        <td valign="top" style="height: 20px; width: 2%;"></td>
                                                        <td valign="top" style="height: 20px; width: 71px;">
                                                            <input type="button" class="btnimgexsmall" id="btnClose" value="Close" onclick="ClientMedicationDrugs.closeDiv();" />
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
    </form>

    <script type="text/javascript">parent.fnHideParentDiv();</script>

</body>
</html>