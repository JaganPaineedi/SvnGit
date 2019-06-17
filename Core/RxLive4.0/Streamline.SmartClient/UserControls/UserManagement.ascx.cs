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
using System.Collections.Generic;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_UserManagement : Streamline.BaseLayer.BaseActivityPage
    {
        private String sortExpression = "StaffName";
        string RelativePath = "";
        Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences _dsUserPreferences = null;
        Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                RelativePath = Page.ResolveUrl("~");
                CommonFunctions.Event_Trap(this);
                //Added in ref to Task#2895
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }
                string sortField = Request["sortField"] != null ? Request["sortField"].ToString() : sortExpression;
                sortExpression = String.IsNullOrEmpty(sortField) ? sortExpression : sortField;
                string activeUsersOnly = Request["activeUsersOnly"] != null ? Request["activeUsersOnly"].ToString() : "Y";
                string searchFilter = Request["searchField"] != null ? Request["searchField"].ToString() : "";

                string prescribersOnly = Request["prescribersOnly"] != null ? Request["prescribersOnly"].ToString() : "Y";
                string epcsprescribers = Request["epcsprescribers"] != null ? Request["epcsprescribers"].ToString() : "Y";

                FillGridView(sortExpression, activeUsersOnly, searchFilter, prescribersOnly, epcsprescribers);
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
                //Active Users Only should be selected if page gets open
                RadioButtonActiveUsers.Checked = true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private void FillGridView(string sortField, string activeUsersOnly, string searchFilter, string prescribersOnly, string epcsprescribers)
        {
            DataTable dtTemp;
            DataSet dsTemp;
            objUserPreferences = new UserPrefernces();
            string filterString = "";
            string[] filters = searchFilter.Split(' ');
            if (filters.Length > 0 && searchFilter != "")
            {
                if (filters.Length == 1)
                {
                    filterString = "(lastname like '%" + filters[0] + "%' or firstname like '%" + filters[0] + "%') AND ";
                }
                else
                {
                    filterString = "(lastname like '%" + filters[1] + "%' and firstname like '%" + filters[0] + "%') AND ";
                }
            }
            try
            {
                _dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
                dsTemp = objUserPreferences.DownloadStaffMedicationDetail();
                _dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                dtTemp = _dsUserPreferences.Staff.Clone();
                if (activeUsersOnly == "Y")
                {
                    filterString = filterString + "ISNULL(Active,'Y')<>'N' and ISNULL(RecordDeleted,'N')<>'Y'";
                    DataRow[] dataRowUsers = _dsUserPreferences.Tables["Staff"].Select(filterString, sortField);
                    for (int i = 0; i < dataRowUsers.Length; i++)
                    {
                        dtTemp.ImportRow(dataRowUsers[i]);
                    }
                    //DataGridUsers.DataSource = dtTemp;
                    //DataGridUsers.DataBind();
                    lvUserList.DataSource = dtTemp;
                    lvUserList.DataBind();
                    Session["DataViewUserManagement"] = _dsUserPreferences.Tables["Staff"].DefaultView;
                }
                else if (prescribersOnly == "Y")
                {
                    filterString = filterString + "ISNULL(Prescriber,'Y')<>'N' and ISNULL(RecordDeleted,'N')<>'Y'";
                    DataRow[] dataRowUsers = _dsUserPreferences.Tables["Staff"].Select(filterString, sortField);
                    for (int i = 0; i < dataRowUsers.Length; i++)
                    {
                        dtTemp.ImportRow(dataRowUsers[i]);
                    }
                    lvUserList.DataSource = dtTemp;
                    lvUserList.DataBind();
                    Session["DataViewUserManagement"] = _dsUserPreferences.Tables["Staff"].DefaultView;
                }

                else if (epcsprescribers == "Y")
                {
                    filterString = filterString + "EPCS = 'Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                    DataRow[] dataRowUsers = _dsUserPreferences.Tables["Staff"].Select(filterString, sortField);
                    for (int i = 0; i < dataRowUsers.Length; i++)
                    {
                        dtTemp.ImportRow(dataRowUsers[i]);
                    }
                    lvUserList.DataSource = dtTemp;
                    lvUserList.DataBind();
                    Session["DataViewUserManagement"] = _dsUserPreferences.Tables["Staff"].DefaultView;
                }
                else
                {
                    filterString = filterString + "ISNULL(RecordDeleted,'N')<>'Y'";
                    DataRow[] dataRowUsers = _dsUserPreferences.Tables["Staff"].Select(filterString, sortField);
                    for (int i = 0; i < dataRowUsers.Length; i++)
                    {
                        dtTemp.ImportRow(dataRowUsers[i]);
                    }
                    //DataGridUsers.DataSource = dtTemp;
                    //DataGridUsers.DataBind();
                    lvUserList.DataSource = dtTemp;
                    lvUserList.DataBind();
                    Session["DataViewUserManagement"] = dtTemp.DefaultView;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                dtTemp = null;
            }
        }

        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }

        protected void LayoutCreated(object sender, EventArgs e)
        {
            string[] Sort = sortExpression.Split(' ');

            Panel divHeader = (Panel)lvUserList.FindControl("divHeader");
            foreach (Control ctrl in divHeader.Controls)
            {
                if (ctrl.GetType() == typeof(Panel))
                {
                    string SortId = ((Panel)ctrl).Attributes["SortId"];
                    if (SortId != null)
                    {
                        if (Sort.Length > 0)
                        {
                            if (Sort[0] == SortId)
                            {
                                if (Sort.Length == 1)
                                {
                                    ((Panel) ctrl).Attributes.Add("onclick", "SortUserManagementListPage('" + SortId + " Desc');");
                                    ((Panel) ctrl).Style.Add("background-image",
                                                             "url('" + RelativePath +
                                                             "App_Themes/Includes/Images/ListPageUp.png'");
                                    ((Panel) ctrl).CssClass = "ListSortUp";
                                }
                                else
                                {
                                    ((Panel) ctrl).Attributes.Add("onclick", "SortUserManagementListPage('" + SortId + "');");
                                    ((Panel) ctrl).Style.Add("background-image",
                                                             "url('" + RelativePath +
                                                             "App_Themes/Includes/Images/ListPageDown.png'");
                                    ((Panel) ctrl).CssClass = "ListSortDown";
                                }
                            }
                            else
                            {
                                ((Panel) ctrl).Attributes.Add("onclick", "SortUserManagementListPage('" + SortId + "');");
                            }
                        }
                    }
                }
            }
            Panel divContent = (Panel)lvUserList.FindControl("divListPageContent");
            divContent.Attributes.Add("onscroll", "fnScroll('#" + divHeader.ClientID + "','#" + divContent.ClientID + "');");
        }
    }
}
