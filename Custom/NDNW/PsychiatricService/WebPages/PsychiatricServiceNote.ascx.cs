using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Linq;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Text;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceNote : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        string DocumentCodeId = string.Empty;
        public override string PageDataSetName
        {
            get
            {
                return "PsychiatricServiceNote";
            }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomDocumentPsychiatricServiceNoteGenerals","CustomDocumentPsychiatricServiceNoteHistory","CustomPsychiatricServiceNoteProblems","CustomDocumentPsychiatricServiceNoteExams","CustomDocumentPsychiatricServiceNoteMDMs","DocumentDiagnosisCodes","DocumentDiagnosis","DocumentDiagnosisFactors" };
            }
        }
        public override string DefaultTab
        {
            get { return "/Custom/PsychiatricService/WebPages/PsychiatricServiceGeneral.ascx"; }
        }
        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
        }
        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RadMultiPage1.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];
        }
        public override void BindControls()
        {
        }
        public override bool HaveDiagnosisControl
        {
            get
            {
                return true;
            }
        }
       
    }
}