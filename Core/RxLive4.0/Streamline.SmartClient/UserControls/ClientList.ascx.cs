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
using System.Text.RegularExpressions;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Text;
using System.Collections.Generic;
using System.Linq;
//using System.Web.UI.MobileControls;
using Image = System.Web.UI.WebControls.Image;
using Label = System.Web.UI.WebControls.Label;

public partial class UserControls_ClientList : BaseActivityPage
{
    private System.Data.DataView dataViewClients;
    private string _externalInterface = "false";
    DataSet dsTemp = null;
    private string _sortString = "";
    public string codeName = "";
    //Ref to Task#2595
    Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;
    Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = null;
    public string verbalOrderType = "";
    //Added by Loveena in ref to Task#2954
    DataSet DataSetAssociatedLocations = null;
    //Code added by Loveena in ref to Task#85
    Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = null;
    //Streamline.UserBusinessServices.DataSets.DataSetSureScripts dsSureScriptRefill = null;
    Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
    DataView dataViewProxyPrescriber = null;
    int prescriberId = 0;
    protected override void Page_Load(object sender, EventArgs e)
    {
        int PrescriptionCount = 0;
        //Added By Priya Ref: task No:2859
        DataSet datasetVerbalOrderCount = null;
        //End

        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
        objUserPreferences = new UserPrefernces();

        try
        {
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";

            }
            //Ref to Task#2652
            this.TextBoxAnswer1.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {$('[id$=ButtonSubmit]')[0].click();return false;}} else {return true}; ");
            //Added By Pushpita to Ref: task 85
            this.DropDownListRefillPrescriber.Attributes.Add("onchange", "javascript:BindGridRefillRequest('" + this.DropDownListRefillPrescriber.ClientID + "');");
            DropDownListOutBoundPrescriber.Attributes.Add("onchange", "javascript:SortOutBoundPrescriptionListPage();");
            //  Ref To #1566
            Streamline.DataService.SharedTables objSharedTables1 = new Streamline.DataService.SharedTables();
            DataSet datasetStaffPermissions = null;
            datasetStaffPermissions = objSharedTables1.GetPermissionforStaffToSeachClient((((StreamlineIdentity)Context.User.Identity)).UserId);
            DataTable dt = datasetStaffPermissions.Tables["StaffPermissionExceptions"];

            var dValue = from row in dt.AsEnumerable()
                         where row.Field<int>("PermissionTemplateType") == 5904
                               && row.Field<int>("PermissionItemId") == 8732
                         select row.Field<int>("StaffId");
            if (dValue.Count() != 0)
                HiddenFieldIsStaffHasPermissionforClientsDropDown.Value = "true";
            else
                HiddenFieldIsStaffHasPermissionforClientsDropDown.Value = "false";

