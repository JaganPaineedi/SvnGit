using System;
using System.Data;
using System.Collections.Generic;
using System.Text;

namespace Streamline.UserBusinessServices
{
    public class CommonBase : IDisposable
    {
        DataSet datasetMain = null;
        bool newRow = true;
        //Path to dataset folder
        string PATH = System.Web.HttpContext.Current.Server.MapPath("~\\DataSets\\");
        Streamline.DataService.CommonBase objCommonBase = null;
        /// <summary>
        /// Creates datarows pertaining to the controls in the panel and updates them 
        /// </summary>
        /// <param name="PanelControls">Panel with contains the collection </param>
        /// <param name="objTemp">Object which contains values regarding the documentrow</param>
        /// <returns>true on successful update</returns>
        public bool UpdateData(System.Web.UI.WebControls.Panel PanelControls, ref object objTemp)
        {
            try 
            {
                objCommonBase = new Streamline.DataService.CommonBase();
                System.Collections.Hashtable hashTableTemp = (System.Collections.Hashtable)objTemp;
                string dataFileTemp = PanelControls.Attributes["DataFile"];
                string dataFileAfterUpdate = PanelControls.Attributes["DataFileAfterUpdate"];

                //This statement is used to get the collections of controls in the panel.
                //GetEnumerator is a forward only and light weight cursor.Hence it is more efficient than
                // For each control in Panel.
                System.Collections.IEnumerator eControls = PanelControls.Controls.GetEnumerator();
                datasetMain = new DataSet();


                if (!String.IsNullOrEmpty(dataFileAfterUpdate))
                {
                    datasetMain.ReadXml(PATH + System.Web.HttpContext.Current.Session.SessionID + "\\" + dataFileAfterUpdate, XmlReadMode.ReadSchema);
                    datasetMain.AcceptChanges();
                }
                else
                {
                    datasetMain.ReadXmlSchema(PATH + dataFileTemp);
                }

                newRow = true;
                //if(hashTableTemp.ContainsKey("DocumentId")) 
                //   AddDataRowValues(tableName, fieldName, hdnTemp.Value, primaryKey == "True" ? true : false);
                //if(hashTableTemp.ContainsKey("Version"))
                //   AddDataRowValues(tableName, fieldName, hdnTemp.Value, primaryKey == "True" ? true : false);

                while (eControls.MoveNext())
                {
                    object objCurrentControl = eControls.Current;
                    switch (objCurrentControl.GetType().ToString())
                    {
                        case "System.Web.UI.HtmlControls.HtmlInputHidden":
                            {
                                System.Web.UI.HtmlControls.HtmlInputHidden hdnTemp = (System.Web.UI.HtmlControls.HtmlInputHidden)objCurrentControl;
                                string primaryKey = hdnTemp.Attributes["PrimaryKey"];
                                if (!String.IsNullOrEmpty(primaryKey))
                                {
                                    string fieldName = hdnTemp.Attributes["FieldName"];
                                    string tableName = hdnTemp.Attributes["TableName"];
                                    if (primaryKey == "True")
                                    {
                                        if (String.IsNullOrEmpty(hdnTemp.Value))
                                        {
                                            if (hashTableTemp.ContainsKey(fieldName))
                                                hdnTemp.Value = hashTableTemp[fieldName].ToString();
                                        }
                                        else
                                        {
                                            newRow = false;
                                        }
                                        AddDataRowValues(tableName, fieldName, hdnTemp.Value, primaryKey == "True" ? true : false);
                                    }

                                }
                                break;
                            }
                        case "System.Web.UI.WebControls.TextBox":
                            {
                                System.Web.UI.WebControls.TextBox txtTemp = (System.Web.UI.WebControls.TextBox)objCurrentControl;
                                string fieldName = txtTemp.Attributes["FieldName"];
                                string tableName = txtTemp.Attributes["TableName"];
                                AddDataRowValues(tableName, fieldName, txtTemp.Text, false);
                                break;
                            }
                        case "System.Web.UI.WebControls.CheckBox":
                            {
                                System.Web.UI.WebControls.CheckBox chkTemp = (System.Web.UI.WebControls.CheckBox)objCurrentControl;
                                string fieldName = chkTemp.Attributes["FieldName"];
                                string tableName = chkTemp.Attributes["TableName"];
                                AddDataRowValues(tableName, fieldName, chkTemp.Checked == true ? "Y" : "N", false);
                                break;
                            }
                        case "System.Web.UI.WebControls.DropDownList":
                            {
                                System.Web.UI.WebControls.DropDownList ddlTemp = (System.Web.UI.WebControls.DropDownList)objCurrentControl;
                                string fieldName = ddlTemp.Attributes["FieldName"];
                                string tableName = ddlTemp.Attributes["TableName"];
                                AddDataRowValues(tableName, fieldName, ddlTemp.SelectedValue, false);
                                break;
                            }
                        case "System.Web.UI.WebControls.RadioButton":
                            {
                                System.Web.UI.WebControls.RadioButton rbTemp = (System.Web.UI.WebControls.RadioButton)objCurrentControl;
                                string fieldName = rbTemp.Attributes["FieldName"];
                                string tableName = rbTemp.Attributes["TableName"];
                                string value = rbTemp.Attributes["Value"];
                                if (rbTemp.Checked == true)
                                    AddDataRowValues(tableName, fieldName, value, false);
                                break;
                            }

                    }

                }

                //Merging the documents table to the maindataset
                datasetMain.Merge(getDocumentTable(objTemp));

                DataSet dsUpdated = objCommonBase.UpdateDocuments(datasetMain);
                string updateFile = System.Guid.NewGuid().ToString() + ".xml";
                dsUpdated.WriteXml(PATH + System.Web.HttpContext.Current.Session.SessionID + "\\" + updateFile, XmlWriteMode.WriteSchema);
                PanelControls.Attributes["DataFileAfterUpdate"] = updateFile;

                // setting back the updated documentid and version id to the arguments passed by the parent class
                if (dsUpdated.Tables.Count > 0)
                {
                    if (dsUpdated.Tables[0].Columns.Contains("DocumentId"))
                    {
                        if (dsUpdated.Tables[0].Rows.Count > 0)
                        {

                            if (hashTableTemp.ContainsKey("DocumentId"))
                            {
                                hashTableTemp["DocumentId"] = Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["DocumentId"]);
                            }
                            else
                            {
                                hashTableTemp.Add("DocumentId", Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["DocumentId"]));
                            }

                            if (hashTableTemp.ContainsKey("Version"))
                            {
                                hashTableTemp["Version"] = Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["Version"]);
                            }
                            else
                            {
                                hashTableTemp.Add("Version", Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["Version"]));
                            }

                        }
                    }
                }


                // SetControlValues(PanelControls, dsUpdated);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        /// <summary>
        /// Updates dataset passed
        /// </summary>
        /// <param name="datasetUpdate">dataset for update</param>
        /// <param name="objTemp">Object which contains values regarding the documentrow</param>
        /// <returns>true on successful update</returns>
        public bool UpdateData(DataSet datasetUpdate, ref object objTemp)
        {
            try
            {
                System.Collections.Hashtable hashTableTemp = (System.Collections.Hashtable)objTemp;
                datasetMain = datasetUpdate;
                datasetMain.Merge(getDocumentTable(objTemp));
                using (objCommonBase = new Streamline.DataService.CommonBase())
                {
                    DataSet dsUpdated = objCommonBase.UpdateDocuments(datasetMain);
                    string updateFile = System.Guid.NewGuid().ToString() + ".xml";
                    dsUpdated.WriteXml(PATH + System.Web.HttpContext.Current.Session.SessionID + "\\" + updateFile, XmlWriteMode.WriteSchema);
                    //PanelControls.Attributes["DataFileAfterUpdate"] = updateFile;

                    // setting back the updated documentid and version id to the arguments passed by the parent class
                    if (dsUpdated.Tables.Count > 0)
                    {
                        if (dsUpdated.Tables[0].Columns.Contains("DocumentId"))
                        {
                            if (dsUpdated.Tables[0].Rows.Count > 0)
                            {

                                if (hashTableTemp.ContainsKey("DocumentId"))
                                {
                                    hashTableTemp["DocumentId"] = Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["DocumentId"]);
                                }
                                else
                                {
                                    hashTableTemp.Add("DocumentId", Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["DocumentId"]));
                                }

                                if (hashTableTemp.ContainsKey("Version"))
                                {
                                    hashTableTemp["Version"] = Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["Version"]);
                                }
                                else
                                {
                                    hashTableTemp.Add("Version", Convert.ToInt32(dsUpdated.Tables[0].Rows[0]["Version"]));
                                }

                            }
                        }
                    }
                }


                return true;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        /// <summary>
        /// Retrives data from object and create a new document row
        /// </summary>
        /// <param name="objTemp">hashtable(object) containing document related values </param>
        /// <returns></returns>
        private DataTable getDocumentTable(object objTemp)
        {
            try
            {
                DataTable dtTemp = new DataTable();
                dtTemp.TableName = "Documents";
                System.Collections.Hashtable htTemp = (System.Collections.Hashtable)objTemp;
                foreach (System.Collections.DictionaryEntry dekey in htTemp)
                {
                    dtTemp.Columns.Add(dekey.Key.ToString(), System.Type.GetType("System.String"));
                }
                DataRow dr = dtTemp.NewRow();
                foreach (System.Collections.DictionaryEntry dekey in htTemp)
                {
                    dr[dekey.Key.ToString()] = dekey.Value;
                }
                dtTemp.Rows.Add(dr);
                return dtTemp;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        private void FillDropDowns(System.Web.UI.WebControls.DropDownList dropDownTemp, string dataSource, string dataTextField, string dataValueField, string SelectCase, string SelectType)
        {
            try
            {
                objCommonBase = new Streamline.DataService.CommonBase();
                DataSet DataSetDropdown = new DataSet();
                DataSetDropdown = objCommonBase.FillDropDown(SelectType, SelectCase);
                if (DataSetDropdown.Tables.Count > 0)
                {
                    if (DataSetDropdown.Tables[0].Rows.Count > 0)
                    {
                        dropDownTemp.DataSource = DataSetDropdown.Tables[0];
                        dropDownTemp.DataValueField = dataValueField;
                        dropDownTemp.DataTextField = dataTextField;
                        dropDownTemp.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        /// <summary>
        /// Adds row to the main dataset depending on datatable and columnNames passed
        /// </summary>
        /// <param name="dataTableName"></param>
        /// <param name="dataField"></param>
        /// <param name="fieldValue"></param>
        /// <param name="primaryKey"></param>
        private void AddDataRowValues(string dataTableName, string dataField, string fieldValue, bool primaryKey)
        {
            try
            {

                if (datasetMain == null)
                    return;
                if (!datasetMain.Tables.Contains(dataTableName))
                    return;
                if (!datasetMain.Tables[dataTableName].Columns.Contains(dataField))
                    return;

                DataRow drTemp = null;
                //Check for row in datatable else add a new row to the table
                if (datasetMain.Tables[dataTableName].Rows.Count > 0)
                {
                    drTemp = datasetMain.Tables[dataTableName].Rows[0];
                    drTemp[dataField] = fieldValue;
                    //When ever the loop encounters a primary key  it set the rowstates to unchanged 
                    //so that it does not change the row state of primarykeys while modifying
                    if (primaryKey && !newRow)
                        datasetMain.Tables[dataTableName].AcceptChanges();
                }
                else
                {
                    drTemp = datasetMain.Tables[dataTableName].NewRow();
                    // checks for a column  which does not allow null values and sets a default value according to datatype
                    foreach (DataColumn c in datasetMain.Tables[dataTableName].Columns)
                    {
                        if (c.AllowDBNull == false)
                        {
                            if (drTemp[c] == DBNull.Value)
                            {
                                if (c.DataType.ToString() == "System.Int32")
                                    drTemp[c] = -1;
                                if (c.DataType.ToString() == "System.String")
                                    drTemp[c] = "";
                                if (c.DataType.ToString() == "System.DateTime")
                                    drTemp[c] = System.DateTime.Now;
                            }
                        }
                    }
                    if (newRow == false)
                    {
                        drTemp[dataField] = fieldValue;
                        datasetMain.Tables[dataTableName].Rows.Add(drTemp);
                        if (primaryKey)
                            datasetMain.Tables[dataTableName].AcceptChanges();
                    }
                    else
                    {
                        drTemp[dataField] = fieldValue;
                        datasetMain.Tables[dataTableName].Rows.Add(drTemp);
                    }

                }
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// Set back the updated value from the dataset to each controls of the panel
        /// Also sets validation and javascript events on the controls.
        /// </summary>
        /// <param name="PanelControls"></param>
        /// <param name="datasetDocument"></param>
        public void SetControlValues(System.Web.UI.WebControls.Panel PanelControls, DataSet datasetDocument)
        {
            try
            {
                System.Web.UI.WebControls.HiddenField HiddenFieldValidation = new System.Web.UI.WebControls.HiddenField();
                using (datasetDocument)
                {
                    HiddenFieldValidation.ID = "HiddenFieldValidation";
                    PanelControls.Controls.Add(HiddenFieldValidation);
                    System.Collections.IEnumerator eControls = PanelControls.Controls.GetEnumerator();
                    while (eControls.MoveNext())
                    {
                        object objCurrentControl = eControls.Current;
                        switch (objCurrentControl.GetType().ToString())
                        {
                            case "System.Web.UI.HtmlControls.HtmlInputHidden":
                                {
                                    System.Web.UI.HtmlControls.HtmlInputHidden hdnTemp = (System.Web.UI.HtmlControls.HtmlInputHidden)objCurrentControl;
                                    string primaryKey = hdnTemp.Attributes["PrimaryKey"];

                                    if (!String.IsNullOrEmpty(primaryKey))
                                    {
                                        string fieldName = hdnTemp.Attributes["FieldName"];
                                        string tableName = hdnTemp.Attributes["TableName"];
                                        if (CheckFieldValues(tableName, fieldName, datasetDocument))
                                            hdnTemp.Value = datasetDocument.Tables[tableName].Rows[0][fieldName].ToString();
                                    }
                                    break;
                                }
                            case "System.Web.UI.WebControls.TextBox":
                                {
                                    System.Web.UI.WebControls.TextBox txtTemp = (System.Web.UI.WebControls.TextBox)objCurrentControl;
                                    txtTemp.Attributes.Add("OnChange", "isdirty()");
                                    string fieldName = txtTemp.Attributes["FieldName"];
                                    string tableName = txtTemp.Attributes["TableName"];
                                    string validation = txtTemp.Attributes["Validate"];

                                    if (!String.IsNullOrEmpty(validation))
                                    {
                                        if (HiddenFieldValidation.Value == "")
                                            HiddenFieldValidation.Value = txtTemp.ClientID;
                                        else
                                            HiddenFieldValidation.Value += ";" + txtTemp.ClientID;

                                    }
                                    if (CheckFieldValues(tableName, fieldName, datasetDocument))
                                        txtTemp.Text = datasetDocument.Tables[tableName].Rows[0][fieldName].ToString();
                                    break;
                                }
                            case "System.Web.UI.WebControls.CheckBox":
                                {
                                    System.Web.UI.WebControls.CheckBox chkTemp = (System.Web.UI.WebControls.CheckBox)objCurrentControl;
                                    chkTemp.Attributes.Add("OnClick", "isdirty()");
                                    string fieldName = chkTemp.Attributes["FieldName"];
                                    string tableName = chkTemp.Attributes["TableName"];
                                    string validation = chkTemp.Attributes["Validate"];

                                    if (!String.IsNullOrEmpty(validation))
                                    {
                                        if (HiddenFieldValidation.Value == "")
                                            HiddenFieldValidation.Value = chkTemp.ClientID;
                                        else
                                            HiddenFieldValidation.Value += ";" + chkTemp.ClientID;
                                   }
                                    if (CheckFieldValues(tableName, fieldName, datasetDocument))
                                        chkTemp.Checked = datasetDocument.Tables[tableName].Rows[0][fieldName].ToString() == "Y" ? true : false;
                                    break;
                                }
                            case "System.Web.UI.WebControls.DropDownList":
                                {
                                    System.Web.UI.WebControls.DropDownList ddlTemp = (System.Web.UI.WebControls.DropDownList)objCurrentControl;
                                    ddlTemp.Attributes.Add("OnChange", "isdirty()");
                                    string fieldName = ddlTemp.Attributes["FieldName"];
                                    string tableName = ddlTemp.Attributes["TableName"];
                                    string dataSource = ddlTemp.Attributes["DataSource"];/////////No Need
                                    string SelectCase = ddlTemp.Attributes["SelectCase"];
                                    string SelectType = ddlTemp.Attributes["SelectType"];
                                    string dataTextField = ddlTemp.Attributes["TextField"];
                                    string dataValueField = ddlTemp.Attributes["ValueField"];
                                    string validation = ddlTemp.Attributes["Validate"];

                                    if (!String.IsNullOrEmpty(validation))
                                    {
                                        if (HiddenFieldValidation.Value == "")
                                            HiddenFieldValidation.Value = ddlTemp.ClientID;
                                        else
                                            HiddenFieldValidation.Value += ";" + ddlTemp.ClientID;
                                    }

                                    //FillDropDowns(ddlTemp, dataSource, dataTextField, dataValueField);
                                    FillDropDowns(ddlTemp, dataSource, dataTextField, dataValueField, SelectCase, SelectType);
                                    if (CheckFieldValues(tableName, fieldName, datasetDocument))
                                        ddlTemp.SelectedValue = datasetDocument.Tables[tableName].Rows[0][fieldName].ToString();
                                    break;
                                }
                            case "System.Web.UI.WebControls.RadioButton":
                                {
                                    System.Web.UI.WebControls.RadioButton rbTemp = (System.Web.UI.WebControls.RadioButton)objCurrentControl;
                                    rbTemp.Attributes.Add("OnClick", "isdirty()");
                                    string fieldName = rbTemp.Attributes["FieldName"];
                                    string tableName = rbTemp.Attributes["TableName"];
                                    string value = rbTemp.Attributes["Value"];
                                    string validation = rbTemp.Attributes["Validate"];

                                    if (!String.IsNullOrEmpty(validation))
                                    {
                                        if (HiddenFieldValidation.Value == "")
                                            HiddenFieldValidation.Value = rbTemp.ClientID;
                                        else
                                            HiddenFieldValidation.Value += ";" + rbTemp.ClientID;
                                    }

                                    if (CheckFieldValues(tableName, fieldName, datasetDocument))
                                    {
                                        if (datasetDocument.Tables[tableName].Rows[0][fieldName].ToString().Trim() == value.Trim())
                                        {
                                            rbTemp.Checked = true;
                                        }
                                    }
                                    break;
                                }
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        private bool CheckFieldValues(string dataTableName, string dataField, DataSet dsTemp)
        {
            try
            {
                if (dsTemp == null)
                    return false;
                if (!dsTemp.Tables.Contains(dataTableName))
                    return false;
                if (!dsTemp.Tables[dataTableName].Columns.Contains(dataField))
                    return false;
                if (dsTemp.Tables[dataTableName].Rows.Count < 1)
                    return false;

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public void Dispose()
        {
            if (datasetMain != null)
                datasetMain.Dispose();
            if (objCommonBase != null)
                objCommonBase.Dispose();
        }      


        //public DataSet FillDataSetMentalStatus(int DocumentId, int version)
        //{
        //    DataSet DataSetMentalStatus = new DataSet();
        //    try
        //    {
        //        objCommonBase = new Streamline.DataService.CommonBase();
        //        DataSetMentalStatus = objCommonBase.FillDataSetMentalStatus(DocumentId, version);
        //        return DataSetMentalStatus;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}


        //Code added by Priya on 8th Feb '08

        //public DataSet FillDataSetAssesmentInitial(int DocumentId, int version)
        //{
        //    DataSet DataSetAssesmentInitial = new DataSet();
        //    try
        //    {
        //        objCommonBase = new Streamline.DataService.CommonBase();
        //        DataSetAssesmentInitial = objCommonBase.FillDataSetInitial(DocumentId, version);
        //        return DataSetAssesmentInitial;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }

        //}

        public DataSet RetreiveData(string spName, string[] tableNames, System.Collections.Hashtable args)
        {
            try
            {
                using (Streamline.DataService.CommonBase objCommonBase = new Streamline.DataService.CommonBase())
                {

                    DataSet datasetRetrieve = objCommonBase.RetrieveDataset(spName, tableNames, args);
                    if (datasetRetrieve.Tables.Count > 0)
                    {
                        if (datasetRetrieve.Tables[0].Rows.Count > 0)
                        {
                            string updateFile = System.Guid.NewGuid().ToString() + ".xml";
                            datasetRetrieve.WriteXml(PATH + System.Web.HttpContext.Current.Session.SessionID + "\\" + updateFile, XmlWriteMode.WriteSchema);
                            datasetRetrieve.ExtendedProperties.Add("XMLFileName", updateFile);
                        }
                    }

                    return datasetRetrieve;

                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        /// <summary>
        /// Created By Pramod Prakash on 11th Feb 2008
        /// This fucntion is a generic function that will retun dataset after executing procedure
        /// that is passed to it and this function will not create .Xml file.
        /// </summary>
        /// <param name="spName"></param>
        /// <param name="tableNames"></param>
        /// <returns></returns>
        public DataSet RetreiveDataWithoutXml(string spName, string[] tableNames, System.Collections.Hashtable args)
        {
            try
            {
                using (Streamline.DataService.CommonBase objCommonBase = new Streamline.DataService.CommonBase())
                {

                    DataSet datasetRetrieve = objCommonBase.RetrieveDataset(spName, tableNames, args);
                   

                    return datasetRetrieve;

                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
