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


namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_Assessment_HRMRAPBehaviors : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        string RAPQuestionFilterColumnName = "Challenging Behaviors";
        public override void BindControls()
        {
            UserControl_HRMRAPQuestions.BindRapQuestions(RAPQuestionFilterColumnName);
            //using (SHS.UserBusinessServices.HRMAssesment objectHRMAssesment = new SHS.UserBusinessServices.HRMAssesment())
            //{
            //   // string a = objectHRMAssesment.GetDDRAPLevelOfIntensity(RAPQuestionFilterColumnName, "2,3,4,5");
                
            //    PlaceHolderControlRAPLevelIntensity.Controls.Add(new LiteralControl(objectHRMAssesment.GetDDRAPLevelOfIntensity(RAPQuestionFilterColumnName, "2,3,4,5")));
            //}
        }
    }
}
