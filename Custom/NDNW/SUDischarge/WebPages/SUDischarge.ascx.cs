using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer.ActivityPages;

namespace SHS.SmartCare
{
    public partial class Custom_SUDischarge_WebPages_SUDischarge : DocumentDataActivityMultiTabPage
    {

        public override string DefaultTab
        {
            get { return "/Custom/SUDischarge/WebPages/Discharge.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPageTabPage"; }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPageTabPage.Controls[TabIndex].Controls;
            RadTabStrip1TabPage.SelectedIndex = (short)TabIndex;
            RadMultiPageTabPage.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1TabPage.Tabs[TabIndex].Attributes["Path"];
        }

        public override void BindControls()
        {
            
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomSUDischarges"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentSUDischarges" }; }
        }
    }
}