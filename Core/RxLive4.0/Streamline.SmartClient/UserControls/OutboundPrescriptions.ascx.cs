using Streamline.BaseLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_OutboundPrescriptions : System.Web.UI.UserControl
{
    private String sortExpression = "CreatedDate Desc";
    string RelativePath = "";
    private DataTable outboundPrescriptionDataTable = null;
    private DataTable fillPrescriptionDataTable = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        RelativePath = Page.ResolveUrl("~");
        CommonFunctions.Event_Trap(this);

        string sortField = Request["sortField"] != null ? Request["sortField"].ToString() : sortExpression;
        sortExpression = String.IsNullOrEmpty(sortField) ? sortExpression : sortField;

        if (outboundPrescriptionDataTable != null)
        {
            DataView dvOutboundPrescriptions = outboundPrescriptionDataTable.DefaultView;
            dvOutboundPrescriptions.Sort = sortExpression;

            lvOutBoundPrescriptionList.DataSource = dvOutboundPrescriptions;
            lvOutBoundPrescriptionList.DataBind();
        }


        if (fillPrescriptionDataTable != null)
        {
            DataView dvOutboundPrescriptions = fillPrescriptionDataTable.DefaultView;
            dvOutboundPrescriptions.Sort = sortExpression;

            lvOutBoundPrescriptionList.DataSource = dvOutboundPrescriptions;
            lvOutBoundPrescriptionList.DataBind();
        }
    }

    public DataTable OutboundPrescriptionDataTable
    {
        get { return outboundPrescriptionDataTable; }
        set { outboundPrescriptionDataTable = value; }
    }

    public DataTable FillPrescriptionDataTable
    {
        get { return fillPrescriptionDataTable; }
        set { fillPrescriptionDataTable = value; }
    }
    protected void LayoutCreated(object sender, EventArgs e)
    {
        string[] Sort = sortExpression.Split(' ');

        Panel divHeader = (Panel)lvOutBoundPrescriptionList.FindControl("divHeader");
        foreach (Control ctrl in divHeader.Controls)
        {
            if (ctrl.GetType() == typeof(Panel))
            {
                string SortId = ((Panel)ctrl).Attributes["SortId"];
                if (SortId != null)
                {
                    if (Sort.Length > 0)
                    {
                        if (Sort[0] == SortId)
                        {
                            if (Sort.Length == 1)
                            {
                                ((Panel)ctrl).Attributes.Add("onclick", "SortOutBoundPrescriptionListPage('" + SortId + " Desc');");
                                ((Panel)ctrl).Style.Add("background-image",
                                                         "url('" + RelativePath +
                                                         "App_Themes/Includes/Images/ListPageUp.png'");
                                ((Panel)ctrl).CssClass = "ListSortUp";
                            }
                            else
                            {
                                ((Panel)ctrl).Attributes.Add("onclick", "SortOutBoundPrescriptionListPage('" + SortId + "');");
                                ((Panel)ctrl).Style.Add("background-image",
                                                         "url('" + RelativePath +
                                                         "App_Themes/Includes/Images/ListPageDown.png'");
                                ((Panel)ctrl).CssClass = "ListSortDown";
                            }
                        }
                        else
                        {
                            ((Panel)ctrl).Attributes.Add("onclick", "SortOutBoundPrescriptionListPage('" + SortId + "');");
                        }
                    }
                }
            }
        }
        Panel divContent = (Panel)lvOutBoundPrescriptionList.FindControl("divListPageContent");
        divContent.Attributes.Add("onscroll", "fnScroll('" + divHeader.ClientID + "','" + divContent.ClientID + "');");
    }
}