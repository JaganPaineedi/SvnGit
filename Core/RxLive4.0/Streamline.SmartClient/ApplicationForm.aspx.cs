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


namespace Streamline.SmartClient
{
    public partial class ApplicationForm : Streamline.BaseLayer.ActivityPages.ActivityPage
    {
        private Control CurrentlyLoadedControl = null;
        protected override void Page_Load(object sender, EventArgs e)
        {

            if (Session["SessionTimeout"] != null)
            {
                //Title Changed by Sonia
                //Ref Task #184
                this.Title = "Streamline Medication Management";
            }
            else
            {
                Response.Redirect("MedicationLogin.aspx?SessionExpires='yes'");
            }

            //Added by Loveena in ref to task#2378 - CopyrightInfo      
            if (Session["UserContext"] != null)
                LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
            //Added in ref to Task#2895
            LabelReleaseVersion.Text = "5.0";
            //Start Added By pradeep as per task#2640
            this.HiddenDefaultPrescribingQuantity.Value = ApplicationCommonFunctions.defaultPrescribingQuantity;
            //End Added By pradeep as per task#2640

            // To handle entrance via the Refill/Reject widget in SC
            if (Session["SurescriptsRefillRequestResponse"] != null)
            {
                var responseString = Session["SurescriptsRefillRequestResponse"].ToString();
                var responseAction = responseString.Substring(0,
                                                              responseString.IndexOf("$",
                                                                                     System.StringComparison.Ordinal));
                var medicationId = responseString.Substring(responseString.IndexOf("$",
                                                                                                 System
                                                                                                     .StringComparison
                                                                                                     .Ordinal) + 1);
                if (responseAction == "ApproveRRWithChange")
                {
                    HiddenFieldSurescriptsRefillRequestMedicationId.Value = medicationId;
                }

                Session["SurescriptsRefillRequestResponse"] = null;
            }
          
        }

