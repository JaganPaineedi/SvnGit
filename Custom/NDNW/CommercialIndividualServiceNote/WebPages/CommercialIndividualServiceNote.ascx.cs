using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
public partial class Custom_CommercialIndividualServiceNote_WebPages_CommercialIndividualServiceNote : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public override void BindControls()
    {

    }
    public override string PageDataSetName
    {
        get { return "DataSetCommercialIndividualServiceNote"; }
    }
    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentCommercialIndividualServiceNotes" }; }
    }
    public override string GetStoreProcedureName
    {
        get
        {
            return "csp_SCGetCommercialIndividualServiceNote";
        }
    }
}