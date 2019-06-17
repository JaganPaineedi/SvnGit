<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ScreenToolbarIRIP.ascx.cs" Inherits="Custom_Restraint_ListPage_WebPages_ScreenToolbarIRIP" %>
<%--<script type="text/javascript" src="<%=RelativePath%>Custom/Restraint/ListPage/Scripts/IRRPListPage.js"></script>
<script type="text/javascript" src="<%=RelativePath%>Custom/Restraint/ListPage/Scripts/RPListPage.js"></script>--%>
<div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr align="right">
            <td align="right">
                <table border="0" cellpadding="0" cellspacing="0" style="padding: 0px 5px 0px 5px">
                    <tr valign="top" align="left">
               
                        
                        
                        <td style="width: 5px">
                        </td>
                        <td >
                            &nbsp;
                        </td>
                        <td >                               
                                <img src="<%=WebsiteSettings.BaseUrl %>Custom/IncidentReport/ListPage/Images/IRtoolbaricon.gif" alt=""
                                    title="New Incident Report" onclick="javascript:return OpenIRPages()" id="ButtonIR" />

                        </td>   
                    </tr>
                    
                </table>
            </td>
        </tr>
    </table>
</div>