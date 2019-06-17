using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class ASAM4 : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        FillLevelOfCareName();
    }

    /// <summary>
    /// Method For filling LevelOfCareName in DropdownList from Shared Tables
    /// </summary>
    /// <returns></returns>
    /// Created By Jitender
    private void FillLevelOfCareName()
    {
        /*if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomASAMLevelOfCares != null)
        {
            DataSet datasetLevelOfCareName = new DataSet();
            DataView DataViewLevelOfCareName = null;
            datasetLevelOfCareName.Tables.Add(SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomASAMLevelOfCares.Copy());
            if (datasetLevelOfCareName != null)
            {
                if (datasetLevelOfCareName.Tables.Count > 0 && datasetLevelOfCareName.Tables["CustomASAMLevelOfCares"].Rows.Count > 0)
                {
                    if (datasetLevelOfCareName.Tables.Contains("CustomASAMLevelOfCares") == true)
                    {
                        DataViewLevelOfCareName = datasetLevelOfCareName.Tables["CustomASAMLevelOfCares"].DefaultView;
                        //dataViewDocumentCodes.RowFilter = "Active='Y'";
                        DropDownList_CustomASAMPlacements_FinalPlacement.DataTextField = "LevelOfCareName";
                        DropDownList_CustomASAMPlacements_FinalPlacement.DataValueField = "ASAMLevelOfCareId";
                        DropDownList_CustomASAMPlacements_FinalPlacement.DataSource = DataViewLevelOfCareName;
                        DropDownList_CustomASAMPlacements_FinalPlacement.DataBind();
                        //DropDownList_ASAMLevelOfCares_LevelOfCareName.Items.Insert(0, "");
                        DropDownList_CustomASAMPlacements_FinalPlacement.Items.Insert(0, new ListItem("", ""));
                    }
                }
            }
        }
         * */

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
        {
            DataView dataViewLevelofCare = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewLevelofCare.RowFilter = "Category='XLEVELOFCARE' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'"; 
            dataViewLevelofCare.Sort = "CodeName";

            DropDownList_CustomASAMPlacements_FinalPlacement.DataTextField = "CodeName";
            DropDownList_CustomASAMPlacements_FinalPlacement.DataValueField = "GlobalCodeId";
            DropDownList_CustomASAMPlacements_FinalPlacement.DataSource = dataViewLevelofCare;
            DropDownList_CustomASAMPlacements_FinalPlacement.DataBind();
            DropDownList_CustomASAMPlacements_FinalPlacement.Items.Insert(0, new ListItem("", ""));

        }
    }
}
