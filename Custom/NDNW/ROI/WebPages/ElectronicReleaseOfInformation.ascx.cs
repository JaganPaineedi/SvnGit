using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Reflection;
using System.IO;
using System.Xml;
using SHS.BaseLayer.ActivityPages;
using System.Web.Script.Serialization;

public partial class NewaygoElectronicReleaseOfInformation : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{
    private JavaScriptSerializer objectJavaScriptSerializer = null;

    /// <summary>
    ///  Purpose : Page DataSet Name
    /// </summary>
    public override string PageDataSetName
    {
        get { return "DataSetElectronicROI"; }
    }
    /// <summary>
    ///  Purpose :Table Use to Be Initialized
    /// </summary>
    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentReleaseOfInformations" }; }
    }

    /// <summary>
    ///  Purpose :Binding Controls
    /// </summary>
    public override void BindControls()
    {
        //HiddenFieldRelativePath.Value = Page.ResolveUrl("~/");
        //string ROIId = base.GetRequestParameterValue("ROIId");
        //if (!string.IsNullOrEmpty(ROIId))
        //{
        //    ParentDetailPageObject.SetParentScreenProperties("ROIId", ROIId);
        //}

        DataView dvAllStates = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.States);
        dvAllStates.Sort = "StateName ASC";
        DropDownList_CustomDocumentReleaseOfInformations_ReleasedState.DataSource = dvAllStates;
        DropDownList_CustomDocumentReleaseOfInformations_ReleasedState.DataTextField = "StateName";
        DropDownList_CustomDocumentReleaseOfInformations_ReleasedState.DataValueField = "StateAbbreviation";
        DropDownList_CustomDocumentReleaseOfInformations_ReleasedState.DataBind();
        DropDownList_CustomDocumentReleaseOfInformations_ReleasedState.Items.Insert(0, new ListItem("", ""));

        DataSet datasetReleasedToReceiveFrom = new DataSet();
        int clientId = 0;
        clientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
        using (SHS.UserBusinessServices.ReleaseOfInformations objectReleasedToReceiveFrom = new SHS.UserBusinessServices.ReleaseOfInformations())
        {
            datasetReleasedToReceiveFrom = objectReleasedToReceiveFrom.GetMemberContactsReleasedToReceiveFrom(clientId);
            if (datasetReleasedToReceiveFrom.Tables.Contains("TableReleasedToReceiveFrom") && BaseCommonFunctions.CheckRowExists(datasetReleasedToReceiveFrom, "TableReleasedToReceiveFrom", 0))
            {
                DataView dataviewReleaseOfInformations = new DataView(datasetReleasedToReceiveFrom.Tables["TableReleasedToReceiveFrom"]);
                DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom.DataSource = dataviewReleaseOfInformations;
                DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom.DataTextField = "Name";
                DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom.DataValueField = "ClientContactId";
                DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom.DataBind();
                DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom.Items.Insert(0, new ListItem("", ""));
            }
        }
        BindROIObjectivesInfo();
    }


    ///// <summary>
    ///// Purpose :Binding Release of Infomration records
    ///// </summary>
    public void BindROIObjectivesInfo()
    {

        using (DataSet dataSetDocument = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
        {

            ROIsListData objectROIsList = new ROIsListData();
            objectROIsList.objectListROIs = new List<ROIs>();

            if (dataSetDocument.Tables.Contains("CustomDocumentReleaseOfInformations"))
            {
                if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetDocument.Tables["CustomDocumentReleaseOfInformations"], 0))
                {
                    DataView dataViewCarePlanROIs = new DataView();
                    dataViewCarePlanROIs = dataSetDocument.Tables["CustomDocumentReleaseOfInformations"].DefaultView;
                    dataViewCarePlanROIs.RowFilter = "ISNULL(RecordDeleted,'N')<>'Y'";

                    for (int rowCount = 0; rowCount < dataViewCarePlanROIs.Count; rowCount++)
                    {
                        ROIs objectROIs = new ROIs();
                        objectROIs.ROIId = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseOfInformationId"]);
                        objectROIs.ReleaseOfInformationOrder = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseOfInformationOrder"]);
                        objectROIs.GetInformationFrom = Convert.ToString(dataViewCarePlanROIs[rowCount]["GetInformationFrom"]);
                        objectROIs.ReleaseInformationFrom = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseInformationFrom"]);
                        objectROIs.ReleaseToReceiveFrom = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseToReceiveFrom"]);
                        if (dataViewCarePlanROIs[rowCount]["ReleaseEndDate"] != DBNull.Value)
                        objectROIs.ReleaseEndDate = Convert.ToString(Convert.ToDateTime(dataViewCarePlanROIs[rowCount]["ReleaseEndDate"]).ToString("MM/dd/yyyy")).Substring(0, 10);
                        objectROIs.ReleaseContactType = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseContactType"]);
                        objectROIs.ReleaseName = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseName"]);
                        objectROIs.ReleaseAddress = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseAddress"]);
                        objectROIs.ReleaseCity = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleaseCity"]);
                        objectROIs.ReleasedState = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleasedState"]);
                        objectROIs.ReleasePhoneNumber = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleasePhoneNumber"]);
                        objectROIs.ReleasedZip = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleasedZip"]);
                        objectROIs.AssessmentEvaluation = Convert.ToString(dataViewCarePlanROIs[rowCount]["AssessmentEvaluation"]);
                        objectROIs.PersonPlan = Convert.ToString(dataViewCarePlanROIs[rowCount]["PersonPlan"]);
                        objectROIs.ProgressNote = Convert.ToString(dataViewCarePlanROIs[rowCount]["ProgressNote"]);
                        objectROIs.PsychologicalTesting = Convert.ToString(dataViewCarePlanROIs[rowCount]["PsychologicalTesting"]);
                        objectROIs.PsychiatricTreatment = Convert.ToString(dataViewCarePlanROIs[rowCount]["PsychiatricTreatment"]);
                        objectROIs.TreatmentServiceRecommendation = Convert.ToString(dataViewCarePlanROIs[rowCount]["TreatmentServiceRecommendation"]);
                        objectROIs.EducationalDevelopmental = Convert.ToString(dataViewCarePlanROIs[rowCount]["EducationalDevelopmental"]);
                        objectROIs.DischargeTransferRecommendation = Convert.ToString(dataViewCarePlanROIs[rowCount]["DischargeTransferRecommendation"]);
                        objectROIs.InformationBenefitInsurance = Convert.ToString(dataViewCarePlanROIs[rowCount]["InformationBenefitInsurance"]);
                        objectROIs.WorkRelatedInformation = Convert.ToString(dataViewCarePlanROIs[rowCount]["WorkRelatedInformation"]);
                        objectROIs.ReleasedInfoOther = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleasedInfoOther"]);
                        objectROIs.ReleasedInfoOtherComment = Convert.ToString(dataViewCarePlanROIs[rowCount]["ReleasedInfoOtherComment"]);
                        objectROIs.TransmissionModesWritten = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesWritten"]);
                        objectROIs.TransmissionModesVerbal = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesVerbal"]);
                        objectROIs.TransmissionModesElectronic = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesElectronic"]);
                        objectROIs.TransmissionModesAudio = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesAudio"]);
                        objectROIs.TransmissionModesPhoto = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesPhoto"]);
                        objectROIs.TransmissionModesReleaseInOther = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesReleaseInOther"]);
                        objectROIs.TransmissionModesReleaseInOtherComment = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesReleaseInOtherComment"]);
                        objectROIs.TransmissionModesToProvideCaseCoordination = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesToProvideCaseCoordination"]);
                        objectROIs.TransmissionModesToDetermineEligibleService = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesToDetermineEligibleService"]);
                        objectROIs.TransmissionModesAtRequestIndividual = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesAtRequestIndividual"]);
                        objectROIs.TransmissionModesInOther = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesInOther"]);
                        objectROIs.TransmissionModesOtherComment = Convert.ToString(dataViewCarePlanROIs[rowCount]["TransmissionModesOtherComment"]);
                        objectROIs.AlcoholDrugAbuse = Convert.ToString(dataViewCarePlanROIs[rowCount]["AlcoholDrugAbuse"]);
                        objectROIs.AIDSRelatedComplex = Convert.ToString(dataViewCarePlanROIs[rowCount]["AIDSRelatedComplex"]);

                        objectROIsList.objectListROIs.Add(objectROIs);
                    }
                }
            }
            else
            {
                ROIs objectROIs = new ROIs();
                objectROIs.ROIId = "-1";
                objectROIs.ReleaseOfInformationOrder = "1";
                objectROIs.GetInformationFrom = "";
                objectROIs.ReleaseInformationFrom = "";
                objectROIs.ReleaseToReceiveFrom = "";
                objectROIs.ReleaseEndDate = "";
                objectROIs.ReleaseContactType = "";
                objectROIs.ReleaseName = "";
                objectROIs.ReleaseAddress = "";
                objectROIs.ReleaseCity = "";
                objectROIs.ReleasedState = "";
                objectROIs.ReleasePhoneNumber = "";
                objectROIs.ReleasedZip = "";
                objectROIs.AssessmentEvaluation = "";
                objectROIs.PersonPlan = "";

                objectROIs.ProgressNote = "";

                objectROIs.PsychologicalTesting = "";
                objectROIs.PsychiatricTreatment = "";

                objectROIs.TreatmentServiceRecommendation = "";
                objectROIs.EducationalDevelopmental = "";
                objectROIs.DischargeTransferRecommendation = "";
                objectROIs.InformationBenefitInsurance = "";
                objectROIs.WorkRelatedInformation = "";

                objectROIs.ReleasedInfoOther = "";
                objectROIs.ReleasedInfoOtherComment = "";

                objectROIs.TransmissionModesWritten = "";
                objectROIs.TransmissionModesVerbal = "";
                objectROIs.TransmissionModesElectronic = "";
                objectROIs.TransmissionModesAudio = "";
                objectROIs.TransmissionModesPhoto = "";

                objectROIs.TransmissionModesReleaseInOther = "";
                objectROIs.TransmissionModesReleaseInOtherComment = "";
                objectROIs.TransmissionModesToProvideCaseCoordination = "";
                objectROIs.TransmissionModesToDetermineEligibleService = "";
                objectROIs.TransmissionModesAtRequestIndividual = "";
                objectROIs.TransmissionModesInOther = "";
                objectROIs.TransmissionModesOtherComment = "";
                objectROIs.AlcoholDrugAbuse = "";
                objectROIs.AIDSRelatedComplex = "";
                objectROIsList.objectListROIs.Add(objectROIs);
            }

            //This will serialize the ROI class objects and return to client side in hidden control
            objectJavaScriptSerializer = new JavaScriptSerializer();
            string objectStringROIObjectJSON = objectJavaScriptSerializer.Serialize(objectROIsList);
            HiddenField_CentraWellnessROIJSONData.Value = objectStringROIObjectJSON;
        }
    }




    /// <summary>
    /// <Created By>Sanjay Bhardwaj</Created>
    /// <Createdon>21 Jan 2013</createdon>
    /// <purpose>Custom Ajax Hit</purpose>
    /// </summary>
    public override void CustomAjaxRequest()
    {
        base.CustomAjaxRequest();
        string customAction = string.Empty;
        customAction = base.GetRequestParameterValue("CustomAction");

        //DataSet datasetDocumentNewaygo = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        //MergeUnsavedXMLInCentraWellnessDataSet(ref datasetDocumentCentraWellness);

        switch (customAction)
        {
            case "AddNewCentraWellnessROI":   //Add New ROI
                AddNewCentraWellnessROI();
                break;

            default:
                break;
        }
    }

    /// <summary>
    /// <Created By>Sanjay Bhardwaj</Created>
    /// <Purpose>TO Add a New ROI</Purpose>
    /// </summary>
    public void AddNewCentraWellnessROI()
    {
        using (DataSet dataSetDocument = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
        {
            int CustomDocumentReleaseOfInformationId = 0;

            DataTable datatableROIs = dataSetDocument.Tables["CustomDocumentReleaseOfInformations"];
            DataRow datarowNewROI = datatableROIs.NewRow();
            if (BaseCommonFunctions.CheckRowExists(datatableROIs, 0))
            {
                //This is used to maintain the ROI Primary Key and Document Version ID.
                CustomDocumentReleaseOfInformationId = Convert.ToInt32(datatableROIs.Rows[datatableROIs.Rows.Count - 1]["ReleaseOfInformationId"]);
                if (CustomDocumentReleaseOfInformationId < 0)
                    datarowNewROI["ReleaseOfInformationId"] = CustomDocumentReleaseOfInformationId + Convert.ToInt16("-1");
                else
                    datarowNewROI["ReleaseOfInformationId"] = "-1";
                datarowNewROI["DocumentVersionId"] = Convert.ToInt32(datatableROIs.Rows[datatableROIs.Rows.Count - 1]["DocumentVersionId"]);
            }
            else
            {
                datarowNewROI["ReleaseOfInformationId"] = "-1";
                datarowNewROI["DocumentVersionId"] = "-1";
            }
            //This is used to maintain the ROI order.
            int minROIId = 1;
            minROIId = Convert.ToInt32(datatableROIs.Compute("Min(ReleaseOfInformationOrder)", "ReleaseOfInformationOrder>0"));
            if (minROIId < 1)
                datarowNewROI["ReleaseOfInformationOrder"] = "1";
            else
                datarowNewROI["ReleaseOfInformationOrder"] = Convert.ToInt32(datatableROIs.Compute("Max(ReleaseOfInformationOrder)", "ISNULL(RecordDeleted,'N')<>'Y'")) + 1;

            datarowNewROI["ReleaseEndDate"] = DateTime.Now.AddYears(1).ToString("MM/dd/yyyy");
            BaseCommonFunctions.InitRowCredentials(datarowNewROI);
            datatableROIs.Rows.Add(datarowNewROI);


            SetResponseOnAddROI(datatableROIs, Convert.ToInt64(datarowNewROI["ReleaseOfInformationId"]), Convert.ToInt64(datarowNewROI["ReleaseOfInformationOrder"]));
        }
    }


    public void MergeUnsavedXMLInCentraWellnessDataSet(ref DataSet dataSetPageDataSet)
    {
        TextReader stringReader = null;
        DataSet datasetXMLReader = null;

        try
        {
            DataSet dataSetMain = new DataSet();
            //Read the XML
            //Modified by: Sweety Kamboj / Sonia Dhamija on 18 March ,2010
            //To remove xmlnx from xml string for dynamic pages
            string strxml = base.GetRequestParameterValue("xmlstring").Replace("xmlns=\"\"", "");
            if (strxml.IndexOf("xmlns:xsi=") == -1)
            {
                int index = strxml.IndexOf("xmlns");
                if (index != -1)
                {
                    strxml = strxml.Insert(index - 1, " " + "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" + " ");
                    //strxml.Substring(0,index-1) + " xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" + strxml.Substring(index ,strxml.Length-index) ;
                }
            }
            if (!string.IsNullOrEmpty(strxml))
            {
                stringReader = new StringReader(strxml);
                // stringReader = new StringReader(ParentPageObject.XMLString);
                datasetXMLReader = new DataSet();
                datasetXMLReader.ReadXml(stringReader);
                datasetXMLReader.EnforceConstraints = false;
                //datasetXMLReader = SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet(PageDataSetName);
                //datasetXMLReader.ReadXml(stringReader);
                //Merge the Read XML into session's DataSet as received in parameter
                try
                {
                    dataSetPageDataSet.Merge(datasetXMLReader, false, MissingSchemaAction.Ignore);
                    // dataSetPageDataSet.Merge(datasetXMLReader);

                }
                catch (Exception)
                {
                    //dataSetPageDataSet.Clear();
                    dataSetPageDataSet.Merge(datasetXMLReader, false, MissingSchemaAction.Ignore);
                    //dataSetPageDataSet.Merge(datasetXMLReader);
                }
            }
        }
        //try/catch block commented by shifali in ref to task# 950 on 01 july,2010
        //catch (Exception ex)
        //{
        //    //Code needs to be added for exception handling
        //}
        finally
        {
            stringReader = null;
        }

    }
    /// <summary>
    /// Set Response of cutsom ajax call when new ROI is added
    /// </summary>
    /// <param name="datatableROIs"></param>
    /// <param name="ROIIdAdded"></param>
    private void SetResponseOnAddROI(DataTable datatableROIs, Int64 ROIIdAdded, Int64 ROINumberAdded)
    {
        ROIsListData objectROIsList = new ROIsListData();
        objectROIsList.objectListROIs = new List<ROIs>();


        ROIs objectROIs = new ROIs();

        objectROIs.ROIId = Convert.ToString(ROIIdAdded);
        objectROIs.ReleaseOfInformationOrder = Convert.ToString(ROINumberAdded);

        objectROIs.GetInformationFrom = "";
        objectROIs.ReleaseInformationFrom = "";
        objectROIs.ReleaseToReceiveFrom = "";
        objectROIs.ReleaseEndDate = Convert.ToString(DateTime.Now.AddYears(1).ToString("MM/dd/yyyy")).Substring(0, 10);
        objectROIs.ReleaseContactType = "";
        objectROIs.ReleaseAddress = "";
        objectROIs.ReleaseAddress = "";
        objectROIs.ReleaseCity = "";
        objectROIs.ReleasedState = "";
        objectROIs.ReleasePhoneNumber = "";
        objectROIs.ReleasedZip = "";
        objectROIs.AssessmentEvaluation = "";
        objectROIs.PersonPlan = "";

        objectROIs.ProgressNote = "";

        objectROIs.PsychologicalTesting = "";
        objectROIs.PsychiatricTreatment = "";

        objectROIs.TreatmentServiceRecommendation = "";
        objectROIs.EducationalDevelopmental = "";
        objectROIs.DischargeTransferRecommendation = "";
        objectROIs.InformationBenefitInsurance = "";
        objectROIs.WorkRelatedInformation = "";

        objectROIs.ReleasedInfoOther = "";
        objectROIs.ReleasedInfoOtherComment = "";

        objectROIs.TransmissionModesWritten = "";
        objectROIs.TransmissionModesVerbal = "";
        objectROIs.TransmissionModesElectronic = "";
        objectROIs.TransmissionModesAudio = "";
        objectROIs.TransmissionModesPhoto = "";

        objectROIs.TransmissionModesReleaseInOther = "";
        objectROIs.TransmissionModesReleaseInOtherComment = "";
        objectROIs.TransmissionModesToProvideCaseCoordination = "";
        objectROIs.TransmissionModesToDetermineEligibleService = "";
        objectROIs.TransmissionModesAtRequestIndividual = "";
        objectROIs.TransmissionModesInOther = "";
        objectROIs.TransmissionModesOtherComment = "";
        objectROIs.AlcoholDrugAbuse = "";
        objectROIs.AIDSRelatedComplex = "";
        objectROIsList.objectListROIs.Add(objectROIs);

        //This will serialize the ROI class objects and return to client side in div panel
        objectJavaScriptSerializer = new JavaScriptSerializer();
        string objectStringROIObjectJSON = objectJavaScriptSerializer.Serialize(objectROIsList);
        //HiddenField_CentraWellnessROIJSONData.Value = objectStringROIObjectJSON;
        SetShowHidePanels("###StartAddNewROI###", objectStringROIObjectJSON, "###EndAddNewROI###");
    }
    /// <summary>
    /// <Created By>Shifali</Created>
    /// <Purpose>To Set Show/Hide Panels for Custom Ajax Request</Purpose>
    /// </summary>
    /// <param name="valueToSetAtStart"></param>
    /// <param name="valueToSet"></param>
    /// <param name="valueToSetAtEnd"></param>
    public void SetShowHidePanels(string valueToSetAtStart, string valueToSet, string valueToSetAtEnd)
    {
        using (DataSet documentDataset = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
        {
            DataSet DatasetScreenTemp = new DataSet();
            DatasetScreenTemp.EnforceConstraints = false;
            DatasetScreenTemp = documentDataset.Copy();

            string TableList = "CustomDocumentReleaseOfInformations";
            string[] ArrTableList = TableList.Split(',');
            for (int i = 0; i <= ArrTableList.Length - 1; i++)
            {
                //Added Table contains check before removing
                if (DatasetScreenTemp.Tables.Contains(ArrTableList[i]))
                {
                    // DatasetScreenTemp.Tables.Remove(ArrTableList[i].ToString());
                }
            }
            string pageDataSetXml = DatasetScreenTemp.GetXml();

            PanelMainCentraWellnessROI.Visible = false;
            Literal literalStart = new Literal();
            Literal literalHtmlText = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = valueToSetAtStart;
            literalHtmlText.Text += valueToSet;
            literalEnd.Text = valueToSetAtEnd + "^pageDataSetXML=" + pageDataSetXml;

            PanelCustomAjax.Controls.Add(literalStart);
            PanelCustomAjax.Controls.Add(literalHtmlText);
            PanelCustomAjax.Controls.Add(literalEnd);
        }

    }
    /// <Description>Call ChangeDataSetBeforeUpdate For ROI</Description>
    /// <Author>Sanjay Bhardwaj</Author>
    /// <CreatedOn>08April2013</CreatedOn>
    /// </summary>
    /// <param name="dataSetObject"></param>
    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        if (dataSetObject.IsRowExists("CustomDocumentReleaseOfInformations"))
        {
            //Update Deleted By and Record Deleted Date for RecordDeleted = Y Records
            int ROIOrder = 0;
            int ROICount = dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows.Count;
            int ROIDeletedCount = 1;
            for (int i = 0; i < dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows.Count; i++)
            {
                ROIOrder = ROIOrder + 1;
                dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["ReleaseOfInformationOrder"] = ROIOrder.ToString();
                if (dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["TempRecordDeleted"].ToString() == "Y")
                {
                    if (ROIDeletedCount < ROICount)
                    {
                        if (Convert.ToInt64(dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["ReleaseOfInformationId"]) < 0)
                        {

                            dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows.Remove(dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]);
                            ROIOrder = ROIOrder - 1;
                            i--; ROIDeletedCount++;
                        }
                        else
                        {

                            dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["RecordDeleted"] = "Y";
                            dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["DeletedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                            dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["DeletedDate"] = DateTime.Now;
                            dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Rows[i]["ReleaseOfInformationOrder"] = "0";
                            ROIOrder = ROIOrder - 1;
                            ROIDeletedCount++;
                        }
                    }
                }
            }
        }

        if (dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Columns.Contains("TempRecordDeleted"))
        {
             dataSetObject.Tables["CustomDocumentReleaseOfInformations"].Columns.Remove("TempRecordDeleted");
        }

    }
}


