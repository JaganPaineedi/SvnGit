using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SureScriptClassLibrary;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;

public partial class ClientMedicationFormulary : Streamline.BaseLayer.ActivityPages.ActivityPage
{


    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            var MedicationId = Request.QueryString["MedicationId"].ToString();
            var PrescriberId = Request.QueryString["PrescriberId"].ToString();
            var ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId.ToString();

            Eligibility objEligibility = new Eligibility();
            string response = objEligibility.GetEligibility(ClientId, PrescriberId);

            List<PBM> listpbm = new List<PBM>();
            Formulary objFormulary = new Formulary(ClientId, MedicationId);
            objFormulary = objFormulary.GetFormulary();
            if (!IsPostBack)
            {
                BindDropdown(objFormulary);           //Fill the dropdown with all pbm
                int index = objFormulary.DefaultPBMIndex;  //pbmListNo represents the pbm having highest formulary status
                ddlPBM.SelectedIndex = index;
            }
            if (objFormulary.Alternative == null && objFormulary.Copays == null && objFormulary.Coverage == null && objFormulary.DefaultPBMName == null &&
                objFormulary.DrugClass == null && objFormulary.DrugType == null && objFormulary.PatientDetails == null)
            {
                Status.Text = objFormulary.FormularyStatus;
            }
            else
            {
                Status.Text = "";
            }

            lbPBMName.Text = objFormulary.DefaultPBMName;            //Set the PBM Name, DefaultPBMName is the properties that always holds current PBM Name
            lbFormulary.Text = objFormulary.FormularyStatus;        //Formulary Status of Medication, Example:- On Formulary, Prefered Formulary-3 etc 
            lbDrugType.Text = objFormulary.DrugType;                //Drug Type that display Branded or Generic
            lbDrugClass.Text = objFormulary.DrugClass;

            DataTable dtPatient = new DataTable();           //Create a Datatable to store all the patient Details
            dtPatient.Columns.Add("InfoType", typeof(string));
            dtPatient.Columns.Add("Info", typeof(string));
            if (objFormulary.PatientDetails != null)                //Display Patient Details
            {

                Patient objPatient = objFormulary.PatientDetails;   //"PatientDetails" gets the the object of Patient class which  gives all the patient details as  properties 
                if (objPatient.LastName != string.Empty)
                    dtPatient.Rows.Add("Patient Name", objPatient.Suffix + " "
                        + objPatient.FirstName + " " + objPatient.MiddleName + " "
                        + objPatient.LastName);
                if (objPatient.Address1 != string.Empty || objPatient.City != string.Empty ||
                    objPatient.State != string.Empty || objPatient.Zip != string.Empty)
                    dtPatient.Rows.Add("Address", objPatient.Address1 + "\r\n"
                        + objPatient.Address2 + "\r\n" + objPatient.City + "\r\n"
                        + objPatient.State + "\r\n" + objPatient.Zip);
                if (objPatient.Gender != string.Empty)
                    dtPatient.Rows.Add("Gender", objPatient.Gender); //Add Gender to Datatable
                if (objPatient.DOB != string.Empty)
                    dtPatient.Rows.Add("DOB", objPatient.DOB);        //Add DOB to Datatable

            }
            GVPatient.DataSource = dtPatient;
            GVPatient.DataBind();


            #region Copay details
            DataTable dtCop = new DataTable();            //Create a datatable to store all copay      
            dtCop = CopayDetails(objFormulary.Copays);     //Copays is a property which is a collection of object of Class Copay
            //CopayDetails() collects all the copay details and keep them Datatable
            GVCOPAY.DataSource = dtCop;
            GVCOPAY.DataBind();
            #endregion

            #region CoverageDetails
            if (objFormulary.Coverage != null)
            {
                DataTable CoverageTable = new DataTable();  //Create a Coverage Table that holds all the copay details
                CoverageTable = CoverageDetails(objFormulary.Coverage);  //ObjFormulary.Coverage--> Coverage is the property Which is a collection of property
                GVCOV.DataSource = CoverageTable;
                GVCOV.DataBind();
            }

            #endregion

            #region Therapeutic alternative
            DataTable dtTherapeutic = new DataTable();       //Create a datatable to holds Therapeutic alternative 
            dtTherapeutic.Columns.Add("Therapeutic", typeof(DataTable)); //Datatable is having a single column of type DataTable

