﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="24HourAccessReportDocument.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_24HourAccessReportDocument" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/24HourAccessReport.js" ></script>
<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <div id="Div24HourAccessDFA">
                <uc2:DynamicForms ID="DynamicForms24HourAccess" runat="server" />
            </div>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenField_CustomDocument24HourAccess_DocumentVersionId" name="HiddenField_CustomDocument24HourAccess_DocumentVersionId"
                type="hidden" />
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocument24HourAccess,DocumentInitializationLog" />
              
                
         </td>
    </tr>
</table>