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

public partial class ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNoteMedications : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {

    }
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentMedicationReviewNotes" };
        }
    }
}