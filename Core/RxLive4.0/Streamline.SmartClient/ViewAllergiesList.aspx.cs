using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
namespace Streamline.SmartClient
{
    public partial class ViewAllergiesList : Streamline.BaseLayer.ActivityPages.ActivityPage
    {

        private static int GridRowNumber = 0;
        private int AllergenConceptIdToReturn;
        private string AllergenConceptDescriptionToReturn;
        public int i = 0;
        DataSet dsAllergiesData = null;
        public string CalledFrom;
        public bool _IsClose = false;
        public int m_iRowIdx = 0;
        int _SearchId = 0;
        private string AllergySearchCriteria;
        private int SelectedRowNumber;
        bool flagSelected = false;
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {

                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                AllergySearchCriteria = "";

                //Added by Loveena in ref to task#2378 - CopyrightInfo
                if (Session["UserContext"] != null)
                    LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
                if (Page.IsPostBack == false)
                {
                    try
                    {


                        GetAllergiesData(Request.QueryString["SearchCriteria"].ToString());
                        string ss = "";
                        ss = Request.QueryString["SearchCriteria"].ToString();

                        if (ss.IndexOf('!') > 0)
                            ss = ss.Replace('!', '&');
                        if (ss.IndexOf('^') > 0)
                            ss = ss.Replace('^', '#');

                        AllergySearchCriteria = ss;
                        BindGridAllergies();
                        //this.PlaceHolderScript.Controls.Clear();                        

                    }
                    catch (Exception ex)
                    {

                        ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + ex.Message.ToString() + "', true);", true);
                    }
                }


                DataRow[] DataRowAllergyReaction = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='ALLERGYREACTION' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");
                DataRow[] DataRowAllergySeverity = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='ALLERGYSEVERITY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");



                DataSet DataSetAllergyReaction = new DataSet();
                DataSetAllergyReaction.Merge(DataRowAllergyReaction);
                if (DataSetAllergyReaction.Tables.Count > 0)
                {
                    DataSetAllergyReaction.Tables[0].TableName = "GlobalCodesAllergyReaction";
                    if (DataSetAllergyReaction.Tables["GlobalCodesAllergyReaction"].Rows.Count > 0)
                    {
                        DropDownListAllergyReaction.DataSource = DataSetAllergyReaction.Tables["GlobalCodesAllergyReaction"];
                        DropDownListAllergyReaction.DataTextField = "CodeName";
                        DropDownListAllergyReaction.DataValueField = "GlobalCodeId";
                        DropDownListAllergyReaction.DataBind();
                        ListItem itemAllergyReaction = new ListItem(" ", "-1");
                        DropDownListAllergyReaction.Items.Insert(0, itemAllergyReaction);

                    }
                }

                DataSet DataSetAllergySeverity = new DataSet();
                DataSetAllergySeverity.Merge(DataRowAllergySeverity);
                if (DataSetAllergySeverity.Tables.Count > 0)
                {
                    DataSetAllergySeverity.Tables[0].TableName = "GlobalCodesAllergySeverity";
                    if (DataSetAllergySeverity.Tables["GlobalCodesAllergySeverity"].Rows.Count > 0)
                    {
                        DropDownListAllergySeverity.DataSource = DataSetAllergySeverity.Tables["GlobalCodesAllergySeverity"];
                        DropDownListAllergySeverity.DataTextField = "CodeName";
                        DropDownListAllergySeverity.DataValueField = "GlobalCodeId";
                        DropDownListAllergySeverity.DataBind();
                        ListItem itemAllergySeverity = new ListItem(" ", "-1");
                        DropDownListAllergySeverity.Items.Insert(0, itemAllergySeverity);

                    }
                }


            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

