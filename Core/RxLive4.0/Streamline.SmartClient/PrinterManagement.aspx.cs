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

public partial class PrinterManagement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            int intLoop = 0;
            if (Request["FunctionId"].ToString() != string.Empty)
            {
                switch (Request["FunctionId"].ToString())
                {
                    case "GetPrinterList":
                        {
                            try
                            {
                                //if (Session["DataSetClientMedications"] != null)
                                // {
                                //Streamline.UserBusinessServices.DataSets.DataSetPharmacies _dsPharmacies = new Streamline.UserBusinessServices.DataSets.DataSetPharmacies();
                                Streamline.UserBusinessServices.ClientMedication objectClientMedications = new ClientMedication();
                                DataSet dsTemp = new DataSet();
                                DataRow[] _DataRow = null;
                                objectClientMedications = new ClientMedication();
                                dsTemp = objectClientMedications.GetPrinterData();
                                //if (Request["par1"] == "All")
                                //{
                                //    _DataRow = dsTemp.Tables[0].Select(null, Request["par" + intLoop.ToString()]);
                                //}
                                //else
                                //{
                                   // _DataRow = dsTemp.Tables[0].Select("Active='Y'", Request["par" +  intLoop.ToString()]);
                               // }
                                //DataSet _dsPrinter = new DataSet();
                               // _dsPrinter.Merge(_DataRow);
                                PrinterList1.SortString = Request["par" + intLoop.ToString()];
                                if (dsTemp != null && dsTemp.Tables.Count > 0)
                                    PrinterList1.GenerateRows(dsTemp.Tables[0]);
                            }
                            catch (Exception ex)
                            {

                            }
                            //}
                            break;
                        }
                    case "GetPrinterListOnHeaderClick":
                        {
                            try
                            {
                                Streamline.UserBusinessServices.ClientMedication objectClientMedications = new ClientMedication();
                                DataSet dsTemp = new DataSet();
                                DataRow[] _DataRow = null;
                                objectClientMedications = new ClientMedication();
                                dsTemp = objectClientMedications.GetPrinterData();
                                _DataRow = dsTemp.Tables[0].Select(null, Request["par0"]);
                                DataSet _dsPrinter = new DataSet();
                                _dsPrinter.Merge(_DataRow);
                                PrinterList1.SortString = Request["par0"];
                                if (_dsPrinter != null && _dsPrinter.Tables.Count > 0)
                                    PrinterList1.GenerateRows(_dsPrinter.Tables[0]);
                                
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
