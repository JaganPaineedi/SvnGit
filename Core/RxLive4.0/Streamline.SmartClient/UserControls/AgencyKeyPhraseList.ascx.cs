using System;
using System.Collections;
using System.Data;
using System.Drawing;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using SharedTables = Streamline.UserBusinessServices.SharedTables;
namespace Streamline.SmartClient.UI
{
    public partial class UserControls_AgencyKeyPhraseList : BaseActivityPage
    {


        private DataSetKeyPhrases.AgencyKeyPhrasesDataTable _dtAgencyKeyPhrasesTemp;

        private bool _Category = true;
        private bool _Phrases = true;

        private bool _favorite = true;
        private bool _showCheckBox = true;

        private string _sortString;
        private bool _showRadioButton;
        private string method = "";

        public bool Category
        {
            get { return _Category; }
            set { _Category = value; }
        }

        public bool Phrases
        {
            get { return _Phrases; }
            set { _Phrases = value; }
        }

        public string SortString
        {
            get { return _sortString; }
            set { _sortString = value; }
        }
        public bool Favorite
        {
            get { return _favorite; }
            set { _favorite = value; }
        }


        public bool ShowRadioButton
        {
            get { return _showRadioButton; }
            set { _showRadioButton = value; }
        }


        public Panel GetMedicationListPanel
        {
            get { return PanelPhrasesList; }
        }

        private string _calledFromControllerName = "";


        public void Activate(string controllerName)
        {
            _calledFromControllerName = controllerName;
            Activate();
        }

