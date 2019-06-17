using System;
using System.Collections;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Text;
using System.IO;
/// <summary>
/// This class is used for Extension methods
/// Author/Modified by - Sumanta Chatterjee
/// Date of Creation - 5/Feb/2010
/// </summary>
public static class ExtensionMethods
{
    /// <summary>
    /// Check the string contain null or white space. 
    /// Available in C# 4.0. 
    /// Added by Sumanta.
    /// </summary>
    /// <param name="stringValue"></param>
    /// <returns></returns>
    public static bool IsNullOrWhiteSpace(this string stringValue)
    {
        return String.IsNullOrEmpty(stringValue) || stringValue.Trim().Length == 0;

    }
    /// <summary>
    /// Get string to pass in javascript function as an argument.
    /// Need to decode the text in client side with unescape command.
    /// Added By Sumanta.
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string EncodeForJs(this object value)
    {
        if (Convert.ToString(value).IsNullOrWhiteSpace()) return Convert.ToString(value);
        return System.Web.HttpContext.Current.Server.UrlEncode(Convert.ToString(value).Trim())
            .Replace("+", " ")
            .Replace("'", "%27")
            .Replace("(", "%28")
            .Replace(")", "%29")
            .Replace("<", "&#60;")
            .Replace(">", "&#62;")
            ;
    }

}

