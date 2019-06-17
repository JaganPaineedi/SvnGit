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

public partial class PharmacyManagement : System.Web.UI.Page
{
    private const int PageSize = 10;
    protected int startrowIndex;
    protected int endRowIndex;
    protected int CurrentPage = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            int intLoop = 0;
            if (Request["FunctionId"].ToString() != string.Empty)
            {
                switch (Request["FunctionId"].ToString())
                {
                    case "GetPharmacyList":
                        {
                            try
                            {
                                Streamline.UserBusinessServices.ClientMedication objectClientMedications = new ClientMedication();
                                DataSet dsTemp = new DataSet();
                                DataRow[] _DataRow = null;
                                objectClientMedications = new ClientMedication();
                                dsTemp = objectClientMedications.GetPharmaciesData();
                                _DataRow = dsTemp.Tables[0].Select(null, Request["par" + intLoop.ToString()]);
                                DataSet _dsPharmacies = new DataSet();
                                _dsPharmacies.Merge(_DataRow);
                                PharmacyList1.Visible = true;
                                PharmacyList1.SortString = Request["par" + intLoop.ToString()];
                                if (_dsPharmacies != null && _dsPharmacies.Tables.Count > 0)
                                    PharmacyList1.GenerateRows(_dsPharmacies.Tables[0], false);
                                Session["PharmacyId"] = null;
                            }
                            catch (Exception ex)
                            {
                            }
                            break;
                        }
                    case "GetAllPharmaciesList":
                        {
                            DataRow[] _DataRow = null;
                            Streamline.UserBusinessServices.ClientMedication objectClientMedications = new ClientMedication();
                            DataSet dsTemp = new DataSet();
                            objectClientMedications = new ClientMedication();
                            dsTemp = objectClientMedications.GetPharmaciesData();
                            _DataRow = dsTemp.Tables[0].Select("isnull(recorddeleted,'N')<>'Y'", "PharmacyName asc");
                            DataSet _dsPharmacies = new DataSet();
                            _dsPharmacies.Merge(_DataRow);
                            PharmacyList1.Visible = true;
                            PharmacyList1.SortString = "PharmacyName asc";
                            if (_dsPharmacies != null && _dsPharmacies.Tables.Count > 0)
                                PharmacyList1.GenerateRows(_dsPharmacies.Tables[0], false);
                            Session["PharmacyId"] = null;
                            break;
                        }
                    //Ref:Task no:85
                    case "GetSearchPharmaciesList":
                        {
                            int PharmacyId = 0;
                            string PharmacyName = "";
                            string Phone = "";
                            string Fax = "";
                            string State = "";
                            string City = "";
                            string Address = "";
                            string Zip = "";
                            string SureScriptIdentifier = "";
                            string Specialty = "";
                            if (Request["PharmacyId"].ToString() != "")
                                PharmacyId = Convert.ToInt32(Request["PharmacyId"].ToString());
                            Phone = Request["Phone"].ToString();
                            PharmacyName = Request["PharmacyName"].ToString();
                            Address = Request["Address"].ToString();
                            Fax = Request["Fax"].ToString();
                            City = Request["City"].ToString();
                            State = Request["State"].ToString();
                            Zip = Request["Zip"].ToString();
                            SureScriptIdentifier = Request["SureScriptIdentifier"].ToString();
                            Specialty = Request["Specialty"].ToString();
                            Streamline.UserBusinessServices.ClientMedication objectClientMedications = new ClientMedication();
                            DataSet dsTemp = new DataSet();
                            if (Request["CurrentPage"].ToString() != "")
                                CurrentPage = Convert.ToInt32(Request["CurrentPage"].ToString());
                            startrowIndex = (CurrentPage * PageSize) + 1;
                            endRowIndex = (PageSize * CurrentPage) + PageSize;
                            PharmacySerachList.Visible = true;
                            PharmacySerachList.GridBind(PharmacyName, Address, City, State, Zip, Phone, Fax, PharmacyId, SureScriptIdentifier, Specialty, startrowIndex, endRowIndex, CurrentPage, PageSize);
                            Session["SearchList"] = dsTemp;
                            break;
                        }
                    case "GetPharmacySearchListSort":
                        {
                            try
                            {
                                PharmacySerachList.Visible = true;
                                string Sortcolumn = Request["SortColumn"].ToString();
                                string Sortdirection = Request["SortDirection"].ToString();
                                int CurrentPage = 0;
                                if (Request["CurrentPage"].ToString() != "")
                                    CurrentPage = Convert.ToInt32(Request["CurrentPage"].ToString());
                                PharmacySerachList.GridBindOnSorting(Sortcolumn, Sortdirection, CurrentPage);
                            }
                            catch (Exception ex)
                            {

                            }
                            break;
                        }
                }
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

}
