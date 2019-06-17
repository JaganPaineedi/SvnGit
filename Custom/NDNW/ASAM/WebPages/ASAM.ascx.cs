using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_ASAM_WebPages_ASAM : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {

        public override string DefaultTab
        {
            get { return "/Custom/ASAM/WebPages/Dimension1.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPageASAMTabPage"; }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPageASAMTabPage.Controls[TabIndex].Controls;
            RadTabStrip1ASAMTabPage.SelectedIndex = (short)TabIndex;
            RadMultiPageASAMTabPage.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1ASAMTabPage.Tabs[TabIndex].Attributes["Path"];
        }

        public override void BindControls()
        {

        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomASAMs"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentASAMs" }; }
        }
    }
}