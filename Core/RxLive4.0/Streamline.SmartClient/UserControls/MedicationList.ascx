<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationList.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_MedicationList" %>

<script language="javascript">
    function pageLoad() {
        try {
                RegisterMedicationListControlEvents();
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    }

</script>
<script>
    $(document).ready(function () {
          $('[id$="HiddenPrintEC"]').val("collapse");
        $('.ExpandCollapseRows,.Rowbolditalic').css('display', 'none');
        $(".ExpandCollapse").attr("src", "App_Themes/Includes/Images/Expand_Records.png");
       
        $('.ExapandCollapseMedList').click(function () {
            if ($('.ExpandCollapseRows').css('display') == 'table-row') {               
                $('.ExpandCollapseRows,.Rowbolditalic').css('display', 'none');
                $(".ExpandCollapse").attr("src", "App_Themes/Includes/Images/Expand_Records.png");
                $('[id$="HiddenPrintEC"]').val("collpase");
            }
            else {
                $('.ExpandCollapseRows,.Rowbolditalic').css('display', 'table-row');
                $(".ExpandCollapse").attr("src", "App_Themes/Includes/Images/Collapse_Records.png");
                $('[id$="HiddenPrintEC"]').val("expand");
            }
            return false;
        });

        $(".ExpandCollapse").click(function () {
            var pid = $(this).parents('tr').attr('id');
            var ImageId = $(this).attr('id');
            var Imagename = ImageId.replace('Control_ASP.usercontrols_viewhistory_ascx_', '');
            var name = pid.replace('Control_ASP.usercontrols_viewhistory_ascx_', '');
            var d = $('[id$="' + name + '"]').nextUntil('.GridViewRowStyle');         
            var result = d.closest('.ExpandCollapseRows').not('.Rowbolditalic').css('display');
           
            if (result=="table-row") {
                d.not('.RowblackLine').css('display', 'none');
                $('[id$="' + Imagename + '"]').attr("src", "App_Themes/Includes/Images/expand_Records.png");
            }
            else {
                d.not('.RowblackLine').css('display', 'table-row');
                $('[id$="' + Imagename + '"]').attr("src", "App_Themes/Includes/Images/Collapse_Records.png");
                
            }
         
        });
    });
</script>

<asp:Panel ID="PanelMedicationList" Style="width: 100%;" runat="server">
</asp:Panel>
<asp:HiddenField ID="HiddenMedicationLists" runat="server" Value="" />
<asp:HiddenField ID="HiddenPrintEC" runat="server" Value="" />
