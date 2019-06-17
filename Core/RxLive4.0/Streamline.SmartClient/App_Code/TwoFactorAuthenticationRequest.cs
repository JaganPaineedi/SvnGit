using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class TwoFactorAuthenticationRequest
{
    public TwoFactorAuthenticationRequest()
    {
    }

    private string userID;
    private string password;
    private string otp;

    public string UserID
    {
        get { return userID; }
        set { userID = value; }
    }

    public string Password
    {
        get { return password; }
        set { password = value; }
    }

    public string OTP
    {
        get { return otp; }
        set { otp = value; }
    }


    /// <summary>
    /// Set response value
    /// </summary>
    /// <param name="OTPMessage"></param>
    /// <param name="PWDMessage"></param>
    /// <param name="Passed"></param>
    /// <returns></returns>
    public static TwoFactorAuthenticationResponse SetResponseObjectValues(string OTPMessage, string PWDMessage, bool Passed)
    {
        TwoFactorAuthenticationResponse twoFactorAuthenticationResponse = new TwoFactorAuthenticationResponse();
        twoFactorAuthenticationResponse.Passed = Passed;
        twoFactorAuthenticationResponse.ExceptionMessage = PWDMessage + " - " + OTPMessage;
        return twoFactorAuthenticationResponse;
    }

}