            if (objFormulary.TherapeuticAlternative != null) //TherapeuticAlternative is the propery which is the collection of all the therapeutic Details
            {

                foreach (AlternativeMedication objTherapeutic in objFormulary.TherapeuticAlternative)  //objTherapeutic is the object of class AlternativeMedication
                {                                                                                     //which is a set of properties

                    DataTable dtInnerTherapeutic = new DataTable();       //Create a DataTable that contains Medication Name, Formulary Status, Drug Type
                    dtInnerTherapeutic.Columns.Add("Type", typeof(string));
                    dtInnerTherapeutic.Columns.Add("Data", typeof(string));
                    dtInnerTherapeutic.Rows.Add("Medication Name:", objTherapeutic.MedicationName); //Medication Name of Therapeutic Medication
                    dtInnerTherapeutic.Rows.Add("FormularyStatus", objTherapeutic.FormularyStatus); //Formulary Status of Therapeutic Medication
                    dtInnerTherapeutic.Rows.Add("Drug Type", objTherapeutic.DrugType);              //

                    DataTable dtCopayTherap = CopayDetails(objTherapeutic.Copays);    //CopayDetails takes a collection of object of class 
                    //Copay and each object have its own properties               
                    foreach (DataRow dr in dtCopayTherap.Rows)
                    {
                        dtInnerTherapeutic.ImportRow(dr);               //Import Copay Details to the inner table
                    }
                    dtTherapeutic.Rows.Add(dtInnerTherapeutic);
                    if (objTherapeutic.Coverages != null)
                    {
                        DataTable dtCov = new DataTable();
                        dtCov = CoverageDetails(objTherapeutic.Coverages);
                        foreach (DataRow dr in dtCov.Rows)
                        {
                            dtInnerTherapeutic.ImportRow(dr);
                        }
                        dtTherapeutic.Rows.Add(dtInnerTherapeutic);
                    }

                }

                GVTHALT.DataSource = dtTherapeutic;
                GVTHALT.DataBind();
            }
            #endregion

