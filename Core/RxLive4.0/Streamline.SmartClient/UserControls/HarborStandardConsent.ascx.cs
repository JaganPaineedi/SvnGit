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
using System.Collections.Generic;

public partial class UserControls_PatientConsentForm : Streamline.BaseLayer.BaseActivityPage
    {
    Streamline.UserBusinessServices.ClientMedication objClientMedications = null;
    protected override void Page_Load(object sender, EventArgs e)
        {

        }

    public override void Activate()
        {
        base.Activate();
        CreateControls();
        }
    private void CreateControls()
        {        
        try
            {
            objClientMedications = new ClientMedication();
            CommonFunctions.Event_Trap(this);
          
            PanelHarborConsent.Controls.Clear();
            Table tblHarborStandardConsent = new Table();
            tblHarborStandardConsent.ID = System.Guid.NewGuid().ToString();

            tblHarborStandardConsent.Width = new Unit(98, UnitType.Percentage);

            
            string myscript = "<script id='HarborStandarConsent' type='text/javascript'>";
            myscript += "function RegisterMedicationListControlEvents(){try{ ";

            DataSet DataSetClientMedications = new DataSet();
            if (Session["DataSetClientMedications"] != null)
                {
                DataSetClientMedications = (DataSet)Session["DataSetClientMedications"];

                foreach (DataRow drMedication in DataSetClientMedications.Tables["ClientMedications"].Rows)
                    {
                    string newId = System.Guid.NewGuid().ToString();
                    string tblId = this.ClientID + this.ClientIDSeparator + tblHarborStandardConsent.ClientID;
                    TableRow trTemp = new TableRow();
                    trTemp.ID = "Tr_" + newId;

                    TableCell tdMedication = new TableCell();
                    tdMedication.Text = "Medication";
                    tdMedication.CssClass = "labelFont";
                    //tdMedication.Width = new Unit(20, UnitType.Pixel);

                    TableCell tdMedicationName = new TableCell();
                    tdMedicationName.Text = drMedication["MedicationName"].ToString();
                    //tdMedicationName.Wrap = false;           
                    tdMedicationName.CssClass = "LabelClaimline";
                    //tdMedicationName.Width = new Unit(100, UnitType.Pixel);

                    trTemp.Cells.Add(tdMedication);
                    trTemp.Cells.Add(tdMedicationName);

                    tblHarborStandardConsent.Rows.Add(trTemp);
                  
                    DataRow[] _drMedicationInstructions=DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + Convert.ToInt32(drMedication["ClientMedicationId"]));

                    TableCell tdInstructions = new TableCell();
                    tdInstructions.Text = "Instructions";
                    tdInstructions.CssClass = "labelFont";
                    //tdInstructions.Width = new Unit(20, UnitType.Pixel);

                    TableCell tdInstructionsText = new TableCell();
                    tdInstructionsText.Text = _drMedicationInstructions[0]["Instruction"].ToString();
                    //tdInstructionsText.Wrap = false;                 
                    tdInstructionsText.CssClass = "LabelClaimline";
                    //tdInstructionsText.Width = new Unit(150, UnitType.Pixel);

                    TableCell tdFrom = new TableCell();
                    tdFrom.Text = "From";
                    tdFrom.CssClass = "labelFont";
                    //tdFrom.Width = new Unit(20, UnitType.Pixel);

                    TableCell tdFromDate = new TableCell();
                    if (_drMedicationInstructions[0]["StartDate"] != System.DBNull.Value)
                        tdFromDate.Text = Convert.ToDateTime(_drMedicationInstructions[0]["StartDate"]).ToString("MM/dd/yyyy");
                    tdFromDate.CssClass = "LabelClaimline";
                    //tdFromDate.Width = new Unit(50, UnitType.Pixel);
                    //tdFromDate.Wrap = false;

                    TableCell tdTo = new TableCell();
                    tdTo.Text = "To";
                    tdTo.CssClass = "labelFont";
                    //tdTo.Width = new Unit(20, UnitType.Pixel);

                    TableCell tdToDate = new TableCell();
                    if (_drMedicationInstructions[0]["EndDate"] != System.DBNull.Value)
                    tdToDate.Text = Convert.ToDateTime(_drMedicationInstructions[0]["EndDate"]).ToString("MM/dd/yyyy");
                    tdToDate.CssClass = "LabelClaimline";
                    //tdToDate.Width = new Unit(50, UnitType.Pixel);
                    //tdToDate.Wrap = false;

                    trTemp.Cells.Add(tdInstructions);
                    trTemp.Cells.Add(tdInstructionsText);
                    trTemp.Cells.Add(tdFrom);
                    trTemp.Cells.Add(tdFromDate);
                    trTemp.Cells.Add(tdTo);
                    trTemp.Cells.Add(tdToDate);

                    tblHarborStandardConsent.Rows.Add(trTemp);

                    if (_drMedicationInstructions.Length > 1)
                        {
                        for (int index = 1; index < _drMedicationInstructions.Length; index++)
                            {
                            TableCell tdDummy = new TableCell();
                            tdDummy.ColumnSpan = 2;

                            TableCell tdInstructionsNewRow = new TableCell();
                            tdInstructionsNewRow.Text = "Instructions";
                            tdInstructionsNewRow.CssClass = "labelFont";
                            //tdInstructionsNewRow.Width = new Unit(20, UnitType.Pixel);

                            TableCell tdInstructionsTextNewRow = new TableCell();
                            tdInstructionsTextNewRow.Text = _drMedicationInstructions[index]["Instruction"].ToString();                            
                            //tdInstructionsTextNewRow.Wrap = false;
                            tdInstructionsTextNewRow.CssClass = "LabelClaimline";
                            //tdInstructionsTextNewRow.Width = new Unit(150, UnitType.Pixel);

                            TableCell tdFromNewRow = new TableCell();
                            tdFromNewRow.Text = "From";
                            tdFromNewRow.CssClass = "labelFont";

                            TableCell tdFromDateNewRow = new TableCell();
                            if (_drMedicationInstructions[index]["StartDate"] != System.DBNull.Value)
                            tdFromDateNewRow.Text = Convert.ToDateTime(_drMedicationInstructions[index]["StartDate"]).ToShortDateString();
                            //tdFromDateNewRow.Wrap = false;                            
                            tdFromDateNewRow.CssClass = "LabelClaimline";
                            //tdFromDateNewRow.Width = new Unit(50, UnitType.Pixel);

                            TableCell tdToNewRow = new TableCell();
                            tdToNewRow.Text = "To";
                            tdToNewRow.CssClass = "labelFont";

                            TableCell tdToDateNewRow = new TableCell();
                            if (_drMedicationInstructions[index]["EndDate"] != System.DBNull.Value)
                            tdToDateNewRow.Text = Convert.ToDateTime(_drMedicationInstructions[index]["EndDate"]).ToShortDateString();                            
                            //tdToDateNewRow.Wrap = false;
                            tdToDateNewRow.CssClass = "LabelClaimline";
                            //tdToDateNewRow.Width = new Unit(50, UnitType.Pixel);

                            TableRow trTempInstuctions = new TableRow();
                            trTempInstuctions.ID = "Tr_" + newId;

                            trTempInstuctions.Cells.Add(tdDummy);
                            trTempInstuctions.Cells.Add(tdInstructionsNewRow);
                            trTempInstuctions.Cells.Add(tdInstructionsTextNewRow);
                            trTempInstuctions.Cells.Add(tdFromNewRow);
                            trTempInstuctions.Cells.Add(tdFromDateNewRow);
                            trTempInstuctions.Cells.Add(tdToNewRow);
                            trTempInstuctions.Cells.Add(tdToDateNewRow);

                            tblHarborStandardConsent.Rows.Add(trTempInstuctions);
                            }
                        }
                    
                       
                       

                    TableRow trTempSideEffects = new TableRow();
                    trTempSideEffects.ID = "Tr_" + newId;

                    TableCell tdSideEffects = new TableCell();
                    tdSideEffects.Text = "Common Side Effects";
                    tdSideEffects.CssClass = "labelFont";

                    TextBox txtCommonsideEffects = new TextBox();
                    txtCommonsideEffects.TextMode = TextBoxMode.MultiLine;
                    txtCommonsideEffects.Height = new Unit(70, UnitType.Percentage); ;
                    txtCommonsideEffects.Width = new Unit(98, UnitType.Percentage);
                    txtCommonsideEffects.ReadOnly = true;
                    txtCommonsideEffects.Style.Add("font-family", "Microsoft Sans Serif");                   
                    if (DataSetClientMedications.Tables.Contains("PatientMonographId"))
                        {
                        if (DataSetClientMedications.Tables["PatientMonographId"].Rows.Count > 0)
                            {
                            DataRow[] _drPatientMonographText = DataSetClientMedications.Tables["PatientMonographId"].Select("ClientMedicationId=" + Convert.ToInt32(drMedication["ClientMedicationId"]));
                            if (_drPatientMonographText.Length > 0)
                                {
                                DataSet DataSetPatientEducationMonographText = null;
                                DataSetPatientEducationMonographText = objClientMedications.GetPatientEducationMonographSideEffects(Convert.ToInt32(_drPatientMonographText[0]["PatientEducationMonographId"]));
                                if (DataSetPatientEducationMonographText.Tables[0].Rows.Count > 0)
                                    {
                                    txtCommonsideEffects.Text = DataSetPatientEducationMonographText.Tables[0].Rows[0]["FormattedSideEffectsText"].ToString();
                                    }
                                }
                            }
                        }
                    TableCell tdSideEffectsText = new TableCell();
                    tdSideEffectsText.EnableTheming = false;
                    tdSideEffectsText.Controls.Add(txtCommonsideEffects);
                    tdSideEffectsText.ColumnSpan = 6;

                    TableRow trLine = new TableRow();
                    TableCell tdHorizontalLine = new TableCell();
                    tdHorizontalLine.ColumnSpan = 8;
                    tdHorizontalLine.Width = new Unit(100, UnitType.Percentage);
                    tdHorizontalLine.Height = new Unit(20, UnitType.Pixel);
                    trLine.Cells.Add(tdHorizontalLine);

                    trTempSideEffects.Cells.Add(tdSideEffects);
                    trTempSideEffects.Cells.Add(tdSideEffectsText);
                    tblHarborStandardConsent.Rows.Add(trTempSideEffects);
                    tblHarborStandardConsent.Rows.Add(trLine);
                    }                                                        
                }

            PanelHarborConsent.Controls.Add(tblHarborStandardConsent);
            myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
            //Page.ClientScript.re

            //if (!Page.ClientScript.IsClientScriptBlockRegistered("MedicationListScript"))
            Page.RegisterClientScriptBlock(this.ClientID, myscript);
            //    Page.ClientScript.RegisterStartupScript(this.GetType(), "MedicationListScript", myscript);
            }
        catch (Exception ex)
            {
            }
        }    
}