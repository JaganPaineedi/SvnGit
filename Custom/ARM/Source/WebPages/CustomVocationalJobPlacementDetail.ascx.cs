#region Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//=========================================================================================
// Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    CustomVocationalJobPlacementDetail.ascx.cs
//
// Author:      Vaibhav Khare
// Date:        08 jun 2011
//=========================================================================================
#endregion


using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using SHS.BaseLayer;
using System.Data;
using System.Configuration;
using System.Web.UI.WebControls.WebParts;
using SHS.UserBusinessServices;
using SHS.BaseLayer.ActivityPages;
namespace SHS.SmartCare
{
    public partial class CustomVocationalJobPlacementDetail : SHS.BaseLayer.ActivityPages.DataActivityPage
    {
        private string strExistingProgramStatus = null;
        private int countOfPrograms;
        public override void BindControls()
        {
            Bind_Control_Expires();

        }
        public override void AddMandatoryValues(DataRow dataRow, string tableName)
        {
            switch (tableName)
            {
                case "CustomVocationalJobPlacements":
                    {
                       //
                       dataRow.Table.DataSet.Tables[tableName].Columns["CustomVocationalJobPlacementId"].ReadOnly = false;
                       dataRow["CustomVocationalJobPlacementId"] = -1;
                        int clientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                        dataRow["ClientId"] = clientId;
                      //  dataRow["JobPlacementDate"] = string.Format("{0:MM/dd/yyyy}", DateTime.Now);
                       // dataRow["ProgramId"] = Session["NewDefaultProgram"] == null ? -1 : Session["NewDefaultProgram"];
                       // dataRow["PrimaryAssignment"] = "N";
                    }
                    break;
                
            }

        }

        //private void Bind_Filter_Others()
        //{
        //    string OtherFilter = string.Empty;
        //    int Count = 0;
        //    DataView dataViewOthers = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        //    dataViewOthers.Sort = "SortOrder,CodeName";
        //    DropDownList_Referredby.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //    DropDownList_Referredby.FillDropDownDropSubGlobalCodes();
        //    OtherFilter = DropDownList_Referredby.SelectedItem.Text.ToString();
        //    Count = DropDownList_Referredby.Items.Count;
          
        //}

        private void Bind_Control_Expires()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                //DataView dataViewExpires = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                //dataViewExpires.RowFilter = "Category like 'XVOCREFEREDBY' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                //dataViewExpires.Sort = "SortOrder ";
                //DropDownList_GlobalCodes_CodeName.DataTextField = "CodeName";
                //DropDownList_GlobalCodes_CodeName.DataValueField = "GlobalCodeId";
                //DropDownList_GlobalCodes_CodeName.DataSource = dataViewExpires;
                //DropDownList_GlobalCodes_CodeName.DataBind();


                DataView dataViewExpires = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewExpires.RowFilter = "Category like 'XVOCREFEREDBY' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewExpires.Sort = "CodeName";
                //DropDownList_CustomVocationalJobPlacements_ReferredBy.Items.Add(new ListItem("", "-1"));
                DropDownList_CustomVocationalJobPlacements_ReferredBy.DataTextField = "CodeName";
                DropDownList_CustomVocationalJobPlacements_ReferredBy.DataValueField = "GlobalCodeId";
                DropDownList_CustomVocationalJobPlacements_ReferredBy.DataSource = dataViewExpires;
                DropDownList_CustomVocationalJobPlacements_ReferredBy.DataBind();
                



                dataViewExpires.RowFilter = "Category like 'XVOCPLACEMENTSHIFT' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewExpires.Sort = "CodeName";
                //DropDownList_CustomVocationalJobPlacements_JobShift.Items.Add(new ListItem("", "-1"));
               // DropDownList_CustomVocationalJobPlacements_JobShift.Items.Add(new ListItem("Select", ""));
                DropDownList_CustomVocationalJobPlacements_JobShift.DataTextField = "CodeName";
                DropDownList_CustomVocationalJobPlacements_JobShift.DataValueField = "GlobalCodeId";
                DropDownList_CustomVocationalJobPlacements_JobShift.DataSource = dataViewExpires;
                DropDownList_CustomVocationalJobPlacements_JobShift.DataBind();
               


