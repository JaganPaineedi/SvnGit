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
namespace Streamline.SmartClient
{
    public partial class HealthMaintenanceAlertPopup : Streamline.BaseLayer.ActivityPages.ActivityPage
    {
        public int i = 0;
        public string CalledFrom;
        public bool _IsClose = false;
        public int m_iRowIdx = 0;
        DataTable dtHMTemplateCriteriaDetails = null;
        private DataSet dsHealthDataAlerts;
        public string RelativePath;

        protected override void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["AjaxAction"] == "saveHMTemplateUserDecisions")
            {
                string acceptedKeys = Request.QueryString["AcceptedKeys"].ToString();
                string rejectedKeys = Request.QueryString["RejectedKeys"].ToString();
                string clientIdStr = Request.QueryString["ClientId"].ToString();
                int clientId = 0;
                if (clientIdStr != null && clientIdStr != "")
                {
                    clientId = Convert.ToInt32(clientIdStr);
                }
                using (Streamline.UserBusinessServices.HealthMaintenanceTemplate HealthMaintenanceObj = new Streamline.UserBusinessServices.HealthMaintenanceTemplate())
                {
                    string pendingAlertCount = "";
                    DataSet dataSetObj = HealthMaintenanceObj.SaveHealthMaintenaceUserDecisions(acceptedKeys, rejectedKeys, clientId);
                    if (dataSetObj != null && dataSetObj.Tables.Count > 0)
                    {
                        if (dataSetObj.Tables[0] != null && dataSetObj.Tables[0].Rows.Count > 0)
                        {
                            pendingAlertCount = dataSetObj.Tables[0].Rows[0][0].ToString();
                        }
                    }
                    Response.Clear();
                    Response.Write(pendingAlertCount);
                    Response.End();
                }
            }
            if (Request.QueryString["AjaxAction"] == "HealthMaintenanceAlertCheck")
            {
                string CheckAlert = "true";
                int CheckClientID = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

                string retValue = HealthMaintenanceAlertCheck(CheckAlert, CheckClientID);
                Response.Write(retValue);
                Response.End();
            }

            try
            {
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                if (Session["UserContext"] != null)
                    LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
                if (Page.IsPostBack == false)
                {
                    try
                    {
                        bindTemplateGrid();

                    }
                    catch (Exception ex)
                    {

                        ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + ex.Message.ToString() + "', true);", true);
                    }
                }
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