// ROIs
public class ROIs
{
    public string ROIId = string.Empty;
    public string ReleaseOfInformationOrder = string.Empty;

    public string GetInformationFrom = string.Empty;
    public string ReleaseInformationFrom = string.Empty;
    public string ReleaseToReceiveFrom = string.Empty;
    public string ReleaseEndDate = string.Empty;
    public string ReleaseContactType = string.Empty;
    public string ReleaseName = string.Empty;
    public string ReleaseAddress = string.Empty;
    public string ReleaseCity = string.Empty;
    public string ReleasedState = string.Empty;
    public string ReleasePhoneNumber = string.Empty;
    public string ReleasedZip = string.Empty;
    public string AssessmentEvaluation = string.Empty;
    public string PersonPlan = string.Empty;
    public string ProgressNote = string.Empty;
    public string PsychologicalTesting = string.Empty;
    public string PsychiatricTreatment = string.Empty;
    public string TreatmentServiceRecommendation = string.Empty;
    public string EducationalDevelopmental = string.Empty;
    public string DischargeTransferRecommendation = string.Empty;
    public string InformationBenefitInsurance = string.Empty;
    public string WorkRelatedInformation = string.Empty;
    public string ReleasedInfoOther = string.Empty;
    public string ReleasedInfoOtherComment = string.Empty;
    public string TransmissionModesWritten = string.Empty;
    public string TransmissionModesVerbal = string.Empty;
    public string TransmissionModesElectronic = string.Empty;
    public string TransmissionModesAudio = string.Empty;
    public string TransmissionModesPhoto = string.Empty;
    public string TransmissionModesReleaseInOther = string.Empty;
    public string TransmissionModesReleaseInOtherComment = string.Empty;
    public string TransmissionModesToProvideCaseCoordination = string.Empty;
    public string TransmissionModesToDetermineEligibleService = string.Empty;
    public string TransmissionModesAtRequestIndividual = string.Empty;
    public string TransmissionModesInOther = string.Empty;
    public string TransmissionModesOtherComment = string.Empty;
    public string AlcoholDrugAbuse = string.Empty;
    public string AIDSRelatedComplex = string.Empty;

}
// GridData
public class ROIsListData
{
    public List<ROIs> objectListROIs = null;
}
