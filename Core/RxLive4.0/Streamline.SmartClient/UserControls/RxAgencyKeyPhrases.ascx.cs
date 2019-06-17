using Streamline.BaseLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_RxAgencyKeyPhrases : BaseActivityPage
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
        DataTable dtStaffAgencyKeyPhrases = dsMyKeyPhrases.Tables["StaffAgencyKeyPhrases"];

        //Added By Arjun K R
        var lqAgencyKeyPhrases = (from AgencyKeyPhrases in dtMyKeyPhrases.AsEnumerable()
                                  join StaffAgencyKeyPhrases in dtStaffAgencyKeyPhrases.AsEnumerable()
                                  on AgencyKeyPhrases.Field<int?>("AgencyKeyPhraseId") equals StaffAgencyKeyPhrases.Field<int?>("AgencyKeyPhraseId") into tempStaffAgencyKeyPhrases
                                  from q in tempStaffAgencyKeyPhrases.DefaultIfEmpty()
                                  select new
                                  {
                                      AgencyKeyPhraseId = AgencyKeyPhrases.Field<int?>("AgencyKeyPhraseId"),
                                      PhraseText = AgencyKeyPhrases.Field<string>("PhraseText").Trim(),
                                      KeyPhraseCategory = AgencyKeyPhrases.Field<int?>("KeyPhraseCategory"),
                                      CheckOrUnCheck= q == null ? "N" : (q.Field<string>("RecordDeleted") == "Y" ? "N" : "Y")
                                  }).ToList();
        var pjsonAgencyKeyPhrases = new JavaScriptSerializer();
        var ajsonAgencyKeyPhrases = pjsonAgencyKeyPhrases.Serialize(lqAgencyKeyPhrases);
        HiddenField_AgencyKeyPhraseContainerJSON.Value = ajsonAgencyKeyPhrases.ToString();

        //Arjun KR Code Block End here

    }

    private void FillKeyPhraseCategory()
    {
        DataSet DataSetKeyPhraseCategory = null;
        DataRow[] DataRowKeyPhraseCategory = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='RXKEYPHRASECATEGORY' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ", "CodeName asc");
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
                    DropDownListAgencyKeyPhraseCategory.DataSource = DataSetKeyPhraseCategory.Tables["GlobalCodesKeyPhrases"];
                    DropDownListAgencyKeyPhraseCategory.DataTextField = "CodeName";
                    DropDownListAgencyKeyPhraseCategory.DataValueField = "GlobalCodeId";
                    DropDownListAgencyKeyPhraseCategory.DataBind();


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