                string ParseMessage = ex.Message;
                if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
                {
                    int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                    ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                    //  ShowError(ParseMessage, true);
                }
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + ex.Message.ToString() + "', true);", true);
            }
        }


        public string HealthMaintenanceAlertCheck(string checkAlert, int clientID)
        {
            string retValue = "failed";
            if (checkAlert != null && checkAlert == "true" && clientID >= 0)
            {
                int staffID = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                using (Streamline.UserBusinessServices.HealthMaintenanceTemplate objHealthMaintenanceTemplate = new Streamline.UserBusinessServices.HealthMaintenanceTemplate())
                {
                    DataSet ds = objHealthMaintenanceTemplate.HealthMaintenanceAlertCheck(clientID, staffID);
                    if (ds != null && ds.Tables.Count > 0)
                    {
                        if ((ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0) || clientID == 0)
                        {
                            retValue = "success";
                        }
                        if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        {
                            retValue += "|;" + Convert.ToString(ds.Tables[2].Rows[0][0]);
                        }
                    }
                }
            }
            return retValue;
        }

        private string InitHealthMaintenanceAlertCheck()
        {
            string _details = "";
            int staffID = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
            using (Streamline.UserBusinessServices.HealthMaintenanceTemplate objHealthMaintenanceTemplate = new Streamline.UserBusinessServices.HealthMaintenanceTemplate())
            {
                DataSet ds = objHealthMaintenanceTemplate.InitHealthMaintenanceAlertCheck(staffID);
                if (ds != null && ds.Tables.Count > 0)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        _details = Convert.ToString(ds.Tables[0].Rows[0][0]);
                    }
                }
            }

            return _details;

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }


        public void bindTemplateGrid()
        {
            int StaffId = 0, ClientId = 0;

            StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            try
            {
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                dsHealthDataAlerts = objectClientMedications.GetHealthMaintenaceAlertData(ClientId, StaffId);
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
                objectClientMedications = null;
            }

            if (dsHealthDataAlerts != null && dsHealthDataAlerts.Tables.Count > 0)
            {
                if (dsHealthDataAlerts.Tables["HMTemplateDetails"] != null && dsHealthDataAlerts.Tables["HMTemplateDetails"].Rows.Count > 0)
                {
                    if (dsHealthDataAlerts.Tables["HMCriteriaDetails"] != null && dsHealthDataAlerts.Tables["HMCriteriaDetails"].Rows.Count > 0)
                    {
                        dtHMTemplateCriteriaDetails = dsHealthDataAlerts.Tables["HMCriteriaDetails"];
                    }
                    divHMTemplateAndCriteriaRepeater.DataSource = dsHealthDataAlerts.Tables["HMTemplateDetails"];
                    divHMTemplateAndCriteriaRepeater.DataBind();
                    dtHMTemplateCriteriaDetails = null;

                    string clientStr = dsHealthDataAlerts.Tables["HMTemplateDetails"].Rows[0]["ClientName"].ToString() + " (" + dsHealthDataAlerts.Tables["HMTemplateDetails"].Rows[0]["ClientID"].ToString() + ")";
                    hiddenClientName.Value = clientStr;
                    hiddenClientId.Value = dsHealthDataAlerts.Tables["HMTemplateDetails"].Rows[0]["ClientID"].ToString();
                }
                if (dsHealthDataAlerts.Tables["HMAlertCount"] != null && dsHealthDataAlerts.Tables["HMAlertCount"].Rows.Count > 0)
                {
                    hiddenAlertCount.Value = dsHealthDataAlerts.Tables["HMAlertCount"].Rows[0][0].ToString();
                }
            }
        }

        public string getHMTemplateDescription(object templName, object factorGrpNameLst)
        {
            string retValue = "";
            string templateName = Convert.ToString(templName);
            string factorGroupNameList = Convert.ToString(factorGrpNameLst);

            if (!string.IsNullOrEmpty(templateName) && !string.IsNullOrEmpty(factorGroupNameList))
            {
                retValue = "Template '" + templateName + "' got matched against factor group(s) '" + factorGroupNameList + "'";
            }

            return retValue;
        }
        public string getHMTemplateCriteriaDetails(object HealthMaintenanceTemplateId)
        {
            RelativePath = Page.ResolveUrl("~/");
            string retValue = "";
            DataTable dtHMTemplateCriteria = dtHMTemplateCriteriaDetails;

            if (dtHMTemplateCriteria != null && dtHMTemplateCriteria.Rows.Count > 0)
            {
                DataView dvTemplateCriteria = new DataView(dtHMTemplateCriteria);
                dvTemplateCriteria.RowFilter = "HealthMaintenanceTemplateId=" + HealthMaintenanceTemplateId.ToString();

                foreach (DataRowView dr in dvTemplateCriteria)
                {
                    if (retValue == "")
                    {
                        retValue = "<ul>";
                    }
                    retValue += " <li style='list-style: circle none inside;padding-bottom:1px'> Order '" + dr.Row["OrderName"] + "' - " + dr.Row["CriteriaDescription"] + "  <img onclick=\" window.open('EducationInformationView.aspx?Type=LOINC&LOINCCode=" + dr.Row["LoincCode"] + "')\";  src ='" + RelativePath + "App_Themes/Includes/Images/Educationinfo.png' /> </li>";
                }

                if (retValue != "")
                {
                    retValue += "</ul>";
                }

            }
            return retValue;
        }
    }


}