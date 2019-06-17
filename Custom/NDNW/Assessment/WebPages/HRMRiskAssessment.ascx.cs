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
    public partial class ActivityPages_Client_Detail_Assessment_HRMRiskAssessment : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        /// <summary>
        /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
        /// <Author>Jitender</Author>
        /// <CreatedOn>06 May 2010</CreatedOn>
        /// </summary>
        /// 
        public override void BindControls()
        {
            // Binding parent grid
            CustomGridOtherRiskFactorsLookup.Bind(ParentDetailPageObject.ScreenId);
        }
        
    }
}