        protected override void Page_Init(object sender, EventArgs e)
        {

            try
            {
                if (Session["SessionTimeout"] != null)
                {
                    base.Page_Init(sender, e);
                    CommonFunctions.Event_Trap(this);
                    if (Session["CurrentControl"] != null)
                    {
                        if ((Request.Form["HiddenControlPath"] != null) && (Session["CurrentControl"].ToString() != Request.Form["HiddenControlPath"].ToString()))
                        {
                            if (Session["CurrentControl"].ToString() == "~/UserControls/ClientList.ascx")
                                LoadControls(Session["CurrentControl"].ToString(), false);
                            else if (Session["InitializeClient"] != null) // == "~/UserControls/MedicationMgt.ascx") && (Session["ClientIdForValidateToken"].ToString() != "") && ((Session["CurrentControl"].ToString() != Request.Form["HiddenControlPath"].ToString()) && (Session["LoadMgt"].ToString()=="True")))
                            {
                                if (Session["InitializeClient"].ToString() == "True")
                                {
                                    Session["InitializeClient"] = false;
                                    Response.Redirect("ValidateToken.aspx?ClientId=" + Convert.ToInt32(Session["ClientIdForValidateToken"].ToString()) + " &StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, false);
                                }
                                else
                                    LoadControls(Session["CurrentControl"].ToString(), false);
                            }
                            else
                                LoadControls(Session["CurrentControl"].ToString(), false);
                        }
                        else
                        {
                            LoadControls(Session["CurrentControl"].ToString(), false);
                            Session["InitializeClient"] = false;
                        }
                    }
                    else
                    {
                        LoadControls(Session["CurrentControl"].ToString(), false);
                    }
                    if (CurrentlyLoadedControl != null)
                    {
                        PlaceHolderMain.Controls.Clear();
                        PlaceHolderMain.Controls.Add(CurrentlyLoadedControl);
                    }

                }
                else
                {
                    Response.Redirect("MedicationLogin.aspx?SessionExpires='yes'");
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
            finally
            {

            }



        }


        protected void lnkTest_Click(object sender, EventArgs e)
        {
            if (HiddenPageName.Value == "FromDashBoard")
            {
                LoadControls("~/UserControls/VerbalOrdersReview.ascx", true);
                Session["CurrentControl"] = "~/UserControls/VerbalOrdersReview.ascx";
                HiddenControlPath.Value = "~/UserControls/VerbalOrdersReview.ascx";
            }
            else
            {
                LoadControls("~/UserControls/MedicationMgt.ascx", true);
                Session["DataSetPrescribedClientMedications"] = null;
                Session["medicationIdList"] = null;
                Session["PatientAlreadySignedDocument"] = null;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationScriptId = -1;
            }




        }
        //Added by chandan task#2604 
        protected void LinkButtonPrescriptionReview_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/PrescriptionReview.ascx", true);
        }

        protected void lnkClientMedicationOrder_Click(object sender, EventArgs e)
        {
            Session["DataSetClientMedications"] = null;
            Session["IsDirty"] = false;
            LoadControls("~/UserControls/ClientMedicationOrder.ascx", true);
            //ScriptManager1.Scripts.Add(sr);            
        }

        protected void lnkClientMedicationNonOrder_Click(object sender, EventArgs e)
        {
            //Code added by Loveena in ref to Task#3273-2.6.1 Non-Ordered Medications: Allow Changes.
            if (txtButtonValue.Value == "Add Medication")
                Session["DataSetClientMedications"] = null;
            Session["IsDirty"] = false;
            LoadControls("~/UserControls/ClientMedicationNonOrder.ascx", true);
            //ScriptManager1.Scripts.Add(sr);            
        }
        //Added by Loveena to in Ref to Task#23
        protected void LinkButtonPrinterDevice_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/PrinterDevice.ascx", true);
        }
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            ScriptReference sr = new ScriptReference("~/App_Themes/Includes/JS/Test.js?rel=3_5_x_4_1");
            LoadControls("~/UserControls/Test.ascx", true);
            ScriptManager1.Scripts.Add(sr);
        }
        //Task#3
        protected void LinkButtonverbalOrder_Click(object sender, EventArgs e)
        {
            Session["IsDirty"] = false;
            LoadControls("~/UserControls/VerbalOrdersReview.ascx", true);
            //Session["ScriptId"] = HiddenFieldScriptId.Value;      
        }
        public override void LoadControls(string ControlPath, bool ActivateControl)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                if (PlaceHolderMain.Controls[0].AppRelativeTemplateSourceDirectory != ControlPath)
                {
                    PlaceHolderMain.Controls.Clear();
                    CurrentlyLoadedControl = this.Page.LoadControl(ControlPath);
                    CurrentlyLoadedControl.ID = "Control_" + CurrentlyLoadedControl.ToString();
                    CurrentlyLoadedControl.AppRelativeTemplateSourceDirectory = ControlPath;
                    Session["CurrentControl"] = ControlPath;
                    PlaceHolderMain.Controls.Add(CurrentlyLoadedControl);
                    if (ActivateControl == true || Session["LoadMgt"] != null)
                    {
                        Session["LoadMgt"] = null;
                        ((BaseActivityPage)CurrentlyLoadedControl).Activate();
                    }
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "LoadControls";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        protected void lnkRefresh_Click(object sender, EventArgs e)
        {
            Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
            try
            {
                string msg = "refresh";
                if (PlaceHolderMain.Controls.Count > 0)
                {
                    Control ctrl = PlaceHolderMain.Controls[0];
                    ((Streamline.BaseLayer.BaseActivityPage)ctrl).RefreshPage();
                }
                // Code that runs on application startup
                objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
                objectSharedTables.getSharedTablesData();
                objectSharedTables.getStaffClientsData(((StreamlineIdentity)Context.User.Identity).UserId);
            }
            catch (Exception ex)
            {
            }
            finally
            {
                objectSharedTables = null;
            }

        }
        protected void Prescribe_Click(object sender, EventArgs e)
        {
            Session["IsDirty"] = false;
            HiddenFieldPharmacyId.Value = "";
            //added by Priya Ref:task no:85
            HiddenFieldGetAllPharmacy.Value = "";
            LoadControls("~/UserControls/MedicationsPrescribe.ascx", true);
            //ScriptManager1.Scripts.Add(sr); 
        }
        protected void lnkClientMedOrder_Click(object sender, EventArgs e)
        {

            LoadControls("~/UserControls/ClientMedicationOrder.ascx", true);
            //ScriptManager1.Scripts.Add(sr);         
        }
        protected void lnkOrderDetails_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/MedicationOrderDetails.ascx", true);
        }
        //Added by Loveena in ref to Task#2498 View History - It should not be a pop-up.
        protected void LinkButtonViewHistory_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/ViewHistory.ascx", true);
        }
        //Added by Pradeep in ref to Task#16 (Venture)
        protected void LinkButtonPatientConsentHistory_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/PatientConsentHistory.ascx", true);
        }
        protected void lnkPatientContent_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/MadicationPatientContent.ascx", true);
        }
        //Added by Loveena to Load Start Page on 26-March-2009
        protected void LinkButtonUserManagementClose_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/ClientList.ascx", true);
        }
        //Added by Loveena to Load User Management Page on 26-March-2009
        protected void LinkButtonUserManagement_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/UserManagement.ascx", true);
        }
        //Added by Loveena to Load User Preferences Page on 27-March-2009
        protected void LinkButtonUserPreferences_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/UserPreferences.ascx", true);
        }
        //Added by Loveena to Load User Preferences Page on 27-March-2009
        protected void LinkButtonPharmacyManagement_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/PharmacyManagement.ascx", true);
        }
        protected void lnkLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        protected void lnkPatientContentDetail_Click(object sender, EventArgs e)
        {
            LoadControls("~/UserControls/PatientConsentDetail.ascx", true);
        }

        protected void LinkButtonRefreshMgt_Click(object sender, EventArgs e)
        {
            try
            {
                string msg = "refresh";
                if (PlaceHolderMain.Controls.Count > 0)
                {
                    Control ctrl = PlaceHolderMain.Controls[0];
                    if (ctrl.GetType() == typeof(Streamline.BaseLayer.BaseActivityPage))
                    {
                        ((Streamline.BaseLayer.BaseActivityPage)ctrl).RefreshPage();
                    }
                }

            }
            catch (Exception ex)
            {
            }
            finally
            {

            }
        }

        protected void SetIdentityInformation(int ClintId, int StaffId)
        {
            try
            {
                DataSet dsStaff = new DataSet();
                Streamline.SmartClient.UserInfo objuser = new Streamline.SmartClient.UserInfo();
                if (StaffId != 0)
                {
                    dsStaff = objuser.StaffDetail(StaffId);
                }


                if (dsStaff.Tables.Count > 0)
                {
                    ApplicationCommonFunctions.ClientId = ClintId;
                    StreamlinePrinciple newUser = new StreamlinePrinciple(dsStaff.Tables["Staff"].Rows[0], ClintId);
                    Session["UserContext"] = newUser;
                    Context.User = newUser;
                    FormsAuthentication.SetAuthCookie(dsStaff.Tables["Staff"].Rows[0]["UserCode"].ToString(), false);
                    //ApplicationCommonFunctions.ClientId = Convert.ToInt32(Request.QueryString["ClientId"].ToString());
                    ApplicationCommonFunctions.loggedUserName = ((StreamlineIdentity)(Context.User.Identity)).UserCode;


                    Session["CurrentControl"] = "~/UserControls/MedicationMgt.ascx";
                    Session["LoadMgt"] = true;
                    Session["SessionTimeout"] = "N";


                }
            }
            catch (Exception ex)
            {

            }
        }

    }
}
//Commented by Sony
//Added by Sonia