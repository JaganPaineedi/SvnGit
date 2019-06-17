using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using Microsoft.VisualBasic;
using System.IO;
using System.Reflection;
using System.Xml.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Collections;
using System.Diagnostics;

namespace Streamline.SmartClient.WebServices
{
    /// <summary>
    /// Summary description for UserPreferences
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class UserPreferences : Streamline.BaseLayer.WebServices.WebServiceBasePage
    {
        Streamline.UserBusinessServices.DataSets.DataSetPharmacies _dsPharmacies;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        //Code added in Ref to Task#2595
        Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;
        //Code added in ref to Task#34
        Streamline.UserBusinessServices.DataSets.DataSetHealthData dataSetHealthData = null;
        Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations _dsPrinter = null;
        //Added in ref to Task#85 respective to JH72
        Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
        public UserPreferences()
        {
            try
            {
                base.Initialize();
                //Uncomment the following line if using designed components 
                //InitializeComponent(); 
                if (Session["UserContext"] == null)
                {
                    throw new Exception("Session Expired");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:To get the HTML of ScriptHistory on Sorting option
        /// </summary>
        /// <param name="AscDesc"></param>
        /// <param name="FieldName"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public String SortGridViewUserManagement(string FieldName, string condition)
        {
            DataView DataViewUserManagement = null;
            DataSet DataSetUserManagement = new DataSet();
            System.Web.UI.Pair _pairResult = new Pair();
            string _active = string.Empty;
            string _prescriber = string.Empty;
            StringBuilder GridViewUserManagementHTML = new StringBuilder();
            try
            {



                if (Session["DataViewUserManagement"] != null)
                {
                    DataViewUserManagement = new DataView();
                    DataViewUserManagement = (DataView)Session["DataViewUserManagement"];
                    if (condition == "All")
                        DataViewUserManagement.RowFilter = "ISNULL(RecordDeleted,'N')<>'Y'";
                    else if (condition == "Active")
                        DataViewUserManagement.RowFilter = "Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'";

                    //DataViewUserManagement.Sort = FieldName + " " + AscDesc;

                    GridViewUserManagementHTML.Append("<div id='DivUserManagement' style='width: 100%;overflow-y :scroll; overflow-x: hidden; height:485px' >");
                    GridViewUserManagementHTML.Append("<div style='width: 100%;'>");

                    GridViewUserManagementHTML.Append("<table cellspacing='0' border='0' id='Control_ASP.usercontrols_usermanagement_ascx_DataGridUsers' style='width:100%;border-collapse:collapse;'>");
                    GridViewUserManagementHTML.Append("<tr class='GridViewHeaderText' align='left' style='position:static; color:Black;background-color:#DEE7EF;font-family:Sans-Serif;font-weight:bold;text-decoration:none;height:20px;'>");
                    //GridViewUserManagementHTML.Append("<td align='left' scope='col'></td>");


                    GridViewUserManagementHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridUserManagement('StaffName','" + condition + "')>Staff Name</a></td>");
                    GridViewUserManagementHTML.Append("<td align='left' scope='col'></td>");
                    GridViewUserManagementHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridUserManagement('UserCode','" + condition + "')>User Name</a></td>");
                    GridViewUserManagementHTML.Append("<td  align='left' scope='col'></td>");
                    GridViewUserManagementHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridUserManagement('Active','" + condition + "')>Active</a></td>");
                    GridViewUserManagementHTML.Append("<td align='left' scope='col'></td>");
                    GridViewUserManagementHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridUserManagement('Prescriber','" + condition + "')>Prescriber</a></td>");

                    GridViewUserManagementHTML.Append("<td align='left' scope='col'></td>");
                    GridViewUserManagementHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridUserManagement('PhoneNumber','" + condition + "')>Phone Number</a></td>");

                    GridViewUserManagementHTML.Append("</tr>");
                    if (DataViewUserManagement.Table.Rows.Count > 0)
                    {

                        //for (int RowIndex = 0; RowIndex < DataViewUserManagement.Table.Rows.Count; RowIndex++)
                        for (int RowIndex = 0; RowIndex < DataViewUserManagement.Count; RowIndex++)
                        {
                            if (DataViewUserManagement[RowIndex]["Active"].ToString() == "Y")
                            {
                                _active = "Yes";
                            }
                            else if (DataViewUserManagement[RowIndex]["Active"].ToString() == "N")
                            {
                                _active = "No";
                            }
                            if (DataViewUserManagement[RowIndex]["Prescriber"].ToString() == "Y")
                            {
                                _prescriber = "Yes";
                            }
                            else if (DataViewUserManagement[RowIndex]["Prescriber"].ToString() == "N")
                            {
                                _prescriber = "No";
                            }
                            GridViewUserManagementHTML.Append("<tr class='GridViewRowStyle'>");
                            //GridViewUserManagementHTML.Append("<td align='left' scope='col'></td>");
                            GridViewUserManagementHTML.Append("<td align='left' valign='middle' style='width:15%;'>");
                            GridViewUserManagementHTML.Append("<a style='cursor:hand;text-decoration:underline' align='left' scope='col' href=javascript:OpenUserPreferences(" + DataViewUserManagement[RowIndex]["StaffId"] + ")>" + DataViewUserManagement[RowIndex]["StaffName"] + "</a>");
                            GridViewUserManagementHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewUserManagementHTML.Append(" <span id='Control_ASP.usercontrols_usermanagement_ascx_DataGridUsers_ctl02_LabelUserName'>" + DataViewUserManagement[RowIndex]["UserCode"] + " </span>");
                            GridViewUserManagementHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewUserManagementHTML.Append(" <span id='Control_ASP.usercontrols_usermanagement_ascx_DataGridUsers_ctl02_LabelActive'>" + _active + " </span>");
                            GridViewUserManagementHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewUserManagementHTML.Append(" <span id='Control_ASP.usercontrols_usermanagement_ascx_DataGridUsers_ctl02_LabelPrescriber'>" + _prescriber + " </span>");
                            GridViewUserManagementHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewUserManagementHTML.Append(" <span id='Control_ASP.usercontrols_usermanagement_ascx_DataGridUsers_ctl02_LabelPhone'>" + DataViewUserManagement[RowIndex]["PhoneNumber"] + " </span>");
                            GridViewUserManagementHTML.Append("</td>");
                            GridViewUserManagementHTML.Append("</tr>");

                        }
                    }
                    else
                    {
                        GridViewUserManagementHTML.Append("<tr class='GridViewRowStyle'>");
                        GridViewUserManagementHTML.Append("<td colspan='4' align='center'>");
                        GridViewUserManagementHTML.Append("No Records Found");
                        GridViewUserManagementHTML.Append("</td></tr>");

                    }

                    GridViewUserManagementHTML.Append("</table></div></div>");

                }
                return GridViewUserManagementHTML.ToString();

            }
            catch (Exception ex)
            {
                return GridViewUserManagementHTML.ToString();
            }
        }

        [WebMethod(EnableSession = true)]
        public void OpenUserPreferencesWithStaffId(Int32 StaffId)
        {
            try
            {
                Session["StaffIdForPreferences"] = StaffId;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public void SetStaffIdForUserPreferenceIdToNull()
        {
            try
            {
                Session["StaffIdForPreferences"] = null;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public DataTable FillDegree()
        {
            try
            {
                DataSet DataSetDegree = new DataSet();
                DataView DataViewDegree = null;
                DataSetDegree = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowDegree = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='DEGREE' And ISNULL(RecordDeleted,'N')='N'");
                DataSetDegree.Merge(DataRowDegree);
                DataSetDegree.Tables[0].TableName = "GlobalCodes";
                return DataSetDegree.Tables[0];
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        /// <summary>
        /// <Description>Used to fill data into each Row in table </Description>
        /// <Author>Mohit</Author>
        /// <CreatedOn>Nov 21,2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        private TableRow GenerateHealthDataSubRow(DataRow dataRowTitarationTemplate, string tableId, ref string myscript)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                // string tblId = this.ClientID + this.ClientIDSeparator + tableId;
                int titrationTemplateId = Convert.ToInt32(dataRowTitarationTemplate["TitrationTemplateId"]);
                TableRow tableRow = new TableRow();
                tableRow.ID = "Tr_" + newId;
                //----Start For Delete Icon---
                TableCell tdDelete = new TableCell();
                HtmlImage imgDelete = new HtmlImage();
                imgDelete.ID = "Img_" + titrationTemplateId.ToString();
                imgDelete.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
                imgDelete.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgDelete.Attributes.Add("class", "handStyle");
                tdDelete.Controls.Add(imgDelete);

                myscript += "var Imagecontext" + titrationTemplateId + ";";
                myscript += "var ImageclickCallback" + titrationTemplateId + " =";
                myscript += " Function.createCallback(DeleteRow , Imagecontext" + titrationTemplateId + ");";
                myscript += "$addHandler($get('" + imgDelete.ClientID + "'), 'click', ImageclickCallback" + titrationTemplateId + ");";
                //----End For Delete Icon---
                //----Start For Radio Button---
                TableCell tdRadioButton = new TableCell();
                HtmlInputRadioButton radioButtonTemp = new HtmlInputRadioButton();
                radioButtonTemp.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
                radioButtonTemp.ID = "Rb_" + titrationTemplateId.ToString();
                tdRadioButton.Controls.Add(radioButtonTemp);
                TableCell tdTemplateName = new TableCell();
                tdTemplateName.Text = dataRowTitarationTemplate["TemplateName"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["TemplateName"]);
                tdTemplateName.CssClass = "Label";
                TableCell tdCreatedBy = new TableCell();
                tdCreatedBy.Text = Convert.ToString(dataRowTitarationTemplate["CreatedBy"]);
                tdCreatedBy.CssClass = "Label";
                //--End For Other Columns value
                tableRow.Cells.Add(tdDelete);
                tableRow.Cells.Add(tdRadioButton);
                tableRow.Cells.Add(tdTemplateName);
                tableRow.Cells.Add(tdCreatedBy);

                return tableRow;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        #region "Get Formated Phone Number"
        /// <summary>
        /// Get Formated Phone Number
        /// </summary>
        /// <param name="pPhoneNumber"></param>
        /// <returns>string</returns>
        [WebMethod(EnableSession = true)]
        public string getFormatedPhoneNumber(string pPhoneNumber)
        {
            string PhoneNumber = "";
            string exp = null;
            double dblPhoneNumber;

            if (pPhoneNumber == null)
            {
                return PhoneNumber;
            }

            if (pPhoneNumber.ToString().Trim() == "")
            {
                return PhoneNumber;
            }

            try
            {
                dblPhoneNumber = Convert.ToDouble(pPhoneNumber);
            }
            catch (Exception ex)
            {
                exp = ex.Message.ToString();
                return PhoneNumber;
            }

            if (Convert.ToInt16(pPhoneNumber.Length) <= Convert.ToInt16(15))
            {
                if (dblPhoneNumber.ToString().Length > 10)
                {
                    PhoneNumber = String.Format("{0:(###) ###-####}", Convert.ToDouble((dblPhoneNumber.ToString().Substring(0, 10))));
                    PhoneNumber += " " + dblPhoneNumber.ToString().Substring(10, dblPhoneNumber.ToString().Length - 10).ToString();
                }
                else
                    PhoneNumber = String.Format("{0:(###) ###-####}", dblPhoneNumber);
            }
            //PhoneNumber=String.Format("{0:(###) ###-####}",dblPhoneNumber );
            //arv
            return PhoneNumber;
        }
        #endregion

        #region "Get Unformated Phone Number"
        /// <summary>
        /// Get Unformated Phone Number"
        /// </summary>
        /// <param name="pPhoneNumber"></param>
        /// <returns>string</returns>
        [WebMethod(EnableSession = true)]
        public string getUnformatedPhoneNumber(string pPhoneNumber)
        {
            try
            {
                string PhoneNumber = "";
                if (pPhoneNumber == null)
                {
                    return PhoneNumber;
                }
                if (pPhoneNumber.Trim() == "")
                {
                    return PhoneNumber;
                }
                char cOldLeft = '(';
                char cOldRight = ')';
                char cOldMinus = '-';

                char cNew = ' ';
                PhoneNumber = pPhoneNumber.Replace(cOldLeft, cNew);
                PhoneNumber = PhoneNumber.Replace(cOldRight, cNew);
                PhoneNumber = PhoneNumber.Replace(cOldMinus, cNew);

                PhoneNumber = RemoveSpacesFromString(PhoneNumber);

                return PhoneNumber;
            }
            catch (Exception ex)
            {
                // Exception Hadling
                throw (ex);
                return "";
            }
        }
        #endregion

        #region "Remove spaces from string"
        /// <summary>
        /// Remove Spaces from the string
        /// </summary>
        /// <param name="pPhoneNumber"></param>
        /// <returns>string</returns>
        [WebMethod(EnableSession = true)]
        public string RemoveSpacesFromString(string pPhoneNumber)
        {
            pPhoneNumber = pPhoneNumber.Replace(" ", "");
            return pPhoneNumber;
        }
        #endregion

        #region FillPanelonClickofRadioButton
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selectedPharmacyId"></param>
        /// <returns></returns>
        /// ---------------Modification History-----------------------
        /// -----Date------Author--------Purpose-------------------------
        /// 17 March 2011  Pradeep       Made changes as per task#3346
        [WebMethod(EnableSession = true)]
        public DataRow RadioButtonClick(int selectedPharmacyId)
        {
            DataTable _DataTablePharmacies = null;
            Streamline.UserBusinessServices.DataSets.DataSetPharmacies _dsPharmacies = null;
            DataSet dsTempEditAllowedStatus = null;
            ClientMedication objectClientMedications = new ClientMedication();
            try
            {
                Session["PharmacyId"] = selectedPharmacyId;
                return objectClientMedications.GetPharmacyById(selectedPharmacyId);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion


        #region DeletePharmacy
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selectedPharmacyId"></param>
        /// ----------Modification History----------------
        /// ------Date-----Author-------Purpose-----------------
        /// 17 March 2011  Pradeep      Made changes as per task#3346
        [WebMethod(EnableSession = true)]
        public DataSet DeletePharmacy(int selectedPharmacyId)
        {
            DataTable _DataTablePharmacies = null;
            Streamline.UserBusinessServices.DataSets.DataSetPharmacies _dsPharmacies = null;
            ClientMedication objectClientMedications = new ClientMedication();
            DataSet dsTempEditAllowedStaus = null;
            bool IsDeleteAllow = false;
            try
            {
                #region--Code Added By Pradeep as per task#3346----
                dsTempEditAllowedStaus = objectClientMedications.GetPharmacyEditAllowedStaus(selectedPharmacyId);
                if (dsTempEditAllowedStaus != null)
                {
                    if (dsTempEditAllowedStaus.Tables.Count > 0)
                    {
                        if (dsTempEditAllowedStaus.Tables["PharmacyEditAllowedStatus"].Rows[0]["PharmacyEditAllowed"].ToString().ToUpper() == "Y")
                        {
                            IsDeleteAllow = true;
                        }
                        else
                        {
                            IsDeleteAllow = false;
                        }
                    }
                }
                #endregion
                if (IsDeleteAllow)//This if condition is imposed by Pradeep as per task#3346
                {
                    _dsPharmacies = new Streamline.UserBusinessServices.DataSets.DataSetPharmacies();
                    _dsPharmacies.Merge(objectClientMedications.GetPharmaciesData());
                    _DataTablePharmacies = _dsPharmacies.Tables[0];

                    DataRow[] drPharmacies = _DataTablePharmacies.Select("PharmacyId=" + selectedPharmacyId + "");
                    drPharmacies[0]["RecordDeleted"] = "Y";
                    drPharmacies[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                    drPharmacies[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataSet dsTemp = new DataSet("Pharmacies");
                    Session["PharmacyId"] = selectedPharmacyId;
                    dsTemp.Merge(drPharmacies);
                    objectClientMedications.UpdateDocuments(dsTemp);
                    Session["PharmacyId"] = null;
                }
                return dsTempEditAllowedStaus;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                // _DataTablePharmacies.Dispose();
            }
        }
        #endregion

        #region DeletePrinter
        [WebMethod(EnableSession = true)]
        public void DeletePrinter(int selectedPrinterDeviceLocationId)
        {
            DataTable _DataTablePrinter = null;
            Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations _dsPrinterDeviceLocations = null;
            ClientMedication objectClientMedications = new ClientMedication();
            try
            {
                _dsPrinterDeviceLocations = new Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations();
                _dsPrinterDeviceLocations.Merge(objectClientMedications.GetPrinterData());
                _DataTablePrinter = _dsPrinterDeviceLocations.Tables[0];

                DataRow[] drPrinter = _DataTablePrinter.Select("PrinterDeviceLocationId=" + selectedPrinterDeviceLocationId + "");
                drPrinter[0]["RecordDeleted"] = "Y";
                drPrinter[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                drPrinter[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                DataSet dsTemp = new DataSet("PrinterDeviceLocations");
                Session["PrinterDeviceLocationId"] = selectedPrinterDeviceLocationId;
                dsTemp.Merge(drPrinter);
                objectClientMedications.UpdateDocuments(dsTemp);
                Session["PrinterDeviceLocationId"] = null;
            }
            catch (Exception ex)
            {
            }
            finally
            {
                _DataTablePrinter.Dispose();
            }
        }
        #endregion

        #region FillPanelonClickofRadioButton
        [WebMethod(EnableSession = true)]
        public DataSet RadioButtonClickForPrinter(int selectedPrinterDeviceLocationId)
        {
            DataTable _DataTablePrinter = null;
            Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations _dsPrinterDeviceLocations = null;
            ClientMedication objectClientMedications = new ClientMedication();
            try
            {
                _dsPrinterDeviceLocations = new Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations();
                _dsPrinterDeviceLocations.Merge(objectClientMedications.GetPrinterData());
                _DataTablePrinter = _dsPrinterDeviceLocations.Tables[0];

                DataRow[] drPrinter = _DataTablePrinter.Select("IsNull(RecordDeleted,'N')<>'Y' And PrinterDeviceLocationId=" + selectedPrinterDeviceLocationId + "");

                DataSet dsTemp = new DataSet("PrinterDeviceLocation");
                Session["PrinterDeviceLocationId"] = selectedPrinterDeviceLocationId;
                dsTemp.Merge(drPrinter);
                return dsTemp;
            }
            catch (Exception ex)
            {

                return null;
            }
            finally
            {
                _DataTablePrinter.Dispose();
            }
        }
        #endregion

        #region DeletePermission
        [WebMethod(EnableSession = true)]
        public void DeletePermission(int staffPermissionId)
        {
            DataSet dtst = null;
            DataSet DataSetPermissions = null;
            string actions = string.Empty;
            try
            {
                dtst = (DataSet)(Session["DataSetPermissionsList"]);
                for (int i = 0; i < dtst.Tables[1].Rows.Count; i++)
                {
                    if (Convert.ToInt32(dtst.Tables[1].Rows[i]["StaffPermissionId"]) == staffPermissionId && dtst.Tables[1].Rows[i]["NewlyAddedColumn"].ToString() == "Y")
                    {
                        Session["DeleteStaffPermissionId"] = dtst.Tables[1].Rows[i]["StaffPermissionId"];
                        if (actions == string.Empty)
                        {
                            actions = dtst.Tables[1].Rows[i]["ActionId"].ToString();
                        }
                        else
                        {
                            actions = actions + "," + dtst.Tables[1].Rows[i]["ActionId"].ToString();
                        }
                        dtst.Tables[1].Rows[i].Delete();

                    }
                    else if (Convert.ToInt32(dtst.Tables[1].Rows[i]["StaffPermissionId"]) == staffPermissionId && dtst.Tables[1].Rows[i]["NewlyAddedColumn"].ToString() != "Y")
                    {
                        Session["DeleteStaffPermissionId"] = dtst.Tables[1].Rows[i]["StaffPermissionId"];
                        dtst.Tables[1].Rows[i]["RecordDeleted"] = "Y";
                        dtst.Tables[1].Rows[i]["DeletedDate"] = DateTime.Now;
                        dtst.Tables[1].Rows[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        if (actions == string.Empty)
                        {
                            actions = dtst.Tables[1].Rows[i]["ActionId"].ToString();
                        }
                        else
                        {
                            actions = actions + "," + dtst.Tables[1].Rows[i]["ActionId"].ToString();
                        }
                    }
                }
                if (Session["Permissions"] != null)
                {
                    string[] ActionId;
                    string[] staffActions;
                    if (Session["Permissions"].ToString().Length > 0)
                    {
                        ActionId = Session["Permissions"].ToString().Split(',');
                        Session["Permissions"] = string.Empty;
                        staffActions = actions.Split(',');
                        for (int i = 0; i < ActionId.Length; i++)
                        {
                            for (int j = 0; j < staffActions.Length; j++)
                            {
                                if (ActionId[i] != staffActions[j])
                                {
                                    if (Session["Permissions"].ToString() == "")
                                    {
                                        Session["Permissions"] = ActionId[i];
                                    }
                                    else if (Session["Permissions"].ToString() != "")
                                    {
                                        Session["Permissions"] = Session["Permissions"].ToString() + "," + ActionId[i];
                                    }
                                }
                            }

                        }
                    }
                }
                Session["DataSetPermissionsList"] = dtst;

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        #endregion

        //Modified For Ref:Task no:85
        #region SavePharmacyRow
        [WebMethod(EnableSession = true)]
        public DataSet SavePharmacyRow(string PharmacyName, string Phone, string Fax, string Email, string Address, string State, string City, string ZipCode, string SureScriptsIdentifier, char Active, char Preferred, string Specialty)
        {
            objectClientMedications = new ClientMedication();
            DataSet pharmacyValidationStaus = null;
            bool AllowInsertUpdate = false;
            try
            {
                Int32 _pharmacyid = Session["PharmacyId"] != null ? Convert.ToInt32(Session["PharmacyId"]) : -1;
                pharmacyValidationStaus = objectClientMedications.GetPharmacyValidationStatus(PharmacyName, Active, Preferred, Phone, Fax, Email, Address, City, State, ZipCode, SureScriptsIdentifier, _pharmacyid);
                if (pharmacyValidationStaus != null)
                {
                    if (pharmacyValidationStaus.Tables["PharmacyValidateStatus"].Rows.Count > 0)
                    {
                        if (pharmacyValidationStaus.Tables["PharmacyValidateStatus"].Rows[0]["PharmacyIsValid"].ToString().Trim().ToUpper() == "Y")
                        {
                            AllowInsertUpdate = true;
                        }
                        else
                        {
                            AllowInsertUpdate = false;
                        }
                    }
                }

                _dsPharmacies = new Streamline.UserBusinessServices.DataSets.DataSetPharmacies();
                if (AllowInsertUpdate)
                {
                    _dsPharmacies.EnforceConstraints = false;
                    if (_pharmacyid > 0)
                    {
                        _dsPharmacies.Tables[0].ImportRow(objectClientMedications.GetPharmacyById(_pharmacyid));
                    }
                    else
                    {
                        _dsPharmacies.Tables[0].Rows.Add(_dsPharmacies.Tables[0].NewRow());
                    }

                    if (_pharmacyid < 0 || SureScriptsIdentifier.Trim() == "")
                    {
                        _dsPharmacies.Tables[0].Rows[0]["PharmacyName"] = PharmacyName;
                            if (Phone != "")
                            _dsPharmacies.Tables[0].Rows[0]["PhoneNumber"] = Phone;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["PhoneNumber"] = System.DBNull.Value;
                            if (Fax != "")
                            _dsPharmacies.Tables[0].Rows[0]["FaxNumber"] = Fax;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["FaxNumber"] = System.DBNull.Value;
                            if (Email != "")
                            _dsPharmacies.Tables[0].Rows[0]["Email"] = Email;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["Email"] = System.DBNull.Value;
                            if (Address != "")
                            _dsPharmacies.Tables[0].Rows[0]["Address"] = Address;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["Address"] = System.DBNull.Value;
                            if (State != "")
                            _dsPharmacies.Tables[0].Rows[0]["State"] = State;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["State"] = System.DBNull.Value;
                            if (City != "")
                            _dsPharmacies.Tables[0].Rows[0]["City"] = City;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["City"] = System.DBNull.Value;
                            if (ZipCode != "")
                            _dsPharmacies.Tables[0].Rows[0]["ZipCode"] = ZipCode;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["ZipCode"] = System.DBNull.Value;
                            if (SureScriptsIdentifier.Trim() == "")
                            _dsPharmacies.Tables[0].Rows[0]["SureScriptsPharmacyIdentifier"] = System.DBNull.Value;
                            else
                            _dsPharmacies.Tables[0].Rows[0]["SureScriptsPharmacyIdentifier"] = SureScriptsIdentifier;

                        _dsPharmacies.Tables[0].Rows[0]["Active"] = Active;
                        _dsPharmacies.Tables[0].Rows[0]["Specialty"] = Specialty;
                    }
                    if (_pharmacyid < 0)
                    {
                        _dsPharmacies.Tables[0].Rows[0]["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _dsPharmacies.Tables[0].Rows[0]["CreatedDate"] = DateTime.Now;
                        _dsPharmacies.Tables[0].Rows[0]["RowIdentifier"] = Guid.NewGuid();
                    }

                    _dsPharmacies.Tables[0].Rows[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dsPharmacies.Tables[0].Rows[0]["ModifiedDate"] = DateTime.Now;
                    _dsPharmacies.Tables[0].Rows[0]["PreferredPharmacy"] = Preferred;
                    _dsPharmacies.EnforceConstraints = true;

                            objectClientMedications.UpdateDocuments(_dsPharmacies);

                    Session["PharmacyId"] = null;
                }
                    
                return pharmacyValidationStaus;
            }
            catch (Exception ex)
            {
                throw (ex);

            }
        }
        #endregion

        #region SavePrinterRow
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Location"></param>
        /// <param name="Active"></param>
        /// <param name="Path"></param>
        /// <param name="DeviceLabel"></param>
        /// ------Modification History----------
        /// Date         Author      Purpose
        /// 23 Dec 2009  Pradeep     Made changes as per task#2709(Medication Management)
        [WebMethod(EnableSession = true)]
        public void SavePrinterRow(string Location, char Active, string Path, string DeviceLabel)
        {
            DataSet DataSetPrinter = null;
            objectClientMedications = new ClientMedication();
            DataRow _dataRow = null;
            DataSet dsTemp = null;
            try
            {
                DataSetPrinter = new DataSet();
                _dsPrinter = new Streamline.UserBusinessServices.DataSets.DataSetPrinterDeviceLocations();
                _dsPrinter.Merge(objectClientMedications.GetPrinterData());
                DataRow[] _dataRowPrinter = null;
                if (Session["PrinterDeviceLocationId"] != null)
                {
                    _dataRowPrinter = _dsPrinter.Tables[0].Select("PrinterDeviceLocationId=" + Convert.ToInt32(Session["PrinterDeviceLocationId"]));
                    _dataRowPrinter[0]["LocationId"] = Convert.ToInt32(Location);
                    _dataRowPrinter[0]["Active"] = Active;
                    if (Path != string.Empty)
                    {
                        _dataRowPrinter[0]["DeviceUNCPath"] = Path;
                    }
                    else
                    {
                        _dataRowPrinter[0]["DeviceUNCPath"] = DBNull.Value;
                    }
                    if (DeviceLabel != string.Empty)
                    {
                        _dataRowPrinter[0]["DeviceLabel"] = DeviceLabel;
                    }
                    else
                    {
                        _dataRowPrinter[0]["DeviceLabel"] = DBNull.Value;
                    }

                    _dataRowPrinter[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowPrinter[0]["ModifiedDate"] = DateTime.Now;
                    objectClientMedications.UpdateDocuments(_dsPrinter);
                    Session["PrinterDeviceLocationId"] = null;
                }
                else
                {
                    _dataRow = _dsPrinter.Tables[0].NewRow();
                    _dataRow["LocationId"] = Location;
                    _dataRow["Active"] = Active;
                    if (Path != string.Empty)
                    {
                        _dataRow["DeviceUNCPath"] = Path;
                    }
                    else
                    {
                        _dataRow["DeviceUNCPath"] = DBNull.Value;
                    }
                    if (DeviceLabel != string.Empty)
                    {
                        _dataRow["DeviceLabel"] = DeviceLabel;
                    }
                    else
                    {
                        _dataRow["DeviceLabel"] = DBNull.Value;
                    }


                    _dataRow["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRow["CreatedDate"] = DateTime.Now;
                    _dataRow["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRow["ModifiedDate"] = DateTime.Now;
                    _dataRow["RowIdentifier"] = System.Guid.NewGuid();
                    _dsPrinter.Tables[0].Rows.Add(_dataRow);
                    objectClientMedications.UpdateDocuments(_dsPrinter);
                }
                //_dataRow = _dsPharmacies.Tables["Pharmacies"].Select("Active = 'Y' And IsNull(RecordDeleted,'N')<>'Y'", "PharmacyName asc");
                //DataSetPrinter.Merge(_dataRow);
                //17-Aug-2009
                // PharmaciesList1.SortString = "Asc";
                //PharmaciesList1.GenerateRows(DataSetPrinter.Tables["Pharmacies"]);

                //Incase of New User Maximum value is generated  for PharmacyId.
                if (Session["PrinterDeviceLocationId"] == null)
                {
                    objectClientMedications = new ClientMedication();
                    // dsTemp = objectClientMedications.GetPrinterData();
                    //Session["PrinterDeviceLocationId"] = dsTemp.Tables[0].Compute("Max(PrinterDeviceLocationId)", "");
                }
            }
            catch (Exception ex)
            {


            }
            finally
            {
                dsTemp = null;
                _dataRow = null;
            }
        }
        #endregion

        #region "ClearPharmacy"
        [WebMethod(EnableSession = true)]
        public void ClearPharmacy()
        {
            try
            {
                Session["PharmacyId"] = null;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }
        #endregion

        #region "ClearPrinter"
        [WebMethod(EnableSession = true)]
        public void ClearPrinter()
        {
            try
            {
                Session["PrinterDeviceLocationId"] = null;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }
        #endregion
        //Ref to Task#2595
        #region "FillDistinctQuestions"
        /// <summary>
        /// FillDistinctQuestions
        /// </summary>

        [WebMethod(EnableSession = true)]
        public DataTable FillDistinctQuestions(string HiddenSecurityQuestions)
        {

            try
            {
                DataSet DataSetGlobalCodes = null;
                DataSetGlobalCodes = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowGlobalCodes = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='SECURITYQUESTION' And ISNULL(RecordDeleted,'N')='N' And GlobalCodeId Not IN (" + HiddenSecurityQuestions + ")");
                DataSetGlobalCodes.Merge(DataRowGlobalCodes);
                DataSetGlobalCodes.Tables[0].TableName = "SECURITYQUESTIONS";
                return DataSetGlobalCodes.Tables["SECURITYQUESTIONS"];
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion


        #region "SaveSecurityQuestions"
        /// <summary>
        /// SaveSecurityQuestions
        /// </summary>
        [Serializable]
        public class SecurityQuestionsRow
        {
            private Int32 _Question;
            public Int32 Question
            {
                get { return _Question; }
                set { _Question = value; }
            }
            private string _Answer;
            public string Answer
            {
                get { return _Answer; }
                set { _Answer = value; }
            }
            private Int32 _StaffSecurityQuestionId;
            public Int32 StaffSecurityQuestionId
            {
                get { return _StaffSecurityQuestionId; }
                set { _StaffSecurityQuestionId = value; }
            }
        }
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(SecurityQuestionsRow))]
        public void SaveSecurityQuestions(SecurityQuestionsRow[] objSecurityQuestions)
        {
            objUserPreferences = new UserPrefernces();
            objectClientMedications = new ClientMedication();
            DataSet dsStaffSecurityQuestions = new DataSet();
            try
            {
                CommonFunctions.Event_Trap(this);
                DataSet dsUserPrefernces = new DataSet();

                dsUserPrefernces = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                //throw new Exception(Session["StaffIdForPreferences"].ToString());
                dsStaffSecurityQuestions.Merge(dsUserPrefernces.Tables[2]);
                dsStaffSecurityQuestions.Tables[0].TableName = "StaffSecurityQuestions";
                //Add New Row
                for (short index = 0; index < objSecurityQuestions.Length; index++)
                {
                    if (objSecurityQuestions[index].StaffSecurityQuestionId <= 0)
                    {
                        DataRow drStaffSecurityQuestions = dsStaffSecurityQuestions.Tables["StaffSecurityQuestions"].NewRow();
                        drStaffSecurityQuestions["StaffSecurityQuestionId"] = -(index + 1);
                        drStaffSecurityQuestions["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        // drStaffSecurityQuestions["StaffId"] = Convert.ToInt32(Session["StaffIdForPreferences"]);
                        drStaffSecurityQuestions["SecurityQuestion"] = objSecurityQuestions[index].Question;
                        drStaffSecurityQuestions["SecurityAnswer"] = objSecurityQuestions[index].Answer;
                        drStaffSecurityQuestions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drStaffSecurityQuestions["CreatedDate"] = DateTime.Now;
                        drStaffSecurityQuestions["RowIdentifier"] = System.Guid.NewGuid();
                        drStaffSecurityQuestions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drStaffSecurityQuestions["ModifiedDate"] = DateTime.Now;
                        dsStaffSecurityQuestions.Tables[0].Rows.Add(drStaffSecurityQuestions);
                    }
                    else
                    {
                        DataRow[] _drStaffSecurityQuestions = dsStaffSecurityQuestions.Tables["StaffSecurityQuestions"].Select("StaffSecurityQuestionId=" + Convert.ToInt32(objSecurityQuestions[index].StaffSecurityQuestionId) + "and StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                        _drStaffSecurityQuestions[0]["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;

                        // _drStaffSecurityQuestions[0]["StaffId"] = Convert.ToInt32(Session["StaffIdForPreferences"]);
                        _drStaffSecurityQuestions[0]["SecurityQuestion"] = objSecurityQuestions[index].Question;
                        _drStaffSecurityQuestions[0]["SecurityAnswer"] = objSecurityQuestions[index].Answer;
                        //_drStaffSecurityQuestions[0]["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        //_drStaffSecurityQuestions[0]["CreatedDate"] = DateTime.Now;
                        _drStaffSecurityQuestions[0]["RowIdentifier"] = System.Guid.NewGuid();
                        _drStaffSecurityQuestions[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drStaffSecurityQuestions[0]["ModifiedDate"] = DateTime.Now;
                    }
                }

                //objectClientMedications.UpdateDocuments(dsStaffSecurityQuestions);
                Session["StaffSecurityQuestions"] = dsStaffSecurityQuestions;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        #endregion

        #region "Unique UserName"
        /// <summary>
        /// 
        /// </summary>
        /// <param name="useCode"></param>
        /// <returns>string</returns>
        [WebMethod(EnableSession = true)]
        public string CheckUserNameExists(string useCode)
        {
            objUserPreferences = new UserPrefernces();
            int staffid = 0;
            try
            {
                //Code added to created use with unique username
                if (Session["StaffIdForPreferences"] == null)
                    staffid = 0;
                else
                    staffid = Convert.ToInt32(Session["StaffIdForPreferences"]);
                if (!objUserPreferences.CheckUserNameExists(staffid, useCode))
                {
                    return "User Name already exists";
                }
                return "";
                //Code ends ove here.
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion
        #region "ApprovePrescription"
        //Added by Chandan with ref task#2604
        [WebMethod(EnableSession = true)]
        public int ApprovePrescription(string RDLDateTime)
        {
            Streamline.UserBusinessServices.UserPrefernces objectUserPrefernces = null;
            try
            {
                int count = 0;
                objectUserPrefernces = new Streamline.UserBusinessServices.UserPrefernces();
                count = objectUserPrefernces.ApprovePrescription(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime, RDLDateTime);
                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime = RDLDateTime;
                return count;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        #endregion


        /// <summary>
        /// <Description>Used to generate HelthData template header rows as per task#34(Venture 10.0)</Description>
        /// <Author>Mohit</Author>
        /// <CreatedOn> 21 Nov 2009</CreatedOn>
        /// </summary>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair GenerateHealthDataRow(int healthDataCategoryId)
        {
            DataRow[] dataRow;
            DataSet dataSetHealthData = null;
            string _strTableHtml = "";
            try
            {
                CommonFunctions.Event_Trap(this);
                //PanelTitrationTraperList.Controls.Clear();
                Table tableHealthDataList = new Table();
                tableHealthDataList.ID = System.Guid.NewGuid().ToString();
                tableHealthDataList.Width = new Unit(98, UnitType.Percentage);
                Pair pairResult = new Pair();

                if (Session["dataSetHealthData"] != null)
                {
                    dataSetHealthData = (DataSet)Session["dataSetHealthData"];

                }

                dataRow = dataSetHealthData.Tables[0].Select("HealthDataCategoryId=" + healthDataCategoryId);



                if (dataRow.Length > 0)
                {
                    // this.LabelDrugName.Text = dataRow[0]["MedicationName"].ToString();
                    foreach (DataRow dataRowHealthDataCategory in dataRow)
                    {
                        for (int loopCounter = 0; loopCounter < 6; loopCounter++)
                        {
                            tableHealthDataList.Rows.Add(this.GenerateHealthDataSubRow(dataRowHealthDataCategory, tableHealthDataList.ClientID, loopCounter));
                        }

                    }
                }

                StringBuilder sb = new StringBuilder();
                using (StringWriter sw = new StringWriter(sb))
                {
                    using (HtmlTextWriter textWriter = new HtmlTextWriter(sw))
                    {
                        tableHealthDataList.RenderControl(textWriter);
                    }
                }
                _strTableHtml = sb.ToString();
                //pairResult.First = _strTableHtml = _strTableHtml.Substring(66, _strTableHtml.Length - 76);
                pairResult.First = _strTableHtml;
                return pairResult;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// <Description>Used to fill data into each Row in table </Description>
        /// <Author>Mohit</Author>
        /// <CreatedOn>Nov 21,2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        private TableRow GenerateHealthDataSubRow(DataRow dataRowHealthDataCategory, string tableId, int rowIndex)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                // string tblId = this.ClientID + this.ClientIDSeparator + tableId;               

                TableRow tableRow = new TableRow();
                tableRow.ID = "Tr_" + newId;

                string rowId = System.Guid.NewGuid().ToString();

                TableCell tdItemName = new TableCell();
                tdItemName.CssClass = "labelFont";
                string itemName = "";
                switch (rowIndex)
                {
                    case 0:
                        itemName = dataRowHealthDataCategory["ItemName1"].ToString();
                        break;
                    case 1:
                        itemName = dataRowHealthDataCategory["ItemName2"].ToString();
                        break;
                    case 2:
                        itemName = dataRowHealthDataCategory["ItemName3"].ToString();
                        break;
                    case 3:
                        itemName = dataRowHealthDataCategory["ItemName4"].ToString();
                        break;
                    case 4:
                        itemName = dataRowHealthDataCategory["ItemName5"].ToString();
                        break;
                    case 6:
                        itemName = dataRowHealthDataCategory["ItemName6"].ToString();
                        break;
                }
                tdItemName.Text = itemName;

                TableCell tdEmptyCell = new TableCell();
                tdEmptyCell.Width = new Unit(35, UnitType.Percentage);

                TableCell tdItemValue = new TableCell();
                TextBox TextBoxItemValue = new TextBox();
                TextBoxItemValue.ID = "TextBoxItemValue" + rowIndex;
                TextBoxItemValue.Width = new Unit(50, UnitType.Pixel);
                tdItemValue.Controls.Add(TextBoxItemValue);
                tdItemValue.Width = new Unit(20, UnitType.Percentage);
                tdItemValue.Attributes.Add("align", "right");

                TableCell tdUnits = new TableCell();
                string itemUnits = "";
                switch (rowIndex)
                {
                    case 0:
                        itemUnits = dataRowHealthDataCategory["ItemUnit1"].ToString();
                        if (dataRowHealthDataCategory["itemFormula1"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                    case 1:
                        itemUnits = dataRowHealthDataCategory["ItemUnit2"].ToString();
                        if (dataRowHealthDataCategory["itemFormula2"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                    case 2:
                        itemUnits = dataRowHealthDataCategory["ItemUnit3"].ToString();
                        if (dataRowHealthDataCategory["itemFormula3"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                    case 3:
                        itemUnits = dataRowHealthDataCategory["ItemUnit4"].ToString();
                        if (dataRowHealthDataCategory["itemFormula4"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                    case 4:
                        itemUnits = dataRowHealthDataCategory["ItemUnit5"].ToString();
                        if (dataRowHealthDataCategory["itemFormula5"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                    case 5:
                        itemUnits = dataRowHealthDataCategory["ItemUnit6"].ToString();
                        if (dataRowHealthDataCategory["itemFormula6"] != System.DBNull.Value)
                        {
                            TextBoxItemValue.ReadOnly = true;
                            TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
                        }
                        break;
                }
                tdUnits.Text = itemUnits;
                tdUnits.CssClass = "Label";

                if (itemName != "")
                {
                    tableRow.Cells.Add(tdItemName);
                    tableRow.Cells.Add(tdEmptyCell);
                    tableRow.Cells.Add(tdItemValue);
                    tableRow.Cells.Add(tdUnits);
                }

                return tableRow;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        public class HealthDataRow
        {
            private string _itemValue1;
            public string ItemValue1
            {
                get { return _itemValue1; }
                set { _itemValue1 = value; }
            }
            private string _itemValue2;
            public string ItemValue2
            {
                get { return _itemValue2; }
                set { _itemValue2 = value; }
            }
            private string _itemValue3;
            public string ItemValue3
            {
                get { return _itemValue3; }
                set { _itemValue3 = value; }
            }
            private string _itemValue4;
            public string ItemValue4
            {
                get { return _itemValue4; }
                set { _itemValue4 = value; }
            }
            private string _itemValue5;
            public string ItemValue5
            {
                get { return _itemValue5; }
                set { _itemValue5 = value; }
            }
            private string _itemValue6;
            public string ItemValue6
            {
                get { return _itemValue6; }
                set { _itemValue6 = value; }
            }
            private string _itemValue7;
            public string ItemValue7
            {
                get { return _itemValue7; }
                set { _itemValue7 = value; }
            }
            private string _itemValue8;
            public string ItemValue8
            {
                get { return _itemValue8; }
                set { _itemValue8 = value; }
            }
            private string _itemValue9;
            public string ItemValue9
            {
                get { return _itemValue9; }
                set { _itemValue9 = value; }
            }
            private string _itemValue10;
            public string ItemValue10
            {
                get { return _itemValue10; }
                set { _itemValue10 = value; }
            }
            private string _itemValue11;
            public string ItemValue11
            {
                get { return _itemValue11; }
                set { _itemValue11 = value; }
            }
            private string _itemValue12;
            public string ItemValue12
            {
                get { return _itemValue12; }
                set { _itemValue12 = value; }
            }

            private string _itemChecked1;
            public string ItemChecked1
            {
                get { return _itemChecked1; }
                set { _itemChecked1 = value; }
            }
            private string _itemChecked2;
            public string ItemChecked2
            {
                get { return _itemChecked2; }
                set { _itemChecked2 = value; }
            }
            private string _itemChecked3;
            public string ItemChecked3
            {
                get { return _itemChecked3; }
                set { _itemChecked3 = value; }
            }
            private string _itemChecked4;
            public string ItemChecked4
            {
                get { return _itemChecked4; }
                set { _itemChecked4 = value; }
            }
            private string _itemChecked5;
            public string ItemChecked5
            {
                get { return _itemChecked5; }
                set { _itemChecked5 = value; }
            }
            private string _itemChecked6;
            public string ItemChecked6
            {
                get { return _itemChecked6; }
                set { _itemChecked6 = value; }
            }
            private string _itemChecked7;
            public string ItemChecked7
            {
                get { return _itemChecked7; }
                set { _itemChecked7 = value; }
            }
            private string _itemChecked8;
            public string ItemChecked8
            {
                get { return _itemChecked8; }
                set { _itemChecked8 = value; }
            }
            private string _itemChecked9;
            public string ItemChecked9
            {
                get { return _itemChecked9; }
                set { _itemChecked9 = value; }
            }
            private string _itemChecked10;
            public string ItemChecked10
            {
                get { return _itemChecked10; }
                set { _itemChecked10 = value; }
            }
            private string _itemChecked11;
            public string ItemChecked11
            {
                get { return _itemChecked11; }
                set { _itemChecked11 = value; }
            }
            private string _itemChecked12;
            public string ItemChecked12
            {
                get { return _itemChecked12; }
                set { _itemChecked12 = value; }
            }


            private DateTime _dateRecorded;
            public DateTime DateRecorded
            {
                get { return _dateRecorded; }
                set { _dateRecorded = value; }
            }
            private int _healthDataCategoryId;
            public int HealthDataCategoryId
            {
                get { return _healthDataCategoryId; }
                set { _healthDataCategoryId = value; }
            }
            private int _itemName;
            public int ItemName
            {
                get { return _itemName; }
                set { _itemName = value; }
            }
            private int _healthDataId;
            public int HealthDataId
            {
                get { return _healthDataId; }
                set { _healthDataId = value; }
            }
        }
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(HealthDataRow))]
        public string SaveHealthData(HealthDataRow[] objHealthDataRow)
        {
            string result = "";
            objectClientMedications = new ClientMedication();
            try
            {
                CommonFunctions.Event_Trap(this);
                if (objHealthDataRow[0].HealthDataId > 0)
                {
                    dataSetHealthData = new Streamline.UserBusinessServices.DataSets.DataSetHealthData();
                    dataSetHealthData.Merge((DataSet)Session["HealthDataList"]);
                    result = "update"; //"HealthDataUpdated";
                }
                else
                {
                    dataSetHealthData = new Streamline.UserBusinessServices.DataSets.DataSetHealthData();
                    result = "update"; //"HealthDataAdded";
                }
                DataRow dataRowHealthData = null;
                if (dataSetHealthData.Tables["HealthData"].Rows.Count == 0)
                    dataRowHealthData = dataSetHealthData.Tables["HealthData"].NewRow();
                else
                {
                    DataRow[] dtRowHealthData = dataSetHealthData.Tables["HealthData"].Select("HealthDataId=" + objHealthDataRow[0].HealthDataId);
                    dataRowHealthData = dtRowHealthData[0];
                }
                dataRowHealthData["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                dataRowHealthData["HealthDataCategoryId"] = objHealthDataRow[0].HealthDataCategoryId;
                dataRowHealthData["DateRecorded"] = objHealthDataRow[0].DateRecorded;
                var loopIt = 0;
                for (short loopCounter = 0; loopCounter < (objHealthDataRow.Length); loopCounter++)
                {
                    loopIt = loopCounter + 1;
                    HealthDataRow _row = objHealthDataRow[loopCounter];
                    var _itemValue = _row.GetType().GetProperty("ItemValue" + loopIt.ToString()).GetValue(_row, null);
                    if (_itemValue != null)
                    {
                        if (!String.IsNullOrEmpty(_itemValue.ToString()))
                            dataRowHealthData["ItemValue" + loopIt.ToString()] = _itemValue.ToString();
                        else
                            dataRowHealthData["ItemValue" + loopIt.ToString()] = DBNull.Value;
                    }
                    var _itemChecked = _row.GetType().GetProperty("ItemChecked" + loopIt.ToString()).GetValue(_row, null);
                    if (_itemChecked != null)
                    {
                        if (_itemChecked.ToString() == "True")
                            dataRowHealthData["ItemChecked" + loopIt.ToString()] = "Y";
                        else
                            dataRowHealthData["ItemChecked" + loopIt.ToString()] = "N";
                    }

                }



                dataRowHealthData["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                dataRowHealthData["CreatedDate"] = System.DateTime.Now;
                dataRowHealthData["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                dataRowHealthData["ModifiedDate"] = System.DateTime.Now;
                if (objHealthDataRow[0].HealthDataId == 0)
                {
                    dataSetHealthData.Tables["HealthData"].Rows.Add(dataRowHealthData);
                }
                objectClientMedications.UpdateDocuments(dataSetHealthData);
                return result;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #region--Code written by Pradeep as per task#23
        [WebMethod(EnableSession = true)]
        public void UpdatePrinterDeviceLocation(string locationId, string printerDeviceLocationId, string assigningAtatus)
        {
            DataSet DataSetStaffLocations = null;
            DataRow[] DataRowStaffLocations = null;
            DataRow DataRowNewStaffLocations = null;
            try
            {
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetStaffLocations = (DataSet)(Session["DataSetPermissionsList"]);
                    if (DataSetStaffLocations.Tables["StaffLocations"].Rows.Count > 0)
                    {
                        if (Session["StaffIdForPreferences"] != null)
                        {
                            DataRowStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                        }
                        //DataRowStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                        if (DataRowStaffLocations != null && DataRowStaffLocations.Length > 0)
                        {
                            if (assigningAtatus == "Assigned")
                            {
                                if (printerDeviceLocationId != string.Empty)
                                {
                                    DataRowStaffLocations[0]["PrescriptionPrinterLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                                }
                                else
                                {
                                    DataRowStaffLocations[0]["PrescriptionPrinterLocationId"] = DBNull.Value;
                                }
                            }

                        }
                        else
                        {
                            //Create New row
                            //DataRowNewStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].NewRow();
                            //DataRowNewStaffLocations["RowIdentifier"] = System.Guid.NewGuid();
                            ////DataRowNewStaffLocations["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            //DataRowNewStaffLocations["StaffId"] = Convert.ToInt32(Session["StaffIdForPreferences"]);
                            //DataRowNewStaffLocations["LocationId"] = Convert.ToInt32(locationId);
                            //if (printerDeviceLocationId != string.Empty)
                            //{
                            //    DataRowNewStaffLocations["PrinterDeviceLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                            //}
                            //else
                            //{
                            //    DataRowNewStaffLocations["PrinterDeviceLocationId"] = DBNull.Value;
                            //}

                            //DataRowNewStaffLocations["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            //DataRowNewStaffLocations["CreatedDate"] = System.DateTime.Now;
                            //DataRowNewStaffLocations["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            //DataRowNewStaffLocations["ModifiedDate"] = System.DateTime.Now;
                            //DataSetStaffLocations.Tables["StaffLocations"].Rows.Add(DataRowNewStaffLocations);
                        }
                    }
                    else
                    {
                        //Create New row
                        //DataRowNewStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].NewRow();
                        //DataRowNewStaffLocations["RowIdentifier"] = System.Guid.NewGuid();
                        ////DataRowNewStaffLocations["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        //DataRowNewStaffLocations["StaffId"] = Convert.ToInt32(Session["StaffIdForPreferences"]);
                        //DataRowNewStaffLocations["LocationId"] = Convert.ToInt32(locationId);
                        //if (printerDeviceLocationId != string.Empty)
                        //{
                        //    DataRowNewStaffLocations["PrinterDeviceLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                        //}
                        //else
                        //{
                        //    DataRowNewStaffLocations["PrinterDeviceLocationId"] = DBNull.Value;
                        //}
                        //DataRowNewStaffLocations["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        //DataRowNewStaffLocations["CreatedDate"] = System.DateTime.Now;
                        //DataRowNewStaffLocations["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        //DataRowNewStaffLocations["ModifiedDate"] = System.DateTime.Now;
                        //DataSetStaffLocations.Tables["StaffLocations"].Rows.Add(DataRowNewStaffLocations);
                    }
                }
                Session["DataSetPermissionsList"] = DataSetStaffLocations;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public void EditDefaultPrescribingLocation(string locationId, string checkBoxStatus)
        {
            DataSet DataSetStaff = null;
            DataRow[] dataRowStaff = null;
            try
            {
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetStaff = (DataSet)(Session["DataSetPermissionsList"]);
                    if (DataSetStaff.Tables["Staff"].Rows.Count > 0)
                    {
                        if (checkBoxStatus == "Default Checked")
                        {
                            DataSetStaff.Tables["Staff"].Rows[0]["DefaultPrescribingLocation"] = Convert.ToInt32(locationId);
                        }
                        else if (checkBoxStatus == "Default UnChecked")
                        {
                            DataSetStaff.Tables["Staff"].Rows[0]["DefaultPrescribingLocation"] = DBNull.Value;
                        }

                    }
                }
                Session["DataSetPermissionsList"] = DataSetStaff;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public void EditStaffLocations(string LocationId, string AssignCheckBoxStatus, string DefaultCheckBoxStatus, string printerDeviceLocation)
        {
            DataSet DataSetPermissionList = null;//
            DataRow[] DataRowStaffLocation = null;


            try
            {
                string locationId = LocationId;
                // int staffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                int staffId = Convert.ToInt32(Session["StaffIdForPreferences"]);
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetPermissionList = (DataSet)(Session["DataSetPermissionsList"]);

                    DataRowStaffLocation = DataSetPermissionList.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + staffId);

                    if (AssignCheckBoxStatus == "Assign Not Checked")
                    {
                        if (DataRowStaffLocation.Length > 0)
                        {
                            if (DataRowStaffLocation[0].RowState == DataRowState.Added)
                            {


                                DataRow[] _DataRowStaffLocation = DataSetPermissionList.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + staffId);
                                if (_DataRowStaffLocation != null)
                                {
                                    DataSetPermissionList.Tables["StaffLocations"].Rows.Remove(_DataRowStaffLocation[0]);


                                }

                            }
                            else
                            {
                                DataRowStaffLocation[0]["RecordDeleted"] = "Y";

                                DataRowStaffLocation[0]["DeletedDate"] = DateTime.Now;
                                DataRowStaffLocation[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowStaffLocation[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowStaffLocation[0]["ModifiedDate"] = DateTime.Now;
                            }
                        }
                        if (DefaultCheckBoxStatus == "Default Checked")
                        {
                            DataSetPermissionList.Tables["Staff"].Rows[0]["DefaultPrescribingLocation"] = DBNull.Value;
                            DataSetPermissionList.Tables["Staff"].Rows[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataSetPermissionList.Tables["Staff"].Rows[0]["ModifiedDate"] = System.DateTime.Now;
                        }
                    }
                    if (AssignCheckBoxStatus == "Assign Checked")
                    {
                        if (DataRowStaffLocation.Length > 0)
                        {
                            DataRowStaffLocation[0]["RecordDeleted"] = "N";
                            DataRowStaffLocation[0]["DeletedDate"] = DateTime.Now;
                            DataRowStaffLocation[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowStaffLocation[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowStaffLocation[0]["ModifiedDate"] = DateTime.Now;
                        }
                        else
                        {
                            DataRow dataRowStaffLocation = DataSetPermissionList.Tables["StaffLocations"].NewRow();
                            dataRowStaffLocation["RowIdentifier"] = System.Guid.NewGuid();
                            //dataRowStaffLocation["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            dataRowStaffLocation["StaffId"] = Convert.ToInt32(Session["StaffIdForPreferences"]);
                            dataRowStaffLocation["LocationId"] = Convert.ToInt32(LocationId);
                            dataRowStaffLocation["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            dataRowStaffLocation["CreatedDate"] = System.DateTime.Now;
                            dataRowStaffLocation["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            dataRowStaffLocation["ModifiedDate"] = System.DateTime.Now;
                            if (printerDeviceLocation != string.Empty)
                            {
                                dataRowStaffLocation["PrescriptionPrinterLocationId"] = Convert.ToInt32(printerDeviceLocation);
                            }
                            else
                            {
                                dataRowStaffLocation["PrescriptionPrinterLocationId"] = DBNull.Value;
                            }
                            DataSetPermissionList.Tables["StaffLocations"].Rows.Add(dataRowStaffLocation);
                        }
                    }
                }
                Session["DataSetPermissionsList"] = DataSetPermissionList;


            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion--Code written by Pradeep as per task#23

        /// <summary>
        /// <Description>Added by Loveena in ref to Task#86</Description>
        /// </summary>
        /// <param name="locationId"></param>
        /// <param name="printerDeviceLocationId"></param>        
        [WebMethod(EnableSession = true)]
        public void UpdateChartCopyPrinterDeviceLocation(string locationId, string chartCopyPrinterDeviceLocationId)
        {
            DataSet DataSetStaffLocations = null;
            DataRow[] DataRowStaffLocations = null;
            try
            {
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetStaffLocations = (DataSet)(Session["DataSetPermissionsList"]);
                    if (DataSetStaffLocations.Tables["StaffLocations"].Rows.Count > 0)
                    {
                        if (Session["StaffIdForPreferences"] != null)
                        {
                            DataRowStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                        }
                        //DataRowStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                        if (DataRowStaffLocations != null && DataRowStaffLocations.Length > 0)
                        {

                            if (chartCopyPrinterDeviceLocationId != string.Empty)
                            {
                                DataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"] = Convert.ToInt32(chartCopyPrinterDeviceLocationId);
                            }
                            else
                            {
                                DataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"] = DBNull.Value;
                            }

                        }

                    }
                }
                Session["DataSetPermissionsList"] = DataSetStaffLocations;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        /// <summary>
        /// <Description>Used to merge the pharmacy selected from Pharmacy Search page</Description>
        /// <Author>Sahil Bhagat</Author>
        /// <CreatedOn> 09 Feb. 2010</CreatedOn>
        /// Modified By Priya Ref:task no:85
        /// </summary>
        [WebMethod(EnableSession = true)]
        public void MergePharmacy(int PreferredPharmacyId, int SureScriptsPharmacyId)
        {
            ClientMedication _objectClientMedications = null;
            try
            {
                string UserCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                _objectClientMedications = new ClientMedication();
                _objectClientMedications.MergePharmacy(PreferredPharmacyId, SureScriptsPharmacyId, UserCode);
            }

            catch (Exception ex)
            {
                throw ex;
            }


        }
        [WebMethod(EnableSession = true)]
        public DataRow GetSureScriptsPrescriberId(int StaffId)
        {
            try
            {
                objUserPreferences = new UserPrefernces();
                DataSet dsSureScriptPrescriberId = objUserPreferences.GetSureScriptPrescriberId(StaffId);
                DataRow drSureScriptPrescriberId = null;
                if (dsSureScriptPrescriberId.Tables["SureScriptPresciberId"].Rows.Count > 0)
                {
                    drSureScriptPrescriberId = dsSureScriptPrescriberId.Tables["SureScriptPresciberId"].Rows[0];
                }
                return drSureScriptPrescriberId;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="StaffId"></param>
        /// <param name="SurescriptsOrganizationId"></param>
        /// <param name="OrganizationName"></param>
        /// <param name="ActiveStartTime"></param>
        /// <param name="ActiveEndTime"></param>
        /// <param name="DEANumber"></param>
        /// <param name="NPI"></param>
        /// <param name="LastName"></param>
        /// <param name="FirstName"></param>
        /// <param name="MiddleName"></param>
        /// <param name="NamePrefix"></param>
        /// <param name="SpecialtyCode"></param>
        /// <param name="City"></param>
        /// <param name="State"></param>
        /// <param name="Zip"></param>
        /// <param name="Address"></param>
        /// <param name="PhoneNumber"></param>
        /// <param name="FaxNumber"></param>
        /// <param name="Email"></param>
        /// <param name="SPI_Id"></param>
        /// <returns></returns>
        /// -----------Modification History------------------
        /// ----Date------Author---------Purpose--------------------
        /// 16 Feb 2011   Pradeep        Made changes as per task#3315
        [WebMethod(EnableSession = true)]
        public string[] GetPrescriberId(string StaffId, string SurescriptsOrganizationId, string OrganizationName, string ActiveStartTime, string ActiveEndTime, string DEANumber, string NPI, string LastName, string FirstName, string MiddleName, string NamePrefix, string SpecialtyCode, string City, string State, string Zip, string Address, string PhoneNumber, string FaxNumber, string Email, string SPI_Id)
        {
            try
            {
                if (SPI_Id == "000") SPI_Id = "";

                SureScriptsServices sureScriptsServices = new SureScriptsServices();
                string registerSureScriptsPrescriberUrl =
                    System.Configuration.ConfigurationSettings.AppSettings["RegisterSureScriptsPrescriberUrl"].ToString();
                PrescriberReturning prescriber = sureScriptsServices.RegisterPrescriberInformation(registerSureScriptsPrescriberUrl,
                                        StaffId, SurescriptsOrganizationId, OrganizationName,
                                        ActiveStartTime, ActiveEndTime, DEANumber, NPI,
                                        LastName, FirstName, MiddleName, NamePrefix,
                    // ServiceLevel is specialty code
                                        "", SpecialtyCode, City, State, Zip, Address, PhoneNumber,
                                        FaxNumber, Email, SPI_Id);


                string[] result = new string[2];
                if (prescriber.Valid)
                {
                    DataSet dsUserPrefernces = new DataSet();
                    objUserPreferences = new UserPrefernces();
                    dsUserPrefernces = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(prescriber.StaffId));
                    dsUserPrefernces.Tables[0].TableName = "Staff";
                    dsUserPrefernces.Tables[1].TableName = "StaffPermissions";
                    dsUserPrefernces.Tables[2].TableName = "StaffSecurityQuestions";
                    if (dsUserPrefernces.Tables.Count > 2)
                        dsUserPrefernces.Tables[3].TableName = "TwoFactorAuthenticationDeviceRegistrations";

                    dsUserPrefernces.Tables[0].Rows[0]["SureScriptsPrescriberId"] = prescriber.SPI;
                    dsUserPrefernces.Tables[0].Rows[0]["SureScriptsLocationId"] = prescriber.LocationId;
                    DateTime current = Convert.ToDateTime(DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss.fff"));
                    dsUserPrefernces.Tables[0].Rows[0]["SureScriptsLastUpdateTime"] = current;
                    objectClientMedications = new ClientMedication();
                    if (dsUserPrefernces.Tables.Contains("StaffPermissions"))
                    {
                        dsUserPrefernces.Tables.Remove("StaffPermissions");
                    }
                    if (dsUserPrefernces.Tables.Contains("StaffSecurityQuestions"))
                    {
                        dsUserPrefernces.Tables.Remove("StaffSecurityQuestions");
                    }
                    DataSet dataSetTemp = objectClientMedications.UpdateDocuments(dsUserPrefernces);
                    DataSet dataSetPermissionsListTemp = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                    dataSetPermissionsListTemp.Merge(dataSetTemp.Tables["Staff"]);
                    Session["DataSetPermissionsList"] = dataSetPermissionsListTemp;

                    result[0] = "SUCCESS";
                    result[1] = prescriber.SPI_Id;
                    dataSetPermissionsListTemp = null;
                    dataSetTemp = null;
                }
                else
                {
                    result[0] = "FAILURE";
                    result[1] = !string.IsNullOrEmpty(prescriber.ErrorText) ? prescriber.ErrorText : prescriber.Status;
                }
                
                return result;
            }
            catch (Exception eX)
            {
                throw (eX);
            }
        }

        //Added by Loveena in ref to Task#3215
        [WebMethod(EnableSession = true)]
        public DataSet MergePharmacies(int DetailsPharmacyId, int SearchPharmacyId)
        {
            try
            {
                objUserPreferences = new UserPrefernces();
                DataSet dsMergePharmacies = objUserPreferences.MergePharmacies(DetailsPharmacyId, SearchPharmacyId);
                return dsMergePharmacies;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        //Added by Loveena in ref to Task#3236        
        [WebMethod(EnableSession = true)]
        public void SavePreferredPharmacy(int PharmacyId)
        {
            try
            {
                objUserPreferences = new UserPrefernces();
                objUserPreferences.UpdatePreferredPharmacy(PharmacyId);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        // Make this method as web Method as part of Engineering improvements-#765 
        [WebMethod(EnableSession = true)]
        public void DeleteUserPreferenceInformation()
        {

            Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences dsUserPreferences = null;
            string[] result = new string[2];

            DataSet dsTemp = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                objUserPreferences = new UserPrefernces();
                dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
                dsTemp = objUserPreferences.DownloadStaffMedicationDetail();
                dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                objectClientMedications = new ClientMedication();
                DataRow[] _dataRowUserPrefernces = null;
                _dataRowUserPrefernces = dsUserPreferences.Tables[0].Select("StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                if (_dataRowUserPrefernces.Length > 0)
                {
                    _dataRowUserPrefernces[0]["RecordDeleted"] = "Y";
                    _dataRowUserPrefernces[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowUserPrefernces[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                    objectClientMedications.UpdateDocuments(dsUserPreferences);
                    Session["StaffIdForPreferences"] = null;
                }
                result[0] = "SUCCESS";
                // ScriptManager.RegisterStartupScript("",, "key", "OpenStartPage();", true);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                result[0] = "FAILURE";
                result[1] = ex.Message;
                //result[1] = !string.IsNullOrEmpty(prescriber.ErrorText) ? prescriber.ErrorText : prescriber.Status;

                //Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                objUserPreferences = null;
                dsTemp = null;
                dsUserPreferences = null;
                objectClientMedications = null;
            }
        }

    }
}




