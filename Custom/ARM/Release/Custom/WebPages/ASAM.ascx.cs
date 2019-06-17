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

public partial class ASAM : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override string DefaultTab
    {
        get { return "/Custom/WebPages/ASAM1.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "ASAMTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ASAMTabPage.ActiveTabIndex = (short)TabIndex;
        ctlcollection = ASAMTabPage.TabPages[TabIndex].Controls;
        UcPath = ASAMTabPage.TabPages[TabIndex].Name;
    }

    public override void BindControls()
    {
        SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Merge(SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomASAMLevelOfCares);
        //Modified by Manju Padmanabhan on 20 June, 2013 for A Renewed Mind - Customizations Task#16 
        //using (SHS.BaseLayer.ActivityPages.DataActivityTab objectActivityTabPage = (SHS.BaseLayer.ActivityPages.DataActivityTab)(this.LoadControl(Page.ResolveUrl("~") + "/Custom/WebPages/Event.ascx")))
        //{
        //    objectActivityTabPage.Activate();
        //    Panel_DetailUC.Controls.Add(objectActivityTabPage);
        //    Panel_DetailUC.Visible = true;
        //}
    }

    public override string PageDataSetName
    {
        get { return "DataSetCustomASAM"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentEventInformations,CustomASAMPlacements" }; }
    }

    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        if (dataSetObject != null && dataSetObject.Tables.Count > 0)
        {
            if (dataSetObject.Tables.Contains("CustomASAMLevelOfCares"))
            {
                //dataSetObject.Tables["CustomASAMLevelOfCares"].Constraints.Clear();
                //dataSetObject.Tables["CustomASAMLevelOfCares"].ChildRelations.Remove(dataSetObject.Tables["CustomASAMLevelOfCares"].ChildRelations[0]);
                dataSetObject.Tables.Remove("CustomASAMLevelOfCares");
            }
        }
        //Modified by Manju Padmanabhan on 20 June, 2013 for A Renewed Mind - Customizations Task#16
        //if (dataSetObject.Tables["Documents"] != null)
        //{
        //    if (dataSetObject.Tables["Documents"].Rows.Count > 0)
        //    {
        //        //dataSetObject.Tables["Documents"].Rows[0]["EffectiveDate"] = Convert.ToString(dataSetObject.Tables["CustomDocumentEventInformations"].Rows[0]["EventDateTime"]) != "" ? Convert.ToString(dataSetObject.Tables["CustomDocumentEventInformations"].Rows[0]["EventDateTime"]) : "";
        //    }
        //}
    }
}
