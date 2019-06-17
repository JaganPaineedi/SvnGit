using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Streamline.DataService;

namespace Streamline.UserBusinessServices
{
    public class UseKeyPhrases : IDisposable
    {
        public DataSet GetKeyPhrases(int StaffId, int ClientId)
        {
            using (DataService.UseKeyPhrases UseKeyPhrases = new DataService.UseKeyPhrases())
            {
                return UseKeyPhrases.GetKeyPhrases(StaffId, ClientId);
            }
        }


        public DataSet GetAgencyPhrasesForSecondTab(int StaffId, int ClientId)
        {
            using (DataService.UseKeyPhrases UseKeyPhrases = new DataService.UseKeyPhrases())
            {
                return UseKeyPhrases.GetAgencyPhrasesForSecondTab(StaffId, ClientId);
            }
        }


        public void Dispose()
        {

        }
    }
}