        public override void Activate()
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                base.Activate();
                _dtAgencyKeyPhrasesTemp = new DataSetKeyPhrases.AgencyKeyPhrasesDataTable();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        public void GenerateAgencyKeyPhrasesControlRows(DataView dvAgencyKeyPhrases)
        {
            try
            {
                // Set the control generation variables...
                _showRadioButton = true;
                _Category = true;
                _Phrases = true;
                _favorite = true;

                // Create the data table to be binded...
                CompileNewAgencyKeyPhrasesDataTable(dvAgencyKeyPhrases);

                // Generate the Agency KeyPhrase Rows...
                GenerateAgencyKeyPhrasesHeaderRow();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        private void CompileNewAgencyKeyPhrasesDataTable(DataView dvAgencyKeyPhrases)
        {
            try
            {
                
                // Get the data table from the given views
                DataTable dtAgencyKeyPhrases = dvAgencyKeyPhrases.Table.Copy();
                CompileAgencyKeyPhrasesDataTable(dtAgencyKeyPhrases);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void CompileAgencyKeyPhrasesDataTable(DataTable dtAgencyKeyPhrases)
        {
            try
            {
             
              foreach (DataRow drAgencyKeyPhrases in dtAgencyKeyPhrases.Rows)
                {
                    if (drAgencyKeyPhrases["RecordDeleted"] == DBNull.Value || drAgencyKeyPhrases["RecordDeleted"].ToString() == "N")
                    {
                        string AgencyKeyPhraseId = drAgencyKeyPhrases["AgencyKeyPhraseId"].ToString();
                        Int32 KeyPhraseCategory = Convert.ToInt32(drAgencyKeyPhrases["KeyPhraseCategory"].ToString());
                        string KeyPhraseCategoryName = drAgencyKeyPhrases["KeyPhraseCategoryName"].ToString();

                        string PhraseText = drAgencyKeyPhrases["PhraseText"].ToString();
                        string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string CreatedDate = DateTime.Now.ToShortDateString();
                        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string ModifiedDate = DateTime.Now.ToShortDateString();

                        _dtAgencyKeyPhrasesTemp.Rows.Add(new object[]
                            {
                                AgencyKeyPhraseId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, DBNull.Value,
                                DBNull.Value, DBNull.Value,KeyPhraseCategory,PhraseText,KeyPhraseCategoryName
                               
                            });
                    }
                }
         }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        private string setAttributes()
        {
            if (_sortString == "")
            {
                return "";
            }
            else if (_sortString.Contains("Desc"))
            {
                return "Asc";
            }
            else if (_sortString.Contains("Asc"))
            {
                return "Desc";
            }
            else
            {
                return "";
            }
        }
        private void GenerateAgencyKeyPhrasesHeaderRow()
        {
            
            try
            {
                CommonFunctions.Event_Trap(this);

                Color[] _color =
                    {
                        Color.Pink,
                        Color.Red,
                        Color.Yellow,
                        Color.Green,
                        Color.Plum,
                        Color.Aqua,
                        Color.PaleGoldenrod,
                        Color.Peru,
                        Color.Tan,
                        Color.Khaki,
                        Color.DarkGoldenrod,
                        Color.Maroon,
                        Color.OliveDrab,
                        Color.Crimson,
                        Color.Beige,
                        Color.DimGray,
                        Color.ForestGreen,
                        Color.Indigo,
                        Color.LightCyan
                    };


                PanelPhrasesList.Controls.Clear();
                var tblMedication = new Table();
                tblMedication.ID = Guid.NewGuid().ToString();


                tblMedication.Width = new Unit(100, UnitType.Percentage);
                var thTitle = new TableHeaderRow();
                var thcBlank1 = new TableHeaderCell();
                thcBlank1.Width = 24;
                var thcBlank2 = new TableHeaderCell();
                var thcBlank3 = new TableHeaderCell();
                var thcBlank4 = new TableHeaderCell();

                var thcCategory = new TableHeaderCell();
                thcCategory.Text = "Category";
                thcCategory.Font.Underline = true;
                thcCategory.Attributes.Add("onClick", "onHeaderClick(this)");
                thcCategory.Attributes.Add("ColumnName", "KeyPhraseCategory");
                // thcCategory.Attributes.Add("SortOrder", setAttributes());
                thcCategory.Style.Add("width", "32%");


                if (_dtAgencyKeyPhrasesTemp.Rows.Count > 0)
                    thcCategory.CssClass = "handStyle";

                var thcPhrases = new TableHeaderCell();
                thcPhrases.Text = "Phrases";
                thcPhrases.Font.Underline = true;
                thcPhrases.Attributes.Add("onClick", "onHeaderClick(this)");
                thcPhrases.Attributes.Add("ColumnName", "PhraseText");
                // thcPhrases.Attributes.Add("SortOrder", setAttributes());
                thcPhrases.Style.Add("width", "60%");
                if (_dtAgencyKeyPhrasesTemp.Rows.Count > 0)
                    thcPhrases.CssClass = "handStyle";

                if (_showRadioButton)
                    thTitle.Cells.Add(thcBlank1);

                if (_showCheckBox)
                    thTitle.Cells.Add(thcBlank2);

                if (_Category)
                    thTitle.Cells.Add(thcCategory);

                if (_Phrases)
                    thTitle.Cells.Add(thcPhrases);

                thTitle.CssClass = "GridViewHeaderText";

                tblMedication.Rows.Add(thTitle);

                if (_dtAgencyKeyPhrasesTemp.Rows.Count > 0)
                {
                    foreach (DataRow drMedication in _dtAgencyKeyPhrasesTemp.Rows)
                    {
                        string AgencyKeyPhraseId = drMedication["AgencyKeyPhraseId"].ToString();
                        Int32 KeyPhraseCategory = Convert.ToInt32(drMedication["KeyPhraseCategory"].ToString());
                        string KeyPhraseCategoryName = drMedication["KeyPhraseCategoryName"].ToString();
                        string PhraseText = drMedication["PhraseText"].ToString();
                        string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string CreatedDate = DateTime.Now.ToShortDateString();
                        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string ModifiedDate = DateTime.Now.ToShortDateString();

                        DataRow[] drMedInstructions;

                        drMedInstructions = _dtAgencyKeyPhrasesTemp.Select("AgencyKeyPhraseId=" + AgencyKeyPhraseId);

                        foreach (DataRow drTemp in drMedInstructions)
                        {
                           
                            tblMedication.Rows.Add(GenerateAgencyKeyPhrasesBodyRows(drTemp, tblMedication.ClientID,AgencyKeyPhraseId,
                                                                  KeyPhraseCategory, PhraseText, CreatedBy,
                                                                   CreatedDate, ModifiedBy, ModifiedDate, KeyPhraseCategoryName));

                        }
                            PanelPhrasesList.Controls.Add(tblMedication);
                       
                    }
                }
              
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        private TableRow GenerateAgencyKeyPhrasesBodyRows(DataRow drTemp, string tableId, string AgencyKeyPhraseId, Int32 KeyPhraseCategory, string PhraseText,
                                      string CreatedBy, string CreatedDate, string ModifiedBy,
                                      string ModifiedDate, string KeyPhraseCategoryName)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = Guid.NewGuid().ToString();
                int AgencyKeyPhraseid = Convert.ToInt32(drTemp["AgencyKeyPhraseId"]);
               string tblId = ClientID + ClientIDSeparator + tableId;
                var trTemp = new TableRow();
                trTemp.ID = "Tr_" + newId;
                int client = ((StreamlinePrinciple)Context.User).Client.ClientId;
                var tdKeyPhraseCategory = new TableCell();
                var tdDelete = new TableCell();
                var imgTemp = new HtmlImage();
                var tdRadioButton = new TableCell();
                string rowId = ClientID + ClientIDSeparator + trTemp.ClientID;
                var rbTemp = new HtmlInputRadioButton();
                rbTemp.Attributes.Add("onClick", "ModifyAgencyKeyPhraseList(" + AgencyKeyPhraseId + ")");
                rbTemp.Attributes.Add("class", "handStyle");
       
                imgTemp.ID = "Img_" + AgencyKeyPhraseId.ToString();
                imgTemp.Attributes.Add("AgencyKeyPhraseid", drTemp["AgencyKeyPhraseid"].ToString());
                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgTemp.Attributes.Add("title", "Delete Phrase");
                imgTemp.Attributes.Add("onClick", "DeleteFromAgencyKeyPhraseList(" + AgencyKeyPhraseId + ")");
                imgTemp.Attributes.Add("class", "handStyle");

                tdDelete.Controls.Add(imgTemp);
                tdDelete.Style.Add("width", "4%");
                tdKeyPhraseCategory.Text = KeyPhraseCategoryName;
                tdKeyPhraseCategory.Style.Add("text-align", "center");
                var tdPhraseText = new TableCell();
                tdPhraseText.ToolTip = PhraseText;
                string s = AgencyEllipsis(PhraseText);
                tdPhraseText.Text = s;
                tdPhraseText.Style.Add("text-align", "left");

                var tdDAW = new TableCell();
                tdRadioButton.Controls.Add(rbTemp);
                tdRadioButton.Style.Add("width", "4%");
                trTemp.Cells.Add(tdRadioButton);
            
                trTemp.Cells.Add(tdDelete);
                trTemp.Cells.Add(tdKeyPhraseCategory);
                trTemp.Cells.Add(tdPhraseText);
                trTemp.Cells.Add(tdDAW);
                trTemp.CssClass = "GridViewRowStyle";
                return trTemp;
            }

            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        static public string AgencyEllipsis(string text)
        {
            Int32 length = 100;
            if (text.Length <= length) return text;
            int pos = text.IndexOf(" ", length);
            if (pos >= 0)
                return text.Substring(0, pos) + "...";
            return text;
        }        
    public string KeyPhraseCategoryName { get; set; }
    }

}
