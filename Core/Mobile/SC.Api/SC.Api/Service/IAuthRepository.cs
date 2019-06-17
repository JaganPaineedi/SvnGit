using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IAuthRepository
    {
        Task<Staff> FindSCUser(string userName, string password);

        Task<Staff> ValidateSmartKey(UserModel usermodel);
    }
}
