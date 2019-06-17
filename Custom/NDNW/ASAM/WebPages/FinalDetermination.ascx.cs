using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_ASAM_WebPages_FinalDetermination : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            DropDownList_CustomDocumentASAMs_IndicatedReferredLevel.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_IndicatedReferredLevel.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_ProvidedLevel.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_ProvidedLevel.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_DummyD1Level.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_DummyD1Level.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentASAMs_DummyD1Risk.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentASAMs_DummyD1Risk.FillDropDownDropGlobalCodes();
        }
    }
}