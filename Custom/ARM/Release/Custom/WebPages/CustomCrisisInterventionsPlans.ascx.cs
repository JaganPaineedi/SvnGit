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
    public partial class CustomCrisisInterventionsPlans : DataActivityTab
    {
        #region override
        public override void BindControls()
        {
            DynamicFormsCrisisNote.FormId = 5004;
            DynamicFormsCrisisNote.Activate();
        }
       
        #endregion

        //public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        //{
        //    //
        //}


        ///// <summary>
        ///// Purpose - Overridden Add Mandatory Values Function
        ///// </summary>
        ///// <param name="dataRow"></param>
        ///// <param name="tableName"></param>
        //public override void AddMandatoryValues(DataRow dataRowObject, string tableName)
        //{
        //    switch (tableName)
        //    {
        //        case "CustomDocumentPreventionServicesNotes":
        //            //Initialize values for Mandatory fields
        //            break;
        //        default:
        //            break;
        //    }
        //}
    }
}