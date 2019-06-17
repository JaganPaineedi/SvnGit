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

public partial class ActivityPages_Client_Detail_Documents_Threshold_FBABIP_FBABIPGeneral : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    string TableName = string.Empty;
    int _FormCollectionId;
    string DocumentCodeId = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override string DefaultTab
    {
        get { return "/Custom/FBABIP/WebPages/FuntionalBehaviorAssessment.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "FBABIPGeneralTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        FBABIPGeneralTabPage.ActiveTabIndex = (short)TabIndex;
        ctlcollection = FBABIPGeneralTabPage.TabPages[TabIndex].Controls;
        UcPath = FBABIPGeneralTabPage.TabPages[TabIndex].Name;
    }

    public override void BindControls()
    {
        
    }

    public override string PageDataSetName
    {
        get { return "DataSetCustomFBABIP"; }
    }

    public override string[] TablesToBeInitialized
    {
        get
        {
            return new string[] { "CustomDocumentFABIPs" };
        }
    }

    public override int FormCollectionId
    {
        get
        {
            return GetFormCollectionIdForFBABIP();
        }
        set
        {
            base.FormCollectionId = _FormCollectionId;
        }
    }

    public int GetFormCollectionIdForFBABIP()
    {
        
        _FormCollectionId = 0;
        DocumentCodeId = ParentDocumentPageObject.DocumentCodeId.ToString();
        if (DocumentCodeId != string.Empty)
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.DocumentCodes != null)
            {
                DataRow[] DataRowDocumentCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.DocumentCodes.Select("DocumentCodeId=" + DocumentCodeId + " and ISNULL(RecordDeleted, 'N') = 'N'");
                if (DataRowDocumentCodes != null && DataRowDocumentCodes.Length > 0)
                {
                    if (Convert.ToString(DataRowDocumentCodes[0]["FormCollectionId"]) != string.Empty)
                    {
                        _FormCollectionId = Convert.ToInt32(DataRowDocumentCodes[0]["FormCollectionId"]);
                    }
                }
            }
        }
        return _FormCollectionId;
    }

    public override System.Collections.Generic.List<SHS.BaseLayer.CustomParameters> customInitializationStoreProcedureParameters
    {
        get
        {
            SHS.BaseLayer.DocumentInformation obj = new SHS.BaseLayer.DocumentInformation();

            System.Collections.Generic.List<SHS.BaseLayer.CustomParameters> customParameter = new System.Collections.Generic.List<SHS.BaseLayer.CustomParameters>();
            customParameter.Add(new SHS.BaseLayer.CustomParameters("DocumentCodeId", Convert.ToString(ParentDetailPageObject.dataRowScreenRow["DocumentCodeId"])));

            return customParameter;
        }
    }

    
}
