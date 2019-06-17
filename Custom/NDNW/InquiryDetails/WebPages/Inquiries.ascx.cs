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

public partial class Custom_InquiryDetails_Inquiries : SHS.BaseLayer.ActivityPages.ListActivityPage
{
    public string source = "";
    protected string PeriodStartDate = string.Empty;
    protected string PeriodEndDate = string.Empty;

    #region--User Defined Functions
    public override string DefaultSortExpression
    {
        get
        {
            return "InQuiryDateTime Desc";
        }
    }
    /// <summary>
    /// <Description>This is overridable function inherited from base layer's ListActivityPage and is used to bind dropdown control</Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn>Sept 6,2011</CreatedOn>
    /// </summary>
    public override void BindFilters()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
        {
            DataView dataViewStaff = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff);
            if (dataViewStaff != null && dataViewStaff.Count>0)
            {
            dataViewStaff.RowFilter = "Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            DropDownList_RecordedByStaffId.DataTextField = "StaffName";
            DropDownList_RecordedByStaffId.DataValueField = "StaffId";
            DropDownList_RecordedByStaffId.DataSource = dataViewStaff;
            DropDownList_RecordedByStaffId.BlankRowText = "Recorded By All";
            DropDownList_RecordedByStaffId.BlankRowValue = "0";
            DropDownList_RecordedByStaffId.AddBlankRow = true;
            DropDownList_RecordedByStaffId.DataBind();
            //DropDownList_RecordedBy.Items.Insert(0, new ListItem("Recorded By All", "0"));
            //----------------DropDownList_AssignTo
            DropDownList_AssignedToStaffId.DataTextField = "StaffName";
            DropDownList_AssignedToStaffId.DataValueField = "StaffId";
            DropDownList_AssignedToStaffId.DataSource = dataViewStaff;
            DropDownList_AssignedToStaffId.BlankRowText = "Assigned To All";
            DropDownList_AssignedToStaffId.BlankRowValue = "0";
            DropDownList_AssignedToStaffId.AddBlankRow = true;
            DropDownList_AssignedToStaffId.DataBind();
            }
        }
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes!=null)
        {
            DropDownList_Dispositions.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_Dispositions.FillDropDownDropGlobalCodes();
            DropDownList_InquiryStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_InquiryStatus.FillDropDownDropGlobalCodes();
        }

    }

    public override DataTable GetExportDataSet()
    {
        using (SHS.UserBusinessServices.ListPages listPagesObj = new SHS.UserBusinessServices.ListPages())
        {
            int instanceId = 0;
            int pageNumber = ParentPageListObject.CurrentPage;
            int pageSize = ParentPageListObject.PageSize == 0 ? 1 : ParentPageListObject.PageSize;
            string sortExpression = ParentPageListObject.SortExpression;

            DataSet dataSet = null;
            // Begin custom code
            int recordedByStaffId = -1;
            int assignedToStaffId = 0;
            string memberLastName = "";
            string memberFirstName = "";
            int otherFilter = 0;
            int dispositions = 0;
            int inquiryStatus = 0;
            source = "GetExportDataSet";
            DateTime InquiriesFrom;
            DateTime InquiriesTo;


            recordedByStaffId = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "RecordedByStaffId", ParentPageObject.PageFiltersXML);
            assignedToStaffId = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "AssignedToStaffId", ParentPageObject.PageFiltersXML);
            dispositions = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "Dispositions", ParentPageObject.PageFiltersXML);
            inquiryStatus = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "InquiryStatus", ParentPageObject.PageFiltersXML);
            InquiriesFrom = BaseCommonFunctions.GetSelectedValueFromXML<DateTime>("/PageFilters/", "InquiriesFrom", ParentPageObject.PageFiltersXML);
            InquiriesTo = BaseCommonFunctions.GetSelectedValueFromXML<DateTime>("/PageFilters/", "InquiriesTo", ParentPageObject.PageFiltersXML);
            otherFilter = BaseCommonFunctions.GetSelectedValueFromXML<int>("/PageFilters/", "CustomFilter", ParentPageObject.PageFiltersXML);
            memberLastName = BaseCommonFunctions.GetSelectedValueFromXML<string>("/PageFilters/", "MemberLatName", ParentPageObject.PageFiltersXML);
            memberFirstName = BaseCommonFunctions.GetSelectedValueFromXML<string>("/PageFilters/", "MemberFirstName", ParentPageObject.PageFiltersXML);

            dataSet = GetInquriesList(instanceId, pageNumber, pageSize, sortExpression, recordedByStaffId, assignedToStaffId, InquiriesFrom, InquiriesTo, memberLastName, memberFirstName, dispositions, inquiryStatus, otherFilter);
            dataSet.Tables["CustomInquiries"].Columns.Remove("RowNumber");
            dataSet.Tables["CustomInquiries"].Columns.Remove("InquiryId");

            dataSet.Tables["CustomInquiries"].Columns["MemberName"].ColumnName = "Client (Potential)";
            dataSet.Tables["CustomInquiries"].Columns["MemberId"].ColumnName = "Client Id";
            dataSet.Tables["CustomInquiries"].Columns["InquirerName"].ColumnName = "Inquirer";
            dataSet.Tables["CustomInquiries"].Columns["InQuiryDateTime"].ColumnName = "Date/Time";
            dataSet.Tables["CustomInquiries"].Columns["RecordedByName"].ColumnName = "Recorded By";
            dataSet.Tables["CustomInquiries"].Columns["AssignedToName"].ColumnName = "Assigned To";

            return dataSet.Tables["CustomInquiries"];
        }
    }

    public DataSet GetInquriesList(int instanceId, int pageNumber, int pageSize, string sortExpression, int recordedByStaffId, int assignedToStaffId, DateTime? inquiryFrom, DateTime? inquiryTo, string memberLatName, string memberFirstName, int dispositions, int inquiryStatus, int otherFilter)
    {

        DataSet dataSetInquiriesList = null;
        
            dataSetInquiriesList = new DataSet();
            SqlParameter[] _objectSqlParmeters = new SqlParameter[13];
            //_objectSqlParmeters[0] = new SqlParameter("@SessionId", sessionId);
            _objectSqlParmeters[0] = new SqlParameter("@InstanceId", instanceId);
            _objectSqlParmeters[1] = new SqlParameter("@PageNumber", pageNumber);
            _objectSqlParmeters[2] = new SqlParameter("@PageSize", pageSize);
            _objectSqlParmeters[3] = new SqlParameter("@SortExpression", sortExpression);
            _objectSqlParmeters[4] = new SqlParameter("@RecordedByStaffId", recordedByStaffId);
            _objectSqlParmeters[5] = new SqlParameter("@AssignedToStaffId", assignedToStaffId);
            if (inquiryFrom.HasValue)
            {
                _objectSqlParmeters[6] = new SqlParameter("@InquiryFrom", inquiryFrom);
            }
            else
            {
                _objectSqlParmeters[6] = new SqlParameter("@InquiryFrom", DBNull.Value);
            }
            if (inquiryTo.HasValue)
            {
                _objectSqlParmeters[7] = new SqlParameter("@InquiryTo", inquiryTo);
            }
            else
            {
                _objectSqlParmeters[7] = new SqlParameter("@InquiryTo", DBNull.Value);
            }

            _objectSqlParmeters[8] = new SqlParameter("@MemberLatName", memberLatName);
            _objectSqlParmeters[9] = new SqlParameter("@MemberFirstName", memberFirstName);
            _objectSqlParmeters[10] = new SqlParameter("@Dispositions", dispositions);
            _objectSqlParmeters[11] = new SqlParameter("@InquiryStatus", inquiryStatus);
            _objectSqlParmeters[12] = new SqlParameter("@OtherFilter", otherFilter);
            dataSetInquiriesList = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_ListPageSCInquiries", _objectSqlParmeters);
            dataSetInquiriesList.Tables[1].TableName = "CustomInquiries";
            return dataSetInquiriesList;
                
    }


    /// <summary>
    /// <Description>Bind the list view grid with the data from database.</Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn>8 Sept 2011</CreatedOn>
    /// </summary>
    /// <returns></returns>
    public override DataTable BindGrid()
    {
        string sessionId;
        int instanceId = 0;
        int pageNumber = 0;
        int pageSize = 0;
        string sortExpression = "";
        int otherFilter = 0;
        int recordedByStaffId = 0;
        int assignedToStaffId = 0;
        int dispositions = 0;       
        int inquieryStatus = 0;
        DateTime? inquiryFrom = null;
        DateTime? inquiryTo = null;
        string memberLatName = null;
        string memberFirstName = null;
        //using (SHS.UserBusinessServices.MemberInquiriesKalamazoo objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiriesKalamazoo())
        //{
            DataSet dataSetInquries = null;
            sessionId = Session.SessionID;
            int.TryParse(ParentPageListObject.CurrentHistoryId, out instanceId);
            pageNumber = ParentPageListObject.CurrentPage;
            pageSize = ParentPageListObject.PageSize;
            sortExpression = ParentPageListObject.SortExpression;

            PeriodStartDate = GetFilterValue("InquiriesFrom", "01/01/1900");
            PeriodEndDate = GetFilterValue("InquiriesTo", "12/31/9999");

            if (Extension.IsDropDownHaveItems(DropDownList_AssignedToStaffId))
            {
                int.TryParse(GetFilterValue("AssignedToStaffId", DropDownList_AssignedToStaffId.SelectedValue), out assignedToStaffId);
            }
            else { int.TryParse(GetFilterValue("AssignedToStaffId"), out assignedToStaffId); }
            if (Extension.IsDropDownHaveItems(DropDownList_RecordedByStaffId))
            {
                int.TryParse(GetFilterValue("RecordedByStaffId", DropDownList_RecordedByStaffId.SelectedValue), out recordedByStaffId);
            }
            else { int.TryParse(GetFilterValue("RecordedByStaffId"), out recordedByStaffId); }
            if (Extension.IsDropDownHaveItems(DropDownList_Dispositions))
            {
                int.TryParse(GetFilterValue("Dispositions", DropDownList_Dispositions.SelectedValue), out dispositions);
            }
            else { int.TryParse(GetFilterValue("Dispositions"), out dispositions); }
            if (Extension.IsDropDownHaveItems(DropDownList_InquiryStatus))
            {
                int.TryParse(GetFilterValue("InquiryStatus", DropDownList_InquiryStatus.SelectedValue), out inquieryStatus);
            }
            else { int.TryParse(GetFilterValue("InquiryStatus"), out inquieryStatus); }
            if (Extension.IsDropDownHaveItems(DropDownList_CustomFilter))
            {
                int.TryParse(GetFilterValue("CustomFilter", DropDownList_CustomFilter.SelectedValue), out otherFilter);
            }
            else { int.TryParse(GetFilterValue("CustomFilter"), out otherFilter); }
            if (GetFilterValue("InquiriesFrom") != null && GetFilterValue("InquiriesFrom") != "")
            {
                inquiryFrom = Convert.ToDateTime(GetFilterValue("InquiriesFrom"));

            }
            else
            {
                inquiryFrom = Convert.ToDateTime(GetFilterValue("InquiriesFrom", "01/01/1900"));
            }

            if (GetFilterValue("InquiriesTo") != null && GetFilterValue("InquiriesTo") != "")
            {
                inquiryTo = Convert.ToDateTime(GetFilterValue("InquiriesTo"));

            }
            else
            {
                inquiryTo = Convert.ToDateTime(GetFilterValue("InquiriesTo", "12/31/9999"));
            }
            if (GetFilterValue("MemberLatName") != "")
            {
                memberLatName = GetFilterValue("MemberLatName").ToString();

            }
            if (GetFilterValue("MemberFirstName") != "")
            {
                memberFirstName = GetFilterValue("MemberFirstName").ToString();

            }
            //dataSetInquries = objectMemberInquiries.GetInquriesList(sessionId,instanceId, pageNumber, pageSize, sortExpression, recordedByStaffId, assignedToStaffId, inquiryFrom, inquiryTo, memberLatName, memberFirstName, dispositions,inquieryStatus,otherFilter);
            dataSetInquries = GetInquriesList(instanceId, pageNumber, pageSize, sortExpression, recordedByStaffId, assignedToStaffId, inquiryFrom, inquiryTo, memberLatName, memberFirstName, dispositions, inquieryStatus, otherFilter);

            if (dataSetInquries.Tables.Count>0)
            {
                if (dataSetInquries.Tables.Contains("CustomInquiries") == true)
                {
                    //GridViewInquriesListRadGrid.SettingsPager.PageSize = pageSize; //Set the page size
                    ListViewInquriesListRadGrid.DataSource = dataSetInquries.Tables["CustomInquiries"];
                    //Extension.SetDevXGridSortIcon(sortExpression, GridViewInquriesListRadGrid);
                    ListViewInquriesListRadGrid.DataBind();
                    //GridViewInquriesListRadGrid.Settings.ShowVerticalScrollBar = true;
                }
            }
            return dataSetInquries.Tables["TablePagingInformation"]; 
        //}
        
       
    }
    #endregion
    public override int DetailScreenId
    {
        get
        {
            return 10683;
        }
       
    }
    protected void LayoutCreated(object sender, EventArgs e)
    {
        var SortExpression = ParentPageListObject.SortExpression;
        string[] Sort = SortExpression.Split(' ');

        Panel divHeader = (Panel)ListViewInquriesListRadGrid.FindControl("divHeader");
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
        Panel divContent = (Panel)ListViewInquriesListRadGrid.FindControl("divListPageContent");
        //CheckboxController1.ListPageControllerDivID = divContent.ClientID.Trim();
        divContent.Attributes.Add("onscroll", "fnScroll('#" + divHeader.ClientID + "','#" + divContent.ClientID + "');");
    }
}
