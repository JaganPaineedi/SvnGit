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
using System.Xml;

namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_Assessment_HRMNeedList : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {

            //string xml = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GetXml();
         
         
           // string sd = xml.Substring(xml.IndexOf("CustomHRMNeeds"), xml.LastIndexOf("CustomHRMNeeds") - xml.IndexOf("CustomHRMNeeds"));
            //ParentDetailPageObject.SetParentScreenProperties("CustomHRMNeeds", "<CustomHRMNeeds><HRMNeedId>12</HRMNeedId></CustomHRMNeeds>");
        }

       
    }


}
