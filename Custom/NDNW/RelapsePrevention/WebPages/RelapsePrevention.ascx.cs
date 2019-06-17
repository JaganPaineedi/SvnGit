using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;
using SHS.BaseLayer;
using SHS.DataServices;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer.ActivityPages;

public partial class Custom_RelapsePrevention_WebPages_RelapsePrevention : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{

    public override string DefaultTab
    {
        get { return "/Custom/RelapsePrevention/WebPages/RelapsePreventionplan.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "RadMultiPageRelapsePreventionMainTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ctlcollection = this.RadMultiPageRelapsePreventionMainTabPage.Controls[TabIndex].Controls;
        RadMultiPageRelapsePreventionMainTabPage.SelectedIndex = (short)TabIndex;
        RadTabStrip1RelapsePreventionMainTabPage.SelectedIndex = (short)TabIndex;
        UcPath = RadTabStrip1RelapsePreventionMainTabPage.Tabs[TabIndex].Attributes["Path"];
    }

    public override void BindControls()
    {
        DataSet DatasetLifeDomain = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        DataTable dt = DatasetLifeDomain.Tables["CustomRelapseLifeDomains"];
        DataTable dtgoals = DatasetLifeDomain.Tables["CustomRelapseGoals"];
        DataTable dtobjectives = DatasetLifeDomain.Tables["CustomRelapseObjectives"];
        DataTable dtactions = DatasetLifeDomain.Tables["CustomRelapseActionSteps"];
        var LifeDomain = (from p in dt.AsEnumerable()
                          where p.Field<string>("RecordDeleted") != "Y"
                          select new
                          {
                              Id = p.Field<int>("Id"),
                              RelapseLifeDomainId = p.Field<int>("RelapseLifeDomainId"),
                              DocumentVersionId = p.Field<int>("DocumentVersionId"),
                              LifeDomainDetail = p.Field<string>("LifeDomainDetail"),
                              LifeDomainDate = p.Field<DateTime?>("LifeDomainDate") == null ? "" : Convert.ToDateTime(p.Field<DateTime?>("LifeDomainDate")).ToString("MM/dd/yyyy"),
                              LifeDomain = p.Field<int?>("LifeDomain"),
                              Resources = p.Field<string>("Resources"),
                              Barriers = p.Field<string>("Barriers"),
                              LifeDomainNumber = p.Field<int?>("LifeDomainNumber"),
                              objectListMemberService = (from M in dtgoals.AsEnumerable()
                                                         where M.Field<string>("RecordDeleted") != "Y" && M.Field<int>("RelapseLifeDomainId") == p.Field<int>("RelapseLifeDomainId")
                                                         select new
                                                         {
                                                             RelapseGoalId = M.Field<int>("RelapseGoalId"),
                                                             RelapseGoalStatus = M.Field<int?>("RelapseGoalStatus"),
                                                             ProjectedDate = M.Field<DateTime?>("ProjectedDate") == null ? "" : Convert.ToDateTime(M.Field<DateTime?>("ProjectedDate")).ToString("MM/dd/yyyy"),
                                                             MyGoal = M.Field<string>("MyGoal"),
                                                             AchievedThisGoal = M.Field<string>("AchievedThisGoal"),
                                                             GoalNumber = M.Field<string>("GoalNumber"),
                                                             objectListobjectiveService = (from O in dtobjectives.AsEnumerable()
                                                                                           where O.Field<string>("RecordDeleted") != "Y" && O.Field<int>("RelapseGoalId") == M.Field<int>("RelapseGoalId")
                                                                                           select new
                                                                                           {
                                                                                               RelapseObjectiveId = O.Field<int>("RelapseObjectiveId"),
                                                                                               ObjectiveStatus = O.Field<int?>("ObjectiveStatus"),
                                                                                               ObjectivesCreateDate = O.Field<DateTime?>("ObjectivesCreateDate") == null ? "" : Convert.ToDateTime(O.Field<DateTime?>("ObjectivesCreateDate")).ToString("MM/dd/yyyy"),
                                                                                               RelapseObjectives = O.Field<string>("RelapseObjectives"),
                                                                                               IWillAchieve = O.Field<string>("IWillAchieve"),
                                                                                               ExpectedAchieveDate = O.Field<DateTime?>("ExpectedAchieveDate") == null ? "" : Convert.ToDateTime(O.Field<DateTime?>("ExpectedAchieveDate")).ToString("MM/dd/yyyy"),
                                                                                               ResolutionDate = O.Field<DateTime?>("ResolutionDate") == null ? "" : Convert.ToDateTime(O.Field<DateTime?>("ResolutionDate")).ToString("MM/dd/yyyy"),
                                                                                               ObjectivesNumber = O.Field<string>("ObjectivesNumber"),
                                                                                               objectListActionService = (from A in dtactions.AsEnumerable()
                                                                                                                          where A.Field<string>("RecordDeleted") != "Y" && A.Field<int>("RelapseObjectiveId") == O.Field<int>("RelapseObjectiveId")
                                                                                                                          select new
                                                                                                                          {
                                                                                                                              RelapseActionStepId = A.Field<int>("RelapseActionStepId"),
                                                                                                                              RelapseActionSteps = A.Field<string>("RelapseActionSteps"),
                                                                                                                              CreateDate = A.Field<DateTime?>("CreateDate") == null ? "" : Convert.ToDateTime(A.Field<DateTime?>("CreateDate")).ToString("MM/dd/yyyy"),
                                                                                                                              ActionStepStatus = A.Field<int?>("ActionStepStatus"),                                                                                                                         
                                                                                                                              ToAchieveMyGoal = A.Field<string>("ToAchieveMyGoal"),
                                                                                                                              ActionStepNumber = A.Field<string>("ActionStepNumber")


                                                                                                                          }).ToList()
                                                                                           }).ToList()
                                                         }).ToList()
                          }).ToList();




        var ajsonSerialiser = new JavaScriptSerializer();
        var pjsonSerialiser = new JavaScriptSerializer();
        var ajson = pjsonSerialiser.Serialize(LifeDomain);
        HiddenFieldLifeDomain.Value = ajson.ToString();

    }

    public override string PageDataSetName
    {
        get { return "DatasetRelapsePreventions"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentRelapsePreventions" }; }
    }
}




