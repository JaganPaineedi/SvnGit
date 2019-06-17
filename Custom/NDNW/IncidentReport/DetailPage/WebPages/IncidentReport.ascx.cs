using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Linq;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Text;
using System.Data;

namespace SHS.SmartCare
{
    public partial class Custom_IncidentReport_WebPages_IncidentReport : SHS.BaseLayer.ActivityPages.DataActivityMultiTabPage
    {
        List<CustomParameters> _customValidationStoreProcedureUpdateParameters = null;
        List<CustomParameters> _corePostUpdateStoreProcedureParameters = null;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override string DefaultTab
        {
            get { return "Custom/IncidentReport/DetailPage/WebPages/Incident.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
        }
        public override string PostUpdateScreenStoredProcedureCore
        {
            get
            {
                return "csp_SCPostUpdateIncidentReport";
            }
           
        }
        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RadMultiPage1.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];
        }

        public override void BindControls()
        {
            if (!string.IsNullOrEmpty(BaseCommonFunctions.ApplicationInfo.LoggedInUser.LastName) && !string.IsNullOrEmpty(BaseCommonFunctions.ApplicationInfo.LoggedInUser.FirstName))
                HiddenField_LoggedInUserName.Value = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LastName + ", " + BaseCommonFunctions.ApplicationInfo.LoggedInUser.FirstName;
            else
                HiddenField_LoggedInUserName.Value = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserName;
        }

        public override string PageDataSetName
        {
            get { return "DataSetIncidentReport"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomIncidentReports", "CustomIncidentReportGenerals", "CustomIncidentReportDetails", "CustomIncidentReportFollowUpOfIndividualStatuses", "CustomIncidentReportSupervisorFollowUps", "CustomIncidentReportAdministratorReviews", "CustomIncidentReportFallDetails", "CustomIncidentReportFallFollowUpOfIndividualStatuses", "CustomIncidentReportFallSupervisorFollowUps", "CustomIncidentReportFallAdministratorReviews", "CustomIncidentReportSeizureDetails", "CustomIncidentSeizureDetails", "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "CustomIncidentReportSeizureSupervisorFollowUps", "CustomIncidentReportSeizureAdministratorReviews", "CustomIncidentReportManagerFollowUps", "CustomIncidentReportFallManagerFollowUps", "CustomIncidentReportSeizureManagerFollowUps" }; }
        }

        public override string[] TablesNameForGetData
        {
            get { return new string[] { "CustomIncidentReports", "CustomIncidentReportGenerals", "CustomIncidentReportDetails", "CustomIncidentReportFollowUpOfIndividualStatuses", "CustomIncidentReportSupervisorFollowUps", "CustomIncidentReportAdministratorReviews", "CustomIncidentReportFallDetails", "CustomIncidentReportFallFollowUpOfIndividualStatuses", "CustomIncidentReportFallSupervisorFollowUps", "CustomIncidentReportFallAdministratorReviews", "CustomIncidentReportSeizureDetails", "CustomIncidentReportSeizures", "CustomIncidentSeizureDetails", "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "CustomIncidentReportSeizureSupervisorFollowUps", "CustomIncidentReportSeizureAdministratorReviews", "CustomIncidentReportManagerFollowUps", "CustomIncidentReportFallManagerFollowUps", "CustomIncidentReportSeizureManagerFollowUps" }; }
        }

        public override string GetStoreProcedureName
        {
            get
            {
                return "csp_GetIncidentReport";
            }
        }
        public override string DetailPageViewModeRDL
        {
            get
            {
                return "RDLIncidentReport";
            }           
        }

        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
             if (dataSetObject.Tables["CustomIncidentReportSeizures"].Rows.Count > 0)
            {
                for (int i = 0; i < dataSetObject.Tables["CustomIncidentReportSeizures"].Rows.Count; i++)
                {
                    if (Convert.ToInt32(dataSetObject.Tables["CustomIncidentReportSeizures"].Rows[i]["IncidentReportSeizureDetailId"].ToString()) == -1)
                    {
                        dataSetObject.Tables["CustomIncidentReportSeizures"].Rows[i]["IncidentReportSeizureDetailId"] = dataSetObject.Tables["CustomIncidentReportSeizureDetails"].Rows[0]["IncidentReportSeizureDetailId"];
                    }
                }

            }

             //if (dataSetObject.Tables["CustomIncidentReports"].Rows.Count > 0)
             //{
             //    dataSetObject.Tables["CustomIncidentReports"].Rows[0]["ClientId"] = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReports"].Rows[0]["ClientId"];
             //}
        }
        public override List<CustomParameters> CorePostUpdateStoreProcedureParameters
        {
            get
            {
                if (_corePostUpdateStoreProcedureParameters == null)
                {
                    string ButtonClicked = GetRequestParameterValue("ButtonClicked");
                    _corePostUpdateStoreProcedureParameters = new List<CustomParameters>();
                    _corePostUpdateStoreProcedureParameters.Add(new CustomParameters("ButtonClicked", ButtonClicked));
                }
                return _corePostUpdateStoreProcedureParameters;
            }
        }
        public override List<CustomParameters> customValidationStoreProcedureUpdateParameters
        {
            get
            {
                if (_customValidationStoreProcedureUpdateParameters == null)
                {
                    string ButtonClicked = GetRequestParameterValue("ButtonClicked");
                    _customValidationStoreProcedureUpdateParameters = new List<CustomParameters>();
                    _customValidationStoreProcedureUpdateParameters.Add(new CustomParameters("ButtonClicked", ButtonClicked));
                }
                return _customValidationStoreProcedureUpdateParameters;
            }
        }

        public override System.Data.SqlClient.SqlParameter[] SqlParameterForGetData
        {
            get
            {
                int IncidentReportId = -1;
                if (!string.IsNullOrEmpty(base.GetRequestParameterValue("IncidentReportId")))
                {
                    int.TryParse(base.GetRequestParameterValue("IncidentReportId"), out IncidentReportId);

                }
                else // Get AuthorizationcodeId after save
                {
                    if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet != null)
                    {
                        if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReports"].Rows[0]["IncidentReportId"] != null)
                        {
                            int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReports"].Rows[0]["IncidentReportId"].ToString(), out IncidentReportId);
                        }
                    }
                }
                System.Data.SqlClient.SqlParameter[] parameters = new System.Data.SqlClient.SqlParameter[1];
                //parameters[0] = new System.Data.SqlClient.SqlParameter("@ClientID", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                parameters[0] = new System.Data.SqlClient.SqlParameter("@IncidentReportId", IncidentReportId);

                return parameters;
            }
        }
    }
}