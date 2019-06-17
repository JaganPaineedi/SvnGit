using System;
using System.Data;
using System.Collections.Generic;
using System.Text;

namespace Streamline.UserBusinessServices
{
   
    /// <summary>
    /// Created By Pramod Prakash Mishra
    /// On 11 Feb 2008
    /// This Class will Impliment all function that will be required by all Custom Assessment pages.
    /// </summary>
    public class AssessmentCustom : IDisposable
    {
        Streamline.DataService.CommonBase objCommonBase = null;
        Streamline.DataService.AssessmentCustom objAssessmentCustom = null;
       /// <summary>
       /// This Function is called from Symptoms Page for fill DataSetSymptoms
       /// <createdBy>Chandan Srivastava</createdBy>
       /// </summary>
       /// <param name="DocumentId"></param>
       /// <param name="version"></param>
       /// <returns></returns>
       public DataSet FillDataSetSymptoms(int DocumentId, int version)
       {
           DataSet DataSetSymptoms = new DataSet();
           try
           {
               objAssessmentCustom = new Streamline.DataService.AssessmentCustom();
               DataSetSymptoms = objAssessmentCustom.FillDataSetSymptoms(DocumentId, version);
               return DataSetSymptoms;
           }
           catch (Exception ex)
           {
               return null;
           }
       }

       public void Dispose()
       {
           if (objCommonBase != null)
               objCommonBase.Dispose();
       }      
    }
}
