#region Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//=========================================================================================
// Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    ReferralDocument.ascx.cs
//
// Author:      Prasanna V
// Date:        16 jun 2011
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
using System.Text;

namespace SHS.SmartCare
{
    public partial class ReferralDocument : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage     
    {
        //for bing the general values to dropdown for the first time
        bool SetIndex = false;
        bool initilization = false;
        public override void BindControls()
        {
         //   DropDownList_CustomDocumentReferrals_ReceivingStaff.Attributes.Add("onchange", "BindProgramDropDown();");
            DropDownList_CustomDocumentReferrals_ReceivingProgram.Attributes.Add("onchange", "SetValue();");
            DropDownList_CustomDocumentReferrals_ReferralStatus.Attributes.Add("onchange", "ShowHide();");
            
            BindControlGeneral();
           // CustomGrid.Bind(ParentDetailPageObject.ScreenId);
        }
        
        public override string PageDataSetName
        {
            get { return "DataSetCustomDocumentReferrals"; }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomDocumentReferrals" };
                //return new string[] { "CustomDocumentReferrals" };
            }
        }
        public override void AddMandatoryValues(DataRow dataRow, string tableName)
        {
            switch (tableName)
            {
                case "CustomDocumentReferrals":
                    {

                       
                        try
                        {
                           initilization= true;
                           
                            //Referring status
                            DataView dataRefStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                            dataRefStatus.RowFilter = "Category='REFERRALSTATUS' AND CodeName='Not Sent' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                            DataTable dtcodeId = dataRefStatus.ToDataTable();
                            dataRow["ReferralStatus"] = Convert.ToInt32(dtcodeId.Rows[0]["GlobalCodeId"]);
                            SetIndex = true;
                            dataRow["ReferringStaff"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                    break;

            }

        }
        private void BindControlGeneral()
        {
            if(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataRow[] DataRowStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.Select("Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'");
                DataTable dataTableStaff = new DataTable("Table");
                dataTableStaff.Columns.Add("StaffID", System.Type.GetType("System.Int32"));
                dataTableStaff.Columns.Add("FirstName", System.Type.GetType("System.String"));
                dataTableStaff.Columns.Add("LastName", System.Type.GetType("System.String"));
                dataTableStaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                dataTableStaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                dataTableStaff.Columns.Add("clinician", System.Type.GetType("System.String"));
                dataTableStaff.Columns.Add("adminstaff", System.Type.GetType("System.String"));

                DataRow dataRowObject = dataTableStaff.NewRow();
                string signerName = string.Empty;

                //For All Staff User
                for (int counter1 = 0; counter1 < DataRowStaff.Length; counter1++)
                {
                    dataRowObject = dataTableStaff.NewRow();
                    dataRowObject["StaffID"] = DataRowStaff[counter1]["StaffId"];
                    signerName = Convert.ToString(DataRowStaff[counter1]["LastName"]).Trim() + ", " + Convert.ToString(DataRowStaff[counter1]["FirstName"]).Trim();
                    if (signerName.Length > 27)
                        dataRowObject["StaffName"] = signerName.Substring(0, 27) + "...";
                    else
                        dataRowObject["StaffName"] = signerName;
                    dataRowObject["FirstName"] = DataRowStaff[counter1]["FirstName"];
                    dataRowObject["LastName"] = DataRowStaff[counter1]["LastName"];
                    dataRowObject["StaffCode"] = DataRowStaff[counter1]["UserCode"];
                    dataRowObject["clinician"] = DataRowStaff[counter1]["clinician"];
                    dataRowObject["adminstaff"] = DataRowStaff[counter1]["adminstaff"];

                    dataTableStaff.Rows.Add(dataRowObject);
                }

                DataView dataViewStaff = new DataView(dataTableStaff);
                //dataViewStaff.Sort = "StaffNameID,StaffName";
                dataViewStaff.Sort = "StaffName";

                //Referring status
                DataView dataRefStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataRefStatus.RowFilter = "Category='REFERRALSTATUS' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataRefStatus.Sort = "SortOrder";
                DropDownList_CustomDocumentReferrals_ReferralStatus.DataTextField = "CodeName";
                DropDownList_CustomDocumentReferrals_ReferralStatus.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentReferrals_ReferralStatus.DataSource = dataRefStatus;
                DropDownList_CustomDocumentReferrals_ReferralStatus.DataBind();
                if (SetIndex == true)
                {
                    DropDownList_CustomDocumentReferrals_ReferralStatus.SelectedIndex = 1;
                }
                //Referral DocumentReferrals


                DropDownList_CustomDocumentReferrals_ReferringStaff.DataTextField = "StaffName";
                DropDownList_CustomDocumentReferrals_ReferringStaff.DataValueField = "StaffId";
                DropDownList_CustomDocumentReferrals_ReferringStaff.DataSource = dataViewStaff;
                DropDownList_CustomDocumentReferrals_ReferringStaff.DataBind();
                if (initilization == true)
                {
                    DropDownList_CustomDocumentReferrals_ReferringStaff.ClearSelection();
                    DropDownList_CustomDocumentReferrals_ReferringStaff.Items.FindByValue(BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId.ToString()).Selected = true;
                    initilization = false;
                }
                //Receiving DocumentReferrals

                DataView dvReceivingStaff = new DataView(dataTableStaff);
                dvReceivingStaff.RowFilter = "clinician='Y' OR adminstaff='Y' ";
                dvReceivingStaff.Sort = "StaffName";
                DropDownList_CustomDocumentReferrals_ReceivingStaff.DataTextField = "StaffName";
                DropDownList_CustomDocumentReferrals_ReceivingStaff.DataValueField = "StaffId";
                DropDownList_CustomDocumentReferrals_ReceivingStaff.DataSource = dvReceivingStaff;
                DropDownList_CustomDocumentReferrals_ReceivingStaff.DataBind();

                //Receiving program
                //DataView dataRecProgram = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs);
                //dataRecProgram.RowFilter = "Active='Y' AND ISNULL(RecordDeleted,'N')='N'";
                //dataRecProgram.Sort = "ProgramName";
                //DropDownList_CustomDocumentReferrals_ReceivingProgram.DataTextField = "ProgramName";
                //DropDownList_CustomDocumentReferrals_ReceivingProgram.DataValueField = "ProgramId";
                //DropDownList_CustomDocumentReferrals_ReceivingProgram.DataSource = dataRecProgram;
                //DropDownList_CustomDocumentReferrals_ReceivingProgram.DataBind();

                //DataView dataServices = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes);
                //dataServices.RowFilter = "Active='Y' AND ISNULL(RecordDeleted,'N')='N'";
                //dataServices.Sort = "AuthorizationCodeName";
                ////DropDownList_CustomDocumentReferrals_ReferralStatus.Items.Add(new ListItem("", "-1"));
                //DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataTextField = "AuthorizationCodeName";
                //DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataValueField = "AuthorizationCodeId";
                //DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataSource = dataServices;
                //DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataBind();

                //Service
                //Modify by :RohitK,on 06-19-2012,1796,#81 Services Drop-Downs,Harbor Go Live Issues
                //This stored procedure is designed to restrict the authorization codes available based on DocumentCodeId and ClientId
                using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
                {
                    int DocumentCodeId = Convert.ToInt32(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "Documents") ? BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["Documents"].Rows[0]["DocumentCodeId"] : 0);
                    DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                    DataView dataViewReferralService = new DataView(datasetReferralService.Tables["AuthorizationCodes"]);
                    dataViewReferralService.Sort = "DisplayAs";
                    DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataTextField = "DisplayAs";
                    DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataValueField = "AuthorizationCodeId";
                    DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataSource = dataViewReferralService;
                    DropDownList_CustomDocumentReferralServices_AuthorizationCodeId.DataBind();
                   
                }
                
                //Receiving action
                DataView dataRecAction = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataRecAction.RowFilter = "Category='RECEIVINGACTION' AND Active='Y' AND ISNULL(RecordDeleted,'N')='N'";
                dataRecAction.Sort = "SortOrder";
                DropDownList_CustomDocumentReferrals_ReceivingAction.DataTextField = "CodeName";
                DropDownList_CustomDocumentReferrals_ReceivingAction.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentReferrals_ReceivingAction.DataSource = dataRecAction;
                DropDownList_CustomDocumentReferrals_ReceivingAction.DataBind();


                using (SHS.UserBusinessServices.DetailPages objectCpt = new SHS.UserBusinessServices.DetailPages())
                {
                    DataSet dstGetcustomconfigurationsURL = new DataSet();
                    dstGetcustomconfigurationsURL = objectCpt.GetcustomconfigurationsURL();
                    if (dstGetcustomconfigurationsURL != null)
                    {
                        if (dstGetcustomconfigurationsURL.Tables["customconfigurations"].Rows.Count > 0)
                        {
                            HyperLink_help.NavigateUrl = Convert.ToString(dstGetcustomconfigurationsURL.Tables["customconfigurations"].Rows[0][0]);
                        }
                    }
                }
            }
            CustomGrid.Bind(ParentDetailPageObject.ScreenId);
        }

        //public override DataSet GetData()
  
    }
}