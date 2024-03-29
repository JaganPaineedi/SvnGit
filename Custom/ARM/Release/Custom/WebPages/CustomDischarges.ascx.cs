﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data;

namespace SHS.SmartCare
{
    public partial class CustomDischarges : DataActivityTab
    {

        public override void BindControls()
        {
            Bind_Control_Expires();
        }
        private void Bind_Control_Expires()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewExpires = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewExpires.RowFilter = "Category like 'XREFERRALPREFERENCE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewExpires.Sort = "CodeName";
                
                DropDownList_CustomDocumentDischarges_ReferralPreference1.DataTextField = "CodeName";
                DropDownList_CustomDocumentDischarges_ReferralPreference1.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentDischarges_ReferralPreference1.DataSource = dataViewExpires;
                DropDownList_CustomDocumentDischarges_ReferralPreference1.DataBind();
                DropDownList_CustomDocumentDischarges_ReferralPreference2.DataTextField = "CodeName";
                DropDownList_CustomDocumentDischarges_ReferralPreference2.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentDischarges_ReferralPreference2.DataSource = dataViewExpires;
                DropDownList_CustomDocumentDischarges_ReferralPreference2.DataBind();
                DropDownList_CustomDocumentDischarges_ReferralPreference3.DataTextField = "CodeName";
                DropDownList_CustomDocumentDischarges_ReferralPreference3.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentDischarges_ReferralPreference3.DataSource = dataViewExpires;
                DropDownList_CustomDocumentDischarges_ReferralPreference3.DataBind();

                DataView dataViewReasonfordischarge = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewReasonfordischarge.RowFilter = "Category like 'XDISCHARGEREASON' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewReasonfordischarge.Sort = "CodeName";
                DropDownList_CustomDocumentDischarges_ReasonForDischargeCode.DataTextField = "CodeName";
                DropDownList_CustomDocumentDischarges_ReasonForDischargeCode.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentDischarges_ReasonForDischargeCode.DataSource = dataViewReasonfordischarge;
                DropDownList_CustomDocumentDischarges_ReasonForDischargeCode.DataBind();

                DataView dataViewInitialLevelofCare = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewInitialLevelofCare.RowFilter = "Category like 'XLEVELOFCARE' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewInitialLevelofCare.Sort = "CodeName";
                DropDownGlobalCodes_CustomDocumentDischarges_InitialLevelofCare.DataTextField = "CodeName";
                DropDownGlobalCodes_CustomDocumentDischarges_InitialLevelofCare.DataValueField = "GlobalCodeId";
                DropDownGlobalCodes_CustomDocumentDischarges_InitialLevelofCare.DataSource = dataViewInitialLevelofCare;
                DropDownGlobalCodes_CustomDocumentDischarges_InitialLevelofCare.DataBind();
                DropDownGlobalCodes_CustomDocumentDischarges_InitialLevelofCare.Items.Insert(0, new ListItem("", ""));

                DataView dataViewDischargeLevelofCare = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewDischargeLevelofCare.RowFilter = "Category like 'XLEVELOFCARE' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewDischargeLevelofCare.Sort = "CodeName";
                DropDownGlobalCodes_CustomDocumentDischarges_DischargeLevelofCare.DataTextField = "CodeName";
                DropDownGlobalCodes_CustomDocumentDischarges_DischargeLevelofCare.DataValueField = "GlobalCodeId";
                DropDownGlobalCodes_CustomDocumentDischarges_DischargeLevelofCare.DataSource = dataViewDischargeLevelofCare;
                DropDownGlobalCodes_CustomDocumentDischarges_DischargeLevelofCare.DataBind();
                DropDownGlobalCodes_CustomDocumentDischarges_DischargeLevelofCare.Items.Insert(0, new ListItem("", ""));
                  

            }
            
        }
        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "CustomDocumentDischarges" };
            }            
        }

        
    }



}
