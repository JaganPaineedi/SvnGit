<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCHRMCurrentSubstanceUse.ascx.cs" 
Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_UCHRMCurrentSubstanceUse" %>


<div id="topdiv" style="width: 100%; overflow-y: hidden; overflow-x: hidden">
    <asp:Panel ID="PlaceHolderControlDimensions" CssClass="divScroll" ScrollBars="None"
        runat="server">
    </asp:Panel>
</div>
<div id="divDrugDescPopUp" style="display: none; z-index: 1000; position: relative;
    background-color: White;">
    <table cellpadding="0" cellspacing="0" width="350px" height="150px" border="1">
        <tr>
            <td valign="top">
                <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="350px">
                    <tr>
                        <td id="topborder" class="TitleBarText LPadd5">
                            Descrption
                           
                        </td>
                        <td align="left" width="10px">
                            <a href="#">
                                <img id="ImgCross" src=" <%=RelativePath%>App_Themes/Includes/Images/cross.jpg" title="Close"
                                    onclick="CloseDrugsDescDiv()" alt="Close" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="width: 100%">
            <td valign="top" class="form_label" align="left" class="LPadd5">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td style="height: 30px;">
                            <span id="SpnDescprition"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;" align="center">
                            <input type="button" onclick="CloseDrugsDescDiv()" value="Close" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
<div id="divFrequency" style="display: none; z-index: 1000; position: relative; background-color: White;">
    <table cellpadding="0" cellspacing="0" width="500px" height="150px" border="1">
        <tr>
            <td valign="top">
                <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="500px">
                    <tr>
                        <td id="Td1" class="TitleBarText LPadd5">
                            Frequency
                        </td>
                        <td align="left" width="10px">
                            <a href="#">
                                <img id="Img1" src=" <%=RelativePath%>App_Themes/Includes/Images/cross.jpg" title="Close"
                                    onclick="CloseFrequencyDiv()" alt="Close" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="width: 100%">
            <td valign="top" class="form_label" align="left" class="LPadd5">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td style="height: 5px">
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;">
                            <span  class="form_label3">Frequency of use is intened to capture the time frame when
                                the client was using and had the opportunity to use. If the client was recently
                                in a controlled setting, then the question should be asked about the preceding confinement
                                or incarceration.</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 5px">
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;">
                            <span class="form_label3">In effect, the question is this: "When you were actively using,
                                how often did you use?" The intent of this item is not to let a technicality or
                                a 30-day limit mask the frequency and intensity of use.</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 5px">
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;">
                            <span class="form_label3">Federal Block Grant outcome performance measures seek to compare
                                use at the satrt of treatment to use at its conclusion. It is understood that not
                                100% of all client will show use, but clinicians should make an effort to document
                                use patterns when there was an opportunity to use.</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 5px">
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px;" align="center">
                         <%--   <input type="button" onclick="CloseFrequencyDiv()" value="Close" />--%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
