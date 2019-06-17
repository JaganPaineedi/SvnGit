using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Reflection;
using System.IO;
using DevExpress.Web.ASPxTabControl;
using System.Xml;
using System.Web.Script.Serialization;
using System.Collections;
using System.Data;

public partial class Custom_IndividualServiceNote_WebPages_IndividualServiceGeneralNote : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    public override string DefaultTab
    {
        get { return "/Custom/IndividualServiceNote/WebPages/IndividualServiceNoteGeneral.ascx"; }
    }

    public override string MultiTabControlName
    {
        get { return IndividualServiceNoteTabPageInstance.ID; }
    }

    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        if ((((DevExpress.Web.ASPxClasses.StateManagedCollectionBase)(IndividualServiceNoteTabPageInstance.TabPages)).Count - 1) < TabIndex)
        {
            TabIndex = 0;
        }
        IndividualServiceNoteTabPageInstance.ActiveTabIndex = (short)TabIndex;
        ctlcollection = IndividualServiceNoteTabPageInstance.TabPages[TabIndex].Controls;
        UcPath = IndividualServiceNoteTabPageInstance.TabPages[TabIndex].Name;
    }

    public override string PageDataSetName
    {
        get { return "DataSetIndividualServiceNotes"; }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentIndividualServiceNoteGenerals,CustomDocumentIndividualServiceNoteDBTs" }; }
    }
}
