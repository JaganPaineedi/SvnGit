using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;

public partial class UseKeyPhrase : Streamline.BaseLayer.ActivityPages.ActivityPage
{

    DataSet dsKeyPhrases = null;

    protected override void Page_Load(object sender, EventArgs e)
    {
        using (Streamline.UserBusinessServices.UseKeyPhrases objUseKeyPhrases = new Streamline.UserBusinessServices.UseKeyPhrases())
        {
            dsKeyPhrases = objUseKeyPhrases.GetKeyPhrases(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            if (dsKeyPhrases != null && dsKeyPhrases.Tables.Count > 0)
            {
                Session["DataSetKeyPhrases"] = dsKeyPhrases;
            }
        }


    }

}