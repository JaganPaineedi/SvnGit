using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;

public partial class ActivityPages_Client_Detail_Kalamazoo_KalamazooAssessment_CraftAssessment : SHS.BaseLayer.ActivityPages.DataActivityTab
{
   
    public override void BindControls()
    {
        using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("STAGEOFCHANGE", true, "", "SortOrder", true))
        {

            DropDownList_CustomDocumentCRAFFTs_CrafftStageOfChange.DataTextField = "CodeName";
            DropDownList_CustomDocumentCRAFFTs_CrafftStageOfChange.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentCRAFFTs_CrafftStageOfChange.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentCRAFFTs_CrafftStageOfChange.DataBind();

        }
    }
}