            #region  alternative
            DataTable dtAlt = new DataTable();
            dtAlt.Columns.Add("ALT", typeof(DataTable));
            if (objFormulary.Alternative != null)
            {
                foreach (AlternativeMedication Alt in objFormulary.Alternative)
                {
                    DataTable dtAlt1 = new DataTable();

                    dtAlt1.Columns.Add("Type", typeof(string));
                    dtAlt1.Columns.Add("Data", typeof(string));
                    dtAlt1.Rows.Add("Medication Name:", Alt.MedicationName);
                    dtAlt1.Rows.Add("FormularyStatus", Alt.FormularyStatus);
                    dtAlt1.Rows.Add("Drug Type", Alt.DrugType);
                    DataTable dtcop = CopayDetails(Alt.Copays);


                    foreach (DataRow dr in dtcop.Rows)   //Add Copay Details
                    {
                        dtAlt1.ImportRow(dr);
                    }

                    //dtAlt.Rows.Add(dtAlt1);
                    if (Alt.Coverages != null)
                    {
                        DataTable dtCov = new DataTable();
                        dtCov = CoverageDetails(Alt.Coverages);
                        foreach (DataRow dr in dtCov.Rows)
                        {
                            dtAlt1.ImportRow(dr);
                        }


                    }
                    dtAlt.Rows.Add(dtAlt1);
                }

                GVALT.DataSource = dtAlt;
                GVALT.DataBind();
            #endregion
            }
        }
        catch (Exception ex) { }
    }

    private void BindDropdown(Formulary objformulary)
    {
        ddlPBM.DataSource = objformulary.PBMs;  //PBMS is the list of all PBM for a patient
        ddlPBM.DataTextField = "Name";   //Shows PBMNAME
        ddlPBM.DataBind();
    }

    protected void ddlPBM_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// The property Coverage gives the object of  type Coverage class.
    /// The object is again associated to differenet objects of different classes .
    /// </summary>
    /// <param name="cov"></param>
    /// <returns></returns>
    private DataTable CoverageDetails(Coverage cov)
    {
        DataTable dtCoverage = new DataTable();
        dtCoverage.Columns.Add("Type", typeof(string));
        dtCoverage.Columns.Add("Data", typeof(string));

        if (cov != null)
        {

            if (cov.CoverageAgeLimit != null)
                foreach (CoverageAL al in cov.CoverageAgeLimit)
                {
                    if (al.MaximumAge != null && al.MinimumAge != null)
                    {
                        dtCoverage.Rows.Add("MaximumAgeLimit:", al.MaximumAge);
                        dtCoverage.Rows.Add("MinimumAgeLimit:", al.MinimumAge);
                    }
                }
            if (cov.CoverageAgeLimit != null)
                foreach (CoverageGL gl in cov.CoverageGender)
                {
                    if (gl.Gender != null)
                    {
                        dtCoverage.Rows.Add("Gender:", gl.Gender);
                    }
                }
            if (cov.CoverageQuantity != null)
                foreach (CoverageQL ql in cov.CoverageQuantity)
                {
                    if (ql.MaximumAmmount != null)
                    {
                        dtCoverage.Rows.Add("MaximumQuantity", ql.MaximumAmmount);
                    }
                }
            if (cov.CoverageMessage != null)
            {
                foreach (CoverageTM tm in cov.CoverageMessage)
                {
                    dtCoverage.Rows.Add("Short Message", tm.ShortTextMessage);
                    dtCoverage.Rows.Add("Long Message", tm.LongTextMessage);
                }
            }
            if (cov.CoverageStepMedication != null)
            {
                foreach (CoverageSM sm in cov.CoverageStepMedication)
                {
                    dtCoverage.Rows.Add("Step Medication", sm.StepMedication);
                }
            }
            if (cov.CoverageResource != null)
            {
                foreach (CoverageRS rs in cov.CoverageResource)
                {
                    dtCoverage.Rows.Add("URLType", rs.URLType);
                    dtCoverage.Rows.Add("URL", rs.URL);
                }
            }
        }
        return dtCoverage;

    }
    /// <summary>
    /// the listcopay is the collection of  properties of type class Copay
    /// </summary>
    /// <param name="listCop"></param>
    /// <returns></returns>
    private DataTable CopayDetails(List<Copay> listCop)
    {
        DataTable CopayTable = new DataTable();   //Create a Datatable that holds Copay details
        CopayTable.Columns.Add("Type", typeof(string));      //the name of Copay type 
        CopayTable.Columns.Add("Data", typeof(string));      //Value of Copay 
        if (listCop != null)
        {
            foreach (Copay cp in listCop)
            {
                if (cp.CopayListType != null && cp.CopayListType.Trim() != string.Empty)
                    CopayTable.Rows.Add("CopayListType:", cp.CopayListType);
                if (cp.PharamcyType != null)
                    CopayTable.Rows.Add("PharmacyType:", cp.PharamcyType);
                //if (cp.ProductType != null)
                //    CopayTable.Rows.Add("ProductType:", cp.ProductType);
                if (cp.MaximumCopay != null)
                    CopayTable.Rows.Add("MaximumCopay:", cp.MaximumCopay);
                if (cp.MinimumCopay != null)
                    CopayTable.Rows.Add("MinimumCopay:", cp.MinimumCopay);
                if (cp.DaysSupplyPerCopay != null)
                    CopayTable.Rows.Add("DaysSupplyPerCopay:", cp.DaysSupplyPerCopay);
                if (cp.FirstCopayTerm != null)
                    CopayTable.Rows.Add("FirstCopayTerm:", cp.FirstCopayTerm);
                if (cp.FlatCopayAmount != null)
                    CopayTable.Rows.Add("FlatCopayAmount:", cp.FlatCopayAmount);
                if (cp.MaxCopayTier != null)
                    CopayTable.Rows.Add("MaxCopayTier:", cp.MaxCopayTier);
                if (cp.CopayTier != null)
                    CopayTable.Rows.Add("CopayTier:", cp.CopayTier);
                if (cp.PercentageCopayRate != null)
                    CopayTable.Rows.Add("PercentageCopayRate:", cp.PercentageCopayRate);
                if (cp.OutPocketRangeStart != null)
                    CopayTable.Rows.Add("OutPocketRangeStart:", cp.OutPocketRangeStart);
                if (cp.OutPocketRangeEnd != null)
                    CopayTable.Rows.Add("OutPocketRangeEnd:", cp.OutPocketRangeEnd);
            }
        }
        return CopayTable;
    }
 }

