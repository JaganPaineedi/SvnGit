using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class TwoFactorAuthenticationResponse
{
    public TwoFactorAuthenticationResponse()
    {
    }

    private bool passed;
    private string exceptionMessage;

    public bool Passed
    {
        get { return passed; }
        set { passed = value; }
    }

    public string ExceptionMessage
    {
        get { return exceptionMessage; }
        set { exceptionMessage = value; }
    }


}