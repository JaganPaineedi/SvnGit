using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace Streamline.BaseLayer
{
    public abstract class StubBase
    {
        public class userInfo
        {

            public virtual  ArrayList GetPermission(int userID)
            {
                return new ArrayList() ;
                
            }

            public virtual ArrayList GetPermission(string userCode)
            {
                return new ArrayList();
            }
        }
    }
}
