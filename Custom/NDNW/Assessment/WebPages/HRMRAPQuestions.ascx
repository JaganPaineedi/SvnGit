<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMRAPQuestions.ascx.cs"
 Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMRAPQuestions" %>
 <% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
 <div id="topdiv"  style="width: 100%; visibility: visible;">
    <asp:Panel ID="PlaceHolderControlRAPQuestions"  ScrollBars="None"
        runat="server">
    </asp:Panel>
    </div>
    
    <div id="divRAPHelpTextPopUp" style="display: none; background-color:  white; 
           height:150px; width: 700px">
           <table border="2" style="border-color:#1C5B94;" width="100%" border="0"  cellpadding="0" cellspacing="0">
             <tr>
              <td>
                       
            <table width="100%" border="0"  cellpadding="0" cellspacing="0">
                  <tr>
                <td align="center">
                    <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td id="topborder" class="TitleBarText LPadd5">
                              Streamline Help Text
                            </td>
                            <td align="left" width="10px">
                                <a href="#">
                                    <img id="ImgCross" src=" <%=Page.ResolveUrl("~")%>App_Themes/Includes/Images/cross.jpg"
                                        title="Close" onclick="DivMoveHide1()" alt="Close" />
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
                  
                
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                
                                <td >
                                  
                                    <textarea  id="SpnDescprition"
                                        name="TextArea_CustomPsychosocialChild2_FunctioningConcerns" rows="8" spellcheck="True"
                                        cols="1" style="width: 99%"></textarea>
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
    





