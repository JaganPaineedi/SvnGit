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

public partial class PermissionsAvailableList : System.Web.UI.Page
      {       
      protected void Page_Load(object sender, EventArgs e)
        {
        Cache.Remove("DataSetSystemActions");
        if (!IsPostBack)
              {
              HiddenFieldCheckedStaffValues.Value = string.Empty; 
             BindGridView();      
          }
        }          

    private void BindGridView()
        {
        DataSet DataSetSystemActions = null;
        try
            {
            DataSetSystemActions = new DataSet();
            //Code Added to not to display Permissions already user had or chosen.
            if (Session["Permissions"] != null && Session["Permissions"].ToString()!="" )
                {               
                DataRow[] _DataRowPermissions = null;
                _DataRowPermissions = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId  NOT IN (" + Session["Permissions"] + ")");
                if(_DataRowPermissions.Length>0)
                DataSetSystemActions.Merge(_DataRowPermissions);
                }
            else
                DataSetSystemActions = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions;
            if (DataSetSystemActions.Tables.Count > 0)
                {
                GridViewSystemActions.DataSource = DataSetSystemActions;
                GridViewSystemActions.DataBind();
                
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
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        finally
            {
            DataSetSystemActions = null;
            }
        }
    protected void GridViewSystemActions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            UserPrefernces objUserPreferences = new UserPrefernces();
        
        try
            {
              var EPCSAssignor = Session["EPCSAssignor"];
              var PrescriberStaffId = Session["StaffIdForPreferences"];
            if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    string value = ((Label)(e.Row.FindControl("LabelActionId"))).Text;
                        e.Row.Attributes.Add("id", e.Row.RowIndex.ToString());
                        e.Row.Attributes.Add("title", value);
                       ((CheckBox)e.Row.FindControl("CheckBoxSystemActions")).Attributes.Add("onclick", "GetRowValueOnCheckBoxCheck('" + value + "', '" + ((CheckBox)e.Row.FindControl("CheckBoxSystemActions")).ClientID + "');");
                    if (value == "10074")
                        {
                        // To Disable the EPCS Checkbox
                            DataSet dsEPCS = objUserPreferences.CheckForEPCS(Int32.Parse(EPCSAssignor.ToString()), Int32.Parse(PrescriberStaffId.ToString()));
                            DataTable dtEPCS = dsEPCS.Tables["EPCSPermissions"];
                            string tempEPCS = dtEPCS.Rows[0][0].ToString();
                            if (tempEPCS != "Y")
                            {
                              string g = "disabled";
                              ((CheckBox)e.Row.FindControl("CheckBoxSystemActions")).InputAttributes.Add("disabled", g);
                            }
                        }
                   //((CheckBox)e.Row.FindControl("CheckBoxSystemActions")).Attributes.Add("onclick", "GetRowValueOnCheckBoxCheck('" + value + "', '" + ((CheckBox)e.Row.FindControl("CheckBoxSystemActions")).ClientID + "');");
                    
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
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }
    }
