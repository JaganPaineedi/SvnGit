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


public partial class ValidateToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        DataSet dsStaff = null;
        try
        {
            CommonFunctions.Event_Trap(this);
            string Token = "";//Request.QueryString["Token"].ToString();
            int ClientId = 0; //Convert.ToInt32(Request.QueryString["ClientId"].ToString());            
            if (Request.QueryString["Token"] != null)
            {
                Token = Request.QueryString["Token"].ToString();
                CommonFunctions.DisposeMMApplicationSessions(true);//Adeed by Pradeepas per task#3323
            }
            else
            {
                CommonFunctions.DisposeMMApplicationSessions(false);//Call this function as per task#3323
                // Token = "9F92FBF4-4C7B-4E3B-9BAD-B56F4D2E43BA";
                // Token = "077F549F-21C3-4CBF-94DC-E8B8E40AE4B5";
                Token = "5F23AA2B-402D-4D02-8163-89B49C2E46EE";
            }
            if (Request.QueryString["ClientId"] != null)
            {
                ClientId = Convert.ToInt32(Request.QueryString["ClientId"].ToString());
            }
            else
            {
                ClientId = 0;
            }
            
            dsStaff = new DataSet();
            Streamline.SmartClient.UserInfo objuser = new Streamline.SmartClient.UserInfo();
            //dsStaff = objuser.ValidateToken(Token);          

            if (Request.QueryString["StaffId"] != null && Request.QueryString["StaffId"].ToString() != "")
            {
                dsStaff = objuser.StaffDetail(Convert.ToInt32(Request.QueryString["StaffId"]));
            }
            else
            {
                dsStaff = objuser.ValidateToken(Token);
            }            
            
            if (dsStaff.Tables.Count > 0)
            {
                StreamlinePrinciple newUser = new StreamlinePrinciple(dsStaff.Tables["Staff"].Rows[0]);
                Session["UserContext"] = newUser;
                Context.User = newUser;
                FormsAuthentication.SetAuthCookie(dsStaff.Tables["Staff"].Rows[0]["UserCode"].ToString(), false);
                ApplicationCommonFunctions.ClientId = Convert.ToInt32(Request.QueryString["ClientId"].ToString());
                ApplicationCommonFunctions.loggedUserName = ((StreamlineIdentity)(Context.User.Identity)).UserCode;
                //---Start Code Added by Pradeep as per task#2640
                ApplicationCommonFunctions.defaultPrescribingQuantity = dsStaff.Tables["Staff"].Rows[0]["DefaultPrescribingQuantity"] == DBNull.Value ? "" : Convert.ToString(dsStaff.Tables["Staff"].Rows[0]["DefaultPrescribingQuantity"]);
                //---End Code Added by Pradeep as per task#2640
                //((streamlineidentity)(context.user.identity)).userCode
                //Added by Chandan on 20th Jan 2010 with Ref Task#2797
                ApplicationCommonFunctions.AllowRePrintFax = dsStaff.Tables["Staff"].Rows[0]["AllowRePrintFax"] == DBNull.Value ? "N" : Convert.ToString(dsStaff.Tables["Staff"].Rows[0]["AllowRePrintFax"]);
                
                if (Request.QueryString["Token"] != null)
                {
                    Session["CurrentControl"] = "~/UserControls/MedicationMgt.ascx";
                    Session["ActiveTab"] = null;
                    switch (Request.QueryString["OpenScreen"])
                    {
                        case "HealthData":
                            Session["ActiveTab"] = "1"; // Health data tab   
                            break;
                        case "AddMedication":
                            Session["CurrentControl"] = "~/UserControls/ClientMedicationNonOrder.ascx"; // Add Medication
                            break;
                        case "MedicationReport":
                            Session["CurrentControl"] = "~/UserControls/ViewHistory.ascx"; // Medication History 
                            break;
                        case "StartPage":
                            //Added by Malathi.S on 13 July 2016 WRT  Camino - Environment Issues Tracking: 311 - From My Office, We should be able to open Rx Medication Pop up and should be redirected to the Start Page
                            Session["CurrentControl"] = "~/UserControls/ClientList.ascx"; // Start Page 
                            break;
                        case "VerbalOrQueuedPage":
                            //Added by Anto on 18 July 2016 Camino - Environment Issues Tracking: 312 - From Verbal/ Queued Orders Dashboard Widget We should be able to open Rx Medication Pop up and should be redirect to the Approval Page
                            Session["CurrentControl"] = "~/UserControls/VerbalOrdersReview.ascx"; // Verbal / Queued Order Page 
                            Session["OpenVerbalOrder"] = Request.QueryString["OrderType"];
                            break;
                    }
                    
                    SureScriptRefillRequest objSureScriptRefillRequest = new SureScriptRefillRequest();
                    DataSet dsSureScriptRefillRequest = objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, 0);
                    Session["DataSetSureScriptRequestRefill"] = null;
                    Session["DataSetSureScriptRequestRefill"] = dsSureScriptRefillRequest;
                }
                else
                {
                    if(ClientId==0)
                        Session["CurrentControl"] = "~/UserControls/ClientList.ascx";
                    else
                        Session["CurrentControl"] = "~/UserControls/MedicationMgt.ascx";
                }
                Session["LoadMgt"] = true;
                Session["SessionTimeout"] = "N";

                // For SC Refill/Reject widget functionality
                if (Request.QueryString["SurescriptsRefillRequestResponse"] != null)
                {
                    Session["SurescriptsRefillRequestResponse"] =
                        Request.QueryString["SurescriptsRefillRequestResponse"];
                }

                if (ClientId == 0 && Request.QueryString["Token"] == null)
                    Response.Redirect("ApplicationForm.aspx", false);
                    //ClientScript.RegisterClientScriptBlock(this.GetType(), "NewWindow", "CloseWindow();", true);
                else if (ClientId != 0 && Request.QueryString["Token"] != null)
                    //ClientScript.RegisterClientScriptBlock(this.GetType(), "NewWindow", "CloseWindow();", true);
                    Response.Redirect("ApplicationForm.aspx", false);
                else
                    Response.Redirect("ApplicationForm.aspx", false);
                
            }
            //User objUser =new User();
            //dsStaff = 
        

        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = null;
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = dsStaff;
            
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {

        }




    }
}
