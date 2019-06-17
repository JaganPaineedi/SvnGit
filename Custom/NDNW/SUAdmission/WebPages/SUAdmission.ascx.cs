using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.DataServices;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

public partial class Custom_SUAdmission_WebPages_SUAdmission : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{

    public override string DefaultTab
    {
        get { return "/Custom/SUAdmission/WebPages/General.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return "RadMultiPageSUAdmissionTabPage"; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ctlcollection = this.RadMultiPageSUAdmissionTabPage.Controls[TabIndex].Controls;
        RadMultiPageSUAdmissionTabPage.SelectedIndex = (short)TabIndex;
        RadTabStrip1SUAdmissionTabPage.SelectedIndex = (short)TabIndex;
        UcPath = RadTabStrip1SUAdmissionTabPage.Tabs[TabIndex].Attributes["Path"];
    }

    public override void BindControls()
    {
        if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSUAdmissions"].Rows.Count > 0)
        {
            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSUAdmissions"].Rows[0]["DocumentVersionId"].ToString() == "-1")
            {
                SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSUAdmissions"].Rows[0]["HouseholdIncome"] = DBNull.Value;
            }
        }

    }

    public override string PageDataSetName
    {
        get { return "DatasetSUAdmissions"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentSUAdmissions", "CustomDocumentInfectiousDiseaseRiskAssessments" }; }
    }
    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        //base.ChangeDataSetBeforeUpdate(ref dataSetObject);
       
    }

    public override void ChangeDataSetAfterGetData()
    {
        if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables.Count > 0)
        {
        }

    }
}

