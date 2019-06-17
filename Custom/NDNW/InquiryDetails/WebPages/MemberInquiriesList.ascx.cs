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


public partial class Custom_InquiryDetails_MemberInquiriesList : SHS.BaseLayer.ActivityPages.ListActivityPage
{

    protected string PeriodStartDate = string.Empty;
    protected string PeriodEndDate = string.Empty;

    public override int DetailScreenId
    {
        get
        {
            return 10683;
        }
    }

    public override int DetailScreenTabId
    {
        get
        {
            return 1;
            
        }   
    }

    public override string DefaultSortExpression
    {
        get
        {
            return "InquiryDateTime DESC";
        }
    }

    public override void BindFilters()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
        {
            DataView DataViewStaffName = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
            DataViewStaffName.Sort = "StaffName";
            //Modified By Mamta Gupta - Ref Task No. 1272 - Kalamazoo Bugs - RecordDeleted check added.
            DataViewStaffName.RowFilter = "Active='Y' and RecordDeleted<>'Y'";
            DropDownList_AssignedToStaffId.DataTextField = "StaffName";
            DropDownList_AssignedToStaffId.DataValueField = "StaffId";
            DropDownList_AssignedToStaffId.DataSource = DataViewStaffName;
            DropDownList_AssignedToStaffId.DataBind();

            DropDownList_RecordedBy.DataTextField = "StaffName";
            DropDownList_RecordedBy.DataValueField = "StaffId";
            DropDownList_RecordedBy.DataSource = DataViewStaffName;
            DropDownList_RecordedBy.DataBind();
        }

        DropDownList_Disposition.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_Disposition.FillDropDownDropGlobalCodes();

