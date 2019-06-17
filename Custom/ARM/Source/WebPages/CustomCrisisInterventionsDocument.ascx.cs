using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data;
namespace SHS.SmartCare
{
    public partial class CustomCrisisInterventionsDocument : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        #region private
        private const string _prefix = "CustomDocumentCrisisInterventionNotes";
        private const string _defaultTab = "/Custom/WebPages/CustomCrisisInterventionsAssessment.ascx";
        private const string _multiTabControlName = "CustomFultonSchoolCrisisNoteDocumentTabPage";
        private const string _dataSetName = "DataSet" + _prefix;
        private string[] _tableNames =   {
            "CustomDocumentCrisisInterventionNotes"
        };
        #endregion

        int formCollectionID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
           // FormCollectionId = 1; 
        }

        #region override
        public override string DefaultTab
        {
            get
            {
                return _defaultTab;
            }
        }

        public override string MultiTabControlName
        {
            get 
            {
                return _multiTabControlName;
            }
        }

        public override string PageDataSetName
        {
            get
            {
                return _dataSetName;
            }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return _tableNames;
            }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            CustomFultonSchoolCrisisNoteDocumentTabPage.ActiveTabIndex = (short)TabIndex;
            ctlcollection = CustomFultonSchoolCrisisNoteDocumentTabPage.TabPages[TabIndex].Controls;
            UcPath = CustomFultonSchoolCrisisNoteDocumentTabPage.TabPages[TabIndex].Name;
            return;
            #region Commented
            //TabIndex = 0;
            //if (ParentDetailPageObject.GetRequestParameterValue("KeyScreenTabIndex") != "")
            //    int.TryParse(ParentDetailPageObject.GetRequestParameterValue("KeyScreenTabIndex"), out TabIndex);

            //CustomFultonSchoolCrisisNoteDocumentTabPage.ActiveTabIndex = (short)TabIndex;
            //ctlcollection = CustomFultonSchoolCrisisNoteDocumentTabPage.TabPages[ TabIndex ].Controls;
            //UcPath = CustomFultonSchoolCrisisNoteDocumentTabPage.TabPages[ TabIndex ].Name;
            #endregion
        }

        public override void BindControls()
        {
           
        }
        
        #endregion

        public override int FormCollectionId
        {
            get
            {
                return formCollectionID;
            }
            set
            {
                formCollectionID=value;
            }

        }

        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            //if (dataSetObject.Tables["CustomDocumentMentalStatuses"].Rows.Count > 0 && 
            //    dataSetObject.Tables["CustomDocumentCrisisInterventionNotes"].Rows.Count>0)
            //{
            //    dataSetObject.Tables["CustomDocumentMentalStatuses"].Rows[0]["DocumentVersionId"] = dataSetObject.Tables["CustomDocumentCrisisInterventionNotes"].Rows[0]["DocumentVersionId"];    
            //}
            
        }

                
       
    }
}