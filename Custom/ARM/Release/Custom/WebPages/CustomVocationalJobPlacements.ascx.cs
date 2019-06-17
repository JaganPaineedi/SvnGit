using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using SHS.UserBusinessServices;
namespace SHS.SmartCare
{
    public partial class CustomVocationalJobPlacements : SHS.BaseLayer.ActivityPages.ListActivityPage
    {
        #region protected

        /// <summary>
        /// DOSFrom date entered in the jobDevelopmentFrom TextBox
        /// </summary>  
        protected string jobDevelopmentFrom = string.Empty;
        /// <summary>
        /// DOSTo date entered in the jobDevelopmentTo TextBox
        /// </summary>  
        protected string jobDevelopmentTo = string.Empty;
        /// <summary>
        /// ProcessedFrom date entered in the jobStartBetweenFrom TextBox
        /// </summary>
        protected string jobStartBetweenFrom = string.Empty;
        /// <summary>
        /// jobStartBetweenTo date entered in the jobStartBetweenFrom TextBox
        /// </summary>
        protected string jobStartBetweenTo = string.Empty;


        #endregion
        public override void BindFilters()
        {

        }
        public override DataTable BindGrid()
        {

            string sessionId;
            int instanceId = 0;
            int pageNumber = 0;
            int pageSize = 0;
            string sortExpression = string.Empty;
            int OtherFilter = 0;
            int staffId;
            int clientid = 0;
            DataSet datasetJobPlacementInformation = null;
            UpdateDates();
              
            using (SHS.UserBusinessServices.ListPages objJobPlacementInformation = new SHS.UserBusinessServices.ListPages())
            {
                sessionId = Session.SessionID;
                int.TryParse(ParentPageListObject.CurrentHistoryId, out instanceId);
                pageNumber = ParentPageListObject.CurrentPage;
                pageSize = ParentPageListObject.PageSize;
                sortExpression = ParentPageListObject.SortExpression;
               
                if (BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId != 0)
                {
                    staffId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;
                }
                else
                {
                    staffId = 0;
                }
                clientid = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                datasetJobPlacementInformation = objJobPlacementInformation.GetJobPlacementInformation(sessionId, instanceId, pageNumber, pageSize, sortExpression, Convert.ToDateTime(jobDevelopmentFrom), Convert.ToDateTime(jobDevelopmentTo), Convert.ToDateTime(jobStartBetweenFrom),
                                                                                                    Convert.ToDateTime(jobStartBetweenTo), OtherFilter, staffId, clientid);
                //GridViewProcedure.SettingsPager.PageSize = pageSize;//Set the page 
                //GridViewProcedure.DataSource = datasetJobPlacementInformation.Tables[1];
                //Extension.SetDevXGridSortIcon(sortExpression, GridViewProcedure);
                //GridViewProcedure.DataBind();
                lvJobPlacement.DataSource = datasetJobPlacementInformation.Tables[1];
                lvJobPlacement.DataBind();
            }
            return datasetJobPlacementInformation.Tables["Paging"];
        }
        private void UpdateDates()
        {
           
            if (GetFiltersCount() == 0)
            {
                Fill_DateFields();
            }
            else
            {
                jobDevelopmentFrom = GetFilterValue("JobDevelopmentFrom");
                jobDevelopmentTo = GetFilterValue("JobDevelopmentTo");
                jobStartBetweenFrom = GetFilterValue("JobStartBetweenFrom");
                jobStartBetweenTo = GetFilterValue("JobStartBetweenTo");
            }
        }

        /// <summary>
        /// Method to fill the Date Fields
        /// </summary>
        private void Fill_DateFields()
        {
            jobDevelopmentFrom = string.Format("{0:MM/dd/yyyy}", DateTime.Now.AddDays(-30));
            jobDevelopmentTo = string.Format("{0:MM/dd/yyyy}", DateTime.Now);
            jobStartBetweenFrom = string.Format("{0:MM/dd/yyyy}", DateTime.Now.AddDays(-30));
            jobStartBetweenTo = string.Format("{0:MM/dd/yyyy}", DateTime.Now);

        }
        public override string DefaultSortExpression
        {
            get
            {
                return "JobStartDate";
            }
        }
        /// <summary>
        /// Screen ID of the details page.
        /// </summary>
        public override int DetailScreenId
        {
            get
            {
                return 20551 ;
            }
           
        }

        protected void LayoutCreated(object sender, EventArgs e)
        {
            var SortExpression = ParentPageListObject.SortExpression;
            string[] Sort = SortExpression.Split(' ');

            Panel divHeader = (Panel)lvJobPlacement.FindControl("divHeader");
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
            Panel divContent = (Panel)lvJobPlacement.FindControl("divListPageContent");
            //CheckboxController1.ListPageControllerDivID = divContent.ClientID.Trim();
            divContent.Attributes.Add("onscroll", "fnScroll('#" + divHeader.ClientID + "','#" + divContent.ClientID + "');");
        }
    }
}
