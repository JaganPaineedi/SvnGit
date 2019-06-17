﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_ASAM_WebPages_Dimension2 : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            DropDownList_CustomDocumentASAMs_D2Level.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D2Level.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_D2Risk.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_D2Risk.FillDropDownDropGlobalCodes();
        }
    }
}