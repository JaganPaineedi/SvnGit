using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;

public partial class Reconciliation : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        ReconciliationData.Activate();
    }
}