using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MedlinePlusLib;

public partial class EducationInformationView : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var infoData = "";
        switch (Request.QueryString["Type"])
        {
            case "ICD":
                infoData = ConnectMedlinePlus.getProblemCode(Request.QueryString["ICDCode"], ConnectMedlinePlus.PCCodeSystem.ICD9CM, ConnectMedlinePlus.Language.English).ToString();
                break;
            case "ICD10":
                infoData = ConnectMedlinePlus.getProblemCode(Request.QueryString["ICDCode"], ConnectMedlinePlus.PCCodeSystem.ICD10CM, ConnectMedlinePlus.Language.English).ToString();
                break;
            case "NDC":
                infoData = ConnectMedlinePlus.getDrugInfoByCode(Request.QueryString["NDCCode"], ConnectMedlinePlus.DICodeSystem.NDC, ConnectMedlinePlus.Language.English).ToString();
                break;
            case "LOINC":
                infoData = ConnectMedlinePlus.getLabTestInfo(Request.QueryString["LOINCCode"], ConnectMedlinePlus.LTCodeSystem.LOINC, ConnectMedlinePlus.Language.English).ToString();
                break;
            default:
                break;
        }

        Dictionary<string, string> replacements = new Dictionary<string, string>(){
               {"<entry>", "<entry>&lt;div id=divAnchorTag&gt;"},
    {"<title", "&lt;p&gt;<title"},
    {"<subtitle", "&lt;p&gt;<subtitle"},
    {"<author", "&lt;p&gt;<author"},
    {"<uri", "&lt;p&gt;<uri"},
    {"</title>", "</title>&lt;/p&gt;"},
    {"</subtitle>", "</subtitle>&lt;/p&gt;"},
    {"</author>", "</author>&lt;/p&gt;"},
    {"</uri>", "</uri>&lt;/p&gt;"},
    {"<link", "<a id=aLinkResource"},
    {"</entry>", "&lt;/div&gt;</entry>"},

};

        foreach (string key in replacements.Keys)
        {
            infoData = infoData.Replace(key, replacements[key]);
        }
        Label1.Text = infoData;
    }
}