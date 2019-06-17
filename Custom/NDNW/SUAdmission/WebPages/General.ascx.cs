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
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Text;
using SHS.BaseLayer.BasePages;


public partial class Custom_SUAdmission_WebPages_General : SHS.BaseLayer.ActivityPages.DataActivityTab
{

    public override void BindControls()
    {
        //throw new NotImplementedException();
        Getcurrentdatetime();
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs != null)
        {
            DataView dataViewPrograms = SHS.BaseLayer.SharedTables.GetSharedTableProgram();
            DropDownList_CustomDocumentSUAdmissions_ProgramId.DataTextField = "ProgramCode";
            DropDownList_CustomDocumentSUAdmissions_ProgramId.DataValueField = "ProgramId";
            DropDownList_CustomDocumentSUAdmissions_ProgramId.DataSource = dataViewPrograms;
            DropDownList_CustomDocumentSUAdmissions_ProgramId.DataBind();
            DropDownList_CustomDocumentSUAdmissions_ProgramId.Items.Insert(0, new ListItem("", ""));
            DropDownList_CustomDocumentSUAdmissions_ProgramId.SelectedIndex = 0;
        }
        
        DropDownList_CustomDocumentSUAdmissions_AdmissionType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_AdmissionType.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_EducationCompleted.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_EducationCompleted.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_AdmissionProgramType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_AdmissionProgramType.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_ReferralSource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_ReferralSource.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_SourceOfPayment.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_SourceOfPayment.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_PriorEpisode.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_PriorEpisode.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_SocialSupports.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_SocialSupports.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_VeteransStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_VeteransStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_AdmittedASAM.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_AdmittedASAM.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_ReferredASAM.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_ReferredASAM.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_StateCode.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_StateCode.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_DrugCourtParticipation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_DrugCourtParticipation.FillDropDownDropGlobalCodes();

        //DropDownList_CustomDocumentSUAdmissions_DoraStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomDocumentSUAdmissions_DoraStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_LivingArrangement.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_LivingArrangement.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_EnrolledEducation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_EnrolledEducation.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_PrimarySourceOfIncome.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_PrimarySourceOfIncome.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_MaritalStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_MaritalStatus.FillDropDownDropGlobalCodes();    
 
        DropDownList_CustomDocumentSUAdmissions_Gender.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Gender.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_EmploymentStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_EmploymentStatus.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_Race.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Race.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Ethnicity.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Ethnicity.FillDropDownDropGlobalCodes();

        
        

    }


    public void Getcurrentdatetime()
    {
        String Dt = DateTime.Now.ToString("MM/dd/yyyy HH:mm tt");
        CurrentdatetimeText.Text = Dt;

    }
}
