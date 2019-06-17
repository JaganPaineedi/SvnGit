using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using SHS.BaseLayer;

public partial class RegistrationDocumentDemographics : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    ///<summary>
    ///<Description>This Function is used to bind form id of DFA
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>Aug 25,2011</CreatedOn>
    ///</summary>
    ///
   
    public override void BindControls()
    {
        //DynamicFormsDemographics.FormId = 82;
        //DynamicFormsDemographics.Activate();
        DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewPrograms.RowFilter = "Category='SEX' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";        
        DownList_CustomDocumentRegistrations_Sex.DataTextField = "CodeName";
        DownList_CustomDocumentRegistrations_Sex.DataValueField = "GlobalCodeId";
        DownList_CustomDocumentRegistrations_Sex.DataSource = dataViewPrograms;
        DownList_CustomDocumentRegistrations_Sex.DataBind();
        dataViewPrograms.RowFilter = "Category='MARITALSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        DownList_CustomDocumentRegistrations_MaritalStatus.DataTextField = "CodeName";
        DownList_CustomDocumentRegistrations_MaritalStatus.DataValueField = "GlobalCodeId";
        DownList_CustomDocumentRegistrations_MaritalStatus.DataSource = dataViewPrograms;
        DownList_CustomDocumentRegistrations_MaritalStatus.DataBind();
        dataViewPrograms.RowFilter = "Category='XCOMMMETHOD' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        DropDownList_CustomDocumentRegistrations_PrimayMethodOfCommunication.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_PrimayMethodOfCommunication.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_PrimayMethodOfCommunication.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_PrimayMethodOfCommunication.DataBind();
        dataViewPrograms.RowFilter = "Category='XINTERPRETERNEEDED' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        DropDownList_CustomDocumentRegistrations_InterpreterNeeded.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_InterpreterNeeded.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_InterpreterNeeded.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_InterpreterNeeded.DataBind();
        dataViewPrograms.RowFilter = "Category='XTRIBALAFFILIATION' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "CodeName ASC";
        DropDownList_CustomDocumentRegistrations_TribalAffiliation.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_TribalAffiliation.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_TribalAffiliation.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_TribalAffiliation.DataBind();
        dataViewPrograms.RowFilter = "Category='LANGUAGE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "CodeName ASC";
        DropDownList_CustomDocumentRegistrations_PrimaryLanguage.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_PrimaryLanguage.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_PrimaryLanguage.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_PrimaryLanguage.DataBind();
        dataViewPrograms.RowFilter = "Category='XSECODARYLANGUAGE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "CodeName ASC";
        DropDownList_CustomDocumentRegistrations_SecondaryLanguage.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_SecondaryLanguage.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_SecondaryLanguage.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_SecondaryLanguage.DataBind();
        dataViewPrograms.RowFilter = "Category='HISPANICORIGIN' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        DropDownList_CustomDocumentRegistrations_HispanicOrigin.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_HispanicOrigin.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_HispanicOrigin.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_HispanicOrigin.DataBind();
        dataViewPrograms.RowFilter = "Category='RACE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        DropDownList_CustomDocumentRegistrations_Race.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_Race.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_Race.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_Race.DataBind();
        dataViewPrograms.RowFilter = "Category='XPATIENTTYPE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        //DropDownList_CustomDocumentRegistrations_PatientType.DataTextField = "CodeName";
        //DropDownList_CustomDocumentRegistrations_PatientType.DataValueField = "GlobalCodeId";
        //DropDownList_CustomDocumentRegistrations_PatientType.DataSource = dataViewPrograms;
        //DropDownList_CustomDocumentRegistrations_PatientType.DataBind();
        Bind_Filter_States();
        Bind_Filter_Counties();
        using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("CLIENTNAMESUFFIX", true, "", "", true))
        //using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("suffix", true, "", "", true))
        {
            DropDownList_CustomDocumentRegistrations_Suffix.DataTextField = "CodeName";
            DropDownList_CustomDocumentRegistrations_Suffix.DataValueField = "CodeName";
            DropDownList_CustomDocumentRegistrations_Suffix.DataSource = DataViewGlobalCodes;
            DropDownList_CustomDocumentRegistrations_Suffix.DataBind();
        }
    }

    private void Bind_Filter_Counties()
    {
        int stateFips = -1;
        //Added By Vikas Vyas in ref to task #1038
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations != null)
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"] != DBNull.Value)
            {
                stateFips = Convert.ToInt32(SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"]);
            }
        }

        DataView dataViewCounties = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Counties);
        dataViewCounties.RowFilter = "StateFIPS=" + stateFips;
        dataViewCounties.Sort = "CountyName";
        DropDownList_CustomDocumentRegistrations_ResidenceCounty.DataTextField = "CountyName";
        DropDownList_CustomDocumentRegistrations_ResidenceCounty.DataValueField = "CountyFIPS";
        DropDownList_CustomDocumentRegistrations_ResidenceCounty.DataSource = dataViewCounties;
        DropDownList_CustomDocumentRegistrations_ResidenceCounty.DataBind();

        DropDownList_CustomDocumentRegistrations_CountyOfTreatment.DataTextField = "CountyName";
        DropDownList_CustomDocumentRegistrations_CountyOfTreatment.DataValueField = "CountyFIPS";
        DropDownList_CustomDocumentRegistrations_CountyOfTreatment.DataSource = dataViewCounties;
        DropDownList_CustomDocumentRegistrations_CountyOfTreatment.DataBind();
    }

    private void Bind_Filter_States()
    {
        DataView dataViewStates = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.States);
        dataViewStates.Sort = "StateName";
        DropDownList_CustomDocumentRegistrations_State.DataTextField = "StateName";
        DropDownList_CustomDocumentRegistrations_State.DataValueField = "StateAbbreviation";
        DropDownList_CustomDocumentRegistrations_State.DataSource = dataViewStates;
        DropDownList_CustomDocumentRegistrations_State.DataBind();
    }



    public override string[] TablesUsedInTab
    {
        get
        {
            string TableName = "";

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms != null)
            {
                DataRow[] dr = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms.Select("FormId=" + 82);
                if (dr != null && dr.Length > 0)
                {
                    TableName = Convert.ToString(dr[0]["TableName"]);
                }

            }
            return new string[] { TableName };
        }
    }


}
