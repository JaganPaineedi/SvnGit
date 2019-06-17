using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Gambling : SHS.BaseLayer.ActivityPages.DataActivityTab
{

    public override void BindControls()
    {
        using (DataView dataViewGlobalCodes = SHS.BaseLayer.BaseCommonFunctions.FillDropDown("XGAMBLINGGENERAL", true, "", "SortOrder", true))
        {
            DropDownList_CustomDocumentGambling_ThinkingAboutGambling.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_ThinkingAboutGambling.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_ThinkingAboutGambling.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_ThinkingAboutGambling.DataBind();

            DropDownList_CustomDocumentGambling_GamblingWithMoreMoney.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_GamblingWithMoreMoney.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_GamblingWithMoreMoney.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_GamblingWithMoreMoney.DataBind();

            DropDownList_CustomDocumentGambling_UnsuccessfulAttemptsToControlGambling.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_UnsuccessfulAttemptsToControlGambling.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_UnsuccessfulAttemptsToControlGambling.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_UnsuccessfulAttemptsToControlGambling.DataBind();

            DropDownList_CustomDocumentGambling_RestlessOrIrritable.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_RestlessOrIrritable.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_RestlessOrIrritable.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_RestlessOrIrritable.DataBind();

            DropDownList_CustomDocumentGambling_GambleToEscapeFromProblems.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_GambleToEscapeFromProblems.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_GambleToEscapeFromProblems.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_GambleToEscapeFromProblems.DataBind();

            DropDownList_CustomDocumentGambling_ReturningAfterLosingGamblingMoney.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_ReturningAfterLosingGamblingMoney.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_ReturningAfterLosingGamblingMoney.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_ReturningAfterLosingGamblingMoney.DataBind();

            DropDownList_CustomDocumentGambling_LieToFamily.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_LieToFamily.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_LieToFamily.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_LieToFamily.DataBind();

            DropDownList_CustomDocumentGambling_GoBeyondLegalGambling.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_GoBeyondLegalGambling.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_GoBeyondLegalGambling.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_GoBeyondLegalGambling.DataBind();

            DropDownList_CustomDocumentGambling_LoseSignificantRelationship.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_LoseSignificantRelationship.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_LoseSignificantRelationship.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_LoseSignificantRelationship.DataBind();

            DropDownList_CustomDocumentGambling_SeekHelpFromOthers.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_SeekHelpFromOthers.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_SeekHelpFromOthers.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_SeekHelpFromOthers.DataBind();

            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataBind();

            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataBind();

            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataBind();

            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                {
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                    continue;
                }
            }
        }

        using (DataView dataViewGlobalCodes = SHS.BaseLayer.BaseCommonFunctions.FillDropDown("XGAMBLING", true, "", "SortOrder", true))
        {
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol.DataBind();

            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth.DataBind();

            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram.DataBind();

            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                {
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                    continue;
                }
            }
        }
    }



}
