using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer.ActivityPages;

namespace SHS.SmartCare
{
    public partial class Custom_SUDischarge_WebPages_Information : DataActivityTab
    {

        public override void BindControls()
        {
            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                {
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                    continue;
                }
            }
        }
    }
}