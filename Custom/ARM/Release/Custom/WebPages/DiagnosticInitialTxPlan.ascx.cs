﻿using System;
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

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticInitialTxPlan : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    /// <summary>
    /// <Description>This overridable function is used to call the activate method of Initial Treatment Plan User control</Description>
    /// <Author>Minakshi</Author>
    /// <CreatedOn>30 June 2011</CreatedOn>
    /// </summary>
    public override void BindControls()
    {
        UserControl_UCTxPlan.Activate();
    }
}
