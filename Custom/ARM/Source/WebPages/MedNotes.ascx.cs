﻿using System;
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
using SHS.BaseLayer;
public partial class ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNotes : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    #region--Properties--
    ///<summary>
    ///<Description>This property is used to return page dataset name
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    ///</summary>
    public override string PageDataSetName
    {
        get
        {
            return "DataSetMedNote";
        }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentMedicationReviewNotes", "CustomDocumentMentalStatuses", "DocumentDiagnosis", "DocumentDiagnosisFactors" }; }
    }

    ///<summary>
    ///<Description>This property is used to open first tab "Custom"
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    ///</summary>
    public override string DefaultTab
    {
        //get { return "/ActivityPages/Client/Detail/Documents/CustomSNPsychiatricEvaluationNote.ascx"; }
        get { return "/Custom/WebPages/MedNoteGeneral.ascx"; }
    }

    ///<summary>
    ///<Description>This property is used to return multitabcontrol id"
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    ///</summary>
    public override string MultiTabControlName
    {

        get { return "MedNotesTabPage"; }
    }
    #endregion

    #region--user defined functions--
    /// <summary>
    /// <Description>This is overridable function used to set tab index </Description>
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    /// </summary>
    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        MedNotesTabPage.ActiveTabIndex = (short)TabIndex;
        ctlcollection = MedNotesTabPage.TabPages[TabIndex].Controls;
        UcPath = MedNotesTabPage.TabPages[TabIndex].Name;
    }

    ///<summary>
    ///<Description>This function is used to bind contols of page
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    ///</summary>
    public override void BindControls()
    {
        DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        PageTitle = "Medication Review Notes";
    }

    /// <summary>
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>July 20,2011</CreatedOn>
    /// </summary>
    /// <param name="dataSetObject"></param>
    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        string[] dataTables = new string[] { "DiagnosesIANDIIMaxOrder" };

        if (dataSetObject != null)
        {
            for (int count = 0; count < dataTables.Length; count++)
            {
                if (dataSetObject.Tables.Contains(dataTables[count]) == true)
                {
                    dataSetObject.Tables.Remove(dataTables[count].ToString());
                }
            }
        }
        else
        {
            throw new ApplicationException("DataSet is Null");
        }
    }

    //public override void CustomAjaxRequest()
    //{
    //    base.CustomAjaxRequest();
    //    if (GetRequestParameterValue("action").ToLower().Trim() == "pullmedicationnote")
    //    {
    //        LoadDataInPanel(GetMedicationData()); 
    //    }

    //}

    //public string GetMedicationData()
    //{
    //    string strMedicationData = string.Empty;

    //    using(SHS.UserBusinessServices.ServiceNotes objectServiceNote=new SHS.UserBusinessServices.ServiceNotes())
    //    {
    //        DataSet dataSetMedicationList=objectServiceNote.GetCustomHarborMedicationList(SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
    //        foreach(DataRow dataRow in dataSetMedicationList.Tables["HarborMedicationList"].Rows)
    //        {
    //            strMedicationData+=dataRow[0].ToString()+"\n";
    //        }
    //    }

    //    return strMedicationData;
    //}

    //public void LoadDataInPanel(string strResult)
    //{
    //    Literal literalStart = new Literal();
    //    Literal literalHtmlText = new Literal();
    //    Literal literalEnd = new Literal();
    //    literalStart.Text = "###StartMedNote###";
    //    literalHtmlText.Text += strResult;
    //    literalEnd.Text = "###EndMedNote###";

    //    PanelAjaxCall.Controls.Add(literalStart);
    //    PanelAjaxCall.Controls.Add(literalHtmlText);
    //    PanelAjaxCall.Controls.Add(literalEnd);
    //}

    #endregion
}
