<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrinterList.ascx.cs" Inherits="UserControls_PrinterList" %>
<script language="javascript" type="text/javascript">
function pageLoad()
{
     try
     {              
        alert('PageLoad'); 
         RegisterPrinterListControlEvents();
     }
    catch(ex)
    {
        
         Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
    }  
}

</script>

<script id='Printerlist' type='text/javascript'>
function $deleteRecord(sender,e)
{ 
if (confirm ('Are you sure you want to delete this row?') == true )
{
onDeleteClick(sender,e)
}
}

function RegisterPrinterListControlEvents()
{
try
{ 
var Imagecontext6={PrinterDeviceLocationId:6,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_37774601-e498-4c19-9665-25ab54e0c408'};
var ImageclickCallback6 = Function.createCallback($deleteRecord, Imagecontext6);
$addHandler($get('PrinterList1_Img_6'), 'click', ImageclickCallback6);
var Imagecontext4={PrinterDeviceLocationId:4,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_77267dad-15cb-4eed-aa4a-183576829059'};
var ImageclickCallback4 = Function.createCallback($deleteRecord, Imagecontext4);$addHandler($get('PrinterList1_Img_4'), 'click', ImageclickCallback4);
var Imagecontext10={PrinterDeviceLocationId:10,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_fd278026-ab92-476f-a0f0-cd213f075c7a'};
var ImageclickCallback10 = Function.createCallback($deleteRecord, Imagecontext10);
$addHandler($get('PrinterList1_Img_10'), 'click', ImageclickCallback10);
var Imagecontext12={PrinterDeviceLocationId:12,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_a595c866-204e-43e8-8c82-61fcdcb23272'};
var ImageclickCallback12 = Function.createCallback($deleteRecord, Imagecontext12);
$addHandler($get('PrinterList1_Img_12'), 'click', ImageclickCallback12);
var Imagecontext3={PrinterDeviceLocationId:3,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_f912bc72-8c0b-4ee1-b48c-ff20c475cb10'};
var ImageclickCallback3 = Function.createCallback($deleteRecord, Imagecontext3);$addHandler($get('PrinterList1_Img_3'), 'click', ImageclickCallback3);
var Imagecontext9={PrinterDeviceLocationId:9,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_1a20c43d-449e-4465-a5d7-c7c50dd2eb8b'};var ImageclickCallback9 = Function.createCallback($deleteRecord, Imagecontext9);$addHandler($get('PrinterList1_Img_9'), 'click', ImageclickCallback9);var Imagecontext11={PrinterDeviceLocationId:11,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_a1ec398c-d0c2-4b20-a4db-eaa4ea1b3608'};var ImageclickCallback11 = Function.createCallback($deleteRecord, Imagecontext11);$addHandler($get('PrinterList1_Img_11'), 'click', ImageclickCallback11);var Imagecontext8={PrinterDeviceLocationId:8,TableId:'PrinterList1_91882aab-d79f-4d6b-b967-fba8e07d040d',RowId:'PrinterList1_Tr_f2149204-ec51-4a05-bf5c-6cd3e92015a6'};var ImageclickCallback8 = Function.createCallback($deleteRecord, Imagecontext8);$addHandler($get('PrinterList1_Img_8'), 'click', ImageclickCallback8);}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>
<asp:Panel  ID="PanelPrinterList"  style="overflow:hidden" Width="100%"  runat="server">
</asp:Panel>

<asp:HiddenField ID="HiddenPermissionsList" runat="server" Value="" />