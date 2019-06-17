using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using System.IO;

public partial class ActivityPages_Client_Detail_Kalamazoo_KalamazooAssessment_ASAMPopUp : SHS.BaseLayer.ActivityPages.DataActivityMultiTabPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override DataSet GetData()
    {
        // return BaseCommonFunctions.GetScreenInfoDataSet();
        DataSet dataSetLatest = new DataSet();
        dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet("DataSetAssessment");
        DataRow[] dr = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomASAMPlacements"].Select("DocumentVersionId Is Not Null");
        if (dr.Length > 0)
        {
            using (DataSet ds = new DataSet())
            {
                ds.Merge(dr);
                dataSetLatest.Tables["CustomASAMPlacements"].Merge(ds.Tables[0]);
            }
        }
        SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet = dataSetLatest;

        return dataSetLatest;
    }

    public override string DefaultTab
    {
        get { return "/ActivityPages/Client/PADocuments/ASAM1.ascx"; }
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
    }

    public override string PageDataSetName
    {
        get { return "DataSetAssessment"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomASAMPlacements" }; }
    }


    /// <summary>
    /// This function overide to handle Custom Ajax Request
    /// </summary>
    public override void CustomAjaxRequest()
    {
        if (base.GetRequestParameterValue("Flag") == "SaveASAMPopup")
        {
            MergeASAMPopUpDataInDataSet();

        }

    }

    /// <summary>
    /// This function added by Rakesh to merge ASAM pop up data in parent screen dataset
    /// </summary>
    private void MergeASAMPopUpDataInDataSet()
    {
        string AutoSaveXML = GetRequestParameterValue("ASAMPopUpData").Replace("%PL", "+");
        StringReader stringReader;
        DataSet datasetXMLReader = null;
        string strxml = AutoSaveXML.Replace("xmlns=\"\"", "");
        if (strxml.IndexOf("xmlns:xsi=") == -1)
        {
            int index = strxml.IndexOf("xmlns");
            if (index != -1)
            {
                strxml = strxml.Insert(index - 1, " " + "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" + " ");
            }
        }
        if (!string.IsNullOrEmpty(strxml))
        {
            stringReader = new StringReader(strxml);
            datasetXMLReader = new DataSet();
            datasetXMLReader.ReadXml(stringReader);
        }
        if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.GetScreenInfoDataSet(), "CustomASAMPlacements"))
        {
            BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomASAMPlacements"].Merge(datasetXMLReader.Tables[0], false, MissingSchemaAction.Ignore);
        }

    }
}
