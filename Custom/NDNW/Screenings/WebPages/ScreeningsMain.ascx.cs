#region Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//=========================================================================================
// Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    ScreeningsMain.ascx.cs
//
// Author:     Shruthi.S
// Date:       06 May 2015
//=========================================================================================
#endregion

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using SHS.BaseLayer;
using System.Data;
using System.Configuration;
using System.Web.UI.WebControls.WebParts;
using SHS.UserBusinessServices;
using SHS.BaseLayer.ActivityPages;
using System.Data.SqlClient;
namespace SHS.SmartCare
{

public partial class Custom_Screenings_WebPages_ScreeningsMain : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{ 
    
    public override string  MultiTabControlName
    {
        get
        {
            return "ScreeningsTabPageInstance";
        }
    }

    public override void  setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ScreeningsTabPageInstance.ActiveTabIndex = (short)TabIndex;
        ctlcollection = ScreeningsTabPageInstance.TabPages[TabIndex].Controls;
        UcPath = ScreeningsTabPageInstance.TabPages[TabIndex].Name;
    }

    public override void  BindControls()
    {
     	
    }

    public override string  PageDataSetName
    {
        get { return "DataSetScreenings"; }
                
    }
    public override string DefaultTab
    {
        get { return "/Custom/Screenings/WebPages/SubstanceUse.ascx"; }
    }

    public override string[]  TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentSubstanceAbuseScreenings" }; }
    }
  }
}
