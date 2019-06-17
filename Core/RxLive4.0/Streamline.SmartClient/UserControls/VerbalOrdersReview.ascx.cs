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
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using Microsoft.Reporting.WebForms;
using System.Text;
using System.Collections.Generic;
using System.IO;
using System.Drawing;

public partial class UserControls_VerbalOrdersReview : BaseActivityPage
{
    Streamline.UserBusinessServices.ClientMedication objClientMedication = new ClientMedication();
    DataSet _dsVerbalOrder;
    bool onSign = false;
    private MedicationList.MedicationInteractionsDataTable _dtMedicationInteractionTemp;
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {

            DataSet DatasetSystemConfigurationKeys = null;
            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
            {
                HiddenFieldRXFourPrescriptionsperpage.Value = "Y";
            }
            
                //Added in ref to Task#2895
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";
                LinkButtonStartPage.Style["display"] = "block";
            }
            this.txtPasword.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonSign.ClientID + "').click();return false;}} else {return true}; ");
            _dtMedicationInteractionTemp = new MedicationList.MedicationInteractionsDataTable();      
        }
        catch (Exception ex)
        {

        }
    }
    public override void Activate()
    {
        string OrderType = "";
        try
        {
            onSign = false;
            if (((HiddenField)(this.Page.FindControl("HiddenFieldVerbal"))).Value.ToString() == string.Empty)
            {
                ((HiddenField)(this.Page.FindControl("HiddenFieldVerbal"))).Value = Session["OpenVerbalOrder"].ToString();
            }
            OrderType = ((HiddenField)(this.Page.FindControl("HiddenFieldVerbal"))).Value.ToString();
            //Code modified by Loveena in ref to Task#2887
            //Session["OpenVerbalOrder"] = ((HiddenField)(this.Page.FindControl("HiddenFieldVerbal"))).Value;
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).VerbalOrdersRequireApproval == "Y" && OrderType == "V")
            {
                Session["OpenVerbalOrder"] = "V";
            }
            else
                Session["OpenVerbalOrder"] = "A";
            if (Session["OpenVerbalOrder"].ToString() == "V")
            {
                LabelTitle.Text = "Verbal Orders Review for " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).LastName + ", " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).FirstName + " " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).StaffDegree;
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).VerbalOrdersRequireApproval == "Y")
                {
                    createControls();
                }
            }
            else
            {
                LabelTitle.Text = "Order Approval for " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).LastName + ", " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).FirstName + " " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).StaffDegree;
                createControls();
            }
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
    }

    public void GetControl(Object sender, EventArgs e)
    {
        try
        {
            onSign = true;
            createControls();
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
    }

    public void createControl(Object sender, EventArgs e)
    {
        try
        {
            createControls();
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
    }

    public void createControls()
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            _dsVerbalOrder = objClientMedication.GetVerbalOrderReviewData(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, Session["OpenVerbalOrder"].ToString());
            Session["dsVerbalOrder"] = _dsVerbalOrder;
            CreateLabelRow();
            Table tableControls = new Table();
            tableControls.Width = new Unit(100, UnitType.Percentage);
            tableControls.ID = "tableApprovedOrders";
            tableControls.Attributes.Add("tableApprovedOrders", "true");
            string myscript = "<script type='text/javascript'>";
            myscript += "function InitializeComponents(){;";
            //DataView dataViewVerbalOrder = _dsVerbalOrder.Tables[0].DefaultView;
            //dataViewVerbalOrder.Sort = "ClientMedicationScriptId asc";
            var rowClass = "GridViewRowStyle";
            for (int _RowCount = 0; _RowCount < _dsVerbalOrder.Tables[0].Rows.Count; _RowCount++)
            {
                tableControls.Rows.Add(CreateOrderRow(_dsVerbalOrder.Tables[0].Rows[_RowCount], _RowCount, ref myscript, rowClass));
                  rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                               }
            myscript += "}</script>";
            tableControls.CellPadding = 0;
            tableControls.CellSpacing = 0;
            PlaceHolder.Controls.Add(tableControls);
            ScriptManager.RegisterStartupScript(PlaceHolder, PlaceHolder.GetType(), PlaceHolder.ClientID.ToString(), myscript, false);
            HiddenFieldSign.Value = "false";
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }

    }

    private void CreateLabelRow()
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            Table _Table = new Table();
            _Table.Width = new Unit(100, UnitType.Percentage);
            TableRow _TableRow = new TableRow();
            TableCell _TableCell0 = new TableCell();
            TableCell _TableCell1 = new TableCell();
            TableCell _TableCell2 = new TableCell();
            TableCell _TableCell3 = new TableCell();

            _Table.ID = "Table";



            Label _lblClientName = new Label();
            _lblClientName.ID = "ClientName";
            _lblClientName.Visible = true;
            _lblClientName.Text = "Patient Name";

            Label _lblCreatedBy = new Label();
            _lblCreatedBy.ID = "CreatedBy";
            _lblCreatedBy.Visible = true;
            _lblCreatedBy.Text = "Created By";

            Label _lblDate = new Label();
            _lblDate.ID = "Date";
            _lblDate.Visible = true;
            _lblDate.Text = "Date";

            _TableCell0.Width = new Unit(10, UnitType.Percentage);
            _TableCell1.Controls.Add(_lblClientName);
            _TableCell1.Style.Add("noWrap", "nowrap");
            _TableCell1.Width = new Unit(20, UnitType.Percentage);
            _TableCell2.Controls.Add(_lblCreatedBy);
            _TableCell2.Width = new Unit(20, UnitType.Percentage);
            _TableCell3.Controls.Add(_lblDate);
            _TableCell3.Width = new Unit(20, UnitType.Percentage);

            _TableRow.Controls.Add(_TableCell0);
            _TableRow.Controls.Add(_TableCell1);
            _TableRow.Controls.Add(_TableCell2);
            _TableRow.Controls.Add(_TableCell3);

            
                TableCell _TableCell4 = new TableCell();
                Label _lblInteraction = new Label();
                _lblInteraction.ID = "Interaction";
                _lblInteraction.Visible = true;
                _lblInteraction.Text = "Interactions";
                _TableCell4.Controls.Add(_lblInteraction);
                _TableCell4.Width = new Unit(20, UnitType.Percentage);
                _TableRow.Controls.Add(_TableCell4);
           

            _Table.CssClass = "Label";
            _Table.Controls.Add(_TableRow);
            PlaceLabel.Controls.Add(_Table);
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            throw (ex);
        }
    }


    private TableRow CreateOrderRow(DataRow dr, int rowIndex, ref string myscript, string rowClass)
    {
        try
        {

            CommonFunctions.Event_Trap(this);
            Table _Table = new Table();
            _Table.Width = new Unit(100, UnitType.Percentage);
            TableRow _TableRow = new TableRow();
            _TableRow.ID = "TableOrderRow_" + rowIndex;
            TableCell _TableCell0 = new TableCell();
            TableCell _TableCell1 = new TableCell();
            TableCell _TableCell2 = new TableCell();
            TableCell _TableCell3 = new TableCell();
            TableCell tdInteraction = new TableCell();

            _Table.ID = "TableOrder" + rowIndex;

            Color[] _color =
                    {
                        Color.Pink,
                        Color.Red,
                        Color.Yellow,
                        Color.Green,
                        Color.Plum,
                        Color.Aqua,
                        Color.PaleGoldenrod,
                        Color.Peru,
                        Color.Tan,
                        Color.Khaki,
                        Color.DarkGoldenrod,
                        Color.Maroon,
                        Color.OliveDrab,
                        //Added by Chandan on 21st Nov 2008 for Adding new colors on Monograph Boxes.
                        Color.Crimson,
                        Color.Beige,
                        Color.DimGray,
                        Color.ForestGreen,
                        Color.Indigo,
                        Color.LightCyan
                        //Added End here by Chanda
                    };

            RadioButton radioButtonOrder = new RadioButton();
            radioButtonOrder.ID = "radioButtonOrder" + rowIndex;
            radioButtonOrder.Attributes.Add("onclick", "GetVerbalOrderReviewData(" + dr["ClientMedicationScriptId"] + "," + dr["DrugCategory"] + ");");
            radioButtonOrder.GroupName = "rdo";
            HiddenField HiddenScriptId = this.Page.FindControl("HiddenFieldScriptId") as HiddenField;
            //if (HiddenScriptId.Value != "")
            //    {
            //if (HiddenScriptId.Value == dr["ClientMedicationScriptId"].ToString())
            if (rowIndex == 0)
            {
                radioButtonOrder.Checked = true;
                ScriptManager.RegisterStartupScript(lblDob, lblDob.GetType(), this.ClientID, "GetVerbalOrderReviewData(" + dr["ClientMedicationScriptId"] + "," + dr["DrugCategory"] + ");", true);
            }
            //else
            //    {
            //   // if (onSign == true)
            //        //{
            //        radioButtonOrder.Checked = true;
            //        ScriptManager.RegisterStartupScript(lblDob, lblDob.GetType(), this.ClientID, "GetVerbalOrderReviewData(" + dr["ClientMedicationScriptId"] + ");", true);
            //        //}
            //    }
            //}
            Label lblClientName = new Label();
            lblClientName.CssClass = "Label";
            //lblClientName.Text = dr["FirstName"] + ", " + dr["LastName"];
            lblClientName.Text = dr["LastName"] + ", " + dr["FirstName"] + " (" + dr["ClientId"] + ")";
           
                lblClientName.Attributes.Add("Style", "font-weight: bold; text-decoration: underline; cursor: pointer");
                lblClientName.Attributes.Add("onclick", "SetPatientMainPage(" + dr["ClientId"] + ")");
                Session["ClientId"] = dr["ClientId"].ToString();
            

            Label lblCreatedBy = new Label();
            lblCreatedBy.CssClass = "Label";
            lblCreatedBy.Text = dr["CreatedBy"].ToString();

            Label lblDate = new Label();
            lblDate.CssClass = "Label";
            lblDate.Text = Convert.ToDateTime(dr["OrderDate"]).ToString("MM/dd/yyyy");

            _TableCell0.Controls.Add(radioButtonOrder);
            _TableCell0.Width = new Unit(10, UnitType.Percentage);
            _TableCell1.Controls.Add(lblClientName);
            _TableCell1.Width = new Unit(20, UnitType.Percentage);
            _TableCell2.Controls.Add(lblCreatedBy);
            _TableCell2.Width = new Unit(20, UnitType.Percentage);
            _TableCell3.Controls.Add(lblDate);
            _TableCell3.Width = new Unit(20, UnitType.Percentage);

            _TableRow.Controls.Add(_TableCell0);
            _TableRow.Controls.Add(_TableCell1);
            _TableRow.Controls.Add(_TableCell2);
            _TableRow.Controls.Add(_TableCell3);
            _TableRow.CssClass = rowClass;   
             

                DataTable dtClientMedicationScripts = _dsVerbalOrder.Tables[1];
                DataTable dtClientMedications = _dsVerbalOrder.Tables[2];
                string medicationId = dtClientMedicationScripts.Rows[rowIndex]["ClientMedicationId"].ToString();
                if (dtClientMedications.Rows.Count > 0)
                {
                    string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                                          medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                    DataRow[] drInteraction = dtClientMedications.Select(Query);

                    foreach (DataRow drT in drInteraction)
                    {
                        if (!drT["InteractionLevel"].ToString().IsNullOrWhiteSpace())
                        {
                            int InteractionId = Convert.ToInt32(drT["ClientMedicationInteractionId"]);
                            var backColor = new Color();
                            if ((drT["Color"] == DBNull.Value) || (String.IsNullOrEmpty(drT["Color"].ToString())))
                            {
                                foreach (Color clr in _color)
                                {
                                    DataRow[] drColorExits =
                                        dtClientMedications.Select("Color='" + clr.ToArgb().ToString() +
                                                                            "'");
                                    if (drColorExits.Length < 1)
                                    {
                                        backColor = clr;
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                backColor = Color.FromArgb(Convert.ToInt32(drT["Color"]));
                            }


                            drT["Color"] = backColor.ToArgb().ToString();

                            Label lblInteraction = new Label();

                            lblInteraction.CssClass = "drugInteraction";
                            lblInteraction.ToolTip = "Drug Interaction";
                            lblInteraction.ID = "QInteraction";
                            lblInteraction.Text = drT["InteractionLevel"].ToString();
                            lblInteraction.BackColor = backColor;
                            lblInteraction.Width = 10;

                            tdInteraction.Controls.Add(lblInteraction);
                            tdInteraction.Width = new Unit(20, UnitType.Percentage);
                            _TableRow.Controls.Add(tdInteraction);

                        }
                    }

                    if (dtClientMedications.Select(Query + " and InteractionLevel=1").Length > 0)
                    {
                        // _boolRowWithInteractionFound.Value = "1";
                    }

                }
            
            return _TableRow;
            
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            throw (ex);
        }
        finally
        {

        }
    }

    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("MedicationLogin.aspx");
    }
    //added By priya Ref:Task no;2924
    /// <summary>
    /// Author Rishu
    /// Purpose To enable/disable buttons based on Staff Permissions
    /// </summary>
    /// <param name="per"></param>
    /// <returns></returns>
    public string enableDisabled(Permissions per)
    {

        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
            return "";
        else
            return "Disabled";
    }

}

