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
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;

public partial class UserControls_HealthGraph : Streamline.BaseLayer.BaseActivityPage
{
    public string ListStartDate = "";
    public string ListEndDate = "";
    Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ListEndDate = DateTime.Now.ToShortDateString();
            ListStartDate = DateTime.Now.AddYears(-1).ToShortDateString();
            TextBoxStartDate.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            TextBoxEndDate.Text = DateTime.Now.ToShortDateString();
            //Added By Priya Ref:task No:3000
            DropDownHealthDataListGraph.Attributes.Add("onchange", "GetHealthGraph('" + PanelGraphListInformation.ClientID + "','" + DropDownHealthDataListGraph.ClientID + "','" + TextBoxStartDate.ClientID + "','" + TextBoxEndDate.ClientID + "', '" + LabelError.ClientID + "');" );
            //ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), this.ClientID, "GetHealthGraph('" + PanelGraphListInformation.ClientID + "','" + DropDownHealthDataListGraph.ClientID + "','" + TextBoxStartDate.ClientID + "','" + TextBoxEndDate.ClientID + "', '" + LabelError.ClientID + "');", true);
        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
    }

    public override void Activate()
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            base.Activate();
        }
        catch (Exception ex)
        {

            throw;
        }

    }

    private void BindHealthDataGraphDropDown()
    {
        DataSet _DataSetHealthDataListGraph = null;
        _DataSetHealthDataListGraph = new DataSet();
        int ClientId = 0;
        ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
        objectClientMedications = new ClientMedication();
        try
        {
            _DataSetHealthDataListGraph = objectClientMedications.GetHeathDataGraphDropDown(ClientId);
            if (_DataSetHealthDataListGraph.Tables["HealthDataListGraph"].Rows.Count > 0)
            {
                DataView dataViewgraph = _DataSetHealthDataListGraph.Tables["HealthDataListGraph"].DefaultView;
                dataViewgraph.Sort = "ItemDescription ASC";
                DropDownHealthDataListGraph.DataValueField = "HealthDataCategoryId";
                DropDownHealthDataListGraph.DataTextField = "ItemDescription";
                DropDownHealthDataListGraph.DataSource = dataViewgraph;
                DropDownHealthDataListGraph.DataBind();
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            throw (ex);
        }
    }





}
