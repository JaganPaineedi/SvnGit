using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_ASAM_WebPages_Dimension3 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            DropDownList_CustomDocumentASAMs_D3Level.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D3Level.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_D3Risk.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D3Risk.FillDropDownDropGlobalCodes();
        }
    }
}