        DropDownList_InquiryStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_InquiryStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomFilter.DataTableSubGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes;
        DropDownList_CustomFilter.FillDropDownDropSubGlobalCodes();
    }

    public DataSet GetMemberInquiriesListIonia(int instanceId, int pageNumber, int pageSize, string sortExpression, int clientId, int recordedBy, int staffId, int disposition, int inquiryStatus, DateTime? fromDate, DateTime? toDate, int other)
    {
        DataSet dataSetMemberInquiriesList = null;
        SqlParameter[] _objectSqlParmeters = new SqlParameter[12];
        //_objectSqlParmeters[0] = new SqlParameter("@SessionId", sessionId);
        _objectSqlParmeters[0] = new SqlParameter("@InstanceId", instanceId);
        _objectSqlParmeters[1] = new SqlParameter("@PageNumber", pageNumber);
        _objectSqlParmeters[2] = new SqlParameter("@PageSize", pageSize);
        _objectSqlParmeters[3] = new SqlParameter("@SortExpression", sortExpression);
        _objectSqlParmeters[4] = new SqlParameter("@ClientId", clientId);
        _objectSqlParmeters[5] = new SqlParameter("@RecordedBy", recordedBy);
        _objectSqlParmeters[6] = new SqlParameter("@StaffId", staffId);
        _objectSqlParmeters[7] = new SqlParameter("@Disposition", disposition);
        _objectSqlParmeters[8] = new SqlParameter("@InquiryStatus", inquiryStatus);
        _objectSqlParmeters[9] = new SqlParameter("@FromDate", fromDate);
        _objectSqlParmeters[10] = new SqlParameter("@ToDate", toDate);
        _objectSqlParmeters[11] = new SqlParameter("@OtherFilter", other);
        dataSetMemberInquiriesList = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCListPageMemberInquiries", _objectSqlParmeters);
        dataSetMemberInquiriesList.Tables[1].TableName = "CustomInquiries";
        //SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCListPageMemberInquiries", dataSetMemberInquiriesList, new string[] { "TablePagingInformation", "MemberInquiries" }, _objectSqlParmeters);
        return dataSetMemberInquiriesList;
    }

    public override System.Data.DataTable BindGrid()
    {
        //string sessionId;
        int instanceId = 0;
        int pageNumber = 0;
        int pageSize = 0;
        string sortExpression = string.Empty;
        int clientId = 0;
        int recordedBy = 0;
        int staffId = 0;
        int disposition = 0;
        int inquiryStatus = 0;
        int other = 0;
        DateTime? FromDate = null;
        DateTime? ToDate = null;

        //using (SHS.UserBusinessServices.MemberInquiriesKalamazoo objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiriesKalamazoo())
        //{
            DataSet dataSetMemberInquiries = null;
            //sessionId = Session.SessionID;
            int.TryParse(ParentPageListObject.CurrentHistoryId, out instanceId);
            pageNumber = ParentPageListObject.CurrentPage;
            pageSize = ParentPageListObject.PageSize;
            sortExpression = ParentPageListObject.SortExpression;
            clientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;

            PeriodStartDate = GetFilterValue("InquiriesFrom", DateTime.Now.ToString("MM/dd/yyyy"));
            PeriodEndDate = GetFilterValue("InquiriesTo", DateTime.Now.ToString("MM/dd/yyyy"));

            if (Extension.IsDropDownHaveItems(DropDownList_RecordedBy))
            {
                int.TryParse(GetFilterValue("RecordedBy", DropDownList_RecordedBy.SelectedValue), out recordedBy);
            }
            else
            {
                int.TryParse(GetFilterValue("RecordedBy"), out recordedBy);
            }

            if (Extension.IsDropDownHaveItems(DropDownList_AssignedToStaffId))
            {
                int.TryParse(GetFilterValue("AssignedToStaffId", DropDownList_AssignedToStaffId.SelectedValue), out staffId);
            }
            else
            {
                int.TryParse(GetFilterValue("AssignedToStaffId"), out staffId);
            }
            if (Extension.IsDropDownHaveItems(DropDownList_Disposition))
            {
                int.TryParse(GetFilterValue("Disposition", DropDownList_Disposition.SelectedValue), out disposition);
            }
            else
            {
                int.TryParse(GetFilterValue("Disposition"), out disposition);
            }
            if (Extension.IsDropDownHaveItems(DropDownList_InquiryStatus))
            {
                int.TryParse(GetFilterValue("InquiryStatus", DropDownList_InquiryStatus.SelectedValue), out inquiryStatus);
            }
            else
            {
                int.TryParse(GetFilterValue("InquiryStatus"), out inquiryStatus);
            }
            if (GetFilterValue("InquiriesFrom") != "")
            {
                FromDate = Convert.ToDateTime(GetFilterValue("InquiriesFrom"));
            }
            else
            {
                FromDate = Convert.ToDateTime(GetFilterValue("InquiriesFrom", DateTime.Now.ToString("MM/dd/yyyy")));
            }
            if (GetFilterValue("InquiriesTo") != "")
            {
                ToDate = Convert.ToDateTime(GetFilterValue("InquiriesTo"));
            }
            else
            {
                ToDate = Convert.ToDateTime(GetFilterValue("InquiriesTo", DateTime.Now.ToString("MM/dd/yyyy")));
            }

            //dataSetMemberInquiries = objectMemberInquiries.GetMemberInquiriesList(instanceId, pageNumber, pageSize, sortExpression, clientId, recordedBy, staffId, disposition, inquiryStatus, FromDate, ToDate, other);
            dataSetMemberInquiries = GetMemberInquiriesListIonia(instanceId, pageNumber, pageSize, sortExpression, clientId, recordedBy, staffId, disposition, inquiryStatus, FromDate, ToDate, other);

            if (dataSetMemberInquiries != null)
            {
                if (dataSetMemberInquiries.Tables.Count > 0)
                {
                    if (dataSetMemberInquiries.Tables.Contains("CustomInquiries") == true)
                    {
                        //ListViewMemberInquiries.SettingsPager.PageSize = pageSize;
                        ListViewMemberInquiries.DataSource = dataSetMemberInquiries.Tables["CustomInquiries"];
                        //Extension.SetDevXGridSortIcon(sortExpression, GridViewMemberInquiries);
                        ListViewMemberInquiries.DataBind();
                    }
                }
            }
            return dataSetMemberInquiries.Tables["TablePagingInformation"];
        //}
        return null;
    }

    protected void LayoutCreated(object sender, EventArgs e)
    {
        var SortExpression = ParentPageListObject.SortExpression;
        string[] Sort = SortExpression.Split(' ');

        Panel divHeader = (Panel)ListViewMemberInquiries.FindControl("divHeader");
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
        Panel divContent = (Panel)ListViewMemberInquiries.FindControl("divListPageContent");
        //CheckboxController1.ListPageControllerDivID = divContent.ClientID.Trim();
        divContent.Attributes.Add("onscroll", "fnScroll('#" + divHeader.ClientID + "','#" + divContent.ClientID + "');");
    }
}