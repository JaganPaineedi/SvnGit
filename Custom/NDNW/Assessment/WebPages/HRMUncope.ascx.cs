using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;
namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_Assessment_HRMUncope : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("STAGEOFCHANGE", true, "", "SortOrder", true))
            {
                
                DropDownList_CustomHRMAssessments_StageOfChange.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_StageOfChange.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_StageOfChange.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_StageOfChange.DataBind();
                
            }
        }
    }
}

