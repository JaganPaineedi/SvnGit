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
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;

public partial class RefillDenialReason : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        FillRefillDenialDropDown();
        DropDownDenialReason.Focus();
        if (Request.QueryString["SureScriptsRefillRequestId"] != null && Request["SureScriptsRefillRequestId"] != "")
        {
            string SureScriptsRefillRequestId = Request.QueryString["SureScriptsRefillRequestId"].ToString();
            if (Request.QueryString["UserCode"] != null && Request["UserCode"] != "")
            {
                string UserCode = Request.QueryString["UserCode"].ToString();
                if (Request.QueryString["RequiresCallBack"] != null &&
                    Request.QueryString["RequiresCallBack"].ToString().ToLower() == "true")
                {
                    DropDownDenialReason.Enabled = false;
                    DropDownDenialReason.Visible = false;
                    Message1.Visible = false;
                    Message2.Visible = true;
                    ButtonOk.Attributes.Add("onclick",
                                            "ButtonDenyWithNewRxClick('" + SureScriptsRefillRequestId + "','" + UserCode + "','" +
                                            this.DropDownDenialReason.ClientID + "','" + this.TextBoxDenialReason.ClientID + "','" +
                                            Request.QueryString["Clientid"].ToString() + "','" + Request.QueryString["PharmacyId"].ToString() + "','" +
                                            Request.QueryString["PharmacyName"].ToString() + "','" + Request.QueryString["DrugCategory"].ToString() + "');return false;");
                }

                else if (Request.QueryString["DenyType"].ToString().ToUpper() == "CHANGE") //Added By PranayB w.r.t MeaningFull Uses 
                
                {
                    Message1.Visible = true;
                    Message2.Visible = false;
                    ButtonOk.Attributes.Add("onclick",
                                            "ButtonDenyClick('" + SureScriptsRefillRequestId + "','" + UserCode + "','" +
                                            this.DropDownDenialReason.ClientID + "','" +
                                            this.TextBoxDenialReason.ClientID +"','CHANGE');return false;");
                }

                else
                {
                    Message1.Visible = true;
                    Message2.Visible = false;
                    ButtonOk.Attributes.Add("onclick",
                                            "ButtonDenyClick('" + SureScriptsRefillRequestId + "','" + UserCode + "','" +
                                            this.DropDownDenialReason.ClientID + "','" +
                                            this.TextBoxDenialReason.ClientID + "');return false;");
                }
            }
        }
    }
    //For Bind the Refill Denail Reason DropDown
    private void FillRefillDenialDropDown()
    {
        CommonFunctions.Event_Trap(this);
        DataSet DataSetDenialReason = null;
        DataRow[] DataRowDenialReason = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='REFILLDENIEDREASON' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");

        try
        {
            DataSetDenialReason = new DataSet();
            DataSetDenialReason.Merge(DataRowDenialReason);
            if (DataSetDenialReason.Tables.Count > 0)
            {
                DataSetDenialReason.Tables[0].TableName = "GlobalCodesRefillDenialReasons";
                if (DataSetDenialReason.Tables["GlobalCodesRefillDenialReasons"].Rows.Count > 0)
                {
                    DropDownDenialReason.DataSource = DataSetDenialReason.Tables["GlobalCodesRefillDenialReasons"];
                    DropDownDenialReason.DataTextField = "CodeName";
                    DropDownDenialReason.DataValueField = "GlobalCodeId";
                    DropDownDenialReason.DataBind();

                }
            }
            DropDownDenialReason.Items.Insert(0, new ListItem("........Select Denial Reason........", "0"));
            DropDownDenialReason.SelectedIndex = 0;

        }
        catch (Exception ex)
        {



        }
        finally
        {
            DataSetDenialReason = null;

        }


    }
}
