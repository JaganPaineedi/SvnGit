using System;
using System.Web.UI;
using System.Linq;

public partial class UserControls_Heading : UserControl
{
    public string HeadingText { get; set; }

    public string HeadingDetailId { get; set; }
    
    /// <summary>
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        var headingText = HeadingText.Split(',').Select(a =>
                    new { headerLabel = a.Split('#')[0].ToString(), headerItemId = a.Split('#').Length > 1 ? a.Split('#')[1].ToString() : ""  }
            );
        HeaderTdRepeat.DataSource = headingText;
        HeaderTdRepeat.DataBind();
    }
}
