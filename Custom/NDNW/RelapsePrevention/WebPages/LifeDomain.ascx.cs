using System;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data.Linq.SqlClient;
using System.Xml.Linq;
using System.Web.Script.Serialization;
using SHS.BaseLayer.ActivityPages;



public partial class Custom_RelapsePrevention_WebPages_LifeDomain : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
       
        DataView dvSeverity = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dvSeverity.RowFilter = "Category = 'Xlifedomain' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dvSeverity.Sort = "SortOrder ASC";
        DropDownList_CustomRelapseLifeDomains_LifeDomain.DataSource = dvSeverity;
        DropDownList_CustomRelapseLifeDomains_LifeDomain.DataTextField = "CodeName";
        DropDownList_CustomRelapseLifeDomains_LifeDomain.DataValueField = "GlobalCodeId";
        DropDownList_CustomRelapseLifeDomains_LifeDomain.DataBind();
        DropDownList_CustomRelapseLifeDomains_LifeDomain.Items.Insert(0, new ListItem("", ""));


        DataView dvGoalstatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dvGoalstatus.RowFilter = "Category = 'Xrelapsegoalstatus' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dvGoalstatus.Sort = "SortOrder ASC";
        DropDownList_CustomRelapseGoals_RelapseGoalStatus.DataSource = dvGoalstatus;
        DropDownList_CustomRelapseGoals_RelapseGoalStatus.DataTextField = "CodeName";
        DropDownList_CustomRelapseGoals_RelapseGoalStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomRelapseGoals_RelapseGoalStatus.DataBind();
        DropDownList_CustomRelapseGoals_RelapseGoalStatus.Items.Insert(0, new ListItem("", ""));


        DataView dvObjectiveStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dvObjectiveStatus.RowFilter = "Category = 'Xrelapseobjstatus' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dvObjectiveStatus.Sort = "SortOrder ASC";
        DropDownList_CustomRelapseObjectives_ObjectiveStatus.DataSource = dvObjectiveStatus;
        DropDownList_CustomRelapseObjectives_ObjectiveStatus.DataTextField = "CodeName";
        DropDownList_CustomRelapseObjectives_ObjectiveStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomRelapseObjectives_ObjectiveStatus.DataBind();
        DropDownList_CustomRelapseObjectives_ObjectiveStatus.Items.Insert(0, new ListItem("", ""));



        DataView dvactionstepStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dvactionstepStatus.RowFilter = "Category = 'Xactionstepstatus' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dvactionstepStatus.Sort = "SortOrder ASC";
        DropDownList_CustomRelapseActionSteps_ActionStepStatus.DataSource = dvactionstepStatus;
        DropDownList_CustomRelapseActionSteps_ActionStepStatus.DataTextField = "CodeName";
        DropDownList_CustomRelapseActionSteps_ActionStepStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomRelapseActionSteps_ActionStepStatus.DataBind();
        DropDownList_CustomRelapseActionSteps_ActionStepStatus.Items.Insert(0, new ListItem("", ""));

        //DataSet datasetLifeDomain = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;

        //var LifeDomain = (from p in datasetLifeDomain.Tables["CustomRelapseLifeDomains"].AsEnumerable()
        //             where p.Field<string>("RecordDeleted") != "Y"
        //             select new
        //             {
        //                 RelapseLifeDomainId = p.Field<int?>("RelapseLifeDomainId"),
        //                 LifeDomainDetail = p.Field<string>("LifeDomainDetail"),
        //                 LifeDomainDate = p.Field<DateTime?>("LifeDomainDate") == null ? "" : Convert.ToDateTime(p.Field<DateTime?>("LifeDomainDate")).ToString("MM/dd/yyyy"),
        //                 LifeDomain = p.Field<int>("LifeDomain"),
        //                 Resources = p.Field<string>("Resources"),
        //                 Barriers = p.Field<string>("Barriers")
        //             }).ToList();



    }

    public void BindLifeDoaminTemplate(string filter)
    {
    }



}



