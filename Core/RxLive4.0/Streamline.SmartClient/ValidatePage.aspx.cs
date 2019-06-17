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

public partial class ValidatePage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Response.Redirect("ValidateToken.aspx?ClientId=38214");
        //Modfied in ref to Task#2700
        Response.Redirect("ValidateToken.aspx?ClientId=" + Request.QueryString["ClientId"] + " &StaffId=" + Request.QueryString["StaffId"]);
        //Response.Redirect("ValidateToken.aspx?ClientId=" + Request.QueryString["ClientId"] + " &StaffId=" + Request.QueryString["StaffId"] + "&QuestionsAnswered=" + Request.QueryString["QuestionsAnswered"]);
    }
}
