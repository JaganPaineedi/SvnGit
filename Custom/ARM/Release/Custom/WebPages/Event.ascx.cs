using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;

namespace SHS.SmartCare
{
    public partial class Event : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override void BindControls()
        {
            FillEventsDropDown();
            if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet != null)
            {
                if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "CustomDocumentEventInformations", 0))
                {
                    DataRow dataRowEvent = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentEventInformations"].Rows[0];
                    HiddenFieldDocumentVersionId.Value = Convert.ToString(dataRowEvent["DocumentVersionId"]);
                    DataRow dataRowDocument = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["Documents"].Rows[0];
                }
            }
        }

        //To fill The CodeDropDown
        private void FillEventsDropDown()
        {
            using (SHS.UserBusinessServices.Event objEvent = new SHS.UserBusinessServices.Event())
            {
                DropDownList_CustomDocumentEventInformations_InsurerId.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                DropDownList_CustomDocumentEventInformations_InsurerId.FillDropDownDropGlobalCodes();
            }
        }
    }
}