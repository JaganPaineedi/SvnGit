using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;
using System.Reflection;
using System.IO;
using System.Xml;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using SHS.BaseLayer.ActivityPages;
using System.Text;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Data.SqlClient;

public partial class Custom_InquiryDetails_WebPages_MemberInquiryDetail : DataActivityMultiTabPage
{
    private System.Data.SqlClient.SqlParameter[] _sqlParameterForGetData = null;
    UserControl userControl = null;
    protected int globalcodeComplete = 0;
    public override string DefaultTab
    {
        get { return "/Custom/InquiryDetails/WebPages/MemberInquiryDetailGeneral.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return inquiryTabPageInstance.ID; }
    }
    //Added By Mamta Gupta - Ref Task No. 1738 - Kalamazoo Bugs - Go Live - To pass RDL name from user control to PrintDetailPage
    public override string DetailPageViewModeRDL
    {
        get { return "RDLInquiryViewMode"; }
    }
    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        inquiryTabPageInstance.ActiveTabIndex = (short)TabIndex;
        ctlcollection = inquiryTabPageInstance.TabPages[TabIndex].Controls;
        UcPath = inquiryTabPageInstance.TabPages[TabIndex].Name;
    }

    /// <summary>
    /// Used to Get COverage Information 
    /// </summary>
    /// <param name="clientId"></param>
    /// <returns>DataSet of Coverage Information</returns>
    public DataSet GetCoverageInformation(int inquiryId)
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetMemberInformation = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@inquiryId", inquiryId);
        dataSetMemberInformation = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCoverageInformation", dataSetMemberInformation, new string[] { "CustomInquiriesCoverageInformations", "CoveragePlans" }, _objectSqlParmeters);
        return dataSetMemberInformation;
    }

    public override void BindControls()
    {
        int clientId = 0;
        int InquiryId = -1;
        int.TryParse(Convert.ToString(BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["ClientId"]), out clientId);
        int.TryParse(Convert.ToString(BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["InquiryId"]), out InquiryId);
        if (clientId > 0 && InquiryId <= 0)
        {
            int MedicaidId = 0;
            SHS.UserBusinessServices.ClientInformation clientinfo = new SHS.UserBusinessServices.ClientInformation();
            DataSet dsclientinfo = clientinfo.GetClientDetails(clientId);
            int.TryParse(Convert.ToString(dsclientinfo.Tables["ClientInfo"].Rows[0]["MedicaidId"]), out MedicaidId);
            BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["MedicaidId"] = MedicaidId == 0 ? DBNull.Value : (object)MedicaidId;
        }
        var ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries();
        var DatasetCoverageInfo = GetCoverageInformation(InquiryId);
        int.TryParse(GetGlobalCode("COMPLETE"),out globalcodeComplete);
        DataTable dtCoverageInfo = ds.Tables["CustomInquiriesCoverageInformations"];
        if (dtCoverageInfo.Rows.Count == 0)
        {
            dtCoverageInfo = DatasetCoverageInfo.Tables["CustomInquiriesCoverageInformations"];
        }
        //DataTable dt = DatasetCoverageInfo.Tables["CustomInquiriesCoverageInformations"];
        if (dtCoverageInfo.Rows.Count > 0)
        {
            var AppointmentList = (from p in dtCoverageInfo.AsEnumerable()
                                   where p.Field<string>("RecordDeleted") != "Y"
                                   select new
                                   {
                                       InquiriesCoverageInformationId = p.Field<int>("InquiriesCoverageInformationId"),
                                       InquiryId = p.Field<int>("InquiryId"),
                                       CoveragePlanId = p.Field<int>("CoveragePlanId"),
                                       InsuredId = p.Field<string>("InsuredId"),
                                       GroupId = p.Field<string>("GroupId"),
                                       Comment = p.Field<string>("Comment")
                                   }).ToList();
            var ajsonSerialiser = new JavaScriptSerializer();
            var ajson = ajsonSerialiser.Serialize(AppointmentList);
            HiddenFieldAppointments.Value = ajson.ToString();
        }       
        else
        {
            HiddenFieldAppointments.Value = "";
        }
        DataTable dtCoveragePlans = DatasetCoverageInfo.Tables["CoveragePlans"];
                
        if (dtCoveragePlans.Rows.Count > 0)
        {
            var PlanList = (from p in dtCoveragePlans.AsEnumerable()                                   
                                   select new
                                   {
                                       CoveragePlanId = p.Field<int>("CoveragePlanId"),
                                       PlanName = p.Field<string>("DisplayAs"),
                                       IsSelected = p.Field<string>("IsSelected")
                                   }).ToList();
            var pajsonSerialiser = new JavaScriptSerializer();
            var paajson = pajsonSerialiser.Serialize(PlanList);
            HiddenFieldsPlan.Value = paajson.ToString();
        }
        else
        {
            HiddenFieldsPlan.Value = "";
        }
       
    }

    public override string PageDataSetName
    {
        get { return "DataSetMemberInquiry"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomInquiries", "CustomDispositions", "CustomServiceDispositions", "CustomProviderServices" }; }
    }

    public override string GetStoreProcedureName
    {
        get
        {
            return "csp_SCGetMemberInquiriesDetails";
        }
    }

    public override string[] TablesNameForGetData
    {
        get { return new string[] { "CustomInquiries", "CustomDispositions", "CustomServiceDispositions", "CustomProviderServices", "CustomInquiriesCoverageInformations", "CoveragePlans" }; }
    }
    
    //Get the sql  parameter which will pass to the procedure in GetData.
    public override System.Data.SqlClient.SqlParameter[] SqlParameterForGetData
    {
        get
        {
            int InquiryId = 0;

            if (base.GetRequestParameterValue("InquiryId").Length > 0)
                InquiryId = Convert.ToInt32(base.GetRequestParameterValue("InquiryId"));

            if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet != null)
            {
                if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"] != null)
                {
                    if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "CustomInquiries"))
                    {
                        int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"].ToString(), out InquiryId);
                    }
                }
            }

            System.Data.SqlClient.SqlParameter[] parameters = new System.Data.SqlClient.SqlParameter[2];
            parameters[0] = new System.Data.SqlClient.SqlParameter("@InquiryId", InquiryId);
            return parameters;
        }
    }

    public override void AddMandatoryValues(DataRow dataRow, string tableName)
    {
        switch (tableName)
        {
            case "CustomInquiries":               
                dataRow["RecordedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId.ToString();
                dataRow["GatheredBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId.ToString();
                // Global Code for inquiry status hardcode according to requirement to default set Inprogress  inquiry status
                dataRow["InquiryStatus"] = GetGlobalCode("INPROGRESS");
                break;
        }

    }
    private string GetGlobalCode(string codeName)
    {
        DataRow[] dataRowGlobalCode = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='XINQUIRYSTATUS' AND CODE='" + codeName.ToUpper() + "'");
        if (dataRowGlobalCode.Length > 0)
        {
            return dataRowGlobalCode[0]["GlobalCodeId"].ToString();
        }
        else
        {
            return null;
        }
    }

    /// <summary>
    /// Used for CustomAjaxRequest to get required data.
    /// </summary>
    public override void CustomAjaxRequest()
    {
        //To Get the dropdown data according to ReferralTypeId selected in other dropdown.
        string referralTypeId = GetRequestParameterValue("ReferralTypeId");
        if (GetRequestParameterValue("Flag") == "ReferralTypeChange")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartReferralType###";

            literalEnd.Text = "###EndReferralType###";

            //PanelLoadUC.Controls.Add(literalStart);

            DropDownList DropDownReferralSubType = new DropDownList();
            DataView dataviewReferralSubType = new DataView();
            dataviewReferralSubType = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes.DefaultView;
            dataviewReferralSubType.RowFilter = "GlobalCodeId= " + referralTypeId + "  and Active='Y' ";
            DropDownReferralSubType.DataSource = dataviewReferralSubType;
            DropDownReferralSubType.DataTextField = "SubCodeName";
            DropDownReferralSubType.DataValueField = "GlobalSubCodeId";
            DropDownReferralSubType.DataBind();
            DropDownReferralSubType.Items.Insert(0, new ListItem("tt", "0"));
            PanelLoadUC.Controls.Add(DropDownReferralSubType);
            PanelLoadUC.Controls.Add(literalEnd);
        }
        //To Create a New Member Record and Get Detail of Newly Created Member
        if (GetRequestParameterValue("Flag") == "Create New Potential Member")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();

            Literal MemberInfoStart = new Literal();
            Literal MemberInfoResult = new Literal();
            Literal MemberInfoEnd = new Literal();

            literalStart.Text = "###StartCreateMember###";
            literalEnd.Text = "###EndCreateMember###";

            MemberInfoStart.Text = "###StartText###";
            MemberInfoEnd.Text = "###EndText###";

            int clientId = 0;
            char active = 'N';
            string lastName = GetRequestParameterValue("LastName");
            string firstName = GetRequestParameterValue("FirstName");
            string ssn = GetRequestParameterValue("SSN");
            DateTime? dob = null;
            if (GetRequestParameterValue("DOB") != "")
            {
                dob = Convert.ToDateTime(GetRequestParameterValue("DOB"));
            }
            char financiallyResponsible = 'Y';
            char doesNotSpeakEnglish = 'N';
            int staffId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberDetails = null;
                dataSetMemberDetails = objectMemberInquiries.CreateMemberRecord(active, lastName, firstName, ssn, dob, financiallyResponsible, doesNotSpeakEnglish, staffId,SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserCode);
                if (dataSetMemberDetails != null)
                {
                    if (dataSetMemberDetails.Tables.Count > 0)
                    {
                        if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                        {
                            clientId = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                            lastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                            firstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                            ssn = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                            dob = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                            literalResult.Text = (clientId.ToString() + "!@#$%" + lastName + "!@#$%" + firstName + "!@#$%" + ssn + "!@#$%" + dob.ToString());
                        }
                    }
                }
            }
            //Commented by Deepak Rai
            // Reason : PanelLoadUC on accessible on Main tab. 

            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

            string MemberInformationText = string.Empty;
            //To Get the Member Information like Member Id, Last Inquiry Date, Coverage History etc..
            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberInformation = null;
                dataSetMemberInformation = objectMemberInquiries.GetMemberInformationText(clientId);
                if (dataSetMemberInformation != null)
                {
                    if (dataSetMemberInformation.Tables.Count > 0)
                    {
                        if (dataSetMemberInformation.Tables.Contains("MemberInformation") == true)
                        {
                            MemberInformationText = dataSetMemberInformation.Tables["MemberInformation"].Rows[0][0].ToString();
                            MemberInfoResult.Text = (MemberInformationText).Replace("\\n", "\n").Replace("\\r", "\r");
                        }
                    }
                }
            }

            //Commented by Deepak Rai
            // Reason : PanelLoadUC on accessible on Main tab. 

            PanelLoadUC.Controls.Add(MemberInfoStart);
            PanelLoadUC.Controls.Add(MemberInfoResult);
            PanelLoadUC.Controls.Add(MemberInfoEnd);

            //if (clientId > 0)
            //{
            //    PageTitle += " [" + lastName+" ," + firstName + "("+clientId+")"+ " ]";
            //}
        }
        //To Get the Member Details for a selected Member
        if (GetRequestParameterValue("Flag") == "Inquiry (Selected Client)")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartInquiryMember###";
            literalEnd.Text = "###EndInquiryMember###";

            Literal MemberInfoStart = new Literal();
            Literal MemberInfoResult = new Literal();
            Literal MemberInfoEnd = new Literal();

            MemberInfoStart.Text = "###StartText###";
            MemberInfoEnd.Text = "###EndText###";

            int clientId = Convert.ToInt32(GetRequestParameterValue("MClientId"));
            string lastName = string.Empty;
            string firstName = string.Empty;
            string middleName = string.Empty;
            string ssn = string.Empty;
            DateTime? dob = null;
            string phone = string.Empty;
            string email = string.Empty;
            string address1 = string.Empty;
            string address2 = string.Empty;
            string city = string.Empty;
            string state = string.Empty;
            string zip = string.Empty;
            string emergencyContactFirstName = string.Empty;
            string emergencyContactMiddleName = string.Empty;
            string emergencyContactLastName = string.Empty;
            string emergencyContactRelationToClient = string.Empty;
            string emergencyContactHomePhone = string.Empty;
            string emergencyContactCellPhone = string.Empty;
            string emergencyContactWorkPhone = string.Empty;
            string sex = string.Empty;

            int AssignedPopulation = 0;
            SHS.UserBusinessServices.ClientInformation clientinfo = new SHS.UserBusinessServices.ClientInformation();
            DataSet dsclientinfo = clientinfo.GetClientDetails(clientId);
            int.TryParse(Convert.ToString(dsclientinfo.Tables["ClientInfo"].Rows[0]["AssignedPopulation"]), out AssignedPopulation);

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberDetails = null;
                dataSetMemberDetails = GetMemberDetails(clientId);
                if (dataSetMemberDetails != null)
                {
                    if (dataSetMemberDetails.Tables.Count > 0)
                    {
                        if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                        {
                            if (dataSetMemberDetails.Tables["MemberDetails"].Rows.Count > 0)
                            {
                                clientId = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                                firstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                                middleName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MiddleName"].ToString();
                                lastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                                ssn = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"].ToString() != "")
                                {
                                    dob = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                                }
                                phone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["PhoneNumber"].ToString();
                                email = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Email"].ToString();
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"] != DBNull.Value)
                                {
                                    string[] addresses = Regex.Split(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"].ToString().Replace("\\n", "\n").Replace("\\r", "\r"), "\r\n");
                                    address1 = addresses[0].ToString();
                                    if (addresses.Length > 1)
                                    {
                                        address2 = addresses[1].ToString();
                                    }

                                }
                                city = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["City"].ToString();
                                state = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["State"].ToString();
                                zip = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Zip"].ToString();

                                emergencyContactFirstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactFirstName"].ToString();
                                emergencyContactMiddleName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactMiddleName"].ToString();
                                emergencyContactLastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactLastName"].ToString();
                                emergencyContactRelationToClient = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString();
                                emergencyContactHomePhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactHomePhone"].ToString().Trim();
                                emergencyContactCellPhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactCellPhone"].ToString();
                                emergencyContactWorkPhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactWorkPhone"].ToString();

                                //Added Sex field
                                sex = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Sex"].ToString();

                            }
                            literalResult.Text = (clientId.ToString() + "!@#$%" + firstName + "!@#$%" + middleName + "!@#$%" + lastName + "!@#$%" + ssn + "!@#$%" + dob.ToString() + "!@#$%" + phone + "!@#$%" + email + "!@#$%" + address1 + "!@#$%" + address2 + "!@#$%" + city + "!@#$%" + state + "!@#$%" + zip + "!@#$%" + emergencyContactFirstName + "!@#$%" + emergencyContactMiddleName + "!@#$%" + emergencyContactLastName + "!@#$%" + emergencyContactRelationToClient + "!@#$%" + emergencyContactHomePhone + "!@#$%" + emergencyContactCellPhone + "!@#$%" + emergencyContactWorkPhone + "!@#$%" + sex + "!@#$%" + AssignedPopulation);
                        }
                    }
                }
            }
            //Commented by Deepak Rai
            // Reason : PanelLoadUC on accessible on Main tab. 

            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

            string MemberInformationText = string.Empty;
            //To Get the Member Information like Member Id, Last Inquiry Date, Coverage History etc..
            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberInformation = null;
                dataSetMemberInformation = objectMemberInquiries.GetMemberInformationText(clientId);
                if (dataSetMemberInformation != null)
                {
                    if (dataSetMemberInformation.Tables.Count > 0)
                    {
                        if (dataSetMemberInformation.Tables.Contains("MemberInformation") == true)
                        {
                            MemberInformationText = dataSetMemberInformation.Tables["MemberInformation"].Rows[0][0].ToString();
                            MemberInfoResult.Text = (MemberInformationText).Replace("\\n", "\n").Replace("\\r", "\r");
                        }
                    }
                }
            }
            //Commented by Deepak Rai
            // Reason : PanelLoadUC on accessible on Main tab. 

            PanelLoadUC.Controls.Add(MemberInfoStart);
            PanelLoadUC.Controls.Add(MemberInfoResult);
            PanelLoadUC.Controls.Add(MemberInfoEnd);

            //if (clientId > 0)
            //{
            //    PageTitle += " [" + lastName + " ," + firstName + "(" + clientId + ")" + " ]";
            //}
        }
        //To Get the Member Information like Member Id, Last Inquiry Date, Coverage History etc..
        if (GetRequestParameterValue("Flag") == "GetMemberInformationText")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartText###";
            literalEnd.Text = "###EndText###";

            int clientId = Convert.ToInt32(GetRequestParameterValue("MClientId"));
            string MemberInformationText = string.Empty;

            using (SHS.UserBusinessServices.MemberInquiriesKalamazoo objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiriesKalamazoo())
            {
                DataSet dataSetMemberInformation = null;
                int InquiryId=0;
                if(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet,"CustomInquiries",0))
                {
                    int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"].ToString(), out InquiryId);
                }

                dataSetMemberInformation = objectMemberInquiries.GetMemberInformationText(clientId, InquiryId);
                if (dataSetMemberInformation != null)
                {
                    if (dataSetMemberInformation.Tables.Count > 0)
                    {
                        if (dataSetMemberInformation.Tables.Contains("MemberInformation") == true)
                        {
                            MemberInformationText = dataSetMemberInformation.Tables["MemberInformation"].Rows[0][0].ToString();
                            literalResult.Text = MemberInformationText.Replace("\\n", "\n").Replace("\\r", "\r");
                        }
                    }
                }
            }
            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);
        }

        if (GetRequestParameterValue("Flag") == "New Registration")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();

            literalStart.Text = "###StartCreateMember###";
            literalEnd.Text = "###EndCreateMember###";

            //int clientId = 0;
            //char active = 'Y';
            //string lastName = GetRequestParameterValue("LastName");
            //string firstName = GetRequestParameterValue("FirstName");
            //string ssn = GetRequestParameterValue("SSN");
            //DateTime dob;
            //DateTime.TryParse(GetRequestParameterValue("DOB"), out dob);
            //char financiallyResponsible = 'Y';
            //char doesNotSpeakEnglish = 'N';
            //int staffId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;
            int clientId = 0;
            char active = 'N';
            string lastName = GetRequestParameterValue("LastName");
            string firstName = GetRequestParameterValue("FirstName");
            string ssn = GetRequestParameterValue("SSN");
            DateTime dob;
            DateTime.TryParse(GetRequestParameterValue("DOB"), out dob);
            char financiallyResponsible = 'Y';
            char doesNotSpeakEnglish = 'N';
            int staffId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId;

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberDetails = null;
                dataSetMemberDetails = objectMemberInquiries.CreateMemberRecord(active, lastName, firstName, ssn, dob, financiallyResponsible, doesNotSpeakEnglish, staffId,SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserCode);
                if (dataSetMemberDetails != null)
                {
                    if (dataSetMemberDetails.Tables.Count > 0)
                    {
                        if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                        {
                            //clientId = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                            //lastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                            //firstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                            //literalResult.Text = (clientId.ToString() + "!@#$%" + lastName + "!@#$%" + firstName);
                            clientId = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                            firstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                            lastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                            ssn = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                            if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"].ToString() != "")
                            {
                                dob = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                            }
                        }
                        literalResult.Text = (clientId.ToString() + "!@#$%" + firstName + "!@#$%" + "" + "!@#$%" + lastName + "!@#$%" + ssn + "!@#$%" + dob.ToString() + "!@#$%" + "" + "!@#$%" + "" + "!@#$%" + "" + "!@#$%" + "" + "!@#$%" + "" + "!@#$%" + "" + "!@#$%" + "");
                    }
                }
            }


            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

            //if (clientId > 0)
            //{
            //    PageTitle += " [" + lastName + " ," + firstName + "(" + clientId + ")" + " ]";
            //}
        }

        if (GetRequestParameterValue("Flag") == "Select Member")
        {
            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartInquiryMember###";
            literalEnd.Text = "###EndInquiryMember###";

            Literal MemberInfoStart = new Literal();
            Literal MemberInfoResult = new Literal();
            Literal MemberInfoEnd = new Literal();

            MemberInfoStart.Text = "###StartText###";
            MemberInfoEnd.Text = "###EndText###";

            int clientId = Convert.ToInt32(GetRequestParameterValue("MClientId"));
            string lastName = string.Empty;
            string firstName = string.Empty;
            string middleName = string.Empty;
            string ssn = string.Empty;
            DateTime? dob = null;
            string phone = string.Empty;
            string email = string.Empty;
            string address1 = string.Empty;
            string address2 = string.Empty;
            string city = string.Empty;
            string state = string.Empty;
            string zip = string.Empty;
            string emergencyContactFirstName = string.Empty;
            string emergencyContactMiddleName = string.Empty;
            string emergencyContactLastName = string.Empty;
            string emergencyContactRelationToClient = string.Empty;
            string emergencyContactHomePhone = string.Empty;
            string emergencyContactCellPhone = string.Empty;
            string emergencyContactWorkPhone = string.Empty;
            string masterId = string.Empty;
            string sex = string.Empty;
            int MedicaidId = 0;

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberDetails = null;
                dataSetMemberDetails = GetMemberDetails(clientId);
                if (dataSetMemberDetails != null)
                {
                    if (dataSetMemberDetails.Tables.Count > 0)
                    {
                        if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                        {
                            if (dataSetMemberDetails.Tables["MemberDetails"].Rows.Count > 0)
                            {
                                clientId = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                                firstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                                middleName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MiddleName"].ToString();
                                lastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                                ssn = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"].ToString() != "")
                                {
                                    dob = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                                }
                                phone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["PhoneNumber"].ToString();
                                email = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Email"].ToString();
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"] != DBNull.Value)
                                {
                                    string[] addresses = Regex.Split(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"].ToString().Replace("\\n", "\n").Replace("\\r", "\r"), "\r\n");
                                    address1 = addresses[0].ToString();
                                    if (addresses.Length > 1)
                                    {
                                        address2 = addresses[1].ToString();
                                    }

                                }
                                city = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["City"].ToString();
                                state = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["State"].ToString();
                                zip = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Zip"].ToString();

                                emergencyContactFirstName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactFirstName"].ToString();
                                emergencyContactMiddleName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactMiddleName"].ToString();
                                emergencyContactLastName = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactLastName"].ToString();
                                emergencyContactRelationToClient = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString();
                                emergencyContactHomePhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactHomePhone"].ToString().Trim();
                                emergencyContactCellPhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactCellPhone"].ToString();
                                emergencyContactWorkPhone = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactWorkPhone"].ToString();

                                //Added Sex field
                                sex = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Sex"].ToString();

                                if (!string.IsNullOrEmpty(Convert.ToString(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"])))
                                    masterId = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"].ToString();

                                if (clientId > 0)
                                {                                    
                                    SHS.UserBusinessServices.ClientInformation clientinfo = new SHS.UserBusinessServices.ClientInformation();
                                    DataSet dsclientinfo = clientinfo.GetClientDetails(clientId);
                                    int.TryParse(Convert.ToString(dsclientinfo.Tables["ClientInfo"].Rows[0]["MedicaidId"]), out MedicaidId);
                                    BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["MedicaidId"] = MedicaidId == 0 ? DBNull.Value : (object)MedicaidId;
                                }
                            }
                            literalResult.Text = (clientId.ToString() + "!@#$%" + firstName + "!@#$%" + middleName + "!@#$%" + lastName + "!@#$%" + ssn + "!@#$%" + dob.ToString() + "!@#$%" + phone + "!@#$%" + email + "!@#$%" + address1 + "!@#$%" + address2 + "!@#$%" + city + "!@#$%" + state + "!@#$%" + zip + "!@#$%" + emergencyContactFirstName + "!@#$%" + emergencyContactMiddleName + "!@#$%" + emergencyContactLastName + "!@#$%" + emergencyContactRelationToClient + "!@#$%" + emergencyContactHomePhone + "!@#$%" + emergencyContactCellPhone + "!@#$%" + emergencyContactWorkPhone + "!@#$%" + sex + "!@#$%" + "" + "!@#$%" + masterId + "!@#$%" + (MedicaidId == 0 ? "" :MedicaidId.ToString()));
                        }
                    }
                }
            }


            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

            string MemberInformationText = string.Empty;

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet dataSetMemberInformation = null;
                dataSetMemberInformation = objectMemberInquiries.GetMemberInformationText(clientId);
                if (dataSetMemberInformation != null)
                {
                    if (dataSetMemberInformation.Tables.Count > 0)
                    {
                        if (dataSetMemberInformation.Tables.Contains("MemberInformation") == true)
                        {
                            MemberInformationText = dataSetMemberInformation.Tables["MemberInformation"].Rows[0][0].ToString();
                            MemberInfoResult.Text = (MemberInformationText).Replace("\\n", "\n").Replace("\\r", "\r");
                        }
                    }
                }
            }

            PanelLoadUC.Controls.Add(MemberInfoStart);
            PanelLoadUC.Controls.Add(MemberInfoResult);
            PanelLoadUC.Controls.Add(MemberInfoEnd);

            //if (clientId > 0)
            //{
            //    PageTitle += " [" + lastName + " ," + firstName + "(" + clientId + ")" + " ]";
            //}
        }


        if (GetRequestParameterValue("Flag") == "CheckEpisodes")
        {
            int inquiryId = Convert.ToInt32(GetRequestParameterValue("InquiryId"));
            int memberId = Convert.ToInt32(GetRequestParameterValue("MemberId"));
            string isEpisodeExists = string.Empty;

            PanelMain.Visible = false;
            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartEpisode###";
            literalEnd.Text = "###EndEpisode###";

            using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
            {
                DataSet datasetIsEpisodeExists = null;
                datasetIsEpisodeExists = objectMemberInquiries.CheckIsEpisodeAlreadyExists(memberId, inquiryId);
                if (datasetIsEpisodeExists != null)
                {
                    if (datasetIsEpisodeExists.Tables.Count > 0)
                    {
                        if (datasetIsEpisodeExists.Tables.Contains("Episodes") == true)
                        {
                            isEpisodeExists = datasetIsEpisodeExists.Tables["Episodes"].Rows[0][0].ToString();
                            literalResult.Text = (isEpisodeExists);
                        }
                    }
                }
            }

            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);
        }

        if (base.GetRequestParameterValue("Flag") == "AlterDispositionControl")
        {
            PanelMain.Visible = false;
            LoadDispositionDropDownControlForService();
        }

        if (base.GetRequestParameterValue("Flag") == "RemoveMemberLink")
        {
            int clientIdToRemove = Convert.ToInt32(GetRequestParameterValue("ClientId"));
            int inquiryId = Convert.ToInt32(GetRequestParameterValue("InquiryId"));
            string currentUserId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserCode.ToString();
            RemoveMemberEventFromCare(clientIdToRemove, inquiryId, currentUserId);
        }

        if (base.GetRequestParameterValue("Flag") == "GetGlobalCode")
        {
            var codeName = GetRequestParameterValue("CodeName");

            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartGlobalCode###";
            literalEnd.Text = "###EndGlobalCode###";
            literalResult.Text = GetGlobalCode(codeName);
            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

        }

        if (base.GetRequestParameterValue("Flag") == "GetDispositionDropDown")
        {
            PanelMain.Visible = false;

            Literal literalStart = new Literal();
            Literal literalResult = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartDispositionHTML###";
            literalEnd.Text = "###EndDispositionHTML###";

            string calledMethod = GetRequestParameterValue("calledMethod");
            string key = GetRequestParameterValue("key");
            
            literalResult.Text=GetDispositionDropDownsHTML(calledMethod, key);

            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalResult);
            PanelLoadUC.Controls.Add(literalEnd);

        }
    }
    public string GetDispositionDropDownsHTML(string calledMethod, string key)
    {
        StringBuilder stringHTML = new StringBuilder();
        if (calledMethod == "ServiceDisposition")
        {
            int ddValue = 0;

            int.TryParse(key, out ddValue);
            stringHTML.Append("<option value='' >Select Service Type</option>");
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
            {
                DataView dataViewGlobalSubCodesCodesServiceType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
                dataViewGlobalSubCodesCodesServiceType.RowFilter = "globalcodeid='" + ddValue + "'and isnull(RecordDeleted,'N')<>'Y'";

                for (int i = 0; i < dataViewGlobalSubCodesCodesServiceType.Count; i++)
                {
                    stringHTML.Append("<option value=" + dataViewGlobalSubCodesCodesServiceType[i]["GlobalSubCodeId"] + " title='" + Convert.ToString(dataViewGlobalSubCodesCodesServiceType[i]["SubCodeName"]) + "'>" + Convert.ToString(dataViewGlobalSubCodesCodesServiceType[i]["SubCodeName"]) + "</option>");
                }
            }

        }
        else
            if (calledMethod == "ProviderService")
            {
                int ddValue = 0;

                int.TryParse(key, out ddValue);
                stringHTML.Append("<option value='' >Select Provider/Agency</option>");
                using (SHS.UserBusinessServices.MemberInquiriesKalamazoo objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiriesKalamazoo())
                {
                    DataSet dataSetProgramsBasedOnServiceType = new DataSet();
                    dataSetProgramsBasedOnServiceType = objectMemberInquiries.GetProgramsBasedOnServiceType(ddValue);
                    if (BaseCommonFunctions.CheckRowExists(dataSetProgramsBasedOnServiceType, "ProgramsBasedOnServiceType", 0))
                    {
                        foreach (DataRow dr in dataSetProgramsBasedOnServiceType.Tables["ProgramsBasedOnServiceType"].Rows)
                        {
                            stringHTML.Append("<option value=" + dr["ProgramId"] + " title='" + Convert.ToString(dr["ProgramName"]) + "'>" + Convert.ToString(dr["ProgramName"]) + "</option>");
                        }
                    }
                }

            }
        return stringHTML.ToString();
    }
    private void RemoveMemberEventFromCare(int clientIdToRemove, int inquiryId, string currentUserId)
    {
        using (SHS.UserBusinessServices.MemberInquiriesKalamazoo objectMemberInquiriesKalamazoo = new SHS.UserBusinessServices.MemberInquiriesKalamazoo())
        {
            objectMemberInquiriesKalamazoo.RemoveMemberEventFromCare(clientIdToRemove, inquiryId, currentUserId);
        }
    }
    
    /// <summary>
    /// This function is overidden from inherited class DataActivityPage.
    /// Used to make changes in the initialized dataset
    /// </summary>
    /// <param name="dataSetObject"></param>
    public override void ChangeInitializedDataSet(ref DataSet dataSetObject)
    {
        int clientId = 0;
        DataSet dataSetCoverageDetails = null;
        if (dataSetObject.Tables["CustomInquiries"].Rows.Count > 0)
        {            
            //Select from Quick Action.
            if (GetRequestParameterValue("CustomButtonCaption") == "Inquiry (Selected Client)")
            {
                clientId = Convert.ToInt32(GetRequestParameterValue("MClientId"));
                int AssignedPopulation = 0;
                SHS.UserBusinessServices.ClientInformation clientinfo = new SHS.UserBusinessServices.ClientInformation();
                DataSet dsclientinfo = clientinfo.GetClientDetails(clientId);
                int.TryParse(Convert.ToString(dsclientinfo.Tables["ClientInfo"].Rows[0]["AssignedPopulation"]), out AssignedPopulation);

                using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
                {
                    DataSet dataSetMemberDetails = null;
                    dataSetMemberDetails = GetMemberDetails(clientId);
                    dataSetCoverageDetails=dataSetMemberDetails;
                    if (dataSetMemberDetails != null)
                    {
                        if (dataSetMemberDetails.Tables.Count > 0)
                        {
                            if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                            {
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows.Count > 0)
                                {
                                    // Code Added by deepak on 27122011
                                    //Block Start
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerRelationToMember"] = "6781";
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerFirstName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerLastName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerEmail"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Email"].ToString();

                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactFirstName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactFirstName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactMiddleName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactMiddleName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactLastName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactLastName"].ToString();

                                    //Added by himanshu
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString() != "")
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactRelationToClient"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString();

                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactHomePhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactHomePhone"].ToString().Trim();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactCellPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactCellPhone"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactWorkPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactWorkPhone"].ToString();

                                    //Added Sex field
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["Sex"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Sex"].ToString();

                                    // Block End
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ClientId"] = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberFirstName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberMiddleName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MiddleName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberLastName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["SSN"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"].ToString() != "")
                                    {
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["DateOfBirth"] = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                                    }
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["PhoneNumber"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberEmail"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Email"].ToString();
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"] != DBNull.Value)
                                    {
                                        string[] addresses = Regex.Split(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"].ToString().Replace("\\n", "\n").Replace("\\r", "\r"), "\r\n");
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["Address1"] = addresses[0].ToString();
                                        if (addresses.Length > 1)
                                        {
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["Address2"] = addresses[1].ToString();
                                        }
                                    }
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["PresentingPopulation"] = AssignedPopulation == 0 ? DBNull.Value : (object)AssignedPopulation;
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["City"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["City"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["State"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["State"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ZipCode"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Zip"].ToString();
                                    //Added by himanshu
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"].ToString() != "")
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["MasterId"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"];
                                    
                                    ///
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["RegistrationDate"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["RegistrationDate"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["EpisodeNumber"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EpisodeNumber"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["DischargeDate"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DischargeDate"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralDate"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ReferralDate"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["EpisodeStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Status"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralType"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ReferralType"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralSubtype"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ReferralSubtype"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ReferralName"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralAdditionalInformation"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ReferralAdditionalInformation"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["Living"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LivingArrangement"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["NoOfBeds"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["NumberOfBeds"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["CountyOfResidence"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["CountyOfResidence"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["COFR"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["COFR"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["CorrectionStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["CorrectionStatus"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["DHSStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DHSAbuseNeglect"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EducationalStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EducationalStatus"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["VeteranStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["AreyouVeteran"];
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmploymentStatus"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmploymentStatus"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["EmployerName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmploymentInformation"];
                                    //dataSetObject.Tables["CustomInquiries"].Rows[0]["MinimumWage"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MinimumWage"];
                                }
                            }
                        }
                    }
                }
            }

            
            clientId = 0;

            if (GetRequestParameterValue("CustomButtonCaption") == "Inquiry (New Client)")
            {
                // Code Added by deepak on 27122011
                //Block Start
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerRelationToMember"] = "6781";
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerFirstName"] = GetRequestParameterValue("FirstName");
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquirerLastName"] = GetRequestParameterValue("LastName");
                // Block End
                dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberFirstName"] = GetRequestParameterValue("FirstName");
                dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberLastName"] = GetRequestParameterValue("LastName");
                dataSetObject.Tables["CustomInquiries"].Rows[0]["SSN"] = GetRequestParameterValue("SSN");
                if (GetRequestParameterValue("DOB") != "")
                {
                    dataSetObject.Tables["CustomInquiries"].Rows[0]["DateOfBirth"] = Convert.ToDateTime(GetRequestParameterValue("DOB"));
                }


                //---- New Code written by Pralyankar For Fixing ClientId Issue ------
                if (base.ParentPageObject.PageAction == BaseCommonFunctions.PageActions.New && ParentPageObject.ScreenId != 10683)
                {
                    if (!int.TryParse(Convert.ToString(GetRequestParameterValue("MClientId")), out clientId))
                    {
                        if (GetRequestParameterValue("CustomButtonCaption") != "Inquiry (New Client)")
                        {
                            clientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                        }
                    }
                }
            }
            else
            {
                if (BaseCommonFunctions.ApplicationInfo.Client.ClientId > 0 && base.ParentPageObject.PageAction == BaseCommonFunctions.PageActions.New)
                {
                    if (!int.TryParse(Convert.ToString(GetRequestParameterValue("MClientId")), out clientId))
                    {
                        if (GetRequestParameterValue("CustomButtonCaption") != "Inquiry (New Client)")
                        {
                            clientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                        }
                    }
                }
            }
            //---- End Code For Fixing ClientId Issue ------


            if (clientId >0)// (BaseCommonFunctions.ApplicationInfo.Client.ClientId > 0 && base.ParentPageObject.PageAction == BaseCommonFunctions.PageActions.New)
            {
                //if (!int.TryParse(Convert.ToString(GetRequestParameterValue("MClientId")), out clientId))
                //    if (GetRequestParameterValue("CustomButtonCaption") != "Inquiry (New Client)")
                //    {
                //        clientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                //    }

                using (SHS.UserBusinessServices.MemberInquiries objectMemberInquiries = new SHS.UserBusinessServices.MemberInquiries())
                {
                    DataSet dataSetMemberDetails = null;
                    dataSetMemberDetails = GetMemberDetails(clientId);
                    if (dataSetMemberDetails != null)
                    {
                        if (dataSetMemberDetails.Tables.Count > 0)
                        {
                            if (dataSetMemberDetails.Tables.Contains("MemberDetails") == true)
                            {
                                if (dataSetMemberDetails.Tables["MemberDetails"].Rows.Count > 0)
                                {
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ClientId"] = Convert.ToInt32(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["ClientId"]);
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberFirstName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["FirstName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberMiddleName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MiddleName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberLastName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["LastName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["SSN"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["SSN"].ToString();
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"].ToString() != "")
                                    {
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["DateOfBirth"] = Convert.ToDateTime(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["DOB"]);
                                    }
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["PhoneNumber"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["MemberEmail"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Email"].ToString();
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"] != DBNull.Value)
                                    {
                                        string[] addresses = Regex.Split(dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Address"].ToString().Replace("\\n", "\n").Replace("\\r", "\r"), "\r\n");
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["Address1"] = addresses[0].ToString();
                                        if (addresses.Length > 1)
                                        {
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["Address2"] = addresses[1].ToString();
                                        }
                                    }
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["City"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["City"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["State"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["State"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["ZipCode"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Zip"].ToString();

                                    //Added by himanshu
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"].ToString() != "")
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["MasterId"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["MasterId"];

                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactFirstName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactFirstName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactMiddleName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactMiddleName"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactLastName"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactLastName"].ToString();
                                    //Added by himanshu
                                    if (dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString() != "")
                                        dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactRelationToClient"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactRelationToClient"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactHomePhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactHomePhone"].ToString().Trim();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactCellPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactCellPhone"].ToString();
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["EmergencyContactWorkPhone"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["EmergencyContactWorkPhone"].ToString();

                                    //Added Sex field
                                    dataSetObject.Tables["CustomInquiries"].Rows[0]["Sex"] = dataSetMemberDetails.Tables["MemberDetails"].Rows[0]["Sex"].ToString();

                                    //Added Referal information,  Income/Fee information, Legal, Marital Status, Primary Spoken Language, Accomodation Needed and Education info
                                    if (dataSetMemberDetails.Tables.Count > 1)
                                    {
                                        if (dataSetMemberDetails.Tables["CustomInquiries"].Rows.Count > 0)
                                        {
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralType"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferralType"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferralSubtype"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferralSubtype"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalOrganizationName"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalOrganizationName"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalFirstName"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalFirstName"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalPhone"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalPhone"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalLastName"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalLastName"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalAddressLine1"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalAddressLine1"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalAddressLine2"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalAddressLine2"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalCity"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalCity"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalState"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalState"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalZip"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalZip"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalEmail"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalEmail"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["ReferalComments"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["ReferalComments"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHeadHousehold"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHeadHousehold"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHouseholdComposition"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHouseholdComposition"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralDependents"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralDependents"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHousehold"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHousehold"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHouseholdAnnualIncome"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralHouseholdAnnualIncome"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralAnnualIncome"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralAnnualIncome"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralPrimarySource"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralPrimarySource"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralMonthlyIncome"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralMonthlyIncome"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralAlternativeSource"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralAlternativeSource"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeCharge"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeCharge"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeBeginDate"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeBeginDate"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeComment"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeComment"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeStartDate"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeStartDate"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeEndDate"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeEndDate"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeIncomeVerified"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeeIncomeVerified"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeePerSessionFee"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeSpecialFeePerSessionFee"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["IncomeGeneralDependents"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["IncomeGeneralDependents"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["OtherDemographicsLegal"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["OtherDemographicsLegal"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["OtherDemographicsMaritalStatus"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["OtherDemographicsMaritalStatus"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["PrimarySpokenLanguage"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["PrimarySpokenLanguage"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["AccomodationNeeded"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["AccomodationNeeded"];
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["SchoolName"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["SchoolName"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["SchoolDistric"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["SchoolDistric"].ToString();
                                            dataSetObject.Tables["CustomInquiries"].Rows[0]["Education"] = dataSetMemberDetails.Tables["CustomInquiries"].Rows[0]["Education"].ToString();
                                        }
                                    }

                                    if (dataSetMemberDetails.Tables.Count > 2)
                                    {
                                        // Commented the merge function to avoid concurrency error. #108 New Directions Support Go Live
                                        //dataSetObject.Tables["CustomInquiriesCoverageInformations"].Merge(dataSetMemberDetails.Tables["CustomInquiriesCoverageInformations"]);
                                        dataSetObject.Tables["CoveragePlans"].Merge(dataSetMemberDetails.Tables["CoveragePlans"]);
                                    }

                                }
                            }
                        }
                    }
                }
            }

            if (base.ParentPageObject.PageAction == BaseCommonFunctions.PageActions.New)
            {
                if (dataSetObject.Tables["CustomDispositions"] != null && dataSetObject.Tables["CustomDispositions"].Rows.Count > 0)
                {
                    dataSetObject.Tables["CustomDispositions"].Rows[0]["InquiryId"] = -1;
                }
                if (dataSetObject.Tables["CustomServiceDispositions"] != null && dataSetObject.Tables["CustomServiceDispositions"].Rows.Count > 0)
                {
                    dataSetObject.Tables["CustomServiceDispositions"].Rows[0]["CustomDispositionId"] = -1;
                }
                if (dataSetObject.Tables["CustomProviderServices"] != null && dataSetObject.Tables["CustomProviderServices"].Rows.Count > 0)
                {
                    dataSetObject.Tables["CustomProviderServices"].Rows[0]["CustomServiceDispositionId"] = -1;
                }
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquiryStartDateTime"] = DateTime.Now;
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquiryStartDate"] = DateTime.Now.ToString("MM/dd/yyyy");
                dataSetObject.Tables["CustomInquiries"].Rows[0]["InquiryStartTime"] = DateTime.Now.ToString("hh:mm tt");
            }
        }
    }

    /// <summary>
    /// Used to Get the details of a particular client
    /// </summary>
    /// <param name="clientId"></param>
    /// <returns>DataSet of Member Details</returns>
    public DataSet GetMemberDetails(int clientId)
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetMemberDetails = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ClientId", clientId);
        dataSetMemberDetails = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetMemberDetailedInformation", dataSetMemberDetails, new string[] { "MemberDetails", "CustomInquiries", "CustomInquiriesCoverageInformations", "CoveragePlans" }, _objectSqlParmeters);
        return dataSetMemberDetails;
    }

    public override void ChangeDataSetAfterGetData()
    {
        if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.GetScreenInfoDataSet(), "CustomInquiries", 0))
        {
            int clientId = 0;
            int.TryParse(Convert.ToString(BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["ClientId"]), out clientId);
            if (clientId > 0)
            {
                int AssignedPopulation = 0;
                SHS.UserBusinessServices.ClientInformation clientinfo = new SHS.UserBusinessServices.ClientInformation();
                DataSet dsclientinfo = clientinfo.GetClientDetails(clientId);
                int.TryParse(Convert.ToString(dsclientinfo.Tables["ClientInfo"].Rows[0]["AssignedPopulation"]), out AssignedPopulation);
                //BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Rows[0]["PresentingPopulation"] = AssignedPopulation == 0 ? DBNull.Value : (object)AssignedPopulation;
            }
        }
    }

    private void LoadDispositionDropDownControlForService()
    {
        bool IsNew = false;
        string bindControlId = base.GetRequestParameterValue("bindControlId");
        string callMethod = base.GetRequestParameterValue("callMethod");
        string operationType = base.GetRequestParameterValue("operationType");
        string operationOn = base.GetRequestParameterValue("operationOn");
        int pKey = Convert.ToInt32(base.GetRequestParameterValue("PrKey"));
        int changeValue = 0;
        int.TryParse(base.GetRequestParameterValue("changeValue"), out changeValue);
        int deleteParentKey = 0;
        int.TryParse(base.GetRequestParameterValue("PPKey"), out deleteParentKey);

        int inqueryId = 0;
        int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"].ToString(), out inqueryId);
        UserControl userControl = LoadUC("~/CommonUserControls/DispositionProviderServiceType.ascx", bindControlId, callMethod, operationType, operationOn, pKey, changeValue, deleteParentKey, IsNew, inqueryId, 0);
        MainPanelUC.Controls.Clear();
        MainPanelUC.Controls.Add(userControl);
    }
    
    public override void AfterUpdateProcess(ref DataSet dataSetObject)
    {
        if (GetRequestParameterValue("Flag") == "New Registration")
            base.ParentDetailPageObject.SetParentScreenProperties("CalledFrom", "NewRegistration");
        else if (GetRequestParameterValue("Flag") == "CheckEpisodes")
            base.ParentDetailPageObject.SetParentScreenProperties("CalledFrom", "CheckEpisodes");
    }

    /// <summary>
    /// Delete Data from the CM/PA data after Deletion of the inquiry.
    /// </summary>
    /// <param name="dataSetObject"></param>
    public override void AfterDeleteProcess(ref DataSet dataSetObject)
    {
        int clientIdToRemove = 0;
        if (dataSetObject.Tables["CustomInquiries"].Rows[0]["ClientId"] != DBNull.Value)
        {
            clientIdToRemove = Convert.ToInt32(dataSetObject.Tables["CustomInquiries"].Rows[0]["ClientId"].ToString());
        }
        int inquiryId = Convert.ToInt32(dataSetObject.Tables["CustomInquiries"].Rows[0]["InquiryId"].ToString()); 
        string currentUserId = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserCode.ToString();
        //RemoveMemberEventFromCare(clientIdToRemove, inquiryId, currentUserId);
        //RefreshMainTableFromSharedTableAfterDelete();
    }



    private UserControl LoadUC(string LoadUCName, params object[] constructorParameters)
    {
        System.Web.UI.UserControl userControl = null;
        string ucControlPath = string.Empty;

        ucControlPath = LoadUCName;

        List<Type> constParamTypes = new List<Type>();

        foreach (object constParam in constructorParameters)
        {
            constParamTypes.Add(constParam.GetType());
        }

        if (!string.IsNullOrEmpty(ucControlPath))
        {
            userControl = (UserControl)this.Page.LoadControl(ucControlPath);
        }

        ConstructorInfo constructor = userControl.GetType().BaseType.GetConstructor(constParamTypes.ToArray());

        //And then call the relevant constructor
        if (constructor == null)
        {
            throw new MemberAccessException("The requested constructor was not found on : " + userControl.GetType().BaseType.ToString());
        }
        else
        {
            constructor.Invoke(userControl, constructorParameters);
        }

        return userControl;
    }


    /// <summary>
    /// Set Null valu in fields if this is bank
    /// </summary>
    /// <param name="dataSetObject"></param>
    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        
        if (dataSetObject != null)
        {
            
            if (dataSetObject.Tables["CustomInquiries"].Rows.Count > 0)
            {
                DataRow objectDataRow = dataSetObject.Tables["CustomInquiries"].Rows[0];
                if (objectDataRow != null)
                {
                    if (objectDataRow["InquirerFirstName"].ToString().Trim() == "")
                        objectDataRow["InquirerFirstName"] = DBNull.Value;
                    if (objectDataRow["InquirerLastName"].ToString().Trim() == "")
                        objectDataRow["InquirerLastName"] = DBNull.Value;
                    if (objectDataRow["InquirerMiddleName"].ToString().Trim() == "")
                        objectDataRow["InquirerMiddleName"] = DBNull.Value;
                    if (objectDataRow["InquirerEmail"].ToString().Trim() == "")
                        objectDataRow["InquirerEmail"] = DBNull.Value;
                    if (objectDataRow["MemberFirstName"].ToString().Trim() == "")
                        objectDataRow["MemberFirstName"] = DBNull.Value;
                    if (objectDataRow["MemberMiddleName"].ToString().Trim() == "")
                        objectDataRow["MemberMiddleName"] = DBNull.Value;
                    if (objectDataRow["MemberLastName"].ToString().Trim() == "")
                        objectDataRow["MemberLastName"] = DBNull.Value;
                    if (objectDataRow["MemberPhone"].ToString().Trim() == "")
                        objectDataRow["MemberPhone"] = DBNull.Value;
                }
                if(dataSetObject.Tables.Contains("Table4"))
                {
                    dataSetObject.Tables.Remove("Table4");
                }
                if (dataSetObject.Tables.Contains("CoveragePlans"))
                {
                    dataSetObject.Tables.Remove("CoveragePlans");
                }
                if (dataSetObject.Tables.Contains("CustomInquiriesCoverageInformations"))
                {                                      
                    List<DataRow> rowsToDelete = new List<DataRow>();
                    foreach (DataRow row in dataSetObject.Tables["CustomInquiriesCoverageInformations"].Rows)
                    {
                        if (row["RecordDeleted"].ToString() == "Y" && Convert.ToInt32(row["InquiriesCoverageInformationId"]) < 0)
                        {
                            rowsToDelete.Add( row );
                        }                        
                    }

                    foreach( DataRow row in rowsToDelete )
                    {
                        dataSetObject.Tables["CustomInquiriesCoverageInformations"].Rows.Remove(row);
                    }
                    for (int i = 0; i < dataSetObject.Tables["CustomInquiriesCoverageInformations"].Rows.Count; i++)
                    {
                        dataSetObject.Tables["CustomInquiriesCoverageInformations"].Rows[i]["NewlyAddedplan"] = "Y";
                    }

                }
                
                
                if (dataSetObject.Tables.Contains("CoveragePlans"))
                {
                    dataSetObject.Tables.Remove("CoveragePlans");
                }
            }

        }

    }


}
