using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;
using System.Collections.Generic;
using System.Reflection;

namespace SHS.SmartCare
{
    public partial class Disposition : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            //throw new NotImplementedException();
            LoadDispositionControl();
        }


        private void LoadDispositionControl()
        {
            int documentVersionId = -1;
            documentVersionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
            UserControl userControl = LoadUC("~/CommonUserControls/DispositionProviderServiceType.ascx", true, 0, documentVersionId);
            MainPanelUC.Controls.Add(userControl);
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