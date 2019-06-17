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

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_PatientConsentHistory : Streamline.BaseLayer.BaseActivityPage
    {
        #region---Global Variables---
        DataSet _DataSetClientMedications;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications;
        string strErrorMessage;
        DataTable _DataTableClientMedications;
        private System.Data.DataView _DataViewClientsMeddication;
        DataSet _DataSetClientMedication = new DataSet();
        DataSet _DataSetClientConsentHistory;
        #endregion
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                //Added in ref to Task#2895
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }
                this.ButtonApplyFilter.Attributes.Add("onclick", "javascript:return CheckDates('" + this.TextBoxConsentStartDate.ClientID + "'" + ",'" + this.TextBoxConsentEndDate.ClientID + "','" + LabelError.ClientID + "')");
                DropDownConsentMedication.Attributes.Add("onchange", "SetMedicationFilterValue()");
                #region--Error Message color
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                #endregion
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ViewMedicationHistory--Page_Load(), ParameterCount -0 ###";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                if (ex.Message == "Session Expired")
                    ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), " HideViewHistory('" + ex.Message + "');", true);
            }
        }
        #region---User defined function---
        /// <summary>
        /// <Description>Used to Assign data to the controls on the page</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>29 Oct 2009</CreatedOn>
        /// </summary>
        public override void Activate()
        {
            try
            {               
                Session["DataSetClientMedicationsHistory"] = null;
                this.TextBoxConsentStartDate.Attributes.Add("onblur", "SetDateFormat(this)");
                this.TextBoxConsentEndDate.Attributes.Add("onblur", "SetDateFormat(this)");
                base.Activate();
                //Code added by Loveena in ref to Task#3234 2.3 Show Client Demographics on All Client Pages 
                if (Session["DataSetClientSummary"] != null)
                {
                    DataSet _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    //Modified by Loveena in ref to Task#3265
                    LabelClientName.Text = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();                    
                }
               // TextBoxConsentStartDate.Text = DateTime.Now.AddYears(-1).ToString("MM/dd/yyyy");
                //commented By Priya and Add After Display Medication List 
                //As per task no:2979
                GetClientConsentHistory(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                string currentDate = DateTime.Now.ToString("MM/dd/yyyy");
                FillMedication();
                HiddenFieldMedication.Value = DropDownConsentMedication.SelectedValue;
                TextBoxConsentStartDate.Text = DateTime.Now.AddYears(-1).ToString("MM/dd/yyyy");
                string sFilter = SetFilter();
                if (sFilter.Length > 0)
                    DisplayMedicationData(sFilter);
                else
                {
                    //    strErrorMessage = "End Date should be Greater than Start Date";
                    //    #region "error message colors"
                    //    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                    //    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                    //    #endregion
                    //   // ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ViewMedicationHistory--Page_Load(), ParameterCount -0 ###";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                if (ex.Message == "Session Expired")
                    ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), " HideViewHistory('" + ex.Message + "');", true);
            }
        }
        /// <summary>
        /// <Description>Enable/Disable buttons based on staff Permissions</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Oct 29,2009</CreatedOn>
        /// </summary>
        /// <param name="per"></param>
        /// <returns></returns>
        public string enableDisabled(Permissions per)
        {
            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User) != null)
            {
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
                    return "";
                else
                    return "Disabled";
            }
            else
            {
                return "Disabled";
            }
        }
        /// <summary>
        /// Author Sonia
        /// Purpose:-To Download the Client's Medication Summary Data
        /// </summary>
        private void GetClientConsentHistory(Int64 ClientId)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                _DataSetClientMedications = new DataSet();
                Session["DataSetClientConsentHistory"] = null;
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                if (ClientId > 0)
                {
                    _DataSetClientMedications = objectClientMedications.DownloadClientConsentHistory(ClientId);
                    Session["DataSetClientConsentHistory"] = _DataSetClientMedications;
                    string currentDate = DateTime.Now.ToShortDateString();
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientConsentHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                objectClientMedications = null;
            }
        }
        /// <summary>
        /// <Description>Used to display those medication data which are consent</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Oct 29,2009</CreatedOn>
        /// </summary>
        /// <param name="Filter"></param>
        private void DisplayMedicationData(string Filter)
        {
            DataSet _DataSetClientConsentHistory;
            DataRow[] DataRowsClientMedications = null;
            DataRow[] DataRowsClientMedicationInstructions = null;
            DataSet _DataSetClientConsentFilteredHistory = null;
            string Medicationsfilter = "";
            try
            {
                _DataSetClientConsentHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
               // _DataSetClientConsentHistory = new DataSet();
                //Session["DataSetConsentMedicationHistory"] = null;
                string MedicationId = "";
                if (Session["DataSetClientConsentHistory"] != null)
                    _DataSetClientConsentHistory = (DataSet)Session["DataSetClientConsentHistory"];

                DataTable dtTempMedicationInstructions = new DataTable();
                DataTable dtTempMedications = new DataTable();
                dtTempMedicationInstructions = _DataSetClientConsentHistory.Tables["ClientMedicationInstructions"].Clone();
                dtTempMedications = _DataSetClientConsentHistory.Tables["ClientMedications"].Clone();
                // _DataSetClientConsentHistory.Merge(_DataSetClientMedications);

                if (Filter == "")
                {
                    DataRowsClientMedications = _DataSetClientConsentHistory.Tables["ClientMedications"].Select("1=0");
                    DataRowsClientMedicationInstructions = _DataSetClientConsentHistory.Tables["ClientMedicationInstructions"].Select("1=0");
                }
                else
                {
                    DataRowsClientMedications = _DataSetClientConsentHistory.Tables["ClientMedications"].Select("1=1");
                    //added By Priya Ref:Task No:2979
                    if (Filter == "All")
                        DataRowsClientMedicationInstructions = _DataSetClientConsentHistory.Tables["ClientMedicationInstructions"].Select("1=1");
                    else
                    DataRowsClientMedicationInstructions = _DataSetClientConsentHistory.Tables["ClientMedicationInstructions"].Select(Filter);
                    
                }
                
                _DataSetClientConsentFilteredHistory = new DataSet();
                _DataSetClientConsentFilteredHistory.Merge(DataRowsClientMedications);
                if (_DataSetClientConsentFilteredHistory.Tables.Count > 0)
                {
                    _DataSetClientConsentFilteredHistory.Tables[0].TableName = "ClientMedications";
                }
                _DataSetClientConsentFilteredHistory.Merge(DataRowsClientMedicationInstructions);
                if (_DataSetClientConsentFilteredHistory.Tables.Count > 1)
                {
                    _DataSetClientConsentFilteredHistory.Tables[1].TableName = "ClientMedicationInstructions";
                }
                //The following session is used for sorting purpose
                Session["DataSetConsentMedicationHistory"] = _DataSetClientConsentFilteredHistory;
                ConsentHistoryList1.Activate();
                ConsentHistoryList1.SortString = "ConsentStartDate DESC";
                ConsentHistoryList1.GenerationConsentTabControlRows(_DataSetClientConsentFilteredHistory.Tables["ClientMedications"], _DataSetClientConsentFilteredHistory.Tables["ClientMedicationInstructions"]);
                if (Filter != "")
                {
                    if (_DataSetClientConsentFilteredHistory.Tables["ClientMedicationInstructions"]!=null)
                    {
                        if (_DataSetClientConsentFilteredHistory.Tables["ClientMedicationInstructions"].Rows.Count == 0)
                        {
                            string strErrorMessage = "No Records Found matching Search Criteria";
                            #region "error message color added by rohit ref. #121"
                            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                            #endregion
                            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                string strErrorMessage = "Error in loading page";
                //ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            }
            finally
            {
                _DataSetClientConsentHistory = null;
                DataRowsClientMedications = null;
                DataRowsClientMedicationInstructions = null;
            }
        }
        /// <summary>
        /// <Description>Used to handles the ButtonApplyFilter click event</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>29 Oct 2009</CreatedOn>
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonApplyFilter_Click(object sender, EventArgs e)
        {
            try
            {
               // FillMedication();
               // DropDownConsentMedication.SelectedValue = HiddenFieldMedication.Value;
                HiddenFieldMedication.Value = DropDownConsentMedication.SelectedValue;

                string sFilter = SetFilter();
                if (sFilter.Length > 0)
                    DisplayMedicationData(sFilter);
                else
                {
                    DisplayMedicationData(sFilter);
                    strErrorMessage = "End Date should be Greater than Start Date";
                    #region "error message color"
                    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                    #endregion
                    ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "fnHideParentDiv1();", true);

            }

        }
        /// <summary>
        /// <Description>Used to set the Filter string for DataTable Rows filtering Based on TextBoxes Values</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>29 Oct 2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        private string SetFilter()
        {
            try
            {

                string ConsentStartDate = TextBoxConsentStartDate.Text.ToString();
                string ConsentEndDate = TextBoxConsentEndDate.Text.ToString();
                string StartDate = "";
                string EndDate = "";
                //to apply filter on basis of Medication
                string Medication = HiddenFieldMedication.Value;
                string Filter = "";
                DateTime DEndDate = new DateTime();
                DateTime DStartDate = new DateTime();
                if (ConsentStartDate != string.Empty)
                {
                    DStartDate = Convert.ToDateTime(ConsentStartDate);
                    StartDate = Convert.ToString(DStartDate);
                }
                Filter = "";
                #region---Comented Code---
                
                //code Added By Priya Ref: Task no: 2979
                if (ConsentStartDate == string.Empty || ConsentStartDate == null || ConsentStartDate == "")
                    return "All";

                if (ConsentEndDate != string.Empty && ConsentEndDate != null && ConsentEndDate != "")
                {
                    DEndDate = Convert.ToDateTime(ConsentEndDate).AddDays(01);
                    EndDate = Convert.ToString(DEndDate);
                    if (DEndDate != null)
                    {
                        if (DEndDate >= DStartDate)
                        {
                            if (Medication == "0" || Medication == "" || Medication == string.Empty)
                            {
                                Filter = "(ConsentStartDate > ='" + StartDate + "') and (ConsentEndDate <='" + EndDate + "')";
                            }
                            else
                            {
                                Filter = "(ConsentStartDate > ='" + StartDate + "') and (ConsentEndDate <='" + EndDate + "') and MedicationNameId=" + Medication;
                            }
                        }
                        else
                        {
                            return "";
                        }
                    }
                    else
                    {
                        if (Medication == "0" || Medication == "" || Medication == string.Empty)
                        {
                            return "(ConsentStartDate > ='" + StartDate + "')";
                        }
                        else
                        {
                            return "(ConsentStartDate > ='" + StartDate + "') and MedicationNameId=" + Medication;
                        }
                    }


                }
                else
                {
                    if (Medication == "0" || Medication == "" || Medication== string.Empty)
                    {
                        return "(ConsentStartDate > ='" + StartDate + "')";
                    }
                    else
                    {
                        return "(ConsentStartDate > ='" + StartDate + "') and MedicationNameId=" + Medication;
                    }
                }

                #endregion
                return Filter;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        /// <summary>
        /// <Description>To fill Medicaton when page is loaded</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>29 Oct 2009</CreatedOn>
        /// </summary>
        public void FillMedication()
        {
            try
            {
                _DataSetClientMedication = new DataSet();

                _DataSetClientConsentHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataSetClientConsentHistory = new DataSet();

                if (Session["DataSetClientConsentHistory"] != null)
                    _DataSetClientMedications = (DataSet)Session["DataSetClientConsentHistory"];

               // _DataSetClientConsentHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

               // _DataTableClientMedications = new DataTable();
               // DataRow[] _DataRowClientMedication = _DataSetClientMedications.Tables["ClientMedications"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

              //  _DataSetClientMedication.Merge(_DataRowClientMedication);

                //To Select distinct columns.
                if (_DataSetClientMedications.Tables["ClientMedications"] != null)
                {
                   // _DataTableClientMedications = _DataSetClientMedication.Tables["ClientMedications"].DefaultView.ToTable(true, "MedicationName", "MedicationNameId");

                    //if (_DataTableClientMedications != null && _DataTableClientMedications.Rows.Count > 0)
                    //{

                        //_DataViewClientsMeddication = new DataView();
                       // _DataViewClientsMeddication.Table = _DataTableClientMedications;
                      //  _DataViewClientsMeddication.Sort = "MedicationName";


                    this.DropDownConsentMedication.DataSource = this._DataSetClientMedications.Tables["ClientMedications"];
                        this.DropDownConsentMedication.DataTextField = "MedicationName";


                        this.DropDownConsentMedication.DataValueField = "MedicationNameId";
                        this.DropDownConsentMedication.DataBind();


                   // }
                }
                DropDownConsentMedication.Items.Insert(0, new ListItem("...Medications...", "0"));
                DropDownConsentMedication.SelectedIndex = 0;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }
        #endregion
        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
}
}

