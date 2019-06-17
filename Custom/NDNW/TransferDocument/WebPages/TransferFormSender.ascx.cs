#region Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//=========================================================================================
// Copyright (C) 2011 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    transferFromSender.ascx.cs
//
// Author:      Vaibhav Khare
// Date:        016 jun 2011
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
    public partial class TransferFormSender : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        bool SetIndex = false;
        bool initilization = false;
        public override string PageDataSetName
        {
            get { return "DataSetDocumentTransfersValley"; }
        }
        public override void BindControls()
        {
            DropDownList_CustomDocumentTransfers_ReceivingStaff.Attributes.Add("onchange", "BindProgramDropDown();");
            DropDownList_CustomDocumentTransfers_ReceivingProgram.Attributes.Add("onchange", "SetValue();");
            DropDownList_CustomDocumentTransfers_TransferStatus.Attributes.Add("onchange", "ShowHide();");
            Bind_Control_Expires();
            CustomGrid.Bind(ParentDetailPageObject.ScreenId);

        }
        public override void AddMandatoryValues(DataRow dataRow, string tableName)
        {
            switch (tableName)
            {
                case "CustomDocumentTransfers":
                    {

                        initilization = true;
                        // dataRow["ProgramId"] = Session["NewDefaultProgram"] == null ? -1 : Session["NewDefaultProgram"];
                        DataView dataRefStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                        dataRefStatus.RowFilter = "Category='REFERRALSTATUS' AND CodeName='Not Sent' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                        DataTable dtcodeId = dataRefStatus.ToDataTable();
                        dataRow["TransferStatus"] = Convert.ToInt32(dtcodeId.Rows[0]["GlobalCodeId"]);

                        SetIndex = true;
                        dataRow["TransferringStaff"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;
                    }
                    break;

            }

        }
        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomDocumentTransfers" };
            }

        }

        public void Bind_Control_Expires()
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                //Referring status
                DataView dataRefStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataRefStatus.RowFilter = "Category='REFERRALSTATUS' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataRefStatus.Sort = "CodeName";
                //DropDownList_CustomDocumentReferrals_ReferralStatus.Items.Add(new ListItem("", "-1"));
                DropDownList_CustomDocumentTransfers_TransferStatus.DataTextField = "CodeName";
                DropDownList_CustomDocumentTransfers_TransferStatus.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTransfers_TransferStatus.DataSource = dataRefStatus;
                DropDownList_CustomDocumentTransfers_TransferStatus.DataBind();
                if (SetIndex == true)
                {
                    DropDownList_CustomDocumentTransfers_TransferStatus.SelectedIndex = 1;
                }
                //Referral staff
                ///Staff
                DataRow[] DataRowStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.Select("Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'");
                DataTable dataTableStaff = new DataTable("Table");
                dataTableStaff.Columns.Add("StaffID", System.Type.GetType("System.Int32"));
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
                    dataRowObject["StaffCode"] = DataRowStaff[counter1]["UserCode"];
                    dataRowObject["clinician"] = DataRowStaff[counter1]["clinician"];
                    dataRowObject["adminstaff"] = DataRowStaff[counter1]["adminstaff"];
                    dataTableStaff.Rows.Add(dataRowObject);
                }

                DataView dataViewStaff = new DataView(dataTableStaff);
                //dataViewStaff.Sort = "StaffNameID,StaffName";
                dataViewStaff.Sort = "StaffName";
                DropDownList_CustomDocumentTransfers_TransferringStaff.DataTextField = "StaffName";
                DropDownList_CustomDocumentTransfers_TransferringStaff.DataValueField = "StaffID";
                DropDownList_CustomDocumentTransfers_TransferringStaff.DataSource = dataViewStaff;
                DropDownList_CustomDocumentTransfers_TransferringStaff.DataBind();

                if (initilization == true)
                {
                    DropDownList_CustomDocumentTransfers_TransferringStaff.ClearSelection();
                    DropDownList_CustomDocumentTransfers_TransferringStaff.Items.FindByValue(BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId.ToString()).Selected = true;
                    initilization = false;
                }

                //Receiving staff
                DataView dvReceivingStaff = new DataView(dataTableStaff);
                dvReceivingStaff.RowFilter = "clinician='Y' OR adminstaff='Y' ";
                dvReceivingStaff.Sort = "StaffName";
                DropDownList_CustomDocumentTransfers_ReceivingStaff.DataTextField = "StaffName";
                DropDownList_CustomDocumentTransfers_ReceivingStaff.DataValueField = "StaffID";
                DropDownList_CustomDocumentTransfers_ReceivingStaff.DataSource = dvReceivingStaff;
                DropDownList_CustomDocumentTransfers_ReceivingStaff.DataBind();


                //Receiving program
                //DataView dataStaffProgram = new DataView(SHS.BaseLayer.SharedTables.StaffSharedTables.StaffProgram);
                ////DataView dataRecProgram = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                ////dataRecProgram.RowFilter = "Category='RECEIVINGPROGRAM' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                //dataStaffProgram.Sort = "CodeName";
                ////DropDownList_CustomDocumentReferrals_ReferralStatus.Items.Add(new ListItem("", "-1"));
                //DropDownList_CustomDocumentTransfers_ReceivingProgram.DataTextField = "CodeName";
                //DropDownList_CustomDocumentTransfers_ReceivingProgram.DataValueField = "GlobalCodeId";
                //DropDownList_CustomDocumentTransfers_ReceivingProgram.DataSource = dataStaffProgram;
                //DropDownList_CustomDocumentTransfers_ReceivingProgram.DataBind();

                //Service

                //DataView dataServices = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes);
                //dataServices.RowFilter = "Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                //dataServices.Sort = "AuthorizationCodeName";
                ////DropDownList_CustomDocumentReferrals_ReferralStatus.Items.Add(new ListItem("", "-1"));
                //DropDownList_CustomTransferServices_AuthorizationCodeId.DataTextField = "AuthorizationCodeName";
                //DropDownList_CustomTransferServices_AuthorizationCodeId.DataValueField = "AuthorizationCodeId";
                //DropDownList_CustomTransferServices_AuthorizationCodeId.DataSource = dataServices;
                //DropDownList_CustomTransferServices_AuthorizationCodeId.DataBind();
                using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
                {
                    int DocumentCodeId = Convert.ToInt32(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "Documents") ? BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["Documents"].Rows[0]["DocumentCodeId"] : 0);
                    DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                    DataView dataViewReferralService = new DataView(datasetReferralService.Tables["AuthorizationCodes"]);
                    dataViewReferralService.Sort = "DisplayAs";
                    DropDownList_CustomTransferServices_AuthorizationCodeId.DataTextField = "DisplayAs";
                    DropDownList_CustomTransferServices_AuthorizationCodeId.DataValueField = "AuthorizationCodeId";
                    DropDownList_CustomTransferServices_AuthorizationCodeId.DataSource = dataViewReferralService;
                    DropDownList_CustomTransferServices_AuthorizationCodeId.DataBind();

                }

                //Receiving action
                DataView dataRecAction = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataRecAction.RowFilter = "Category='RECEIVINGACTION' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";
                dataRecAction.Sort = "CodeName";
                //DropDownList_CustomDocumentReferrals_ReferralStatus.Items.Add(new ListItem("", "-1"));
                DropDownList_CustomDocumentTransfers_ReceivingAction.DataTextField = "CodeName";
                DropDownList_CustomDocumentTransfers_ReceivingAction.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTransfers_ReceivingAction.DataSource = dataRecAction;
                DropDownList_CustomDocumentTransfers_ReceivingAction.DataBind();

                //using (SHS.UserBusinessServices.DetailPages objectCpt = new SHS.UserBusinessServices.DetailPages())
                //{ 
                //    DataSet dstGetStaffProgeram = new DataSet();
                //   // dstGetStaffProgeram = objectCpt.GetStaffProgeram();
                //    int counter = dstGetStaffProgeram.Tables[0].Rows.Count;
                //    StringBuilder strhidden = new StringBuilder(); 
                //    for(int i=0;i<counter;i++)
                //    {
                //        strhidden.Append(dstGetStaffProgeram.Tables[0].Rows[i]["Program"]);
                //        strhidden.Append(",");
                //        strhidden.Append(dstGetStaffProgeram.Tables[0].Rows[i]["StaffProgramId"]);
                //        strhidden.Append("||");
                //    }


                //    hiddenProgramList.Value = strhidden.ToString(); 

                //    // cs.RegisterClientScriptBlock(GetType(), "BodyLoadUnloadScript", "<SCRIPT LANGUAGE='JavaScript'> alert('HAPPY CODING')</script>");


                //    //Page.ClientScript.RegisterClientScriptBlock(GetType(), "MyScript", "<script> alert('HAPPY CODING')</script>");


                //}
                using (SHS.UserBusinessServices.DetailPages objectCpt = new SHS.UserBusinessServices.DetailPages())
                {
                    DataSet dstGetcustomconfigurationsURL = new DataSet();
                    dstGetcustomconfigurationsURL = objectCpt.GetcustomconfigurationsURL();
                    if (dstGetcustomconfigurationsURL.Tables["customconfigurations"].Rows.Count > 0)
                        HyperLink_help.NavigateUrl = Convert.ToString(dstGetcustomconfigurationsURL.Tables["customconfigurations"].Rows[0][0]);


                }
            }

        }



    }
}
