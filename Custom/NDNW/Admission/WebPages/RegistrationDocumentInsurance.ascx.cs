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
using System.Reflection;
using System.IO;
using System.Xml;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using SHS.BaseLayer.ActivityPages;
using System.Text;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Data.SqlClient;

public partial class RegistrationDocumentInsurance : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public override void BindControls()
    {
        LoadVerificationEligibiltyControl();
        DropDownList_CustomDocumentRegistrations_HouseholdComposition.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRegistrations_HouseholdComposition.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentRegistrations_PrimarySource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRegistrations_PrimarySource.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentRegistrations_AlternativeSource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRegistrations_AlternativeSource.FillDropDownDropGlobalCodes();

        //DropDownList_CustomDocumentRegistrations_ResidenceType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomDocumentRegistrations_ResidenceType.FillDropDownDropGlobalCodes();

        var ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        DataTable dtCoverageInfo = ds.Tables["CustomRegistrationCoveragePlans"];
        var clientid = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
        var DatasetCoverageInfo = GetCoverageInformation(clientid);

        //DataTable dt = DatasetCoverageInfo.Tables["CustomInquiriesCoverageInformations"];
        if (dtCoverageInfo.Rows.Count > 0)
        {
            var AppointmentList = (from p in SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationCoveragePlans"].Copy().AsEnumerable()
                                   where p.Field<string>("RecordDeleted") != "Y"
                                   select new
                                   {
                                       RegistrationCoveragePlanId = p.Field<int>("RegistrationCoveragePlanId"),
                                       // InquiryId = p.Field<int>("InquiryId"),
                                       CoveragePlanId = p.Field<int?>("CoveragePlanId"),
                                       InsuredId = p.Field<string>("InsuredId"),
                                       GroupId = p.Field<string>("GroupId"),
                                       Comment = p.Field<string>("Comment")
                                   }).ToList();
            var ajsonSerialiser = new JavaScriptSerializer();
            var ajson = ajsonSerialiser.Serialize(AppointmentList);
            HiddenFieldAppointments.Value = ajson.ToString();
        }
        else
        {
            HiddenFieldAppointments.Value = "";
        }
        DataTable dtCoveragePlans = DatasetCoverageInfo.Tables["CoveragePlans"];

        if (dtCoveragePlans != null && dtCoveragePlans.Rows.Count > 0)
        {
            var PlanList = (from p in dtCoveragePlans.AsEnumerable()
                            select new
                            {
                                CoveragePlanId = p.Field<int>("CoveragePlanId"),
                                PlanName = p.Field<string>("DisplayAs"),
                                IsSelected = p.Field<string>("IsSelected")
                            }).ToList();
            var pajsonSerialiser = new JavaScriptSerializer();
            var paajson = pajsonSerialiser.Serialize(PlanList);
            HiddenFieldsPlan.Value = paajson.ToString();
        }
        else
        {
            HiddenFieldsPlan.Value = "";
        }
    }
    private void LoadVerificationEligibiltyControl()
    {
        //int inquiryid;
        //if (Int32.TryParse(Convert.ToString(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationCoveragePlans"].Rows[0]["DocumentVersionId"]), out inquiryid))
        //{
        //    eev1.InquiryId = inquiryid;
        //}
    }

    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentRegistrations", "CustomRegistrationCoveragePlans" };
        }
    }

    public DataSet GetCoverageInformation(int clientid)
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetMemberInformation = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@clientid", clientid);
        dataSetMemberInformation = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetRegCoverageInformation", dataSetMemberInformation, new string[] { "CoveragePlans" }, _objectSqlParmeters);
        return dataSetMemberInformation;
    }
}