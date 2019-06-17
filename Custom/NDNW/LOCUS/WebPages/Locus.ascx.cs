using System.Web.UI;
using SHS.BaseLayer.ActivityPages;
using System.Data;
using SHS.BaseLayer;

namespace SHS.SmartCare
{
    public partial class Custom_LOCUS_WebPages_Locus : DocumentDataActivityPage
    {
        /// <summary>
        /// Created By: Rakesh
        /// Dated : 08 Dec, 2011
        /// Purpose :To bind the control in DFA
        /// </summary>
        public override void BindControls()
        {
            DynamicFormsCustomDocumentLOCUSs.FormId = 21122;
            DynamicFormsCustomDocumentLOCUSs.Activate();
            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        }
        /// <summary>
        /// Created By: Rakesh
        /// Dated : 08 Dec, 2011
        /// Purpose :Page Data set Name(Single tab  DFA so no Data set name)
        /// </summary>
        public override string PageDataSetName
        {
            get { return ""; }
        }
        /// <summary>
        ///  /// Created By: Rakesh
        /// Dated : 08 Dec, 2011
        /// Purpose :Enter table name which is to be initialize
        /// </summary>
        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentLOCUSs" }; }
        }
    }
}