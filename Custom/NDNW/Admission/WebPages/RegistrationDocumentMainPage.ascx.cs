using System;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Data;
using System.Xml;
using System.IO;
using SHS.BaseLayer;
using System.Collections.Generic;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

namespace SHS.SmartCare
{
    public partial class RegistrationDocumentMainPage : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        string TableName = string.Empty;

        #region--Properties--
        ///<summary>
        ///<Description>This property is used to return page dataset name
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        ///</summary>

        public override string PageDataSetName
        {
            get
            {
                return "DataSetCustomRegistrationDocument";
            }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms != null)
                {
                    DataRow[] dr = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms.Select("FormId=" + 82);
                    if (dr != null && dr.Length > 0)
                    {
                        TableName = Convert.ToString(dr[0]["TableName"]);
                    }

                }
                return new string[] { TableName, "CustomRegistrationFormsAndAgreements" };
            }
        }

        ///<summary>
        ///<Description>This property is used to open first tab "Custom"
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        ///</summary>
        public override string DefaultTab
        {
            get { return "/Custom/Admission/WebPages/RegistrationDocumentDemographics.ascx"; }
        }

        ///<summary>
        ///<Description>This property is used to return multitabcontrol id"
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        ///</summary>
        public override string MultiTabControlName
        {

            get { return "RegistrationDocumentTabPage"; }
        }
        #endregion

        #region--user defined functions--
        /// <summary>
        /// <Description>This is overridable function used to set tab index </Description>
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        /// </summary>
        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RegistrationDocumentTabPage.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RegistrationDocumentTabPage.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];
        }

        //public override bool NewAllowedForInactiveClients
        //{
        //    get
        //    {
        //        return true;
        //    }
        //}

        public override int FormCollectionId
        {
            get
            {
                return 1;
            }
            set
            {
                base.FormCollectionId = 1;
            }
        }

        ///<summary>
        ///<Description>This function is used to bind contols of page
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        ///</summary>
        public override void BindControls()
        {
            hdnStaffcode.Value = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count > 0)
            {
                if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["DocumentVersionId"].ToString() == "-1")
                {
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["ProgramRequestedDate"] = DBNull.Value;
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["ProgramEnrolledDate"] = DBNull.Value;
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["PerSessionFee"] = DBNull.Value;
                }
            }
        }

        /// <summary>
        ///<Author>Malathi Shiva</Author>
        ///<CreatedOn>Oct 01,2014</CreatedOn>
        /// </summary>
        /// <param name="dataSetObject"></param>
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            string[] dataTables = new string[] { "ClientContacts"};

            if (dataSetObject != null)
            {
                for (int i = 0; i < BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationCoveragePlans"].Rows.Count; i++)
                {
                    if (Convert.ToString(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationCoveragePlans"].Rows[i]["GroupId"]) == "")
                    {
                        BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomRegistrationCoveragePlans"].Rows[i]["GroupId"] = DBNull.Value;
                    }
                }
                for (int count = 0; count < dataTables.Length; count++)
                {
                    if (dataSetObject.Tables.Contains(dataTables[count]) == true)
                    {
                        dataSetObject.Tables.Remove(dataTables[count].ToString());
                    }
                }
            }
            else
            {
                throw new ApplicationException("DataSet is Null");
            }
            ResidanceCountryNull();

        }

        public override void ChangeDataSetBeforeDeletion(ref DataSet dataSetObject)
        {
            string[] dataTables = new string[] { "ClientContacts" };

            if (dataSetObject != null)
            {
                for (int count = 0; count < dataTables.Length; count++)
                {
                    if (dataSetObject.Tables.Contains(dataTables[count]) == true)
                    {
                        dataSetObject.Tables.Remove(dataTables[count].ToString());
                    }
                }
            }
            else
            {
                throw new ApplicationException("DataSet is Null");
            }
        }

        public void ResidanceCountryNull()
        {
            if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables.Contains("CustomDocumentRegistrations"))
            {
                if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count > 0)
                {
                    for (int i = 0; i < BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count; i++)
                    {
                        if (Convert.ToString(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[i]["ResidenceCounty"]) == "-1")
                        {
                            BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[i]["ResidenceCounty"] = DBNull.Value;
                        }
                    }
                }
            }
        }

        public string PageTables
        {
            get
            {
                string TableName = "";
                if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms != null)
                {
                    DataRow[] dr = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms.Select("FormId=" + 82);
                    if (dr != null && dr.Length > 0)
                    {
                        TableName = Convert.ToString(dr[0]["TableName"]);
                    }

                }
                return TableName + ",CustomRegistrationFormsAndAgreements,CustomRegistrationCoveragePlans";
            }
        }


        
        #endregion
    }
}