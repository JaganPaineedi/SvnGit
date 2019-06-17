using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.IO;
using System.Collections.Generic;
using Ajax;
using Microsoft.Reporting.WebForms;
using System.Text;

public partial class DiscontinueMedicationScriptPrinting : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
    Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScripts = null;
    char OrderingMethod;
    char PrintDrugInformation;
    char intDrugInformation;
    DataTable _DataTableClientMedications;
    DataTable _DataTableClientMedicationInstructions;
    DataTable _DataTableClientMedicationScriptDrugs;
    //Code added by Loveena in ref to Task#2660
    string FolderId = string.Empty;
    byte[] renderedBytes;
    Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
    string _strScriptIds = "";
    string strReceipeintName = "";
    string strReceipentOrganisation = "";
    string strReceipentFaxNumber = "";
    string _strChartScripts = "";
    bool _strChartCopiesToBePrinted = false;
    string _strFaxFailedScripts = ""; //added by Chandan
    bool _strFaxFailed = false;
    string _DrugsOrderMethod = "";

    Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities = null;
    protected override void Page_Load(object sender, EventArgs e)
    {
        //ReportViewer();
    }



    private bool ReportViewer()
    {
        DataSet _DataSetClientSummary = null;
        //Session["ChangedOrderMedicationIds"] = Medicationids;
        ////Added by Chandan for task#2429 and task#131 
        //EventArray = Streamline.BaseLayer.CommonFunctions.StringSplit(Medicationids, ",");
        //for (int i = 0; i < EventArray.Count; i++)
        //    {
        //    DataRow[] drClientMedicationInteractiontobeDeleted = _DataTableClientMedicationInteractions.Select("ClientMedicationId1=" + EventArray[i] + " or ClientMedicationId2 =" + EventArray[i] + " ");
        //    foreach (DataRow dr in drClientMedicationInteractiontobeDeleted)
        //        {
        //        _clientMedicationInteractionIds = _clientMedicationInteractionIds + dr["ClientMedicationInteractionId"] + ",";
        //        }
        //    }
        //_clientMedicationInteractionIds = _clientMedicationInteractionIds.TrimEnd(',');
        //Session["ClientMedicationInteractionIds"] = _clientMedicationInteractionIds;

        DataTable DataTableClientMedicationsNCSampleORStockDrugs;
        DataTable DataTableClientMedicationsNCNonSampleORStockDrugs;
        DataTable DataTableClientMedicationsC2SampleORStockDrugs;
        DataTable DataTableClientMedicationsC2NonSampleORStockDrugs;
        DataTable DataTableClientMedicationsControlledSampleORStockDrugs;
        DataTable DataTableClientMedicationsControlledNonSampleORStockDrugs;
        bool _strScriptsTobeFaxedButPrinted = false;
        DataSet DataSetPharmacies;
        DataRow[] drSelectedPharmacy;
        DataRow[] drPharmacies = null;
        DataRow[] DataRowsClientMedeicationsCategory2Drugs = null;
        DataRow[] DataRowsClientMedicationsNormalCategoryDrugs = null;
        DataRow[] DataRowsClientMedicationsControlledCategoryDrugs = null;
        //Ref to Task#2660
        string FileName = "";
        string _strPrintChartCopy = null;
        _strPrintChartCopy = "true";
        string _strMedicationInstructionIds = "";
        divReportViewer.InnerHtml = "";
        try
        {
            //Ref to Task#2660
            if (System.Configuration.ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true")
            {
                if (System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                {
                    if (!System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                        System.IO.Directory.CreateDirectory(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                    foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                        {
                            //Added by Chandan on 16th Feb2010 ref task#2797
                            if (System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName))
                            {
                                if (FileName.ToUpper().IndexOf(".RDLC") == -1)
                                    System.IO.File.Delete(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + FileName));
                            }
                            else
                                System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName);
                        }
                    }
                }
            }
            else
            {
                //Code added to delete the rendered images
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


                }

            }

            ObjectClientMedication = new ClientMedication();
            DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            DataRow[] dataRowClientMedicationRow = _DataSetClientSummary.Tables["ClientMedications"].Select("ClientMedicationId=" + Convert.ToInt32(Request.QueryString["MedicationId"]));
            DataSet ds = new DataSet();
            ds.Merge(dataRowClientMedicationRow);
            DataSetClientMedications.EnforceConstraints = false;
            //DataSetClientMedications.Tables["ClientMedications"].Merge(_DataSetClientSummary.Tables["ClientMedications"]);
            DataSetClientMedications.Tables["ClientMedications"].Merge(ds.Tables[0]);
            DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);
            DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Merge(_DataSetClientSummary.Tables["ClientMedicationScriptDrugs"]);
            DataSetClientMedications.Tables["ClientMedicationInteractions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInteractions"]);
            DataSetClientMedications.Tables["ClientMedicationInteractionDetails"].Merge(_DataSetClientSummary.Tables["ClientMedicationInteractionDetails"]);

            //DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
            DataSetClientScripts = null;
            //  DataSetClientScripts = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            //if (RadioButtonFaxToPharmacy.Checked == true)
            //    OrderingMethod = 'F';
            //else
            //Added by Anuj (To set the ordering method coming from discontinue window fro task #1 Fy-10 Venture)
            if (Request.QueryString["OrderName"] != "" && Request.QueryString["OrderName"] != null)
            {
                OrderingMethod = Convert.ToChar(Request.QueryString["OrderName"]);
            }
            //OrderingMethod = 'P';
            PrintDrugInformation = 'Y';
            intDrugInformation = 'N';
            if (OrderingMethod == 'F')
            {
                //Get the Fax Number of Selected Pharmacy

                //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
                ////Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                //drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                //DataSet DataSetEditPharmacies = new DataSet();
                //DataSetEditPharmacies.Merge(drPharmacies);
                ////Code Added by Loveena ends over here.
                //drSelectedPharmacy = DataSetEditPharmacies.Tables[0].Select("PharmacyId=" + DropDownListPharmacies.SelectedValue);                        
                //if (drSelectedPharmacy.Length > 0)
                //    {
                //    strReceipeintName = drSelectedPharmacy[0]["PharmacyName"].ToString();
                //    strReceipentOrganisation = drSelectedPharmacy[0]["PharmacyName"].ToString();
                //    strReceipentFaxNumber = drSelectedPharmacy[0]["FaxNumber"].ToString();

                //    }
                //if (strReceipentFaxNumber == "" || strReceipentFaxNumber == null)
                //    {
                //    //ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowError('Selected Pharmacy has no Fax Number', true);", true);
                //    HiddenFieldShowError.Value = "Selected Pharmacy has no Fax Number";
                //    return false;
                //    }
            }
            //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue.ToString());

            _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
            _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];
            _DataTableClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"];

            //Find out Category2,NormalCategory and ControlledCategoryDrugss

            DataRowsClientMedeicationsCategory2Drugs = _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')", " [ClientMedicationId] DESC ");
            DataRowsClientMedicationsNormalCategoryDrugs = _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ", " [ClientMedicationId] DESC ");
            DataRowsClientMedicationsControlledCategoryDrugs = _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')", " [ClientMedicationId] DESC ");
            DataTableClientMedicationsC2NonSampleORStockDrugs = null;
            DataTableClientMedicationsControlledNonSampleORStockDrugs = null;
            DataTableClientMedicationsNCNonSampleORStockDrugs = null;
            DataTableClientMedicationsNCNonSampleORStockDrugs = _DataTableClientMedications.Clone();
            DataTableClientMedicationsC2NonSampleORStockDrugs = _DataTableClientMedications.Clone();
            DataTableClientMedicationsControlledNonSampleORStockDrugs = _DataTableClientMedications.Clone();
            try
            {
                if (DataRowsClientMedicationsNormalCategoryDrugs.Length > 0)
                {
                    foreach (DataRow dr in DataRowsClientMedicationsNormalCategoryDrugs)
                    {
                        DataRow[] drInstructions = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));

                        foreach (DataRow dr1 in drInstructions)
                        {
                            if (_strMedicationInstructionIds == "")
                            {
                                _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                            }
                            else
                            {
                                _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"].ToString();
                            }
                        }
                        if (_strMedicationInstructionIds != "")
                        {
                            //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                            DataRow[] dr2 = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ") and (Pharmacy+Sample+Stock>0) ");
                            //Changes end over here
                            if (dr2.Length > 0)
                            {
                                DataTableClientMedicationsNCNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //DataRows to be disposed
            }

            //Category 2 Drugs
            if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
            {
                foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                {
                    DataRow[] drInstructions = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));

                    foreach (DataRow dr1 in drInstructions)
                    {
                        if (_strMedicationInstructionIds == "")
                        {
                            _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                        }
                        else
                        {
                            _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"].ToString();
                        }
                    }
                    if (_strMedicationInstructionIds != "")
                    {
                        //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                        DataRow[] dr2 = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ") and (Pharmacy+Sample+Stock>0) ");
                        //Changes end over here 
                        if (dr2.Length > 0)
                        {
                            DataTableClientMedicationsC2NonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                        }
                    }
                }
            }
            //Controlled Drugs
            if (DataRowsClientMedicationsControlledCategoryDrugs.Length > 0)
            {
                foreach (DataRow dr in DataRowsClientMedicationsControlledCategoryDrugs)
                {
                    DataRow[] drInstructions = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));

                    foreach (DataRow dr1 in drInstructions)
                    {
                        if (_strMedicationInstructionIds == "")
                        {
                            _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                        }
                        else
                        {
                            _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"].ToString();
                        }
                    }
                    if (_strMedicationInstructionIds != "")
                    {
                        //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                        DataRow[] dr2 = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ") and (Pharmacy+Sample+Stock>0) ");
                        if (dr2.Length > 0)
                        {
                            DataTableClientMedicationsControlledNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                        }
                    }
                }
            }
            DataSet dsTemp = new DataSet();
            dsTemp.Merge(DataTableClientMedicationsC2NonSampleORStockDrugs);
            if (dsTemp.Tables.Count > 0)
            {
                dsTemp.Tables[0].TableName = "ClientMedicationsC2NonSampleORStockDrugs";
            }
            else
            {
                dsTemp.Merge(new DataTable("ClientMedicationsC2NonSampleORStockDrugs"));
            }
            dsTemp.Merge(DataTableClientMedicationsNCNonSampleORStockDrugs);
            if (dsTemp.Tables.Count > 1)
            {
                dsTemp.Tables[1].TableName = "ClientMedicationsNCNonSampleORStockDrugs";
            }
            else
            {
                dsTemp.Merge(new DataTable("ClientMedicationsNCNonSampleORStockDrugs"));
            }
            dsTemp.Merge(DataTableClientMedicationsControlledNonSampleORStockDrugs);
            if (dsTemp.Tables.Count > 2)
            {
                dsTemp.Tables[2].TableName = "ClientMedicationsControlledNonSampleORStockDrugs";
            }
            else
            {
                dsTemp.Merge(new DataTable("ClientMedicationsControlledNonSampleORStockDrugs"));
            }
            int _Category2Drugs = 0;
            int _OtherCategoryDrugs = 0;
            int _ControlledDrugs = 0;
            int nCategory2ScriptCount = 0;
            int nOtherCategoryScriptCount = 0;
            int nControlledScriptCount = 0;
            int iMedicationRowsCount = 0;
            if (dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"] != null)
            {
                _Category2Drugs = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
            }
            if (dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"] != null)
            {
                _OtherCategoryDrugs = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;
            }
            if (dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"] != null)
            {
                _ControlledDrugs = dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;
            }
            nCategory2ScriptCount = _Category2Drugs;
            nOtherCategoryScriptCount = ScriptsCount(_OtherCategoryDrugs);
            nControlledScriptCount = _ControlledDrugs;
            int NoOfRowsToBeCopied = 0;

            #region Generate Category2Scripts
            NoOfRowsToBeCopied = 0;
            for (int icount = 1; icount <= nCategory2ScriptCount; icount++)
            {
                iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                GenerateScriptsTableRows('N', iMedicationRowsCount, dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"], NoOfRowsToBeCopied, "C2");
                //NoOfRowsToBeCopied = NoOfRowsToBeCopied + 3;
                NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
            }
            #endregion

            #region Generate OtherCategoryScripts
            NoOfRowsToBeCopied = 0;
            for (int icount = 1; icount <= nOtherCategoryScriptCount; icount++)
            {
                iMedicationRowsCount = 0;
                int iloopCounter = 0;
                iMedicationRowsCount = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;
                GenerateScriptsTableRows('N', iMedicationRowsCount, dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"], NoOfRowsToBeCopied, "NC");
                NoOfRowsToBeCopied = NoOfRowsToBeCopied + 3;
            }
            #endregion

            #region Generate ControlledCategoryScripts
            NoOfRowsToBeCopied = 0;
            for (int icount = 1; icount <= nControlledScriptCount; icount++)
            {
                iMedicationRowsCount = 0;
                int iloopCounter = 0;
                iMedicationRowsCount = dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;
                GenerateScriptsTableRows('N', iMedicationRowsCount, dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"], NoOfRowsToBeCopied, "CT");
                //NoOfRowsToBeCopied = NoOfRowsToBeCopied + 3;
                NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
            }
            #endregion

            //Remove the Last Row From ClientMedicationScripts Table which was generated in New Order Page just to Enforce Relations
            DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0].Delete();
            DataSet DataSetTemp = new DataSet();
            // DataSetTemp = ObjectClientMedication.UpdateClientScripts(DataSetClientScripts);
            //DataSetTemp = ObjectClientMedication.UpdateDocuments(DataSetClientMedications);
            ObjectClientMedication = null;

            #region UpdateClientScriptActivities
            //Following code will be used to update ClientScriptActivities table
            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
            //HiddenFieldAllFaxed.Value = "1";
            ////Send Fax if ordering Method is Fax
            bool FlagForImagesDeletion = false;
            if (OrderingMethod == 'F')
            {
                #region Sending Fax
                for (int icount = 0; icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count; icount++)
                {
                    if (icount == 0)
                    {
                        FlagForImagesDeletion = true;
                    }
                    else
                    {
                        FlagForImagesDeletion = false;
                    }
                    _strScriptsTobeFaxedButPrinted = false;
                    string strSelectClause = "ISNULL(DrugCategory,0)=2  and  ClientMedicationScriptId=" + DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"].ToString();
                    if (DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause).Length > 0)
                    {
                        _strScriptsTobeFaxedButPrinted = true;
                        //HiddenFieldAllFaxed.Value = "0";
                    }
                    //If Non controlled Drugs
                    if (_strScriptsTobeFaxedButPrinted)
                    {
                        //Error here 9anj Please Check)
                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion);
                    }
                    //If Controlled Drugs
                    else
                    {
                        // bool ans1 = SendToFax(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), Convert.ToInt32(DropDownListPharmacies.SelectedValue), FlagForImagesDeletion);
                        // if (_strPrintChartCopy == "true" && ans1 == true)

                        if (_strPrintChartCopy == "true")
                        {
                            PrintChartCopy(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]));
                        }
                        //Added by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
                        //If Sending Fax failed 
                        //else if (ans1 == false) //If Sending Fax failed
                        //    {
                        //    PrintPrescription(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]));
                        //    }
                    }
                }
                ObjectClientMedication = new ClientMedication();
                //DataSetTempMeds = ObjectClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                ObjectClientMedication = null;
                #endregion
            }
            else
            {
                #region Sending Results to printer
                for (int icount = 0; icount < DataSetClientMedications.Tables["ClientMedications"].Rows.Count; icount++)
                {
                    if (icount == 0)
                    {
                        FlagForImagesDeletion = true;
                    }
                    else
                    {
                        FlagForImagesDeletion = false;
                    }
                    bool ans = SendToPrinter(Convert.ToInt32(DataSetClientMedications.Tables["ClientMedications"].Rows[icount]["ClientMedicationId"]), FlagForImagesDeletion);
                }
                ObjectClientMedication = new ClientMedication();
                //DataSetTempMeds = ObjectClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                ObjectClientMedication = null;
                #endregion
            }

            #endregion


            //After ClientScript Activities have been updated Discontinue old Medications in case Choosen method was Change Order
            DataRow[] DataRowsClientMedicationsToBeDiscontinued;
            DataRow[] DataRowsClientMedicationsToBeRefilled;
            DataSet _DataSetClientMedications = null;

            //Session["DataSetPrescribedClientMedications"] = null;
            Session["medicationIdList"] = null;
            if (HiddenFieldAllFaxed.Value.ToString() == "0" || OrderingMethod == 'P' || _strChartCopiesToBePrinted == true)
            {
                //ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "PrintMedicationScript('" + _strScriptIds + "','" + HiddenFieldAllFaxed.Value.ToString() + "','" + _strChartScripts + "',true);", true);
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "PrintMedicationScript('138771','" + HiddenFieldAllFaxed.Value.ToString() + "','" + _strChartScripts + "',true);", true);
            }
            else if (_strFaxFailed == true)// in case sending fax failed 
            {
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "PrintMedicationScript('" + _strFaxFailedScripts + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',false);", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
            }
            return true;//true should be returned only if document has been updated successfully reference Task #50 MM1.5
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            DataSetClientScripts = null;
            DataSetClientScriptActivities = null;
            DataSetClientMedications = null;
            _DataTableClientMedications = null;
            _DataSetClientSummary = null;
            _DataTableClientMedicationInstructions = null;
            DataTableClientMedicationsNCSampleORStockDrugs = null;
            DataTableClientMedicationsNCNonSampleORStockDrugs = null;
            DataTableClientMedicationsC2SampleORStockDrugs = null;
            DataTableClientMedicationsC2NonSampleORStockDrugs = null;
            DataSetPharmacies = null;
            drSelectedPharmacy = null;
            DataRowsClientMedeicationsCategory2Drugs = null;
            DataRowsClientMedicationsNormalCategoryDrugs = null;
            DataRowsClientMedicationsControlledCategoryDrugs = null;
            _strPrintChartCopy = null;
            _strMedicationInstructionIds = null;
        }
    }
    private void GenerateScriptsTableRows(char SampleOrStock, int iMedicationRowsCount, DataTable DataTableMedicationDetails, int NoOfRowsToBeCopied, string DrugCategory)
    {
        //  DataRow drClientMedicationScripts = DataSetClientScripts.Tables["ClientMedicationScripts"].NewRow();
        //Added By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
        //DataRow drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();
        DataRow drClientMedicationScripts = null;
        //if (_UpdateTempTables == true)
        //    drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
        //else
        drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();
        DataRow dr = null;
        DataRow[] dataRowsClientMedicationScriptDrugs = null;
        string _strMedicationInstructionIds = "";
        try
        {
            drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
            if (OrderingMethod == 'F')
            {
                //if (DropDownListPharmacies.SelectedIndex != 0)
                //    drClientMedicationScripts["PharmacyId"] = Convert.ToInt32(DropDownListPharmacies.SelectedValue.ToString());
            }
            else
            {
                drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
            }
            drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
            //drClientMedicationScripts["StockOrSample"] = SampleOrStock;
            drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
            //drClientMedicationScripts["PatientConsent"] = System.DBNull.Value;                      
            drClientMedicationScripts["OrderingPrescriberId"] = DataTableMedicationDetails.Rows[0]["PrescriberId"];
            drClientMedicationScripts["OrderingPrescriberName"] = DataTableMedicationDetails.Rows[0]["PrescriberName"];

            //drClientMedicationScripts["OrderDate"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
            //if (_UpdateTempTables == true)
            //    {
            //    drClientMedicationScripts["OrderDate"] = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
            //    }
            //else
            //    {
            //drClientMedicationScripts["OrderDate"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
            //}          
            //if (DropDownListLocations.SelectedIndex != 0 || DropDownListLocations.SelectedIndex != -1)
            //    drClientMedicationScripts["LocationId"] = LocationId;
            //else
            drClientMedicationScripts["LocationId"] = System.DBNull.Value;
            //if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
            //    drClientMedicationScripts["ScriptEventType"] = "C";
            //else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
            //    drClientMedicationScripts["ScriptEventType"] = "R";
            //else
            drClientMedicationScripts["ScriptEventType"] = "N";
            drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScripts["CreatedDate"] = DateTime.Now;
            drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScripts["ModifiedDate"] = DateTime.Now;

            //DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
            //if (_UpdateTempTables == true)
            //    DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
            //else
            DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
            int iloopCounter = 1;
            if (DrugCategory == "C2" || DrugCategory == "C3" || DrugCategory == "C4" || DrugCategory == "C5" || DrugCategory == "CT")
            {
                iloopCounter = ((NoOfRowsToBeCopied + 1) > iMedicationRowsCount) ? iMedicationRowsCount : (NoOfRowsToBeCopied + 1);
            }
            else
            {
                iloopCounter = ((NoOfRowsToBeCopied + 3) > iMedicationRowsCount) ? iMedicationRowsCount : (NoOfRowsToBeCopied + 3);
            }
            for (int i = NoOfRowsToBeCopied; i < iloopCounter; i++)
            {
                _strMedicationInstructionIds = "";
                dr = null;
                dr = DataTableMedicationDetails.Rows[i];
                DataRow[] drInstructions = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + dr["ClientMedicationId"].ToString());
                foreach (DataRow dr1 in drInstructions)
                {
                    if (_strMedicationInstructionIds == "")
                    {
                        _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                    }
                    else
                    {
                        _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"].ToString();
                    }
                }
                if (_strMedicationInstructionIds != "")
                {
                    // dataRowsClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                    //if (_UpdateTempTables == true)
                    //    dataRowsClientMedicationScriptDrugs = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                    //else
                    dataRowsClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                    //Added end By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                }
                //Update the ScriptId into ClientMedicationScriptDrugs
                foreach (DataRow drMedicationScriptDrugs in dataRowsClientMedicationScriptDrugs)
                {
                    //Changes as per New Data Model
                    drMedicationScriptDrugs["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                    #region CommnetedCode as per New Data Model Changes
                    #endregion

                    //Following code added by Sonia
                    //Ref Task #67 1.6.1 - Special Instructions Changes
                    //Special Instructions needs to be updated in the new ClientMedicationScriptDrugs with the latest value of special Instructions in ClientMedications Table
                    drMedicationScriptDrugs["SpecialInstructions"] = dr["SpecialInstructions"];
                    //Code changed end over here
                }
                if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                {

                    //Added By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                    ////using (DataView DataViewClientMedicationScriptDrugs = new DataView(DataSetClientMedications.Tables["ClientMedicationScriptDrugs"], "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")", "EndDate Desc", DataViewRowState.CurrentRows))
                    ////{
                    ////    DataRow DataRowClientMedication = DataSetClientMedications.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                    ////    DataRowClientMedication["MedicationEndDate"] = DataViewClientMedicationScriptDrugs[0]["EndDate"];
                    ////  //  DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"] = DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"];

                    ////}
                    //if (_UpdateTempTables == true)
                    //    {

                    //    using (DataView DataViewClientMedicationScriptDrugs = new DataView(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"], "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")", "EndDate Desc", DataViewRowState.CurrentRows))
                    //        {
                    //        DataRow DataRowClientMedication = DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                    //        DataRowClientMedication["MedicationEndDate"] = DataViewClientMedicationScriptDrugs[0]["EndDate"];
                    //        //  DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"] = DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"];

                    //        }
                    //    }
                    //else
                    //    {
                    using (DataView DataViewClientMedicationScriptDrugs = new DataView(DataSetClientMedications.Tables["ClientMedicationScriptDrugs"], "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")", "EndDate Desc", DataViewRowState.CurrentRows))
                    {
                        DataRow DataRowClientMedication = DataSetClientMedications.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                        DataRowClientMedication["MedicationEndDate"] = DataViewClientMedicationScriptDrugs[0]["EndDate"];
                        //  DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"] = DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"];
                    }
                    //}
                    //Added end By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                }
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Event Name -GenerateScriptsTableRows()";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            string strErrorMessage = "Error occured while Creating Scripts";
            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            HiddenFieldShowError.Value = strErrorMessage;
        }
        finally
        {
            drClientMedicationScripts = null;
            dr = null;
            dataRowsClientMedicationScriptDrugs = null;
        }
    }

    private int ScriptsCount(int NumberOfDrugs)
    {
        int ScriptCount = 0;
        int rem = 0;
        if (NumberOfDrugs != 0)
        {
            ScriptCount = (NumberOfDrugs / 3);
            rem = (NumberOfDrugs % 3);
            if (rem > 0)
                ScriptCount++;
        }
        return ScriptCount;
    }
    public bool SendToPrinter(int ScriptId, bool FlagForImagesDeletion)
    {
        #region Sending Results to printer
        DataSet DataSetTemp = null;
        try
        {
            GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "P");

            if (_strScriptIds == "")
            {
                _strScriptIds += ScriptId;
            }
            else
            {
                _strScriptIds += "^" + ScriptId;
            }

            //#region InsertRowsIntoClientScriptActivities
            //////Insert Rows into ClientScriptActivities
            //DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            //drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
            //drClientMedicationScriptsActivity["Method"] = 'P';
            //drClientMedicationScriptsActivity["PharmacyId"] = System.DBNull.Value;
            //drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
            //drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
            //drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
            //drClientMedicationScriptsActivity["FaxImageData"] = renderedBytes;
            ////    drClientMedicationScriptsActivity["FaxImageData"] = System.DBNull.Value; 

            ////Added By chandan for task #85 
            ////if (CheckBoxPrintChartCopy.Checked == true)
            ////    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
            ////else
            //drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

            //drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            //drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            //drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            //drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            //drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            //DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);


            //#endregion
            return true;
        }
        catch (System.Runtime.InteropServices.COMException ex)
        {
            string strEx = ex.Message.ToString();
            throw (ex);
        }
        finally
        {


            DataSetTemp = null;
        }

        #endregion
    }
    public void PrintPrescription(int ScriptId)
    {
        try
        {
            //RDLC to be rendered for Chart Copy of Faxed Document
            //Added by chandan on 21st Nov 2008 for creating report  
            //Added by Loveena in ref to Task#2660
            FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
            try
            {
                GetRDLCContents(ScriptId, false, true, "P");
                using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                {
                    //Ref to Task#2660
                    //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), false, false);
                    objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, false, false);
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
            }
            _strFaxFailed = true;
            if (_strFaxFailedScripts == "")
            {
                _strFaxFailedScripts += ScriptId;
            }
            else
            {
                _strFaxFailedScripts += "^" + ScriptId;
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function PrintPrescription() of Prescribe Screen";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }

    }
    public void PrintChartCopy(int ScriptId)
    {
        try
        {
            //RDLC to be rendered for Chart Copy of Faxed Document
            GetRDLCContents(ScriptId, false, false, "X");
            _strChartCopiesToBePrinted = true;
            //Modified in ref to Task#2660
            //if (_strChartScripts == "")
            //    {
            //    _strChartScripts += ScriptId;
            //    }
            //else
            //    {
            //    _strChartScripts += "^" + ScriptId;
            //    }
            if (_strChartScripts == "")
            {
                _strChartScripts += FolderId;
            }
            else
            {
                _strChartScripts += "^" + FolderId;
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function PrintChartCopy() of Prescribe Screen";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }

    }

    public void GetRDLCContents(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod)
    {
        #region Get RDLC Contents

        string _ReportPath = "";
        string mimeType;
        string encoding;
        string fileNameExtension;
        string[] streams;
        string _PrintChartCopy = "N";
        //if (CheckBoxPrintChartCopy.Checked == true)
        //    _PrintChartCopy = "Y";
        //else
        _PrintChartCopy = "N";

        //DataSet _DataSetRdl;

        //Code Added by Vikas Vyas 
        DataSet _DataSetGetRdlCName = null;
        DataSet _DataSetRdlForMainReport = null;
        DataSet _DataSetRdlForSubReport = null;
        DataRow[] dr = null;
        DataRow[] _drSubReport = null;
        string _OrderingMethod = "";
        string strErrorMessage = "";
        LogManager objLogManager = null;

        ReportParameter[] _RptParam = null;
        int LocationId = 1;
        //End
        //Block For ReportPath
        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
        try
        {
            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            return;

        }
        finally
        {
            objLogManager = null;

        }
        try
        {
            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            //Added by Chandan for getting Location Id
            //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
            //if (LocationId == 0)
            //    LocationId = 1;
            #region Added by Vikas Vyas
            //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
            _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";
            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row             
                _OrderingMethod = OrderingMethod;

                //Check For Main Report
                if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                {
                    #region Get the StoredProceudreName and Execute
                    string _StoredProcedureName = "";
                    string _ReportName = "";
                    _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();//Get the StoredProcedure Name
                    _ReportName = dr[0]["DocumentName"].ToString();
                    this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                    this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                    this.reportViewer1.LocalReport.DataSources.Clear();

                    //Get Data For Main Report
                    //One More Parameter Added by Chandan Task#85 MM1.7
                    //_DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID);
                    _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, 138771, "P", 1, 98, "N", "qad3k4yy00h4p4itycilf3qn", string.Empty);
                    //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);


                    Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                    //Added by Chandan 0n 18th Dec 2008
                    //Session["DataSetRdlTemp"] = null;
                    DataSet dstemp = (DataSet)Session["DataSetRdlTemp"];
                    if (dstemp == null)
                    {
                        dstemp = _DataSetRdlForMainReport;
                    }
                    else
                    {
                        dstemp.Merge(_DataSetRdlForMainReport);
                    }
                    Session["DataSetRdlTemp"] = dstemp;
                    HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                    HiddenFieldReportName.Value = _ReportName;

                    #endregion
                    if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                    {
                        _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();
                        reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                        reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                        for (int i = 0; i < _drSubReport.Length; i++)
                        {
                            if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                            {
                                #region Get the StoredProcedureName For SubReport and Execute
                                string _SubReportStoredProcedure = "";
                                string _SubReportName = "";
                                _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                //Get Data For SubReport                                
                                //_DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID);
                                _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, 138771, "P", 1, 98, "N", "qad3k4yy00h4p4itycilf3qn", string.Empty);
                                Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                reportViewer1.LocalReport.DataSources.Add(rds);
                                string strRootPath = Server.MapPath(".");
                                System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");
                                reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);
                                #endregion
                            }
                        }
                    }
                    //Following parameters added with ref to Task 2371 SC-Support
                    _RptParam = new ReportParameter[2];
                    _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                    _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                    reportViewer1.LocalReport.SetParameters(_RptParam);
                    reportViewer1.LocalReport.Refresh();
                    reportViewer1.LocalReport.DataSources.Add(DataSource);
                }
            }
            #endregion

            //Added by Rohit. Ref ticket#84
            string reportType = "PDF";
            IList<Stream> m_streams;
            m_streams = new List<Stream>();
            Microsoft.Reporting.WebForms.Warning[] warnings;
            string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";

            //Commented by Vikas Vyas In ref to 2334  
            //  reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
            //_DataSetRdl = objectClientMedications.GetClientMedicationRDLDataSet(ScriptId);
            //_ReportPath = Server.MapPath("RDLC\\MedicationReport.rdlc");
            //ProcessRdlReport("DataSetMedication_ssp_SCGetClientMedicationScriptDatatry", _DataSetRdl, _ReportPath, ToBeFaxed, ScriptId.ToString());
            //End
            //Added by Loveena in ref to Task#2660
            FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
            //Code Added by Vikas Vyas In ref to 2334
            if (ToBeFaxed == false)
            {
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        //In case of Ordering method as X Chart copy will be printed
                        if (OrderingMethod == "X")
                        {
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, true);
                        }
                        else  //In case of Ordering method as P Chart copy will not be printed
                        {
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, false);
                        }
                        //Added by Rohit. Ref ticket#84
                        renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                }
                finally
                {
                    objLogManager = null;
                }

            }
            //if (ToBeFaxed)//Commented by Vikas Vyas In ref to 2334
            else
            {
                //Commented by Rohit. Ref ticket#84
                //string reportType = "PDF";
                //IList<Stream> m_streams;
                //m_streams = new List<Stream>();
                //Microsoft.Reporting.WebForms.Warning[] warnings;
                //string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";
                renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                // Create PDF from rendered Bytes to send as an attachment
                string strScriptRenderingPath = Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name;
                //  string strPath = "RDLC\\" + 
                if (!System.IO.Directory.Exists(strScriptRenderingPath))
                {
                    System.IO.Directory.CreateDirectory(strScriptRenderingPath);
                }
                Stream fs = new FileStream(strScriptRenderingPath + "\\MedicationScript.pdf", FileMode.Create);
                fs.Write(renderedBytes, 0, renderedBytes.Length);
                fs.Close();
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            //    //Added by Vikas Vyas In ref to task 2334 On Dated March 04th 2008
            _DataSetGetRdlCName = null;
            _DataSetRdlForMainReport = null;
            _DataSetRdlForSubReport = null;
            _RptParam = null;
            ////End
        }

        #endregion
    }

    public void SetSubDataSource(object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
    {
        try
        {
            Microsoft.Reporting.WebForms.LocalReport rptTemp = (Microsoft.Reporting.WebForms.LocalReport)sender;
            DataTable dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
            e.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource(e.DataSourceNames[0], dtTemp));
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
    }
}
