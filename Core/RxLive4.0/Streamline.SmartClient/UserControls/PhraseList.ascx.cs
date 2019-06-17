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
    public partial class UserControls_PhraseList : BaseActivityPage
    {
  
        private DataSetKeyPhrases.KeyPhrasesDataTable _dtKeyPhraseTemp;

        private bool _Category = true;
        private bool _Phrases = true;

        private bool _favorite = true;
        private bool _showCheckBox = true;

        private string _sortString;
        private bool _showRadioButton;

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
                _dtKeyPhraseTemp = new DataSetKeyPhrases.KeyPhrasesDataTable();

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

        public void GenerateKeyPhraseRows(DataView dvKeyPhrase)
        {
            try
            {
                _showRadioButton = true;
                _Category = true;
                _Phrases = true;
                _favorite = true;
                CompileKeyPhraseDataTable(dvKeyPhrase);

                // Generate the KeyPhrase HeaderRows...
                GenerateKeyPhraseHeaderRows();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        private void CompileKeyPhraseDataTable(DataView dvKeyPhrase)
        {
            try
            {
                DataTable dtPhrases = dvKeyPhrase.Table.Copy();
                CompileDataTable(dtPhrases);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private void CompileDataTable(DataTable dtPhrases)
        {
            try
            {
                foreach (DataRow drPhrases in dtPhrases.Rows)
                {
                    if (drPhrases["RecordDeleted"] == DBNull.Value || drPhrases["RecordDeleted"].ToString() == "N")
                    {
                        string KeyPhraseId = drPhrases["KeyPhraseId"].ToString();
                        Int32 StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        Int32 KeyPhraseCategory = Convert.ToInt32(drPhrases["KeyPhraseCategory"].ToString());
                        string KeyPhraseCategoryName = drPhrases["KeyPhraseCategoryName"].ToString();

                        string PhraseText = drPhrases["PhraseText"].ToString();

                        string Favorite = "N";

                        if (dtPhrases.Columns.Contains("Favorite"))
                        {
                            Favorite = drPhrases["Favorite"] == DBNull.Value
                                               ? "N"
                                               : drPhrases["Favorite"].ToString();
                        }
                        string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                        string CreatedDate = DateTime.Now.ToShortDateString();
                        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string ModifiedDate = DateTime.Now.ToShortDateString();

                        _dtKeyPhraseTemp.Rows.Add(new object[]
                            {
                                KeyPhraseId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, DBNull.Value,
                                DBNull.Value, DBNull.Value,StaffId,KeyPhraseCategory,Favorite,PhraseText,KeyPhraseCategoryName
                               
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
        private void GenerateKeyPhraseHeaderRows()
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
                var tblKeyPhrase = new Table();
                tblKeyPhrase.ID = Guid.NewGuid().ToString();


                tblKeyPhrase.Width = new Unit(100, UnitType.Percentage);
                var thTitle = new TableHeaderRow();
                var thcBlank1 = new TableHeaderCell();
                thcBlank1.Width = 5;
                var thcBlank2 = new TableHeaderCell();
                thcBlank2.Width = 5;

                var thcCategory = new TableHeaderCell();
                thcCategory.Text = "Category";
                thcCategory.Font.Underline = true;
                thcCategory.Attributes.Add("onClick", "onHeaderClick(this)");
                thcCategory.Attributes.Add("ColumnName", "KeyPhraseCategory");
                // thcCategory.Attributes.Add("SortOrder", setAttributes());
                thcCategory.Style.Add("width", "20%");
                if (_dtKeyPhraseTemp.Rows.Count > 0)
                    thcCategory.CssClass = "handStyle";


                var thcPhrases = new TableHeaderCell();
                thcPhrases.Text = "Phrases";
                thcPhrases.Font.Underline = true;
                thcPhrases.Attributes.Add("onClick", "onHeaderClick(this)");
                thcPhrases.Attributes.Add("ColumnName", "PhraseText");
                // thcPhrases.Attributes.Add("SortOrder", setAttributes());
                thcPhrases.Style.Add("width", "40%");
                //Added bt Loveena on 05-Jan-2009
                if (_dtKeyPhraseTemp.Rows.Count > 0)
                    thcPhrases.CssClass = "handStyle";

                var thcFavourite = new TableHeaderCell();

                thcFavourite.Text = "Favorite";
                thcFavourite.Style.Add("width", "30%");
                thcFavourite.Style.Add("text-align", "center");
                thcFavourite.Font.Underline = true;
                thcFavourite.Attributes.Add("onClick", "onHeaderClick(this)");
                thcFavourite.Attributes.Add("ColumnName", "Favorite");
                //thcFavourite.Attributes.Add("SortOrder", setAttributes());

                if (_dtKeyPhraseTemp.Rows.Count > 0)
                    thcFavourite.CssClass = "handStyle";

                if (_showRadioButton)
                    thTitle.Cells.Add(thcBlank1);
                if (_showCheckBox)
                    thTitle.Cells.Add(thcBlank2);

                if (_Category)
                    thTitle.Cells.Add(thcCategory);

                if (_Phrases)
                    thTitle.Cells.Add(thcPhrases);

                if (_favorite)
                    thTitle.Cells.Add(thcFavourite);

                thTitle.CssClass = "GridViewHeaderText";

                tblKeyPhrase.Rows.Add(thTitle);

                if (_dtKeyPhraseTemp.Rows.Count > 0)
                {
                    foreach (DataRow drMedication in _dtKeyPhraseTemp.Rows)
                    {
                        string KeyPhraseId = drMedication["KeyPhraseId"].ToString();
                        Int32 StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        Int32 KeyPhraseCategory = Convert.ToInt32(drMedication["KeyPhraseCategory"].ToString());
                        string KeyPhraseCategoryName = drMedication["KeyPhraseCategoryName"].ToString();

                        string PhraseText = drMedication["PhraseText"].ToString();

                        string Favorite = "N";

                        if (_dtKeyPhraseTemp.Columns.Contains("Favorite"))
                        {
                            Favorite = drMedication["Favorite"] == DBNull.Value
                                               ? "N"
                                               : drMedication["Favorite"].ToString();
                        }
                        string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                        string CreatedDate = DateTime.Now.ToShortDateString();
                        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        string ModifiedDate = DateTime.Now.ToShortDateString();

                        DataRow[] drKeyPhrases;

                        drKeyPhrases = _dtKeyPhraseTemp.Select("KeyPhraseId=" + KeyPhraseId);

                        foreach (DataRow drTemp in drKeyPhrases)
                        {

                            tblKeyPhrase.Rows.Add(GenerateKeyPhraseDataRows(drTemp, tblKeyPhrase.ClientID, KeyPhraseId, StaffId,
                                                                  KeyPhraseCategory, PhraseText, Favorite, CreatedBy,
                                                                   CreatedDate, ModifiedBy, ModifiedDate, KeyPhraseCategoryName));

                        }
                        PanelPhrasesList.Controls.Add(tblKeyPhrase);
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

        private TableRow GenerateKeyPhraseDataRows(DataRow drTemp, string tableId, string KeyPhraseId, Int32 StaffId, Int32 KeyPhraseCategory, string PhraseText, string Favorite,
                                      string CreatedBy, string CreatedDate, string ModifiedBy,
                                      string ModifiedDate, string KeyPhraseCategoryName)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = Guid.NewGuid().ToString();
                int KeyPhraseid = Convert.ToInt32(drTemp["KeyPhraseId"]);
                string tblId = ClientID + ClientIDSeparator + tableId;
                var trTemp = new TableRow();
                trTemp.ID = "Tr_" + KeyPhraseid;
                int client = ((StreamlinePrinciple)Context.User).Client.ClientId;
                var tdKeyPhraseCategory = new TableCell();
                var tdDelete = new TableCell();
                var imgTemp = new HtmlImage();
                var tdRadioButton = new TableCell();
                string rowId = ClientID + ClientIDSeparator + trTemp.ClientID;
                var rbTemp = new HtmlInputRadioButton();

                imgTemp.ID = "Img_" + KeyPhraseId.ToString();
                imgTemp.Attributes.Add("KeyPhraseid", drTemp["KeyPhraseId"].ToString());
                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgTemp.Attributes.Add("title", "Delete Phrase");
                imgTemp.Attributes.Add("onClick", "DeleateFromPhraseList(" + KeyPhraseId + ")");
                imgTemp.Attributes.Add("class", "handStyle");

                tdDelete.Controls.Add(imgTemp);

                tdKeyPhraseCategory.Text = KeyPhraseCategoryName;
                tdKeyPhraseCategory.Style.Add("text-align", "center");
                var tdPhraseText = new TableCell();
                tdPhraseText.ToolTip = PhraseText;
                string s = Ellipsis(PhraseText);
                tdPhraseText.Text = s;
                tdPhraseText.Style.Add("text-align", "left");

                var tdFavorite = new TableCell();

                var lblFavorite = new Label();
                if (drTemp["Favorite"].ToString().ToUpper() == "Y")
                    lblFavorite.Text = "Y";
                else
                    lblFavorite.Text = "N";
                lblFavorite.ID = "lblFavorite" + newId;
                tdFavorite.Controls.Add(lblFavorite);
                tdFavorite.Style.Add("text-align", "center");

                rbTemp.Attributes.Add("onClick", "ModifyPhraseList(" + KeyPhraseId + ")");

                tdRadioButton.Controls.Add(rbTemp);
                trTemp.Cells.Add(tdRadioButton);

                trTemp.Cells.Add(tdDelete);
                trTemp.Cells.Add(tdKeyPhraseCategory);
                trTemp.Cells.Add(tdPhraseText);
                trTemp.Cells.Add(tdFavorite);
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

        static public string Ellipsis(string text)
        {
            Int32 length = 60;
            if (text.Length <= length) return text;
            int pos = text.IndexOf(" ", length);
            if (pos >= 0)
                return text.Substring(0, pos) + "...";
            return text;
        }
        public string KeyPhraseCategoryName { get; set; }
    }

}
