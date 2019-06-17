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
using Streamline.DataService;
using Streamline.BaseLayer;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;
using System.Linq;


public partial class KeyPhrases : Streamline.BaseLayer.ActivityPages.ActivityPage
{


    public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
    private string _ConnectionString = ConnectionString;

    protected override void Page_Load(object sender, EventArgs e)
    {

        Streamline.UserBusinessServices.ClientMedication objectClientMedications;
        objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
        DataSet DataSetStaffKeyPhrases = null;
        Int32 staffid = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
        DataSetStaffKeyPhrases = GetMyKeyPhrases(staffid);
        Session["DataSetKeyPhrases"] = DataSetStaffKeyPhrases;


    }

    public DataSet GetMyKeyPhrases(int StaffID)
    {
        SqlParameter[] _ParametersObject = null;
        try
        {
            _ParametersObject = new SqlParameter[1];
            _ParametersObject[0] = new SqlParameter("@StaffID", StaffID);

            DataSet dsTemp = new DataSet();
            string[] _TableNames = { "KeyPhrases", "AgencyKeyPhrases","StaffAgencyKeyPhrases" };
            SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "csp_GetStaffKeyPhrases", dsTemp, _TableNames, _ParametersObject);
            return dsTemp;
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMyKeyPhrases(), ParameterCount - 1,FirstParameter-" + StaffID + " ###";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            throw ex;
        }

    }
}



