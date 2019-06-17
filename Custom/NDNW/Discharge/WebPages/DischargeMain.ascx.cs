using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Custom_Discharge_WebPages_DischargeMain : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    public override string DefaultTab
    {
        get { return "/Custom/Discharge/WebPages/General.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "RadMultiPageDischargeMainTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ctlcollection = this.RadMultiPageDischargeMainTabPage.Controls[TabIndex].Controls;
        RadMultiPageDischargeMainTabPage.SelectedIndex = (short)TabIndex;
        RadTabStrip1DischargeMainTabPage.SelectedIndex = (short)TabIndex;
        UcPath = RadTabStrip1DischargeMainTabPage.Tabs[TabIndex].Attributes["Path"];
    }

    public override void BindControls()
    {

    }

    public override string PageDataSetName
    {
        get { return "DatasetDischarge"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentDischarges", "ClientPrograms", "CustomDischargePrograms" }; }
    }

    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        if (dataSetObject.Tables.Contains("ClientPrograms") == true)
        {
            dataSetObject.Tables.Remove("ClientPrograms");
        }
    }

}
