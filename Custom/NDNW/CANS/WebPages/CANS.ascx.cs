using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using SHS.BaseLayer;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.IO;

namespace SHS.SmartCare
{
    public partial class CANS : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public override string PageDataSetName
        {
            get
            {
                return "DataSetCANSDocument";
            }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomDocumentCANSGenerals","CustomDocumentCANSYouthStrengths","CustomDocumentCANSModules" };
            }
        }

        public override string DefaultTab
        {
            get { return "Custom/CANS/WebPages/CANSGeneral.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPageCANS"; }
        }


        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPageCANS.Controls[TabIndex].Controls;
            RadTabStripCANS.SelectedIndex = (short)TabIndex;
            RadMultiPageCANS.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStripCANS.Tabs[TabIndex].Attributes["Path"];
        }


        public override void BindControls()
        {

        }
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            if (dataSetObject.Tables.Contains("CustomDocumentCANSGenerals"))
                dataSetObject.Tables["CustomDocumentCANSGenerals"].Columns.Remove("LivingArrangement");
        }
    }
}