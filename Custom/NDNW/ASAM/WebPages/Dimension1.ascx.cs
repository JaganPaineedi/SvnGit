using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_ASAM_WebPages_Dimension1 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            DropDownList_CustomDocumentASAMs_D1Level.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D1Level.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_D1Risk.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D1Risk.FillDropDownDropGlobalCodes();
        }
    }
}