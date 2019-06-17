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
    public partial class Custom_Assessment_WebPages_CSSRSAdultScreeners : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            DropDownList_CustomDocumentCSSRSAdultScreeners_WishToBeDead.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_WishToBeDead.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_WishToBeDead.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughtsWithMethods.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughtsWithMethods.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughtsWithMethods.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithoutSpecificPlan.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithoutSpecificPlan.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithoutSpecificPlan.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithSpecificPlan.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithSpecificPlan.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithSpecificPlan.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_HowLongAgoSuicidalBehavior.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_HowLongAgoSuicidalBehavior.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_HowLongAgoSuicidalBehavior.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalBehaviorQuestion.Items.Add(new ListItem(string.Empty, ""));
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalBehaviorQuestion.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalBehaviorQuestion.FillDropDownDropGlobalCodes();
        }
    }
}