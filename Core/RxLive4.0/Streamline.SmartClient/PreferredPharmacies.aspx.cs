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

public partial class PreferredPharmacies : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    DataSet _DataSetClientSummary = null;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;
    DataSet dsClientPharmacies = null;
    DataSet dsPatientoverviewdetails = null;

    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            DropDownListPharmacy1.Attributes.Add("onchange", "SetPreferredPharmacy1Filter()");
            DropDownListPharmacy2.Attributes.Add("onchange", "SetPreferredPharmacy2Filter()");
            DropDownListPharmacy3.Attributes.Add("onchange", "SetPreferredPharmacy3Filter()");
            if (!Page.IsPostBack)
            {


                //Code added by Loveena in ref to Task#2575 1.9.5.8 Patient Overview Template not Following Specifications  
                if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE" && Session["ExternalClientInformation"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["ExternalClientInformation"];
                    if (_DataSetClientSummary.Tables["ClientHTMLSummary"].Rows.Count > 0)
                        BindControls();
                    else
                        ClearControls();
                }
                else
                {
                    if (Session["DataSetClientSummary"] != null)
                    {
                        _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];

                        if (_DataSetClientSummary.Tables["ClientInformation"].Rows.Count > 0)

                            BindControls();
                        else
                            ClearControls();
                    }
                }
                //Code ends over here.
                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = null;
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    //Fill PreferredPharmacy DropDownList from Shared Tables.                    
                    FillPrefferdPharmacy1(1, "SearchImageFirst");
                    FillPrefferdPharmacy1(2, "SearchImageSecond");
                    FillPrefferdPharmacy1(3, "SearchImageThird");

                    //changes end over here
                }
                //Set Values for HiddenFields.
                HiddenPreferredPharmacy1.Value = DropDownListPharmacy1.SelectedValue;
                HiddenPreferredPharmacy2.Value = DropDownListPharmacy2.SelectedValue;
                HiddenPreferredPharmacy3.Value = DropDownListPharmacy3.SelectedValue;
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

    private void BindControls()
    {

        try
        {

            CommonFunctions.Event_Trap(this);

            //Clear the controls
            ClearControls();

            //Get the Client Pharmacies data from Session's DataSet Client Summary
            //and merge the same in dsClientPharmacies
            //no need to fetch again from database

            objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            string DOB = "";
            //Added by Loveena in ref to task# 2417 MM-1.9 to retrieve HTML Client Summary
            if (_DataSetClientSummary.Tables.Contains("ClientHTMLSummary") == true)
            {
                // Bind Name
                //Increasing the Limit from 15 to 35 on the basis of Task#2896 1.9.8.9 Patient Overview Edit - Widen Client Name 
                LabelClientName.Text = ApplicationCommonFunctions.cutText((_DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["ClientName"].ToString()), 35);

                // Bind DOB/Age
                if (_DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["DOB"].ToString() != "")
                    DOB = Convert.ToDateTime(_DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["DOB"].ToString()).ToString("MM/dd/yyyy");
            }
            else if (_DataSetClientSummary.Tables.Contains("ClientInfoAreaHtml") == true)
            {
                //Increasing the Limit from 15 to 35 on the basis of Task#2896 1.9.8.9 Patient Overview Edit - Widen Client Name 
                LabelClientName.Text = ApplicationCommonFunctions.cutText((_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientName"].ToString()), 35);

                // Bind DOB/Age
                if (_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["DOB"].ToString() != "")
                    DOB = Convert.ToDateTime(_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["DOB"].ToString()).ToString("MM/dd/yyyy");
            }
            if (DOB == string.Empty)
                LabelClientDOB.Text = "";
            else
                LabelClientDOB.Text = DateTime.Parse(DOB).ToString("MM/dd/yyyy");

            //Set Values for HiddenFields.
            HiddenPreferredPharmacy1.Value = DropDownListPharmacy1.SelectedValue;
            HiddenPreferredPharmacy2.Value = DropDownListPharmacy2.SelectedValue;
            HiddenPreferredPharmacy3.Value = DropDownListPharmacy3.SelectedValue;
        }
        catch (Exception ex)
        {
            throw (ex);
        }

    }


    private void ClearControls()
    {
        try
        {
            LabelClientName.Text = "";
            LabelClientDOB.Text = "";
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    /// <summary>
    /// <Author>Loveena</Author>
    /// <Description>To Fill Pharmacies Drop-DownList for Sequence Number 1</Description>
    /// </summary>
    private void FillPrefferdPharmacy1(int dropDownNum, String SearchImage)
    {

        DataSet DataSetPharmacies = null;
        //added By Priya rEf:Task no:85
        DataTable DataTableGetAllPharmacies = new DataTable();
        //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
        //Code added in ref to Task#2589
        Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
        objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
        string SessionGetAllPreferredPharmacies = string.Empty;
        DropDownList ddL = DropDownListPharmacy1;
        if (dropDownNum == 1)
        {
            SessionGetAllPreferredPharmacies = "GetAllPreferredPharmacies1";
            ddL = DropDownListPharmacy1;
        }
        else if (dropDownNum == 2)
        {
            SessionGetAllPreferredPharmacies = "GetAllPreferredPharmacies2";
            ddL = DropDownListPharmacy2;
        }
        else if (dropDownNum == 3)
        {
            SessionGetAllPreferredPharmacies = "GetAllPreferredPharmacies3";
            ddL = DropDownListPharmacy3;
        }
        try
        {
            //added By Priya rEf:Task no:85
            if (Request.QueryString["imgname"] == null)
            {
                Session[SessionGetAllPreferredPharmacies] = null;
            }
            DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            CommonFunctions.Event_Trap(this);
            //added By Priya rEf:Task no:85
            if (Session[SessionGetAllPreferredPharmacies] != null)
            {
                ddL.DataSource = GetEPCSPharmacies((DataTable)Session[SessionGetAllPreferredPharmacies]);
            }
            else
            { 
                ddL.DataSource = GetEPCSPharmacies(DataSetPharmacies.Tables[0]);
            }

            ddL.DataTextField = "PharmacyName";
            ddL.DataValueField = "PharmacyId";
            ddL.DataBind();
            int count = ddL.Items.Count;
            count = count + 1;
            ddL.Items.Insert(0, new ListItem("", "0"));
            ddL.SelectedIndex = 0;

            DataRow drNewPharmacies = null;
            if (Session[SessionGetAllPreferredPharmacies] == null)
                DataTableGetAllPharmacies = DataSetPharmacies.Tables[0];
            else
                DataTableGetAllPharmacies = (DataTable)Session[SessionGetAllPreferredPharmacies];
            DataRow[] _drClientId = (_DataSetClientSummary.Tables["ClientPharmacies"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + " AND SequenceNumber=" + dropDownNum + " AND ISNULL(RecordDeleted,'N')='N'"));
            if (_drClientId.Length > 0)
            {


                //Set the Selected Value for DropDownListPharmacy1 with the Sequence Number1.
                ddL.SelectedValue = _drClientId[0]["PharmacyId"].ToString();

            }
            //added By Priya Ref: task 85 SDI Projects FY10 - Venture            

            string pharmacyname = "";
            string pharmacyId = "";
            bool isExist = false;
            if (Request.QueryString["imgname"] != null)
            {
                string imgname = Request.QueryString["imgname"].ToString();
                if (imgname != SearchImage)
                {
                    string SelectedPharmacyValue = string.Empty;
                    if (dropDownNum == 1)
                        SelectedPharmacyValue = Request.QueryString["DropDownValue1"].ToString();
                    else if (dropDownNum == 2)
                        SelectedPharmacyValue = Request.QueryString["DropDownValue2"].ToString();
                    else
                        SelectedPharmacyValue = Request.QueryString["DropDownValue3"].ToString();
                    ddL.SelectedValue = SelectedPharmacyValue;
                }
                if (imgname == SearchImage)
                {
                    pharmacyname = Request.QueryString["PharmacyName"].ToString();
                    pharmacyId = Request.QueryString["PharmacyId"].ToString();
                    int gridCount = ddL.Items.Count;
                    for (int i = 0; i < gridCount; i++)
                    {
                        if (ddL.Items[i].Value == pharmacyId)
                        {
                            isExist = true;
                            ddL.SelectedValue = pharmacyId;
                            break;
                        }
                    }
                    if (isExist == false)
                    {
                        drNewPharmacies = DataTableGetAllPharmacies.NewRow();
                        ddL.Items.Insert(count, new ListItem(pharmacyname, pharmacyId));
                        drNewPharmacies["PharmacyId"] = pharmacyId;
                        drNewPharmacies["PharmacyName"] = pharmacyname;
                        DataTableGetAllPharmacies.Rows.Add(drNewPharmacies);
                        ddL.SelectedValue = pharmacyId;

                    }
                    Session[SessionGetAllPreferredPharmacies] = DataTableGetAllPharmacies;
                }



            }

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillPreferredPharmacy1(),ParameterCount 0 - ###");
            else
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetPharmacies;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            DataSetPharmacies = null;

        }
    }
    //<Summary>
    //Author-PranayB
    //Purpose-To show the EPCS after pharmacyName if Pharmacy accept cntl Drug ele.
    //<Summary>
    public DataTable GetEPCSPharmacies(DataTable dtPharmacies)
    {
        foreach (DataRow drPharmacies in dtPharmacies.Rows)
        {
            int ServiceLevel = drPharmacies["ServiceLevel"].Equals(DBNull.Value) ? 0 : Convert.ToInt32(drPharmacies["ServiceLevel"]);  /* ServiceLevel check of the pharmacy */
            
                if (ServiceLevel >= 2048)
                {
                    drPharmacies["PharmacyName"] = drPharmacies["PharmacyName"] + " - " + "EPCS";   /* Adding EPCS with  if it matches the service level */
                }
        }
        return dtPharmacies;
    }
    protected void ButtonSave_Click(object sender, EventArgs e)
    {

        objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
        dsClientPharmacies = new DataSet();
        try
        {
            CommonFunctions.Event_Trap(this);
            dsClientPharmacies.Merge(objectClientMedications.GetClientPharmacies(
                Convert.ToInt32(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId), false, HiddenPreferredPharmacy1.Value, HiddenPreferredPharmacy2.Value, HiddenPreferredPharmacy3.Value));
            //Add New Row
            if (dsClientPharmacies != null && dsClientPharmacies.Tables["ClientPharmacies"].Rows.Count == 0)
            {
                DataRow drClientPharmacies = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                if (HiddenPreferredPharmacy1.Value != "0")
                {
                    drClientPharmacies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies["SequenceNumber"] = 1;
                    drClientPharmacies["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy1.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies);
                }
                if (HiddenPreferredPharmacy2.Value != "0")
                {
                    drClientPharmacies = null;
                    drClientPharmacies = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies["SequenceNumber"] = 2;
                    drClientPharmacies["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy2.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies);
                }
                if (HiddenPreferredPharmacy3.Value != "0")
                {
                    drClientPharmacies = null;
                    drClientPharmacies = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies["SequenceNumber"] = 3;
                    drClientPharmacies["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy3.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies);
                }
            }
            //Edit Present Data
            //Added by Loveena in ref to task#187 to allow null enteries for Preferred Pharmacies.
            else if (dsClientPharmacies != null && dsClientPharmacies.Tables["ClientPharmacies"].Rows.Count > 0)
            {
                DataRow[] _drClientPharmacies1 = dsClientPharmacies.Tables["ClientPharmacies"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + " and SequenceNumber=1");
                if (_drClientPharmacies1.Length > 0)
                {
                    if (HiddenPreferredPharmacy1.Value != "0" && HiddenPreferredPharmacy1.Value != "")
                    {
                        _drClientPharmacies1[0]["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy1.Value);
                        if (Request.QueryString["ExternalReferenceId"] != null)
                            _drClientPharmacies1[0]["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    }
                    else
                    {
                        _drClientPharmacies1[0]["RecordDeleted"] = "Y";
                        _drClientPharmacies1[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drClientPharmacies1[0]["DeletedDate"] = DateTime.Now.ToShortDateString();
                    }
                }
                else if (_drClientPharmacies1.Length == 0 && HiddenPreferredPharmacy1.Value != "0")
                {
                    DataRow drClientPharmacies1 = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies1["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies1["SequenceNumber"] = 1;
                    drClientPharmacies1["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy1.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies1["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies1["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies1["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies1["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies1["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies1["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies1);

                }
                DataRow[] _drClientPharmacies2 = dsClientPharmacies.Tables["ClientPharmacies"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + " and SequenceNumber=2");
                if (_drClientPharmacies2.Length > 0)
                {
                    if (HiddenPreferredPharmacy2.Value != "0" && HiddenPreferredPharmacy2.Value != "")
                    {
                        _drClientPharmacies2[0]["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy2.Value);
                        if (Request.QueryString["ExternalReferenceId"] != null)
                            _drClientPharmacies2[0]["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    }
                    else
                    {
                        _drClientPharmacies2[0]["RecordDeleted"] = "Y";
                        _drClientPharmacies2[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drClientPharmacies2[0]["DeletedDate"] = DateTime.Now.ToShortDateString();
                    }
                }
                else if (_drClientPharmacies2.Length == 0 && HiddenPreferredPharmacy2.Value != "0")
                {
                    DataRow drClientPharmacies2 = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies2 = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies2["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies2["SequenceNumber"] = 2;
                    drClientPharmacies2["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy2.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies2["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies2["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies2["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies2["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies2["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies2["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies2);

                }
                DataRow[] _drClientPharmacies3 = dsClientPharmacies.Tables["ClientPharmacies"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + " and SequenceNumber=3");
                if (_drClientPharmacies3.Length > 0)
                {
                    if (HiddenPreferredPharmacy3.Value != "0" && HiddenPreferredPharmacy3.Value != "")
                    {
                        _drClientPharmacies3[0]["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy3.Value);
                        if (Request.QueryString["ExternalReferenceId"] != null)
                            _drClientPharmacies3[0]["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    }
                    else
                    {
                        _drClientPharmacies3[0]["RecordDeleted"] = "Y";
                        _drClientPharmacies3[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drClientPharmacies3[0]["DeletedDate"] = DateTime.Now.ToShortDateString();
                    }
                }
                else if (_drClientPharmacies3.Length == 0 && HiddenPreferredPharmacy3.Value != "0")
                {
                    DataRow drClientPharmacies3 = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies3 = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies3["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies3["SequenceNumber"] = 3;
                    drClientPharmacies3["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy2.Value);
                    if (Request.QueryString["ExternalReferenceId"] != null)
                        drClientPharmacies3["ExternalReferenceId"] = Request.QueryString["ExternalReferenceId"];
                    drClientPharmacies3["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies3["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies3["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies3["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies3["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies3);

                }
            }

            //Commented by Loveena in ref to task#187 to allow null enteries for Preferred Pharmacies.
            //Edit Present Data;
            //if (dsClientPharmacies.Tables["ClientPharmacies"].Rows.Count > 0)
            //{
            //    DataRow[] _drClientPharmacies = dsClientPharmacies.Tables["ClientPharmacies"].Select("ClientId=" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            //    if (_drClientPharmacies.Length > 0)
            //    {
            //        _drClientPharmacies[0]["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy1.Value);
            //        _drClientPharmacies[1]["PharmacyId"] = Convert.ToInt32(HiddenPreferredPharmacy2.Value); 
            //    }

            //}
            //Commented Code Ends over here.
            //Code added in ref to Task#85 - Sure Scripts
            if (HiddenPreferredPharmacy1.Value != "0")
            {
                DataRow[] drPharmacy = dsClientPharmacies.Tables["Pharmacies"].Select("PharmacyId=" + Convert.ToInt32(HiddenPreferredPharmacy1.Value));
                if (drPharmacy.Length > 0)
                {
                    if (drPharmacy[0]["PreferredPharmacy"] != "Y")
                        drPharmacy[0]["PreferredPharmacy"] = "Y";
                }
            }
            if (HiddenPreferredPharmacy2.Value != "0")
            {
                DataRow[] drPharmacy = dsClientPharmacies.Tables["Pharmacies"].Select("PharmacyId=" + Convert.ToInt32(HiddenPreferredPharmacy2.Value));
                if (drPharmacy.Length > 0)
                {
                    if (drPharmacy[0]["PreferredPharmacy"] != "Y")
                        drPharmacy[0]["PreferredPharmacy"] = "Y";
                }
            }
            if (HiddenPreferredPharmacy3.Value != "0")
            {
                DataRow[] drPharmacy = dsClientPharmacies.Tables["Pharmacies"].Select("PharmacyId=" + Convert.ToInt32(HiddenPreferredPharmacy3.Value));
                if (drPharmacy.Length > 0)
                {
                    if (drPharmacy[0]["PreferredPharmacy"] != "Y")
                        drPharmacy[0]["PreferredPharmacy"] = "Y";
                }
            }
            objectClientMedications.UpdateDocuments(dsClientPharmacies);
            objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();

            //#ka02022014 dsClientPharmacies = objectClientMedications.GetClientPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);



            //After saving the dsClientPharmacies 
            //Again fetch the Client pharmacies data
            //and merge the same in DataSetClientSummary
            //and store same in session["DataSetClientSummary"]

            _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            _DataSetClientSummary.Tables["ClientPharmacies"].Clear();
            _DataSetClientSummary.Tables["ClientPharmacies"].Merge(dsClientPharmacies.Tables["ClientPharmacies"]);
            GetPatientoverviewdetails();
            Session["DataSetClientSummary"] = _DataSetClientSummary;
            //call ClosePharmaciesDiv(true)
            ScriptManager.RegisterStartupScript(LabelClientName, LabelClientName.GetType(), "key", "closeDivPharmacies(true);", true);

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

    private void GetPatientoverviewdetails()
    {
        int Clientid = 0;
        try
        {
            Clientid = (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            if (Clientid > 0)
            {
                dsPatientoverviewdetails = objectClientMedications.GetPatientoverviewdetails(Clientid);
                _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Clear();
                _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Merge(dsPatientoverviewdetails.Tables["ClientInfoAreaHtml"]);
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            objectClientMedications = null;
        }



    }

}
