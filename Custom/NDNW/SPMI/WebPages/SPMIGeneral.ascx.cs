using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;

public partial class Custom_SPMI_WebPages_SPMIGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentSPMIs" };
        }
    }

    public override void BindControls()
    {

    }
   
}
