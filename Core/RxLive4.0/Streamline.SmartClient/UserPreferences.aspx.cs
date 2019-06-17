using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;

public partial class UserPreferences : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
        {
        int intLoop = 0;
        if (Request["FunctionId"].ToString() != string.Empty)
            {
            switch (Request["FunctionId"].ToString())
                {
                case "GetPermissionsList":
                        {
                        PermissionsList.GenerateRows(Request["par0"].ToString());
                        break;
                        }                
                }
            }
        }
    }
