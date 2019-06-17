using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using DevExpress.Web.ASPxGridView;
using System.Web.Services;
using System.Collections.Generic;
using System.IO;

namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_HarborTreatmentPlan_TreatmentPlanHarborAjaxScript : System.Web.UI.Page//SHS.BaseLayer.BasePages.Base
    {
        public string RelativePath = string.Empty;
        string goalNo = "";
        int NeedId = 0;
        int GoalId = 0;
        string NeedText = string.Empty;
        int newNeedId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            RelativePath = Page.ResolveUrl("~/");
            newNeedId = 0;
            switch (Request.Form["action"].ToLower())
            {
                case "addassociateneed"://Add the Associate need in the GridviewCustomTPneed
                    GoalId = Convert.ToInt32(Request.Form["GoalId"]);
                    AddAssociateNeed(HttpUtility.HtmlDecode(Request.Form["NeedText"]));

                    break;
                case "adddateneedtobeplan"://Add the Date To Be Plan and Check The Checkbox in the GridviewCustomTPneed
                    GoalId = Convert.ToInt32(Request.Form["GoalId"]);
                    AddDateNeedToBePlan(Request.Form["Needstring"], Convert.ToInt32(Request.Form["GoalId"]));
                    break;
                case "edit": //Handle On Blur
                    EditValue();
                    break;
                case "addgoal": //Handle Add Goal
                    BaseCommonFunctions.IsPopup = false;
                    AddGoal();
                    break;
                case "addobjective": //Handle Add objective
                    AddObjective();
                    break;
                case "deleteobjective"://Hadle Delete objective 
                    DeleteObjective();
                    break;
                case "updatequicktxplan": //Handle Add this to QuickTxPlan 
                    InsertNewRowInTxPlan();
                    break;
                case "updateusequicktxplan": //Handle when Quick tx plan text is used.    
                    UpdateTxPlanText();
                    break;
                case "deletegoal": // Handle deleting of a goal.
                    DeleteGoal();
                    break;
                case "updateobjective": // Handle objective updating
                    UpdateObjective();
                    break;
                case "deletequicktxplan": //Handle deleting of a Quick Tx plan when deleted from Quick Tx plan from the pop up
                    //DeleteQuickTxPlan();
                    DeleteQuickTxPlanModified();
                    break;
                case "renumbertxplan":// Renumbering of Goals and objectives
                    RenumberTxPlan();
                    break;
                case "recreatetxplanaftersave":
                    RecreateTxPlanAfterSave();
                    break;
                case "createtxplan":
                    CreateTxPlan();
                    break;
                case "addservice":
                    AddService();// Handle adding of a new service
                    break;
                case "deleteservice":
                    DeleteService();//Handle deleting of a service
                    break;
                case "authorizationcodeschange":// Handles display of unitType after selection of Authorization
                    //AuthorizationCodesChange();
                    AuthorizationCodesChangeWithoutRecreateGoal();
                    break;
                case "deletecustomtpneeds":
                    int.TryParse(Request.Form["TPGoalID"], out GoalId);
                    DeleteCustomTPNeeds();
                    break;
                case "removenewneeds":// Handles display of unitType after selection of Authorization
                    RemoveNewNeeds();
                    break;

            }
        }

        /// <summary>
        /// Davinder Kumar 02-May 2011
        /// To the add Needs in the Dataset havind Tab CustomTpNeeds
        /// Modified by Davinder Kumar 15-06-2011
        /// Now The Nedds will save directly in The table CustomTPNeeds
        /// Orginated Dataset is merge to Get screeninfo dataser
        /// </summary>
        private void AddAssociateNeed(string NeedText)
        {
            DataSet dataSetTreatmentPlan = null;
            DataRow drCustomTPNeeds = null;
            DataView DataViewCustomTPNeeds = null;
            //DataSet datasetCustomTPNeed = null;
            //int ClientId = 0;
            try
            {
                //using (SHS.UserBusinessServices.CustomTPNeeds objCustomTPNeeds = new SHS.UserBusinessServices.CustomTPNeeds())
                //{
                //    ClientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                //    datasetCustomTPNeed = objCustomTPNeeds.InsertCustomTPNeed(ClientId, NeedText, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
                //}

                using (dataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlan != null && dataSetTreatmentPlan.Tables.Contains("CustomTPNeeds"))
                    {
                        drCustomTPNeeds = dataSetTreatmentPlan.Tables["CustomTPNeeds"].NewRow();
                        drCustomTPNeeds.BeginEdit();
                        drCustomTPNeeds["NeedText"] = NeedText;
                        drCustomTPNeeds["ClientId"] = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                        //drCustomTPNeeds["LinkedInSession"] = "Y";
                        BaseCommonFunctions.InitRowCredentials(drCustomTPNeeds);
                        drCustomTPNeeds.EndEdit();
                        dataSetTreatmentPlan.Tables["CustomTPNeeds"].Rows.Add(drCustomTPNeeds);
                        newNeedId = Convert.ToInt32(drCustomTPNeeds["NeedId"]);
                        DataViewCustomTPNeeds = dataSetTreatmentPlan.Tables["CustomTPNeeds"].DefaultView;
                        DataViewCustomTPNeeds.RowFilter = "isnull(RecordDeleted,'N')<>'Y'";
                        GridViewCustomTPNeed.DataSource = DataViewCustomTPNeeds;

                        GridViewCustomTPNeed.DataSource = dataSetTreatmentPlan.Tables["CustomTPNeeds"];
                        GridViewCustomTPNeed.DataBind();
                        PlaceHolderControlAssociatedTPNeeds.Controls.Add(PanelTxPlanCustomTPNeed);

                    }

                }

            }
            finally
            {
                drCustomTPNeeds = null;
                DataViewCustomTPNeeds = null;
            }
        }

        //private void AddAssociateNeed(string NeedText)
        //{
        //    //DataSet dataSetTreatmentPlan = null;
        //    DataSet datasetCustomTPNeed = null;
        //    int ClientId = 0;
        //    try
        //    {
        //        using (SHS.UserBusinessServices.CustomTPNeeds objCustomTPNeeds = new SHS.UserBusinessServices.CustomTPNeeds())
        //        {
        //            ClientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
        //            datasetCustomTPNeed = objCustomTPNeeds.InsertCustomTPNeed(ClientId, NeedText, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
        //        }
        //        //dataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet();
        //        GridViewCustomTPNeed.DataSource = datasetCustomTPNeed.Tables[0];
        //        GridViewCustomTPNeed.DataBind();
        //        PlaceHolderControlAssociatedTPNeeds.Controls.Add(PanelTxPlanCustomTPNeed);
        //    }
        //    finally
        //    {
        //        //dataSetTreatmentPlan = null;
        //        datasetCustomTPNeed = null;
        //    }
        //}

        /// <summary>
        /// Davinder Kumar 03-06-2011
        /// This Method are used to add or Remove the Date To Be Planned from the customTPGoalNeeds table
        /// Modified By Davinder Kumar 15-06-2011
        /// Now Needs will Save Directly in the Dataset so No Need to Remove the Row for table CustomTPGoalNeeds
        private void AddDateNeedToBePlan(string Needstring, int GoalId)
        {
            DataSet dataSetTreatmentPlan = null;
            DataRow dataRowCustomTPNeeds = null;
            DataRow dataRowTPNeedNew = null;
            DataRow[] drSelectedCustomNeedGoal = null;
            try
            {
                string[] splitStr = new String[] { "#$#" };
                string NeedText = string.Empty;
                dataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet();
                string[] NeedStringGet = Needstring.Split(splitStr, StringSplitOptions.None);
                foreach (var NeedData in NeedStringGet)
                {
                    if (NeedData.Trim().Length > 0)
                    {

                        string[] NeedSplitData = NeedData.Split('^');
                        int LinkedInSessionCount = 0;

                        NeedId = Convert.ToInt32(NeedSplitData[0]);
                        NeedText = HttpUtility.HtmlDecode(NeedSplitData[1]);

                        int.TryParse(Convert.ToString(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("NeedId=" + NeedId + " and isnull(RecordDeleted,'N')<>'Y'").Length), out LinkedInSessionCount);

                        drSelectedCustomNeedGoal = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId=" + GoalId + " and NeedId=" + NeedId + " and isnull(RecordDeleted,'N')<>'Y'");

                        dataRowCustomTPNeeds = dataSetTreatmentPlan.Tables["CustomTPNeeds"].Select("NeedId=" + NeedId)[0];

                        if (NeedSplitData[2] == "T")
                        {
                            if (drSelectedCustomNeedGoal.Length == 0)
                            {
                                dataRowTPNeedNew = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].NewRow();
                                dataRowTPNeedNew["NeedId"] = NeedId;
                                dataRowTPNeedNew["TPGoalId"] = GoalId;
                                dataRowTPNeedNew["DateNeedAddedToplan"] = DateTime.Now;
                                //dataRowTPNeedNew["NeedText"] = NeedText;

                                ChangeLinkedInSessionCustomTPNeeds(dataRowCustomTPNeeds, true);

                                BaseCommonFunctions.InitRowCredentials(dataRowTPNeedNew);
                                dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Rows.Add(dataRowTPNeedNew);

                            }
                            else
                            {
                                drSelectedCustomNeedGoal[0].BeginEdit();
                                drSelectedCustomNeedGoal[0]["RecordDeleted"] = "N";
                                //dataRowTPNeedNew["DateNeedAddedToplan"] = DateTime.Now;
                                drSelectedCustomNeedGoal[0]["ModifiedDate"] = DateTime.Now.ToString();
                                BaseCommonFunctions.UpdateModifiedInformation(drSelectedCustomNeedGoal[0]);
                                drSelectedCustomNeedGoal[0].EndEdit();

                                if (LinkedInSessionCount == 1)
                                {
                                    ChangeLinkedInSessionCustomTPNeeds(dataRowCustomTPNeeds, false);
                                }
                            }
                        }
                        else
                        {
                            if (drSelectedCustomNeedGoal.Length > 0)
                            {
                                drSelectedCustomNeedGoal[0].BeginEdit();
                                BaseCommonFunctions.UpdateRecordDeletedInformation(drSelectedCustomNeedGoal[0]);
                                drSelectedCustomNeedGoal[0].EndEdit();

                                if (LinkedInSessionCount == 1)
                                {
                                    ChangeLinkedInSessionCustomTPNeeds(dataRowCustomTPNeeds, false);
                                }
                            }
                        }
                    }

                }
                PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                CreateGoal();
            }
            finally
            {
                dataSetTreatmentPlan = null;
                dataRowTPNeedNew = null;
                drSelectedCustomNeedGoal = null;
            }

        }

        private void ChangeLinkedInSessionCustomTPNeeds(DataRow dataRowCustomTPNeeds, bool LinkedInSession)
        {
            dataRowCustomTPNeeds.BeginEdit();
            if (LinkedInSession)
                dataRowCustomTPNeeds["LinkedInSession"] = "Y";
            else
                dataRowCustomTPNeeds["LinkedInSession"] = "N";
            dataRowCustomTPNeeds.EndEdit();
        }

        /// <summary>
        /// Davinder Kumar 03-06-2011
        /// Method Use To get the Data of The Rows 
        /// </summary>
        protected void GridViewCustomTPNeed_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data || e.Row.Cells.Count < 3) return;
            if (e.GetValue("NeedId").ToString() != "")
                NeedId = Convert.ToInt32(e.GetValue("NeedId"));
            if (e.GetValue("NeedText").ToString() != "")
            {
                NeedText = HttpUtility.UrlEncode(Convert.ToString(e.GetValue("NeedText")));
            }
            else { NeedText = string.Empty; }

            string Checked = string.Empty;
            using (DataSet dataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet())
            {
                //if (e.DataColumn.FieldName == "NeedId")
                //{

                string lstSessionNeedId = string.Empty;

                DataRow[] drSessionNeeds = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");

                foreach (DataRow drNeeds in drSessionNeeds)
                {
                    lstSessionNeedId += drNeeds["TPGoalId"].ToString() + ",";
                }
                string newNeedAddedd = "N";
                if (newNeedId == NeedId)
                    newNeedAddedd = "Y";

                DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + GoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
                if (dRowGoalNeed.Length > 0)
                {

                    Checked = "Checked";
                    //e.Row.Cells[0].Text = "<table><tr><td style='width:20px;'><img id=Img_CustomTPGoalNeeds_" + NeedId + " name=Img_CustomTPGoalNeeds_" + NeedId + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "   style='cursor:hand;display:None;'  onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "_" + NeedText + "' name='CheckBox_" + NeedId + "_" + NeedText + "' style='width:20px;' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <label for='CheckBox_" + NeedId + "_" + NeedText + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(NeedText, 20) + "</label> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='"+lstSessionNeedId+"' /> </td></tr></table>";
                    e.Row.Cells[0].Text = "<table width='43'><tr><td style='width:18px;'><img id='Img_CustomTPGoalNeeds_" + NeedId + "' name='Img_CustomTPGoalNeeds_" + NeedId + "' src='" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif'  tag='" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "'   style='cursor:hand;display:None;' onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td style='width:18px'><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') newNeed='" + newNeedAddedd + "' /> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
                    e.Row.Cells[2].Text = (dRowGoalNeed[0]["DateNeedAddedtoPlan"].ToString().Trim() != string.Empty) ? Convert.ToDateTime(dRowGoalNeed[0]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "";
                }
                else
                {
                    Checked = string.Empty;
                    e.Row.Cells[0].Text = "<table width='43'><tr><td style='width:18px;'><img id='Img_CustomTPGoalNeeds_" + NeedId + "'  name='Img_CustomTPGoalNeeds_" + NeedId + "' src='" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif'  tag='" + -1 + "'   style='cursor:hand;display:block;' onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "'  onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') newNeed='" + newNeedAddedd + "' /><input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
                }
                e.Row.Cells[1].Text = "<label for='CheckBox_" + NeedId + "_" + NeedText + "' id='label_" + NeedId + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(HttpUtility.UrlDecode(NeedText), 20) + "</label>";
                //GrantPermissionTemplateItems

                //e.DataColumn.CellStyle.HorizontalAlign = HorizontalAlign.Center;
                //DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + TPGoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");

            }
        }

        /// <summary>
        /// Davinder Kumar 03-06-2011
        /// Method use to assing the data to the cell of grid
        /// Date to be Planned are valued through the NeedId and Goal Id Respectively
        /// from the table CustomTpGoalNeeds
        /// </summary>
        protected void GridViewCustomTPNeed_HtmlDataCellPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableDataCellEventArgs e)
        {
            //string Checked = string.Empty;
            //using (DataSet dataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet())
            //{
            //    if (e.DataColumn.FieldName == "NeedId")
            //    {
            //        string lstSessionNeedId = string.Empty;

            //        DataRow[] drSessionNeeds = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");

            //        foreach (DataRow drNeeds in drSessionNeeds)
            //        {
            //            lstSessionNeedId += drNeeds["TPGoalId"].ToString() + ",";
            //        }

            //        DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + GoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
            //        if (dRowGoalNeed.Length > 0)
            //        {

            //            Checked = "Checked";
            //            //e.Cell.Text = "<table><tr><td style='width:20px;'><img id=Img_CustomTPGoalNeeds_" + NeedId + " name=Img_CustomTPGoalNeeds_" + NeedId + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "   style='cursor:hand;display:None;'  onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "_" + NeedText + "' name='CheckBox_" + NeedId + "_" + NeedText + "' style='width:20px;' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <label for='CheckBox_" + NeedId + "_" + NeedText + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(NeedText, 20) + "</label> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='"+lstSessionNeedId+"' /> </td></tr></table>";
            //            e.Cell.Text = "<table><tr><td style='width:20px;'><img id=Img_CustomTPGoalNeeds_" + NeedId + " name=Img_CustomTPGoalNeeds_" + NeedId + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "   style='cursor:hand;display:None;'  onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "' style='width:20px;' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <label for='CheckBox_" + NeedId + "_" + NeedText + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(NeedText, 20) + "</label> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
            //        }
            //        else
            //        {
            //            Checked = string.Empty;
            //            e.Cell.Text = "<table><tr><td style='width:20px;'><img id=Img_CustomTPGoalNeeds_" + NeedId + "  name=Img_CustomTPGoalNeeds_" + NeedId + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + -1 + "   style='cursor:hand;display:block;' onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "' style='width:20px' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <label for='CheckBox_" + NeedId + "_" + NeedText + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(NeedText, 20) + "</label><input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
            //        }
            //    }
            //    //GrantPermissionTemplateItems
            //    if (e.DataColumn.FieldName == "DateNeed")
            //    {
            //        e.DataColumn.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            //        DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + GoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
            //        if (dRowGoalNeed.Length > 0)
            //        {
            //            e.Cell.Text = (dRowGoalNeed[0]["DateNeedAddedtoPlan"].ToString().Trim() != string.Empty) ? Convert.ToDateTime(dRowGoalNeed[0]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "";
            //        }
            //    }
            //}
        }

        /// <summary>
        /// <Description>Change value in there respective Datatable</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>29 May 2011</CreatedOn>
        /// </summary>
        private void EditValue()
        {
            DataRow[] dataRowTreatmentPlanHRM = null;
            try
            {
                //Get DataSet from Base Common Function
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        //Perform Table Contain Check 
                        if (dataSetTreatmentPlanHRM.Tables.Contains(Request.Form["tableName"]))
                        {
                            if (dataSetTreatmentPlanHRM.Tables[Request.Form["tableName"]].Rows.Count > 0)  //Perform Row Count Check
                            {
                                dataRowTreatmentPlanHRM = dataSetTreatmentPlanHRM.Tables[Request.Form["tableName"]].Select(Request.Form["keyFieldName"] + "=" + Request.QueryString["keyValue"]);
                                if (dataRowTreatmentPlanHRM.Length > 0)
                                {
                                    dataRowTreatmentPlanHRM[0].BeginEdit();
                                    if (!Request.Form["controlValue"].IsNullOrEmpty())
                                    {
                                        dataRowTreatmentPlanHRM[0][Request.Form["fieldName"]] = Server.UrlDecode(Request.Form["controlValue"]);
                                    }
                                    else
                                    {
                                        dataRowTreatmentPlanHRM[0][Request.Form["fieldName"]] = DBNull.Value;
                                    }

                                    dataRowTreatmentPlanHRM[0].EndEdit();

                                    if (Request.Form["tableName"] == "CustomTPGoals" && Request.Form["fieldName"] == "TargeDate")
                                    {
                                        DataRow[] datarowCustomTPObjectives = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("TPGoalId=" + Request.QueryString["keyValue"] + " AND isnull(RecordDeleted,'N')<>'Y'");
                                        foreach (DataRow dr in datarowCustomTPObjectives)
                                        {
                                            dr.BeginEdit();
                                            if (!Request.Form["controlValue"].IsNullOrEmpty())
                                            {
                                                dr["TargetDate"] = Server.UrlDecode(Request.Form["controlValue"]);
                                            }
                                            else
                                            {
                                                dr["TargetDate"] = DBNull.Value;
                                            }
                                            dr.EndEdit();
                                        }
                                    }

                                    BaseCommonFunctions.GetScreenInfoDataSet().Merge(dataSetTreatmentPlanHRM);
                                }
                            }
                        }
                        if (Request.Form["GoalNo"] != null && Request.Form["GoalNo"] != "" && Request.Form["GoalNo"] != "undefined")
                        {
                            if (Request.Form["AuthCodeId"] != "")
                            {
                                string siteId = "-1";
                                if (Request.Form["SiteId"] != "")
                                {
                                    siteId = Request.Form["SiteId"];
                                }
                                DataRow[] dr = null;
                                if (siteId.Trim() != "-1")
                                {
                                    dr = dataSetTreatmentPlanHRM.Tables["TPInterventionProcedures"].Select("AuthorizationCodeId=" + Request.Form["AuthCodeId"] + " and SiteId=" + siteId + " and (Units is not null)  and Isnull(InitializedFromPreviousPlan,'N') <> 'Y'");
                                }
                                else
                                {
                                    dr = dataSetTreatmentPlanHRM.Tables["TPInterventionProcedures"].Select("AuthorizationCodeId=" + Request.Form["AuthCodeId"] + "  and (Units is not null) and Isnull(InitializedFromPreviousPlan,'N') <> 'Y'");
                                }
                                if (dr != null && dr.Length > 0)
                                {
                                    Response.Clear();
                                    Response.Write("SelectAuthorization");
                                    Response.End();
                                }
                            }
                        }

                    }
                }

            }
            finally
            {
                dataRowTreatmentPlanHRM = null;
            }
        }

        /// <summary>
        /// <Description></Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>29 May 2011</CreatedOn>
        /// </summary>
        private void InsertNewRowInTxPlan()
        {
            SHS.UserBusinessServices.Document objectDocuments = null;
            DataRow dataRowQuick = null;
            DataSet dataSetForUpdate = null;
            DataRow[] dataRowTPElementOrder = null;
            string whereClause = string.Empty;
            string TableName = Request.QueryString["tableName"];
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet().Clone())
                //Commented By Vishant Garg on 2/20/2012 with ref task#346 3.x Issues
                //What and why- We have no need to get the copy of dataset.Because this will provide all the rows of dataset with added rowstate
                //at the time of updating this will add all the records as new and insert into DB.
                //using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet().Copy())
                //
                {
                    if (dataSetTreatmentPlanHRM.Tables.Contains(TableName))
                    {
                        dataRowQuick = dataSetTreatmentPlanHRM.Tables[TableName].NewRow();
                        dataRowQuick.BeginEdit();
                        if (TableName != "CustomTPGlobalQuickTransitionPlans")
                            dataRowQuick["StaffId"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;
                        dataRowQuick["TPElementTitle"] = Request.Form["elementTitle"];
                        if (TableName != "CustomTPGlobalQuickTransitionPlans")
                            dataRowTPElementOrder = dataSetTreatmentPlanHRM.Tables[TableName].Select("IsNull(RecordDeleted,'N')<>'Y' and staffid = " + BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId, "TPElementOrder Desc");
                        else
                        {
                            dataRowTPElementOrder = dataSetTreatmentPlanHRM.Tables[TableName].Select("IsNull(RecordDeleted,'N')<>'Y' ", "TPElementOrder Desc");
                        }
                        if (dataRowTPElementOrder.Length > 0)
                        {
                            dataRowQuick["TPElementOrder"] = Convert.ToInt32(dataRowTPElementOrder[0]["TPElementOrder"]) + 1;
                        }
                        else
                        {
                            dataRowQuick["TPElementOrder"] = 1;
                        }
                        dataRowQuick["TPElementText"] = Request.Form["goalText"];
                        BaseCommonFunctions.InitRowCredentials(dataRowQuick);
                        dataRowQuick.EndEdit();
                        dataSetTreatmentPlanHRM.Tables[TableName].Rows.Add(dataRowQuick);
                        objectDocuments = new SHS.UserBusinessServices.Document();
                        dataSetForUpdate = new DataSet();
                        dataSetForUpdate.Merge(dataSetTreatmentPlanHRM.Tables[TableName]);
                        objectDocuments.UpdateDocuments(dataSetForUpdate, "", 0, string.Empty, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserName, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode, string.Empty, string.Empty, string.Empty, 5763, "", "");

                        //Commented By Vishant Garg 
                        //What and why-- We have no need to get all the records from database after updating because we have all the records in screendataset.
                        //dataSetTreatmentPlanHRM.Tables[TableName].AcceptChanges();
                        //dataSetTreatmentPlanHRM.Tables[TableName].Clear();
                        //if (TableName != "CustomTPGlobalQuickTransitionPlans")
                        //    whereClause = "  where IsNull(RecordDeleted,'N')<>'Y' AND StaffId= '" + BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId + "'";
                        //else
                        //    whereClause = "  where IsNull(RecordDeleted,'N')<>'Y'";
                        //DataTable dtTemp = (objectDocuments.GetUpdatedQuickTypeData(dataSetTreatmentPlanHRM, whereClause, TableName)).Tables[TableName];
                        //dataSetTreatmentPlanHRM.Tables[TableName].Merge(dtTemp);

                        //Added By Vishant Garg
                        //What and why- We need add newly inserted row into screendataset.
                        string UpdatedtableName = dataSetForUpdate.Tables[0].TableName;
                        BaseCommonFunctions.GetScreenInfoDataSet().Tables[UpdatedtableName].Merge(dataSetForUpdate.Tables[UpdatedtableName]);
                        BaseCommonFunctions.GetScreenInfoDataSet().Tables[UpdatedtableName].AcceptChanges();
                    }
                }
            }
            finally
            {
                objectDocuments = null;
                dataRowQuick = null;
                dataSetForUpdate = null;
                dataRowTPElementOrder = null;
            }
        }

        private void UpdateQuickTransitionsText()
        {
            DataRow[] dataRowQuickTransitionsPlan = null;
            DataRow[] dataRowTxPlan = null;
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        dataRowQuickTransitionsPlan = dataSetTreatmentPlanHRM.Tables["CustomTPGlobalQuickTransitionPlans"].Select("TPQuickId=" + Convert.ToInt32(Request.QueryString["keyTxValue"]));
                        if (dataRowQuickTransitionsPlan.Length > 0)
                        {
                            //Only a single record exists in the dataset.
                            dataRowTxPlan = dataSetTreatmentPlanHRM.Tables["CustomTreatmentPlans"].Select("1=1");
                            dataRowTxPlan[0].BeginEdit();
                            dataRowTxPlan[0]["DischargeTransitionCriteria"] = dataRowQuickTransitionsPlan[0]["TPElementText"];
                            dataRowTxPlan[0].EndEdit();
                        }
                    }
                }
            }
            finally
            {
                dataRowQuickTransitionsPlan = null;
                dataRowTxPlan = null;
            }
        }

        /// <summary>
        /// <Description>This method is used to get value from TPQuickGoal/TPQuickObjective/TPQuickIntervention  and add in there respective table</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>29 May 2011</CreatedOn>
        /// </summary>
        private void UpdateTxPlanText()
        {
            DataRow[] dataRowQuickTxPlan = null;
            DataRow[] dataRowTxPlan = null;
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        dataRowQuickTxPlan = dataSetTreatmentPlanHRM.Tables[Request.Form["txtableField"]].Select("TPQuickId=" + Convert.ToInt32(Request.QueryString["keyTxValue"]));
                        if (dataRowQuickTxPlan.Length > 0)
                        {
                            if (Request.Form["tableField"].ToString().ToLower() == "customtreatmentplans")
                            {
                                dataRowTxPlan = dataSetTreatmentPlanHRM.Tables[Request.Form["tableField"]].Select("1=1");
                            }
                            else
                            {
                                dataRowTxPlan = dataSetTreatmentPlanHRM.Tables[Request.Form["tableField"]].Select(Request.Form["keyFieldName"] + "=" + Convert.ToInt32(Request.Form["keyValue"]));
                            }
                            if (dataRowTxPlan.Length > 0)
                            {
                                dataRowTxPlan[0].BeginEdit();
                                switch (Request.Form["tableField"].ToLower())
                                {
                                    case "customtpgoals":
                                        dataRowTxPlan[0]["GoalText"] = dataRowQuickTxPlan[0]["TPElementText"];
                                        break;
                                    case "customtpobjectives":
                                        dataRowTxPlan[0]["ObjectiveText"] = dataRowQuickTxPlan[0]["TPElementText"];
                                        break;
                                    case "customtreatmentplans":
                                        dataRowTxPlan[0]["DischargeTransitionCriteria"] = dataRowQuickTxPlan[0]["TPElementText"];
                                        break;
                                }
                                BaseCommonFunctions.UpdateModifiedInformation(dataRowTxPlan[0]);
                                dataRowTxPlan[0].EndEdit();

                            }
                        }
                    }
                }
            }
            finally
            {
                dataRowQuickTxPlan = null;
                dataRowTxPlan = null;
            }
        }

        /// <summary>
        /// <Description>Insert New Row in the TPObjective</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>29 May 2011</CreatedOn>
        /// </summary>
        private void AddObjective()
        {
            int TPGoalId = 0;
            DataView dataViewTPObjectives = null;
            DataRowView dataRowViewObjective = null;
            DataRow[] dataRowTPGoals = null;
            double objectiveNumber = 0.0;
            try
            {
                TPGoalId = Convert.ToInt32(Request.QueryString["TPGoalId"]);
                //comented on 1 July,2010 orignal code line : using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    //Perform table contain check
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPObjectives") && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                    {
                        if (dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Rows.Count >= 0)
                        {
                            dataRowTPGoals = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId);
                            if (dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId).Length > 0)
                            {
                                objectiveNumber = Convert.ToDouble(dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Compute("Max(ObjectiveNumber)", "ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId));
                                objectiveNumber = Math.Round((objectiveNumber + .01), 2);
                            }
                            else
                            {
                                objectiveNumber = Math.Round(Convert.ToDouble(dataRowTPGoals[0]["GoalNumber"]) + .01, 2);
                            }
                            //Create DataView of TPObjectives
                            dataViewTPObjectives = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"]);
                            dataRowViewObjective = dataViewTPObjectives.AddNew(); //Create New Row
                            dataRowViewObjective.BeginEdit();
                            dataRowViewObjective["TPGoalId"] = TPGoalId;
                            dataRowViewObjective["ObjectiveNumber"] = Convert.ToDouble(objectiveNumber.ToString("0.00"));
                            dataRowViewObjective["TargetDate"] = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("TPGoalId=" + TPGoalId).Length > 0 ? dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("TPGoalId=" + TPGoalId)[0]["TargeDate"] : DBNull.Value;
                            BaseCommonFunctions.InitRowCredentials(dataRowViewObjective.Row);
                            dataRowViewObjective.EndEdit();

                            CreateGoal();
                            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                        }
                    }
                }
            }
            finally
            {
                dataViewTPObjectives = null;
                dataRowViewObjective = null;
                dataRowTPGoals = null;
            }

        }

        /// <summary>
        /// <Description>Delete Row from TPObjective</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>29 May 2011</CreatedOn>
        /// </summary>
        private void DeleteObjective()
        {
            DataRow[] dataRowDeleteObjective = null;
            DataRow[] dataRowObjectives = null;
            Double maxObjectiveNumber = 0.0;
            string objectiveNumber = string.Empty;
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPObjectives") && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                    {
                        dataRowDeleteObjective = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("Isnull(RecordDeleted,'N')<>'Y' and TpObjectiveID=" + Request.Form["objectiveId"]);
                        dataRowDeleteObjective[0].BeginEdit();
                        BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowDeleteObjective[0]);

                        dataRowDeleteObjective[0].EndEdit();
                        objectiveNumber = dataRowDeleteObjective[0]["ObjectiveNumber"].ToString();
                        maxObjectiveNumber = Convert.ToInt32(objectiveNumber.ToString().Substring(0, objectiveNumber.ToString().IndexOf(".")));
                        maxObjectiveNumber += .01;
                        dataRowObjectives = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("ISNULL(RecordDeleted,'N')<>'Y' and ObjectiveNumber >" + objectiveNumber.ToString() + " and TPGoalId=" + Request.QueryString["TPGoalId"]);
                        for (int objectiveCount = 0; objectiveCount < dataRowObjectives.Length; objectiveCount++)
                        {
                            dataRowObjectives[objectiveCount]["ObjectiveNumber"] = Convert.ToDouble(dataRowObjectives[objectiveCount]["ObjectiveNumber"]) - Convert.ToDouble(".01");
                        }
                        CreateGoal();
                        PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                    }
                }
            }
            finally
            {
                dataRowDeleteObjective = null;
                dataRowObjectives = null;
            }
        }

        /// <summary>
        /// <Description>Insert New Row in the CustomTPServices</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>1st-June-2011</CreatedOn>
        /// </summary>
        private void AddService()
        {
            int TPGoalId = 0;
            DataView dataViewTPServices = null;
            DataRowView dataRowViewServices = null;
            DataRow[] dataRowTPGoals = null;
            double ServiceNumber = 0.0;
            try
            {
                TPGoalId = Convert.ToInt32(Request.QueryString["TPGoalId"]);
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    //Perform table contain check
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices") && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                    {
                        if (dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Rows.Count >= 0)
                        {
                            dataRowTPGoals = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId);
                            if (dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId).Length > 0)
                            {
                                ServiceNumber = Convert.ToDouble(dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Compute("Max(ServiceNumber)", "ISNULL(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId));
                                ServiceNumber = Math.Round((ServiceNumber + .01), 2);
                            }
                            else
                            {
                                ServiceNumber = Math.Round(Convert.ToDouble(dataRowTPGoals[0]["GoalNumber"]) + .01, 2);
                            }
                            //Create DataView of TpServices
                            dataViewTPServices = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPServices"]);
                            dataRowViewServices = dataViewTPServices.AddNew(); //Create New Row
                            dataRowViewServices.BeginEdit();
                            dataRowViewServices["TPGoalId"] = TPGoalId;
                            dataRowViewServices["ServiceNumber"] = Convert.ToDouble(ServiceNumber.ToString("0.00"));
                            dataRowViewServices["AuthorizationCodeId"] = -1;
                            BaseCommonFunctions.InitRowCredentials(dataRowViewServices.Row);
                            dataRowViewServices.EndEdit();

                            CreateGoal();
                            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                        }
                    }
                }
            }
            finally
            {
                dataViewTPServices = null;
                dataRowViewServices = null;
                dataRowTPGoals = null;
            }

        }

        /// <summary>
        /// <Description>Delete Row from CustomTpServices</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>1st-June-2011</CreatedOn>
        /// </summary>
        private void DeleteService()
        {
            DataRow[] dataRowDeleteService = null;
            DataRow[] dataRowServices = null;
            Double maxServiceNumber = 0.0;
            string ServiceNumber = string.Empty;
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices") && dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                    {
                        dataRowDeleteService = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N')<>'Y' and TpServiceID=" + Request.Form["serviceid"]);
                        if (dataRowDeleteService.Length > 0)
                        {
                            ServiceNumber = dataRowDeleteService[0]["ServiceNumber"].ToString();
                            maxServiceNumber = Convert.ToInt32(ServiceNumber.ToString().Substring(0, ServiceNumber.ToString().IndexOf(".")));
                            maxServiceNumber += .01;
                            if (Convert.ToInt32(dataRowDeleteService[0]["TPServiceId"]) < 0)
                            {
                                dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Rows.Remove(dataRowDeleteService[0]);
                            }
                            else
                            {
                                dataRowDeleteService[0].BeginEdit();
                                BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowDeleteService[0]);
                                dataRowDeleteService[0].EndEdit();
                            }
                            //ServiceNumber = dataRowDeleteService[0]["ServiceNumber"].ToString();
                            //maxServiceNumber = Convert.ToInt32(ServiceNumber.ToString().Substring(0, ServiceNumber.ToString().IndexOf(".")));
                            //maxServiceNumber += .01;
                            dataRowServices = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("ISNULL(RecordDeleted,'N')<>'Y' and ServiceNumber >" + ServiceNumber.ToString() + " and TPGoalId=" + Request.QueryString["TPGoalId"]);
                            for (int objectiveCount = 0; objectiveCount < dataRowServices.Length; objectiveCount++)
                            {
                                dataRowServices[objectiveCount]["ServiceNumber"] = Convert.ToDouble(dataRowServices[objectiveCount]["ServiceNumber"]) - Convert.ToDouble(".01");
                            }
                            CreateGoal();
                            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                        }
                    }
                }
            }
            finally
            {
                dataRowDeleteService = null;
                dataRowServices = null;
            }
        }

        /// <summary>
        /// <Description>Method is used to create a new Goal i.e add new row in TPNeed table</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>30 May 2011</CreatedOn>
        /// </summary>
        private void AddGoal()
        {
            DataRow[] DataRowTPNeeds = null;
            DataRow dataRowTPNeedNew = null;
            try
            {
                // //Commented on 3 July,2010 orignal code Line : using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                        {
                            DataRowTPNeeds = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("Isnull(RecordDeleted,'N')<>'Y' and TPGoalId=" + Convert.ToInt32(Request.QueryString["TPGoalId"]));
                            if (DataRowTPNeeds.Length > 0)
                            {

                                dataRowTPNeedNew = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].NewRow();

                                dataRowTPNeedNew.BeginEdit();
                                dataRowTPNeedNew["DocumentVersionId"] = DataRowTPNeeds[0]["DocumentVersionId"];

                                dataRowTPNeedNew["GoalNumber"] = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Compute("Max(GoalNumber)", "Isnull(RecordDeleted,'N')<>'Y'")) + 1;

                                dataRowTPNeedNew["GoalText"] = Request.Form["goalText"];
                                dataRowTPNeedNew["TargeDate"] = DateTime.Now.AddYears(1);
                                BaseCommonFunctions.InitRowCredentials(dataRowTPNeedNew);
                                dataRowTPNeedNew.EndEdit();
                                dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Rows.Add(dataRowTPNeedNew);

                                CreateGoal();

                                PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                DataRowTPNeeds = null;
            }
        }

        /// <summary>
        /// <Description>This method is used to Read Data from TPNeeds and Create Goal Section </Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>3 June 2011</CreatedOn>
        /// </summary>
        private void CreateGoal()
        {
            DataSet dataSetTreatmentPlanHRM = null;
            DataView dataViewTPNeeds = null;
            DataRowView dataRowViewTPNeeds = null;
            StringBuilder stringBuilderHTML = null;
            int DocumentCodeId = 0;
            try
            {
                PanelTxPlanMain.Controls.Clear();

                using (dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                {
                    if (dataSetTreatmentPlanHRM == null)
                    {
                        dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet();
                    }
                    DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals") && BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPGoals", 0))
                        {
                            dataViewTPNeeds = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPGoals"]);
                            //Sort On the basis of Need Number because we have show Goal on Number basis
                            dataViewTPNeeds.Sort = "GoalNumber";
                            dataViewTPNeeds.RowFilter = "Isnull(RecordDeleted,'N')<>'Y'";
                            //Set Need Count in the hidden field
                            //Loop how many rows exists in the TPNeeds table for creating Goal
                            stringBuilderHTML = new StringBuilder();
                            //Adding the table Goals/Objectives/Services



                            stringBuilderHTML.Append("<table Id='TableHarborTxPlainMain1'  style='width:830px;' border='0' cellpadding='0' cellspacing='0'  BindAutoSaveEvents ='False'  BindSetFormData='False'>");

                            for (int needCount = 0; needCount < dataViewTPNeeds.Count; needCount++)
                            {
                                goalNo = dataViewTPNeeds[needCount]["GoalNumber"].ToString();
                                dataRowViewTPNeeds = dataViewTPNeeds[needCount]; //Create DataRowView 
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:100%'>");
                                stringBuilderHTML.Append("<table Id=" + needCount + "  style='width:100%;'  border='0' cellpadding='0' cellspacing='0'  BindAutoSaveEvents ='False'  BindSetFormData='False'>");

                                #region First TR of Main Table (start Section)
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan=3>");
                                stringBuilderHTML.Append("<table cellspacing='0'  cellpadding='0' border='0' width='100%'>");

                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td align='left' nowrap='nowrap' class='content_tab_left'>");
                                stringBuilderHTML.Append("<span name=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["GoalNumber"].ToString() + "  id=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["GoalNumber"].ToString() + " style='color:Black;font-size:11px;' BindAutoSaveEvents ='False'  BindSetFormData='False' > Goal # " + dataRowViewTPNeeds["GoalNumber"].ToString() + "</span>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td width='17'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='26' width='17' alt='' src=" + RelativePath + "App_Themes/Includes/Images/content_tab_sep.gif />");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td width='100%' class='content_tab_top'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td width='7'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='26' width='7' alt='' src=" + RelativePath + "App_Themes/Includes/Images/content_tab_right.gif />");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append(" </tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                #endregion First TR Main Table (start Section)

                                #region 3 TR for Main Table
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td class='right_contanier_bg' colspan=3>");

                                #region Main Table
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%' id=Table_" + goalNo + " GoalId='" + dataViewTPNeeds[needCount]["TPGoalId"] + "'>");
                                #region Main TR
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:100%'>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                #region 2
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion
                                #region 1st TR opening
                                stringBuilderHTML.Append("<tr>");
                                #region 1st td in 1st tr
                                stringBuilderHTML.Append("<td colspan='3'>"); // class='right_contanier_bg'
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td width='99px'>");

                                #region
                                if (dataRowViewTPNeeds["DeletionNotAllowed"].ToString().Trim() != "Y")
                                {
                                    stringBuilderHTML.Append("<img id=Img_CustomTPGoals_TPGoalId_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  name=Img_CustomTPGoals_TPGoalId_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dataRowViewTPNeeds["TPGoalId"].ToString() + "   style='cursor:hand;' onclick = \"DaleteTxPlanGoal('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + dataViewTPNeeds.Count + "');\"/>");
                                }
                                #endregion

                                //Assign Goal Text e.g (Goal#1)
                                stringBuilderHTML.Append("<span name=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='color:Black;font-size:11px;' ParentChildControls='True' > Goal # " + dataRowViewTPNeeds["GoalNumber"].ToString() + "</span>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                #region 2nd td in 1st tr
                                // Code By Rohit Katoch
                                stringBuilderHTML.Append("<td align='left' style='width:700px;'>");// colspan='3' Ist Row 3rd Column
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='99%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td>");
                                stringBuilderHTML.Append("<textarea   onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "GoalText" + "','" + "TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\"  name=TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "   class='form_textareaWithoutWidth'  parentchildcontrols='True' cols='138' rows='3' spellcheck='True'>");
                                if (dataRowViewTPNeeds["GoalText"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewTPNeeds["GoalText"].ToString().Trim() + "</textarea>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("</textarea>");
                                }
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");//Closing 1st row
                                #endregion

                                #region 2
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 2nd TR opening
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");

                                stringBuilderHTML.Append("<table style='width:100%;' cellborder='0' cellspacing='0' cellpadding='0' >");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:70px;'  >");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                #region 2nd td in 2nd tr
                                stringBuilderHTML.Append("<td  colspan='2' align='left'>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='padding-left:30px;'>");
                                stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Span_UseQuickGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_UseQuickGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;'  onclick=\"OpenModelDialogueQuickTxPlan('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGlobalQuickGoals" + "','" + "CustomTPGoals" + "');\">Use Quick Goal</span>"); //Create
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                #endregion 2nd Row closing

                                #region 4
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 3rd Row opening
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("<table style='width:100%' cellborder='0' cellspacing='0' cellpadding='0' >");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td style='width:70px;' >");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                #region 2
                                stringBuilderHTML.Append("<td colspan='2' align='left'>");

                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='100%'>");

                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open tag                               
                                stringBuilderHTML.Append("<td style='width:4%;padding-left:26px;' align='left' valign='middle;padding-right:5px;'>"); //1st Row 1st Open Col tag
                                stringBuilderHTML.Append("<span ParentChildControls='True' name=Span_TargetDate_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  id=Span_TargetDate_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  class='form_label'  BindAutoSaveEvents ='False'  BindSetFormData='False' >Target Date:</span>");
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close tag

                                stringBuilderHTML.Append("<td style='width:24%'>"); //1st Row 2nd  Col Open tag
                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0'>"); //Create
                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open tag

                                stringBuilderHTML.Append("<td style='padding-left:3px;'>");
                                if (dataRowViewTPNeeds["TargeDate"] != DBNull.Value) //Peform DBNull Check
                                {
                                    stringBuilderHTML.Append("<input type='text' datatype='Date' value='" + Convert.ToDateTime(dataRowViewTPNeeds["TargeDate"]).ToString("MM/dd/yyyy") + "'  name=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  BindAutoSaveEvents ='False'  BindSetFormData='False' onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "TargeDate" + "','" + "Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\" />"); //Create  
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<input type='text'  datatype='Date' name=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "     BindAutoSaveEvents ='False'  BindSetFormData='False' onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "TargeDate" + "','" + "Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\" />");
                                }
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td>&nbsp;"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='left'>");  //1st Row 2nd Col Open tag
                                stringBuilderHTML.Append("<img id=Img_CustomTPGoals_TargetDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " name=Img_CustomTPGoals_TargetDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  src=" + RelativePath + "App_Themes/Includes/Images/calender_grey.gif  style='cursor:hand;' onclick=\"return showCalendar('Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','%m/%d/%Y');\"/>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close tag
                                stringBuilderHTML.Append("</table>"); //Close tag
                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col  Close tag

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");

                                stringBuilderHTML.Append("</td>");
                                #endregion

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3rd row closing

                                #region 6
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 4th row opening
                                stringBuilderHTML.Append("<tr>");
                                #region 2
                                stringBuilderHTML.Append("<td colspan='3'>");
                                #region 4rth Row 3rd Column

                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='100%'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:15%;padding-right:5px;' align='right'>"); //1st Row 1st Col Open tag
                                stringBuilderHTML.Append("<span name=Span_AssociatedNeeds_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  id=Span_AssociatedNeeds_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  style='color:Black;font-size:11px;'>Associated Needs</span>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td  rowspan='2' valign='top'  width='85%'>"); //1st Row 2nd Col Open tag
                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='98%'>"); //Create
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td>");
                                #region for ListBox Control
                                DataTable dataTableResult = new DataTable("Result");
                                dataTableResult.Columns.Add("CustomTPNeedsNeedId", typeof(int));
                                dataTableResult.Columns.Add("NeedText", typeof(string));
                                dataTableResult.Columns.Add("CustomTPGoalNeeds", typeof(int));
                                dataTableResult.Columns.Add("DateNeedAddedtoPlan", typeof(DateTime));

                                DataView dataViewCustomTPGoalNeeds = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPGoalNeeds"]);

                                dataViewCustomTPGoalNeeds.RowFilter = "TPGoalId=" + Convert.ToString(dataRowViewTPNeeds["TPGoalID"] + " and IsNull(RecordDeleted,'N')<>'Y'");

                                //performs join between table.
                                string needDescription = string.Empty;

                                for (int i = 0; i < dataViewCustomTPGoalNeeds.Count; i++)
                                {
                                    DataRow parent = dataViewCustomTPGoalNeeds[i].Row.GetParentRow("CustomTPNeeds_CustomTPGoalNeeds_FK");

                                    DataRow newRow = dataTableResult.NewRow();
                                    if (newRow != null)
                                    {

                                        newRow["CustomTPGoalNeeds"] = dataViewCustomTPGoalNeeds[i].Row["TPGoalNeeds"];
                                        newRow["CustomTPNeedsNeedId"] = dataViewCustomTPGoalNeeds[i].Row["NeedId"];
                                        newRow["DateNeedAddedtoPlan"] = (dataViewCustomTPGoalNeeds[i].Row["DateNeedAddedtoPlan"] != DBNull.Value) ? Convert.ToDateTime(dataViewCustomTPGoalNeeds[i].Row["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "";
                                        DataRowView drneedDescription = (DataRowView)dataViewCustomTPGoalNeeds[i];
                                        needDescription = parent["NeedText"].ToString();//dataViewCustomTPGoalNeeds[i].Row["NeedText"].ToString();
                                        if (needDescription.Length >= 120)
                                        {
                                            needDescription = BaseCommonFunctions.cutText(needDescription, 120);
                                            needDescription = needDescription + "...";
                                        }
                                        newRow["NeedText"] = needDescription;
                                        dataTableResult.Rows.Add(newRow);
                                    }
                                }
                                #endregion
                                #region AssoicatedNeed
                                //Create Div


                                stringBuilderHTML.Append("<div class='form_textarea' id=div_CustomClientNeeds_NeedName_" + dataRowViewTPNeeds["TPGoalID"].ToString() + " style='width:100%;height:60px;overflow-x:auto;padding-left: 20px;width: 665px;'>");
                                stringBuilderHTML.Append("<table multiple='multiple' size='2' style='width:97%;height:100%'>");
                                if (dataTableResult.Rows.Count > 0)
                                {
                                    stringBuilderHTML.Append("<tr><th align='left' width='64%'><b><u>Need </u></b></th><th width='32%' align='center'><b><u>Date Added to Plan</u></b></th></tr>");
                                    for (int tpneedClientNeedCount = 0; tpneedClientNeedCount < dataTableResult.Rows.Count; tpneedClientNeedCount++)
                                    {
                                        stringBuilderHTML.Append("<tr><td align='left' id=" + dataTableResult.Rows[tpneedClientNeedCount]["CustomTPNeedsNeedId"].ToString() + ">");
                                        stringBuilderHTML.Append(dataTableResult.Rows[tpneedClientNeedCount]["NeedText"].ToString() + "</td>");
                                        stringBuilderHTML.Append("<td align='center' id=" + dataTableResult.Rows[tpneedClientNeedCount]["CustomTPGoalNeeds"].ToString() + ">");
                                        stringBuilderHTML.Append((dataTableResult.Rows[tpneedClientNeedCount]["DateNeedAddedtoPlan"] != DBNull.Value) ? Convert.ToDateTime(dataTableResult.Rows[tpneedClientNeedCount]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "" + "</td></tr>");
                                    }
                                }
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</div>");
                                #endregion
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                stringBuilderHTML.Append("</table>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col Close tag


                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag

                                stringBuilderHTML.Append("<tr>"); //2nd Row Open Tag
                                stringBuilderHTML.Append("<td align='right'  valign='top' style='width:15%;padding-right:5px;' >"); //2nd Row 1st Col Open Tag                               
                                stringBuilderHTML.Append("<span name=Span_EditAssociatedNeed_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  id=Span_EditAssociatedNeed_" + dataRowViewTPNeeds["TPGoalID"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueforAssociatedNeeds('" + "div_CustomClientNeeds_NeedName_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "')\" >Edit</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //2nd Row 1st Col Close Tag
                                stringBuilderHTML.Append("</tr>"); //2nd Row Close Tag

                                stringBuilderHTML.Append("</table>");
                                #endregion
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                #endregion 4th row closing

                                #region 8
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                #region Objective Section


                                //Find Objective with respect to there NeedId from TPObjective table
                                #region 16 TR of TabContent Table

                                #region 1subtable 16 TR

                                #region 1 TR of 1subtable 16 TR
                                CreateObjective(Convert.ToInt32(dataRowViewTPNeeds["TpGoalId"]), Convert.ToInt32(dataRowViewTPNeeds["GoalNumber"]), ref dataSetTreatmentPlanHRM);
                                #endregion 1 TR of 1subtable 16 TR

                                stringBuilderHTML = new StringBuilder();

                                #region 2 TR of 1subtable 16 TR
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 2 TR of 1subtable 16 TR


                                #region 3 TR of 1subtable 16 TR
                                stringBuilderHTML.Append("<tr>"); //9th Row Open Tag                                
                                stringBuilderHTML.Append("<td align='left' colspan='3'>"); //9th Row 3rd Column Open Tag

                                #region 9th Row 3rd Column

                                if (needCount % 2 == 0)
                                {
                                    stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='100%;'>"); //Create
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<table cellpadding='0' border='0'  style='width:100%;' cellspacing='0'>"); //Create
                                }
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td width='20%;' align='right'>"); //1st Row 1st Col Open Tag
                                stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_AddObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_AddObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"AddObjective('" + dataRowViewTPNeeds["TpGoalId"].ToString() + "');\" >Add Objective</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close Tag

                                stringBuilderHTML.Append("<td width='40%' align='center'>"); //1st Row 2nd Col Open Tag

                                DataRow[] dataRowTpObjective = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + dataRowViewTPNeeds["TpGoalId"].ToString());
                                if (dataRowTpObjective.Length > 0)
                                {
                                    stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_RenumberObjective_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenRenumberTxPlan('" + "CustomTPObjectives" + "','" + "TPObjectiveId" + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "','" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\" >Renumber Objective</span>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalId"].ToString() + " style='text-decoration:underline;color:Black;font-size:11px;' disabled='disabled'>Renumber Objective</span>");
                                }

                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col Close Tag

                                stringBuilderHTML.Append("<td>"); //1st Row 1st Col Open Tag
                                stringBuilderHTML.Append("&nbsp;"); //Create
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                stringBuilderHTML.Append("</table>");
                                #endregion

                                stringBuilderHTML.Append("</td>"); //9th Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>"); //9th Row Close Tag
                                #endregion 3 TR of 1subtable 16 TR


                                #endregion 1subtable 16 TR

                                #endregion 16 TR of TabContent Table

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #endregion

                                #region 8
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 1 TR of Services
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of Services

                                #region 2 TR of Services
                                //Checking if any row for services corresponding to a Goal exists or not
                                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices")) //Perform Table contain Check
                                {

                                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPServices", 0))
                                    {
                                        DataRow[] dataRowCustomTpServices = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + dataRowViewTPNeeds["TPGoalID"].ToString() + "", "ServiceNumber Asc");
                                        if (dataRowCustomTpServices.Length > 0)
                                        {

                                            stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                            stringBuilderHTML.Append("<td style='width:3%;' valign='top'>"); //1st Row 1st Col Open tag                              
                                            stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag
                                            stringBuilderHTML.Append("<td style='width:8%;' valign='top'>");//1st Row 2nd Col Open tag
                                            stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                            stringBuilderHTML.Append("<td align='left'>"); //1st Row 3rd Column Open Tag
                                            stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='99%'>"); //Create
                                            stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                            stringBuilderHTML.Append("<td style='width:23%;text-align:left;' >");
                                            stringBuilderHTML.Append("<span class='form_label'><b>Service</b></span>");
                                            stringBuilderHTML.Append("</td>");

                                            stringBuilderHTML.Append("<td style='width:15%;text-align:center;'>");
                                            stringBuilderHTML.Append("<span class='form_label'><b>How Many</b></span>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:15%;text-align:left;'>");
                                            stringBuilderHTML.Append("</td>");

                                            stringBuilderHTML.Append("<td style='width:27%;text-align:left;'>");
                                            stringBuilderHTML.Append("<span class='form_label'><b>How Often</b></span>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:10%;text-align:center;'>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:17%;text-align:center;'>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<tr>");
                                            stringBuilderHTML.Append("</table>");

                                            stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                            stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                        }
                                    }
                                }
                                #endregion 2 TR of Services

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #region Service Section
                                #region 17 TR of TabContent Table

                                #region 1 TR of Sub table 1 of Service
                                CreateService(Convert.ToInt32(dataRowViewTPNeeds["TPGoalID"]), goalNo, ref dataSetTreatmentPlanHRM);
                                #endregion 1 TR of Sub table 1 of Service



                                #region 2 TR of Sub table 1 of Service
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 2 TR of Sub table 1 of Service


                                #region 3 TR of Sub table 1 of Service
                                stringBuilderHTML.Append("<tr>"); //9th Row Open Tag                               
                                stringBuilderHTML.Append("<td align='left' colspan='3'>"); //9th Row 3rd Column Open Tag
                                #region 9th Row 3rd Column
                                stringBuilderHTML.Append("<table cellpadding='0' border='0' style='width:100%' cellspacing='0'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td align='right' style='width:20%;padding-right:11px;'>"); //1st Row 1st Col Open Tag                              
                                stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_AddService_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_AddService_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"AddService('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\" >Add Service</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close Tag
                                stringBuilderHTML.Append("<td style='width:80%;'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                stringBuilderHTML.Append("</table>");

                                #endregion
                                stringBuilderHTML.Append("</td>"); //9th Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3 TR of Sub table 1 of Service

                                #endregion 17 TR of TabContent Table

                                #region Show Space
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion Show Space

                                //Check as the enclosed conditional Html should not be made for Initial
                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    #region Goal Status
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td align='left' colspan='3'>");

                                    stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' width='100%;'>");
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td align='left' style='padding-left:7px;'>");
                                    stringBuilderHTML.Append("<table style='width:50%;' border='0' cellspacing='0' cellpadding='0'>");
                                    stringBuilderHTML.Append("<tr class='RadioText'>");
                                    #region 1 td
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("<span class='form_label'><b>Goal Status:</b></span>");
                                    stringBuilderHTML.Append("</td>");
                                    #endregion
                                    #region 2 td
                                    stringBuilderHTML.Append("<td>"); //1st Row 1st Column Open Tag    
                                    string goalActive = string.Empty;
                                    if (dataRowViewTPNeeds["Active"] != DBNull.Value) //Peform DBNull Check
                                    {
                                        goalActive = dataRowViewTPNeeds["Active"].ToString();//Get the value of GoalActive
                                    }
                                    else
                                    {
                                        goalActive = "Y";
                                    }
                                    if (goalActive.ToUpper() == "Y")
                                    {
                                        stringBuilderHTML.Append("<input   BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='Y'/><label for=Radio_CustomTPGoals_Active_Y_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is active</label>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input   BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"   id=Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='Y'/><label for=Radio_CustomTPGoals_Active_Y_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is active</label>");
                                    }
                                    stringBuilderHTML.Append("</td>"); //1st Row 1st Column Close Tag
                                    #endregion
                                    #region 3 td
                                    stringBuilderHTML.Append("<td>"); //1st Row 2nd Column Open Tag
                                    if (goalActive.ToUpper() == "N")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"     checked='checked' id=Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N' /><label for=Radio_CustomTPGoals_Active_N_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is NOT active</label>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"    id=Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N' /><label for=Radio_CustomTPGoals_Active_N_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is NOT active</label>");
                                    }
                                    stringBuilderHTML.Append("</td>");
                                    #endregion
                                    stringBuilderHTML.Append("</tr>");
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");//1st Row Close tag
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");//1st Row Close tag
                                    #endregion Goal Status

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space

                                    #region Goal Progress Rate
                                    //Progress Rate row 1
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3'>");
                                    stringBuilderHTML.Append("<span class='form_label'><b>Rating of progress towards goal(required when service discontinued or goal made inactive):</b></span>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:9px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space

                                    //Progress Rate row 2
                                    string RateProgress = string.Empty;
                                    if (dataRowViewTPNeeds["ProgressTowardsGoal"] != null)
                                    {
                                        RateProgress = dataRowViewTPNeeds["ProgressTowardsGoal"].ToString();
                                    }
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3'>");
                                    stringBuilderHTML.Append("<table style='width:70%;' cellborder='0' cellpadding='0' cellspacing='0'>");
                                    stringBuilderHTML.Append("<tr class='RadioText'>");
                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "D")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='D'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" id=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='D'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Deterioration</label>");
                                    stringBuilderHTML.Append("</td>");



                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "N")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='N'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">No change</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "S")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='S'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='S'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Some Improvement</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "M")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='M'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='M'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Moderate Improvement</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "A")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='A'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='A'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Acheived</label>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Goal Progress Rate

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space
                                }

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #endregion
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion Main TR
                                stringBuilderHTML.Append("</table>");//Table Goal No. closed
                                #endregion MainTable

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3 TR for Main Table

                                #region 4 TR for Main Table
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan=3>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td width='2' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='7'  alt='' src=" + RelativePath + "App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif /> ");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td width='100%' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='right' width='2' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='7'  alt='' src=" + RelativePath + "App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif />");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 4 TR for Main Table

                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:3%;height:3px;' colspan='3'>&nbsp;</td>");
                                stringBuilderHTML.Append("</tr>");

                                stringBuilderHTML.Append("</table>");//Table Need count Ends here

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                            }
                            #region Add Goal
                            stringBuilderHTML = new StringBuilder();


                            //Html to be made only for Treatment Plan Initial
                            //if (DocumentCodeId == 1483 || DocumentCodeId == 1486)
                            //{
                            #region Show Space
                            stringBuilderHTML.Append("<tr>");
                            stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("</tr>");
                            #endregion Show Space

                            #region 5th TR
                            stringBuilderHTML.Append("<tr>"); //8th Row Open Tag                           
                            stringBuilderHTML.Append("<td colspan='3' align='left'>");
                            stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>"); //Create
                            stringBuilderHTML.Append("<tr>");
                            stringBuilderHTML.Append("<td width='1%' >");
                            stringBuilderHTML.Append("&nbsp;"); //Create
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("<td align='left'>");
                            stringBuilderHTML.Append("<span name=Span_AddGoal_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  id=Span_AddGoal_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueHRMTPGoal('" + dataRowViewTPNeeds["TpGoalId"].ToString() + "','" + "Add Goal" + "');\" >Add Goal</span>"); //Create
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("<td width='1%' >");
                            stringBuilderHTML.Append("&nbsp;"); //Create
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("<td align='left'>");
                            stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Span_RenumberGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_RenumberGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenRenumberTxPlan('" + "CustomTPGoals" + "','" + "TPGoalId" + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "','" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\"> Renumber Goals</span>"); //Create 
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("</tr>");
                            stringBuilderHTML.Append("</table>");
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("</tr>");
                            #endregion

                            //}



                            stringBuilderHTML.Append("</table>");
                            dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].DefaultView.RowFilter = "";
                            PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                            #endregion
                        }

                    }
                }
            }
            finally
            {
                dataSetTreatmentPlanHRM = null;
                dataViewTPNeeds = null;
                dataRowViewTPNeeds = null;
            }
        }

        /// <summary>
        /// <Description>This method is used to Read Data from TPObjective and Create Objective Section</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>3 june 2011</CreatedOn>
        /// </summary>
        /// <param name="TPGoalID"></param>
        /// <param name="goalNumber"></param>
        private void CreateObjective(int TpGoalId, int goalNumber, ref DataSet dataSetTreatmentPlanHRM)
        {
            StringBuilder stringBuilderHTML = null;
            DataRow[] dataRowTpObjective = null;
            DataRowView[] dataRowViewTPObjective = null;
            double objectiveNumber = 0.0;
            int DocumentCodeId = 0;
            DropDownList dropdownListObjectiveActive = null;
            try
            {
                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPobjectives")) //Perform Table contain Check
                {
                    stringBuilderHTML = new StringBuilder();
                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPobjectives", 0))
                    {
                        DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                        //Find out the Number of Objectives Corresponding to a Goal
                        dataRowTpObjective = dataSetTreatmentPlanHRM.Tables["CustomTPobjectives"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + TpGoalId + "", "ObjectiveNumber Asc");
                        if (dataRowTpObjective.Length > 0)
                        {
                            for (int objectiveCount = 0; objectiveCount < dataRowTpObjective.Length; objectiveCount++)
                            {
                                DataView dataViewTPObjectives = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPobjectives"]);
                                dataViewTPObjectives.Sort = "TPObjectiveId Asc";
                                //Create DataRowView 
                                dataRowViewTPObjective = dataViewTPObjectives.FindRows(dataRowTpObjective[objectiveCount]["TPObjectiveId"]);

                                #region 1 TR of OBjective
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of OBjective

                                #region 2 TR of OBjective
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("<table style='width:100%;' cellborder='0' cellpadding='0' cellspacing='0' >");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td style='width:9%;padding-right:5px;' align='right' valign='top'>"); //1st Row 1st Col Open tag                              
                                if (dataRowViewTPObjective[0]["DeletionNotAllowed"].ToString().Trim() != "Y")
                                    stringBuilderHTML.Append("<img style='cursor:hand;color:Black;font-size:11px;' id=Img_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  name=Img_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag='" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "'  onClick= \"DeleteObjective('" + TpGoalId + "','" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "');\" />");
                                stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag
                                stringBuilderHTML.Append("<td style='width:35px' align='center' valign='top'>");//1st Row 2nd Col Open tag
                                objectiveNumber = Convert.ToDouble(dataRowViewTPObjective[0]["ObjectiveNumber"].ToString());
                                stringBuilderHTML.Append("<span   style='color:Black;font-size:11px;'  name=Span_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + ">Objective" + objectiveNumber.ToString("0.00") + "</span>");
                                stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                stringBuilderHTML.Append("<td align='left'  style='padding-left:3px;width:80%;'>"); //1st Row 3rd Column Open Tag

                                stringBuilderHTML.Append("<textarea  spellcheck='True' BindAutoSaveEvents ='False'  BindSetFormData='False' name=TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " rows='3' cols='126' class='form_textareaWithoutWidth' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "ObjectiveText" + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" >");
                                if (dataRowViewTPObjective[0]["ObjectiveText"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewTPObjective[0]["ObjectiveText"].ToString() + "</textarea>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("</textarea>");
                                }

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("<td width='6px'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                #endregion 2 TR of OBjective

                                #region 3 TR of OBjective
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion 3 TR of OBjective

                                #region 4 TR of OBjective
                                stringBuilderHTML.Append("<tr>"); //2nd Row Open Tag
                                stringBuilderHTML.Append("<td align='left' colspan='3'>");//2nd Row 3rd Col Open Tag
                                #region subtable1
                                stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>"); //Create

                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td align='right' style='width:31%;padding-right:2px;'>");
                                stringBuilderHTML.Append("<span   name=Span_UseQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_UseQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueQuickTxPlan('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPQuickObjectives" + "','" + "CustomTPObjectives" + "');\">Use Quick Objective</span>"); //Create
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='center' style='width:25%'>");
                                stringBuilderHTML.Append("<span   name=Span_AddthistoQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_AddthistoQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueAddQuickTxPlan('" + "CustomTPQuickObjectives" + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "');\">Add this to Quick Objective</span>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                //Html not be be created for Treatment Plan initial
                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("<span class='form_label'>Status:</span>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td style='width:20%'>");
                                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                    stringBuilderHTML = new StringBuilder();

                                    dropdownListObjectiveActive = new DropDownList();
                                    dropdownListObjectiveActive.ID = "DropDownList_RecordDeleted_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString();
                                    dropdownListObjectiveActive.Width = 100;
                                    dropdownListObjectiveActive.CssClass = "form_dropdown";
                                    ListItem lstItemAciive = new ListItem();
                                    lstItemAciive.Text = "Active";
                                    lstItemAciive.Value = "1";

                                    ListItem lstItemInactive = new ListItem();
                                    lstItemInactive.Text = "Inactive";
                                    lstItemInactive.Value = "0";

                                    dropdownListObjectiveActive.Items.Add(lstItemAciive);
                                    dropdownListObjectiveActive.Items.Add(lstItemInactive);
                                    dropdownListObjectiveActive.DataBind();
                                    dropdownListObjectiveActive.Items.Insert(0, "");
                                    if (dataRowViewTPObjective[0]["Status"].ToString().Trim() == "" || dataRowViewTPObjective[0]["Status"].ToString().Trim() == "1")
                                    {
                                        dropdownListObjectiveActive.SelectedValue = "1";
                                    }
                                    else
                                    {
                                        dropdownListObjectiveActive.SelectedValue = "0";
                                    }

                                    PanelTxPlanMain.Controls.Add(dropdownListObjectiveActive);
                                    dropdownListObjectiveActive.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "Status" + "','" + dropdownListObjectiveActive.ClientID + "','" + "Edit" + "','" + "TPObjectiveId" + "');");
                                    dropdownListObjectiveActive.Attributes.Add("BindAutoSaveEvents", "False");
                                    dropdownListObjectiveActive.Attributes.Add("BindSetFormData", "False");

                                    stringBuilderHTML.Append("</td>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td style='width:20%'>");
                                    stringBuilderHTML.Append("</td>");
                                }
                                stringBuilderHTML.Append("<td align='center' style='padding-right:5px; width:10%'>");//1st Row  1st Col Open Tag
                                stringBuilderHTML.Append("<span   name=Span_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='color:Black;font-size:11px;'>Target Date</span>"); //Create                                                            
                                stringBuilderHTML.Append("</td>");//1st Row  1st Col Close Tag

                                stringBuilderHTML.Append("<td align='left' style='width:24%;'>");//1st Row  2nd Col Open Tag
                                #region subtable2
                                stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0'>");
                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td>");
                                if (dataRowViewTPObjective[0]["TargetDate"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False' type='text' datatype='Date' value='" + Convert.ToDateTime(dataRowViewTPObjective[0]["TargetDate"]).ToString("MM/dd/yyyy") + "'   name=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  class='form_textbox' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "TargetDate" + "','" + "Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" />"); //Create  
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False' type='text' datatype='Date'  name=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  class='form_textbox' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "TargetDate" + "','" + "Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" />"); //Create  
                                }
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td>");
                                stringBuilderHTML.Append("&nbsp;<img id=Img_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " name=Img_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  src=" + RelativePath + "App_Themes/Includes/Images/calender_grey.gif   style='cursor:hand;' onclick=\"return showCalendar('Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','%m/%d/%Y');\"/>"); //Create 
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                #endregion sub table
                                stringBuilderHTML.Append("</td>");//1st Row  2nd Col Close Tag
                                stringBuilderHTML.Append("</tr>");//1st Row Close Tag
                                stringBuilderHTML.Append("</table>"); //Create
                                #endregion subtable1
                                stringBuilderHTML.Append("</td>");//2nd Row 3rd Col Close Tag
                                stringBuilderHTML.Append("</tr>"); //2nd Row Close Tag
                                #endregion 4 TR of OBjective

                                //To show difference between the two rows
                                #region 5 TR of OBjective
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion 5 TR of OBjective

                            }
                        }
                    }
                    else
                    {
                        #region 1 TR of OBjective
                        stringBuilderHTML.Append("<tr>");
                        stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                        stringBuilderHTML.Append("&nbsp;");
                        stringBuilderHTML.Append("</td>");

                        stringBuilderHTML.Append("</tr>");
                        #endregion 1 TR of OBjective
                    }
                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowTpObjective = null;
                dataRowViewTPObjective = null;
            }
        }

        /// <summary>
        /// <Description>To read data from CustomTpServices and create the Services</Description>
        ///<Author>Rohit Katoch</Author>
        /// <CreatedOn>30th-May-2011</CreatedOn>
        /// </summary>
        private void CreateService(int TpGoalId, string goalNumber, ref DataSet dataSetTreatmentPlanHRM)
        {
            StringBuilder stringBuilderHTML = null;
            DataRow[] dataRowCustomTpServices = null;
            DataRowView[] dataRowViewCustomTPServices = null;
            double serviceNumber = 0.0;
            DropDownList dropdownListServiceCode = null;
            DropDownList dropdownListServiceFrequency = null;
            DropDownList dropdownListServiceActive = null;
            int DocumentCodeId = 0;
            try
            {

                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices")) //Perform Table contain Check
                {
                    stringBuilderHTML = new StringBuilder();
                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPServices", 0))
                    {
                        DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                        dataRowCustomTpServices = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + TpGoalId + "", "ServiceNumber Asc");

                        if (dataRowCustomTpServices.Length > 0)
                        {

                            for (int serviceCount = 0; serviceCount < dataRowCustomTpServices.Length; serviceCount++)
                            {
                                DataView dataViewTPServices = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPServices"]);
                                dataViewTPServices.Sort = "TPServiceId Asc";
                                //Create DataRowView 
                                dataRowViewCustomTPServices = dataViewTPServices.FindRows(dataRowCustomTpServices[serviceCount]["TPServiceId"]);

                                #region 1 TR of Services
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of Services

                                #region 2 TR of Services
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:9%;padding-right:5px;' valign='top' align='right'>"); //1st Row 1st Col Open tag                              
                                if (dataRowViewCustomTPServices[0]["DeletionNotAllowed"].ToString().Trim() != "Y")
                                {
                                    stringBuilderHTML.Append("<img style='cursor:hand;color:Black;font-size:11px;' id=Img_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  name=Img_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag='" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "'  onClick= \"DeleteService('" + TpGoalId + "','" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "');\" />");
                                }
                                stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag


                                stringBuilderHTML.Append("<td style='width:8%' valign='top'>");//1st Row 2nd Col Open tag
                                serviceNumber = Convert.ToDouble(dataRowViewCustomTPServices[0]["ServiceNumber"].ToString());
                                stringBuilderHTML.Append("<span style='color:Black;font-size:11px;'  name=Span_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Span_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + ">Service" + serviceNumber.ToString("0.00") + "</span>");
                                stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                //stringBuilderHTML.Append("<td align='left' style='padding-left:8px'>"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("<td align='left' style='padding-left:2px'>"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='99%'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:20%;text-align:left;' >");
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                stringBuilderHTML = new StringBuilder();

                                dropdownListServiceCode = new DropDownList();
                                dropdownListServiceCode.ID = "DropDownList_ServiceCode_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                dropdownListServiceCode.Width = 150;
                                dropdownListServiceCode.CssClass = "form_dropdown";
                                //using (DataTable DatatableAuthorizationCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes)
                                //{
                                //    DataRow[] dataRowAuthorizationCodes = DatatableAuthorizationCodes.Select("isnull(RecordDeleted,'N')<>'Y' and Active='Y'");
                                //    dropdownListServiceCode.DataTextField = "AuthorizationCodeName";
                                //    dropdownListServiceCode.DataValueField = "AuthorizationCodeId";
                                //    dropdownListServiceCode.DataSource = dataRowAuthorizationCodes;
                                //    dropdownListServiceCode.DataBind();
                                //    dropdownListServiceCode.Items.Insert(0, "");
                                //}

                                //Modify by :RohitK,on 06-19-2012,1796,#81 Services Drop-Downs,Harbor Go Live Issues
                                //This stored procedure is designed to restrict the authorization codes available based on DocumentCodeId and ClientId
                                using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
                                {
                                    //Added by : Amit Kumar Srivastava Parameter @isInitialTxTab char(1), #1672, Harbor Go Live Issues, DA: Call csp_ReferralServiceDropDown with extra parameter
                                    //DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                                    DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId), 'Y');

                                    dropdownListServiceCode.DataTextField = "DisplayAs";
                                    dropdownListServiceCode.DataValueField = "AuthorizationCodeId";
                                    dropdownListServiceCode.DataSource = datasetReferralService.Tables["AuthorizationCodes"].DefaultView;
                                    dropdownListServiceCode.DataBind();
                                    dropdownListServiceCode.Items.Insert(0, "");
                                }
                                if (dataRowViewCustomTPServices[0]["AuthorizationCodeId"] != DBNull.Value && Convert.ToInt32(dataRowViewCustomTPServices[0]["AuthorizationCodeId"]) > 0)
                                {
                                    dropdownListServiceCode.SelectedValue = dataRowViewCustomTPServices[0]["AuthorizationCodeId"].ToString();
                                }
                                dropdownListServiceCode.Attributes.Add("ServiceNo", dataRowViewCustomTPServices[0]["ServiceNumber"].ToString());
                                dropdownListServiceCode.Attributes.Add("required", "true");
                                PanelTxPlanMain.Controls.Add(dropdownListServiceCode);
                                dropdownListServiceCode.Attributes.Add("onChange", "OnChangeAuthorizationCodes(this," + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + ")");
                                dropdownListServiceCode.Attributes.Add("BindAutoSaveEvents", "False");
                                dropdownListServiceCode.Attributes.Add("BindSetFormData", "False");
                                dropdownListServiceCode.Attributes.Add("required", "true");

                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:15%;text-align:center;'>");
                                if (dataRowViewCustomTPServices[0]["Units"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  value='" + (Convert.ToDouble(dataRowViewCustomTPServices[0]["Units"]).ToString()) + "'   name=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " class='form_textbox' style='width: 50px;'  onChange= \"ModifyGoalValueInDataSetCheckInteger('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Units" + "','" + "Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "Edit" + "','" + "TPServiceId" + "');\" />"); //Create  
                                }
                                else
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  class='form_textbox' style='width: 50px;' onChange= \"ModifyGoalValueInDataSetCheckInteger('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Units" + "','" + "Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "Edit" + "','" + "TPServiceId" + "');\" />"); //Create  

                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:16%;text-align:left;'>");
                                stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False' id=AuthorizationUnitType_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " class='form_label' >");
                                if (dataRowViewCustomTPServices[0]["UnitType"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewCustomTPServices[0]["UnitType"].ToString());
                                }
                                stringBuilderHTML.Append("</span>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:23%;text-align:left'>");
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                stringBuilderHTML = new StringBuilder();
                                dropdownListServiceFrequency = new DropDownList();
                                dropdownListServiceFrequency.ID = "DropDownList_Frequency_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                dropdownListServiceFrequency.Width = 140;
                                dropdownListServiceFrequency.CssClass = "form_dropdown";

                                using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("TPFREQUENCYTYPE", true, "", "SortOrder", false))
                                {
                                    dropdownListServiceFrequency.DataTextField = "CodeName";
                                    dropdownListServiceFrequency.DataValueField = "GlobalCodeId";
                                    dropdownListServiceFrequency.DataSource = DataViewGlobalCodes;
                                    dropdownListServiceFrequency.DataBind();
                                    dropdownListServiceFrequency.Items.Insert(0, "");
                                }
                                if (dataRowViewCustomTPServices[0]["FrequencyType"] != DBNull.Value)
                                {
                                    dropdownListServiceFrequency.SelectedValue = dataRowViewCustomTPServices[0]["FrequencyType"].ToString();
                                }

                                PanelTxPlanMain.Controls.Add(dropdownListServiceFrequency);
                                dropdownListServiceFrequency.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "FrequencyType" + "','" + dropdownListServiceFrequency.ClientID + "','" + "Edit" + "','" + "TPServiceId" + "');");
                                dropdownListServiceFrequency.Attributes.Add("BindAutoSaveEvents", "False");
                                dropdownListServiceFrequency.Attributes.Add("BindSetFormData", "False");
                                stringBuilderHTML.Append("</td>");

                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    stringBuilderHTML.Append("<td style='width:10%'>");
                                    stringBuilderHTML.Append("<span class='form_label' >Status:</label>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("<td style='width:17%'>");
                                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                    stringBuilderHTML = new StringBuilder();
                                    dropdownListServiceActive = new DropDownList();
                                    dropdownListServiceActive.ID = "DropDownList_ServiceActive_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                    dropdownListServiceActive.Width = 90;
                                    dropdownListServiceActive.CssClass = "form_dropdown";

                                    ListItem lstItemAciive = new ListItem();
                                    lstItemAciive.Text = "Active";
                                    lstItemAciive.Value = "1";

                                    ListItem lstItemInactive = new ListItem();
                                    lstItemInactive.Text = "Inactive";
                                    lstItemInactive.Value = "0";

                                    dropdownListServiceActive.Items.Add(lstItemAciive);
                                    dropdownListServiceActive.Items.Add(lstItemInactive);
                                    dropdownListServiceActive.DataBind();

                                    if (dataRowViewCustomTPServices[0]["Status"] == DBNull.Value || dataRowViewCustomTPServices[0]["Status"].ToString() == "1")
                                    {
                                        dropdownListServiceActive.SelectedValue = "1";
                                    }
                                    else
                                    {
                                        dropdownListServiceActive.SelectedValue = "0";
                                    }

                                    PanelTxPlanMain.Controls.Add(dropdownListServiceActive);
                                    dropdownListServiceActive.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Status" + "','" + dropdownListServiceActive.ClientID + "','" + "Edit" + "','" + "TPServiceId" + "');");
                                    dropdownListServiceActive.Attributes.Add("BindAutoSaveEvents", "False");
                                    dropdownListServiceActive.Attributes.Add("BindSetFormData", "False");
                                    stringBuilderHTML.Append("</td>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<td style='width:10%'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("<td style='width:17%'>");
                                    stringBuilderHTML.Append("</td>");
                                }

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                #endregion 2 TR of Services
                            }

                        }
                        else
                        {
                            #region 1 TR of OBjective
                            stringBuilderHTML.Append("<tr>");
                            stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                            stringBuilderHTML.Append("&nbsp;");
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("</tr>");
                            #endregion 1 TR of OBjective
                        }
                        PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                    }

                }

            }
            catch (Exception ex)
            {
            }
            finally
            {
                dataRowCustomTpServices = null;
                dataRowViewCustomTPServices = null;
            }
        }

        /// <summary>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>3 june 2011</CreatedOn>
        /// <Description>Method is used to Delete the Goal</Description>
        /// </summary>
        private void DeleteGoal()
        {
            DataRow[] dataRowObjective = null;
            DataRow[] dataRowService = null;
            int GoalNumber = 0;
            int TPGoalId = 0;
            try
            {
                TPGoalId = Convert.ToInt32(Request.QueryString["TPGoalId"]);
                DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet();

                if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                {
                    if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals"))
                    {

                        DataRow[] dataRowCustomTPGoals = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("Isnull(RecordDeleted,'N')<>'Y' and TPGoalId=" + Convert.ToInt32(Request.QueryString["TPGoalId"]));
                        if (dataRowCustomTPGoals.Length > 0)
                        {

                            GoalNumber = Convert.ToInt32(dataRowCustomTPGoals[0]["GoalNumber"]);
                            dataRowCustomTPGoals[0].BeginEdit();
                            BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowCustomTPGoals[0]);
                            dataRowCustomTPGoals[0].EndEdit();
                            #region Section for Objective
                            if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPObjectives") && dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Rows.Count > 0)
                            {
                                dataRowObjective = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("Isnull(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId);

                                for (int objectiveCount = 0; objectiveCount < dataRowObjective.Length; objectiveCount++)
                                {
                                    dataRowObjective[objectiveCount].BeginEdit();
                                    BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowObjective[objectiveCount]);
                                    dataRowObjective[objectiveCount].EndEdit();
                                }
                            }
                            #endregion
                            #region Section for Services
                            if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices") && dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Rows.Count > 0)
                            {
                                dataRowService = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N')<>'Y' and TPGoalId=" + TPGoalId);
                                for (int serviceCount = 0; serviceCount < dataRowService.Length; serviceCount++)
                                {
                                    dataRowService[serviceCount].BeginEdit();
                                    BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowService[serviceCount]);
                                    dataRowService[serviceCount].EndEdit();
                                }
                            }
                            #endregion
                            #region Renumber Goal
                            dataRowCustomTPGoals = dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].Select("TPGoalId<>" + TPGoalId + " and ISNULL(RecordDeleted,'N')<>'Y' and GoalNumber >" + GoalNumber);
                            for (int goalCount = 0; goalCount < dataRowCustomTPGoals.Length; goalCount++)
                            {
                                ChangeObjectiveNumbers(Convert.ToInt32(dataRowCustomTPGoals[goalCount]["TpGoalId"]), Convert.ToInt32(dataRowCustomTPGoals[goalCount]["GoalNumber"]) - 1, ref dataSetTreatmentPlanHRM);
                                dataRowCustomTPGoals[goalCount].BeginEdit();
                                dataRowCustomTPGoals[goalCount]["GoalNumber"] = Convert.ToInt32(dataRowCustomTPGoals[goalCount]["GoalNumber"]) - 1;
                                dataRowCustomTPGoals[goalCount].EndEdit();
                            }
                            #endregion
                            CreateGoal();
                            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                        }
                    }
                }
            }
            finally
            {
                dataRowObjective = null;
                dataRowService = null;
            }
        }

        /// <summary>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>5 june 2011</CreatedOn>
        /// <Description>Method is used to Update the objective values</Description>
        /// </summary>
        private void UpdateObjective()
        {
            DataRow[] dataRowTPObjectives = null;
            int objectiveId = 0;
            string strHTML = string.Empty;
            try
            {
                objectiveId = Convert.ToInt32(Request.QueryString["objectiveId"]);

                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {

                        if (dataSetTreatmentPlanHRM.Tables.Contains("TPObjectives") && dataSetTreatmentPlanHRM.Tables["TPObjectives"].Rows.Count > 0)
                        {
                            dataRowTPObjectives = dataSetTreatmentPlanHRM.Tables["TPObjectives"].Select("Isnull(RecordDeleted,'N')<>'Y' and ObjectiveId=" + objectiveId);

                            if (dataRowTPObjectives.Length > 0)
                            {
                                string objectvetext = string.Empty;
                                string targetdate = string.Empty;
                                string objectiveStatus = string.Empty;
                                dataRowTPObjectives[0].BeginEdit();

                                if (Request.Form["ObjectiveText"] != string.Empty)
                                {
                                    dataRowTPObjectives[0]["ObjectiveText"] = Request.Form["ObjectiveText"];
                                    objectvetext = Convert.ToString(Request.Form["ObjectiveText"]);
                                }
                                else
                                {
                                    objectvetext = "";
                                }
                                if (Request.Form["TargetDate"] != string.Empty)
                                {
                                    dataRowTPObjectives[0]["TargetDate"] = Convert.ToDateTime(Request.Form["TargetDate"]);
                                    targetdate = Convert.ToString(Request.Form["TargetDate"]);
                                }
                                else
                                {
                                    targetdate = "";
                                }
                                if (Request.Form["ObjectiveStatus"] != string.Empty)
                                {
                                    dataRowTPObjectives[0]["ObjectiveStatus"] = Request.Form["ObjectiveStatus"];
                                    objectiveStatus = Convert.ToString(Request.Form["ObjectiveStatus"]);
                                }
                                else
                                {
                                    objectiveStatus = "";
                                }
                                BaseCommonFunctions.UpdateModifiedInformation(dataRowTPObjectives[0]);
                                dataRowTPObjectives[0].EndEdit();


                                strHTML = strHTML + "$$" + objectvetext + "$$" + targetdate.Trim() + "$$" + objectiveStatus.Trim();

                                PlaceHolderControlAssociatedNeeds.Controls.Add(new LiteralControl(strHTML));
                            }
                        }
                    }
                }
            }
            finally
            {
                dataRowTPObjectives = null;
            }
        }

        /// <summary>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>4 june 2011</CreatedOn>
        /// <Description>Method is used to Update the objective values</Description>
        /// </summary>
        private void DeleteQuickTxPlan()
        {
            DataRow[] dataRowDeleteQuickTxPlan = null;
            string tableName = string.Empty;
            DataSet datasetQuicktype = null;
            SHS.UserBusinessServices.Document objectDocument = null;
            try
            {
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (Request.Form["tableName"] != null && Request.Form["tableName"] != "")
                    {
                        tableName = Request.Form["tableName"].ToString();
                    }

                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Contains(tableName) && dataSetTreatmentPlanHRM.Tables.Contains(tableName))
                    {
                        dataRowDeleteQuickTxPlan = dataSetTreatmentPlanHRM.Tables[tableName].Select("Isnull(RecordDeleted,'N')<>'Y' and TPQuickId=" + Request.QueryString["quickId"].ToString());
                        if (dataRowDeleteQuickTxPlan.Length > 0)
                        {
                            dataRowDeleteQuickTxPlan[0].BeginEdit();
                            BaseCommonFunctions.UpdateRecordDeletedInformation(dataRowDeleteQuickTxPlan[0]);
                            dataRowDeleteQuickTxPlan[0].EndEdit();


                            if (!dataSetTreatmentPlanHRM.Tables[tableName].ExtendedProperties.Contains("UpdateChildTable"))
                                dataSetTreatmentPlanHRM.Tables[tableName].ExtendedProperties.Add("UpdateChildTable", false);
                            else
                                dataSetTreatmentPlanHRM.Tables[tableName].ExtendedProperties["UpdateChildTable"] = false;

                            objectDocument = new SHS.UserBusinessServices.Document();
                            datasetQuicktype = new DataSet();
                            datasetQuicktype.Merge(dataSetTreatmentPlanHRM.Tables[tableName]);
                            objectDocument.UpdateDocuments(datasetQuicktype, string.Empty, 0, string.Empty, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserName, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode, string.Empty, string.Empty, string.Empty, 5763, "", "");
                            dataSetTreatmentPlanHRM.Tables[tableName].AcceptChanges();
                            dataSetTreatmentPlanHRM.Tables[tableName].Clear();
                            string whereClause = string.Empty;
                            if (Request.Form["tableName"].ToString().ToLower() == "customtpquickobjectives" || Request.Form["tableName"].ToString() == "CustomMapToEmploymentQuickObjectives")
                            {
                                whereClause = "  where IsNull(RecordDeleted,'N')<>'Y' AND StaffId= '" + BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId + "'";
                            }
                            else
                                whereClause = "  where IsNull(RecordDeleted,'N')<>'Y' ";
                            DataSet dataSetTemp = objectDocument.GetUpdatedQuickTypeData(dataSetTreatmentPlanHRM, whereClause, tableName);
                            if (dataSetTemp != null)
                            {
                                if (dataSetTemp.Tables.Count > 0)
                                {
                                    dataSetTreatmentPlanHRM.Tables[tableName].Merge(dataSetTemp.Tables[tableName]);
                                }
                            }
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowDeleteQuickTxPlan = null;
            }
        }

        /// <summary>
        /// Added modified version of DeleteQuickTxPlan()
        /// </summary>
        private void DeleteQuickTxPlanModified()
        {
            DataRow[] dataRowDeleteQuickTxPlan = null;
            string tableName = string.Empty;
            DataSet datasetQuicktype = null;
            SHS.UserBusinessServices.Document objectDocument = null;
            string whereClause = " where IsNull(RecordDeleted,'N')<>'Y' ";
            DataSet dataSetTpHrm = new DataSet();
            DataSet dataSetTreatmentPlanHRM = new DataSet();
            try
            {
                objectDocument = new SHS.UserBusinessServices.Document();
                if (Request.Form["tableName"] != null && Request.Form["tableName"] != "")
                {
                    tableName = Request.Form["tableName"].ToString();
                }

                whereClause += " and TPQuickId=" + Request.QueryString["quickId"].ToString();

                if (Request.Form["tableName"].ToString().ToLower() == "customtpquickobjectives" || Request.Form["tableName"].ToString() == "CustomMapToEmploymentQuickObjectives")
                {
                    whereClause += "  AND StaffId= '" + BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId + "'";
                }
                dataSetTreatmentPlanHRM.Merge(BaseCommonFunctions.GetScreenInfoDataSet().Tables[tableName].Copy());
                dataSetTreatmentPlanHRM.Tables[tableName].Clear();
                dataSetTreatmentPlanHRM.Merge(objectDocument.GetUpdatedQuickTypeData(dataSetTpHrm, whereClause, tableName));

                if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, tableName, 0))
                {
                    dataSetTreatmentPlanHRM.Tables[tableName].Rows[0].BeginEdit();
                    dataSetTreatmentPlanHRM.Tables[tableName].Rows[0]["RecordDeleted"] = "Y";
                    BaseCommonFunctions.UpdateRecordDeletedInformation(dataSetTreatmentPlanHRM.Tables[tableName].Rows[0]);
                    dataSetTreatmentPlanHRM.Tables[tableName].Rows[0].EndEdit();

                    objectDocument.UpdateDocuments(dataSetTreatmentPlanHRM, string.Empty, 0, string.Empty, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserName, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode, string.Empty, string.Empty, string.Empty, 5763, "", "");
                    DataSet dataSetTemp = objectDocument.GetUpdatedQuickTypeData(dataSetTreatmentPlanHRM, whereClause, tableName);
                }

            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowDeleteQuickTxPlan = null;
            }
        }

        /// <summary>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>4 june 2011</CreatedOn>
        /// <Description>Method is used to Renumber the objective</Description>
        /// </summary>
        private void ChangeObjectiveNumbers(int newGoalID, int newNumber, ref DataSet dataSetTreatmentPlan)
        {
            DataRow[] dataRowsObjectives = null;
            string objectiveNumber = string.Empty;
            try
            {
                dataRowsObjectives = dataSetTreatmentPlan.Tables["CustomTPObjectives"].Select("TPGoalId=" + newGoalID);
                for (int objectiveCount = 0; objectiveCount < dataRowsObjectives.Length; objectiveCount++)
                {
                    dataRowsObjectives[objectiveCount].BeginEdit();
                    objectiveNumber = dataRowsObjectives[objectiveCount]["ObjectiveNumber"].ToString();
                    dataRowsObjectives[objectiveCount]["ObjectiveNumber"] = newNumber.ToString() + objectiveNumber.Substring(objectiveNumber.IndexOf("."));
                    dataRowsObjectives[objectiveCount].EndEdit();
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowsObjectives = null;
            }
        }

        /// <summary>
        /// Created By Rohit Katoch
        /// Created On:7th June,2011
        /// <Description>Method is used to Renumber the Services</Description>
        /// </summary>
        private void ChangeServiceNumbers(int newGoalID, int newNumber, ref DataSet dataSetTreatmentPlan)
        {
            DataRow[] dataRowsServices = null;
            string ServiceNumber = string.Empty;
            try
            {
                dataRowsServices = dataSetTreatmentPlan.Tables["CustomTPServices"].Select("TPGoalId=" + newGoalID);
                for (int serviceCount = 0; serviceCount < dataRowsServices.Length; serviceCount++)
                {
                    dataRowsServices[serviceCount].BeginEdit();
                    ServiceNumber = dataRowsServices[serviceCount]["ServiceNumber"].ToString();
                    dataRowsServices[serviceCount]["ServiceNumber"] = newNumber.ToString() + ServiceNumber.Substring(ServiceNumber.IndexOf("."));
                    dataRowsServices[serviceCount].EndEdit();
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowsServices = null;
            }
        }

        /// <summary>
        /// <Description>Handle Renumber Goal/Objective/Intervention</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>8 june 2011</CreatedOn>
        /// </summary>

        private void RenumberTxPlan()
        {
            string[] rowSeparator = null;
            string[] separatorCol = null;
            DataRow[] dataRowTPNeeds = null;
            string[] arrayColCollection = null;
            DataSet dataSetTreatmentPlanHRM = null;
            string tableName = string.Empty;
            string keyFieldName = string.Empty;
            string fieldText = string.Empty;
            try
            {
                rowSeparator = new string[] { "||" };
                separatorCol = new string[] { "$$" };
                dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet();
                if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                {
                    tableName = Request.QueryString["tableName"];
                    keyFieldName = Request.Form["keyFieldName"];
                    switch (tableName.ToLower())
                    {
                        case "customtpgoals":
                            fieldText = "GoalNumber";
                            break;
                        case "customtpobjectives":
                            fieldText = "ObjectiveNumber";
                            break;

                    }
                    if (dataSetTreatmentPlanHRM.Tables.Contains(tableName) && dataSetTreatmentPlanHRM.Tables[tableName].Rows.Count > 0)
                    {
                        string[] strSplitArr = Request.Form["strHTML"].Split(rowSeparator, StringSplitOptions.None);
                        if (strSplitArr.Length > 0)
                        {
                            for (int rowCount = 0; rowCount < strSplitArr.Length; rowCount++)
                            {
                                arrayColCollection = strSplitArr[rowCount].Split(separatorCol, StringSplitOptions.None);
                                dataRowTPNeeds = dataSetTreatmentPlanHRM.Tables[tableName].Select("Isnull(RecordDeleted,'N')<>'Y' and " + keyFieldName + "=" + Convert.ToInt32(arrayColCollection[0]));
                                if (dataRowTPNeeds.Length > 0)
                                {
                                    dataRowTPNeeds[0].BeginEdit();
                                    dataRowTPNeeds[0][fieldText] = arrayColCollection[1];
                                    dataRowTPNeeds[0].EndEdit();
                                    if (tableName.ToLower() == "customtpgoals")
                                    {
                                        ChangeObjectiveNumbers(Convert.ToInt32(dataRowTPNeeds[0]["TPGoalId"]), Convert.ToInt32(dataRowTPNeeds[0]["GoalNumber"]), ref dataSetTreatmentPlanHRM);
                                        ChangeServiceNumbers(Convert.ToInt32(dataRowTPNeeds[0]["TPGoalId"]), Convert.ToInt32(dataRowTPNeeds[0]["GoalNumber"]), ref dataSetTreatmentPlanHRM);
                                    }
                                }
                            }
                            CreateGoal();
                            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
                        }
                    }
                }
            }
            finally
            {
                rowSeparator = null;
                separatorCol = null;
                dataRowTPNeeds = null;
                arrayColCollection = null;
                dataSetTreatmentPlanHRM = null;
            }
        }

        private void RecreateTxPlanAfterSave()
        {
            CreateGoal();
            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
        }


        /// <summary>
        /// <Description></Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>8 june 2011</CreatedOn>
        /// </summary>
        private void CreateTxPlan()
        {
            CreateGoal();
            PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
        }

        /// <summary>
        /// <Description>Called when Authorization selection is changed to get the unitType for services</Description>
        /// <Author>Rohit Katoch</Author>
        /// <createdon>8 June 2011</createdon>
        /// </summary>
        private void AuthorizationCodesChange()
        {
            DataSet dataSetHarborTreatmentPlan = null;
            DataTable dataTableAuthorizationCodes = null;
            DataTable dataTableGlobalCodes = null;
            DataRow[] dataRowCustomTPServices = null;
            DataRow[] dataRowAuthorizationCodes = null;
            DataRow[] dataRowGlobalCodes = null;
            try
            {
                dataSetHarborTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet();
                if (dataSetHarborTreatmentPlan.Tables.Contains("CustomTPServices"))
                {
                    dataTableAuthorizationCodes = SharedTables.ApplicationSharedTables.AuthorizationCodes;
                    if (dataTableAuthorizationCodes != null)
                    {
                        string TPServiceId = Request.QueryString["TPServiceId"].ToString();
                        string AuthorizationCode = Request.QueryString["AuthorizationCode"].ToString();
                        dataRowCustomTPServices = dataSetHarborTreatmentPlan.Tables["CustomTPServices"].Select("TPServiceId='" + TPServiceId + "'");
                        if (AuthorizationCode.Trim() != string.Empty)
                        {
                            dataRowAuthorizationCodes = dataTableAuthorizationCodes.Select("AuthorizationCodeId='" + AuthorizationCode + "'");
                            if (dataRowCustomTPServices.Length > 0 && dataRowAuthorizationCodes.Length > 0)
                            {
                                string UnitType = string.Empty;
                                dataTableGlobalCodes = SharedTables.ApplicationSharedTables.GlobalCodes;
                                if (dataTableGlobalCodes != null)
                                {
                                    if (dataRowAuthorizationCodes[0]["UnitType"] != DBNull.Value)
                                        dataRowGlobalCodes = dataTableGlobalCodes.Select("GlobalCodeId='" + dataRowAuthorizationCodes[0]["UnitType"].ToString() + "'");
                                    if (dataRowGlobalCodes != null && dataRowGlobalCodes.Length > 0)
                                    {
                                        UnitType = dataRowGlobalCodes[0]["CodeName"].ToString();
                                    }
                                }

                                dataRowCustomTPServices[0].BeginEdit();
                                if (dataRowAuthorizationCodes[0]["Units"] != DBNull.Value)
                                {
                                    dataRowCustomTPServices[0]["Units"] = dataRowAuthorizationCodes[0]["Units"].ToString();
                                }
                                dataRowCustomTPServices[0]["AuthorizationCodeId"] = AuthorizationCode;
                                dataRowCustomTPServices[0]["UnitType"] = UnitType;
                                dataRowCustomTPServices[0].EndEdit();

                            }
                        }
                    }
                }
                CreateGoal();
                PlaceHolderControlAssociatedNeeds.Controls.Add(PanelTxPlanMain);
            }
            finally
            {
                dataSetHarborTreatmentPlan = null;
            }
        }
        /// <summary>
        /// <Description>Called when Authorization selection is changed to get the unitType for services</Description>
        /// <Author>Rohit Katoch</Author>
        /// <createdon>8 June 2011</createdon>
        /// </summary>
        private void AuthorizationCodesChangeWithoutRecreateGoal()
        {
            DataSet dataSetHarborTreatmentPlan = null;
            DataTable dataTableAuthorizationCodes = null;
            DataTable dataTableGlobalCodes = null;
            DataRow[] dataRowCustomTPServices = null;
            DataRow[] dataRowAuthorizationCodes = null;
            DataRow[] dataRowGlobalCodes = null;
            string strUnits = "";
            string UnitType = "";
            try
            {
                dataSetHarborTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet();
                if (dataSetHarborTreatmentPlan.Tables.Contains("CustomTPServices"))
                {
                    dataTableAuthorizationCodes = SharedTables.ApplicationSharedTables.AuthorizationCodes;
                    if (dataTableAuthorizationCodes != null)
                    {
                        string TPServiceId = Request.QueryString["TPServiceId"].ToString();
                        string AuthorizationCode = Request.QueryString["AuthorizationCode"].ToString();
                        dataRowCustomTPServices = dataSetHarborTreatmentPlan.Tables["CustomTPServices"].Select("TPServiceId='" + TPServiceId + "'");
                        if (AuthorizationCode.Trim() != string.Empty)
                        {
                            dataRowAuthorizationCodes = dataTableAuthorizationCodes.Select("AuthorizationCodeId='" + AuthorizationCode + "'");
                            if (dataRowCustomTPServices.Length > 0 && dataRowAuthorizationCodes.Length > 0)
                            {

                                dataTableGlobalCodes = SharedTables.ApplicationSharedTables.GlobalCodes;
                                if (dataTableGlobalCodes != null)
                                {
                                    if (dataRowAuthorizationCodes[0]["UnitType"] != DBNull.Value)
                                        dataRowGlobalCodes = dataTableGlobalCodes.Select("GlobalCodeId='" + dataRowAuthorizationCodes[0]["UnitType"].ToString() + "'");
                                    if (dataRowGlobalCodes != null && dataRowGlobalCodes.Length > 0)
                                    {
                                        UnitType = dataRowGlobalCodes[0]["CodeName"].ToString();
                                    }
                                }

                                dataRowCustomTPServices[0].BeginEdit();
                                if (dataRowAuthorizationCodes[0]["Units"] != DBNull.Value)
                                {
                                    dataRowCustomTPServices[0]["Units"] = strUnits = Convert.ToDouble(dataRowAuthorizationCodes[0]["Units"]).ToString();
                                }
                                dataRowCustomTPServices[0]["AuthorizationCodeId"] = AuthorizationCode;
                                dataRowCustomTPServices[0]["UnitType"] = UnitType;
                                dataRowCustomTPServices[0].EndEdit();

                            }
                        }
                        else
                        {
                            dataRowCustomTPServices[0].BeginEdit();

                            dataRowCustomTPServices[0]["Units"] = DBNull.Value;

                            //dataRowCustomTPServices[0]["AuthorizationCodeId"] = DBNull.Value;
                            dataRowCustomTPServices[0]["AuthorizationCodeId"] = -1;
                            dataRowCustomTPServices[0]["UnitType"] = DBNull.Value;
                            dataRowCustomTPServices[0].EndEdit();
                        }
                    }
                }
                Response.Clear();
                Response.Write(strUnits + ";" + UnitType);
                Response.End();
            }
            finally
            {
                dataSetHarborTreatmentPlan = null;
            }
        }
        private void DeleteCustomTPNeeds()
        {
            //DataSet datasetCustomTPNeed = null;
            //try
            //{
            //    using (SHS.UserBusinessServices.CustomTPNeeds customTPNeeds = new SHS.UserBusinessServices.CustomTPNeeds())
            //    {
            //        int NeedId = 0;
            //        int.TryParse(Request.Form["NeedId"], out NeedId);
            //       datasetCustomTPNeed= customTPNeeds.DeleteCustomTPNeeds(NeedId, BaseCommonFunctions.ApplicationInfo.Client.ClientId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
            //    }
            //    GridViewCustomTPNeed.DataSource = datasetCustomTPNeed.Tables[0];
            //    GridViewCustomTPNeed.DataBind();
            //    PlaceHolderControlAssociatedTPNeeds.Controls.Add(PanelTxPlanCustomTPNeed);
            //}
            //finally
            //{
            //    datasetCustomTPNeed=null;
            //}
            DataView DataViewCustomTPNeeds = null;
            DataRow[] DataRowCustomTPGoalNeeds = null;
            try
            {
                using (DataSet DataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (DataSetTreatmentPlan != null && DataSetTreatmentPlan.Tables.Contains("CustomTPNeeds"))
                    {
                        int NeedId = 0;
                        int.TryParse(Request.Form["NeedId"], out NeedId);
                        //Updating Record Deleted information in the table CustomTPNeeds
                        DataRow DrCustomTPNeeds = DataSetTreatmentPlan.Tables["CustomTPNeeds"].Select("NeedId=" + NeedId)[0];
                        DrCustomTPNeeds.BeginEdit();
                        BaseCommonFunctions.UpdateRecordDeletedInformation(DrCustomTPNeeds);
                        DrCustomTPNeeds.EndEdit();

                        DataRowCustomTPGoalNeeds = DataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("NeedId=" + NeedId);
                        if (DataRowCustomTPGoalNeeds.Length > 0)
                        {
                            for (int Record = 0; Record < DataRowCustomTPGoalNeeds.Length; Record++)
                            {
                                DataRowCustomTPGoalNeeds[Record].BeginEdit();
                                BaseCommonFunctions.UpdateRecordDeletedInformation(DataRowCustomTPGoalNeeds[Record]);
                                DataRowCustomTPGoalNeeds[Record].EndEdit();
                            }
                        }

                        DataViewCustomTPNeeds = DataSetTreatmentPlan.Tables["CustomTPNeeds"].DefaultView;
                        DataViewCustomTPNeeds.RowFilter = "isnull(RecordDeleted,'N')<>'Y'";
                        GridViewCustomTPNeed.DataSource = DataViewCustomTPNeeds;
                        GridViewCustomTPNeed.DataBind();
                        PlaceHolderControlAssociatedTPNeeds.Controls.Add(PanelTxPlanCustomTPNeed);
                        //objectDocument = new SHS.UserBusinessServices.Document();
                        //datasetQuicktype = new DataSet();
                        //datasetQuicktype.Merge(DataSetTreatmentPlan.Tables["CustomTPNeeds"]);
                        //objectDocument.UpdateDocuments(datasetQuicktype, string.Empty, 0, string.Empty, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserName, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode, string.Empty, string.Empty, string.Empty, 5763);
                        //DataSetTreatmentPlan.Tables["CustomTPNeeds"].AcceptChanges();
                        //DataSetTreatmentPlan.Tables["CustomTPNeeds"].Clear();
                        //string whereClause = string.Empty;
                        //whereClause = "  where IsNull(RecordDeleted,'N')<>'Y' and ClientId="+BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                        //DataSet dataSetTemp = objectDocument.GetUpdatedQuickTypeData(DataSetTreatmentPlan, whereClause, "CustomTPNeeds");
                        //if (dataSetTemp != null)
                        //{
                        //    if (dataSetTemp.Tables.Count > 0)
                        //    {
                        //        DataSetTreatmentPlan.Tables["CustomTPNeeds"].Merge(dataSetTemp.Tables["CustomTPNeeds"]);
                        //    }
                        //}


                    }
                }
            }
            finally
            {
                DataViewCustomTPNeeds = null;
                //objectDocument = null;
                //datasetQuicktype=null;
            }
        }

        public void RemoveNewNeeds()
        {
            string strNeedId = Request.Form["needids"];
            if (!strNeedId.IsNullOrEmpty())
            {
                using (DataSet DataSetTreatmentPlan = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    if (BaseCommonFunctions.CheckRowExists(DataSetTreatmentPlan, "CustomTPNeeds", 0))
                    {
                        string[] arrNeedsId = strNeedId.Split(',');
                        for (int count = 0; count < arrNeedsId.Length - 1; count++)
                        {
                            int needId = 0;
                            int.TryParse(arrNeedsId[count], out needId);

                            DataRow[] drCustomTPNeeds = DataSetTreatmentPlan.Tables["CustomTPNeeds"].Select("NeedId=" + needId + "");
                            if (drCustomTPNeeds.Length > 0)
                                DataSetTreatmentPlan.Tables["CustomTPNeeds"].Rows.Remove(drCustomTPNeeds[0]);


                        }
                    }
                }
            }
        }

        //private void DeleteCustomTPNeeds()
        //{
        //    DataSet datasetCustomTPNeed = null;
        //    try
        //    {
        //        using (SHS.UserBusinessServices.CustomTPNeeds customTPNeeds = new SHS.UserBusinessServices.CustomTPNeeds())
        //        {
        //            int NeedId = 0;
        //            int.TryParse(Request.Form["NeedId"], out NeedId);
        //            datasetCustomTPNeed = customTPNeeds.DeleteCustomTPNeeds(NeedId, BaseCommonFunctions.ApplicationInfo.Client.ClientId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
        //        }
        //        GridViewCustomTPNeed.DataSource = datasetCustomTPNeed.Tables[0];
        //        GridViewCustomTPNeed.DataBind();
        //        PlaceHolderControlAssociatedTPNeeds.Controls.Add(PanelTxPlanCustomTPNeed);
        //    }
        //    finally
        //    {
        //        datasetCustomTPNeed = null;
        //    }
        //}
    }

}