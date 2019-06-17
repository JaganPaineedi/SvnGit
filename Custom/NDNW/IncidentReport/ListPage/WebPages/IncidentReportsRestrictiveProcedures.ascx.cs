using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Data;
using SHS.BaseLayer.ActivityPages;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
namespace SHS.SmartCare
{

    public partial class IncidentReportsRestrictiveProcedures : SHS.BaseLayer.ActivityPages.ListActivityPage
    {

        public override void BindFilters()
        {
            Bind_Filter_Programs();
            Bind_Filter_Forms();
            Bind_Filter_LocationOfIncident();
            Bind_Filter_Staff();
            Bind_Filter_Status();
            Bind_Filter_IncidentCategory();
            Bind_Filter_Units();
        }

        private void Bind_Filter_Units()
        {
            DataSet dsResidentialUnit = new DataSet();
            try
            {
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetResidentialUnit", dsResidentialUnit, new string[] { "Units" });
                DropDownList_ResidentialUnit.DataTextField = "DisplayAs";
                DropDownList_ResidentialUnit.DataValueField = "UnitId";
                DropDownList_ResidentialUnit.DataSource = dsResidentialUnit.Tables["Units"];
                DropDownList_ResidentialUnit.DataBind();
            }
            finally
            {
                if (dsResidentialUnit != null)
                    dsResidentialUnit.Dispose();
            }

        }

        

