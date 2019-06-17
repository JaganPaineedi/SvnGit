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
    public partial class RegistrationDocumentClientContacts : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
       // public int ClientId;
        protected override void OnLoad(EventArgs e)
        {
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "ClientContacts" };
            }
        }

        public override void BindControls()
        {
            CustomGrid.Bind(ParentDetailPageObject.ScreenId);
        }

    }
}
