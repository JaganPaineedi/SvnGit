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

    public partial class ActivityPages_Client_Detail_Assessment_HRMSummary : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        /// <summary>
        /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
        /// <Author>Jitender</Author>
        /// <CreatedOn>05 May 2010</CreatedOn>
        /// </summary>
        /// <ModifiedBy>Atul Pandey</ModifiedBy>
        /// <ModifiedDate>10/30/2012</ModifiedDate>
        public override void BindControls()
        {   //Modified by Atul Pandey for task #23 of Allegan CMH Development
            //using (SHS.UserBusinessServices.EligibilityVerification objectEligibilityVerification = new SHS.UserBusinessServices.EligibilityVerification())
            //{
            //    if (objectEligibilityVerification.GetAgencyInformation().Tables["Agency"].Columns.Contains("AbbreviatedAgencyName"))
            //    {
            //        string AbbreviatedAgencyName = objectEligibilityVerification.GetAgencyInformation().Tables["Agency"].Rows[0]["AbbreviatedAgencyName"].ToString();
            //        if (AbbreviatedAgencyName != "")
            //        {
            //            Label_Agency_AbbreviatedAgencyName.Text = AbbreviatedAgencyName;
            //        }
            //    }
            //}
            //till here
            // Binding parent grid
            //CustomGridServiceLookup.Bind(ParentDetailPageObject.ScreenId);
        }
    }
}
