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
    public partial class UserControls_ViewHistory : Streamline.BaseLayer.BaseActivityPage
    {
        DataSet _DataSetClientMedications;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications;
        string strErrorMessage;
        DataTable _DataTableClientMedications;
        private System.Data.DataView _DataViewClientsMeddication;
        DataSet _DataSetClientMedication = new DataSet();
        DataSet _DataSetClientMedicationHistory;
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this); this.ButtonApplyFilter.Attributes.Add("onclick", "javascript:return CheckDates('" + TextBoxStartDate.ClientID + "'" + ",'" + TextBoxEndDate.ClientID + "','" + LabelError.ClientID + "')");
                ////Added by Loveena in ref to task#2378 - CopyrightInfo
                //if (Session["UserContext"] != null)
                //    LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
                //Added in ref to Task#2895
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }

                //Added by Loveena in Ref to Task#128 on 16-Dec-2008 to set the filter value onchange
                DropDownMedication.Attributes.Add("onchange", "SetFilterValue()");
                //Added by Loveena in Ref to Task#128 on 16-Dec-2008 to set filter value onchange
                DropDownListPrescriber.Attributes.Add("onchange", "SetPrescriberFilterValue()");

                DropDownListDateFilter.Attributes.Add("onchange", "SetDateFilterValue()");

                DropDownListDiscontinuedReason.Attributes.Add("onchange", "SetDiscontinueReasonFilterValue()");

                #region "error message color added by rohit ref. #121"
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
        public override void Activate()
        {
            try
            {
                if (Session["DataSetClientSummary"] == null) { GetClientSummaryData();  }
                Session["DataSetClientMedicationsHistory"] = null;
                this.TextBoxStartDate.Attributes.Add("onblur", "SetDateFormat(this)");
                this.TextBoxEndDate.Attributes.Add("onblur", "SetDateFormat(this)");
                //this.DropDownListPrescriber.Attributes.Add("onblur", "FillPrescriber(this)");

                base.Activate();
                //Changed by Loveena to Change the date format to MM/dd/yyyy.
                //TextBoxStartDate.Text = DateTime.Now.AddYears(-1).ToShortDateString();
                TextBoxStartDate.Text = DateTime.Now.AddYears(-1).ToString("MM/dd/yyyy");

                //Code added by Loveena in ref to Task#3234 2.3 Show Client Demographics on All Client Pages 
                if (Session["DataSetClientSummary"] != null)
                {
                    DataSet _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    //Modified by Loveen ain ref to Task#3265
                    LabelClientName.Text = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();                    
                }
                
                GetClientMedicationHistory(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

                //Changed by Loveena to Change the date format to MM/dd/yyyy.
                //string currentDate = DateTime.Now.ToShortDateString();
                string currentDate = DateTime.Now.ToString("MM/dd/yyyy");

                //Added by Loveena in Ref to Task#128 on 15-Dec-2008 to fill the Prescriber when page is Loaded.
                FillPrescriber();

                //Added by Loveena in Ref to Task#128 on 15-Dec-2008 to fill the Medications when page is Loaded.
                FillMedication();

                //Added by Loveena in Ref to Task#2386 on 09-Feb-2009 to fill Dates DropDownList to filter the date.
                FillDateFilters();

                //Added by Loveena in ref to Task# on 11-April-2009 to fill DisContinuedReason DropDown for MM-1.9.
                FillDiscontinueReason();

                HiddenFieldMedication.Value = DropDownMedication.SelectedValue;
                HiddenFieldPrescriber.Value = DropDownListPrescriber.SelectedValue;
                HiddenFieldDateFilter.Value = DropDownListDateFilter.SelectedValue;
                HiddenFieldDiscontineReasonFilter.Value = DropDownListDiscontinuedReason.SelectedValue;
                // DisplayMedicationData("StartDate > ='" + currentDate + "' AND EndDate <='" + currentDate + "'");
                string sFilter = SetFilter();
                if (sFilter.Length > 0)
                    DisplayMedicationData(sFilter);
                else
                {
                    strErrorMessage = "End Date should be Greater than Start Date";
                    #region "error message color added by rohit ref. #121"
                    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                    Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
                    #endregion
                    ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
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
        /// Author Sony
        /// Purpose Enable/Disable buttons based on staff Permissions
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
        private void GetClientMedicationHistory(Int64 ClientId)
        {


            try
            {
                CommonFunctions.Event_Trap(this);
                _DataSetClientMedications = new DataSet();
                Session["DataSetClientMedicationsHistory"] = null;
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                if (ClientId > 0)
                {
                    _DataSetClientMedications = objectClientMedications.DownloadClientMedicationHistory(ClientId);
                    Session["DataSetClientMedicationsHistory"] = _DataSetClientMedications;
                    string currentDate = DateTime.Now.ToShortDateString();
                }

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
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
        /// Author: Sonia
        /// Purpose:Display Medication data into Medication List
        /// </summary>
        /// <param name="Filter"></param>
        private void DisplayMedicationData(string Filter)
        {
            DataSet _DataSetClientMedicationHistory;
            DataRow[] DataRowsClientMedications = null;
            DataRow[] DataRowsClientMedicationInstructions = null;
            string Medicationsfilter = "";


            try
            {
                _DataSetClientMedicationHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataSetClientMedicationHistory = new DataSet();

                Session["DataSetMedMgtHistory"] = null;
                string MedicationId = "";
                if (Session["DataSetClientMedicationsHistory"] != null)
                    _DataSetClientMedications = (DataSet)Session["DataSetClientMedicationsHistory"];

                DataTable dtTempMedicationInstructions = new DataTable();
                DataTable dtTempMedications = new DataTable();
                dtTempMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Clone();
                dtTempMedications = _DataSetClientMedications.Tables["ClientMedications"].Clone();

                if (Filter == "")
                {
                    //in case Filter is blank then select DataRows with a condition 1=0 to get no resulting rows
                    DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("1=0");
                    DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("1=0");

                }
                else
                {
                    //Modified by Loveena in Ref to Task#2386 on 09-Feb-2009 
                    //to filter the rows on basis of Rx Start Date and Rx End Date which are fields in ClientMedicationInstructions
                    //and OrderDate and OrderStatus Date in ClientMedications.
                    //if (HiddenFieldDateFilter.Value == "0" || HiddenFieldDateFilter.Value == "Order Date" || HiddenFieldDateFilter.Value == "Order Status Date")
                    if (HiddenFieldDateFilter.Value == "0" || HiddenFieldDateFilter.Value == "Order Date" || HiddenFieldDateFilter.Value == "Order Status Date" || HiddenFieldDateFilter.Value == "Order Status Date Non Order")
                    {
                        DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select(Filter);
                        if (DataRowsClientMedications.Length == 0)
                            DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("1=0");
                        foreach (DataRow dr in DataRowsClientMedications)
                        {
                            //if (MedicationId == "")
                            MedicationId += dr["ClientMedicationId"].ToString() + ",";

                        }

                        //if(DataRowsClientMedications.Length==0)
                        //    DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("1=0");
                        //foreach (DataRow dr in DataRowsClientMedications)
                        //{
                        //    //if (MedicationId == "")
                        //        MedicationId += dr["ClientMedicationId"].ToString() + ",";

                        // }

                        if (MedicationId.Length > 1)
                            MedicationId = MedicationId.TrimEnd(',');
                        if (MedicationId != "")
                        {
                            Medicationsfilter = "ClientMedicationId in (" + MedicationId.ToString() + ")";
                            DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select(Medicationsfilter);
                        }
                        else
                            DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("1=0");
                    }
                    else
                    {
                        //if (MedicationId.Length > 1)
                        //    MedicationId = MedicationId.TrimEnd(',');
                        //if (MedicationId != "")
                        //{
                        //    Medicationsfilter = "ClientMedicationId in (" + MedicationId.ToString() + ")"; 

                        DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select(Filter);
                        //}
                        //else
                        //    DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("1=0");
                        if (DataRowsClientMedicationInstructions.Length == 0)
                            DataRowsClientMedicationInstructions = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("1=0");
                        foreach (DataRow dr in DataRowsClientMedicationInstructions)
                        {
                            //if (MedicationId == "")
                            MedicationId += dr["ClientMedicationId"].ToString() + ",";

                        }
                        if (MedicationId.Length > 1)
                            MedicationId = MedicationId.TrimEnd(',');
                        if (MedicationId != "")
                        {
                            Medicationsfilter = "ClientMedicationId in (" + MedicationId.ToString() + ")";
                            //DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select(Medicationsfilter);
                            //Modified by anuj for task ref:2927 on 22March,2010
                            DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select(Medicationsfilter + " or " + "OrderDate is null");
                        }
                        //Added by anuj for task ref:2927 on 22March,2010
                        else if (HiddenFieldMedication.Value != "0" && HiddenFieldMedication.Value != "" && HiddenFieldMedication.Value != null)
                        {
                            string MedicationnameId = HiddenFieldMedication.Value;
                            DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("MedicationNameId=" + MedicationnameId + "AND OrderDate is null");
                        }
                        else
                        {
                            //DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("1=0");
                            //Modified by anuj for task ref:2927 on 22March,2010
                            DataRowsClientMedications = _DataSetClientMedications.Tables["ClientMedications"].Select("OrderDate is null");
                        }
                    }





                    #region Commneted Code
                    /* DataRow[] drTemp = _DataSetClientMedications.Tables["ClientMedicationInstructions"].Select(Filter);
                foreach (DataRow dr in drTemp)
                {

                    dtTempMedicationInstructions.Rows.Add(dr.ItemArray);
                }
                foreach (DataRow dr in dtTempMedicationInstructions.Rows)
                {
                    if (MedicationId == "")
                        MedicationId += dr["ClientMedicationId"].ToString();
                    else
                        MedicationId += "," + dr["ClientMedicationId"].ToString();


                }
                if (MedicationId != "")
                {
                    Filter = "ClientMedicationId in (" + MedicationId.ToString() + ")";

                    DataRow[] drTempMedications = _DataSetClientMedications.Tables["ClientMedications"].Select(Filter);
                    foreach (DataRow dr in drTempMedications)
                    {
                        // if (dr["Discontinued"] == DBNull.Value || dr["Discontinued"].ToString().ToUpper() == "N")
                        dtTempMedications.Rows.Add(dr.ItemArray);
                    }
                }*/

                }

                //_DataSetClientMedicationHistory.Tables[0].Merge(dtTempMedications);
                //_DataSetClientMedicationHistory.Tables[1].Merge(dtTempMedicationInstructions);
                    #endregion


                _DataSetClientMedicationHistory.Merge(DataRowsClientMedications);
                if (_DataSetClientMedicationHistory.Tables.Count > 0)
                    _DataSetClientMedicationHistory.Tables[0].TableName = "ClientMedications";
                //   if (DataRowsClientMedicationInstructions.Length > 0)
                _DataSetClientMedicationHistory.Merge(DataRowsClientMedicationInstructions);

                if (_DataSetClientMedicationHistory.Tables.Count > 1)
                    _DataSetClientMedicationHistory.Tables[1].TableName = "ClientMedicationInstructions";
                if (DataRowsClientMedications.Length == 0)
                {

                    _DataSetClientMedicationHistory.Merge(dtTempMedications);
                }
                if (DataRowsClientMedicationInstructions.Length == 0)
                {
                    _DataSetClientMedicationHistory.Merge(dtTempMedicationInstructions);
                }


                Session["DataSetMedMgtHistory"] = _DataSetClientMedicationHistory;
                dtTempMedications.DefaultView.Sort = "ClientMedicationId ASC";
                //Pass the Temp dataSet to the Medication List Control  
                MedicationList1.Activate("ViewMedicationHistory");
                // MedicationList1.GenerationMedicationTabControlRows(_DataSetClientMedications.Tables["ClientMedications"], _DataSetClientMedications.Tables["ClientMedicationInstructions"]);
                MedicationList1.ShowCheckBox = false;
                MedicationList1.ShowOrderedIcon = true;
                MedicationList1.ShowButton = false;
                MedicationList1.ShowMedicationLink = true;
                MedicationList1.showDateInitiatedLabel = true;
                //Changes as per Task #2381
                MedicationList1.ShowOrderStatus = true;
                MedicationList1.ShowOrderStatusDate = true;
                MedicationList1.showMinScriptDrugsEndDate = false;



                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder))
                {
                    MedicationList1.DeleteRowMessage = "Are you sure to Discontinue this Medication ?";
                    MedicationList1.ShowButton = true;
                }
                else
                {
                    MedicationList1.DeleteRowMessage = String.Empty;
                    MedicationList1.ShowButton = true;
                }
                //Modified by Loveena in ref to task#2387 on 10-Feb-2009 to display Non-Ordered Medications on top
                // with null Ordered Date.
                //MedicationList1.SortString = "Ordered desc";
                //Commented by Anuj for task ref:3062 on 24May,2010
                //MedicationList1.SortString = "Ordered asc,OrderDate desc";
                //Ended over here
                MedicationList1.SortString = "";
                MedicationList1.ShowButton = false;
                MedicationList1.showOffLabel = true;
                MedicationList1.showDisContinueReasonLabel = true;
                //Code added by Loveena in ref to Task#2779
                MedicationList1.ShowComments = true;
                //Code ends over here.
                MedicationList1.GenerationMedicationTabControlRows(_DataSetClientMedicationHistory.Tables["ClientMedications"], _DataSetClientMedicationHistory.Tables["ClientMedicationInstructions"], null, null, null);
                if (Filter != "")
                {
                    if (_DataSetClientMedicationHistory.Tables["ClientMedications"].Rows.Count == 0)
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
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                string strErrorMessage = "Error in loading page";
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);

            }
            finally
            {
                _DataSetClientMedicationHistory = null;
                DataRowsClientMedications = null;
                DataRowsClientMedicationInstructions = null;
            }
        }


        /// <summary>
        /// Handles the ButtonApplyFilter click event 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonApplyFilter_Click(object sender, EventArgs e)
        {
            try
            {
                //--Comented by Pradeep a
                //FillMedication();
                FillPrescriber();
                FillDateFilters();
                FillDiscontinueReason();
                DropDownListPrescriber.SelectedValue = HiddenFieldPrescriber.Value;
                DropDownMedication.SelectedValue = HiddenFieldMedication.Value;
                DropDownListDateFilter.SelectedValue = HiddenFieldDateFilter.Value;
                DropDownListDiscontinuedReason.SelectedValue = HiddenFieldDiscontineReasonFilter.Value;
                string sFilter = SetFilter();
                if (sFilter.Length > 0)
                    DisplayMedicationData(sFilter);
                else
                {
                    DisplayMedicationData(sFilter);
                    strErrorMessage = "End Date should be Greater than Start Date";
                    #region "error message color added by Loveena as ref to Task# 141 on 07-Jan-2009."
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
        /// Author:Sonia
        /// Purpose to set the Filter string for DataTable Rows filtering Based on TextBoxes Values
        /// </summary>
        /// <returns></returns>1
        private string SetFilter()
        {
            try
            {

                string StartDate = TextBoxStartDate.Text.ToString();
                string EndDate = TextBoxEndDate.Text.ToString();
                //Added by Loveena in Ref to Task#128 to apply filter on basis of Medication
                string Medication = HiddenFieldMedication.Value;
                //Added by Loveena in Ref to Task#128 to apply filter on the basis of Prescriber
                string Prescriber = HiddenFieldPrescriber.Value;
                //Added by Loveena in ref to Task# MM-1.9 to apply Filter on basis of ClientMedications.DiscontinuedReasonCode
                string DiscontinuedReason = HiddenFieldDiscontineReasonFilter.Value;

                string Dates = HiddenFieldDateFilter.Value;

                string Filter = "";

                DateTime DEndDate = new DateTime();
                DateTime DStartDate = Convert.ToDateTime(StartDate);
                Filter = "";
                if (DiscontinuedReason == "0")
                {
                    if (Dates != "0" && EndDate.ToString() != "" && EndDate != null)
                    {
                        if (Dates == "Rx Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                               // Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "')"; //case2
                                Filter = "((StartDate >='" + StartDate + "') OR (StartDate is null)) and (EndDate <='" + EndDate + "')";

                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;

                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication;

                            }

                            else
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;

                            }
                        }
                        else if (Dates == "Rx Start Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        else if (Dates == "Rx End Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        else if (Dates == "Order Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        else if (Dates == "Order Status Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        //Added by anuj on 8 March,2010 Tak ref:2927
                        else if (Dates == "Order Status Date Non Order")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        //ended over here
                        return Filter;
                    }
                    else if (Dates != "0" && (EndDate.ToString() == "" || EndDate == null))
                    {
                        if (Dates == "Rx Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(EndDate >='" + StartDate + "')";
                                //Filter = "(EndDate >='" + StartDate + "' OR (StartDate is null))";
                                //Filter = "(EndDate >='" + StartDate + "' OR (StartDate is null) OR (EndDate is null))";  //case1
                                Filter = "(StartDate >='" + StartDate + "' OR (StartDate is null) OR (EndDate is null))"; 
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                                return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " OR StartDate is null";
                            }

                            else
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                        }
                        else if (Dates == "Rx Start Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(StartDate >='" + StartDate + "')";
                                Filter = "(StartDate >='" + StartDate + "') OR StartDate is null";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(StartDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                return "(StartDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                                return "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " OR StartDate is null";
                            }

                            else
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                Filter = "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                        }
                        else if (Dates == "Rx End Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(EndDate >='" + StartDate + "')";
                                Filter = "(EndDate >='" + StartDate + "') OR StartDate is null";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                                return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " OR StartDate is null";
                            }

                            else
                            {
                                //Modified in ref to Task#3062 as instructions are not coming for Non-Ordered MEdications with no start date
                                //Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " OR StartDate is null";
                            }
                        }
                        else if (Dates == "Order Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "(OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        else if (Dates == "Order Status Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        //Added by Anuj on 8 March,2010 for task ref:2927
                        else if (Dates == "Order Status Date Non Order")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                            }
                        }
                        //Ended over here
                        return Filter;
                    }
                    if (Dates == "0")
                    {
                        if (EndDate.ToString() != "" && EndDate != null)
                        {
                            DEndDate = Convert.ToDateTime(EndDate);
                            if (DEndDate != null)
                            {
                                if (DEndDate >= DStartDate)
                                {
                                    if (EndDate == null || EndDate == "")
                                        //Changes as per Task 2377 SC-Support Data Model changes
                                        //Filter = "(StartDate > ='" + StartDate + "')";
                                        //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                        if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "')";
                                        }
                                        else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                        }
                                        else if (Medication != "" && Prescriber == "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication;
                                        }
                                        //Code Added by Loveena Ends Here.

                                        else
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                        }
                                    else
                                        //Filter = "(StartDate > ='" + StartDate + "') AND ((EndDate <='" + EndDate + "') OR  (EndDate is null))";
                                        //Changes as per Task 2377 SC-Support Data model changes
                                        //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                        if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND ((MedicationEndDate <='" + EndDate + "') OR  (MedicationEndDate is null))";
                                        }
                                        else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                        }
                                        else if (Medication != "" && Prescriber == "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication;
                                        }
                                        //Code Added by Loveena Ends Here.
                                        else
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND ((MedicationEndDate <='" + EndDate + "') OR  (MedicationEndDate is null)) AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                        }
                                    return Filter;
                                }
                                else
                                    return "";
                            }
                            else
                            {
                                //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "')";
                                }
                                else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber;
                                }
                                else if (Medication != "" && Prescriber == "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication;
                                }
                                //Code Added by Loveena Ends Here.
                                else
                                {
                                    //Changes as per Task 2377 SC-Support
                                    return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber;
                                    // return "(StartDate > ='" + StartDate + "')";
                                }
                            }
                        }
                        else
                        {
                            //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }
                            //Code Added by Loveena Ends Here.
                            else
                            {
                                //Changes as per Task 2377 SC-Support
                                //return "(StartDate > ='" + StartDate + "')";
                                return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + "AND PrescriberId=" + Prescriber;
                            }
                        }
                    }
                }
                //If DiscontinuedReason is selected.
                else
                {
                    if (Dates != "0" && EndDate.ToString() != "" && EndDate != null)
                    {
                        if (Dates == "Rx Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Rx Start Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication;
                            }

                            else
                            {
                                Filter = "((StartDate <='" + EndDate + "') OR (StartDate is null)) and (StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Rx End Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "((EndDate <='" + EndDate + "') OR (EndDate is null)) and (EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Order Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "((OrderDate <='" + EndDate + "') OR (OrderDate is null)) and (OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Order Status Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        //Added by Anuj on 8 March,2010 for task ref:2927
                        else if (Dates == "Order Status Date Non Order")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "((OrderStatusDate <='" + EndDate + "') OR (OrderStatusDate is null)) and (OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        //Ended over here
                        return Filter;
                    }
                    else if (Dates != "0" && (EndDate.ToString() == "" || EndDate == null))
                    {
                        if (Dates == "Rx Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(EndDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Rx Start Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(StartDate >='" + StartDate + "')";
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(StartDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(StartDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Rx End Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(EndDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(EndDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(EndDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Order Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(OrderDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        else if (Dates == "Order Status Date")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        //Added by Anuj on 8 March,2010 for task ref:2927
                        else if (Dates == "Order Status Date Non Order")
                        {
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }

                            else
                            {
                                Filter = "(OrderStatusDate >='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                        //ended over here
                        return Filter;
                    }
                    if (Dates == "0")
                    {
                        if (EndDate.ToString() != "" && EndDate != null)
                        {
                            DEndDate = Convert.ToDateTime(EndDate);
                            if (DEndDate != null)
                            {
                                if (DEndDate >= DStartDate)
                                {
                                    if (EndDate == null || EndDate == "")
                                        //Changes as per Task 2377 SC-Support Data Model changes
                                        //Filter = "(StartDate > ='" + StartDate + "')";
                                        //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                        if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "')AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        else if (Medication != "" && Prescriber == "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        //Code Added by Loveena Ends Here.

                                        else
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                    else
                                        //Filter = "(StartDate > ='" + StartDate + "') AND ((EndDate <='" + EndDate + "') OR  (EndDate is null))";
                                        //Changes as per Task 2377 SC-Support Data model changes
                                        //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                        if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND ((MedicationEndDate <='" + EndDate + "') OR  (MedicationEndDate is null)) AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        else if (Medication != "" && Prescriber == "0")
                                        {
                                            return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                        //Code Added by Loveena Ends Here.
                                        else
                                        {
                                            Filter = "(MedicationStartDate > ='" + StartDate + "') AND ((MedicationEndDate <='" + EndDate + "') OR  (MedicationEndDate is null)) AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                        }
                                    return Filter;
                                }
                                else
                                    return "";
                            }
                            else
                            {
                                //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                                if ((Medication == "0" || Medication == "") && Prescriber == "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                }
                                else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                }
                                else if (Medication != "" && Prescriber == "0")
                                {
                                    return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                }
                                //Code Added by Loveena Ends Here.
                                else
                                {
                                    //Changes as per Task 2377 SC-Support
                                    return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                                    // return "(StartDate > ='" + StartDate + "')";
                                }
                            }
                        }
                        else
                        {
                            //Code Added by Loveena in Ref to Task#128 on 17-Dec-2008 to set filters for MdicationNameId and PrescriberId
                            if ((Medication == "0" || Medication == "") && Prescriber == "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "') AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if ((Medication == "0" || Medication == "") && Prescriber != "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "') AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            else if (Medication != "" && Prescriber == "0")
                            {
                                return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                            //Code Added by Loveena Ends Here.
                            else
                            {
                                //Changes as per Task 2377 SC-Support
                                //return "(StartDate > ='" + StartDate + "')";
                                return "(MedicationStartDate > ='" + StartDate + "') AND MedicationNameId=" + Medication + "AND PrescriberId=" + Prescriber + " AND DiscontinuedReasonCode=" + DiscontinuedReason;
                            }
                        }
                    }
                }
                return "";
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        /// <summary>
        /// <Author>Loveena</Author>
        /// <Description>To fill Prescriber when page is loaded in Ref to Task#128</Description>
        /// <CreationDate>15-Dec-2008</CreationDate>
        /// </summary>
        public void FillPrescriber()
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            try
            {
                objectClientMedications = new ClientMedication();
                DataSet DataSetPrescribers = null;
                DataSetPrescribers = objectClientMedications.GetUniquePrescribers(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

                DropDownListPrescriber.DataSource = DataSetPrescribers.Tables[0];
                DropDownListPrescriber.DataTextField = DataSetPrescribers.Tables[0].Columns["Column1"].ToString();
                //Modified in ref to Task#3062
                //DropDownListPrescriber.DataValueField = DataSetPrescribers.Tables[0].Columns["PrescriberId"].ToString();
                DropDownListPrescriber.DataValueField = DataSetPrescribers.Tables[0].Columns["OrderingPrescriberId"].ToString();
                DropDownListPrescriber.DataBind();
                DropDownListPrescriber.Items.Insert(0, new ListItem("...Prescribers...", "0"));
                DropDownListPrescriber.SelectedIndex = 0;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }
        }

        /// <summary>
        /// <Author>Loveena</Author>
        /// <Description>To fill Medicaton when page is loaded in Ref to Task#128</Description>
        /// <CreationDate>15-Dec-2008</CreationDate>
        /// </summary>
        public void FillMedication()
        {
            try
            {
                _DataSetClientMedication = new DataSet();

                _DataSetClientMedicationHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataSetClientMedicationHistory = new DataSet();

                if (Session["DataSetClientMedicationsHistory"] != null)
                    _DataSetClientMedications = (DataSet)Session["DataSetClientMedicationsHistory"];

                _DataSetClientMedicationHistory = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                _DataTableClientMedications = new DataTable();
                DataRow[] _DataRowClientMedication = _DataSetClientMedications.Tables["ClientMedications"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

                _DataSetClientMedication.Merge(_DataRowClientMedication);

                //To Select distinct columns.
                if (_DataSetClientMedication.Tables["ClientMedications"] != null)
                {
                    _DataTableClientMedications = _DataSetClientMedication.Tables["ClientMedications"].DefaultView.ToTable(true, "MedicationName", "MedicationNameId");

                    if (_DataTableClientMedications != null && _DataTableClientMedications.Rows.Count > 0)
                    {

                        _DataViewClientsMeddication = new DataView();
                        _DataViewClientsMeddication.Table = _DataTableClientMedications;
                        _DataViewClientsMeddication.Sort = "MedicationName";


                        this.DropDownMedication.DataSource = this._DataViewClientsMeddication;
                        this.DropDownMedication.DataTextField = "MedicationName";


                        this.DropDownMedication.DataValueField = "MedicationNameId";
                        this.DropDownMedication.DataBind();


                    }

                }
                DropDownMedication.Items.Insert(0, new ListItem("...Medications...", "0"));
                DropDownMedication.SelectedIndex = 0;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        /// <summary>
        /// <Author>Loveena</Author>
        /// <Description>To Add the Drop-Down of Date Filtering</Description>
        /// Task#2386
        /// <CreatedDate>09-Feb-2009</CreatedDate>
        /// </summary>
        private void FillDateFilters()
        {
            try
            {
                DropDownListDateFilter.Items.Clear();
                //Code Commented in ref to Task#2443 
                //DropDownListDateFilter.Items.Insert(0, new ListItem("...Select Date...", "0"));
                //If "RX Date" is selected, history rows are filtered to select rows where ((RxStartDate <= FilterEndDate) or (FilterEndDate is null)) and (RxEndDate >= FilterStartDate).
                DropDownListDateFilter.Items.Insert(0, new ListItem("Rx Date", "Rx Date"));
                //Added by Anuj on 8 march for Task ref 2927
                //DropDownListDateFilter.Items.Insert(0, new ListItem("Rx Date", "Order Status Date Non Order"));
                //ended over here
                //If "RX Start Date" is selected, history rows are filtered to select rows where ((RxStartDate <= FilterEndDate) or (FilterEndDate is null)) and (RxStartDate >= FilterStartDate).
                DropDownListDateFilter.Items.Insert(1, new ListItem("Rx Start Date", "Rx Start Date"));
                //If "RX End Date" is selected, history rows are filtered to select rows where ((RxEndDate <= FilterEndDate) or (FilterEndDate is null)) and (RxEndDate >= FilterStartDate).
                DropDownListDateFilter.Items.Insert(2, new ListItem("Rx End Date", "Rx End Date"));
                //If "Order Date" is selected, history rows are filtered to select rows where ((OrderDate <= FilterEndDate) or (FilterEndDate is null)) and (OrderDate >= FilterStartDate).
                DropDownListDateFilter.Items.Insert(3, new ListItem("Order Date", "Order Date"));
                //If "Order Status Date" is selected, history rows are filtered to select rows where ((OrderStatusDate <= FilterEndDate) or (FilterEndDate is null)) and (OrderStatusDate >= FilterStartDate).
                DropDownListDateFilter.Items.Insert(4, new ListItem("Order Status Date", "Order Status Date"));
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        /// <summary>
        /// <Description>To fill DisContinuedReason DropDown for MM-1.9.</Description>
        /// <Author>Loveena</Author>
        /// <CreationDate>11-April-2009</CreationDate>
        /// </summary>
        private void FillDiscontinueReason()
        {
            DataSet DataSetDiscontinueReason = null;
            DataView DataViewDiscontinueReason;
            try
            {
                DataSetDiscontinueReason = new DataSet();
                DataSetDiscontinueReason = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowDiscontinueReason = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='MEDDISCONTINUEREASON' And ISNULL(RecordDeleted,'N')='N'");
                DataSetDiscontinueReason.Merge(DataRowDiscontinueReason);
                DataViewDiscontinueReason = DataSetDiscontinueReason.Tables[0].DefaultView;
                DataViewDiscontinueReason.Sort = "CodeName";
                DropDownListDiscontinuedReason.DataSource = DataViewDiscontinueReason;
                DropDownListDiscontinuedReason.DataTextField = "CodeName";
                DropDownListDiscontinuedReason.DataValueField = "GlobalCodeID";
                DropDownListDiscontinuedReason.DataBind();

                DropDownListDiscontinuedReason.Items.Insert(0, new ListItem("........Select Discontinue Reason........", "0"));
                DropDownListDiscontinuedReason.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                DataSetDiscontinueReason = null;
            }
        }

        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }

        /// <summary>
        /// Purpose:This function will be used to Get Client Medication Summary Data
        /// </summary>
        private void GetClientSummaryData()
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
            DataSet _DataSetClientSummary = null;
            try
            {
                objectClientMedications = new ClientMedication();
                //objectCommonFunctions = new ApplicationCommonFunctions();
                CommonFunctions.Event_Trap(this);
                string _ClientRowIdentifier = "";
                string _ClinicianrowIdentifier = "";

                DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                try
                {
                    _ClinicianrowIdentifier = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ClinicianRowIdentifier;
                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "";

                    string ParseMessage = ex.Message;
                    if (ParseMessage.Contains("Object") == true)
                    {
                        throw new Exception("Session Expired");
                    }
                }
                _ClientRowIdentifier = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientRowIdentifier;

                if (_ClientRowIdentifier != "" && _ClinicianrowIdentifier != "")
                {
                    _DataSetClientSummary = objectClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                    Session["DataSetClientMedications"] = null;
                    Session["DataSetPrescribedClientMedications"] = null;//Added As per task#3323 By Pradeep on 4 March 2011
                    Session["DataSetClientSummary"] = _DataSetClientSummary;

                    DataSetClientMedications.EnforceConstraints = false;
                    DataSetClientMedications.Tables["ClientMedications"].Merge(_DataSetClientSummary.Tables["ClientMedications"]);
                    DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = _DataSetClientSummary;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                objectClientMedications = null;             
            }



        }
    }

}
