using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;


/// <summary>
/// Summary description for Test
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class Test : System.Web.Services.WebService
{

    public Test()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    public class ClientMedicationRow
    {
        public Int32 MedicationNameId
        {
            get { return MedicationNameId; }
            set { MedicationNameId = value; }
        }

        public string DrugPurpose
        {
            get { return DrugPurpose; }
            set { DrugPurpose = value; }
        }

        public Int32 DxId
        {
            get { return DxId; }
            set { DxId = value; }
        }

        //public Int32 ClientId
        //{
        //    get { return ClientId; }
        //    set { ClientId = value; }
        //}

        public string PrescriberName
        {
            get { return PrescriberName; }
            set { PrescriberName = value; }
        }

        public Int32 PrescriberId
        {
            get { return PrescriberId; }
            set { PrescriberId = value; }
        }

        public string OrderDate
        {
            get { return OrderDate; }
            set { OrderDate = value; }
        }

        public string SpecialInstructions
        {
            get { return SpecialInstructions; }
            set { SpecialInstructions = value; }
        }

        //public string RowIdentifier
        //{
        //    get { return RowIdentifier; }
        //    set { RowIdentifier = value; }
        //}

        //public string CreatedBy
        //{
        //    get { return CreatedBy; }
        //    set { CreatedBy = value; }
        //}

        //public string CreatedDate
        //{
        //    get { return CreatedDate; }
        //    set { CreatedDate = value; }
        //}

        //public string ModifiedBy
        //{
        //    get { return ModifiedBy; }
        //    set { ModifiedBy = value; }
        //}

        //public string ModifiedDate
        //{
        //    get { return ModifiedDate; }
        //    set { ModifiedDate = value; }
        //}

        public string MedicationName
        {
            get { return MedicationName; }
            set { MedicationName = value; }
        }

        //public string DAW
        //{
        //    get { return DAW; }
        //    set { DAW = value; }
        //}
    }
    public class ClientMedicationInstructionRow
    {
        public Int32 StrengthId
        {
            get { return StrengthId; }
            set { StrengthId = value; }
        }

        public string Unit
        {
            get { return Unit; }
            set { Unit = value; }
        }

        public string Schedule
        {
            get { return Schedule; }
            set { Schedule = value; }
        }

        public Int32 Quantity
        {
            get { return Quantity; }
            set { Quantity = value; }
        }

        public Int32 Days
        {
            get { return Days; }
            set { Days = value; }
        }

        public Int32 Pharmacy
        {
            get { return Pharmacy; }
            set { Pharmacy = value; }
        }

        public Int32 Sample
        {
            get { return Sample; }
            set { Sample = value; }
        }

        public Int32 Stock
        {
            get { return Stock; }
            set { Stock = value; }
        }

        public Int32 Refills
        {
            get { return Refills; }
            set { Refills = value; }
        }

        public string StartDate
        {
            get { return StartDate; }
            set { StartDate = value; }
        }

        public string EndDate
        {
            get { return EndDate; }
            set { EndDate = value; }
        }

    }

    [WebMethod]
    [GenerateScriptType(typeof(ClientMedicationRow))]
    [GenerateScriptType(typeof(ClientMedicationInstructionRow))]
    public void ConvertToDataTable(ClientMedicationRow objClientMedication, ClientMedicationInstructionRow[] objClientMedicationInstructions)
    {
        DataTable DataTableClientMedications = null;
        DataTable DataTableClientMedicationInstructions = null;

        if (Session["DataTableClientMedications"] != null)
            DataTableClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationsDataTable)Session["DataTableClientMedications"];
        else
            DataTableClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationsDataTable();
        if (Session["DataTableClientMedicationInstructions"] != null)
            DataTableClientMedicationInstructions = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInstructionsDataTable)Session["DataTableClientMedicationInstructions"];
        else
            DataTableClientMedicationInstructions = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInstructionsDataTable();
       //For Client Medication
        DataRow DataRowClientMedication;         
        DataRowClientMedication = DataTableClientMedications.NewRow();
        DataRowClientMedication["MedicationNameId"]=objClientMedication.MedicationNameId;
        DataRowClientMedication["DrugPurpose"] = objClientMedication.DrugPurpose;
        DataRowClientMedication["DxId"] = objClientMedication.DxId;
        DataRowClientMedication["PrescriberName"] = objClientMedication.PrescriberName;
        DataRowClientMedication["PrescriberId"] = objClientMedication.PrescriberId;
        DataRowClientMedication["OrderDate"] = objClientMedication.OrderDate;
        DataRowClientMedication["SpecialInstructions"] = objClientMedication.SpecialInstructions;
        DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
        DataTableClientMedications.Rows.Add(DataRowClientMedication);
        //For ClientMedicationInstructions


        foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
        {
            DataRow DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
            DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
            DataRowClientMedInstructions["Quantity"] = row.Quantity;
            DataRowClientMedInstructions["Unit"] = row.Unit;
            DataRowClientMedInstructions["Schedule"] = row.Schedule;
            DataRowClientMedInstructions["StartDate"] = row.StartDate;
            DataRowClientMedInstructions["Days"] = row.Days;
            DataRowClientMedInstructions["Pharma"] = row.Pharmacy;
            DataRowClientMedInstructions["Sample"] = row.Sample;
            DataRowClientMedInstructions["Stock"] = row.Stock;
            DataRowClientMedInstructions["Refills"] = row.Refills;
            DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);
        }
                                                   
    }

}

