<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedNoteDiagnosis.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNoteDiagnosis" %>
<%@ Register Src="~/Custom/WebPages/Diagnosis.ascx" TagName="Diagnosis"
    TagPrefix="uc1" %>

<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" width="99%" class="DocumentScreen">
        <tr>
            <td style="height: 2px">
            </td>
        </tr>
        <tr>
            <td style="width: 98%">
                <uc1:Diagnosis ID="UserControl_UCDiagnosis" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
       
    </table>
</div>