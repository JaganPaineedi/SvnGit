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

public partial class YesNo : System.Web.UI.Page
{
    const int Textcuttorlenth=40;
    protected void Page_Load(object sender, EventArgs e)
    {
        ButtonNo.Visible = true;
        ButtonYes.Value = "Yes";
       
        if (Request.QueryString["CalledFrom"] == "Prescribe")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to cancel this order?<BR>If you click Yes, all medication entries listed below will be discarded";
            
        }
        else if (Request.QueryString["CalledFrom"] == "Order")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to cancel this order?<BR> If you click Yes, all medication entries listed below will be discarded";
        }
        else if (Request.QueryString["CalledFrom"] == "Nonorder")
        {
            SpanConfirm.InnerHtml = "Do you want to save these changes?";
        }
        else if (Request.QueryString["CalledFrom"] == "PatientOverView")
        {
            SpanConfirm.InnerHtml = "Do you wish to save your changes?";
        }
        else if (Request.QueryString["CalledFrom"] == "PatientConsent")
        {
            SpanConfirm.InnerHtml = "Are you sure you wish to revoke the consent?";
        }
        else if (Request.QueryString["CalledFrom"] == "Queuedorder")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to void this order?<BR> If you click Yes, order will be discarded";
        }
        else if (Request.QueryString["CalledFrom"] == "MedicationMgt")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to Discontinue this Medication?";
        }
        else if (Request.QueryString["CalledFrom"] == "MedicationList")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "MedicationListNonOrder")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "PharmaciesList")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "PrintList")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "TitrationUseTemplate")
        {
             SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "VerbalOrdersReview")
        {
            SpanConfirm.InnerHtml = "There are approved orders that have not been signed yet. Would you still like to Close the page?";
        }
        else if (Request.QueryString["CalledFrom"] == "ClienMedicationOrderSDate")
        {
            SpanConfirm.InnerHtml = "Apply this date change to other items in the list?";
        }
        else if (Request.QueryString["CalledFrom"] == "ClientTitrationList")
        {
            SpanConfirm.InnerHtml = "Do you wish to clear all steps for the titration/taper?";
        }
        else if (Request.QueryString["CalledFrom"] == "Assessment")
        {
            SpanConfirm.InnerHtml = "Do you want to delete ?";
        }
        else if (Request.QueryString["CalledFrom"] == "MClientPersonalInfo")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to Delete this Record from Patient Allergies?";
        }
        else if (Request.QueryString["CalledFrom"] == "HealthRecordDelete")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "ClientPersonalHealthData")
        {
            SpanConfirm.InnerHtml = "Are you sure you wish to continue?";
        }
        else if (Request.QueryString["CalledFrom"] == "TitrationTemplate")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to delete this row?";
        }
        else if (Request.QueryString["CalledFrom"] == "UserPreferenceDeleteUser")
        {
            SpanConfirm.InnerHtml = "Are you sure to Delete this User";
        }
        else if (Request.QueryString["CalledFrom"].Trim().IndexOf("^") > 0)
        {
            
              string[] ValidationMessageStatus=Request.QueryString["CalledFrom"].ToString().Trim().Split('^');
              if(ValidationMessageStatus.Length>0)
                {
                    if (ValidationMessageStatus[0].ToUpper() == "ORDERPAGE" && ValidationMessageStatus[1] != string.Empty)
                    {
                       ButtonNo.Visible = false;
                       ButtonYes.Value = "Ok";
                       if (ValidationMessageStatus[1].Length>40)
                        {
                            SpanConfirm.InnerHtml =ValidationMessageStatus[1];
                        }
                       if (ValidationMessageStatus.Length > 2 && ValidationMessageStatus[2].Length > 0)
                       {
                           Title = ValidationMessageStatus[2];
                       }
                       
                     }
                }

        }
        else if (Request.QueryString["CalledFrom"] == "UserPreferances")
        {
            SpanConfirm.InnerHtml = "Are you sure you want to close? If you click Yes, all changes made by you will be discarded.";
        }
        else if (Request.QueryString["CalledFrom"] == "ChangeOrderControlDrugAlert")
        {
            SpanConfirm.InnerHtml = "The selected medication list contains controlled drug. The order cannot be changed.";
        }
        
    }
   
    
}
