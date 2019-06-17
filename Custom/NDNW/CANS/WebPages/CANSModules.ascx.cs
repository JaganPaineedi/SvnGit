using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace SHS.SmartCare
{
    public partial class CANSModules : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
       
        public override void BindControls()
        {
            
        }
        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "CustomDocumentCANSGenerals","CustomDocumentCANSModules" };
            }

        }


    }

}