<%@ WebHandler Language="C#" Class="InvoluntaryServices" %>

using System;
using System.Web;
using System.Data;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data.Linq.SqlClient;
using System.Data.SqlClient;
using SHS.BaseLayer;
using SHS.DataServices;
using Microsoft.ApplicationBlocks.Data;

public class InvoluntaryServices : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        string functionName = context.Request.Form["FunctionName"];
         if (!functionName.IsNullOrWhiteSpace())
        {
            switch (functionName.Trim())
            {
                case "SetInvoluntaryServicesCommittedDropDown":
                    int HearingRecommendedGlobalCodeId = 0;
                    int.TryParse(context.Request.Form["HearingRecommendedGlobalCodeId"].ToString(), out HearingRecommendedGlobalCodeId);
                    int Committed = GetCommittedValueByGlobalCode(HearingRecommendedGlobalCodeId);
                    context.Response.Clear();
                    context.Response.Write(Committed);
                    context.Response.End();
                    break;
                     default:
                    break;
            }
        }
    }

    private int GetCommittedValueByGlobalCode(int HearingRecommendedId)
    {
        DataTable datasetGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DataRow[] dataRowGlobalCodes = datasetGlobalCodes.Select("Category= 'XInHearingRecommend' AND Active='Y' AND ISNULL(RecordDeleted,'N')='N' AND GlobalCodeId=" + HearingRecommendedId);
        int CommittedGlobalCodeId = 0;
        if (dataRowGlobalCodes.Count() > 0)
        {
            string strCode = dataRowGlobalCodes[0][21].ToString();
            if (strCode == "1" || strCode == "2" || strCode == "3" || strCode == "6")
            {
                DataRow[] dataRowCommittedGlobalCodes = datasetGlobalCodes.Select("Category= 'XInCommitted' AND Active='Y' AND ISNULL(RecordDeleted,'N')='N' AND Code='N'");
                if (dataRowCommittedGlobalCodes.Count() > 0)
                    CommittedGlobalCodeId = Convert.ToInt32(dataRowCommittedGlobalCodes[0][0]);
            }
        }

        return CommittedGlobalCodeId;
    }
       
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}