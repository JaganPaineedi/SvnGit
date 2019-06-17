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
using System.Text;


    public partial class UserControls_PermissionsList : BaseActivityPage
        {
        Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences dsUserPreferences = null;
        Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;

        private string _onDeleteEventHandler = "onDeleteClick";

        public string onDeleteEventHandler
            {
            get { return _onDeleteEventHandler; }
            set { _onDeleteEventHandler = value; }
            }

        private string _deleteRowMessage = "Are you sure you want to delete this row?";
        protected override void Page_Load(object sender, EventArgs e)
            {
            }
        public void GenerateRows(string HiddenStaffPermissionId)
            {
            objUserPreferences = new Streamline.UserBusinessServices.UserPrefernces();
            DataSet DataSetPermissions = null;
            DataSet dsTemp = null;
            DataSet dsStaff = null;
            dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();

            try
                {
                DataSet dtst = new DataSet();
                Session["Permissions"] = "";
                DataSetPermissions = new DataSet();
                if (Session["StaffIdForPreferences"] != null && HiddenStaffPermissionId == string.Empty)
                    {
                    dsTemp = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                    dsUserPreferences.StaffPermissions.Merge(dsTemp.Tables[1]);
                    }
                //Changes for merge.
                else if (Session["StaffIdForPreferences"] != null && HiddenStaffPermissionId != string.Empty)
                    {
                    if (Session["DataSetPermissionsList"] != null)
                        {
                        if (((DataSet)(Session["DataSetPermissionsList"])).Tables.Count > 0)
                            {
                            dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                            }
                        }
                    DataRow[] _DataRowPermissions = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in(" + HiddenStaffPermissionId + ")");
                    for (int i = 0; i < _DataRowPermissions.Length; i++)
                        {
                        DataRow DataRowNewPermissiosn = dsUserPreferences.StaffPermissions.NewRow();
                        DataRowNewPermissiosn["StaffId"] = Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                        DataRowNewPermissiosn["ActionId"] = _DataRowPermissions[i]["ActionId"];
                        DataRowNewPermissiosn["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowNewPermissiosn["CreatedBy"] = Context.User.Identity.Name;// ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewPermissiosn["CreatedDate"] = DateTime.Now;
                        DataRowNewPermissiosn["ModifiedBy"] = Context.User.Identity.Name;//((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewPermissiosn["ModifiedDate"] = DateTime.Now;
                        DataRowNewPermissiosn["NewlyAddedColumn"] = "Y";
                        dsUserPreferences.StaffPermissions.Rows.Add(DataRowNewPermissiosn);
                        }
                    }
                else if (Session["StaffIdForPreferences"] == null && HiddenStaffPermissionId != string.Empty)
                    {
                    DataRow[] _dataRow = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in (" + HiddenStaffPermissionId + ")");
                    String[] ActionId = HiddenStaffPermissionId.Split(',');
                    if (ActionId.Length > 0)
                        {
                        if (Session["DataSetPermissionsList"] == null)
                            {
                            DataSetPermissions = new DataSet();
                            DataSetPermissions.Tables.Add("StaffPermissions");
                            DataSetPermissions.Tables[0].Columns.Add("ActionId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("StaffPermissionId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("NewlyAddedColumn");
                            DataSetPermissions.Tables[0].Columns.Add("StaffId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("CreatedBy");
                            DataSetPermissions.Tables[0].Columns.Add("CreatedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("ModifiedBy");
                            DataSetPermissions.Tables[0].Columns.Add("ModifiedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("RecordDeleted");
                            DataSetPermissions.Tables[0].Columns.Add("DeletedBy");
                            DataSetPermissions.Tables[0].Columns.Add("DeletedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("RowIdentifier", System.Type.GetType("System.Guid"));
                            }
                        else
                            {
                            dsTemp = (DataSet)Session["DataSetPermissionsList"];
                            dsUserPreferences.Merge(dsTemp);
                            }
                        Random ran = new Random();
                        for (int i = 0; i < ActionId.Length; i++)
                            {
                            //Random ran = new Random();
                            DataRow DataRowNewPermissiosn = dsUserPreferences.StaffPermissions.NewRow();
                            DataRowNewPermissiosn["StaffPermissionId"] = Convert.ToInt32(ran.Next().ToString());
                            DataRowNewPermissiosn["StaffId"] = Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                            DataRowNewPermissiosn["ActionId"] = Convert.ToInt32(_dataRow[i]["ActionId"]);
                            DataRowNewPermissiosn["RowIdentifier"] = System.Guid.NewGuid();
                            DataRowNewPermissiosn["CreatedBy"] = Context.User.Identity.Name;//((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewPermissiosn["CreatedDate"] = DateTime.Now;
                            DataRowNewPermissiosn["ModifiedBy"] = Context.User.Identity.Name;//((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewPermissiosn["ModifiedDate"] = DateTime.Now;
                            DataRowNewPermissiosn["NewlyAddedColumn"] = "Y";
                            dsUserPreferences.StaffPermissions.Rows.Add(DataRowNewPermissiosn);
                            }
                        }
                    }
                DataSetPermissions.Merge(dsUserPreferences.StaffPermissions);
                PanelPermissionsList.Controls.Clear();
                PanelPermissionsList.ScrollBars = ScrollBars.Vertical;
                Table tbPermissionsList = new Table();
                tbPermissionsList.ID = System.Guid.NewGuid().ToString();
                //tbPermissionsList.BorderWidth = 2;
                

                tbPermissionsList.Width = new Unit(100, UnitType.Percentage);

                TableHeaderRow thTitle = new TableHeaderRow();
                TableHeaderCell thBlank1 = new TableHeaderCell();

                //Screen Name
                TableHeaderCell thScreenName = new TableHeaderCell();
                thScreenName.Text = "Screen Name";
                thScreenName.Attributes.Add("onclick", "onHeaderClick(this)");
                thScreenName.Attributes.Add("ColumnName", "ScreenName");
                //thScreenName.CssClass = "handStyle";
                thScreenName.Attributes.Add("align", "left");

                //Action
                TableHeaderCell thAction = new TableHeaderCell();
                thAction.Text = "Action";
                thAction.Attributes.Add("onclick", "onHeaderClick(this)");
                thAction.Attributes.Add("ColumnName", "Action");
                //thAction.CssClass = "handStyle";
                thAction.Attributes.Add("align", "left");

                thTitle.Cells.Add(thBlank1);
                thTitle.Cells.Add(thScreenName);
                thTitle.Cells.Add(thAction);

                thTitle.CssClass = "GridViewHeaderText";

                tbPermissionsList.Rows.Add(thTitle);
                string rowStyle = "GridViewRowStyle";

                string staffPermissionId;
                string myscript = "<script id='Permissionslist' type='text/javascript'>";
                myscript += "function $deleteRecord(sender,e){";
                if (!string.IsNullOrEmpty(_deleteRowMessage))
                    {
                    myscript += " if (confirm ('" + _deleteRowMessage + "') == true ){" + this._onDeleteEventHandler + "(sender,e)}}";
                    }
                else
                    {
                    myscript += "}";
                    }
                if (DataSetPermissions != null && DataSetPermissions.Tables["StaffPermissions"].Rows.Count > 0)
                    {
                    myscript += "function RegisterPermissionsListControlEvents(){try{";
                    if (DataSetPermissions.Tables[0].Rows.Count > 0)
                        {
                        Random ran = new Random();
                        DataRow[] dtr = DataSetPermissions.Tables[0].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        DataView dtv = DataSetPermissions.Tables[0].DefaultView;
                        dtv.RowFilter = "ISNULL(RecordDeleted,'N')<>'Y'";

                        dtst.Merge(dtr);
                        foreach (DataRow dr in dtst.Tables[0].Rows)
                            {
                            if (dtst.Tables[0].Columns.Contains("StaffPermissionId"))
                                {
                                if (dr["StaffPermissionId"].ToString() != "")
                                    staffPermissionId = dr["StaffPermissionId"].ToString();
                                else
                                    {
                                    staffPermissionId = ran.Next().ToString();
                                    dr["StaffPermissionId"] = staffPermissionId;
                                    }
                                }
                            else
                                staffPermissionId = ran.Next().ToString();
                            string screeName = "Medication Management";
                            DataRow[] _DataRowAction = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in(" + Convert.ToInt32(dr["ActionId"]) + ")");
                            string action = _DataRowAction[0]["Action"].ToString();
                            if (Session["Permissions"].ToString() == "")
                                Session["Permissions"] = _DataRowAction[0]["ActionId"].ToString();
                            else
                                Session["Permissions"] = Session["Permissions"] + "," + _DataRowAction[0]["ActionId"].ToString();
                            tbPermissionsList.Rows.Add(GenerateSubRows(dr, staffPermissionId, screeName, action, tbPermissionsList.ClientID, ref myscript, rowStyle));
                            rowStyle = rowStyle == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                            }
                        }
                    Session["DataSetPermissionsList"] = dsUserPreferences;
                    PanelPermissionsList.Controls.Add(tbPermissionsList);
                    myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                    Page.RegisterClientScriptBlock(this.ClientID, myscript);
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
                throw (ex);

                }
            }

        private TableRow GenerateSubRows(DataRow dr, string staffPermissionId, string ScreenName, string Action, string tableId, ref string myscript, string rowStyle)
            {
            try
                {

                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                string tblId = this.ClientID + this.ClientIDSeparator + tableId;

                TableRow tblRow = new TableRow();
                tblRow.ID = "Tr_" + newId;
                TableCell tdScreenName = new TableCell();
                tdScreenName.Text = ScreenName.ToString();

                TableCell tdAction = new TableCell();
                tdAction.Text = Action;

                TableCell tdDelete = new TableCell();
                HtmlImage imgTemp = new HtmlImage();
                imgTemp.ID = "Img_" + staffPermissionId.ToString();

                string rowId = this.ClientID + this.ClientIDSeparator + tblRow.ClientID;

                imgTemp.Attributes.Add("StaffPermissionId", staffPermissionId);
                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgTemp.Attributes.Add("class", "handStyle");
                tdDelete.Controls.Add(imgTemp);

                myscript += "var Imagecontext" + staffPermissionId + "={StaffPermissionId:" + staffPermissionId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                myscript += "var ImageclickCallback" + staffPermissionId + " =";
                myscript += " Function.createCallback($deleteRecord, Imagecontext" + staffPermissionId + ");";
                myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'), 'click', ImageclickCallback" + staffPermissionId + ");";

                tblRow.Cells.Add(tdDelete);
                tblRow.Cells.Add(tdScreenName);
                tblRow.Cells.Add(tdAction);
                tblRow.CssClass = rowStyle;
                return tblRow;
                }
            catch (Exception ex)
                {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
                }
            }
        }
    