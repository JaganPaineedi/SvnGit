using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Custom_SPMI_WebPages_SPMI : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    public override string DefaultTab
    {
        get { return "/Custom/SPMI/WebPages/SPMIGeneral.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "RadMultiPageSPMIMainTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ctlcollection = this.RadMultiPageSPMIMainTabPage.Controls[TabIndex].Controls;
        RadMultiPageSPMIMainTabPage.SelectedIndex = (short)TabIndex;
        RadTabStrip1SPMIMainTabPage.SelectedIndex = (short)TabIndex;
        UcPath = RadTabStrip1SPMIMainTabPage.Tabs[TabIndex].Attributes["Path"];
    }

    public override void BindControls()
    {

    }

    public override string PageDataSetName
    {
        get { return "DatasetSPMIs"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentSPMIs" }; }
    }

    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
    }
}
