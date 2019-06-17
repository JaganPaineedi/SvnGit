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
    public partial class ActivityPages_Client_Detail_HarborTreatmentPlan_HarborTPGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public string RelativePath;
        /// <summary>
        /// Overridden function of DataActivityTab
        /// </summary>
        public override void BindControls()
        {

            HiddenFieldRelativePath.Value = Page.ResolveUrl("~/");
            RelativePath = Page.ResolveUrl("~/");
            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("AUTHORIZATIONTEAM", true, "", "", false))
            {
                dataViewGlobalCodes.RowFilter = "Active='Y' and isnull(RecordDeleted,'N')='N'";
                dataViewGlobalCodes.Sort = "CodeName";
            }
        }

        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "customTPGeneral" };
            }

        }
    }
}