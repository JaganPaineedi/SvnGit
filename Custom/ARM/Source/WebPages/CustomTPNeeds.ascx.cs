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
using DevExpress.Web.ASPxGridView;
using System.Linq;

public partial class ActivityPages_Harbor_Client_Detail_CustomTPNeeds : SHS.BaseLayer.ActivityPages.CustomActivityPage
{
    int NeedId = 0;
    string NeedText = string.Empty;
    int TPGoalId = 0;

    /// <summary>   
    /// Davinder Kumar 02-May 2011
    /// Method to Bind The Need grid on the Popup
    /// </summary>
    protected override void OnLoad(EventArgs e)
    {
        //SHS.UserBusinessServices.CustomTPNeeds customTPNeeds = null;
        //customTPNeeds = new SHS.UserBusinessServices.CustomTPNeeds();
        DataView DataViewCustomTPNeeds = null;
        try
        {
            using (DataSet datasetCustomTPNeed = BaseCommonFunctions.GetScreenInfoDataSet())
            {
                HiddenField_TPGoalId.Value = GetRequestParameterValue("TPGoalId");
                TPGoalId = Convert.ToInt32(HiddenField_TPGoalId.Value);

                ///////////////////////////
                //var res=from ctpn in datasetCustomTPNeed.Tables["CustomTPNeeds"].AsEnumerable()
                //        join ctpgn in datasetCustomTPNeed.Tables["CustomTPGoalNeeds"].AsEnumerable()
                //        on ctpn.Field<int>("CustomTPNeedId") equals ctpgn.Field<int>("CustomTPNeedId") into joinedTable
                //        from ch in joinedTable.DefaultIfEmpty()
                //        select new
                //        {
                //            CustomTPNeedId=ctpn.Field<int>("CustomTPNeedId"),
                //            NeedText=ctpn.Field<string>("NeedText"),
                //            Need
                //        }


                //////////////////////////


                DataViewCustomTPNeeds = datasetCustomTPNeed.Tables["CustomTPNeeds"].DefaultView;
                DataViewCustomTPNeeds.RowFilter = "isnull(RecordDeleted,'N')<>'Y'";
                GridViewCustomTPNeed.DataSource = DataViewCustomTPNeeds;

                //GridViewCustomTPNeed.DataSource = datasetCustomTPNeed.Tables["CustomTPNeeds"];
                GridViewCustomTPNeed.DataBind();
            }
        }
        finally
        {
            DataViewCustomTPNeeds = null;
            //customTPNeeds = null;
        }

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

            DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + TPGoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
            if (dRowGoalNeed.Length > 0)
            {

                Checked = "Checked";
                //e.Row.Cells[0].Text = "<table><tr><td style='width:20px;'><img id=Img_CustomTPGoalNeeds_" + NeedId + " name=Img_CustomTPGoalNeeds_" + NeedId + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "   style='cursor:hand;display:None;'  onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "_" + NeedText + "' name='CheckBox_" + NeedId + "_" + NeedText + "' style='width:20px;' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <label for='CheckBox_" + NeedId + "_" + NeedText + "' >" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(NeedText, 20) + "</label> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='"+lstSessionNeedId+"' /> </td></tr></table>";
                e.Row.Cells[0].Text = "<table width='43'><tr><td style='width:18px;'><img id='Img_CustomTPGoalNeeds_" + NeedId + "' name='Img_CustomTPGoalNeeds_" + NeedId + "' src='" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif'  tag='" + dRowGoalNeed[0]["TPGoalNeeds"].ToString() + "'   style='cursor:hand;display:None;'  onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td style='width:18px'><input type='checkbox' checked='checked'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /> <input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
                e.Row.Cells[2].Text = (dRowGoalNeed[0]["DateNeedAddedtoPlan"].ToString().Trim() != string.Empty) ? Convert.ToDateTime(dRowGoalNeed[0]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "";
            }
            else
            {
                Checked = string.Empty;
                e.Row.Cells[0].Text = "<table width='43'><tr><td style='width:18px;'><img id='Img_CustomTPGoalNeeds_" + NeedId + "'  name='Img_CustomTPGoalNeeds_" + NeedId + "' src='" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif'  tag='" + -1 + "'   style='cursor:hand;display:block;' onclick = \"DeleteTpGoalNeeds('" + NeedId + "','" + e.GetValue("LinkedInDb") + "','" + e.GetValue("LinkedInSession") + "');\"/></td><td style='width:18px'><input type='checkbox'  id='CheckBox_" + NeedId + "' name='CheckBox_" + NeedId + "' onclick=ChangeDisplayChecked('Img_CustomTPGoalNeeds_" + NeedId + "','CheckBox_" + NeedId + "') /><input type='hidden' id='Hidden_" + NeedId + "' value='" + NeedText + "' /> <input type='hidden' id='HiddenSessionNeeds_" + NeedId + "' value='" + lstSessionNeedId + "' /> </td></tr></table>";
                
            }
            e.Row.Cells[1].Text = "<label for='CheckBox_" + NeedId + "_" + NeedText + "' id='label_"+NeedId+"'>" + SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(HttpUtility.UrlDecode(NeedText), 20) + "</label>";
            //GrantPermissionTemplateItems

            //e.DataColumn.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            //DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + TPGoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");



        }


    }


    /// <summary>
    /// Davinder Kumar 03-06-2011
    /// Method Use To Prepare the Girdview Cells correspond to goal id and need id 
    /// </summary>
    protected void GridViewCustomTPNeed_HtmlDataCellPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableDataCellEventArgs e)
    {
        //string Checked=string.Empty;
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

        //        DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + TPGoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
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
        //        e.DataColumn.CellStyle.HorizontalAlign=HorizontalAlign.Center;
        //        DataRow[] dRowGoalNeed = dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"].Select("TPGoalId='" + TPGoalId + "' AND NeedId='" + NeedId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
        //        if (dRowGoalNeed.Length > 0)
        //        {
        //            e.Cell.Text = (dRowGoalNeed[0]["DateNeedAddedtoPlan"].ToString().Trim()!=string.Empty)?Convert.ToDateTime(dRowGoalNeed[0]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy"):"";
        //        }
        //    }
        //}
    }



}