using System;
using System.Collections;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Streamline.BaseLayer;
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
    
    
    public static string ToHtmlEncoded(this object value)
    {
        // string returnValue = string.Empty;
        //try/catch block commented by shifali on 01july,2010 in ref to task# 950
        //try
        //{
        return System.Convert.ToString(value);
        //  returnValue = System.Web.HttpUtility.HtmlEncode(System.Convert.ToString(value));
        //.Replace("'", " ");

        //}
        //catch { }
        //return returnValue;

    }

    public static string ToHtmlDecoded(this object value)
    {
        string returnValue = string.Empty;
        //try/catch block commented by shifali on 01july,2010 in ref to task# 950
        //try
        //{
        returnValue = System.Web.HttpUtility.HtmlDecode(System.Convert.ToString(value)).Replace("&#39", "'");
        //}
        //catch { }
        return returnValue;

    }
    
    /// <summary>
    /// Get number of records from top.
    /// Added by Sumanta.
    /// </summary>
    /// <param name="dt"></param>
    /// <param name="rowCount"></param>
    /// <returns></returns>
    public static DataTable SelectTop(this DataTable dt, int rowCount)
    {
        DataTable dtn = dt.Clone();
        for (int i = 0; i < rowCount; i++) { dtn.ImportRow(dt.Rows[i]); }
        return dtn;
    }

    
    public static string ToFormatedDateString(this object rawData)
    {
        string returnValue = string.Empty;
        if (rawData != null)
        {
            returnValue = string.Format("{0:MM/dd/yyyy}", rawData);
        }
        return returnValue;
    }
    /// <summary>
    /// Return the Rendered HTML markup of a contorl.
    /// Added By Sumanta.
    /// </summary>
    /// <param name="control"></param>
    /// <returns></returns>
    public static string GetRenderedHtml(this Control control)
    {
        StringBuilder objStringBuilder = new StringBuilder();
        using (StringWriter objStringWriter = new StringWriter(objStringBuilder))
        {
            using (HtmlTextWriter textwriter = new HtmlTextWriter(objStringWriter))
            {
                control.RenderControl(textwriter);
                return objStringBuilder.ToString();
            }
        }
    }
    
    /// <summary>
    /// <Description>This is used for converting special charater for HTML control values</Description>
    /// <CreatedBy>Rakesh Garg</CreatedBy>
    /// <CreatedDate>28 April 2011</CreatedDate>
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string EncodeForDyanmicHTMLControlValues(this string value)
    {
        return value.Replace("'", "&#39;");
    }

    ///<summary>
    ///<Description>Extension Methods use to serialize a string object into JSON</Description>
    ///<Author>Kneale Alpers</Author>
    ///<CreatedOn>December 7, 2010</CreatedOn>
    ///</summary>
    public static string ToJSON(this object obj)
    {
        return (new System.Web.Script.Serialization.JavaScriptSerializer()).Serialize(obj);
    }

    public static string ToJSON(this object obj, int recursionDepth)
    {
        return (new System.Web.Script.Serialization.JavaScriptSerializer() { RecursionLimit = recursionDepth }).Serialize(obj);
    }

    public static string DataSetExceptionMessage(this DataSet ds)
    {
        StringBuilder errorlist = new StringBuilder();
        foreach (DataTable dt in ds.Tables)
        {
            if (dt.HasErrors)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr.HasErrors)
                    {
                        if (errorlist.Length > 0) { errorlist.Append(", "); } else { errorlist.Append("##DataSetMessage: "); }
                        errorlist.Append(dt.TableName + " #: " + dr.RowError);
                    }
                }
            }
        }
        return errorlist.ToString();
    }

}