        //for binding the Programs drop down
        private void Bind_Filter_Programs()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs != null)
            {
                DataView DataViewProgramsName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs.DefaultView;
                DataViewProgramsName.RowFilter = "ISNULL(RecordDeleted,'N')='N' and  ISNULL(Active,'N')='Y'";
                DataViewProgramsName.Sort = "ProgramName";
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.DataTextField = "ProgramName";
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.DataValueField = "ProgramId";
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.DataSource = DataViewProgramsName;
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.DataBind();

                ListItem item = new ListItem("All Programs", "-1");
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.Items.Insert(0, item);
                DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.SelectedValue = "-1";
            }
        }

        //for binding the Forms drop down
        private void Bind_Filter_Forms()
        {
            ListItem item1 = new ListItem("Incident Report", "1");
            ListItem item2 = new ListItem("Restrictive Procedure Form", "2");
            ListItem item3 = new ListItem("All Forms", "-1");

            DropDownList_Forms.Items.Insert(0, item1);
            DropDownList_Forms.Items.Insert(1, item2);
            DropDownList_Forms.Items.Insert(2, item3);
            DropDownList_Forms.SelectedValue = "-1";
        }


        //for binding Location Of Incident drop down
        private void Bind_Filter_LocationOfIncident()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Active='Y' and Category = 'XLOCATIONINCIDNET' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewPrograms.Sort = "SortOrder,CodeName";

                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.DataTextField = "CodeName";
                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.DataBind();

                ListItem item = new ListItem("Location of Incident", "-1");
                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.Items.Insert(0, item);
                DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.SelectedValue = "-1";

            }
        }

        //for binding All Staff
        private void Bind_Filter_Staff()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
            {
                DataView dataViewStaff = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff);
                dataViewStaff.RowFilter = "Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewStaff.Sort = "StaffName ASC";
                DropDownList_Staff.DataTextField = "StaffName";
                DropDownList_Staff.DataValueField = "StaffId";
                DropDownList_Staff.DataSource = dataViewStaff;

                int ScreenId = SHS.BaseLayer.BaseCommonFunctions.ScreenId;
                string OverrideMessage = SHS.BaseLayer.BaseCommonFunctions.GetApplicationMessageFromMessageCode("ALLSTAFF_DD", ScreenId, "All Staff");
                DropDownList_Staff.BlankRowText = OverrideMessage;

                DropDownList_Staff.BlankRowValue = "-1";
                DropDownList_Staff.AddBlankRow = true;
                DropDownList_Staff.DataBind();

            }

        }


        //for binding the Status drop down
        private void Bind_Filter_Status()
        {
            ListItem item1 = new ListItem("In Progress", "21");
            ListItem item2 = new ListItem("Nursing", "13");
            ListItem item4 = new ListItem("Supervisor", "15");
            ListItem item5 = new ListItem("Manager", "16");
            ListItem item6 = new ListItem("Administrator", "17");
            ListItem itemR = new ListItem("Assigned For Review", "9");
            ListItem item7 = new ListItem("Complete", "22");
            ListItem item8 = new ListItem("All Statuses", "-1");

            DropDownList_Status.Items.Insert(0, item1);
            DropDownList_Status.Items.Insert(1, item2);
            DropDownList_Status.Items.Insert(2, item4);
            DropDownList_Status.Items.Insert(3, item5);
            DropDownList_Status.Items.Insert(4, item6);
            DropDownList_Status.Items.Insert(5, itemR);
            DropDownList_Status.Items.Insert(6, item7);
            DropDownList_Status.Items.Insert(7, item8);
            DropDownList_Status.SelectedValue = "-1";
        }


        private char GetSignedByRecorder()
        {
            char SignedByRecorder = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("Recorder")))
            {
                SignedByRecorder = GetFilterValue("Recorder") == "Y" ? 'Y' : 'N';
            }
            return SignedByRecorder;
        }

        private char GetSignedByNursing()
        {
            char SignedByNursing = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("Nursing")))
            {
                SignedByNursing = GetFilterValue("Nursing") == "Y" ? 'Y' : 'N';
            }
            return SignedByNursing;
        }


        private char GetSignedBySupervisior()
        {
            char SignedBySupervisior = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("Supervisior")))
            {
                SignedBySupervisior = GetFilterValue("Supervisior") == "Y" ? 'Y' : 'N';
            }
            return SignedBySupervisior;
        }


        private char GetSignedByAdministrator()
        {
            char SignedByAdministrator = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("Administrator")))
            {
                SignedByAdministrator = GetFilterValue("Administrator") == "Y" ? 'Y' : 'N';
            }
            return SignedByAdministrator;
        }


        protected void LayoutCreated(object sender, EventArgs e)
        {
            var SortExpression = ParentPageListObject.SortExpression;
            string[] Sort = SortExpression.Split(' ');
            Panel divHeader = (Panel)lvIncidentRestrictiveProcedure.FindControl("divHeader");

            if (Sort[0] == "ClientName,FromDate")
            {
                Panel GridPannel = new Panel();
                GridPannel = (Panel)divHeader.FindControl("ClientName");
                if (GridPannel != null)
                {
                    GridPannel.CssClass = "SortDown";
                }
            }
            foreach (Control ctrl in divHeader.Controls)
            {
                if (ctrl.GetType() == typeof(Panel))
                {
                    string SortId = ((Panel)ctrl).Attributes["SortId"];
                    if (SortId != null)
                    {
                        ((Panel)ctrl).Attributes.Add("onclick", "SortListPage(" + ParentPageListObject.ScreenId.ToString() + ",'" + SortId + "');");
                        if (Sort.Count() > 0)
                        {
                            if (Sort[0] == SortId)
                            {
                                if (Sort.Count() == 1)
                                {
                                    ((Panel)ctrl).CssClass = "SortUp";
                                }
                                else
                                {
                                    ((Panel)ctrl).CssClass = "SortDown";
                                }
                            }
                        }

                    }
                }
            }
            Panel divContent = (Panel)lvIncidentRestrictiveProcedure.FindControl("divListPageContent");
            //CheckboxController1.ListPageControllerDivID = divContent.ClientID.Trim();
            divContent.Attributes.Add("onscroll", "fnScroll('#" + divHeader.ClientID + "','#" + divContent.ClientID + "');");
        }


        
        /// <summary>
        /// for binding the grid Programs
        /// </summary>
        /// <returns></returns>
        public override DataTable BindGrid()
        {
            string EffectiveFrom = DateTime.Now.ToString("MM/dd/yyyy");
            string EffectiveTo = DateTime.Now.ToString("MM/dd/yyyy");
            int instanceId = 0;
            int pageNumber = 0;
            int pageSize = 0;
            string sortExpression = string.Empty;
            EffectiveFrom = GetFilterValue("StartDate");
            EffectiveTo = GetFilterValue("EndDate");
            int ProgramId = 0;
            int FormId = 0;
            int LOI = 0;
            int IncidentCategory = 0;
            int SecondaryCategory = 0;
            int RecorderBy = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId;
            int Status = 0;
            string IndividualName = string.Empty;           
            char Recorder = GetSignedByRecorder();            
            char Nursing = GetSignedByNursing();
            char Supervisior = GetSignedBySupervisior();
            char Administrator = GetSignedByAdministrator();
            DataSet dataSetIncidentRestrictiveprocedure = null;
            pageNumber = ParentPageListObject.CurrentPage;
            pageSize = ParentPageListObject.PageSize;
            sortExpression = ParentPageListObject.SortExpression;
            pageNumber = ParentPageListObject.CurrentPage;
            pageSize = ParentPageListObject.PageSize;
            sortExpression = ParentPageListObject.SortExpression;


            char FromDashboard = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("FromDashboard")))
            {
                FromDashboard = GetFilterValue("FromDashboard") == "Y" ? 'Y' : 'N';
            }

            //clientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
            if (GetFilterValue("StartDate").Equals(string.Empty) && GetFilterValue("EndDate").Equals(string.Empty))
            {
                //EffectiveFrom = string.Format("{0: MM/dd/yyyy}", EffectiveFrom);
                //EffectiveTo = string.Format("{0: MM/dd/yyyy}", EffectiveTo);
            }
            //if (EffectiveTo.Equals(string.Empty))
            //{
            //    EffectiveTo = DateTime.Now.ToString("MM/dd/yyyy");
            //}
            //if (EffectiveFrom.Equals(string.Empty))
            //{
            //    EffectiveFrom = EffectiveTo;
            //}

            IndividualName = GetFilterValue("ClientNameFilter");
            if (Extension.IsDropDownHaveItems(DropDownList_CustomDocumentIncidentReportGenerals_ProgramId))
            {
                int.TryParse(GetFilterValue("ProgramId", DropDownList_CustomDocumentIncidentReportGenerals_ProgramId.SelectedValue), out ProgramId);
            }
            else
            {
                int.TryParse(GetFilterValue("ProgramId"), out ProgramId);
            }


            if (Extension.IsDropDownHaveItems(DropDownList_Forms))
            {
                int.TryParse(GetFilterValue("FormId", DropDownList_Forms.SelectedValue), out FormId);
            }
            else
            {
                int.TryParse(GetFilterValue("FormId"), out FormId);
            }

            if (Extension.IsDropDownHaveItems(DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident))
            {
                int.TryParse(GetFilterValue("GeneralLocationOfIncident", DropDownList_CustomDocumentIncidentReportGenerals_GeneralLocationOfIncident.SelectedValue), out LOI);
            }
            else
            {
                int.TryParse(GetFilterValue("GeneralLocationOfIncident"), out LOI);
            }
            if (Extension.IsDropDownHaveItems(DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory))
            {
                int.TryParse(GetFilterValue("GeneralIncidentCategory", DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.SelectedValue), out IncidentCategory);
            }
            else
            {
                int.TryParse(GetFilterValue("GeneralIncidentCategory"), out IncidentCategory);
            }
            if (Extension.IsDropDownHaveItems(DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory))
            {
                int.TryParse(GetFilterValue("GeneralSecondaryCategory", DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.SelectedValue), out SecondaryCategory);
            }
            else
            {
                int.TryParse(GetFilterValue("GeneralSecondaryCategory"), out SecondaryCategory);
            }
            if (Extension.IsDropDownHaveItems(DropDownList_Forms))
            {
                int.TryParse(GetFilterValue("Forms", DropDownList_Forms.SelectedValue), out FormId);
            }
            else
            {
                int.TryParse(GetFilterValue("Forms"), out FormId);
            }

            if (Extension.IsDropDownHaveItems(DropDownList_Staff))
            {
                int.TryParse(GetFilterValue("Staff", DropDownList_Staff.SelectedValue), out RecorderBy);
            }
            else
            {
                int.TryParse(GetFilterValue("Staff"), out RecorderBy);
            }

            if (Extension.IsDropDownHaveItems(DropDownList_Status))
            {
                int.TryParse(GetFilterValue("Status", DropDownList_Status.SelectedValue), out Status);
            }
            else
            {
                int.TryParse(GetFilterValue("Status"), out Status);
            }
            int ClientId = -1;

            int ResidentialUnit = 0;
            if (Extension.IsDropDownHaveItems(DropDownList_ResidentialUnit))
                int.TryParse(GetFilterValue("ResidentialUnit", DropDownList_ResidentialUnit.SelectedValue), out ResidentialUnit);           
            else
                int.TryParse(GetFilterValue("ResidentialUnit"), out ResidentialUnit);


            dataSetIncidentRestrictiveprocedure = GetIncidentRestrictive(pageNumber, pageSize, ClientId, sortExpression, EffectiveFrom, EffectiveTo, ProgramId, FormId, LOI, IncidentCategory, SecondaryCategory, IndividualName, RecorderBy, Status, Recorder, Nursing, Supervisior, Administrator, FromDashboard, ResidentialUnit);
            if (dataSetIncidentRestrictiveprocedure != null)
            {
                if (dataSetIncidentRestrictiveprocedure.Tables.Count > 0)
                {
                    if (dataSetIncidentRestrictiveprocedure.Tables.Contains("IncidentRestrictive") == true)
                    {

                        lvIncidentRestrictiveProcedure.DataSource = dataSetIncidentRestrictiveprocedure.Tables["IncidentRestrictive"];
                        lvIncidentRestrictiveProcedure.DataBind();
                    }
                }
            }
            return dataSetIncidentRestrictiveprocedure.Tables["TablePagingInformation"];


        }

        public DataSet GetIncidentRestrictive(int pageNumber, int pageSize, int ClientId, string sortExpression, string EffectiveFrom, string EffectiveTo, int ProgramId, int FormId, int LOI, int IncidentCategory, int SecondaryCategory, string IndividualName, int RecordedBy, int Status, char Recorder, char Nursing, char Supervisior, char Administrator, char FromDashboard, int ResidentialUnit)
        {
            DataSet _datasetGetIncidentRestrictive = null;
              SqlParameter[] _objectSqlParmeters = null;
       
            try
            {
                _datasetGetIncidentRestrictive = new DataSet();
                _objectSqlParmeters = new SqlParameter[21];
                _objectSqlParmeters[0] = new SqlParameter("@PageNumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@PageSize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@ClientId", ClientId);
                _objectSqlParmeters[3] = new SqlParameter("@SortExpression", sortExpression);
                _objectSqlParmeters[4] = new SqlParameter("@FromDate", EffectiveFrom);
                _objectSqlParmeters[5] = new SqlParameter("@ToDate", EffectiveTo);
                _objectSqlParmeters[6] = new SqlParameter("@ProgramId", ProgramId);
                _objectSqlParmeters[7] = new SqlParameter("@FormId", FormId);
                _objectSqlParmeters[8] = new SqlParameter("@LocationOfIncident", LOI);
                _objectSqlParmeters[9] = new SqlParameter("@IncidentCategory", IncidentCategory);
                _objectSqlParmeters[10] = new SqlParameter("@SecondaryCategory", SecondaryCategory);
                _objectSqlParmeters[11] = new SqlParameter("@IndividualName", IndividualName);
                _objectSqlParmeters[12] = new SqlParameter("@RecordedBy", RecordedBy);
                _objectSqlParmeters[13] = new SqlParameter("@Status", Status);
                _objectSqlParmeters[14] = new SqlParameter("@Recorder", Recorder);
                _objectSqlParmeters[15] = new SqlParameter("@Nursing", Nursing);
                _objectSqlParmeters[16] = new SqlParameter("@Supervisior", Supervisior);
                _objectSqlParmeters[17] = new SqlParameter("@Administrator", Administrator);
                _objectSqlParmeters[18] = new SqlParameter("@FromDashboard", FromDashboard);
                _objectSqlParmeters[19] = new SqlParameter("@LoggedInUser", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[20] = new SqlParameter("@ResidentialUnit", ResidentialUnit);


                _datasetGetIncidentRestrictive = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCListPageIncidentReportsRestrictiveProcedure", _objectSqlParmeters);
                _datasetGetIncidentRestrictive.Tables[0].TableName = "TablePagingInformation";
                _datasetGetIncidentRestrictive.Tables[1].TableName = "IncidentRestrictive";                
                return _datasetGetIncidentRestrictive;
            }
            finally
            {
                if (_datasetGetIncidentRestrictive != null)
                {
                    _datasetGetIncidentRestrictive.Dispose();
                }
            }
        }

        private void Bind_Filter_IncidentCategory()
        {
            DataView dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewCodeName.RowFilter = "Category='XINCIDENTCATEGORY' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewCodeName.Sort = "CodeName";
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataTextField = "CodeName";
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataValueField = "GlobalCodeId";
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataSource = dataViewCodeName;
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataBind();
            ListItem item = new ListItem("All Categories", "-1");
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.Items.Insert(0, item);
            DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.SelectedValue = "-1";
        }


        

        #region Export Functionality
        public override DataTable GetExportDataSet()
        {
            DataSet dataset = null;
            string FromDate;
            string Todate;
            int RecorderBy = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId;
            int pageNumber = 0;
            int pageSize = 0;
            string sortExpression = "";
            int StaffId = 0;
            int ProgramId = 0;
            int FormId = 0;
            int LOI = 0;
            int IncidentCategory = -1;
            int SecondaryCategory = 0;
            int Status = 0;
            int ClientId = -1;
            string IndividualName = string.Empty;
            int ResidentialUnit = 0;
            pageNumber = ParentPageListObject.CurrentPage;
            pageSize = ParentPageListObject.PageSize == 0 ? 1 : ParentPageListObject.PageSize;
            sortExpression = ParentPageListObject.SortExpression;
            char Recorder = GetSignedByRecorder();
            char Nursing = GetSignedByNursing();
            char Supervisior = GetSignedBySupervisior();
            char Administrator = GetSignedByAdministrator();
            char FromDashboard = 'N';
            if (!String.IsNullOrEmpty(GetFilterValue("FromDashboard")))
            {
                FromDashboard = GetFilterValue("FromDashboard") == "Y" ? 'Y' : 'N';
            }

            if (sortExpression.Trim() == "" || sortExpression.Trim() == null || sortExpression == string.Empty)
            {
                sortExpression = "";
            }
            LOI = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "GeneralLocationOfIncident", ParentPageObject.PageFiltersXML);
            IncidentCategory = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "GeneralIncidentCategory", ParentPageObject.PageFiltersXML);
            SecondaryCategory = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "GeneralSecondaryCategory", ParentPageObject.PageFiltersXML);
            StaffId = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "Staff", ParentPageObject.PageFiltersXML);
            FromDate = BaseCommonFunctions.GetSelectedValueFromXML<string>("/PageFilters/", "StartDate", ParentPageObject.PageFiltersXML);
            Todate = BaseCommonFunctions.GetSelectedValueFromXML<string>("/PageFilters/", "EndDate", ParentPageObject.PageFiltersXML);
            IndividualName = BaseCommonFunctions.GetSelectedValueFromXML<string>("/PageFilters/", "Individual", ParentPageObject.PageFiltersXML);
            RecorderBy = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "Staff", ParentPageObject.PageFiltersXML);
            Status = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "Status", ParentPageObject.PageFiltersXML);
            ProgramId = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "ProgramId", ParentPageObject.PageFiltersXML);
            FormId = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "Forms", ParentPageObject.PageFiltersXML);
            ResidentialUnit = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "ResidentialUnit", ParentPageObject.PageFiltersXML);
            dataset = GetIncidentRestrictive(pageNumber, pageSize, ClientId, sortExpression, FromDate, Todate, ProgramId, FormId, LOI, IncidentCategory, SecondaryCategory, IndividualName, RecorderBy,
            Status, Recorder, Nursing, Supervisior, Administrator, FromDashboard, ResidentialUnit);


            return dataset.Tables["IncidentRestrictive"];
        }
        #endregion


    }
}
