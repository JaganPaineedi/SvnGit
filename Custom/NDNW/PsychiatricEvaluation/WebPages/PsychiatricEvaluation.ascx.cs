using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricEvaluation_WebPages_PsychiatricEvaluation : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        public override string DefaultTab
        {
            get { return "/Custom/PsychiatricEvaluation/WebPages/General.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPagePsychEvalTabPage"; }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPagePsychEvalTabPage.Controls[TabIndex].Controls;
            RadTabStrip1PsychEvalTabPage.SelectedIndex = (short)TabIndex;
            RadMultiPagePsychEvalTabPage.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1PsychEvalTabPage.Tabs[TabIndex].Attributes["Path"];
        }

        public override void BindControls()
        {
            
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomPsychiatricEvaluations"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentPsychiatricEvaluations" }; }
        }

        public override bool HaveDiagnosisControl
        {
            get { return true; }
        }        
    }
}