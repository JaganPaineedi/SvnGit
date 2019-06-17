using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using System.Reflection;

public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    UserControl userControl = null;
    string RelativePath1 = string.Empty;
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricServiceNoteGenerals" };
        }
    }
    public override void BindControls()
    {
        RelativePath1 = Page.ResolveUrl("~/");
        userControl = LoadUC("~/Custom/PsychiatricService/WebPages/ServicesListUC.ascx");
        PnlServiceGrid.Controls.Clear();
        PnlServiceGrid.Controls.Add(userControl);

    }
    private UserControl LoadUC(string LoadUCName, params object[] constructorParameters)
    {
        System.Web.UI.UserControl userControl = null;
        string ucControlPath = string.Empty;

        ucControlPath = LoadUCName;

        List<Type> constParamTypes = new List<Type>();

        foreach (object constParam in constructorParameters)
        {
            constParamTypes.Add(constParam.GetType());
        }

        if (!string.IsNullOrEmpty(ucControlPath))
        {
            userControl = (UserControl)this.Page.LoadControl(ucControlPath);
        }

        ConstructorInfo constructor = userControl.GetType().BaseType.GetConstructor(constParamTypes.ToArray());

        //And then call the relevant constructor
        if (constructor == null)
        {
            throw new MemberAccessException("The requested constructor was not found on : " + userControl.GetType().BaseType.ToString());
        }
        else
        {
            constructor.Invoke(userControl, constructorParameters);
        }

        return userControl;
    }

    public override void CustomAjaxRequest()
    {
       
        if (GetRequestParameterValue("CustomAction") == "asc")
        {
            PanelMain.Visible = false;
            string SortCoulmn = string.Empty;
            Literal literalStart = new Literal();
            Literal literalHtmlText = new Literal();
            Literal literalHtmlText1 = new Literal();
            Literal literalEnd = new Literal();
            SortCoulmn = GetRequestParameterValue("sortColumn");
            userControl = LoadUC("~/Custom/PsychiatricService/WebPages/ServicesListUC.ascx",SortCoulmn, "asc");
            PnlSvcGrid.Controls.Clear();
            PnlSvcGrid.Controls.Add(userControl);
        }
        if (GetRequestParameterValue("CustomAction") == "desc")
        {
            PanelMain.Visible = false;
            string SortCoulmn = string.Empty;
            Literal literalStart = new Literal();
            Literal literalHtmlText = new Literal();
            Literal literalHtmlText1 = new Literal();
            Literal literalEnd = new Literal();
            SortCoulmn = GetRequestParameterValue("sortColumn");
            userControl = LoadUC("~/Custom/PsychiatricService/WebPages/ServicesListUC.ascx",SortCoulmn, "desc");
            PnlSvcGrid.Controls.Clear();
            PnlSvcGrid.Controls.Add(userControl);
        }
    }

}
