using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.DataServices;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using SHS.BaseLayer.ActivityPages;
namespace SHS.SmartCare
{
    public partial class Custom_Screenings_WebPages_Outcomes : DataActivityTab
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override void BindControls()
        {
            Bind_Filter_SubstanceAbuseConsumer();
            Bind_Filter_MentalHealthConsumer();
            Bind_Filter_FASDAssessment();
            Bind_Filter_EvidenceOfInjury();
            Bind_Filter_MHAndSAConsumer();
            
        }

        private void Bind_Filter_SubstanceAbuseConsumer()
        {
            DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.AddBlankRow = true;
            DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.BlankRowValue = "";
            DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.DataTextField = "CodeName";
                DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.DataBind();
                DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_MentalHealthConsumer()
        {
            DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.AddBlankRow = true;
            DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.BlankRowValue = "";
            DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.DataTextField = "CodeName";
                DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.DataBind();
                DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_EvidenceOfInjury()
        {
            DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.AddBlankRow = true;
            DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.BlankRowValue = "";
            DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.DataTextField = "CodeName";
                DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.DataBind();
                DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FASDAssessment()
        {
            DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.AddBlankRow = true;
            DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.BlankRowValue = "";
            DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.DataTextField = "CodeName";
                DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.DataBind();
                DropDownList_CustomDocumentOutComesScreenings_FASDAssessment.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_MHAndSAConsumer()
        {
            DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.AddBlankRow = true;
            DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.BlankRowValue = "";
            DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.DataTextField = "CodeName";
                DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.DataBind();
                DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer.SelectedItem.Value = "";
            }

        }

        
      
    }
}