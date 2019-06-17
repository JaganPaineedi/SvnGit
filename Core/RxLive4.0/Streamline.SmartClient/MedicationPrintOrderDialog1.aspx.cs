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
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
using ZfLib;
using System.Text;
using System.IO;
using System.Collections.Generic;
using Zetafax.Common;
using System.Resources;
using Zetafax;
using Microsoft.Reporting.WebForms;


public partial class MedicationPrintOrderDialog1 : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities = null;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
    Byte[] renderedBytes;
    string _strScriptIds = "";
    string strReceipeintName = "";
    string strReceipentOrganisation = "";
    //Code added by Loveena in ref to Task#2660
    string FolderId = string.Empty;
    string strReceipentFaxNumber = "";
    Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
    string _strChartScripts = "";
    bool _strChartCopiesToBePrinted = false;
    bool _boolFaxQueued = false;
    string _strPrintChartCopy = "";// System.Configuration.ConfigurationManager.AppSettings["PrintChartCopyWithFax"];
    string _strFaxFailedScriptIds = "";
    char OrderingMethod = 'F';
    string _drugInformation = "N";
    //Code added in ref to Task#2599
    DataSet _DataSetClientSummary = null;
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            CommonFunctions.Event_Trap(this);

            //Added by Loveena in ref to task#2378 - CopyrightInfo
            if (Session["UserContext"] != null)
                LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
            //Added by Loveena in ref to Task#2599
            if (Session["DataSetClientSummary"] != null)
                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            //Code ends over here.
            if (!Page.IsPostBack)
            {

                #region "error message color added by rohit ref. #121"
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                #endregion

                this.RadioButtonFaxToPharmacy.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "' ,'" + CheckBoxFaxIncludeChartCopy.ClientID + "','" + CheckBoxFaxDrugInformation.ClientID + "','" + RadioButtonPrintChartCopy.ClientID + "' )");
                this.RadioButtonPrintScript.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "','" + CheckBoxFaxIncludeChartCopy.ClientID + "','" + CheckBoxFaxDrugInformation.ClientID + "','" + RadioButtonPrintChartCopy.ClientID + "' )");
                this.CheckBoxFaxIncludeChartCopy.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "' ,'" + CheckBoxFaxIncludeChartCopy.ClientID + "','" + CheckBoxFaxDrugInformation.ClientID + "','" + RadioButtonPrintChartCopy.ClientID + "' )");
                this.RadioButtonPrintChartCopy.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "' ,'" + CheckBoxFaxIncludeChartCopy.ClientID + "','" + CheckBoxFaxDrugInformation.ClientID + "','" + RadioButtonPrintChartCopy.ClientID + "' )");
                this.ButtonOk.Attributes.Add("onclick", "javascript:return ValidateInputsPrint('" + DropDownListPharmacies.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "','" + DropDownListScriptReason.ClientID + "','" + RadioButtonPrintChartCopy.ClientID + "');");
                //Start Added By Pradeep as per task#2640
                this.DropDownListPharmacies.Attributes.Add("onchange", "CheckUncheckFaxToPharmaciesRadioButton('" + this.DropDownListPharmacies.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "');");

                //End Added By Pradeep as per task#2640
                FillPharmaciesCombo();
                FillScriptReasonCombo();
                HiddenFieldLatestClientMedicationScriptId.Value = Request.QueryString["ClientMedicationScriptId"].ToString();
                HiddenFieldOrderMethod.Value = Request.QueryString["OrderingMethod"].ToString();
                HiddenFieldMedicationOrderStatus.Value = Request.QueryString["MedicationOrderStatus"].ToString();
                Session["MedicationOrderStatus"] = HiddenFieldMedicationOrderStatus.Value;
                //Added by Chandan on 20th Jan 2010 with Ref Task#2797
                if (ApplicationCommonFunctions.AllowRePrintFax == "N")
                {
                    RadioButtonPrintScript.Enabled = false;
                    CheckBoxPrintIncludeChartCopy.Enabled = false;
                    CheckBoxPrintDrugInformation.Enabled = false;
                    RadioButtonFaxToPharmacy.Enabled = false;
                    CheckBoxFaxIncludeChartCopy.Enabled = false;
                    CheckBoxFaxDrugInformation.Enabled = false;
                    DropDownListPharmacies.Enabled = false;
                    RadioButtonPrintChartCopy.Checked = true;
                    CheckBoxPrintChartCopyDrugInformation.Enabled = false;
                }
                //End by Chandan

                //added By Priya  Ref:task no:2972
                string _AllowPrintFaxFromOrderDetails = System.Configuration.ConfigurationManager.AppSettings["AllowPrintFaxFromOrderDetails"].ToLower();
                if (_AllowPrintFaxFromOrderDetails == "false")
                {
                    RadioButtonPrintChartCopy.Enabled = true;
                    RadioButtonPrintChartCopy.Checked = true;
                    CheckBoxPrintChartCopyDrugInformation.Enabled = true;
                    DropDownListScriptReason.Enabled = true;
                    RadioButtonPrintScript.Enabled = false;
                    CheckBoxPrintIncludeChartCopy.Enabled = false;
                    CheckBoxPrintDrugInformation.Enabled = false;
                    RadioButtonFaxToPharmacy.Enabled = false;
                    RadioButtonFaxToPharmacy.Checked = false;
                    DropDownListPharmacies.Enabled = false;
                    CheckBoxFaxIncludeChartCopy.Enabled = false;
                    CheckBoxFaxDrugInformation.Enabled = false;
                }
                //end
            }


        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationPrintOrderDialog--Page_Load(), ParameterCount -0 ###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "closeDiv();", true);
        }
        finally
        {

        }

    }

    #region FillDropDowns
    /// Author Sonia
    /// <summary>
    ///  Fills the Pharmacies combo from the SharedTable's Data
    /// </summary>
    /// Modified by Loveena in ref to Task#2599 - 2599 1.9.5.15 Pharmacy Drop-Down Sort Order (Order Details) 
    //private void FillPharmaciesCombo()
    //{
    //    // To Fill Pharmacies Combo 
    //    DataSet DataSetPharmacies = null;
    //    //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
    //    DataRow[] drPharmacies = null;
    //    //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;

    //    //Code added in ref to Task#2589
    //    Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
    //    objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
    //    try
    //    {            
    //        CommonFunctions.Event_Trap(this);
    //        DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
    //        //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
    //        //Modified by Chandan for task #2453 MM#1.7.5
    //        drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7","PharmacyName asc");
    //        DataSet DataSetEditPharmacies = new DataSet();
    //        DataSetEditPharmacies.Merge(drPharmacies);
    //        //Code Added by Loveena Ends over here.

    //        //Code Modified by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified
    //        //DropDownListPharmacies.DataSource = DataSetPharmacies.Tables[0];
    //        if (DataSetEditPharmacies.Tables.Count > 0)
    //        {
    //            DropDownListPharmacies.DataSource = DataSetEditPharmacies.Tables[0];
    //            //Code Modified by Loveena ends over here.

    //            DropDownListPharmacies.DataTextField = "PharmacyName";
    //            DropDownListPharmacies.DataValueField = "PharmacyId";
    //            DropDownListPharmacies.DataBind();
    //            DropDownListPharmacies.Items.Insert(0, new ListItem(".....................Select Pharmacy.....................", "0"));
    //            DropDownListPharmacies.SelectedIndex = 0;
    //        }


    //    }
    //    catch (Exception ex)
    //    {

    //        if (ex.Data["CustomExceptionInformation"] == null)
    //            ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillPharmaciesCombo(),ParameterCount 0 - ###");
    //        else
    //            // ex.Data["CustomExceptionInformation"] =  CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"]);
    //            if (ex.Data["DatasetInfo"] == null)
    //                ex.Data["DatasetInfo"] = DataSetPharmacies;
    //        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

    //    }
    //    finally
    //    {
    //        DataSetPharmacies = null;
    //        drPharmacies = null;
    //        objectSharedTables = null;
    //    }

    //}

    void FillPharmaciesCombo()
    {
        // To Fill Pharmacies Combo 
        DataSet DataSetPharmacies = null;
        //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
        DataRow[] drPharmacies = null;
        //Code Commented in to Task#2589.
        //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
        //DataView DataViewPharmacies = null;
        string ClientPharmecieIds = "";

        //Added by Chandan with ref Task #188 1.7.1 - Prescribe Window: Pharmacy Drop-Down Display Preferred First
        DataSet DataSetClientPharmecies = new DataSet();
        DataRow[] DataRowPharmecies = null;
        DataRow[] DataRowNonClientPharmecies = null;
        //DataTableClientPharmecies = _DataSetClientSummary.Tables["ClientPharmacies"];

        //Code added in ref to Task#2589
        Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
        objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
        DataRow[] DataRowClientPharmacy = null;//Added By Pradeep as per task#2640
        try
        {
            CommonFunctions.Event_Trap(this);
            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User) != null)
            {
                DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                DataRow[] DataRowClientPharmecies = _DataSetClientSummary.Tables["ClientPharmacies"].Select("1=1");
                foreach (DataRow dr1 in DataRowClientPharmecies)
                {
                    ClientPharmecieIds += dr1["PharmacyId"] + ",";
                }
                if (DataSetPharmacies != null)
                {
                    if (DataSetPharmacies.Tables[0].Rows.Count > 0)
                    {
                        //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                        drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                        DataSet DataSetEditPharmacies = new DataSet();
                        DataSetEditPharmacies.Merge(drPharmacies);
                        //Code Added by Loveena Ends over here.
                        if (DataSetEditPharmacies != null)
                        {
                            if (DataSetEditPharmacies.Tables[0].Rows.Count > 0)
                            {
                                if (ClientPharmecieIds.Length > 0)
                                {
                                    ClientPharmecieIds = ClientPharmecieIds.TrimEnd(',');
                                    //Modified by Loveena  in ref to Task#188 to set the Pharmacies which are selected in Edit Preferred Parmacies at top of DropDown
                                    //DataRowPharmecies = DataSetPharmacies.Tables[0].Select("PharmacyId in (" + ClientPharmecieIds + ")");
                                    DataRowPharmecies = DataSetEditPharmacies.Tables[0].Select("PharmacyId in (" + ClientPharmecieIds + ")", "SequenceNumber asc");
                                    //Modified by Loveena in ref to task#188 on 12-Feb-2009 to display Pharmacies in alphabetical order.
                                    //DataRowNonClientPharmecies = DataSetPharmacies.Tables[0].Select("PharmacyId not in (" + ClientPharmecieIds + ")","PharmacyName asc");
                                    //Modified by Loveena  in ref to Task#188 to set the Pharmacies which are selected in Edit Preferred Parmacies at top of DropDown,
                                    DataRowNonClientPharmecies = DataSetEditPharmacies.Tables[0].Select("PharmacyId not in (" + ClientPharmecieIds + ")", "PharmacyName asc");

                                    DataSetClientPharmecies.Merge(DataRowPharmecies);
                                    DataSetClientPharmecies.Merge(DataRowNonClientPharmecies);
                                }
                                else
                                {
                                    //Modified by Loveena  in ref to Task#188 to set the Pharmacies which are selected in Edit Preferred Parmacies at top of DropDown
                                    //                    DataSetClientPharmecies = DataSetPharmacies;
                                    DataSetClientPharmecies = DataSetEditPharmacies;
                                }


                                //DataViewPharmacies = DataSetPharmacies.Tables[0].DefaultView;
                                //DataViewPharmacies.Sort = "PharmacyName Asc";
                                //DropDownListPharmacies.DataSource = DataViewPharmacies;



                                //Code Modified by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified
                                DropDownListPharmacies.DataSource = DataSetClientPharmecies.Tables[0];
                                //Code Modified by Loveena ends over here.
                                DropDownListPharmacies.DataTextField = "PharmacyName";
                                DropDownListPharmacies.DataValueField = "PharmacyId";
                                DropDownListPharmacies.DataBind();
                                DropDownListPharmacies.Items.Insert(0, new ListItem("........................Select Pharmacy........................", "0"));
                                DropDownListPharmacies.SelectedIndex = 0;
                            }
                        }
                        #region--Code written By Pradeep as per task#2640
                        string clientPharmacyId = string.Empty;
                        if (DataRowPharmecies != null)
                        {
                            if (DataRowPharmecies.Length > 0)
                            {
                                clientPharmacyId = DataRowPharmecies[0]["PharmacyId"] == DBNull.Value ? "" : Convert.ToString(DataRowPharmecies[0]["PharmacyId"]);
                            }
                            if (clientPharmacyId != string.Empty)
                            {
                                if (this.DropDownListPharmacies.Items.FindByValue(clientPharmacyId) != null)
                                {
                                    DropDownListPharmacies.SelectedValue = clientPharmacyId;
                                    this.RadioButtonFaxToPharmacy.Checked = true;
                                }
                            }
                        }
                        #endregion--Code written By Pradeep as per task#2640
                    }

                }
            }
        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillPharmaciesCombo(),ParameterCount 0 - ###");
            else
                // ex.Data["CustomExceptionInformation"] =  CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"]);
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetPharmacies;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

            if (DataSetPharmacies != null)
                DataSetPharmacies.Dispose();
            if (DataSetClientPharmecies != null)
                DataSetClientPharmecies.Dispose();
            //DataViewPharmacies = null;
            DataRowPharmecies = null;
            DataRowNonClientPharmecies = null;
        }

    }


    /// Author Sonia
    /// <summary>
    /// Fill the ScriptResons combo Box from SharedTables
    /// </summary>

    private void FillScriptReasonCombo()
    {

        // To Fill Locations Combo 

        DataSet DataSetScriptReasons = null;


        try
        {
            CommonFunctions.Event_Trap(this);
            DataRow[] DataRowScriptReasons = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='SCRIPTREASON' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ");
            DataSetScriptReasons = new DataSet();
            DataSetScriptReasons.Merge(DataRowScriptReasons);
            if (DataSetScriptReasons.Tables.Count > 0)
            {
                DataSetScriptReasons.Tables[0].TableName = "GlobalCodesScriptReasons";
                if (DataSetScriptReasons.Tables["GlobalCodesScriptReasons"].Rows.Count > 0)
                {
                    DropDownListScriptReason.DataSource = DataSetScriptReasons.Tables["GlobalCodesScriptReasons"];
                    DropDownListScriptReason.DataTextField = "CodeName";
                    DropDownListScriptReason.DataValueField = "GlobalCodeId";
                    DropDownListScriptReason.DataBind();

                    DropDownListScriptReason.Items.Insert(0, new ListItem("........Select Script Reason........", "0"));
                    DropDownListScriptReason.SelectedIndex = 0;
                }
            }

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillScriptReasonCombo(),ParameterCount 0 - ###");
            else
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = DataSetScriptReasons;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            DataSetScriptReasons = null;

        }

    }
    #endregion

    /// <summary>
    /// Event Handler of Ok Button Updates the ClientScriptActivities Table 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ButtonOk_Click(object sender, EventArgs e)
    {


        string _strClientScript = "";

        int PharmacyId = 0;
        //char OrderingMethod = 'F';
        //Ref to Task#2660
        string FileName = "";
        int seq = 1;
        int ScriptReason = -1;
        //Code added by Loveena in ref to Task#2597
        string strSendCoverLetter = "false";

        bool strUpdateDatabase = false;
        DataSet DataSetPharmacies = null;
        DataRow[] drSelectedPharmacy;
        //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
        DataRow[] drPharmacies = null;
        //string _strPrintChartCopy = ""; //System.Configuration.ConfigurationManager.AppSettings["PrintChartCopyWithFax"];
        Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
        objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
        try
        {
            CommonFunctions.Event_Trap(this);
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
                            {
                                //System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName);
                                while (seq < 1000)
                                {
                                    seq = seq + 1;
                                    if (!System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName))
                                    {
                                        System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName);
                                        break;
                                    }
                                    else
                                    {
                                        FileName = ApplicationCommonFunctions.GetFileName(FileName, seq);
                                    }

                                }
                            }
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


            HiddenFieldToBeFaxedButPrinted.Value = "0";
            objectClientMedications = new ClientMedication();

            if (RadioButtonFaxToPharmacy.Checked == true)
            {
                OrderingMethod = 'F';
                HiddenFieldReprintAllowed.Value = "F";
                if (CheckBoxFaxIncludeChartCopy.Checked == true)
                    _strPrintChartCopy = "true";
                else
                    _strPrintChartCopy = "false";
            }
            else if (RadioButtonPrintChartCopy.Checked == true)
            {
                OrderingMethod = 'C';
                HiddenFieldReprintAllowed.Value = "C";
                _strPrintChartCopy = "true";
            }
            else
            {
                OrderingMethod = 'P';
                HiddenFieldReprintAllowed.Value = "P";
                if (CheckBoxPrintIncludeChartCopy.Checked == true)
                    _strPrintChartCopy = "true";
                else
                    _strPrintChartCopy = "false";
            }
            if ((CheckBoxFaxDrugInformation.Checked == true) || (CheckBoxPrintChartCopyDrugInformation.Checked == true) || (CheckBoxPrintDrugInformation.Checked == true))
                _drugInformation = "Y";
            else
                _drugInformation = "N";


            if (OrderingMethod == 'F')
            {
                if (DropDownListPharmacies.SelectedIndex != 0)
                    PharmacyId = Convert.ToInt32(DropDownListPharmacies.SelectedValue.ToString());
                //get the Fax Number of Selected Pharmacy
                //Code modified in ref to Task#2589
                //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
                //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                DataSet DataSetEditPharmacies = new DataSet();
                DataSetEditPharmacies.Merge(drPharmacies);
                //Code Added by Loveena ends over here.

                //Code Modified by Loveena in ref to task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                //drSelectedPharmacy = DataSetPharmacies.Tables[0].Select("PharmacyId=" + DropDownListPharmacies.SelectedValue);
                drSelectedPharmacy = DataSetEditPharmacies.Tables[0].Select("PharmacyId=" + DropDownListPharmacies.SelectedValue);
                //Modified Cde Ends over here.
                if (drSelectedPharmacy.Length > 0)
                {
                    strReceipeintName = drSelectedPharmacy[0]["PharmacyName"].ToString();
                    strReceipentOrganisation = drSelectedPharmacy[0]["PharmacyName"].ToString();
                    strReceipentFaxNumber = drSelectedPharmacy[0]["FaxNumber"].ToString();

                }

                _strClientScript = "ShowError('Selected Pharmacy has no Fax Number',true);";
                if (strReceipentFaxNumber == "" || strReceipentFaxNumber == null)
                {
                    //The following lines are commented by Pradeep as per chat withn Tom that his sp will verify the same
                    // ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), _strClientScript, true);
                    // return;
                }

            }



            if (DropDownListScriptReason.SelectedIndex != 0)
                ScriptReason = Convert.ToInt32(DropDownListScriptReason.SelectedValue.ToString());

            //ClientMedicationScriptActivityId = objectClientMedications.InsertIntoClientMedicationScriptActivities(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), OrderingMethod, PharmacyId, ScriptReason, CreatedBy);
            //Send Fax for non-controlled medications if ordering Method is Fax
            if (OrderingMethod == 'F')
            {
                if (HiddenFieldOrderMethod.Value.IndexOf("Faxed") < 0 && HiddenFieldOrderMethod.Value.IndexOf("F") < 0)
                {
                    //Modified by Loveena in ref to Task#2642
                    strUpdateDatabase = SendToPrinter(ScriptReason, PharmacyId, strSendCoverLetter);// SendToPrinter(ScriptReason, PharmacyId);
                    HiddenFieldToBeFaxedButPrinted.Value = "1";

                    if (strUpdateDatabase)
                        _strClientScript = "PrintMedicationScript('" + _strScriptIds + "','" + _strChartScripts + "',true);";
                    else
                    {
                        string strErrorMessage = "Error in Updating Database";
                        _strClientScript = "ShowError('" + strErrorMessage + "', true);";
                    }
                }
                else
                {
                    //Modified in ref to  Task#2642
                    strUpdateDatabase = SendToFax(ScriptReason, PharmacyId, strSendCoverLetter);// SendToPrinter(ScriptReason, PharmacyId);
                    //Changes made as per Task #2371 SC-Support
                    if (strUpdateDatabase)
                    {
                        if (_strPrintChartCopy == "true" && _boolFaxQueued == true)
                        {
                            //Fax Successful but Chart copy has to be printed
                            //Modified in ref to Task#2642
                            PrintChartCopy(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), strSendCoverLetter);
                            _strClientScript = "PrintMedicationScript('" + _strScriptIds + "','" + _strChartScripts + "',true);";  //Added a new parameter by Chandan for task #99
                        }
                        //Added by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
                        // Adding New parameter for Fax Faild message
                        else if (_boolFaxQueued == false) //Fax Failed
                        {
                            //Modified by Loveena in ref to Task#2642
                            PrintPrescription(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), strSendCoverLetter);
                            _strClientScript = "PrintMedicationScript('" + _strFaxFailedScriptIds + "','" + _strChartScripts + "',false);";

                        }
                        //End Here
                        else
                            _strClientScript = "closeDiv();";
                    }
                    else
                    {
                        string strErrorMessage = "Error in Updating Database";
                        _strClientScript = "ShowError('" + strErrorMessage + "', true);";
                    }
                }


            }
            else
            {
                //Modified in ref to Task#2642
                strUpdateDatabase = SendToPrinter(ScriptReason, PharmacyId, strSendCoverLetter);
                if (strUpdateDatabase)
                {
                    //Added by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
                    // Adding New parameter for Fax Faild message
                    _strClientScript = "PrintMedicationScript('" + _strScriptIds + "','" + _strChartScripts + "',true);";
                }
                else
                {
                    string strErrorMessage = "Error in Updating Database";
                    _strClientScript = "ShowError('" + strErrorMessage + "', true);";
                }
            }

            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), _strClientScript, true);


        }


        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function ButtonOk_Click of Print Order Dialog";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            string strErrorMessage = "Error in Updating Database";
            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
        }
        finally
        {
            DataSetClientScriptActivities = null;
            drSelectedPharmacy = null;
            DataSetPharmacies = null;
            reportViewer1 = null;
            drPharmacies = null;
            objectSharedTables = null;
        }



    }
    /// Author Sonia
    /// <summary>
    /// This function is used to Send the Fax at Fax server and Updates ClientScriptActivities Table
    /// </summary>
    /// <param name="ScriptReason"></param>
    /// <param name="PharmacyId"></param>
    /// <returns>true/false</returns>
    public bool SendToFax(int ScriptReason, int PharmacyId, string SendCoveLetter)
    {
        #region Sending Fax
        // Declare objects
        ZfLib.NewMessage oNewMessage;

        DataSet DataSetTemp = null;

        string FaxUniqueId = "";
        string ChartCopy = "";
        string strZetaFaxUserName = System.Configuration.ConfigurationSettings.AppSettings["ZetaFaxUserName"];


        ZfLib.ZfAPI zfAPI = null;
        ZfLib.UserSession zfUserSession = null;
        ResourceManager rm;




        try
        {
            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();

            // Declare objects
            //Update ClientMedicationScript Tables for script Id 
            objectClientMedications.UpdateClientScripts(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), _drugInformation, PharmacyId, 'F');

            //Modified in ref to Task#2642
            GetRDLCContents(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), true, "F", SendCoveLetter);

            //Send to Fax server

            try
            {
                rm = PageBase.ConfigureResources(Request);
                zfAPI = new ZfLib.ZfAPIClass();

                if (ZetafaxConfiguration.ZetafaxServer != String.Empty)
                {
                    zfAPI.SetZetafaxDirs(ZetafaxConfiguration.ZetafaxServer,
                    ZetafaxConfiguration.ZetafaxSystem,
                    ZetafaxConfiguration.ZetafaxUsers,
                    ZetafaxConfiguration.ZetafaxRequest);
                }

                // Set up Zetafax API
                zfAPI.Escape("APPLICATION", 0x1057);    // don't check for an API licence
                zfAPI.AutoTempDirectory = true;			// use \zfax\users\<user> for temp directory
                zfAPI.EnableImpersonation = ZetafaxConfiguration.APIImpersonation;
                if (zfAPI != null)
                {

                    zfUserSession = zfAPI.Logon(strZetaFaxUserName, false);

                    //Get the RDL contents by passing Script Id 
                    oNewMessage = zfUserSession.CreateNewMsg();
                    oNewMessage.Recipients.AddFaxRecipient(strReceipeintName, strReceipentOrganisation, strReceipentFaxNumber);
                    oNewMessage.Subject = "Prescription Medication Script";
                    oNewMessage.Priority = ZfLib.PriorityEnum.zfPriorityUrgent;
                    string strScriptFilePath = Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf";
                    oNewMessage.Files.Add(strScriptFilePath);
                    // Send!
                    oNewMessage.Send();
                    //''Get Generated Unique Id of Fax at Fax Server
                    FaxUniqueId = oNewMessage.Body;
                }
            }
            catch (System.Runtime.InteropServices.COMException ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "Source function SendToFax() of Print Order Dialog";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                zfAPI = null;
                zfUserSession = null;
                oNewMessage = null;

            }



            #region InsertRowsIntoClientScriptActivities
            ////Insert Rows into ClientScriptActivities
            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            drClientMedicationScriptsActivity["ClientMedicationScriptId"] = Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
            //drClientMedicationScriptsActivity["Method"] = 'F';
            drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
            drClientMedicationScriptsActivity["Reason"] = ScriptReason;
            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            //drClientMedicationScriptsActivity["FaxStatus"] = "QUEUED";

            if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
            {
                drClientMedicationScriptsActivity["Method"] = 'F';
                //drClientMedicationScriptsActivity["FaxStatus"] = "QUEUED";
                drClientMedicationScriptsActivity["Status"] = 5561;
            }
            else
            {
                drClientMedicationScriptsActivity["Method"] = 'P';
                //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
            }

            //Added by Chandan for task #2435
            if (_strPrintChartCopy == "true")
                ChartCopy = "Y";
            else
                ChartCopy = "N";
            drClientMedicationScriptsActivity["IncludeChartCopy"] = ChartCopy;
            //end by Chandan
            //Added by sonia
            //Null should be inserted into FaxExternalIdentifier if FaxUniqueId is blank
            if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;
            else
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
            //Ended by sonia
            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
            using (
                ClientMedication _clientMedication = objectClientMedications != null
                                                         ? objectClientMedications
                                                         : new ClientMedication())
            {
                _clientMedication.SetRenderedImageData(DataSetClientScriptActivities, drClientMedicationScriptsActivity,
                                                       ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                           .UserCode, renderedBytes);
            }
            //Update ClientMedicationScript Tables for script Id 
            //objectClientMedications.UpdateClientScripts(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), _drugInformation, PharmacyId,'F');
            //End Update 
            DataSetTemp = objectClientMedications.UpdateClientScriptActivities(DataSetClientScriptActivities);


            #endregion

            if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                _boolFaxQueued = true;
            else
                _boolFaxQueued = false;

            if (DataSetTemp.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                return true;
            else
            {
                return false;
            }

        }



        catch (System.Runtime.InteropServices.COMException ex)
        {
            string strEx = ex.Message.ToString();
            throw (ex);
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            throw (ex);
        }
        finally
        {
            DataSetTemp = null;
        }

        #endregion

    }
    //Rishu for RDLC
    #region CommentedCodeNotInUse

    //private void ProcessRdlReport(string _DataSetName, DataSet _DataSetRdl, string _ReportPath,bool ToBeFaxed,string ScriptId)
    //{
    //    try
    //    {
    //        this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
    //        //this.reportViewer1.LocalReport.ReportPath = _ReportPath;
    //        this.reportViewer1.LocalReport.DataSources.Clear();
    //        this.reportViewer1.LocalReport.ReportPath = _ReportPath;
    //        Microsoft.Reporting.WebForms.ReportDataSource _DataSource = new Microsoft.Reporting.WebForms.ReportDataSource(_DataSetName, _DataSetRdl.Tables[0]);
    //        this.reportViewer1.LocalReport.DataSources.Add(_DataSource);
    //        this.reportViewer1.LocalReport.Refresh();
    //        //To be called for printing of images
    //        if (ToBeFaxed == false)
    //            using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
    //            {
    //                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId, true,false);
    //            }

    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}


    #endregion

    /// Author Sonia 
    /// <summary>
    /// This function is used to Send th Script contents at Printer and Updates ClientScriptActivities Table
    /// </summary>
    /// <param name="ScriptReason"></param>
    /// <param name="PharmacyId"></param>
    /// <returns>true/false</returns>
    public bool SendToPrinter(int ScriptReason, int PharmacyId, string SendCoveLetter)
    {
        #region Sending Results to printer
        // Declare objects

        DataSet DataSetTemp = null;
        string ChartCopy = "";
        try
        {
            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
            //Included this Line to update Print Drug Information for task #184 in Core Bugs Project.
            //Update ClientMedicationScript Tables for script Id 
            objectClientMedications.UpdateClientScripts(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), _drugInformation, 99999, 'P');
            //End Update 
            if (RadioButtonPrintScript.Checked == true)
                //Modified by Loveena in ref to Task#2642
                GetRDLCContents(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), false, "P", SendCoveLetter);
            else
            {
                //Modified by Loveena in ref to Task#2642
                //GetRDLCContents(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), false, "X", SendCoveLetter);
                //Modified by Loveena in ref to Task#2724
                if (RadioButtonFaxToPharmacy.Checked == true)
                    GetRDLCContents(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), false, "F", SendCoveLetter);
                else if (RadioButtonPrintChartCopy.Checked == true)
                    GetRDLCContents(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), false, "X", SendCoveLetter);
                //Modified by Loveena in ref to Task#2660
                //_strChartScripts += Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
                _strChartScripts += FolderId;
            }

            //Modified by Loveena in ref to Task#2660           
            // _strScriptIds += Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
            _strScriptIds += FolderId;

            #region InsertRowsIntoClientScriptActivities
            ////Insert Rows into ClientScriptActivities
            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            drClientMedicationScriptsActivity["ClientMedicationScriptId"] = Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
            //Added by Chandan with ref task #2435
            //drClientMedicationScriptsActivity["Method"] = 'P';
            drClientMedicationScriptsActivity["Method"] = OrderingMethod;
            if (_strPrintChartCopy == "true")
                ChartCopy = "Y";
            else
                ChartCopy = "N";
            drClientMedicationScriptsActivity["IncludeChartCopy"] = ChartCopy;
            //end by Chandan
            drClientMedicationScriptsActivity["PharmacyId"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["Reason"] = ScriptReason;
            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
            using (
                ClientMedication _clientMedication = objectClientMedications != null
                                                         ? objectClientMedications
                                                         : new ClientMedication())
            {
                _clientMedication.SetRenderedImageData(DataSetClientScriptActivities, drClientMedicationScriptsActivity,
                                                       ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                           .UserCode, renderedBytes);
            }            
            //Update ClientMedicationScript Tables for script Id 
            objectClientMedications.UpdateClientScripts(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), _drugInformation, 99999, 'P');
            //End Update 
            DataSetTemp = objectClientMedications.UpdateClientScriptActivities(DataSetClientScriptActivities);


            #endregion


            if (DataSetTemp.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                return true;
            else
            {
                return false;
            }


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
    /// Author Sonia,Vikas
    /// <summary>
    /// This function is used to generate the RDL of Script it generates either PDF file or Images in the User's Directory
    /// </summary>
    /// <param name="ScriptId"></param>
    /// <param name="ToBeFaxed"></param>
    /// <param name="OrderingMethod"></param>
    public void GetRDLCContents(int ScriptId, bool ToBeFaxed, string OrderingMethod, string SendCoveLetter)
    {
        #region Get RDLC Contents

        string _ReportPath = "";
        string mimeType;
        string encoding;
        string fileNameExtension;
        string[] streams;

        //DataSet _DataSetRdl;

        //Code Added by Vikas Vyas 
        DataSet _DataSetGetRdlCName = null;
        DataSet _DataSetRdlForMainReport = null;
        DataSet _DataSetRdlForSubReport = null;
        DataRow[] dr = null;
        DataRow[] _drSubReport = null;
        string _OrderingMethod = "";
        string strErrorMessage = "";
        string _ChartCopyPrint = "";

        ReportParameter[] _RptParam = null;
        //End
        //Block For ReportPath
        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
        try
        {

            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            return;

        }
        finally
        {


        }

        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        try
        {

            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008

            objectClientMedications = new ClientMedication();


            #region Added by Vikas Vyas
            //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
            //Modfied in Ref to Task#2596.
            if (ToBeFaxed == false)
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
            else
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);

            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row

                //Commented by sonia as Now ordering method will be passed as parameter to this function
                /*   if (ToBeFaxed == true)
                    _OrderingMethod = "F";
                else
                    _OrderingMethod = "P";*/

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
                    //Added by Chandan For Task #85 MM1.7                   
                    int OriginalDataUpdated = Convert.ToInt32(Session["OriginalDataUpdated"]);
                    if (_strPrintChartCopy == "true")
                        _ChartCopyPrint = "Y";
                    else
                        _ChartCopyPrint = "N";
                    _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, OriginalDataUpdated, 1, _ChartCopyPrint, Session.SessionID, string.Empty);
                    //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);

                    //Only For Testing Purpose
                    Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                    #endregion
                    if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                    {

                        _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();

                        reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                        reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);

                        for (int i = 0; i < _drSubReport.Length; i++)//Loop 
                        {
                            if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                            {
                                #region Get the StoredProcedureName For SubReport and Execute
                                string _SubReportStoredProcedure = "";
                                string _SubReportName = "";
                                _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                //Get Data For SubReport
                                //One More Parameter added by Chandan Task #85 MM1.7
                                _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), 1, _ChartCopyPrint, Session.SessionID, string.Empty);

                                Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                reportViewer1.LocalReport.DataSources.Add(rds);
                                System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);


                                #endregion

                            }

                        }//End For Loop


                    }
                    //Code addded by Loveena in ref to Task#2642                        
                    if (OrderingMethod == "F" && ToBeFaxed == true)
                    {
                        if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                        {
                            SendCoveLetter = _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
                        }
                    }
                    //Modified by Loveena in ref to Task#2642
                    _RptParam = new ReportParameter[3];
                    _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                    _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                    _RptParam[2] = new ReportParameter("CoverLetter", SendCoveLetter);
                    reportViewer1.LocalReport.SetParameters(_RptParam);
                    reportViewer1.LocalReport.SetParameters(_RptParam);
                    reportViewer1.LocalReport.Refresh();
                    reportViewer1.LocalReport.DataSources.Add(DataSource);
                }


            }




            #endregion



            //Adder by Rohit. Ref task#84
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
                        if (OrderingMethod == "X")
                            //Modified by Loveena in ref to Task#2660
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), false, true);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, false, true);
                        else
                            //Modified by Loveena in ref to Task#2660
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), false, false);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, false, false);
                    }


                    //Added by Rohit. Ref task#84
                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                }
                finally
                {
                }
            }
            else

            //if (ToBeFaxed)//Commented by Vikas Vyas In ref to 2334
            {
                //Commented by Rohit. Ref task#84
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
                    System.IO.Directory.CreateDirectory(strScriptRenderingPath);
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
            objectClientMedications = null;
            ////End
        }

        #endregion
    }
    /// Author Sonia
    /// <summary>
    /// This Mtheod is used to PrintChartCopy in case Fax has been queued
    /// </summary>
    /// <param name="ScriptId"></param>
    public void PrintChartCopy(int ScriptId, string strSendCoverLetter)
    {
        //RDLC to be rendered for Chart Copy of Faxed Document
        //Modified in ref to Task#2642
        GetRDLCContents(ScriptId, false, "X", strSendCoverLetter);
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

    /// Author Vikas
    /// <summary>
    /// This event handler is attached for the Sub Report Processing 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
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

        }




    }


    /// <summary>
    /// Added by sonia to Print Prescription in case Fax Failed
    /// task #99 MM1.6.5 </summary>
    /// <param name="ScriptId">ScriptId</param>
    public void PrintPrescription(int ScriptId, string strSendCoverLetter)
    {
        try
        {
            //RDLC to be rendered for Chart Copy of Faxed Document
            // GetRDLCContents(ScriptId, false, "P");
            //Added by chandan on 21st Nov 2008 for creating report 
            //Added by Loveena in ref to Task#2660
            FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
            try
            {
                using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                {
                    //Modified in ref to Task#2660
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
            //End by Chandan 
            //Modified in ref to Task#2660
            //if (_strFaxFailedScriptIds == "")
            //{
            //    _strFaxFailedScriptIds += ScriptId;
            //}
            //else
            //{
            //    _strFaxFailedScriptIds += "^" + ScriptId;
            //}
            if (_strFaxFailedScriptIds == "")
            {
                _strFaxFailedScriptIds += FolderId;
            }
            else
            {
                _strFaxFailedScriptIds += "^" + FolderId;
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
}
