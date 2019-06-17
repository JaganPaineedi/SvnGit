<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SubstancesList.ascx.cs" EnableViewState="false" Inherits="Streamline.SmartClient.UI.UserControls_SubstancesList" %>


<script type="text/javascript">
    var a = '<%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_QUANTITY_VALUE") + "\">" + Eval("DRUG_QUANTITY_VALUE") + "</div>"%>';

    $(function () {
        if (document.getElementById("Control_ASP.usercontrols_medicationsprescribe_ascx_ctl00_HiddenEPCSPermisions").value == 'false') {
            $("input[type='checkbox'][id^=ControlledSubstance]").hide();
        }
    });
</script>

<input type="hidden" id="HiddenFieldDate" runat="server" />
<table style="width: 100%">

    <tr>
        <td style="width: 30%">
            <span><%= ClientInformation %></span>
        </td>
        <td style="width: 30%">
            <span><%= PrescriberInformation %></span><br />
        </td>
        <td style="width: 40%">
            <span><%= PharmacyInformation %></span><br />
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:ListView runat="server" ID="SubstancesListView">
                <LayoutTemplate>
                    <table class="ListPageContainer" style="width: 100%">
                        <tr>
                            <td style="width: 8%">
                                   <asp:Panel runat="server" ID="ReadytoSign" CssClass="SortLabel">Ready to Sign</asp:Panel>
                            </td>
                            <td style="width: 15%">
                                <asp:Panel runat="server" ID="Medication" SortId="Medication" CssClass="SortLabel">Medication</asp:Panel>
                            </td>
                            <td style="width: 15%">
                                <asp:Panel runat="server" ID="Directions" SortId="Directions" CssClass="SortLabel">Directions</asp:Panel>
                            </td>
                            <td style="width: 5%">
                                <asp:Panel runat="server" ID="Quantity" SortId="Quantity" CssClass="SortLabel">Quantity</asp:Panel>
                            </td>
                            <td style="width: 5%">
                                <asp:Panel runat="server" ID="Refills" SortId="Refills" CssClass="SortLabel">Refills</asp:Panel>
                            </td>
                                <td style="width: 6%">
                                <asp:Panel runat="server" ID="OrderDate" SortId="OrderDate" CssClass="SortLabel">Order Date</asp:Panel>
                            </td>
                            <td style="width: 5%">
                                 <asp:Panel runat="server" ID="StartDate" SortId="StartDate" CssClass="SortLabel">Start Date</asp:Panel>
                            </td>
                             <td style="width: 5%">
                                 <asp:Panel runat="server" ID="EndDate" SortId="EndDate" CssClass="SortLabel">End Date</asp:Panel>
                            </td>
                            <td style="width: 12%">
                                <asp:Panel runat="server" ID="NotetoPharmacy" SortId="NotetoPharmacy" CssClass="SortLabel">Note to Pharmacy</asp:Panel>
                            </td>
                            <td style="width: 10%">
                                <asp:Panel runat="server" ID="SpecialInstructions" SortId="SpecialInstructions" CssClass="SortLabel">Special Instructions</asp:Panel>
                            </td>
                            <td style="width: 13%">
                                <asp:Panel runat="server" ID="SubstitutionsAllowed" SortId="SubstitutionsAllowed" CssClass="SortLabel">Substitutions</asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr style='<%# Container.DisplayIndex % 2 == 0 ? "background-color:#fff;": "background-color:#fff;" %>'>
                        <td style="width: 8%">
                            <input type="CheckBox" style="<%#  Eval("DEACode").ToString() == "0" ? "display:none;": "" %>  height:15px" name="ControlledSubstance" id="ControlledSubstance_<%# Eval("ClientMedicationScriptId") %>" clientmedicationscriptid="<%# Eval("ClientMedicationScriptId") %>" />
                        </td>
                        <td style="width: 15%">

                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_DESCRIPTION") + "\">" + Eval("DRUG_DESCRIPTION") + "</div>"%>
                        </td>
                        <td style="width: 15%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_DIRECTIONS") + "\">" + Eval("DRUG_DIRECTIONS") + "</div>"%>
                        </td>
                        <td style="width: 5%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_QUANTITY_VALUE") + "\">" + Eval("DRUG_QUANTITY_VALUE") + "</div>"%>
                        </td>
                        <td style="width: 5%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("REFILL_QUANTITY") + "\">" + Eval("REFILL_QUANTITY") + "</div>"%>
                        </td>
                          <td style="width: 6%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("WRITTEN_DATE") + "\">" + Eval("WRITTEN_DATE") + "</div>"%>
                        </td>
                          <td style="width: 5%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("P_START_DATE") + "\">" + Eval("P_START_DATE") + "</div>"%>
                        </td>
                          <td style="width: 5%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("P_END_DATE") + "\">" + Eval("P_END_DATE") + "</div>"%>
                        </td>
                        <td style="width: 12%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_NOTE") + "\">" + Eval("DRUG_NOTE") + "</div>"%>
                        </td>
                        <td style="width: 10%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DRUG_INSTRUCTIONS") + "\">" + Eval("DRUG_INSTRUCTIONS") + "</div>"%>
                        </td>
                        <td style="width: 13%">
                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("SUBSTITUTIONS") + "\">" + Eval("SUBSTITUTIONS") + "</div>"%>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
        </td>
    </tr>

</table>

<table style="width: 100%">
    <tr> 
        <td>
            <div id="divDisclaimer">
                <asp:Label ID="Disclaimer" runat="server" Font-Italic="True" Font-Size="Smaller"></asp:Label>
            </div>
        </td>
   </tr>
 </table>
 <input id="HiddenEPCSPermisions" type="hidden" runat="server" />
