using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Streamline.UserBusinessServices
{
    /// <summary>
    /// Created By Pramod Prakash Mishra
    /// Created On 22 Jan 2008
    /// </summary>
    public class AssessmentWizardNeedList:IDisposable 
    {
        //Declaring Object of Assessment Class of DataAccess Layer
        private Streamline.DataService.AssessmentWizardNeedList ObjectAssessment = null;
        //Constructor of Class will initialize Object of Assessemtn Class of DataAccess Layer
        public AssessmentWizardNeedList()
        {
            ObjectAssessment = new Streamline.DataService.AssessmentWizardNeedList();

        }
        /// <summary>
        /// Created By Pramod Prakash Mishra
        /// Created On 22 Jan 2008
        /// this fucntion will Call a fucntion of DataAccess layer named GetAssessment
        /// </summary>
        /// <param name="DocumentId"></param>
        /// <param name="VersionId"></param>
        /// <returns></returns>
        public DataSet GetAssessment(int DocumentId, int VersionId)
        {
            //Declaring a Dataset 
            DataSet DataSetAssessment = null;
            try
            {
                //Initializing Object of dataset with New Dataset; 
                DataSetAssessment = new DataSet();
                ObjectAssessment = new Streamline.DataService.AssessmentWizardNeedList();
                //Calling DataAssess Layer to GetAssessment records and assign it to DataSetAssessment
                //DataSetAssessment = ObjectAssessment.GetAssessment(DocumentId, VersionId);
                return DataSetAssessment;
            }
            catch (Exception ex)
            {

                return DataSetAssessment;
            }
            finally
            {
                //Sessting ObjectAssessment to null
                ObjectAssessment = null;

            }

        }
        public DataSet UpdateAssessementNeedList(DataSet DataSetAssessmentNeedlist, ref object objTemp)
        {
            try
            {
                System.Collections.Hashtable hsTemp = (System.Collections.Hashtable)objTemp;
                
                 DataSetAssessmentNeedlist.Merge(getDocumentTable(objTemp));
                ObjectAssessment=new Streamline.DataService.AssessmentWizardNeedList();
                return ObjectAssessment.UpdateAssessementNeedList(DataSetAssessmentNeedlist);
                 
            }
            catch (Exception)
            {
                
                throw;
            }
            

        }
        private DataTable getDocumentTable(object objTemp)
        {
            try
            {
                DataTable dtTemp = new DataTable();
                dtTemp.TableName = "Documents";
                System.Collections.Hashtable htTemp = (System.Collections.Hashtable)objTemp;
                foreach (System.Collections.DictionaryEntry dekey in htTemp)
                {
                    dtTemp.Columns.Add(dekey.Key.ToString(), System.Type.GetType("System.String"));
                }
                DataRow dr = dtTemp.NewRow();
                foreach (System.Collections.DictionaryEntry dekey in htTemp)
                {
                    dr[dekey.Key.ToString()] = dekey.Value;
                }
                dtTemp.Rows.Add(dr);
                return dtTemp;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        public void Dispose()
        {
           
        }


    }
}
