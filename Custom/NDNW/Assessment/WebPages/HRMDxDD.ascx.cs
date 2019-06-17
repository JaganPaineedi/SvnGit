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

    public partial class ActivityPages_Client_Detail_Assessment_HRMDxDD : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            

            //Added by Sonia with Reference to ticket 
            //460 7.3 - Dx Tab: Tab does not stay disabled when DxTabDisabled = 'Y' 
            if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "CustomHRMAssessments",0) == true)
            {
                if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomHRMAssessments"].Rows[0]["DxTabDisabled"] != null && BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomHRMAssessments"].Rows[0]["DxTabDisabled"].ToString() == "Y")
                {
                    BaseCustomGrid obj = (BaseCustomGrid)UserControl_UCDiagnosis.FindControl("CustomGrid");
                    obj.DoNotDisplayDeleteImage = true;
                }
            }

            UserControl_UCDiagnosis.Activate();
        }
    }
}