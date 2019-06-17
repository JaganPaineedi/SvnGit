using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using SHS.BaseLayer;


// Author   : Amit Kumar Srivastava
// Task     : #23 Additional Scope - Informed Consent (Development Phase II (Offshore))
// Project  : Threshold

public partial class ActivityPages_Client_Detail_Documents_Threshold_CustomInformedConsents : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{    
    /// <summary>
    ///  Purpose :To bind the control in DFA
    /// </summary>
    public override void BindControls()
    {
        DynamicFormsCustomDocumentInformedConsents.FormId = 132;
        DynamicFormsCustomDocumentInformedConsents.Activate();
        
    }
    // added by rohit katoch  ref : task#1169 in threshold bugs snd features
    private ArrayList arrListDFAFormIds = new ArrayList();

    public override ArrayList DFAFormIds
    {
        get
        {
            return arrListDFAFormIds;
        }
        set
        {
            arrListDFAFormIds.Add(132);
        }
    }
    /// <summary>
    ///  Purpose :Page Data set Name(Single tab  DFA so no Data set name)
    /// </summary>
    public override string PageDataSetName
    {
        get { return ""; }
    }

    /// <summary>
    /// Purpose :Enter table name which is to be initialize
    /// </summary>
    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentInformedConsents" }; }
    }
    
}
