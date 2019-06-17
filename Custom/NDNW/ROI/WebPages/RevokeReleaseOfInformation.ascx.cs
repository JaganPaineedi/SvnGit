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

public partial class ActivityPages_Client_Detail_StJoe_RevokeReleaseOf_Information : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{
    public override void BindControls()
    {
        DataSet DataSetClientInformationReleases = null;
        DataRow[] datarowScreens = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Screens.Select("ScreenId=" + SHS.BaseLayer.BaseCommonFunctions.ScreenId);
        DynamicFormsRevokeROI.FormId = Convert.ToInt32(datarowScreens[0]["CustomFieldFormId"]);
        DynamicFormsRevokeROI.Activate();
        //Binding Dropdown with ClientInformationReleases's ReleaseToName with startdate and enddate 
        DropDownList DropDownListClientInformationReleases = (DropDownList)DynamicFormsRevokeROI.FindControl("DropDownList_CustomDocumentRevokeReleaseOfInformations_ClientInformationReleaseId");
        using (SHS.UserBusinessServices.ReleaseofInformation _objectReleaseofInformation = new SHS.UserBusinessServices.ReleaseofInformation())
        {
         DataSetClientInformationReleases=   _objectReleaseofInformation.ClientInformationReleasesReleaseToName(SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
        }
        if (DataSetClientInformationReleases != null && DataSetClientInformationReleases.Tables.Contains("ClientInformationReleasesReleaseToName") && DataSetClientInformationReleases.Tables["ClientInformationReleasesReleaseToName"].Rows.Count > 0)
        {
            DropDownListClientInformationReleases.DataTextField = "ReleaseToNameWithStartDateEndDate";
            DropDownListClientInformationReleases.DataValueField = "ClientInformationReleaseId";
            DropDownListClientInformationReleases.DataSource = DataSetClientInformationReleases;
            DropDownListClientInformationReleases.DataBind();

        }
        else
        {
            DropDownListClientInformationReleases.Width = 100;
        }
        DropDownListClientInformationReleases.Items.Insert(0, "");
    }

    public override string PageDataSetName
    {
        get { return "DataSetRevokeReleaseOfInformation"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "DataSetRevokeReleaseOfInformation" }; }
    }
}