                dataViewExpires.RowFilter = "Category like 'XVOCJOBLOSSREASON' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewExpires.Sort = "CodeName";
                //DropDownList_CustomVocationalJobPlacements_JobShift.Items.Add(new ListItem("", "-1"));
                DropDownList_CustomVocationalJobPlacements_JobLossReason.DataTextField = "CodeName";
                DropDownList_CustomVocationalJobPlacements_JobLossReason.DataValueField = "GlobalCodeId";
                DropDownList_CustomVocationalJobPlacements_JobLossReason.DataSource = dataViewExpires;
                DropDownList_CustomVocationalJobPlacements_JobLossReason.DataBind();
                DataTable dataTableStaff = new DataTable("Table");
                dataTableStaff.Columns.Add("StaffID", System.Type.GetType("System.Int32"));
                dataTableStaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                //dataTableStaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));


                DataRow[] dataViewExpiresStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.Select("Clinician = 'Y'  and ISNULL(RecordDeleted,'N')<>'Y' ");
                //dataViewExpiresStaff.RowFilter = "Clinician = 'Y'  and ISNULL(RecordDeleted,'N')<>'Y' ";
                DataRow dataRowObject = dataTableStaff.NewRow();
                string signerName = string.Empty;
                for (int counter1 = 0; counter1 < dataViewExpiresStaff.Length; counter1++)
                {
                    dataRowObject = dataTableStaff.NewRow();
                    dataRowObject["StaffID"] = dataViewExpiresStaff[counter1]["StaffId"];
                    signerName = Convert.ToString(dataViewExpiresStaff[counter1]["LastName"]).Trim() + ", " + Convert.ToString(dataViewExpiresStaff[counter1]["FirstName"]).Trim();
                    dataRowObject["StaffName"] = signerName;
                    dataTableStaff.Rows.Add(dataRowObject);
                }
                DataView dataViewStaff = new DataView(dataTableStaff);
                dataViewStaff.Sort = "StaffName";
                //Clinician = 'Y'  and 
               // dataViewExpiresStaff.Sort = "FirstName DESC ";
                //Commented by Veena on 13/01/2012
                //DropDownList_CustomVocationalJobPlacements_PlacedBy.DataTextField = "StaffName";
                //DropDownList_CustomVocationalJobPlacements_PlacedBy.DataValueField = "StaffId";
                //DropDownList_CustomVocationalJobPlacements_PlacedBy.DataSource = dataViewStaff;
                //DropDownList_CustomVocationalJobPlacements_PlacedBy.DataBind();


