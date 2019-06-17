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
using System.Web.UI.HtmlControls;

namespace SHS.SmartCare
{
    public partial class CustomProgressTowardsISPGoal : DataActivityTab
    {
        public override void BindControls()
        {
            DataTable dtCustomDocumentDischargeGoals = new DataTable();
            dtCustomDocumentDischargeGoals = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentDischargeGoals"];

            #region Generate Goals
            //for (int i = 0; i < dtCustomDocumentDischargeGoals.Rows.Count; i++)
            //{
            //    Table tb1 = new Table();
            //    TableRow tbr = new TableRow();
            //    TableCell tbcGoalLabel = new TableCell();
            //    TableCell tbcGoalText = new TableCell();

            //    Label GoalLabel = new Label();
            //    Label GoalNumber = new Label();

            //    GoalNumber.ID = "Label_CustomDocumentDischargeGoals_GoalNumber"+i.ToString();


            //    GoalNumber.Text = dtCustomDocumentDischargeGoals.Rows[i]["GoalNumber"].ToString();

            //    //Goal Number
            //    GoalLabel.Text = "Goal #";
            //    tbcGoalLabel.Controls.Add(GoalLabel);
            //    tbcGoalLabel.Controls.Add(GoalNumber);

            //    tbcGoalLabel.Style.Add("width", "30%");
            //    tbcGoalLabel.Style.Add("padding-left", "7px");

            //    //Goal Text
            //    TextBox textBox = new TextBox();
            //    textBox.ID = "TextBox_CustomDocumentDischargeGoals_GoalText"+i.ToString();
            //    textBox.Text = dtCustomDocumentDischargeGoals.Rows[i]["GoalText"].ToString();
            //    textBox.Enabled = false;
            //    textBox.Style.Add("width", "700px");
            //    tbcGoalText.Controls.Add(textBox);

            //    tbr.Cells.Add(tbcGoalLabel);
            //    tbr.Cells.Add(tbcGoalText);

            //    //tb1.Style.Add("", "");

            //    //Rating of progress Towards Goal
            //    Table tb2 = new Table();
            //    TableRow tbrRatingofProgressTowardsGoal = new TableRow();
            //    TableCell tbcRatingOfprogressTowardsGoal = new TableCell();

            //    Label Label_RatingofProgress = new Label();
            //    Label_RatingofProgress.Text = "<b>Rating of progress towards goal:</b>";
            //    tbcRatingOfprogressTowardsGoal.Style.Add("colspan", "3");
            //    tbcRatingOfprogressTowardsGoal.Controls.Add(Label_RatingofProgress);

            //    tbcRatingOfprogressTowardsGoal.Style.Add("width", "10%");
            //    tbcRatingOfprogressTowardsGoal.Style.Add("height", "25px");

            //    tbrRatingofProgressTowardsGoal.Cells.Add(tbcRatingOfprogressTowardsGoal);
            //    tb2.Rows.Add(tbrRatingofProgressTowardsGoal);

            //    //Rating of progress towards goal.
            //    Table tb3 = new Table();
            //    TableRow tbrGoal = new TableRow();

            //    //Deterioration
            //    TableCell tbcRadioGoalDeterioration = new TableCell();
            //    TableCell tbcLabelGoalDeterioration = new TableCell();

            //    RadioButton radioDeterioration = new RadioButton();
            //    radioDeterioration.ID = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    //radioDeterioration = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    tbcRadioGoalDeterioration.Controls.Add(radioDeterioration);

            //    tbcRadioGoalDeterioration.Style.Add("width", "5%");
            //    tbcRadioGoalDeterioration.Style.Add("padding-left", "7px");

            //    Label labelDeterioration = new Label();
            //    labelDeterioration.Text = "Deterioration";

            //    tbcLabelGoalDeterioration.Controls.Add(labelDeterioration);

            //    tbrGoal.Cells.Add(tbcRadioGoalDeterioration);
            //    tbrGoal.Cells.Add(tbcLabelGoalDeterioration);

            //    //No Change
            //    TableCell tbcRadioGoalNoChange = new TableCell();
            //    TableCell tbcLabelGoalNoChange = new TableCell();

            //    RadioButton radioNoChange = new RadioButton();
            //    radioNoChange.ID = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    tbcRadioGoalNoChange.Controls.Add(radioNoChange);

            //    tbcRadioGoalNoChange.Style.Add("width", "5%");
            //    tbcRadioGoalNoChange.Style.Add("padding-left", "7px");

            //    Label labelNoChange = new Label();
            //    labelNoChange.Text = "No Change";

            //    tbcLabelGoalNoChange.Controls.Add(labelNoChange);

            //    tbrGoal.Cells.Add(tbcRadioGoalNoChange);
            //    tbrGoal.Cells.Add(tbcLabelGoalNoChange);

            //    //Some Improvement
            //    TableCell tbcRadioGoalSomeImpr = new TableCell();
            //    TableCell tbcLabelGoalSomeImpr = new TableCell();

            //    RadioButton radioSomeImpr = new RadioButton();
            //    radioSomeImpr.ID = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    tbcRadioGoalSomeImpr.Controls.Add(radioSomeImpr);

            //    tbcRadioGoalSomeImpr.Style.Add("width", "5%");
            //    tbcRadioGoalSomeImpr.Style.Add("padding-left", "7px");

            //    Label labelSomeImpr = new Label();
            //    labelSomeImpr.Text = "Some Improvement";

            //    tbcLabelGoalSomeImpr.Controls.Add(labelSomeImpr);

            //    tbrGoal.Cells.Add(tbcRadioGoalSomeImpr);
            //    tbrGoal.Cells.Add(tbcLabelGoalSomeImpr);

            //    //Moderate Improvement
            //    TableCell tbcRadioGoalModerateImpr = new TableCell();
            //    TableCell tbcLabelGoalModerateImpr = new TableCell();

            //    RadioButton radioModerateImpr = new RadioButton();
            //    radioModerateImpr.ID = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    tbcRadioGoalModerateImpr.Controls.Add(radioModerateImpr);

            //    tbcRadioGoalModerateImpr.Style.Add("width", "5%");
            //    tbcRadioGoalModerateImpr.Style.Add("padding-left", "7px");

            //    Label labelModerateImpr = new Label();
            //    labelModerateImpr.Text = "Moderate Improvement";

            //    tbcLabelGoalModerateImpr.Controls.Add(labelModerateImpr);

            //    tbrGoal.Cells.Add(tbcRadioGoalModerateImpr);
            //    tbrGoal.Cells.Add(tbcLabelGoalModerateImpr);

            //    //Achived
            //    TableCell tbcRadioGoalAchived = new TableCell();
            //    TableCell tbcLabelGoalAchived = new TableCell();

            //    RadioButton radioAchived = new RadioButton();
            //    radioAchived.ID = "RadioButton_CustomDocumentDischargeGoals_GoalRatingProgress" + i.ToString();
            //    tbcRadioGoalAchived.Controls.Add(radioAchived);

            //    tbcRadioGoalAchived.Style.Add("width", "5%");
            //    tbcRadioGoalAchived.Style.Add("padding-left", "7px");

            //    Label labelAchived = new Label();
            //    labelAchived.Text = "Achived";

            //    tbcLabelGoalAchived.Controls.Add(labelAchived);

            //    tbrGoal.Cells.Add(tbcRadioGoalAchived);
            //    tbrGoal.Cells.Add(tbcLabelGoalAchived);

            //    //Spacer
            //    TableRow tbrSpacer = new TableRow();
            //    tbrSpacer.Style.Add("height", "15px");


            //    tb1.Rows.Add(tbr);

            //    tb2.Rows.Add(tbrRatingofProgressTowardsGoal);

            //    tb3.Rows.Add(tbrGoal);

            //    tb3.Rows.Add(tbrSpacer);

            //    Placeholder.Controls.Add(tb1);
            //    Placeholder.Controls.Add(tb2);
            //    Placeholder.Controls.Add(tb3);
            //}
            #endregion
        }
        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "CustomDocumentDischargeGoals" };
            }
        }
        /// <summary>
        /// <Description>Dynamically bind HTML controls.</Description>
        /// <Author>Pradeep A</Author>
        /// <CreatedOn>June 23,2011</CreatedOn>
        /// </summary>
        public void BindHtmlControls()
        {
            
        }
        
    }
}
