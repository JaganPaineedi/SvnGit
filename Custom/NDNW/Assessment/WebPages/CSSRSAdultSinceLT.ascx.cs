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
using SHS.BaseLayer.ActivityPages;
namespace SHS.SmartCare
{
    public partial class Custom_Assessment_WebPages_CSSRSAdultSinceLT : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSYESNO", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion.DataBind();
                DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion.Items.Insert(0, new ListItem("", ""));
            }
        }
    }
}