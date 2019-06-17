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
using Microsoft.Web.Script.Serialization;

public partial class UserControls_UseAgencyKeyPhrases : BaseActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        FillKeyPhraseCategory();

        DataSet dsMyKeyPhrases = null;
        if (Session["DataSetKeyPhrases"] != null)
        {
            dsMyKeyPhrases = (DataSet)Session["DataSetKeyPhrases"];
        }

        DataTable dtMyKeyPhrases = dsMyKeyPhrases.Tables["AgencyKeyPhrases"];



        var lqAgencyKeyPhrases = (from p in dtMyKeyPhrases.AsEnumerable()
                            select new
                            {
                                KeyPhraseId = p.Field<int?>("AgencyKeyPhraseId"),
                                PhraseText = p.Field<string>("PhraseText").Trim(),
                                KeyPhraseCategory = p.Field<int?>("KeyPhraseCategory")
                            }).ToList();
        var pjsonAgencyKeyPhrases = new JavaScriptSerializer();
        var ajsonAgencyKeyPhrases = pjsonAgencyKeyPhrases.Serialize(lqAgencyKeyPhrases);
        HiddenField_UseAgencyKeyPhraseContainerJSON.Value = ajsonAgencyKeyPhrases.ToString();

    }

    private void FillKeyPhraseCategory()
    {
        DataSet DataSetKeyPhraseCategory = null;
        DataRow[] DataRowKeyPhraseCategory = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='KEYPHRASECATEGORY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");
        //DataRow[] DataRowKeyPhraseCategory = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='KEYPHRASECATEGORY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");

        try
        {
            DataSetKeyPhraseCategory = new DataSet();
            DataSetKeyPhraseCategory.Merge(DataRowKeyPhraseCategory);
            if (DataSetKeyPhraseCategory.Tables.Count > 0)
            {
                DataSetKeyPhraseCategory.Tables[0].TableName = "GlobalCodesKeyPhrases";
                if (DataSetKeyPhraseCategory.Tables["GlobalCodesKeyPhrases"].Rows.Count > 0)
                {
                    DropDownListUseAgencyKeyPhraseCategory.DataSource = DataSetKeyPhraseCategory.Tables["GlobalCodesKeyPhrases"];
                    DropDownListUseAgencyKeyPhraseCategory.DataTextField = "CodeName";
                    DropDownListUseAgencyKeyPhraseCategory.DataValueField = "GlobalCodeId";
                    DropDownListUseAgencyKeyPhraseCategory.DataBind();


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
}