using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricEvaluation_WebPages_Exam : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
            {
                DataView dataViewStaffs = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.DataTextField = "StaffName";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.DataValueField = "StaffId";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.DataSource = dataViewStaffs;
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.DataBind();

                ListItem item = new ListItem(" ", "");
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.Items.Insert(0, item);
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1.SelectedValue = "";

                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.DataTextField = "StaffName";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.DataValueField = "StaffId";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.DataSource = dataViewStaffs;
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.DataBind();

                item = new ListItem(" ", "");
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.Items.Insert(0, item);
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2.SelectedValue = "";

                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.DataTextField = "StaffName";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.DataValueField = "StaffId";
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.DataSource = dataViewStaffs;
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.DataBind();

                item = new ListItem(" ", "");
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.Items.Insert(0, item);
                DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3.SelectedValue = "";
            }
        }
    }
}