                string ParseMessage = ex.Message;
                if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
                {
                    int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                    ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                    //  ShowError(ParseMessage, true);
                }
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + ex.Message.ToString() + "', true);", true);
            }
        }

        /// <summary>
        /// Retrieves the Allergies data. and put it in a Grid.
        /// <Author>Author: Sonia</Author>
        /// <CreatedDate>Date: 1-Nov-07</CreatedDate>
        /// </summary>
        private void GetAllergiesData(string SearchCriteria)
        {

            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            try
            {
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                dsAllergiesData = objectClientMedications.GetAllergiesData(SearchCriteria);
            }
            //Exception ex added by Pratap on 29th June 2007
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                objectClientMedications = null;
            }

        }
        /// <summary>
        /// Bind the Allergies Grid
        /// <Author>Author: Sonia</Author>
        /// <CreatedDate>Date: 1-Nov-07</CreatedDate>
        /// </summary>
        private void BindGridAllergies()
        {
            DataView DataViewAllergies;
            try
            {
                CommonFunctions.Event_Trap(this);
                DataViewAllergies = dsAllergiesData.Tables[0].DefaultView;
                DataViewAllergies.Sort = "ConceptDescription";
                DataGridAllergies.DataSource = DataViewAllergies;
                DataGridAllergies.PageIndex = 0;
                DataGridAllergies.DataBind();

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                DataViewAllergies = null;
            }






        }





        protected void DataGridAllergies_RowCreated(object sender, GridViewRowEventArgs e)
        {
			RadioButton radioSelect = (RadioButton)e.Row.FindControl("RadioSelect");
           
        }
        protected void DataGridAllergies_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    RadioButton radioSelect = (RadioButton)e.Row.FindControl("RadioSelect");
					radioSelect.GroupName = "Radio";	
                    Label lblAllergenConceptId = (Label)e.Row.FindControl("lblAllergenConceptId");
                    Label lblAllergenConceptDescription = (Label)e.Row.FindControl("lblAllergenConceptDescription");
                    //  radioSelect.Attributes.Add("onkeypress", "fnGetSelected(event,this);");
                    e.Row.Attributes.Add("ondblclick", "AllergySearch.returnOnClick('" + radioSelect.ClientID + "','" + DataGridAllergies.ClientID + "','" + lblAllergenConceptId.Text + "');");
                    e.Row.Attributes.Add("OnClick", "AllergySearch.ChangeColor('" + e.Row.ClientID + "','" + DataGridAllergies.ClientID + "','" + radioSelect.ClientID + "','" + lblAllergenConceptId.Text + "');");
                    // e.Row.Attributes.Add("onkeydown", "SelectOnChange('" + DataGridAllergies.ClientID + "','" + DataGridAllergies.DataKeys[e.Row.DataItemIndex].Value.ToString() + "');");
                    e.Row.Attributes.Add("onkeydown", "AllergySearch.SelectOnChange('" + DataGridAllergies.ClientID + "','" + lblAllergenConceptId.Text + "');setFocus('" + e.Row.ClientID + "'); return false; ");

                    // e.Row.Cells[1].Style.Value = "Display:None";
                    if (lblAllergenConceptDescription.Text.ToString().Trim().ToUpper() == AllergySearchCriteria.ToUpper())
                    {
                        radioSelect.Checked = true;
                        e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#6D71FC");
                        e.Row.Style.Add("Color", "White");
                        Page.SetFocus(e.Row);
                        HiddenAllergyId.Value = lblAllergenConceptId.Text.ToString();
                        HiddenRadioObject.Value = e.Row.ClientID.ToString();
                        HiddenRadioSelectedObject.Value = e.Row.ClientID.ToString() + "_RadioSelect";
                        flagSelected = true;
                        SelectedRowNumber = e.Row.RowIndex + 1;
                        HiddenSelectedRowNumber.Value = SelectedRowNumber.ToString();
                    }
                    /*  if (flagSelected == false)
                      {
                          if (lblAllergenConceptDescription.Text.ToUpper().IndexOf(AllergySearchCriteria.ToUpper()) > -1)
                          {
                              SelectedRowNumber = e.Row.RowIndex + 1;
                              HiddenSelectedRowNumber.Value = SelectedRowNumber.ToString();
                              flagSelected = true;
                          }
                      }*/


                }
                if (e.Row.RowType == DataControlRowType.Header)
                {


                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            }
        }


    }
}
