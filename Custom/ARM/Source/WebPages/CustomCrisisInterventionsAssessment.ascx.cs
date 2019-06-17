using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data;

namespace SHS.SmartCare
{
    public partial class CustomCrisisInterventionsAssessment : DataActivityTab
    {  
        #region override
        public override void BindControls()
        {
            //object CustomFieldFormId = null;
            DynamicFormsCrisisNote1.FormId = 5003;
            DynamicFormsCrisisNote1.Activate();
            DynamicFormsMentalStatuses.FormId = 58;
            DynamicFormsMentalStatuses.Activate();
            DynamicFormsCrisisNote2.FormId = 5004;
            DynamicFormsCrisisNote2.Activate();
        }
        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "CustomDocumentCrisisInterventionNotes", "CustomDocumentMentalStatuses" };
            }            
        }
                
        #endregion        
    }
}
