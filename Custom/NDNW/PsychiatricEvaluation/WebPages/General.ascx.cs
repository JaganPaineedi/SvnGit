using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer;
using SHS.DataServices;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricEvaluation_WebPages_General : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public string PrimaryEpisodeWorker = string.Empty;
        public string ClientAge = string.Empty;
        UserControl userControl = null;
        string RelativePath1 = string.Empty;

        public override void BindControls()
        {
            DataSet dataSetClients = new DataSet();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.Text, "SELECT S.lastname + ', ' + S.firstname FROM Staff S WHERE S.StaffId = (SELECT TOP 1 PrimaryClinicianId FROM Clients WHERE ClientId = " + BaseCommonFunctions.ApplicationInfo.Client.ClientId + " AND IsNull(RecordDeleted, 'N') = 'N') AND Isnull(S.RecordDeleted, 'N') = 'N'", dataSetClients, new string[] { "Clients" });
            if (dataSetClients.Tables["Clients"].Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dataSetClients.Tables["Clients"].Rows[0][0].ToString()))
                {
                    PrimaryEpisodeWorker = dataSetClients.Tables["Clients"].Rows[0][0].ToString();
                }
            }

            dataSetClients = new DataSet();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.Text, "select TOP 1 DOB from Clients where ClientId=" + BaseCommonFunctions.ApplicationInfo.Client.ClientId, dataSetClients, new string[] { "Clients" });
            if (dataSetClients.Tables["Clients"].Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dataSetClients.Tables["Clients"].Rows[0][0].ToString()))
                {
                    DateTime bday = Convert.ToDateTime(dataSetClients.Tables["Clients"].Rows[0][0].ToString());
                    DateTime today = DateTime.Today;
                    int age = today.Year - bday.Year;
                    if (bday > today.AddYears(-age)) age--;
                    if (age == 0)
                    {
                        age = ((today.Year - bday.Year) * 12) + today.Month - bday.Month;
                        if (age == 0)
                        {
                            int.TryParse((today - bday).TotalDays.ToString(), out age);
                            if (age > 0)
                            {
                                ClientAge = (age - 1).ToString().Trim() + " Days";
                            }
                            else
                            {
                                ClientAge = "0 Days";
                            }
                        }
                        else
                        {
                            ClientAge = (age).ToString().Trim() + " Months";
                        }
                    }
                    else
                    {
                        ClientAge = age.ToString().Trim() + " Years";
                    }
                }
            }

            RelativePath1 = Page.ResolveUrl("~/");
            userControl = LoadUC("~/Custom/PsychiatricEvaluation/WebPages/ServicesListUC.ascx");
            PnlServiceGrid.Controls.Clear();
            PnlServiceGrid.Controls.Add(userControl);
        }

        public override void CustomAjaxRequest()
        {           
            if (GetRequestParameterValue("CustomAction") == "asc")
            {
                PanelMain.Visible = false;
                string SortCoulmn = string.Empty;
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalHtmlText1 = new Literal();
                Literal literalEnd = new Literal();
                SortCoulmn = GetRequestParameterValue("sortColumn");
                userControl = LoadUC("~/Custom/PsychiatricEvaluation/WebPages/ServicesListUC.ascx", SortCoulmn, "asc");
                PnlSvcGrid.Controls.Clear();
                PnlSvcGrid.Controls.Add(userControl);
            }
            if (GetRequestParameterValue("CustomAction") == "desc")
            {
                PanelMain.Visible = false;
                string SortCoulmn = string.Empty;
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalHtmlText1 = new Literal();
                Literal literalEnd = new Literal();
                SortCoulmn = GetRequestParameterValue("sortColumn");
                userControl = LoadUC("~/Custom/PsychiatricEvaluation/WebPages/ServicesListUC.ascx", SortCoulmn, "desc");
                PnlSvcGrid.Controls.Clear();
                PnlSvcGrid.Controls.Add(userControl);
            }
        }

        private UserControl LoadUC(string LoadUCName, params object[] constructorParameters)
        {
            System.Web.UI.UserControl userControl = null;
            string ucControlPath = string.Empty;

            ucControlPath = LoadUCName;

            List<Type> constParamTypes = new List<Type>();

            foreach (object constParam in constructorParameters)
            {
                constParamTypes.Add(constParam.GetType());
            }

            if (!string.IsNullOrEmpty(ucControlPath))
            {
                userControl = (UserControl)this.Page.LoadControl(ucControlPath);
            }

            ConstructorInfo constructor = userControl.GetType().BaseType.GetConstructor(constParamTypes.ToArray());

            //And then call the relevant constructor
            if (constructor == null)
            {
                throw new MemberAccessException("The requested constructor was not found on : " + userControl.GetType().BaseType.ToString());
            }
            else
            {
                constructor.Invoke(userControl, constructorParameters);
            }

            return userControl;
        }
    }
}