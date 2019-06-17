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
using System.Text;

public partial class AssessmentWizard : System.Web.UI.Page
{
    //Declaring Object of Streamline.UserBusinessServices.Assessment
    Streamline.UserBusinessServices.AssessmentWizardNeedList ObjectAssessment = null;
    //Declaring Object of dataset
    DataSet DataSetAssessment = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        ButtonAdd.Attributes.Add("OnClick", "return AddRowToGrid('" + TextBoxNeed.ClientID + "','" + DropDownListStatus.ClientID + "','" + TextBoxDate.ClientID + "','" + TextBoxDiscription.ClientID + "','" + TextBoxComment.ClientID + "','" + CheckBoxComplitedNeeds.ClientID + "','"+DivNeed.ClientID+"','"+HiddenFieldSessionkey.ClientID +"');");
        Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "<script>GetClientId('"+TextBoxNeed.ClientID + "','"+ DropDownListStatus.ClientID +"','"+TextBoxDate.ClientID+"','"+TextBoxDiscription.ClientID+"','"+TextBoxComment.ClientID+"','"+HiddenFieldSessionkey.ClientID +"','"+ButtonAdd.ClientID  +"');</script>");
        if (!IsPostBack)
        {
            this.GetAssessmentData(1,1);
        }
    }
   /// <summary>
   /// Created By Pramod Prakash Mishra
   /// Created On 22 Jan 2008
   /// This Fucntion will Get Data from database according to DocumentId and VersionId
   /// </summary>
   /// <param name="DocumentId"></param>
   /// <param name="VesionId"></param>
    /// <returns>DataSet</returns>
    public DataSet  GetAssessmentData(int DocumentId, int VesionId)
    {
        try
        {
            //Initializing ObjectAssessment with object of Business Layer Assessment Class
            ObjectAssessment = new Streamline.UserBusinessServices.AssessmentWizardNeedList();
            //Initializing DataSetAssessment
            DataSetAssessment = new DataSet();
            DataSetAssessment=  ObjectAssessment.GetAssessment(DocumentId, VesionId);
            //Storing Guid in to HiddenField this Guid will be used as Session key
            if (HiddenFieldSessionkey.Value.Trim().Length < 1)
            {
                HiddenFieldSessionkey.Value = System.Guid.NewGuid().ToString();
            }
            //Storing DataSet into Session for this session key will be DataSet+Hiddenfield.value so that 
            //Session key will be uniqu for every window open by user
            Session["DataSet" + HiddenFieldSessionkey.Value] = DataSetAssessment;
            return DataSetAssessment;
        }
        catch (Exception ex)
        {

            return DataSetAssessment;
        }
        finally
        {
            //Assinging null to ObjectAssessment
            ObjectAssessment = null;

        }

    }
    
   
    
  
    
}
