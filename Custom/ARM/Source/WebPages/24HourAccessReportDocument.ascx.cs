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

public partial class ActivityPages_Harbor_Client_Detail_Documents_24HourAccessReportDocument : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    /// <summary>
    /// <Description>This overridable function inherited from DocumentDataActivityPage is used to bind controls</Description>
    /// <Author>Minakshi</Author>
    /// <CreatedOn>25 July 2011</CreatedOn>
    /// </summary>
    public override void BindControls()
    {
        DynamicForms24HourAccess.FormId = 80;
        DynamicForms24HourAccess.Activate();
    }

    public override string PageDataSetName
    {
        get
        {

            return "DataSet24HourAccess";
        }

    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocument24HourAccess" }; }
    }
}
