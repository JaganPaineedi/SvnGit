using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;



public partial class Custom_Discharge_WebPages_Medications : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentDischarges", "CustomDischargeReferrals" };
        }
    }
    public override void BindControls()
    {
       //Nothing
    }
}