                using (SHS.UserBusinessServices.DetailPages objectCpt = new SHS.UserBusinessServices.DetailPages())
                {
                    DataSet dstGetVocationalPlacedByList = new DataSet();

                    dstGetVocationalPlacedByList = objectCpt.GetVocationalPlacedByList();
                    //DropDownList_CustomVocationalJobPlacements_PlacedBy

                    DropDownList_CustomVocationalJobPlacements_PlacedBy.DataSource = dstGetVocationalPlacedByList.Tables["VocationalPlacedByList"];

                    DropDownList_CustomVocationalJobPlacements_PlacedBy.DataTextField = "FirstName";
                    DropDownList_CustomVocationalJobPlacements_PlacedBy.DataValueField = "StaffId";
                    DropDownList_CustomVocationalJobPlacements_PlacedBy.DataBind();
                    // DropDownList_CustomVocationalJobPlacements_PlacedBy.Items.Add(new ListItem("", "-1"));
                }
            }

        }


        public override string PageDataSetName
        {
            get { return "DataSetCustomVocationalJobPlacementDetail"; }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomVocationalJobPlacements" };
            }

        }
        
        /// <summary>
        /// Update the dataset object by fetching from the database.
        /// </summary>
        /// <returns>Dataset object.</returns>
        public override DataSet GetData()
        {
            int CustomVocationalJobPlacementId = -1;
            using (SHS.UserBusinessServices.DetailPages objectCpt = new SHS.UserBusinessServices.DetailPages())
            {

                if (base.GetRequestParameterValue("CustomVocationalJobPlacementId").Length > 0)
                {
                    int.TryParse(base.GetRequestParameterValue("CustomVocationalJobPlacementId"), out CustomVocationalJobPlacementId);
                }
                else // Get AuthorizationcodeId after save
                {
                    if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet != null)
                    {
                        if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomVocationalJobPlacements"].Rows[0]["CustomVocationalJobPlacementId"] != null)
                        {
                            int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomVocationalJobPlacements"].Rows[0]["CustomVocationalJobPlacementId"].ToString(), out CustomVocationalJobPlacementId);
                        }
                    }
                }
                System.Data.DataSet dataSetCustomVocationalJobPlacement = new System.Data.DataSet();
                dataSetCustomVocationalJobPlacement = (SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet(PageDataSetName));

                DataSet dataSetObject = null;
                if (CustomVocationalJobPlacementId >= 0)
                {
                    dataSetObject = objectCpt.GetJobPlacementDetails(CustomVocationalJobPlacementId);
                    HiddenField_CustomVocationalJobPlacements_CustomVocationalJobPlacementId.Value = dataSetObject.Tables["CustomVocationalJobPlacements"].Rows[0]["CustomVocationalJobPlacementId"].ToString();
                   
                    //if (dataSetObject.Tables["ClientPrograms"].Rows[0]["PrimaryAssignment"].ToString() == "Y")
                    //    CheckBox_ClientPrograms_PrimaryAssignment.Checked = true;
                    //else
                    //    CheckBox_ClientPrograms_PrimaryAssignment.Checked = false;

                }
                

                if (dataSetObject != null)
                {
                    if (!dataSetObject.IsRowExists("CustomVocationalJobPlacements"))
                        dataSetObject = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet = base.DocumentInitializeDocument();

                    try
                    {
                        dataSetCustomVocationalJobPlacement.Merge(dataSetObject);
                    }
                    catch
                    {
                        dataSetCustomVocationalJobPlacement.Merge(dataSetObject);
                    }
                }

                SHS.BaseLayer.BaseCommonFunctions.UnsavedProcessDetailPage(this.ParentDetailPageObject.UnSavedChangeId, 0, this.ParentDetailPageObject.ScreenId, SHS.BaseLayer.SharedTables.StaffSharedTables.UnsavedChanges, this.ParentDetailPageObject, dataSetObject, dataSetCustomVocationalJobPlacement, PageDataSetName);
                return dataSetCustomVocationalJobPlacement;
            }
        }

         public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            //if (dataSetObject.Tables.Contains("Clients"))
            //    dataSetObject.Tables.Remove("Clients");
            //if (dataSetObject.Tables.Contains("ARLedger"))
            //    dataSetObject.Tables.Remove("ARLedger");
            // if (dataSetObject.Tables.Contains("FinancialActivityLines"))
            //    dataSetObject.Tables.Remove("FinancialActivityLines");

            // if (dataSetObject.Tables.Contains("BillingHistory"))
            //    dataSetObject.Tables.Remove("BillingHistory");

             //if (dataSetObject.Tables.Contains("ChargeErrors"))
             //   dataSetObject.Tables.Remove("ChargeErrors");


        }
    }
}
    
//        public override string[] TablesToBeInitialized
//        {
//            get { return _tableNames; }
//        }


//        private string[] _tableNames =   {
//            "CustomVocationalJobPlacements"
//        };
       
