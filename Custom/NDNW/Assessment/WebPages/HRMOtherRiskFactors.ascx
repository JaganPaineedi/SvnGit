<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMOtherRiskFactors.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMOtherRiskFactors" %>



<script type="text/javascript">
    var gridViewOtherRiskFactors = "<%=GridViewOtherRiskFactors.ClientID %>";
</script>

<div id="divGrids" class="list_contanier_white_bg_forPopup" style="overflow: auto;">
    <table width="100%" border="0" class="list_table">
        <tr>
            <td>
                <div id= "DivRiskFactor" style="height: 300px; overflow: auto;">
                    <asp:GridView runat="server" ID="GridViewOtherRiskFactors" AutoGenerateColumns="false"
                        EnableViewState="false" Width="96%" >
                        <AlternatingRowStyle CssClass="odd_rowpopups" />
                        <RowStyle CssClass="even_rowpopus" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBoxOtherRiskFactors" runat="server"/>
                                    <input type="hidden" id="HiddenFieldGlobalCodeId" name="HiddenFieldGlobalCodeId"
                                        value='<%#DataBinder.Eval(Container.DataItem,"GlobalCodeId") %>' />
                                    <input type='hidden' id="HiddenCodeName" name="HiddenCodeName"
                                        value='<%#DataBinder.Eval(Container.DataItem,"CodeName") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:Label ID="LabelCodeName" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CodeName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>No data to display</EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td valign="top" align="right">
                <table cellspacing="0" cellpadding="0" border="0" width="25%">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td  align="center">
                                        <input type="button" class="less_detail_btn" id="buttonok"  runat="server" value="OK"
                                            tabindex="1" onclick="parent.GetOtherRiskFactorsLookupDetail(gridViewOtherRiskFactors);" />
                                    </td>
                                    <td >
                                        
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td>
                                        <input type="button" class="less_detail_btn" id="ButtonCancel" value="Cancel" tabindex="2" onclick="parent.CloaseModalPopupWindow();" />
                                    </td>
                                    <td >
                                       
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