            if (!Page.IsPostBack)
            {
                //Added in ref to Task#85
                Session["ProxyPrescriber"] = null;
                LabelMainError.Style.Add("display", "none");
                //Added by Loveena in ref to Task#2954
                Session["AssociatedLocation"] = null;

             

                //Ref to Task#2700
                //Changes by Sonia
                //Conditions Chnaged with ref to Tom's Comments
                if ((((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y" || ((((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder))))) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y") && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).QuestionsAnswered != 0))
                {
                    //TableResources.Visible = false;
                    //TableLabelResources.Visible = false;
                    //Added in ref to Task#85
                    TableDashboard.Visible = false;
                    TableSecurityQuestion.Style.Add("display", "none");
                    LabelTitleBar.Text = "Start Page";
                    StartPage.Style.Add("display", "block");
                    DivErrorMessage.Style.Add("display", "none");
                    ImageError.Style.Add("display", "none");
                    ImageError.Style.Add("display", "none");
                    LabelErrorMessage.Style.Add("display", "none");
                    LabelErrorMessage.Text = "";
                    //Added by Loveena in ref to Task#85
                    TableDashboard.Visible = false;
                    //TrUserManagement.Visible = false;
                    //TrPharmacyManagement.Visible = false;
                    //TrPatientSearch.Visible = false;
                    //TrMyPreferences.Visible = true;
                    ButtonManageUsers.Visible = false;
                    ButtonManagePharmacies.Visible = false;
                    ButtonPatientSearch.Visible = false;
                    ButtonMyPreferences.Visible = true;
                    //StartPage.Style.Add("margin-top", "14%");
                    //StartPage.Style.Add("margin-bottom", "23%");
                    //TrReviewPrescriptions.Visible = false;
                    ButtonReviewPrescriptions.Visible = false;

                    LabelMainError.Style.Add("display", "block");
                    //LabelMainError.Text = "Prescribers must configure security questions to enable prescribing system access.";
                    //Modified Message ref:Task No:3026
                    LabelMainError.Text = "Access is limited because your security questions/answers are not setup.  Please configure them in the \"My Preferences\" page.";

                }
                //else if ((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y" || (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder)))) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y" && ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count > 1)
                //Anuj Task : 2954
                else if ((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y" || (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder)))) && (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y" || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count > 1))
                {
                    FillLocations();
                    if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y")
                    {
                        //TableResources.Visible = false;
                        TableDashboard.Visible = false;
                        //TableLabelResources.Visible = false;
                        TableSecurityQuestion.Style.Add("display", "block");
                        StartPage.Style.Add("display", "none");
                        LabelTitleBar.Text = "Security Questions";
                        dsTemp = new DataSet();

                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), "fdkjgh", "GetFocus();", true);
                        dsTemp = objUserPreferences.GetSecurityQuestions(Convert.ToInt32((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId)));
                        Session["DataSetSecurityQustion"] = dsTemp;
                        Random random = new Random();
                        int num = random.Next(0, dsTemp.Tables[0].Rows.Count);
                        if (dsTemp.Tables[0].Rows.Count > 0)
                        {
                            Question1.InnerText = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["CodeName"].ToString();
                            Session["Answer"] = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["SecurityAnswer"].ToString();
                        }
                        //Page.Form.DefaultFocus = TextBoxAnswer1.ClientID;
                        ScriptManager scriptManager = Parent.FindControl("ScriptManager1") as ScriptManager;
                        if (scriptManager != null)
                        {
                            scriptManager.SetFocus(TextBoxAnswer1.ClientID);
                        }
                    }
                    //Added by Loveena in ref to Task#2954 when the EnablePrescriberSecurityQuestion = 'N', the page should still be displayed if the user has more than one assigned location.
                    else if ((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "N"))
                    {
                        //TableResources.Visible = false;
                        TableDashboard.Visible = false;
                        //TableLabelResources.Visible = false;
                        TableSecurityQuestion.Style.Add("display", "block");
                        StartPage.Style.Add("display", "none");
                        LabelTitleBar.Text = "Current Location";
                        TrQuestion.Style["display"] = "none";
                        TrAnswer.Style["display"] = "none";
                        TrErrorMessage.Style["display"] = "none";
                    }

                }
                //Added by Anuj fro task ref 2954 on 19March,2010
                else if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count == 1)
                {
                    Session["AssociatedLocation"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows[0]["LocationId"];
                }
                //Ended over here

                else
                {
                    //TableResources.Visible = true;
                    //Added in ref to task#85
                    TableDashboard.Visible = true;
                    //TableLabelResources.Visible = true;
                    LabelTitleBar.Text = "Start Page";
                    TableSecurityQuestion.Style.Add("display", "none");
                    StartPage.Style.Add("display", "block");
                    DivErrorMessage.Style.Add("display", "none");
                    ImageError.Style.Add("display", "none");
                    ImageError.Style.Add("display", "none");
                    LabelErrorMessage.Style.Add("display", "none");
                    LabelErrorMessage.Text = "";
                    if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                    {
                        //TrUserManagement.Visible = true;
                        //TrPharmacyManagement.Visible = true;
                        ////Added By Priya Ref: Task no: 2897
                        //TrRefreshSharedTables.Visible = true;
                        ButtonManageUsers.Visible = true;
                        ButtonManagePharmacies.Visible = true;
                        //Added By Priya Ref: Task no: 2897
                        ButtonRefreshSharedTables.Visible = true;
                        //added By Priya Ref:Task No:2986
                        ButtonPrinter.Visible = true;

                    }
                    else
                    {
                        //TrUserManagement.Visible = false;
                        //TrPharmacyManagement.Visible = false;
                        ////Added By Priya Ref: Task no: 2897
                        //TrRefreshSharedTables.Visible = false;
                        ButtonManageUsers.Visible = false;
                        ButtonManagePharmacies.Visible = false;
                        //Added By Priya Ref: Task no: 2897
                        ButtonRefreshSharedTables.Visible = false;
                        //added By Priya Ref:Task No:2986
                        ButtonPrinter.Visible = false;
                        //StartPage.Style.Add("margin-top", "14%");
                        //StartPage.Style.Add("margin-bottom", "19%");
                    }
                    ////Added in ref to Task#85.
                    //GetProxyPrescriber();
                    //Session["DataSetSureScriptRequestRefill"] = null;
                    //Session["DataSetSureScriptOutboundPrescription"] = null;
                }

                //Condtion added by Loveena in ref to Task#2954
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                {
                    if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count == 1)
                    {
                        Session["AssociatedLocation"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows[0]["LocationId"];
                    }
                    else if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count < 0)
                    //Added By Anuj from task ref 2954 on 18March,2010
                    //else if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count == 0)
                    {
                        Session["AssociatedLocation"] = null;
                    }
                }
            }
            //Added by Chandan for task #2604
            //Modfied in ref to Task#2700
            //if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrescriptionReview == "Y" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrescriptionReview == "Y" && (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y" || (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder))) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).QuestionsAnswered != 0))
            {
                //Ref to Task#2595
                //Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                PrescriptionCount = objMedicationLogin.GetPrescriptionsReviewStatus(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime);

                if (PrescriptionCount > 0)
                {
                    //TrReviewPrescriptions.Visible = true;
                    ButtonReviewPrescriptions.Visible = true;
                    ButtonReviewPrescriptions.Text = "Pending Review (" + PrescriptionCount + ")";
                }
                else
                    //TrReviewPrescriptions.Visible = false;
                    ButtonReviewPrescriptions.Visible = false;
            }


            else
                //TrReviewPrescriptions.Visible = false;
                ButtonReviewPrescriptions.Visible = false;


            //Added By Priya Ref:task No:2859 for Verbal Order Button
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
            {
                datasetVerbalOrderCount = new DataSet();
                datasetVerbalOrderCount = objMedicationLogin.GetVerbalOrderStatus(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                if (datasetVerbalOrderCount.Tables["VerbalOrder"].Rows.Count > 0)
                {
                    if (datasetVerbalOrderCount.Tables["VerbalOrder"].Rows[0]["VerbalOrdersRequireApproval"].ToString() == "Y")
                    {
                        DataRow[] drVerbalCount = datasetVerbalOrderCount.Tables["VerbalOrder"].Select("OrderType='V'");
                        if (drVerbalCount.Length > 0)
                        {
                            if (Convert.ToInt32(drVerbalCount[0]["Count"].ToString()) > 0)
                            {
                                //TrVerbalOrders.Visible = true;
                                ButtonVerbalOrders.Visible = true;
                                ButtonVerbalOrders.Text = "Verbal Orders (" + drVerbalCount[0]["Count"].ToString() + ")";
                            }
                            else
                                //TrVerbalOrders.Visible = false;
                                ButtonVerbalOrders.Visible = false;
                        }
                    }
                    else
                    {
                        ButtonVerbalOrders.Visible = false;
                    }
                    DataRow[] drQueuedCount = datasetVerbalOrderCount.Tables["VerbalOrder"].Select("OrderType='A'");
                    if (drQueuedCount.Length > 0)
                    {
                        if (Convert.ToInt32(drQueuedCount[0]["Count"].ToString()) > 0)
                        {
                            //TrQueuedOrders.Visible = true;
                            ButtonQueuedOrders.Visible = true;
                            ButtonQueuedOrders.Text = "Queued Orders (" + drQueuedCount[0]["Count"].ToString() + ")";
                        }
                        else
                            //TrQueuedOrders.Visible = false;
                            ButtonQueuedOrders.Visible = false;
                    }

                }
                else
                {
                    //TrQueuedOrders.Visible = false;
                    //TrVerbalOrders.Visible = false;
                    ButtonQueuedOrders.Visible = false;
                    ButtonVerbalOrders.Visible = false;
                }
            }
            else
            {
                //TrQueuedOrders.Visible = false;
                //TrVerbalOrders.Visible = false;
                //TrUserManagement.Visible = false;
                //TrPharmacyManagement.Visible = false;
                ButtonQueuedOrders.Visible = false;
                ButtonVerbalOrders.Visible = false;
                ButtonManageUsers.Visible = false;
                ButtonManagePharmacies.Visible = false;
            }

            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
            {
                //TrUserManagement.Visible = true;
                //TrPharmacyManagement.Visible = true;
                //TrRefreshSharedTables.Visible = true;
                ButtonManageUsers.Visible = true;
                ButtonManagePharmacies.Visible = true;
                ButtonRefreshSharedTables.Visible = true;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = true;
            }
            else
            {
                //TrUserManagement.Visible = false;
                //TrPharmacyManagement.Visible = false;
                //TrRefreshSharedTables.Visible = false;
                ButtonManageUsers.Visible = false;
                ButtonManagePharmacies.Visible = false;
                ButtonRefreshSharedTables.Visible = false;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = false;
                //StartPage.Style.Add("margin-top", "14%");
                //StartPage.Style.Add("margin-bottom", "19%");
            }

            //End Code
            //Added in ref to Task#85.
            GetProxyPrescriber();
            Session["DataSetSureScriptRequestRefill"] = null;
            Session["DataSetSureScriptOutboundPrescription"] = null;
            GridBind();
            //Page.Form.DefaultFocus = TextBoxAnswer1.ClientID;
            //Added in ref to Task#85
            ////Added in ref to Task#85.
            //GetProxyPrescriber();
            //Session["DataSetSureScriptRequestRefill"] = null;
            GetSureScriptRefill();
            GetSureScriptChange(); //Added by Pranay
            GetSureScriptFill();
            GetSureScriptOutboundPrescription();
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

    public override void Activate()
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            base.Activate();
            //Ref to Task#2895
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                LinkButtonLogout.Style["display"] = "block";
            //fillComboBoxes();
            //Ref to Task#2700            
            LabelMainError.Style.Add("display", "none");
            //Code added by Loveena in ref to Task#2595
            //TableResources.Visible = true;
            //TableLabelResources.Visible = true;
            LabelTitleBar.Text = "Start Page";
            TableSecurityQuestion.Style.Add("display", "none");
            StartPage.Style.Add("display", "block");
            DivErrorMessage.Style.Add("display", "none");
            ImageError.Style.Add("display", "none");
            ImageError.Style.Add("display", "none");
            LabelErrorMessage.Style.Add("display", "none");
            LabelErrorMessage.Text = "";
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
            {
                //TrUserManagement.Visible = true;
                //TrPharmacyManagement.Visible = true;
                ////Added By Priya Ref: Task no: 2897
                //TrRefreshSharedTables.Visible = true;
                ButtonManageUsers.Visible = true;
                ButtonManagePharmacies.Visible = true;
                //Added By Priya Ref: Task no: 2897
                ButtonRefreshSharedTables.Visible = true;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = true;
            }
            else
            {
                //TrUserManagement.Visible = false;
                //TrPharmacyManagement.Visible = false;
                ////Added By Priya Ref: Task no: 2897
                //TrRefreshSharedTables.Visible = false;
                ButtonManageUsers.Visible = false;
                ButtonManagePharmacies.Visible = false;
                //Added By Priya Ref: Task no: 2897
                ButtonRefreshSharedTables.Visible = false;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = false;
                //StartPage.Style.Add("margin-top", "14%");
                //StartPage.Style.Add("margin-bottom", "19%");
            }
            //Code ends over here.
            //Ref to Task#2700
            if ((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y" || (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder)))) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).QuestionsAnswered != 0)
            {
                //(  ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) && ( ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder)  || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder) ) )


                //TableResources.Visible = false;
                //Added in ref to task#85
                TableDashboard.Visible = false;
                //TableLabelResources.Visible = false;
                TableSecurityQuestion.Style.Add("display", "none");
                LabelTitleBar.Text = "Start Page";
                StartPage.Style.Add("display", "block");
                DivErrorMessage.Style.Add("display", "none");
                ImageError.Style.Add("display", "none");
                ImageError.Style.Add("display", "none");
                LabelErrorMessage.Style.Add("display", "none");
                LabelErrorMessage.Text = "";
                //TrUserManagement.Visible = false;
                //TrPharmacyManagement.Visible = false;
                //TrPatientSearch.Visible = false;
                //TrMyPreferences.Visible = true;
                ButtonManageUsers.Visible = false;
                ButtonManagePharmacies.Visible = false;
                ButtonPatientSearch.Visible = false;
                ButtonMyPreferences.Visible = true;
                //StartPage.Style.Add("margin-top", "14%");
                //StartPage.Style.Add("margin-bottom", "23%");

                //TrReviewPrescriptions.Visible = false;
                ButtonReviewPrescriptions.Visible = false;
                LabelMainError.Style.Add("display", "block");
                //LabelMainError.Text = "Prescribers must configure security questions to enable prescribing system access.";
                //Modified Message ref:Task No:3026
                LabelMainError.Text = "Access is limited because your security questions/answers are not setup.  Please configure them in the \"My Preferences\" page.";

            }
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
            {
                //TrUserManagement.Visible = true;
                //TrPharmacyManagement.Visible = true;
                //TrRefreshSharedTables.Visible = true;
                ButtonManageUsers.Visible = true;
                ButtonManagePharmacies.Visible = true;
                ButtonRefreshSharedTables.Visible = true;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = true;
            }
            else
            {
                //TrUserManagement.Visible = false;
                //TrPharmacyManagement.Visible = false;
                //TrRefreshSharedTables.Visible = false;
                ButtonManageUsers.Visible = false;
                ButtonManagePharmacies.Visible = false;
                ButtonRefreshSharedTables.Visible = false;
                //added By Priya Ref:Task No:2986
                ButtonPrinter.Visible = false;
                //StartPage.Style.Add("margin-top", "14%");
                //StartPage.Style.Add("margin-bottom", "19%");
            }
            _externalInterface = System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"];
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

        }
    }
    #region CommentedCode
    ///// <summary>
    ///// Handles the selected Index Change of DropDwon Clients
    ///// </summary>
    ///// <param name="sender"></param>
    ///// <param name="e"></param>
    //protected void DropDownClientList_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    string ClientId = "";
    //    string ExternalClientId = "";
    //    string UserCode = "";
    //    DataTable DataTableClientsList = new DataTable();
    //    DataTableClientsList.Clear();
    //    DataSet dsExternalClientInfo = new DataSet();
    //    try
    //    {
    //        Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
    //        objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
    //        Session["ExternalClientInformation"] = null;
    //        if (DropDownClientList.SelectedIndex > 0 && DropDownClientList.SelectedIndex == 1)
    //        {
    //            Session["LoadMgt"] = null;
    //            // fillComboBoxes();
    //            DropDownClientList.SelectedIndex = -1;
    //            //Commented By Mohit Madaan on 11 April 2009, because now Client Search page opens from Search Button.
    //            //ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowClientSearch(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + ");", true);
    //        }

    //        else if (DropDownClientList.SelectedIndex > 0 && DropDownClientList.Text != "Open this Patient")
    //        {
    //            //Added by chandan for update/Insert the External Client information in streamline database
    //            if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
    //            {
    //                ClientId = DropDownClientList.SelectedValue;
    //                UserCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
    //                DataTableClientsList = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Clients;
    //                if (DataTableClientsList.Rows.Count > 0)
    //                {
    //                    DataRow[] dr = DataTableClientsList.Select("clientid=" + ClientId + "");
    //                    ExternalClientId = dr[0]["ExternalClientId"].ToString();
    //                }

    //                if (ExternalClientId != "")
    //                {
    //                    //We are passing Externalclientid as clientid  to the external interface
    //                    dsExternalClientInfo = objApplicationCommonFunctions.GetExternalClientInfo(ExternalClientId);
    //                    //dsExternalClientInfo = objApplicationCommonFunctions.GetExternalClientInfo(Convert.ToInt32(ExternalClientId));   
    //                    Session["ExternalClientInformation"] = dsExternalClientInfo;
    //                    if (dsExternalClientInfo != null)
    //                    {
    //                        if (dsExternalClientInfo.Tables.Count > 0)
    //                            objApplicationCommonFunctions.UpdateExternalInformation(dsExternalClientInfo, UserCode);
    //                    }
    //                }
    //            }
    //            Response.Redirect("ValidateToken.aspx?ClientId=" + DropDownClientList.SelectedValue + " &StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);

    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        //if (ex.Data["CustomExceptionInformation"] == null)
    //        //    ex.Data["CustomExceptionInformation"] = "";
    //        //else
    //        //    ex.Data["CustomExceptionInformation"] = "";
    //        //if (ex.Data["DatasetInfo"] == null)
    //        //    ex.Data["DatasetInfo"] = null;
    //        //Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
    //    }
    //    finally
    //    {
    //        DataTableClientsList = null;
    //        dsExternalClientInfo = null;
    //    }
    //}


    ///// <summary>
    ///// Author:Sonia 
    ///// Purpose:Fill the DropDown of Clients
    ///// </summary>
    //public void fillComboBoxes()
    //{

    //    try
    //    {

    //        DataTable DataTableClientsList = new DataTable();
    //        DataTableClientsList.Clear();
    //        DataTableClientsList = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Clients;
    //        dataViewClients = new DataView();
    //        dataViewClients.Table = DataTableClientsList;
    //        dataViewClients.Sort = "Status,Name";


    //        this.DropDownClientList.DataSource = this.dataViewClients;
    //        this.DropDownClientList.DataTextField = "Name";


    //        this.DropDownClientList.DataValueField = "ClientId";
    //        this.DropDownClientList.DataBind();

    //        DropDownClientList.Items.Insert(0, new ListItem("View different Patients...", "0"));
    //        DropDownClientList.Items.Insert(1, new ListItem("     <Search Patients>    ", "1"));

    //        DropDownClientList.SelectedIndex = 0;

    //    }
    //    catch (Exception ex)
    //    {
    //        if (ex.Data["CustomExceptionInformation"] == null)
    //            ex.Data["CustomExceptionInformation"] = "";
    //        else
    //            ex.Data["CustomExceptionInformation"] = "";


    //        if (ex.Data["DatasetInfo"] == null)
    //            ex.Data["DatasetInfo"] = null;
    //        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

    //    }
    //}
    #endregion
    protected void ButtonMyPreferences_Click(object sender, EventArgs e)
    {
        try
        {
            //            Session["RedirectFromUserManagement"] = string.Empty;
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

    protected void ButtonPatientSearch_Click(object sender, EventArgs e)
    {
        //Code Commented by Mohit Madaan on April 11 2009, Beause on ButtonPatientSearch Click Now search page opens in PopUp
        //Response.Redirect("~/ClientSearch.aspx?ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowClientSearch(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + ");", true);
    }

    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        try
        {
            //Abondon Session Ref ticket
            Session.Abandon();
            //Changes end here
            Response.Redirect("MedicationLogin.aspx");
        }
        catch (Exception ex)
        {

            throw;
        }
    }

    protected void ButtonSubmit_Click(object sender, EventArgs e)
    {
        int PrescriptionCount = 0;
        //Added By Priya Ref: task No:2859
        // int VerbalOrderCount = 0;
        //End

        try
        {
            //Code added in ref to Task#2654
            DivErrorMessage.Style.Add("display", "none");
            ImageError.Style.Add("display", "none");
            ImageError.Style.Add("display", "none");
            LabelErrorMessage.Style.Add("display", "none");
            #region if Security question is Asked on basis on EnablePrescriberSecurityQuestion = Y
            if (TrQuestion.Style["display"] != "none")
            {
                if (TextBoxAnswer1.Text == "")
                {
                    DivErrorMessage.Style.Add("display", "block");
                    ImageError.Style.Add("display", "block");
                    ImageError.Style.Add("display", "block");
                    LabelErrorMessage.Style.Add("display", "block");
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), "fdkjgh", "GetFocus();", true);
                    LabelErrorMessage.Text = "Please enter the Answer of following Security Question.";
                    return;
                }
                if (DropDownListLocations.SelectedIndex <= 0)
                {//Comented By Anuj for task ref:2954 on 18March,2010
                    //DivErrorMessage.Style.Add("display", "block");
                    //ImageError.Style.Add("display", "block");
                    //ImageError.Style.Add("display", "block");
                    //LabelErrorMessage.Style.Add("display", "block");
                    //ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), "fdkjgh", "GetFocus();", true);
                    //LabelErrorMessage.Text = "Please select the current location.";
                    //return;
                }
                if (HiddenFieldFirstChance.Value == "")
                    HiddenFieldFirstChance.Value = "0";

                if (Session["Answer"].ToString().Trim().ToLower() == TextBoxAnswer1.Text.Trim().ToLower())
                {
                    //Code added in ref to Task#2954
                    if (DropDownListLocations.SelectedIndex > 0)
                    {
                        Session["AssociatedLocation"] = DropDownListLocations.SelectedValue;
                    }
                    else
                    {
                        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count == 1)
                        {
                            Session["AssociatedLocation"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows[0]["LocationId"];
                        }
                        else
                        {
                            Session["AssociatedLocation"] = null;
                        }
                    }
                    //TableResources.Visible = true;
                    //TableLabelResources.Visible = true;
                    LabelTitleBar.Text = "Start Page";
                    TableSecurityQuestion.Style.Add("display", "none");
                    StartPage.Style.Add("display", "block");
                    TableDashboard.Visible = true;
                    if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                    {
                        //TrUserManagement.Visible = true;
                        ButtonManageUsers.Visible = true;
                        //TrPharmacyManagement.Visible = true;
                        ButtonManagePharmacies.Visible = true;
                        //Added By Priya Ref: Task no: 2897
                        //TrRefreshSharedTables.Visible = true;
                        ButtonRefreshSharedTables.Visible = true;
                        //added By Priya Ref:Task No:2986
                        //TrPrinterDevice.Visible = true;
                        ButtonPrinter.Visible = true;
                    }
                    else
                    {
                        //TrUserManagement.Visible = false;
                        //TrPharmacyManagement.Visible = false;
                        ////Added By Priya Ref: Task no: 2897
                        //TrRefreshSharedTables.Visible = false;
                        ////added By Priya Ref:Task No:2986
                        //TrPrinterDevice.Visible = false;
                        ButtonManageUsers.Visible = false;
                        ButtonManagePharmacies.Visible = false;
                        ButtonRefreshSharedTables.Visible = false;
                        ButtonPrinter.Visible = false;
                    }
                    //Added by Chandan for task #2604
                    if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrescriptionReview == "Y" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                    {
                        Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                        PrescriptionCount = objMedicationLogin.GetPrescriptionsReviewStatus(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime);
                        if (PrescriptionCount > 0)
                        {
                            //TrReviewPrescriptions.Visible = true;
                            ButtonReviewPrescriptions.Visible = true;
                            ButtonReviewPrescriptions.Text = "Pending Review (" + PrescriptionCount + ")";
                        }
                        else
                        {
                            //TrReviewPrescriptions.Visible = false;
                            ButtonReviewPrescriptions.Visible = false;
                        }
                    }
                    else
                    {
                        //TrReviewPrescriptions.Visible = false;
                        ButtonReviewPrescriptions.Visible = false;
                    }
                    //Added By Priya Ref:task No:2859 for Verbal Order Button
                    //if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                    //{
                    //    VerbalOrderCount = objMedicationLogin.GetVerbalOrderStatus(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                    //    if (VerbalOrderCount > 0)
                    //    {
                    //        TrVerbalOrders.Visible = true;
                    //        ButtonVerbalOrders.Text = "Verbal Orders(" + VerbalOrderCount + ")";
                    //    }
                    //    else
                    //        TrVerbalOrders.Visible = false;
                    //}
                    //else
                    //    TrVerbalOrders.Visible = false;
                    //End Code

                }
                else
                {
                    HiddenFieldFirstChance.Value = Convert.ToString(Convert.ToInt32(HiddenFieldFirstChance.Value) + 1);
                    if (Convert.ToInt32(HiddenFieldFirstChance.Value) >= 2)
                    {
                        if (HiddenFieldSecondChance.Value == "")
                            HiddenFieldSecondChance.Value = "0";
                        HiddenFieldSecondChance.Value = Convert.ToString(Convert.ToInt32(HiddenFieldSecondChance.Value) + 1);
                        if (HiddenFieldSecondChance.Value == "1")
                        {
                            dsTemp = (DataSet)Session["DataSetSecurityQustion"];
                            Random random = new Random();
                            if (dsTemp != null)
                            {
                                int num = random.Next(0, dsTemp.Tables[0].Rows.Count);
                                if (dsTemp.Tables[0].Rows.Count > 0)
                                {
                                    Question1.InnerText = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["CodeName"].ToString();
                                    Session["Answer"] = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["SecurityAnswer"].ToString();
                                }

                            }
                        }
                        if (Convert.ToInt32(HiddenFieldSecondChance.Value) > 2)
                        {
                            objMedicationLogin.chkCountLogin(((StreamlineIdentity)(Context.User.Identity)).UserCode);
                            LabelTitleBar.Text = "Security Questions";
                            //TableResources.Visible = false;
                            //TableLabelResources.Visible = false;
                            TableSecurityQuestion.Style.Add("display", "block");
                            StartPage.Style.Add("display", "none");
                            TableDashboard.Visible = false;
                            DivErrorMessage.Style.Add("display", "block");
                            ImageError.Style.Add("display", "block");
                            ImageError.Style.Add("display", "block");
                            LabelErrorMessage.Style.Add("display", "block");
                            //Ref to Task#2652
                            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), "fdkjgh", "GetFocus();", true);
                            LabelErrorMessage.Text = "Your account is disabled.Please contact system administrator.";
                            ButtonSubmit.Visible = false;
                            return;
                        }
                    }
                    LabelTitleBar.Text = "Security Questions";
                    //TableResources.Visible = false;
                    //TableLabelResources.Visible = false;
                    TableSecurityQuestion.Style.Add("display", "block");
                    StartPage.Style.Add("display", "none");
                    TableDashboard.Visible = false;
                    DivErrorMessage.Style.Add("display", "block");
                    ImageError.Style.Add("display", "block");
                    ImageError.Style.Add("display", "block");
                    LabelErrorMessage.Style.Add("display", "block");
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), "fdkjgh", "GetFocus();", true);
                    LabelErrorMessage.Text = "The answers provided do not match the answers on record.";
                }
            }
            #endregion

            else if (TrQuestion.Style["display"] == "none")
            {
                //Code added in ref to Task#2954 on basis of Tom's Comment when the EnablePrescriberSecurityQuestion = 'N', 
                //the page should still be displayed if the user has more than one assigned location.  In this case, only the location drop-down will be displayed.
                if (DropDownListLocations.SelectedIndex > 0)
                {
                    Session["AssociatedLocation"] = DropDownListLocations.SelectedValue;
                }
                else
                {
                    if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows.Count == 1)
                    {
                        Session["AssociatedLocation"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList.Rows[0]["LocationId"];
                    }
                    else
                    {
                        Session["AssociatedLocation"] = null;
                    }
                }
                //TableResources.Visible = true;
                //TableLabelResources.Visible = true;
                LabelTitleBar.Text = "Start Page";
                TableSecurityQuestion.Style.Add("display", "none");
                StartPage.Style.Add("display", "block");
                TableDashboard.Visible = true;
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                {
                    //TrUserManagement.Visible = true;
                    ButtonManageUsers.Visible = true;
                    //TrPharmacyManagement.Visible = true;
                    ButtonManagePharmacies.Visible = true;
                    //Added By Priya Ref: Task no: 2897
                    //TrRefreshSharedTables.Visible = true;
                    ButtonRefreshSharedTables.Visible = true;
                    //added By Priya Ref:Task No:2986
                    //TrPrinterDevice.Visible = true;
                    ButtonPrinter.Visible = true;
                }
                else
                {
                    //TrUserManagement.Visible = false;
                    ButtonManageUsers.Visible = false;
                    //TrPharmacyManagement.Visible = false;
                    ButtonManagePharmacies.Visible = false;
                    //Added By Priya Ref: Task no: 2897
                    //TrRefreshSharedTables.Visible = false;
                    ButtonRefreshSharedTables.Visible = false;
                    //added By Priya Ref:Task No:2986
                    //TrPrinterDevice.Visible = false;
                    ButtonPrinter.Visible = false;
                }
                //Added by Chandan for task #2604
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrescriptionReview == "Y" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                {
                    Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                    PrescriptionCount = objMedicationLogin.GetPrescriptionsReviewStatus(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime);
                    if (PrescriptionCount > 0)
                    {
                        //TrReviewPrescriptions.Visible = true;
                        ButtonReviewPrescriptions.Visible = true;
                        ButtonReviewPrescriptions.Text = "Pending Review (" + PrescriptionCount + ")";
                    }
                    else
                    {
                        //   TrReviewPrescriptions.Visible = false;
                        ButtonReviewPrescriptions.Visible = false;
                    }
                }
                else
                {
                    //   TrReviewPrescriptions.Visible = false;
                    ButtonReviewPrescriptions.Visible = false;
                }
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

    protected void ButtonCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Response.Redirect("MedicationLogin.aspx");
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

    private void GridBind()
    {
        DataSet dataSetResources = null;
        try
        {
            dataSetResources = new DataSet();
            DataRow[] drResources = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category = 'MMFAVORITES' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'");
            dataSetResources.Merge(drResources);
            if (dataSetResources != null && dataSetResources.Tables.Count > 0)
            {
                if (dataSetResources.Tables.Count > 0)
                {
                    GridViewResources.DataSource = dataSetResources;
                    for (short index = 0; index < dataSetResources.Tables[0].Rows.Count; index++)
                    {
                        if (dataSetResources.Tables[0].Rows[index]["ExternalCode1"].ToString() == "")
                        {
                            dataSetResources.Tables[0].Rows[index]["ExternalCode1"] = "null";
                        }
                    }
                    GridViewResources.DataBind();
                    //TableResources.Style.Add("display", "block");
                    //TableLabelResources.Style.Add("display", "block");
                }
                else
                {
                    //TableResources.Style.Add("display", "none");
                    //TableLabelResources.Style.Add("display", "none");
                    ////StartPage.Style.Add("margin-top", "18%");
                    ////StartPage.Style.Add("margin-bottom", "19%");
                }
            }
            else
            {
                //TableResources.Style.Add("display", "none");
                //TableLabelResources.Style.Add("display", "none");
                ////StartPage.Style.Add("margin-top", "18%");
                ////StartPage.Style.Add("margin-bottom", "19%");
            }
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }

    protected void GridViewResources_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            //e.Row.FindControl("CodeName").
        }
        catch (Exception ex)
        {
            throw;
        }
    }

    /// <summary>
    /// <Description>Added in ref to Task#2954</Description>
    /// <Author>Loveena</Author>
    /// </summary>
    private void FillLocations()
    {
        DataView DataViewLocations = null;
        DataTable DataTableAssociatedLocations = null;
        try
        {
            CommonFunctions.Event_Trap(this);
            DataTableAssociatedLocations = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffLocationsList;
            if (DataTableAssociatedLocations.Rows.Count > 0)
            {
                DataViewLocations = DataTableAssociatedLocations.DefaultView;
                DataViewLocations.Sort = "LocationName Asc";
                DropDownListLocations.DataSource = DataViewLocations;
                DropDownListLocations.DataTextField = "LocationName";
                DropDownListLocations.DataValueField = "LocationId";
                DropDownListLocations.DataBind();

                DropDownListLocations.Items.Insert(0, new ListItem("........Select Location........", "0"));
                if (DataViewLocations.Table.Rows[0]["DefaultPrescribingLocation"] != System.DBNull.Value)
                {
                    DropDownListLocations.SelectedValue = Convert.ToString(DataViewLocations.Table.Rows[0]["DefaultPrescribingLocation"]);
                }
                else
                {
                    DropDownListLocations.SelectedIndex = 0;
                }
            }
            //Added By Anuj For task ref :2954 on 18 March,2010
            else
            {
                DropDownListLocations.Enabled = false;
                DropDownListLocations.SelectedIndex = 0;
                Session["AssociatedLocation"] = null;
                DropDownListLocations.Items.Insert(0, new ListItem("........Select Location........", "0"));
            }

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillLocationsCombo(),ParameterCount 0 - ###");
            else
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

            DataViewLocations = null;

        }
    }

    /// <summary>
    /// <Description>The Prescriber dropdown has values of All, Name of the Current User and 
    /// PrescriberProxies.PrescriberId where currentuser = ProxyStaffId. </Description>
    /// <CreatedBy>Loveena</CreatedBy>
    /// <CreatedOn>30Jan2010</CreatedOn>
    /// </summary>
    private void GetProxyPrescriber()
    {
        DataSet dataSetProxyPrescriber = null;

        try
        {
            objSureScriptRefillRequest = new SureScriptRefillRequest();
            if (Session["ProxyPrescriber"] == null)
                dataSetProxyPrescriber = objSureScriptRefillRequest.GetPrescriberProxies(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
            else
                dataSetProxyPrescriber = (DataSet)Session["ProxyPrescriber"];
            Session["ProxyPrescriber"] = dataSetProxyPrescriber;
            DataRow[] dataRowCurrentUserPrescriber = null;
            dataRowCurrentUserPrescriber = dataSetProxyPrescriber.Tables[0].Select("PrescriberId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
            if (dataRowCurrentUserPrescriber.Length > 0)
            {
                dataViewProxyPrescriber = dataSetProxyPrescriber.Tables[0].DefaultView;
            }
            else
            {
                dataViewProxyPrescriber = dataSetProxyPrescriber.Tables[0].DefaultView;
                DataRowView dataRowCurrentPrescriber = dataViewProxyPrescriber.AddNew();
                dataRowCurrentPrescriber["PrescriberId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                dataRowCurrentPrescriber["StaffName"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastName + ", " + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).FirstName;
                dataRowCurrentPrescriber.EndEdit();
                dataViewProxyPrescriber.Sort = "StaffName Asc";
            }
            DropDownListRefillPrescriber.DataSource = dataViewProxyPrescriber;
            DropDownListRefillPrescriber.DataTextField = "StaffName";
            DropDownListRefillPrescriber.DataValueField = "PrescriberId";
            DropDownListRefillPrescriber.DataBind();
            DropDownListRefillPrescriber.Items.Insert(0, new ListItem("All", "0"));
            DropDownListRefillPrescriber.SelectedIndex = 0;

            //foreach (DataRow dr in dataViewProxyPrescriber)    
            //{
            //    if(dr["PresciberId"]!=null)
            //}
            //Added by Anuj for tak ref 85
            DropDownListOutBoundPrescriber.DataSource = dataViewProxyPrescriber;
            DropDownListOutBoundPrescriber.DataTextField = "StaffName";
            DropDownListOutBoundPrescriber.DataValueField = "PrescriberId";
            DropDownListOutBoundPrescriber.DataBind();
            DropDownListOutBoundPrescriber.Items.Insert(0, new ListItem("All", "0"));
            DropDownListOutBoundPrescriber.SelectedIndex = 0;

            //Binding Change Prescriber
            DropDownListChangePrescriber.DataSource = dataViewProxyPrescriber;
            DropDownListChangePrescriber.DataSource = dataViewProxyPrescriber;
            DropDownListChangePrescriber.DataTextField = "StaffName";
            DropDownListChangePrescriber.DataValueField = "PrescriberId";
            DropDownListChangePrescriber.DataBind();
            DropDownListChangePrescriber.Items.Insert(0, new ListItem("All", "0"));
            DropDownListChangePrescriber.SelectedIndex = 0;

            //Binding Start Prescriber
            DropDownListStartPresriber.DataSource = dataViewProxyPrescriber;
            DropDownListStartPresriber.DataTextField = "StaffName";
            DropDownListStartPresriber.DataValueField = "PrescriberId";
            DropDownListStartPresriber.DataBind();
            DropDownListStartPresriber.Items.Insert(0, new ListItem("All", "0"));
            DropDownListStartPresriber.SelectedIndex = 0;

        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {
            dataSetProxyPrescriber = null;
            //dataViewProxyPrescriber = null;
        }
    }

    
    private void GetSureScriptChange() 
    {
      DataSet dataSetSureScriptsChangeRequest = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        string prescribers = string.Empty;
        try
        {
            if (DropDownListChangePrescriber.SelectedValue != null)
            {
                if (Convert.ToInt32(DropDownListChangePrescriber.SelectedValue) > 0)
                {
                    dataSetSureScriptsChangeRequest = objSureScriptRefillRequest.GetSureScriptChange(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, Convert.ToInt32(DropDownListChangePrescriber.SelectedValue));
                    prescriberId = Convert.ToInt32(DropDownListChangePrescriber.SelectedValue);
                }
                else
                {

                    dataSetSureScriptsChangeRequest = objSureScriptRefillRequest.GetSureScriptChange(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, 0);
                    prescriberId = 0;
                }
            }

            Session["DataSetSureScriptsChangeRequest"] = null;
            Session["DataSetSureScriptsChangeRequest"] = dataSetSureScriptsChangeRequest;

            ChangeList.DataSource = dataSetSureScriptsChangeRequest.Tables[0]; //AddEmptyRow();
            ChangeList.DataBind();
         
        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
        }

    }
    //Pranay


    private void GetSureScriptRefill()
    {
        DataSet dataSetSureScriptsRefillRequest = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        string prescribers = string.Empty;
        try
        {

            if (DropDownListRefillPrescriber.SelectedValue != null)
            {
                if (Convert.ToInt32(DropDownListRefillPrescriber.SelectedValue) > 0)
                {
                    //dataSetSureScriptsRefillRequest = objSureScriptRefillRequest.GetSureScriptRefill(Convert.ToInt32(DropDownListRefillPrescriber.SelectedValue), DropDownListRefillPrescriber.SelectedValue);
                    dataSetSureScriptsRefillRequest = objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, Convert.ToInt32(DropDownListRefillPrescriber.SelectedValue));
                    prescriberId = Convert.ToInt32(DropDownListRefillPrescriber.SelectedValue);
                }
                else
                {
                    //dataSetSureScriptsRefillRequest = objSureScriptRefillRequest.GetSureScriptRefill(Convert.ToInt32(DropDownListRefillPrescriber.SelectedValue), prescribers);
                    dataSetSureScriptsRefillRequest = objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, 0);
                    prescriberId = 0;
                }
            }

            Session["DataSetSureScriptRequestRefill"] = null;
            Session["DataSetSureScriptRequestRefill"] = dataSetSureScriptsRefillRequest;
            //Session["DataSetSureScriptRequestRefill"] = dsSureScriptRefill;
            RefillList.DataSource = dataSetSureScriptsRefillRequest.Tables[0]; //AddEmptyRow();
            RefillList.DataBind();
            //GridViewRefillRequests.DataSource = AddEmptyRow();
            //GridViewRefillRequests.DataBind();
        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
        }
    }

    //Added in ref to Task#3254-2.4 Refill Requests Layout Changes
    private DataTable AddEmptyRow()
    {
        DataTable originalDataTable = ((DataSet)(Session["DataSetSureScriptRequestRefill"])).Tables[0];
        DataTable newDataTable = originalDataTable.Clone();
        if (originalDataTable.Rows.Count > 0)
        {
            string SureScriptsRefillRequestId = originalDataTable.Rows[0]["SureScriptsRefillRequestId"].ToString();
            foreach (DataRow dRow in originalDataTable.Rows)
            {
                if (SureScriptsRefillRequestId != dRow["SureScriptsRefillRequestId"].ToString())
                {
                    DataRow newDataRow = newDataTable.NewRow();
                    newDataTable.Rows.Add(newDataRow);
                    SureScriptsRefillRequestId = dRow["SureScriptsRefillRequestId"].ToString();
                }
                newDataTable.ImportRow(dRow);
            }
        }
        return newDataTable;
    }





    public string formatModifiedDate(object date)
    {
        string _date;
        if (Convert.ToString(date) != "")
            return _date = ((DateTime)date).ToString("MM/dd/yyyy");
        return "";
    }

    public string formatPharmacy(object PharmacyName)
    {
        string Pharmacy;

        if (((string)PharmacyName).Length > 25)
            return Pharmacy = ((string)PharmacyName).Substring(0, 20) + "...";
        else
            return Pharmacy = ((string)PharmacyName);

    }

    //protected void GridViewRefillRequests_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    try
    //    {
    //        if (e.Row.RowType == DataControlRowType.DataRow)
    //        {
    //            if (((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text == "")
    //            {
    //                ((Image)e.Row.FindControl("ImageApproved")).Visible = false;
    //                ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Visible = false;
    //                ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Visible = false;
    //                ((Image)e.Row.FindControl("ImageDeny")).Visible = false;
    //                ((Image)e.Row.FindControl("ImageSearch")).Visible = false;
    //                ((Image)e.Row.FindControl("ImageSearchMedication")).Visible = false;
    //                ((Image)e.Row.FindControl("ImagePharmacyDetails")).Visible = false;
    //            }
    //            else
    //            {
    //                if (((Label)e.Row.FindControl("LabelPatientName")).Text != "")
    //                {
    //                    if (((Label)e.Row.FindControl("LabelSameLastName")).Text != "" && ((Label)e.Row.FindControl("LabelSameFirstName")).Text != "")
    //                    {
    //                        if (((Label)e.Row.FindControl("LabelSameLastName")).Text != "0" && ((Label)e.Row.FindControl("LabelSameFirstName")).Text != "0")
    //                        {
    //                            ((Label)e.Row.FindControl("LabelPatientName")).Attributes.Add("title", ((Label)e.Row.FindControl("LabelPatientName")).Text + "(" + ((Label)e.Row.FindControl("LabelSameLastName")).Text + "," + (((Label)e.Row.FindControl("LabelSameFirstName")).Text) + ")");
    //                        }
    //                    }
    //                    else
    //                        ((Label)e.Row.FindControl("LabelPatientName")).Attributes.Add("title", (((Label)e.Row.FindControl("LabelPatientName")).Text));

    //                    //Commented by Loveena in ref to Task#3254-2.4 Refill Requests Layout Changes
    //                    //((Label)e.Row.FindControl("LabelPatientName")).Text = ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelPatientName")).Text), 15);                    
    //                    if (((Label)e.Row.FindControl("LabelSameLastName")).Text != "" && ((Label)e.Row.FindControl("LabelSameFirstName")).Text != "")
    //                    {
    //                        if (((Label)e.Row.FindControl("LabelSameLastName")).Text != "0" && ((Label)e.Row.FindControl("LabelSameFirstName")).Text != "0")
    //                        {
    //                            ((Label)e.Row.FindControl("LabelPatientName")).Text = ((Label)e.Row.FindControl("LabelPatientName")).Text + " (" + ((Label)e.Row.FindControl("LabelSameLastName")).Text + "," + ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelSameFirstName")).Text), 15) + ")";
    //                        }
    //                    }

    //                    //Added in ref to Task#3254-To wrap the Patien Name to next line
    //                    if (((Label)e.Row.FindControl("LabelPatientName")).Text.Length > 15)
    //                    {
    //                        string test = ((Label)e.Row.FindControl("LabelPatientName")).Text;
    //                        string result = ((Label)e.Row.FindControl("LabelPatientName")).Text.Substring(0, 15);
    //                        int resultLength = result.Length;
    //                        result = result + "<br />" + ((Label)e.Row.FindControl("LabelPatientName")).Text.Substring(result.Length, test.Length - 15);
    //                        //string result = BreakWordForWrap(test);
    //                        ((Label)e.Row.FindControl("LabelPatientName")).Text = result;

    //                    }
    //                }
    //                #region--Code Added by Pradeep as per task#3325 on 14 March 2011
    //                if (((Label)e.Row.FindControl("LabelItemDAW")).Text != "")
    //                {
    //                    if (((Label)e.Row.FindControl("LabelItemDAW")).Text.Trim() == "1" || ((Label)e.Row.FindControl("LabelItemDAW")).Text.Trim() == "7")
    //                    {
    //                        ((Label)e.Row.FindControl("LabelItemDAW")).Text = "Y";
    //                    }
    //                    else
    //                    {
    //                        ((Label)e.Row.FindControl("LabelItemDAW")).Text = "N";
    //                    }
    //                }
    //                else
    //                {
    //                    ((Label)e.Row.FindControl("LabelItemDAW")).Text = "N";
    //                }
    //                #endregion
    //                #region--Code Added by Pradeep as per task#3341 on 14 March 2011
    //                string PharmacyText=((Label)e.Row.FindControl("LabelQuantity")).Text.Trim();
    //                string PharmacyTextToDisplay = string.Empty;
    //                string QuantityValue=string.Empty;

    //                if(PharmacyText!=string.Empty)
    //                {
    //                    string[] strArrayPharmacyText=PharmacyText.Split('x');
    //                    if(strArrayPharmacyText.Length>0)
    //                    {
    //                     QuantityValue=strArrayPharmacyText[0].ToString().Trim();
    //                     PharmacyTextToDisplay = CommonFunctions.trimToPrecision(QuantityValue,3) + " x " + strArrayPharmacyText[1].ToString();           
    //                    }
    //                    if(PharmacyTextToDisplay!=string.Empty)
    //                    {
    //                        ((Label)e.Row.FindControl("LabelQuantity")).Text = PharmacyTextToDisplay;
    //                    }
    //                }
    //                #endregion--Code Added by Pradeep as per task#3341 on 14 March 2011
    //                if (((Label)e.Row.FindControl("LabelStaffName")).Text != "")
    //                {
    //                    ((Label)e.Row.FindControl("LabelStaffName")).Attributes.Add("title", ((Label)e.Row.FindControl("LabelStaffName")).Text);
    //                    ((Label)e.Row.FindControl("LabelStaffName")).Text = ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelStaffName")).Text), 15);

    //                }
    //                if (((Label)e.Row.FindControl("LabelDOB")).Text != "")
    //                {
    //                    string ClientDOB = ((Label)e.Row.FindControl("LabelDOB")).Text;
    //                    string ClientAge = Streamline.UserBusinessServices.ApplicationCommonFunctions.GetAge(ClientDOB);
    //                    ClientDOB = ClientDOB + ' ' + '(' + ClientAge + ')';
    //                    ((Label)e.Row.FindControl("LabelDOB")).Text = ClientDOB;
    //                }

    //                if (((Label)e.Row.FindControl("LabelClientId")).Text != "")
    //                {
    //                    string surescriptrefillrequestid = ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text;
    //                    ((Label)e.Row.FindControl("LabelPatientName")).Style.Add("text-decoration", "underline");
    //                    ((Label)e.Row.FindControl("LabelPatientName")).Style.Add("cursor", "hand");
    //                    ((Label)e.Row.FindControl("LabelPatientName")).Attributes.Add("onclick", "OpenPatientMainPage(" + ((Label)e.Row.FindControl("LabelClientId")).Text + ");");
    //                    ((Image)e.Row.FindControl("ImageSearchMedication")).Visible = true;
    //                    //Added By Priya 
    //                    string pharmacyIDNew = ((Label)e.Row.FindControl("LabelPharmacyId")).Text;
    //                    //((HiddenField)Parent.FindControl("HiddenFieldRefillPharmacyId")).Value = pharmacyIDNew;
    //                    string surescriptrefillrequestidNew = ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text;
    //                    //((HiddenField)Parent.FindControl("HiddenFieldSureScriptRefillRequestId")).Value = surescriptrefillrequestidNew;
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Enabled = true;
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = "~/App_Themes/Includes/Images/enable_20.png";
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Attributes.Add("onclick", "redirectToOrderPageFromDenialScreen('" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text + "','" + pharmacyIDNew + "','" + ((Label)e.Row.FindControl("LabelPharmacyName")).Text + "','" + ((Label)e.Row.FindControl("LabelDrugCategory")).Text + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode + "')");
    //                    ((Image)e.Row.FindControl("ImageSearchMedication")).Attributes.Add("onclick", "redirectToCurrentMedications('" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text + "')");
    //                }
    //                else
    //                {
    //                    ((Image)e.Row.FindControl("ImageSearchMedication")).Visible = false;
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = "~/App_Themes/Includes/Images/disable_45.png";
    //                }
    //                if (((Label)e.Row.FindControl("LabelClientMedicationScriptDrugStrengthId")).Text != "")
    //                {
    //                    ((Label)e.Row.FindControl("LabelMedication")).Text = ((Label)e.Row.FindControl("LabelMedication")).Text + "(" + ((Label)e.Row.FindControl("LabelMedicationName")).Text + ")";
    //                    ((Label)e.Row.FindControl("LabelMedication")).Style.Add("text-decoration", "underline");
    //                    ((Label)e.Row.FindControl("LabelMedication")).Style.Add("cursor", "hand");
    //                    ((Label)e.Row.FindControl("LabelDirections")).Style.Add("text-decoration", "underline");
    //                    ((Label)e.Row.FindControl("LabelDirections")).Style.Add("cursor", "hand");
    //                    //Added in ref to Task#3254-To wrap the SureScriptsRefillRequest.Directions to next line
    //                    if (((Label)e.Row.FindControl("LabelDirections")).Text.Length > 50)
    //                    {
    //                        string test = ((Label)e.Row.FindControl("LabelDirections")).Text;
    //                        // #ka string result = ((Label)e.Row.FindControl("LabelDirections")).Text.Substring(0, 50);
    //                        // #ka int resultLength = result.Length;
    //                        // #ka result = result + "<br />" + ((Label)e.Row.FindControl("LabelDirections")).Text.Substring(result.Length, 50);
    //                        // #ka result = result + "<br />" + ((Label)e.Row.FindControl("LabelDirections")).Text.Substring(result.Length, test.Length - result.Length);
    //                        //((Label)e.Row.FindControl("LabelDirections")).Text = result; //Comented By Pradeep as per task#3334
    //                        ((Label)e.Row.FindControl("LabelDirections")).Text = test; //Written by Pradeep as per task#3334

    //                    }

    //                }
    //                string NumberOfRefillToDisplay = ((Label)e.Row.FindControl("LabelNumberOfRefills")).Text.Trim();
    //                HiddenField HiddenFieldRefilType = (e.Row.FindControl("HiddenFielDRefillType")) as HiddenField;
    //                if (HiddenFieldRefilType.Value.Trim().ToUpper() == "PRN")
    //                {
    //                    ((Label)e.Row.FindControl("LabelNumberOfRefills")).Text = "PRN";
    //                }
    //                if (((Label)e.Row.FindControl("LabelClientMedicationScriptDrugStrengthId")).Text != "" && ((Label)e.Row.FindControl("LabelClientId")).Text != "")
    //                {
    //                    ((Image)e.Row.FindControl("ImageApproved")).Enabled = true;
    //                    ((Image)e.Row.FindControl("ImageApproved")).ImageUrl = "~/App_Themes/Includes/Images/enable_16.png";
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).ImageUrl = "~/App_Themes/Includes/Images/enable_18.png";
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Enabled = true;
    //                    //Added By Pushpita 
    //                    string pharmacyID = ((Label)e.Row.FindControl("LabelPharmacyId")).Text;
    //                    string surescriptrefillrequestid = ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text;

    //                   // ((Image)e.Row.FindControl("ImageApproved")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + ((Label)e.Row.FindControl("LabelClientMedicationId")).Text + ",'Refill','" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + surescriptrefillrequestid + "','" + pharmacyID + "','Approved','" + ((Label)e.Row.FindControl("LabelNumberOfRefills")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantityValue")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantity")).Text + "','" + ((Label)e.Row.FindControl("LabelNumberOfDaysSupply")).Text + "','" + ((Label)e.Row.FindControl("LabelPharmacyName")) + "','" + ((Label)e.Row.FindControl("LabelDrugCategory")).Text + "');");

    //                    ((Image)e.Row.FindControl("ImageApproved")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + ((Label)e.Row.FindControl("LabelClientMedicationId")).Text + ",'Refill','" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + surescriptrefillrequestid + "','" + pharmacyID + "','Approved','" + NumberOfRefillToDisplay + "','" + ((Label)e.Row.FindControl("LabelQuantityValue")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantity")).Text + "','" + ((Label)e.Row.FindControl("LabelNumberOfDaysSupply")).Text + "',this,'" + ((Label)e.Row.FindControl("LabelDrugCategory")).Text + "');");
    //                    //((Image)e.Row.FindControl("ImageApproved")).Attributes.Add("onclick", "Test(this);");

    //                    //((Image)e.Row.FindControl("ImageApprovedWithChanges")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + ((Label)e.Row.FindControl("LabelClientMedicationId")).Text + ",'Refill','" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + surescriptrefillrequestid + "','" + pharmacyID + "','ApprovedWithChanges','" + ((Label)e.Row.FindControl("LabelNumberOfRefills")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantityValue")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantity")).Text + "','" + ((Label)e.Row.FindControl("LabelNumberOfDaysSupply")).Text + "','" + ((Label)e.Row.FindControl("LabelPharmacyName")).Text + "','" + ((Label)e.Row.FindControl("LabelDrugCategory")).Text + "');");
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + ((Label)e.Row.FindControl("LabelClientMedicationId")).Text + ",'Refill','" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + surescriptrefillrequestid + "','" + pharmacyID + "','ApprovedWithChanges','" + NumberOfRefillToDisplay + "','" + ((Label)e.Row.FindControl("LabelQuantityValue")).Text + "','" + ((Label)e.Row.FindControl("LabelQuantity")).Text + "','" + ((Label)e.Row.FindControl("LabelNumberOfDaysSupply")).Text + "',this,'" + ((Label)e.Row.FindControl("LabelDrugCategory")).Text + "');");
    //                }
    //                else
    //                {
    //                    ((Image)e.Row.FindControl("ImageApproved")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageApproved")).ImageUrl = "~/App_Themes/Includes/Images/disable_41.png";
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).ImageUrl = "~/App_Themes/Includes/Images/disable_43.png";
    //                }
    //                if (((Label)e.Row.FindControl("LabelIsExistSureScriptRefillRequestId")).Text == "0")
    //                {
    //                    ((Image)e.Row.FindControl("ImageApproved")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageApproved")).ImageUrl = "~/App_Themes/Includes/Images/disable_41.png";
    //                    ((Image)e.Row.FindControl("ImageApprovedWithChanges")).ImageUrl = "~/App_Themes/Includes/Images/disable_43.png";
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = "~/App_Themes/Includes/Images/disable_45.png";
    //                    ((Image)e.Row.FindControl("ImageDeny")).Enabled = false;
    //                    ((Image)e.Row.FindControl("ImageDeny")).ImageUrl = "~/App_Themes/Includes/Images/disable_47.png";
    //                }
    //                else
    //                {
    //                    ((Image)e.Row.FindControl("ImageDeny")).Enabled = true;
    //                    ((Image)e.Row.FindControl("ImageDeny")).ImageUrl = "~/App_Themes/Includes/Images/enable_22.png";
    //                    ((Image)e.Row.FindControl("ImageDeny")).Attributes.Add("onclick", "openRefillDeniedReason('" + ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode + "');");
    //                    //((Image)e.Row.FindControl("ImageDeny")).Attributes.Add("onclick", "alert('hai');");

    //                }
    //                //
    //                if (((Label)e.Row.FindControl("LabelPharmacyId")).Text != "")
    //                {
    //                    string PharmacyName = ((Label)e.Row.FindControl("LabelPharmacyName")).Text;
    //                    string Address = ((Label)e.Row.FindControl("LabelPharmacyAddress")).Text;
    //                    string City = ((Label)e.Row.FindControl("LabelPharmacyCity")).Text;
    //                    string State = ((Label)e.Row.FindControl("LabelPharmacyState")).Text;
    //                    string Zip = ((Label)e.Row.FindControl("LabelPharmacyZip")).Text;
    //                    string Phone = ((Label)e.Row.FindControl("LabelPharmacyPhone")).Text;
    //                    string Fax = ((Label)e.Row.FindControl("LabelPharmacyFax")).Text;
    //                    StringBuilder PharmacyDetails = FormatPharmacyDetail(PharmacyName, Address, City, State, Zip, Phone, Fax);
    //                    ((Image)e.Row.FindControl("ImagePharmacyDetails")).Style.Add("display", "block");
    //                    ((Image)e.Row.FindControl("ImagePharmacyDetails")).Attributes.Add("title", PharmacyDetails.ToString().Replace("/r", System.Environment.NewLine));
    //                }
    //                else
    //                    ((Image)e.Row.FindControl("ImagePharmacyDetails")).Style.Add("display", "none");
    //                //Added By priya Ref:task No:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
    //                if (((Label)e.Row.FindControl("LabelClientMedicationScriptDrugStrengthId")).Text != "")
    //                {
    //                    if (((Label)e.Row.FindControl("LabelDrugCategory")).Text == "2")
    //                    {
    //                        ((Image)e.Row.FindControl("ImageDeny")).Enabled = true;
    //                        ((Image)e.Row.FindControl("ImageDeny")).ImageUrl = "~/App_Themes/Includes/Images/enable_22.png";
    //                        ((Image)e.Row.FindControl("ImageDeny")).Attributes.Add("onclick", "openRefillDeniedReason('" + ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode + "');");
    //                        ((Image)e.Row.FindControl("ImageApproved")).Enabled = false;
    //                        ((Image)e.Row.FindControl("ImageApprovedWithChanges")).Enabled = false;
    //                        ((Image)e.Row.FindControl("ImageApproved")).ImageUrl = "~/App_Themes/Includes/Images/disable_41.png";
    //                        ((Image)e.Row.FindControl("ImageApprovedWithChanges")).ImageUrl = "~/App_Themes/Includes/Images/disable_43.png";
    //                        ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).Enabled = false;
    //                        ((Image)e.Row.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = "~/App_Themes/Includes/Images/disable_45.png";

    //                    }
    //                }
    //                //end
    //                string[] PatientName = ((Label)e.Row.FindControl("LabelPassPatientName")).Text.Split(',');
    //                string LastName = "";
    //                string FirstName = "";
    //                #region--Code Comented by Pradeep on 12 March 2011 as per task#
    //                //if (PatientName.Length > 1)
    //                //{
    //                //    LastName = PatientName[0].ToString();
    //                //    FirstName = PatientName[1].ToString();
    //                //}
    //                #endregion
    //                #region--Code Added By Pradeep as per task#
    //                LastName = ((Label)e.Row.FindControl("LabelClientLastName")).Text.Trim();
    //                FirstName = ((Label)e.Row.FindControl("LabelClientFirstName")).Text.Trim();
    //                #endregion

    //                ((Image)e.Row.FindControl("ImageSearch")).Attributes.Add("onclick", "ShowClientSearch('" + ((Label)e.Row.FindControl("LabelClientId")).Text + "','" + CommonFunctions.ReplaceSpecialChars(FirstName) + "','" + CommonFunctions.ReplaceSpecialChars(LastName) + "','" + ((Label)e.Row.FindControl("LabelSureScriptsRefillRequestId")).Text + "' , " + prescriberId + ");");
    //            }
    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        if (ex.Data["CustomExceptionInformation"] == null)
    //            ex.Data["CustomExceptionInformation"] = "";
    //        else
    //            ex.Data["CustomExceptionInformation"] = "";
    //        if (ex.Data["DatasetInfo"] == null)
    //            ex.Data["DatasetInfo"] = null;
    //        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
    //    }
    //}


    public StringBuilder FormatPharmacyDetail(string PharmacyName, string PharmacyAddress, string PharmacyCity, string PharmacyState, string PharmacyZip, string Phone, string Fax)
    {
        try
        {
            StringBuilder PharmacyDetail = new StringBuilder();
            PharmacyDetail.Append("PharmacyDetails:");
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append(PharmacyName);
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append(PharmacyAddress);
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append(PharmacyCity + "," + PharmacyState + "," + PharmacyZip);
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append("Phone:" + " " + Phone);
            PharmacyDetail.Append("/r");
            PharmacyDetail.Append("Fax:" + " " + Fax);
            return PharmacyDetail;
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }
    /// <summary>
    /// <Description>Used to bind the outbound prescriptions (task ref #85) </Description>
    /// <CreatedBy>Anuj Tomar</CreatedBy>
    /// <CreatedOn>16feb,2010</CreatedOn>
    /// </summary>

    private void GetSureScriptOutboundPrescription()
    {
        DataSet dataSetSureScriptsOutboundPrescription = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        string prescribers = string.Empty;
        try
        {
            if (Session["DataSetSureScriptOutboundPrescription"] == null)
            {
                Int32 obpStaffid = Request["obpStaffid"] != null ? Int32.Parse(Request["obpStaffid"].ToString()) : 0;
                dataSetSureScriptsOutboundPrescription = objSureScriptRefillRequest.GetSureScriptOutboundPrescription(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, obpStaffid);
            }
            else
            {
                dataSetSureScriptsOutboundPrescription = (DataSet)Session["DataSetSureScriptOutboundPrescription"];
            }

            OutboundPrescriptionsControl.OutboundPrescriptionDataTable = dataSetSureScriptsOutboundPrescription.Tables[0];

        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
        }
    }

    private void GetSureScriptFill()
    {

        DataSet dataSetSureScriptsFillRequest = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        string prescribers = string.Empty;
        try
        {
            if (Session["DataSetSureScriptFillPrescription"] == null)
            {
                Int32 obpStaffid = Request["obpStaffid"] != null ? Int32.Parse(Request["obpStaffid"].ToString()) : 0;
                dataSetSureScriptsFillRequest = objSureScriptRefillRequest.GetSureScriptFill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, obpStaffid);
            }
            else
            {
                dataSetSureScriptsFillRequest = (DataSet)Session["DataSetSureScriptFillPrescription"];
            }

            RxFillControl.FillPrescriptionDataTable = dataSetSureScriptsFillRequest.Tables[0];


        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
        }

    }


    #region Create OutBoundPRescriptions
    //private void GenerateOutboundRows(DataSet dataSetSureScriptsOutboundPrescriptions)
    //{

    //    bool _boolRowWithInteractionFound = false;
    //    try
    //    {
    //        CommonFunctions.Event_Trap(this);

    //        System.Drawing.Color[] _color = 
    //            { 
    //            System.Drawing.Color.Pink, 
    //            System.Drawing.Color.Red, 
    //            System.Drawing.Color.Yellow, 
    //            System.Drawing.Color.Green, 
    //            System.Drawing.Color.Plum, 
    //            System.Drawing.Color.Aqua, 
    //            System.Drawing.Color.PaleGoldenrod, 
    //            System.Drawing.Color.Peru, 
    //            System.Drawing.Color.Tan, 
    //            System.Drawing.Color.Khaki, 
    //            System.Drawing.Color.DarkGoldenrod, 
    //            System.Drawing.Color.Maroon, 
    //            System.Drawing.Color.OliveDrab ,

    //            System.Drawing.Color.Crimson,
    //            System.Drawing.Color.Beige,
    //            System.Drawing.Color.DimGray,
    //            System.Drawing.Color.ForestGreen,
    //            System.Drawing.Color.Indigo,
    //            System.Drawing.Color.LightCyan           
    //            };
    //        PanelOutBoundPrescription.Controls.Clear();
    //        Table tblOutBoundPrescriptions = new Table();
    //        tblOutBoundPrescriptions.ID = System.Guid.NewGuid().ToString();

    //        tblOutBoundPrescriptions.Width = new Unit(98, UnitType.Percentage);

    //        //Table Row Started
    //        TableHeaderRow thTitle = new TableHeaderRow();

    //        //Balnk  Table Header Cell
    //        TableHeaderCell thcBlank1 = new TableHeaderCell();

    //        //Table Header Cell For Prescriber             
    //        TableHeaderCell thcPrescriber = new TableHeaderCell();
    //        thcPrescriber.Text = "Prescriber";
    //        thcPrescriber.Font.Underline = true;
    //        thcPrescriber.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcPrescriber.Attributes.Add("ColumnName", "OrderingPrescriberName");
    //        thcPrescriber.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcPrescriber.CssClass = "handStyle";
    //        }

    //        //Table Header Cell For Patient Name    
    //        TableHeaderCell thcPatientName = new TableHeaderCell();
    //        thcPatientName.Text = "Patient Name";
    //        thcPatientName.Font.Underline = true;
    //        thcPatientName.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcPatientName.Attributes.Add("ColumnName", "PatientName");
    //        thcPatientName.Attributes.Add("SortOrder", setAttributes());
    //        thcPatientName.Width = 120;
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcPatientName.CssClass = "handStyle";
    //        }
    //        //Table Header Cell For Date    
    //        TableHeaderCell thcDate = new TableHeaderCell();
    //        thcDate.Text = "Date";
    //        thcDate.Font.Underline = true;
    //        thcDate.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcDate.Attributes.Add("ColumnName", "CreatedDate");
    //        thcDate.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcDate.CssClass = "handStyle";
    //        }

    //        //Table Header Cell For Medication    
    //        TableHeaderCell thcMedication = new TableHeaderCell();
    //        thcMedication.Text = "Medication";
    //        thcMedication.Font.Underline = true;
    //        thcMedication.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcMedication.Attributes.Add("ColumnName", "MedicationName");
    //        thcMedication.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcMedication.CssClass = "handStyle";
    //        }
    //        //Table Header Cell For Instructions                         
    //        TableHeaderCell thcInstruction = new TableHeaderCell();
    //        thcInstruction.Text = "Strength/Instructions";
    //        thcInstruction.Font.Underline = true;
    //        thcInstruction.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcInstruction.Attributes.Add("ColumnName", "Instruction");
    //        thcInstruction.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcInstruction.CssClass = "handStyle";
    //        }

    //        //Table Header Cell For Pharmacy       
    //        TableHeaderCell thcPharmacy = new TableHeaderCell();
    //        thcPharmacy.Text = "Pharmacy";
    //        thcPharmacy.Font.Underline = true;
    //        thcPharmacy.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcPharmacy.Attributes.Add("ColumnName", "PharmacyName");
    //        thcPharmacy.Attributes.Add("SortOrder", setAttributes());

    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcPharmacy.CssClass = "handStyle";
    //        }
    //        //Table Header Cell For Method    
    //        TableHeaderCell thcMethod = new TableHeaderCell();
    //        thcMethod.Text = "Method";
    //        thcMethod.Font.Underline = true;
    //        thcMethod.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcMethod.Attributes.Add("ColumnName", "Method");
    //        thcMethod.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcMethod.CssClass = "handStyle";
    //        }

    //        //Table Header Cell For Status
    //        TableHeaderCell thcStatus = new TableHeaderCell();
    //        thcStatus.Text = "Status";
    //        thcStatus.Font.Underline = true;
    //        thcStatus.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcStatus.Attributes.Add("ColumnName", "Status");
    //        thcStatus.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcStatus.CssClass = "handStyle";
    //        }

    //        //Table Header Cell For Description
    //        TableHeaderCell thcDescription = new TableHeaderCell();
    //        thcDescription.Text = "Description";
    //        thcDescription.Font.Underline = true;
    //        thcDescription.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
    //        thcDescription.Attributes.Add("ColumnName", "StatusDescription");
    //        thcDescription.Attributes.Add("SortOrder", setAttributes());
    //        if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            thcDescription.CssClass = "handStyle";
    //        }

    //        //Adding all the header columns in Header rows
    //        thTitle.Cells.Add(thcBlank1);
    //        thTitle.Cells.Add(thcPrescriber);
    //        thTitle.Cells.Add(thcPatientName);

    //        thTitle.Cells.Add(thcDate);
    //        thTitle.Cells.Add(thcMedication);
    //        thTitle.Cells.Add(thcInstruction);
    //        thTitle.Cells.Add(thcPharmacy);
    //        thTitle.Cells.Add(thcMethod);
    //        thTitle.Cells.Add(thcStatus);
    //        thTitle.Cells.Add(thcDescription);

    //        thTitle.CssClass = "GridViewHeaderText";
    //        tblOutBoundPrescriptions.Rows.Add(thTitle);
    //        if (dataSetSureScriptsOutboundPrescriptions != null && dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
    //        {
    //            foreach (DataRow drSureScriptsOutboundPrescriptions in dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows)
    //            {
    //                string prescriberName = Convert.ToString(drSureScriptsOutboundPrescriptions["OrderingPrescriberName"]);
    //                string patientName = Convert.ToString(drSureScriptsOutboundPrescriptions["PatientName"]);
    //                string date = Convert.ToDateTime(drSureScriptsOutboundPrescriptions["CreatedDate"]).ToString("MM/dd/yyyy");
    //                string medication = Convert.ToString(drSureScriptsOutboundPrescriptions["MedicationName"]);
    //                string pharmacy = Convert.ToString(drSureScriptsOutboundPrescriptions["PharmacyName"]);
    //                string method = Convert.ToString(drSureScriptsOutboundPrescriptions["Method"]);
    //                string status = Convert.ToString(drSureScriptsOutboundPrescriptions["Status"]);
    //                string description = Convert.ToString(drSureScriptsOutboundPrescriptions["StatusDescription"]);
    //                int clientMedicationScriptActivityId = Convert.ToInt32(drSureScriptsOutboundPrescriptions["ClientMedicationScriptActivityId"]);
    //                DataRow[] drMedInstructions;
    //                //Modified in ref to Task#3262-OutBound Prescription:- Incorrect Record displays.
    //                drMedInstructions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationInstructions"].Select("ClientMedicationScriptActivityId=" + drSureScriptsOutboundPrescriptions["ClientMedicationScriptActivityId"] + " and ClientMedicationId=" + drSureScriptsOutboundPrescriptions["ClientMedicationId"]);
    //                bool showMedication = true;
    //                bool showPrescriber = true;
    //                bool showPatientName = true;
    //                bool showDate = true;
    //                bool showPharmacy = true;
    //                bool showMethod = true;
    //                bool showStatus = true;
    //                bool showDescription = true;
    //                bool showDelete = false;
    //                if (status == "Failed")
    //                    showDelete = true;
    //                foreach (DataRow drTemp in drMedInstructions)
    //                {
    //                    tblOutBoundPrescriptions.Rows.Add(GenerateOutBoundSubRows(drTemp, showPrescriber, showPatientName, showMedication, showDate, showPharmacy, showMethod, showStatus, showDescription, tblOutBoundPrescriptions.ClientID, prescriberName, patientName, date, medication, pharmacy, method, status, description, showDelete, clientMedicationScriptActivityId));
    //                    showMedication = false;
    //                    showPrescriber = false;
    //                    showPatientName = false;
    //                    showDate = false;
    //                    showPharmacy = false;
    //                    showMethod = false;
    //                    showStatus = false;
    //                    showDescription = false;
    //                    showDelete = false;
    //                }
    //                TableRow trLine = new TableRow();
    //                //TableCell tdHorizontalLine = new TableCell();
    //                //tdHorizontalLine.ColumnSpan = 10;
    //                //tdHorizontalLine.CssClass = "blackLine";
    //                //trLine.Cells.Add(tdHorizontalLine);
    //                //tblOutBoundPrescriptions.Rows.Add(trLine);
    //            }
    //        }
    //        else
    //        {
    //            tblOutBoundPrescriptions.Rows.Add(GenerateOutBoundSubRows(null, false, false, true, false, false, false, false, false, tblOutBoundPrescriptions.ClientID, "", "", "", "No Records Found", "", "", "", "", false, 0));
    //            //TableRow trLine = new TableRow();
    //            //TableCell tdHorizontalLine = new TableCell();
    //            //tdHorizontalLine.ColumnSpan = 10;
    //            //tdHorizontalLine.CssClass = "blackLine";
    //            //trLine.Cells.Add(tdHorizontalLine);
    //            //tblOutBoundPrescriptions.Rows.Add(trLine);
    //        }
    //        PanelOutBoundPrescription.Controls.Add(tblOutBoundPrescriptions);
    //    }
    //    catch (Exception ex)
    //    {

    //        throw (ex);
    //    }
    //}

    //private TableRow GenerateOutBoundSubRows(DataRow drTemp, bool showPrescriber, bool showPatientName, bool showMedication, bool showDate, bool showPharmacy, bool showMethod, bool showStatus, bool showDescription, string tableId, string prescriberName, string patientName, string date, string medication, string pharmacy, string method, string status, string description, bool showDelete, int clientMedicationScriptActivityId)
    //{
    //    try
    //    {
    //        CommonFunctions.Event_Trap(this);
    //        string newId = System.Guid.NewGuid().ToString();
    //        //int MedicationId = Convert.ToInt32(drTemp["ClientMedicationScriptActivityId"]);

    //        string tblId = this.ClientID + this.ClientIDSeparator + tableId;
    //        TableRow trTemp = new TableRow();
    //        trTemp.ID = "Tr_" + newId;
    //        int client = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

    //        //0th Column
    //        TableCell tdDelete = new TableCell();
    //        HtmlImage imgTemp = new HtmlImage();
    //        imgTemp.ID = "Img" + clientMedicationScriptActivityId;
    //        imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
    //        imgTemp.Style.Add("cursor", "hand");
    //        imgTemp.Attributes.Add("onclick", "deleteScriptActivityPending(" + clientMedicationScriptActivityId + " )");
    //        if (showDelete == true)
    //            tdDelete.Controls.Add(imgTemp);
    //        else
    //            tdDelete.Controls.Clear();
    //        //Ist Column                   
    //        TableCell tdPrescriber = new TableCell();
    //        //Commented by Loveena in ref to Task#3253-2.4 Outbound Prescriptions
    //        //if (prescriberName != "")
    //        //{
    //        //    prescriberName = ApplicationCommonFunctions.cutText((prescriberName), 15);
    //        //}
    //        if (showPrescriber == true)
    //            tdPrescriber.Text = prescriberName;
    //        else
    //            tdPrescriber.Text = "";

    //        //IInd Column
    //        TableCell tdPatientName = new TableCell();
    //        //Commented by Loveena in ref to Task#3253-2.4 Outbound Prescriptions
    //        //if (patientName != "")
    //        //{
    //        //    patientName = ApplicationCommonFunctions.cutText((patientName), 15);
    //        //}


    //        if (showPatientName == true)
    //            tdPatientName.Text = patientName;
    //        else
    //            tdPatientName.Text = "";

    //        //IIIrd Column
    //        TableCell tdDate = new TableCell();
    //        if (showDate == true)
    //            tdDate.Text = date;
    //        else
    //            tdDate.Text = "";

    //        //IVth Column
    //        TableCell tdMedication = new TableCell();
    //        if (showMedication == true)
    //            tdMedication.Text = medication;
    //        else
    //            tdMedication.Text = "";

    //        //Vth Column
    //        TableCell tdInstructions = new TableCell();
    //        if (drTemp != null)
    //            tdInstructions.Text = drTemp["Instruction"].ToString();

    //        //VIth Column
    //        TableCell tdPharmacy = new TableCell();
    //        if (showPharmacy == true)
    //            tdPharmacy.Text = pharmacy;
    //        else
    //            tdPharmacy.Text = "";


    //        //VIIth Column            
    //        TableCell tdMethod = new TableCell();
    //        if (showMethod == true)
    //            tdMethod.Text = method;
    //        else
    //            tdMethod.Text = "";

    //        //VIIIth Column
    //        TableCell tdStatus = new TableCell();
    //        if (showStatus == true)
    //            tdStatus.Text = status;
    //        else
    //            tdStatus.Text = "";

    //        //VIIIth Column
    //        TableCell tdDescription = new TableCell();
    //        if (showDescription == true)
    //            tdDescription.Text = description;
    //        else
    //            tdDescription.Text = "";

    //        trTemp.Cells.Add(tdDelete);
    //        trTemp.Cells.Add(tdPrescriber);
    //        trTemp.Cells.Add(tdPatientName);
    //        trTemp.Cells.Add(tdDate);
    //        trTemp.Cells.Add(tdMedication);//Instruction
    //        trTemp.Cells.Add(tdInstructions);
    //        trTemp.Cells.Add(tdPharmacy);
    //        trTemp.Cells.Add(tdMethod);
    //        trTemp.Cells.Add(tdStatus);
    //        trTemp.Cells.Add(tdDescription);

    //        trTemp.CssClass = "GridViewRowStyle";
    //        return trTemp;

    //    }
    //    catch (Exception ex)
    //    {
    //        if (ex.Data["CustomExceptionInformation"] == null)
    //            ex.Data["CustomExceptionInformation"] = "";
    //        else
    //            ex.Data["CustomExceptionInformation"] = "";
    //        if (ex.Data["DatasetInfo"] == null)
    //            ex.Data["DatasetInfo"] = null;
    //        throw (ex);
    //    }
    //}
    #endregion

    private string setAttributes()
    {
        if (_sortString == "")
        {
            return "";

        }
        else if (_sortString.Contains("Desc"))
        {
            return "Asc";

        }
        else if (_sortString.Contains("Asc"))
        {
            return "Desc";

        }
        else
        {
            return "";
        }
    }

    private DataTable GetFullAddressForPharmacy()
    {
        DataSet DataSetPharmacies = null;
        string[] ClientPharmecieIds=null;
        DataSet DataSetClientPharmecies = new DataSet();
        var objectSharedTables = new Streamline.UserBusinessServices.SharedTables();

        var _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
        if (_DataSetClientSummary != null)
            ClientPharmecieIds = _DataSetClientSummary.Tables["ClientPharmacies"].AsEnumerable().Select(x => x["PharmacyId"].ToString()).ToArray();

        DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
        //if (DataSetPharmacies != null && DataSetPharmacies.Tables[0].Rows.Count > 0)
        //{
        //    DataSetClientPharmecies.Merge(
        //        DataSetPharmacies.Tables[0].AsEnumerable()
        //                                   .Select(pharmacies => pharmacies)
        //                                   .Where(fax => fax["FaxNumber"].ToString().Length >= 7)
        //                                   .OrderBy(clientpharmacies => !ClientPharmecieIds.Contains(clientpharmacies["PharmacyId"].ToString()))
        //                                   .ThenBy(pharmacy => pharmacy["PharmacyName"]).CopyToDataTable());
        //}
        //else
        //{
        DataSetClientPharmecies = DataSetPharmacies;
        //}


        /* Adding a Temp column Fulladdress in DataSetClientPharmecies to save the Complete address by concadianting City,State and Address  */
        DataSetClientPharmecies.Tables[0].Columns.Add("Fulladdress", typeof(string));

        /* Variable Pharmacyarr which has been used to store the Pharmacy ids binded in the Type able dropdown */
        //string[] Pharmacyarr = new string[DataSetClientPharmecies.Tables[0].Rows.Count];

        string pharmacywithaddress = "";
        string pharmacyphonenumber = "";

        int pharmacylen = 0;
        int pharmacyspacing = 0;
        int maxpharmacylen = 0;
        int maxtemppharmacylen = 0;
        string pharmacyaddressforspacing = "";

        /* Loop to align the Phone number and ServiceLevel check of the pharmacy */
        for (int i = 0; i < DataSetClientPharmecies.Tables[0].Rows.Count; i++)
        {
            string SureScriptsPharmacyId = DataSetClientPharmecies.Tables[0].Rows[i]["SureScriptsPharmacyIdentifier"].ToString();
            if (SureScriptsPharmacyId != "")
            {
                pharmacywithaddress = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString();
            }
            else
            {
                pharmacywithaddress = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["Address"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["City"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["State"].ToString() + "," + DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString();
            }

            pharmacylen = pharmacywithaddress.Trim().Length;
            if (pharmacylen <= 100)
            {
                pharmacyspacing = (maxtemppharmacylen - pharmacylen) + 30;
            }

            bool EPCSCheck = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);    /* EPCS Permissions check for the user */
            int ServiceLevel = DataSetClientPharmecies.Tables[0].Rows[i]["ServiceLevel"].Equals(DBNull.Value) ? 0 : Convert.ToInt32(DataSetClientPharmecies.Tables[0].Rows[i]["ServiceLevel"]);  /* ServiceLevel check of the pharmacy */
            if (EPCSCheck == true)
            {
                if (ServiceLevel >= 2048)
                {
                    pharmacyphonenumber = DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString() + " - " + "EPCS";   /* Adding EPCS with PhoneNumber if it matches the service level */
                }
                else
                {
                    pharmacyphonenumber = "";
                }
            }
            else
            {
                pharmacyphonenumber = "";
            }
            DataSetClientPharmecies.Tables[0].Rows[i]["Fulladdress"] = pharmacywithaddress + pharmacyphonenumber;
        }

        /* Binding the Values to the Dropdown */
        DataTable DataTableClientPharmacies = null;
        DataTableClientPharmacies = DataSetClientPharmecies.Tables[0];
        return DataTableClientPharmacies;
    }


    public void RenderChangeRequestRow(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            try
            {
                string userCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ListViewDataItem item = (ListViewDataItem)e.Item;

                ((Label)e.Item.FindControl("ImageDenyLabel")).Attributes.Add("onclick", "openRefillDeniedReason(" + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + ", '" + userCode + "'"+",'CHANGE');");
                ((Label)e.Item.FindControl("ImageSearchLabel")).Attributes.Add("onclick", "ShowClientSearch('" + DataBinder.Eval(item.DataItem, "ClientId") + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientFirstName").ToString()) + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientLastName").ToString()) + "'," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + ", " + DataBinder.Eval(item.DataItem, "PrescriberId") + ");");

                Label age = (Label)e.Item.FindControl("ClientDOBAge");
                DateTime dob = (DateTime)DataBinder.Eval(item.DataItem, "ClientDOB");
                DateTime now = DateTime.Now;
                int years = (int)(now.Year - dob.Year);
                if (now < dob.AddYears(years)) years--;
                age.Text = "(" + years.ToString() + ")";

                var _clientid = DataBinder.Eval(item.DataItem, "ClientId");
                var _clientMedicationScriptDrugStrengthid = DataBinder.Eval(item.DataItem,"ClientMedicationScriptDrugStrengthId");
           //     var RequestedDrugDescription = DataBinder.Eval(item.DataItem,"RequestedDrugDescription");
                var DrugDescritpion = DataBinder.Eval(item.DataItem,"DrugDescription");
                var ChangeRequestType = DataBinder.Eval(item.DataItem,"ChangeRequestType");

                var _drugSchedule = DataBinder.Eval(item.DataItem, "DrugCategory");
                bool _isDrugSchedule2OrMissingClientDemographics = !_drugSchedule.ToString().IsNullOrWhiteSpace() && Convert.ToInt16(_drugSchedule) == 2;

                //firstname, lastname, ODB, Gender, Address line 1, city, state, zip, phone,
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientLastName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientFirstName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "PatientName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientAddress1").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientCity").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientState").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientZip").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientSex").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientDOB").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                //ClientLastName	ClientFirstName	PatientName	ClientMiddleName	ClientAddress1	ClientCity	ClientState	ClientZip	ClientPhone	ClientSex	ClientDOB


                string _imageApproved = "~/App_Themes/Includes/Images/disable_41.png";
                string _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";
                string _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/disable_45.png";
                Label _errorSpan = ((Label)e.Item.FindControl("ErrorSpan"));

                Int16[] _surescriptsServiceLevels =
                {
                        1, // New Rx
                        2, // Refill
                        16 // Cancel
                    };
                var _serviceLevel = Convert.ToInt16(DataBinder.Eval(item.DataItem, "ServiceLevel"));

                if (_serviceLevel > 0)
                {
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                    _errorSpan.Visible = true;

                    for (int i = 0; i < _surescriptsServiceLevels.Length; i++)
                    {
                        if ((_serviceLevel & _surescriptsServiceLevels[i]) == _surescriptsServiceLevels[i])
                        {
                            _errorSpan.Text = string.Empty;
                            _errorSpan.Visible = false;
                            break;
                        }
                    }

                    if ((_serviceLevel & 2) != 2)
                    {
                        _errorSpan.Text = "Prescriber not<br />allowed to refill";
                        _errorSpan.Visible = true;
                    }
                }
                else // No Surescripts
                {
                    _errorSpan.Visible = true;
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                }
                if (_clientid != System.DBNull.Value) // Enables Approve,ApproveWithChangesButton
                {
                    if ((_serviceLevel & 2) == 2)
                    {
                        _errorSpan.Visible = false;
                        if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics)
                        {
                            _imageApproved = "~/App_Themes/Includes/Images/enable_16.png";
                            _imageApprovedWithChanges = "~/App_Themes/Includes/Images/enable_18.png";
                        }
                        _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/enable_20.png";
                    }
                }
             //   if (RequestedDrugDescription.ToString().ToUpper() != DrugDescritpion.ToString().ToUpper())
             //   {
                    //_imageApproved = "~/App_Themes/Includes/Images/disable_41.png";
                
              //  }
                if (ChangeRequestType.ToString().ToUpper() == "P" )
                {
                     _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";
                
                }
                ((Image)e.Item.FindControl("ImageApproved")).ImageUrl = _imageApproved;
                ((Image)e.Item.FindControl("ImageApprovedWithChanges")).ImageUrl = _imageApprovedWithChanges;
                //((Image)e.Item.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = _imageDeniedNewPrescriptions;


                if (_clientid != System.DBNull.Value)
                {
                    string pharmacyId = Convert.ToString(DataBinder.Eval(item.DataItem, "PharmacyId"));
                    DataTable dataTablePharmacy;
                    string pharmacyFullName = CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "PharmacyFullName").ToString());
                    //if (!string.IsNullOrEmpty(pharmacyId))
                    //{
                    //    dataTablePharmacy = GetFullAddressForPharmacy();
                    //    IEnumerable<DataRow> pharmacy = dataTablePharmacy.AsEnumerable().Where(row => row["PharmacyId"].ToString() == pharmacyId);
                    //    if (pharmacy.Count() == 1)
                    //    {
                    //        pharmacyFullName = Convert.ToString(pharmacy.First()["Fulladdress"]);
                    //    }
                    //}

                  
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Attributes.Add("onclick",
                                                                                              "redirectToCurrentMedications(" +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "ClientId") + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsChangeRequestId") +
                                                                                              ");");


                    if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics )
                    {
                        if (ChangeRequestType.ToString().ToUpper() == "P")
                        {
                            ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonAuthorizeChangeOrderClick("+ DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId")+ ");");
                        }
                        else
                        {
                            ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonDashBoardChangeOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'CHANGEAPPROVALORDER'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'Approved'," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "NumberOfRefills").ToString())?"0":DataBinder.Eval(item.DataItem, "NumberOfRefills")) + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "NumberOfDaysSupply").ToString())?"0":DataBinder.Eval(item.DataItem, "NumberOfDaysSupply")) + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "PotencyUnitCode").ToString() + "');");
                            ((Label)e.Item.FindControl("ImageApprovedWithChangesLabel")).Attributes.Add("onclick", "ButtonDashBoardChangeOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'CHANGEAPPROVALORDER'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'ApprovedWithChanges'," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "NumberOfRefills").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "NumberOfRefills")) + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "NumberOfDaysSupply").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "NumberOfDaysSupply")) + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "PotencyUnitCode").ToString() + "');");
                        }
                    }
                }
                else
                {
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Visible = false;
                }

            }
            catch (Exception ex)
            {

            }
        }

    }
 
    public void RenderRefillRequestRow(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            try
            {
                string userCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ListViewDataItem item = (ListViewDataItem)e.Item;

                ((Label)e.Item.FindControl("ImageDenyLabel")).Attributes.Add("onclick", "openRefillDeniedReason(" + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + ", '" + userCode + "');");
                ((Label)e.Item.FindControl("ImageSearchLabel")).Attributes.Add("onclick", "ShowClientSearch('" + DataBinder.Eval(item.DataItem, "ClientId") + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientFirstName").ToString()) + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientLastName").ToString()) + "'," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + ", " + DataBinder.Eval(item.DataItem, "PrescriberId") + ");");

                Label age = (Label)e.Item.FindControl("ClientDOBAge");
                DateTime dob = (DateTime)DataBinder.Eval(item.DataItem, "ClientDOB");
                DateTime now = DateTime.Now;
                int years = (int)(now.Year - dob.Year);
                if (now < dob.AddYears(years)) years--;
                age.Text = "(" + years.ToString() + ")";

                var _clientid = DataBinder.Eval(item.DataItem, "ClientId");
                var _clientMedicationScriptDrugStrengthid = DataBinder.Eval(item.DataItem,
                                                                            "ClientMedicationScriptDrugStrengthId");
                var _drugSchedule = DataBinder.Eval(item.DataItem, "DrugCategory");
                bool _isDrugSchedule2OrMissingClientDemographics = !_drugSchedule.ToString().IsNullOrWhiteSpace() && Convert.ToInt16(_drugSchedule) == 2;

                //firstname, lastname, ODB, Gender, Address line 1, city, state, zip, phone,
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientLastName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientFirstName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "PatientName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientAddress1").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientCity").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientState").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientZip").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientSex").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientDOB").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                //ClientLastName	ClientFirstName	PatientName	ClientMiddleName	ClientAddress1	ClientCity	ClientState	ClientZip	ClientPhone	ClientSex	ClientDOB


                string _imageApproved = "~/App_Themes/Includes/Images/disable_41.png";
                string _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";
                string _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/disable_45.png";
                Label _errorSpan = ((Label)e.Item.FindControl("ErrorSpan"));

                Int16[] _surescriptsServiceLevels =
                {
                        1, // New Rx
                        2, // Refill
                        16 // Cancel
                    };
                var _serviceLevel = Convert.ToInt16(DataBinder.Eval(item.DataItem, "ServiceLevel"));

                if (_serviceLevel > 0)
                {
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                    _errorSpan.Visible = true;

                    for (int i = 0; i < _surescriptsServiceLevels.Length; i++)
                    {
                        if ((_serviceLevel & _surescriptsServiceLevels[i]) == _surescriptsServiceLevels[i])
                        {
                            _errorSpan.Text = string.Empty;
                            _errorSpan.Visible = false;
                            break;
                        }
                    }

                    if ((_serviceLevel & 2) != 2)
                    {
                        _errorSpan.Text = "Prescriber not<br />allowed to refill";
                        _errorSpan.Visible = true;
                    }
                }
                else // No Surescripts
                {
                    _errorSpan.Visible = true;
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                }
                if (_clientid != System.DBNull.Value)
                {
                    if ((_serviceLevel & 2) == 2)
                    {
                        _errorSpan.Visible = false;
                        if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics)
                        {
                            _imageApproved = "~/App_Themes/Includes/Images/enable_16.png";
                            _imageApprovedWithChanges = "~/App_Themes/Includes/Images/enable_18.png";
                        }
                            _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/enable_20.png";
                    }
                }
                ((Image)e.Item.FindControl("ImageApproved")).ImageUrl = _imageApproved;
                ((Image)e.Item.FindControl("ImageApprovedWithChanges")).ImageUrl = _imageApprovedWithChanges;
                ((Image)e.Item.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = _imageDeniedNewPrescriptions;


                if (_clientid != System.DBNull.Value)
                {
                    string pharmacyId = Convert.ToString(DataBinder.Eval(item.DataItem, "PharmacyId"));
                    DataTable dataTablePharmacy;
                    string pharmacyFullName = CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "PharmacyFullName").ToString());
                    //if (!string.IsNullOrEmpty(pharmacyId))
                    //{
                    //    dataTablePharmacy = GetFullAddressForPharmacy();
                    //    IEnumerable<DataRow> pharmacy = dataTablePharmacy.AsEnumerable().Where(row => row["PharmacyId"].ToString() == pharmacyId);
                    //    if (pharmacy.Count() == 1)
                    //    {
                    //        pharmacyFullName = Convert.ToString(pharmacy.First()["Fulladdress"]);
                    //    }
                    //}

                    ((Label)e.Item.FindControl("ImageDeniedNewPrescriptionsLabel")).Attributes.Add("onclick",
                                                                                                    "redirectToOrderPageFromDenialScreen(" +
                                                                                                    DataBinder.Eval(
                                                                                                        item.DataItem,
                                                                                                        "ClientId")
                                                                                                        + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsRefillRequestId") +
                                                                                                    "," +
                                                                                                    DataBinder.Eval(
                                                                                                        item.DataItem,
                                                                                                        "PharmacyId") +
                                                                                                    ",'" +
                                                                                                   pharmacyFullName +
                                                                                                    "'," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" +
                                                                                                    userCode + "');");
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Attributes.Add("onclick",
                                                                                              "redirectToCurrentMedications(" +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "ClientId") + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsRefillRequestId") +
                                                                                              ");");
          

                    if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics)
                    {
                        ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'Refill'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'Approved'," + DataBinder.Eval(item.DataItem, "DispensedNumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedNumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DispensedDrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DispensedDrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "DispensedPotencyUnitCode").ToString() + "');");
                        ((Label)e.Item.FindControl("ImageApprovedWithChangesLabel")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'Refill'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'ApprovedWithChanges'," + DataBinder.Eval(item.DataItem, "DispensedNumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedNumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DispensedDrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DispensedDrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "DispensedPotencyUnitCode").ToString() + "');");
                    }
                }
                else
                {
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Visible = false;
                }

            }
            catch (Exception ex)
            {

            }
        }

    }

}
