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
namespace Streamline.SmartClient.UI
{
    public partial class UserControls_MedicationOrderDetails : BaseActivityPage
    {
        private Streamline.UserBusinessServices.DataSets.DataSetClientMedicationOrders _DataSetOrderDetails;
        private Int32 _clientMedicationId;
        private bool _isEditable;
        public string ShowHidePillImage { get; private set; }
        
        DataSet _DataSetClientSummary;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        Streamline.UserBusinessServices.ApplicationCommonFunctions objectCommonFunctions = null;
        DataSet _DataSetClientMedicationScriptHistory;


        protected override void Page_Load(object sender, EventArgs e)
        {

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
            #endregion

            //Added this function call in ref to Task#2971 to clear the session
            DocumentCloseDocument();

            //Added in ref to Task#2895
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";
                LinkButtonStartPage.Style["display"] = "block";
            }

            ButtonNewOrder.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
            //Code Adde by Pramod on 10 Apr 2008 as checkbox should be enable or disable according to permission
            //CheckBoxDiscontinued.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
            Session["OriginalDataUpdated"] = 1; //added by chandan. Accessed in MedicationPrintOrderDialog1.aspx.cs
            //Code added by Loveena in ref to Task#2486 If this window is opened 
            //from the Medication History page, close should take the user back to the history page
            //to refill the controls on clicking the medication whether continue/discontinue as corresponding to task#2494.
            CommonFunctions.Event_Trap(this);
            //Added by Chandan for task #2433 MM1.9
            FillDiscontinueDropDown();
            //End by Chandan 
            //Commented By Pramod on 10 Apr 2008 as checkbox should be enable of disable according to NewOrder Permission
            //CheckBoxDiscontinued.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AddMedication);
            //TextBoxDiscontinue.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
            //Added new parameter by Chandan for passing DiscontinueReasonCode ref task #2433
            CheckBoxDiscontinued.Attributes.Add("onclick", "return ValidateInputs('" + TextBoxDiscontinue.ClientID + "','" + HiddenFieldClientMedicationId.ClientID + "','" + CheckBoxDiscontinued.ClientID + "','" + DropDownDiscontinueReason.ClientID + "');return false");
            // CheckBoxPermitChanges.Attributes.Add("onclick","return ");
            _DataSetOrderDetails = new Streamline.UserBusinessServices.DataSets.DataSetClientMedicationOrders();
            _DataSetOrderDetails.Clear();
            BindControls();
            //Code added by Loveena ends over here.
            //Start Code Added By Pradeep as per task#31
            CheckBoxPermitChanges.Attributes.Add("onclick", "return SavePermitChangesByOtherUsers()");
            //End Code Added by pradeep as per task#31
            //--Start Code Added by Pradeep as per task#31
            //Modified by Loveena in ref to Task#31 as per David Comments
            //CheckBoxPermitChanges.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PermitChanges);
            //--End Code Added by radeep as per task#31
            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PermitChanges) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
            {
                CheckBoxPermitChanges.Attributes.Add("style", "display:block");
            }
            else
            {
                CheckBoxPermitChanges.Attributes.Add("style", "display:none");
            }
            //Code Added by : Malathi Shiva 
            //With Ref to task# : 33 - Community Network Services
            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) == false)
            {
                this.CheckBoxOffLabel.Attributes.Add("style", "display:none");
                this.Span_OffLabel.Attributes.Add("style", "display:none");
            }
        }
        #region ActivityPage Functions
        public override bool DocumentUpdateDocument()
        {
            return true;
        }

        public override bool DocumentCloseDocument()
        {
            _DataSetOrderDetails = null;
            _DataSetClientMedicationScriptHistory = null;
            objectClientMedications = null;
            _DataSetClientSummary = null;
            Session["DataViewClientMedicationScriptHistory"] = null;
            GridViewMedicationInstructions.Dispose();
            DataGridScriptHistory.Dispose();



            return true;
        }

        public override bool DocumentDeleteDocument()
        {
            return true;
        }

        public override bool DocumentNewDocument()
        {
            return true;
        }
        #endregion


        #region Activate
        public override void Activate()
        {

            try
            {
                //Code commented by Loveena in ref to Task#2486 If this window is opened 
                //from the Medication History page, close should take the user back to the history page
                //to refill the controls on clicking the medication whether continue/discontinue as corresponding to task#2494.

                //CommonFunctions.Event_Trap(this);
                //base.Activate();
                ////Added by Chandan for task #2433 MM1.9
                //FillDiscontinueDropDown();
                ////End by Chandan 
                ////Commented By Pramod on 10 Apr 2008 as checkbox should be enable of disable according to NewOrder Permission
                ////CheckBoxDiscontinued.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AddMedication);
                ////TextBoxDiscontinue.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
                ////Added new parameter by Chandan for passing DiscontinueReasonCode ref task #2433
                //CheckBoxDiscontinued.Attributes.Add("onclick", "return ValidateInputs('" + TextBoxDiscontinue.ClientID + "','" + HiddenFieldClientMedicationId.ClientID + "','" + CheckBoxDiscontinued.ClientID + "','" + DropDownDiscontinueReason.ClientID + "');return false");
                //_DataSetOrderDetails = new Streamline.UserBusinessServices.DataSets.DataSetClientMedicationOrders();
                //_DataSetOrderDetails.Clear();                
                //BindControls();

                //code commented by Loveena ends over here.                

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
                string strErrorMessage = "Error in loading Order Details";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            }



        }
        #endregion

        /// <summary>
        /// Author:Sonia 
        /// Purpose:Fill the DropDown of Clients
        /// </summary>
        public void FillClientsDropDown()
        {

            try
            {

                //DataTable DataTableClientsList = new DataTable();
                //DataTableClientsList.Clear();
                //DataTableClientsList = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Clients;
                //dataViewClients = new DataView();
                //dataViewClients.Table = DataTableClientsList;
                //dataViewClients.Sort = "Status,Name";


                //this.DropDownListClients.DataSource = this.dataViewClients;
                //this.DropDownListClients.DataTextField = "Name";


                //this.DropDownListClients.DataValueField = "ClientId";
                //this.DropDownListClients.DataBind();




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
        }


        #region Get/Fill Data
        /// <summary>
        /// Purpose:This function will be used to Get Client Medication Summary Data
        /// </summary>
        private void GetClientSummaryData()
        {


            try
            {
                objectClientMedications = new ClientMedication();
                objectCommonFunctions = new ApplicationCommonFunctions();
                CommonFunctions.Event_Trap(this);

                _DataSetClientSummary = new DataSet();

                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
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
                objectCommonFunctions = null;
            }



        }


        /// Author Sonia
        /// <summary>
        /// This function is used to Bind ScriptHistory Grid and Other Details of Medication Order
        /// </summary>

        private void BindControls()
        {
            DataView DataViewClientMedicationScriptHistory;
            ShowHidePillImage = "display:none";
            try
            {
                DataViewClientMedicationScriptHistory = null;
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User) != null)
                {
                    _clientMedicationId = Convert.ToInt32(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationId.ToString());
                    HiddenFieldClientMedicationId.Value = _clientMedicationId.ToString();
                    GetMedicationOrderDetails();
                    MedicationClientPersonalInformationControl.showEditableAllergyList = false;
                    MedicationClientPersonalInformationControl.Activate();

                    //Fill the Script History Information
                    objectClientMedications = new ClientMedication();
                    if (HiddenFieldScriptId.Value.ToString() != "")
                        _DataSetClientMedicationScriptHistory = objectClientMedications.DownloadClientMedicationScriptHistory(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, _clientMedicationId, Convert.ToInt32(HiddenFieldScriptId.Value.ToString()));
                    else
                        _DataSetClientMedicationScriptHistory = objectClientMedications.DownloadClientMedicationScriptHistory(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, _clientMedicationId, -1);
                    DataViewClientMedicationScriptHistory = _DataSetClientMedicationScriptHistory.Tables["ClientMedicationScripts"].DefaultView;
                    DataViewClientMedicationScriptHistory.Sort = "ClientMedicationScriptId desc";
                    Session["DataViewClientMedicationScriptHistory"] = DataViewClientMedicationScriptHistory;
                    if (DataViewClientMedicationScriptHistory.Table.Rows.Count > 0)
                    {
                        Session["PharmacyName"] = DataViewClientMedicationScriptHistory.Table.Rows[0]["PharmacyName"];
                        Session["OrderingMethod"] = DataViewClientMedicationScriptHistory.Table.Rows[0]["OrderingMethod"];
                        DataGridScriptHistory.DataSource = DataViewClientMedicationScriptHistory;
                        DataGridScriptHistory.DataBind();
                        HiddenFieldLatestClientMedicationScriptId.Value = DataViewClientMedicationScriptHistory.Table.Rows[0]["ClientMedicationScriptId"].ToString();
                        HiddenFieldPrescriptionStatus.Value = DataViewClientMedicationScriptHistory.Table.Rows[0]["Status"].ToString();

                    }
                    else
                        DataGridScriptHistory.DataBind();


                }
                else
                {
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);
                }


            }
            catch (Exception ex)
            {

                throw (ex);

            }
            finally
            {
                DataViewClientMedicationScriptHistory = null;
            }

        }

        /// Author Sonia
        /// <summary>
        /// This Function is used to get the Details of Medication i.e its Name,Instructions,Prescriber etc
        /// and then Bind the Controls to display the details at GUI
        /// </summary>
        private void GetMedicationOrderDetails()
        {
            try
            {
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();


                _DataSetOrderDetails.Clear();
                _DataSetOrderDetails.EnforceConstraints = false;
                //Changes made by sonia as during testing found that OrderDetails were not being fetched properly
                //In case ScriptId is set pass ScriptId.
                //Otherwise get the Order Details as per latest records in ClientMedicationScriptDrugs

                if (Convert.ToInt32(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationScriptId.ToString()) <= 0)
                {
                    _DataSetOrderDetails.Merge(objectClientMedications.GetMedicationOrderDetails(_clientMedicationId, -1));
                }
                else
                    _DataSetOrderDetails.Merge(objectClientMedications.GetMedicationOrderDetails(_clientMedicationId, Convert.ToInt32(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationScriptId.ToString())));

                if (_DataSetOrderDetails.Tables.Count > 0)
                {
                    if ((_DataSetOrderDetails.Tables.Contains("DrugCategory")) && (_DataSetOrderDetails.Tables["DrugCategory"].Rows.Count > 0))
                    {
                        string _strDrugCategory = _DataSetOrderDetails.Tables["DrugCategory"].Rows[0]["Category"].ToString();
                        if (_strDrugCategory == "0")
                            HiddenFieldScriptOrderingMethod.Value = "Faxed";
                        else
                            HiddenFieldScriptOrderingMethod.Value = "Printed";
                        Session["DrugCategory"] = _strDrugCategory;
                        Session["DataSetOrderDetails"] = _DataSetOrderDetails;
                    }

                    if (_DataSetOrderDetails.Tables.Contains("ClientMedications"))
                    {
                        if (_DataSetOrderDetails.Tables["ClientMedications"].Rows.Count > 0)
                        {
                            // customMedicationOrderDetails.MedicationNameId = Convert.ToInt32(_dataSetOrderDetails.Tables[0].Rows[0]["MedicationNameId"].ToString());
                            LabelPrescriber.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["PrescriberName"].ToString();
                            LabelDxPurpose.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DrugPurpose"].ToString();
                            TextBoxDiscontinue.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DiscontinuedReason"].ToString();
                            LabelEnteredBy.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["CreatedBy"].ToString();
                            //Changed by Loveena on 06-Dec-2009 to set Date Format as MM/dd/yyyy"
                            //LabelDateCreated.Text = Convert.ToDateTime(_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["CreatedDate"].ToString()).ToShortDateString();
                            LabelDateCreated.Text = Convert.ToDateTime(_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["CreatedDate"].ToString()).ToString("MM/dd/yyyy");
                            LabelMedicationName.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["MedicationName"].ToString();
                            if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["Discontinued"].ToString() == "Y")
                            {
                                CheckBoxDiscontinued.Checked = true;
                                CheckBoxDiscontinued.Enabled = false;
                                ButtonUpdate.Disabled = true;
                                TextBoxDiscontinue.ReadOnly = true;
                                //Code added by Loveena on 27-April-2009 in ref to Task#2486 to display Discontinue Reason Code
                                //if medication gets discontinued.
                                if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DiscontinuedReasonCode"].ToString() != string.Empty)
                                {
                                    DropDownDiscontinueReason.SelectedValue = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DiscontinuedReasonCode"].ToString();
                                }
                            }
                            else
                            {
                                CheckBoxDiscontinued.Checked = false;
                                ////Code Adde by Pramod on 10 Apr 2008 as checkbox should be enable or disable according to permission
                                //if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder))
                                //CheckBoxDiscontinued.Enabled = true;
                                //TextBoxDiscontinue.ReadOnly = false;

                            }
                            //Added by Loveena in ref to Task#2433 to display new fields offLabel,Comments,Desired Outcome
                            // on 11-April-2009 MM-1.9.
                            TextBoxComments.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["Comments"] == DBNull.Value ? "" : _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["Comments"].ToString();
                            TextBoxDesiredOutcome.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DesiredOutcomes"] == DBNull.Value ? "" : _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DesiredOutcomes"].ToString();
                            if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["OffLabel"].ToString() == "Y")
                            {
                                CheckBoxOffLabel.Checked = true;
                            }
                            else
                            {
                                CheckBoxOffLabel.Checked = false;
                            }
                            if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["DAW"].ToString() == "Y")
                            {
                                CheckBoxDAW.Checked = true;
                            }
                            else
                            {
                                CheckBoxDAW.Checked = false;
                            }
                            if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["VerbalOrderReadBack"].ToString() == "Y")
                            {
                                CheckBoxVORB.Checked = true;
                            }
                            else
                            {
                                CheckBoxVORB.Checked = false;
                            }
                            //Code Added by Loveena ends over here.
                            //Code added by Loveena in ref to Task#32
                            if (_DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["IncludeCommentOnPrescription"].ToString() == "Y")
                            {
                                CheckBoxIncudeOnProescription.Checked = true;
                            }
                            else
                            {
                                CheckBoxIncudeOnProescription.Checked = false;
                            }
                            //Code ends over here.
                        }
                        //---Start Code Added By Pradeep as per task#31
                        string permmitChanges = string.Empty;
                        permmitChanges = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["PermitChangesByOtherUsers"] == DBNull.Value ? "" : _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["PermitChangesByOtherUsers"].ToString();
                        if (permmitChanges.ToUpper() == "N")
                        {
                            this.CheckBoxPermitChanges.Attributes.Add("style", "display:none");
                        }
                        else
                        {
                            this.CheckBoxPermitChanges.Attributes.Add("style", "display:block");
                        }
                        //--End Code Added by Pradeep as per task#31
                        if (_DataSetOrderDetails.Tables.Contains("ClientMedicationInstructions"))
                        {
                            if (_DataSetOrderDetails.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                            {
                                GridViewMedicationInstructions.DataSource = _DataSetOrderDetails.Tables["ClientMedicationInstructions"].DefaultView;
                                //GridViewMedicationInstructions.DataBind();
                                //Ref Task #67 1.6.1 - Special Instructions Changes
                                //In case of Ordered Medications and Non ordered Medications having Instructions Special Instructions should be displayed from ClientMedicationInstructions as being returned by SP from ClientMedicationScriptDrugs Table 
                                //TextBoxSpecialInstructions.Text = _DataSetOrderDetails.Tables["ClientMedicationInstructions"].Rows[0]["SpecialInstructions"].ToString();
                                if (_DataSetOrderDetails.Tables["ClientMedicationInstructions"].Select("Stock > 0 or Sample > 0 ").Length > 0)
                                {
                                    ShowHidePillImage = "display:block";
                                }
                            }

                            GridViewMedicationInstructions.DataBind();
                            TextBoxSpecialInstructions.Text = _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["SpecialInstructions"].ToString();
                        }
                    }
                    //HiddenFieldScriptId added by Sonia as OrderDetails should be get both according to ClientMedicationId as well as ScriptId
                    //ScriptId should be set only in case there are more than one row in Instructions table
                    //As in Non ordered Medications Instructions can be blank.
                    if (_DataSetOrderDetails.Tables.Contains("ClientMedicationInstructions") && _DataSetOrderDetails.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                    {
                        HiddenFieldScriptId.Value = _DataSetOrderDetails.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationScriptId"].ToString();
                    }
                }

            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }






        #endregion
        /// Author Sonia
        /// <summary>
        /// This function is used to enable/Disable Buttons on basis of StaffPermissions
        /// </summary>
        /// <param name="per"></param>
        /// <returns></returns>
        public string enableDisabled(Permissions per)
        {

            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
                return "";
            else
                return "Disabled";
        }
        protected void GridViewMedicationInstructions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    Label LabelQtyUnitSchedule = (Label)e.Row.FindControl("LabelQtyUnitSchedule");
                    //Label LabelQty = (Label)e.Row.FindControl("LabelQty");
                    //Label LabelUnit = (Label)e.Row.FindControl("LabelUnit");
                    //Label LabelSchedule = (Label)e.Row.FindControl("LabelSchedule");
                    Label LabelStartDate = (Label)e.Row.FindControl("LabelStartDate");
                    Label LabelEndDate = (Label)e.Row.FindControl("LabelEndDate");

                    // LabelQtyUnitSchedule.Text=LabelQty.Text.ToString() + "/" + LabelUnit.Text.ToString() + "/" + LabelSchedule.Text.ToString();
                    //Changed by Loveena on 06-Dec-2009 to set Date Format as MM/dd/yyyy.
                    //LabelStartDate.Text = Convert.ToDateTime(LabelStartDate.Text.ToString()).ToShortDateString();
                    if (LabelStartDate != null && LabelStartDate.Text.ToString().Trim() != "")
                        LabelStartDate.Text = Convert.ToDateTime(LabelStartDate.Text.ToString()).ToString("MM/dd/yyyy");
                    //Changed by Loveena on 05-Dec-2009 to set Date Format as MM/dd/yyyy.
                    //LabelEndDate.Text = Convert.ToDateTime(LabelEndDate.Text.ToString()).ToShortDateString();
                    if (LabelEndDate != null && LabelEndDate.Text.ToString().Trim() != "")
                        LabelEndDate.Text = Convert.ToDateTime(LabelEndDate.Text.ToString()).ToString("MM/dd/yyyy");
                }

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            }
        }


        public override bool RefreshPage()
        {
            Activate();
            return true;
        }




        protected void GridScriptHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                //For Event Trap String
                CommonFunctions.Event_Trap(this);
                /////////
                if (e.Row.RowType == DataControlRowType.Header)
                {
                    ///This Patch is for Sort data on Grid Script History

                    Label LabelDeliveryMethod = new Label();
                    Label LabelScriptCreationDate = new Label();
                    Label LabelCreatedBy = new Label();
                    Label LabelPharmacyName = new Label();
                    //Code Added by Loveena in Ref to Task#83 to display Reprint Reason in Script History
                    Label LabelReason = new Label();
                    //Code Added by Loveena in Ref to Task#83 to display Location in Script History
                    Label LabelLocation = new Label();

                    LabelDeliveryMethod = (Label)e.Row.FindControl("LabelHeaderDeliveryMethod");
                    LabelScriptCreationDate = (Label)e.Row.FindControl("LabelHeaderScriptCreationDate");
                    LabelCreatedBy = (Label)e.Row.FindControl("LabelHeaderCreatedBy");
                    LabelPharmacyName = (Label)e.Row.FindControl("LabelHeaderPharmacyName");
                    //Code Added by Loveena in Ref to Task#83 to display Reprint Reason in Script History
                    LabelReason = (Label)e.Row.FindControl("LabelHeaderReason");
                    //Code Added by Loveena in Ref to Task#83 to display Location in Script History
                    LabelLocation = (Label)e.Row.FindControl("LabelHeaderLocation");

                    LabelDeliveryMethod.Attributes.Add("OnClick", "SortGridScriptHistory('DeliveryMethod');");
                    LabelScriptCreationDate.Attributes.Add("OnClick", "SortGridScriptHistory('ScriptCreationDate');");
                    LabelCreatedBy.Attributes.Add("OnClick", "SortGridScriptHistory('CreatedBy');");
                    //Code Added by Loveena in Ref to Task#83 to dsiplay Reprint Reason in Script History
                    LabelReason.Attributes.Add("OnClick", "SortGridScriptHistory('Reason');");
                    //Code Added by Loveena in Ref to Task#83 to dsiplay Location in Script History
                    LabelReason.Attributes.Add("OnClick", "SortGridScriptHistory('LocationName');");
                    LabelPharmacyName.Attributes.Add("OnClick", "SortGridScriptHistory('PharmacyName');");



                    //End Patch
                }


            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            }
        }
        /// <summary>
        /// Event Handler of Cancel Button 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonCancel_Click(object sender, EventArgs e)
        {

            try
            {
                DocumentCloseDocument();
                //Code added by Loveena in ref to Task#2486 on 27-April-2009
                //to move back to page from where it has been opened.
                if (((HiddenField)(Page.FindControl("HiddenPageName"))).Value == "PatientMainPage")
                {
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                }
                else if (((HiddenField)(Page.FindControl("HiddenPageName"))).Value == "ViewHistory")
                {
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToViewHistoryPageClearSession();", true);
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }



        }
        /// <summary>
        /// Author:Chandan
        /// Purpose:Fill the DropDown of DiscontinueReason
        /// </summary>
        public void FillDiscontinueDropDown()
        {
            try
            {
                DataRow[] DataRowDiscontinueReason = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='MEDDISCONTINUEREASON' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ");
                DataSet dsDiscontinueReason = new DataSet();
                DataView DataViewDiscontinueReason;
                dsDiscontinueReason.Merge(DataRowDiscontinueReason);
                dsDiscontinueReason.Tables[0].TableName = "DiscontinueReason";

                if (dsDiscontinueReason.Tables["DiscontinueReason"].Rows.Count > 0)
                {
                    DataViewDiscontinueReason = dsDiscontinueReason.Tables["DiscontinueReason"].DefaultView;
                    DataViewDiscontinueReason.Sort = "CodeName";

                    DropDownDiscontinueReason.DataSource = DataViewDiscontinueReason;
                    DropDownDiscontinueReason.DataTextField = "CodeName";
                    DropDownDiscontinueReason.DataValueField = "GlobalCodeId";
                    DropDownDiscontinueReason.DataBind();

                    DropDownDiscontinueReason.Items.Insert(0, new ListItem("......Select Discontinue Reason......", "0"));
                    DropDownDiscontinueReason.SelectedIndex = 0;
                }

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
        }
        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
    }
}
