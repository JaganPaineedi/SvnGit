using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DevExpress.Web.ASPxEditors;
using Microsoft.Reporting.WebForms;
using Streamline.BaseLayer;
using Streamline.Faxing;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using Image = System.Drawing.Image;
using SharedTables = Streamline.UserBusinessServices.SharedTables;

public partial class UserControls_RXMyPhrases : BaseActivityPage
{
    Streamline.UserBusinessServices.ClientMedication objectClientKeyPhrases;
    protected override void Page_Load(object sender, EventArgs e)
    {
      
        HeadingPhrasesList.HeadingText = "Phrase List#KeyPhrasePhraseList";
        FillKeyPhraseCategory();
        FillScreenPhraseCategory();

        var tableControls = new Table();
        tableControls.Width = new Unit(100, UnitType.Percentage);
        tableControls.ID = "tablePhraseList";
        tableControls.Attributes.Add("tablePhraseList", "true");
        #region

        CommonFunctions.SetErrorMegssageBackColor(LabelErrorMessage);
        CommonFunctions.SetErrorMegssageBackColor(LabelGridErrorMessage);
        CommonFunctions.SetErrorMegssageForeColor(LabelErrorMessage);
        CommonFunctions.SetErrorMegssageForeColor(LabelGridErrorMessage);
      
        #endregion
    }
    #region override
   
    private void FillKeyPhraseCategory()
    {
        CommonFunctions.Event_Trap(this);
        DataSet DataSetKeyPhraseCategory = null;
        DataRow[] DataRowKeyPhraseCategory = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='RXKEYPHRASECATEGORY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");

        try
        {
            DataSetKeyPhraseCategory = new DataSet();
            DataSetKeyPhraseCategory.Merge(DataRowKeyPhraseCategory);
            if (DataSetKeyPhraseCategory.Tables.Count > 0)
            {
                DataSetKeyPhraseCategory.Tables[0].TableName = "GlobalCodesKeyPhrases";
                if (DataSetKeyPhraseCategory.Tables["GlobalCodesKeyPhrases"].Rows.Count > 0)
                {
                    DropDownListKeyPhraseCategory.DataSource = DataSetKeyPhraseCategory.Tables["GlobalCodesKeyPhrases"];
                    DropDownListKeyPhraseCategory.DataTextField = "CodeName";
                    DropDownListKeyPhraseCategory.DataValueField = "GlobalCodeId";
                    DropDownListKeyPhraseCategory.DataBind();
               
                }
            }
         
        }
        catch (Exception ex)
        {

        }
        finally
        {
            DataSetKeyPhraseCategory = null;

        }

    }

    private void FillScreenPhraseCategory()
    {
        CommonFunctions.Event_Trap(this);
        DataSet DataSetScreenPhraseCategory = null;
        DataRow[] DataRowScreenPhraseCategory = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='RXKEYPHRASECATEGORY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");

        try
        {
            DataSetScreenPhraseCategory = new DataSet();
            DataSetScreenPhraseCategory.Merge(DataRowScreenPhraseCategory);
            if (DataSetScreenPhraseCategory.Tables.Count > 0)
            {
                DataSetScreenPhraseCategory.Tables[0].TableName = "GlobalCodesKeyPhrases";
                if (DataSetScreenPhraseCategory.Tables["GlobalCodesKeyPhrases"].Rows.Count > 0)
                {
                    DropDownListScreenPhraseCategory.DataSource = DataSetScreenPhraseCategory.Tables["GlobalCodesKeyPhrases"];
                    DropDownListScreenPhraseCategory.DataTextField = "CodeName";
                    DropDownListScreenPhraseCategory.DataValueField = "GlobalCodeId";
                    DropDownListScreenPhraseCategory.DataBind();

                }
            }
            DropDownListScreenPhraseCategory.Items.Insert(0, new ListItem("All", "0"));
            DropDownListScreenPhraseCategory.SelectedIndex = 0;

        }
        catch (Exception ex)
        {


        }
        finally
        {
            DataSetScreenPhraseCategory = null;

        }

    }
    public string KeyPhraseId = string.Empty;
    
    #endregion
   
}