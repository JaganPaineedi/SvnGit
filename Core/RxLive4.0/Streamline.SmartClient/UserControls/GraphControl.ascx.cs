using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.BaseLayer;
namespace Streamline.SmartClient.UI
{
    public partial class UserControls_GraphControl : Streamline.BaseLayer.BaseActivityPage
    {
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        int ClientId = 0;
        string xString = "";
        DateTime middledate;
        double MinimumValue = 0.0;
        double MaximumValue = 0.0;
        private int _healthDataCategoryId;
        private string _healthDataCatgeoryName;
        string itemName = "";
        DataSet dataSetGraphValue = null;
        public int HealthDataCatgeoryId
        {
            get { return _healthDataCategoryId; }
            set { _healthDataCategoryId = value; }
        }

        public string HealthDataCatgeoryName
        {
            get { return _healthDataCatgeoryName; }
            set { _healthDataCatgeoryName = value; }
        }

        private int _index;
        public int index
        {
            get { return _index; }
            set { _index = value; }
        }

        private DateTime _startDate;
        public DateTime StartDate
        {
            get { return _startDate; }
            set { _startDate = value; }
        }

        private DateTime _endDate;
        public DateTime EndDate
        {
            get { return _endDate; }
            set { _endDate = value; }
        }
        //Added By Chandan For MultiGarph
        private string _itemName;
        public string HealthDataItemName
        {
            get { return _itemName; }
            set { _itemName = value; }
        }
        protected override void Page_Load(object sender, EventArgs e)
        {


        }

        public override void Activate()
        {
            base.Activate();
            DataSet dataSetGraph = new DataSet();

            double GraphMaximum, GraphMinimum;
            GraphMaximum = 0.0;
            GraphMinimum = 0.0;
            double ItemGraphLowRedMinimum = 0.0;
            double ItemGraphLowRedMaximum = 0.0;
            double ItemGraphLowYellowMinimum = 0.0;
            double ItemGraphLowYellowMaximum = 0.0;
            double ItemGraphGreenMinimum = 0.0;
            double ItemGraphGreenMaximum = 0.0;
            double ItemGraphHighYellowMinimum = 0.0;
            double ItemGraphHighYellowMaximum = 0.0;
            double ItemGraphHighRedMinimum = 0.0;
            double ItemGraphHighRedMaximum = 0.0;


            Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
            objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            DataSet _DataSetHealthDataListGraph = null;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            _DataSetHealthDataListGraph = objectClientMedications.GetHeathDataGraphDropDown(ClientId);
            DataRow[] drHealthGraph = _DataSetHealthDataListGraph.Tables[0].Select("HealthDataCategoryId=" + HealthDataCatgeoryId);
            if (index >= 0)
                itemName = _DataSetHealthDataListGraph.Tables[0].Rows[index]["ItemName"].ToString();
            objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
            GetMinMaxValue();
            //Added By Chandan For MultiGarph
            dataSetGraph = objApplicationCommonFunctions.GetGraphData(HealthDataCatgeoryId, HealthDataCatgeoryName, MinimumValue, MaximumValue);

            dataSetGraph.Tables[0].TableName = "HealthDataCategories";

            RadChartHealthData.ChartTitle.TextBlock.Text = _healthDataCatgeoryName;

            //RadChartHealthData.DataSource = new int[] { 1, 5, 6, 9, 5, 7 };  
            Telerik.Charting.ChartSeries objectChartSeries = new Telerik.Charting.ChartSeries();

            objectChartSeries.DataYColumn = "ItemValue";
            objectChartSeries.Type = Telerik.Charting.ChartSeriesType.Line;
            objectChartSeries.Appearance.LineSeriesAppearance.Color = System.Drawing.Color.BlueViolet;


            if (dataSetGraph.Tables["HealthDataCategories"].Rows.Count != 0)
            {
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["MinimumValue"].ToString() != "")
                    GraphMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["MinimumValue"]);
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["MaximumValue"].ToString() != "")
                    GraphMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["MaximumValue"]);

                //ItemGraphLowRedMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowRedMinimum"].ToString() != "")
                    ItemGraphLowRedMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowRedMinimum"]);

                //ItemGraphLowRedMaximum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowRedMaximum"].ToString() != "")
                    ItemGraphLowRedMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowRedMaximum"]);

                //ItemGraphLowYellowMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowYellowMinimum"].ToString() != "")
                    ItemGraphLowYellowMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowYellowMinimum"]);


                //ItemGraphLowYellowMaximum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowYellowMaximum"].ToString() != "")
                    ItemGraphLowYellowMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["LowYellowMaximum"]);

                //ItemGraphGreenMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["GreenMinimum"].ToString() != "")
                    ItemGraphGreenMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["GreenMinimum"]);

                //ItemGraphGreenMaximum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["GreenMaximum"].ToString() != "")
                    ItemGraphGreenMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["GreenMaximum"]);

                //ItemGraphHighYellowMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighYellowMinimum"].ToString() != "")
                    ItemGraphHighYellowMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighYellowMinimum"]);

                //ItemGraphHighYellowMaximum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighYellowMaximum"].ToString() != "")
                    ItemGraphHighYellowMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighYellowMaximum"]);


                //ItemGraphHighRedMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighRedMinimum"].ToString() != "")
                    ItemGraphHighRedMinimum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighRedMinimum"]);

                //ItemGraphHighRedMinimum
                if (dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighRedMaximum"].ToString() != "")
                    ItemGraphHighRedMaximum = Convert.ToDouble(dataSetGraph.Tables["HealthDataCategories"].Rows[0]["HighRedMaximum"]);

            }

            //string[] xData;
            //xData = new string[12];
            //int rCount = 0;
            //string[] Months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

            //int arrayCounter = 0;

            //for (rCount = System.DateTime.Now.Month; rCount < 12; rCount++)
            //{
            //    xData[arrayCounter] = Months[rCount];
            //    arrayCounter++;
            //}

            //for (rCount = 0; rCount < System.DateTime.Now.Month; rCount++)
            //{
            //    xData[arrayCounter] = Months[rCount];
            //    arrayCounter++;
            //}
            string[] xData;
            xData = new string[12];

            int rCount = 0;
            string[] Months = { "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D" };

            int arrayCounter = 0;
            int totalmonth = MonthDeffrence();
            int SelectedMonth = StartDate.Month;
            int count = 0;
            for (rCount = 0; rCount < totalmonth; rCount++)
            {
                //Find the selected index of the month from the array 
                if (count == 0)
                {
                    xString += Months[MonthName(SelectedMonth - 1)] + ",";
                    count += 1;
                }
                else
                {
                    SelectedMonth = SelectedMonth + 1;
                    if (SelectedMonth > 12)
                    {
                        SelectedMonth = 1;
                    }
                    xString += Months[MonthName(SelectedMonth - 1)] + ",";

                }
            }
            xString = xString.Substring(0, xString.Length - 1);

            Months = xString.Split(',');



            RadChartHealthData.PlotArea.XAxis.AutoScale = false;
            RadChartHealthData.PlotArea.XAxis.AddRange(0, (Months.Length-1) * 30, 30);
            //foreach (string str in Months)
            //{
            //    RadChartHealthData.PlotArea.XAxis.Items.Add(new Telerik.Charting.ChartAxisItem(str));
            //}
            //RadChartHealthData.PlotArea.YAxis.AxisLabel.TextBlock.Appearance.TextProperties.Color =System.Drawing.Color.Red;
            //RadChartHealthData.PlotArea.YAxis.Appearance.Width = 3;
            //RadChartHealthData.PlotArea.YAxis.Appearance.Color = System.Drawing.Color.Red;

            RadChartHealthData.PlotArea.Appearance.Dimensions.Width = 800;
            rCount = 0;

            for (rCount = 0; rCount < Months.Length; rCount++)
            {
                RadChartHealthData.PlotArea.XAxis[rCount].TextBlock.Text = Months[rCount];
            }
            //RadChartHealthData.PlotArea.XAxis[Months.Length].TextBlock.Appearance.Visible = false;
            //RadChartHealthData.Chart.Legend.Items[0].TextBlock.Text = "Chandan";

            RadChartHealthData.PlotArea.XAxis.Appearance.Color = System.Drawing.Color.Maroon;
            RadChartHealthData.PlotArea.YAxis.AutoScale = false;
            //RadChartHealthData.PlotArea.YAxis.AddRange(GraphMinimum, GraphMaximum, 50);
            //double range = Math.Round((GraphMaximum - GraphMinimum) / 5);
            double range = ((GraphMaximum - GraphMinimum) / 5);
            if (range > 0)
                RadChartHealthData.PlotArea.YAxis.AddRange(GraphMinimum, GraphMaximum, range);
            else
                RadChartHealthData.PlotArea.YAxis.AddRange(GraphMinimum, GraphMaximum, 1);


            //ItemGraphLowRedZone
            Telerik.Charting.ChartMarkedZone ItemGraphLowRedMinimumZone = new Telerik.Charting.ChartMarkedZone();
            ItemGraphLowRedMinimumZone.ValueStartY = ItemGraphLowRedMinimum;
            ItemGraphLowRedMinimumZone.ValueEndY = ItemGraphLowRedMaximum;
            ItemGraphLowRedMinimumZone.Appearance.FillStyle.MainColor = System.Drawing.Color.FromArgb(230, 2, 8);// System.Drawing.Color.Red;
            //ItemGraphLowRedMinimumZone.Label.TextBlock.Text = "Low Red";

            //ItemGraphHighRedZone
            Telerik.Charting.ChartMarkedZone ItemGraphHighRedMinimumZone = new Telerik.Charting.ChartMarkedZone();
            ItemGraphHighRedMinimumZone.ValueStartY = ItemGraphHighRedMinimum;
            ItemGraphHighRedMinimumZone.ValueEndY = ItemGraphHighRedMaximum;
            ItemGraphHighRedMinimumZone.Appearance.FillStyle.MainColor = System.Drawing.Color.FromArgb(230, 2, 8); //System.Drawing.Color.Red;
            // ItemGraphHighRedMinimumZone.Label.TextBlock.Text = "High Red";

            //ItemGraphLowYellowZone
            Telerik.Charting.ChartMarkedZone ItemGraphLowYellowZone = new Telerik.Charting.ChartMarkedZone();
            ItemGraphLowYellowZone.ValueStartY = ItemGraphLowYellowMinimum;
            ItemGraphLowYellowZone.ValueEndY = ItemGraphLowYellowMaximum;
            ItemGraphLowYellowZone.Appearance.FillStyle.MainColor = System.Drawing.Color.FromArgb(246, 255, 0); //System.Drawing.Color.Yellow;
            // ItemGraphLowYellowZone.Label.TextBlock.Text = "Low Yellow";


            //ItemGraphHighYellowZone
            Telerik.Charting.ChartMarkedZone ItemGraphHighYellowZone = new Telerik.Charting.ChartMarkedZone();
            ItemGraphHighYellowZone.ValueStartY = ItemGraphHighYellowMinimum;
            ItemGraphHighYellowZone.ValueEndY = ItemGraphHighYellowMaximum;
            ItemGraphHighYellowZone.Appearance.FillStyle.MainColor = System.Drawing.Color.FromArgb(246, 255, 0);// System.Drawing.Color.Yellow;
            //ItemGraphHighYellowZone.Label.TextBlock.Text = "High Yellow";

            //ItemGraphGreenwZone
            Telerik.Charting.ChartMarkedZone ItemGraphGreenwZone = new Telerik.Charting.ChartMarkedZone();
            ItemGraphGreenwZone.ValueStartY = ItemGraphGreenMinimum;
            ItemGraphGreenwZone.ValueEndY = ItemGraphGreenMaximum;
            ItemGraphGreenwZone.Appearance.FillStyle.MainColor = System.Drawing.Color.FromArgb(147, 240, 0); //System.Drawing.Color.Green;
            // ItemGraphGreenwZone.Label.TextBlock.Text = "Green";


            RadChartHealthData.PlotArea.MarkedZones.Add(ItemGraphLowRedMinimumZone);
            RadChartHealthData.PlotArea.MarkedZones.Add(ItemGraphHighRedMinimumZone);
            RadChartHealthData.PlotArea.MarkedZones.Add(ItemGraphLowYellowZone);
            RadChartHealthData.PlotArea.MarkedZones.Add(ItemGraphHighYellowZone);
            RadChartHealthData.PlotArea.MarkedZones.Add(ItemGraphGreenwZone);

            SetGraphData();

        }
        private void SetGraphData()
        {

            try
            {
                int rCount = 0;
                System.DateTime ItemStartDate;
                if (dataSetGraphValue.Tables[0].Rows.Count > 0)
                {
                    dataSetGraphValue.Tables[0].TableName = "HealthData";
                    dataSetGraphValue.Tables[0].Columns.Add("AxisX");

                    Telerik.Charting.ChartSeries objectChartSeries = new Telerik.Charting.ChartSeries();
                    //objectChartSeries.Name = "Item Value";                   
                    //Series objectChartSeries = new Series("BMI Trend");
                    objectChartSeries.Type = Telerik.Charting.ChartSeriesType.Line;
                    objectChartSeries.Appearance.PointMark.Dimensions.Width = 1;
                    objectChartSeries.Appearance.PointMark.Dimensions.Height = 1;
                    objectChartSeries.Appearance.PointMark.FillStyle.MainColor = System.Drawing.Color.Black;
                    objectChartSeries.Appearance.PointMark.Visible = true;

                    objectChartSeries.Appearance.LabelAppearance.Visible = false;
                    RadChartHealthData.Chart.Legend.Appearance.Visible = false;
                    RadChartHealthData.AddChartSeries(objectChartSeries);
                    objectChartSeries.DataYColumn = "ItemValue";
                    if (dataSetGraphValue.Tables["HealthData"].Rows.Count == 0)
                    {

                        ////RadChartHealthData.Visible = false;
                        //ButtonPrint.Visible = false;
                        //tableBMITrend.Visible = false;
                    }
                    else
                    {
                        RadChartHealthData.Visible = true;
                        bool ShowCheckBox = false;
                        TimeSpan tspan;
                        for (rCount = 0; rCount <= dataSetGraphValue.Tables["HealthData"].Rows.Count - 1; rCount++)
                        {
                            //if (dataSetGraphValue.Tables["HealthData"].Rows.Count == 1)
                            //    {
                            //    objectChartSeries.Type = Telerik.Charting.ChartSeriesType.Bubble;
                            //    //objectChartSeries.DataXCol = MarkerStyle.Circle;
                            //    //BMITrendSeries.MarkerSize = 8;
                            //    }

                            double YPoint = Convert.IsDBNull(dataSetGraphValue.Tables["HealthData"].Rows[rCount]["ItemValue"]) ? 0.0 : Convert.ToDouble(dataSetGraphValue.Tables["HealthData"].Rows[rCount]["ItemValue"]);
                            if (YPoint != 0)
                            {
                                ItemStartDate = Convert.ToDateTime(dataSetGraphValue.Tables["HealthData"].Rows[rCount]["DateRecorded"]);
                                tspan = ItemStartDate - StartDate;
                                double months = Math.Round(tspan.TotalDays / 30);
                                Double XPoint = 0.0;
                                if (System.DateTime.Now.Year == ItemStartDate.Year && System.DateTime.Now.Month == ItemStartDate.Month)
                                {
                                    //XPoint = Convert.ToDouble(12 - StartDate.Month + ItemStartDate.Month) * 30 + ItemStartDate.Day;
                                    XPoint = Convert.ToDouble(months + 1) * 30 + ItemStartDate.Day;
                                }
                                else
                                {
                                    //XPoint = Convert.ToDouble(ItemStartDate.Month - StartDate.Month) * 30 + ItemStartDate.Day;

                                    XPoint = Convert.ToDouble(months + 1) * 30 + ItemStartDate.Day; ;
                                }

                                if (XPoint != 0)
                                {
                                    XPoint = XPoint - 45;
                                }

                                dataSetGraphValue.Tables["HealthData"].Rows[rCount]["AxisX"] = XPoint;

                                //RadChartHealthData.PlotArea.XAxis.AutoScale = false;
                                ShowCheckBox = true;
                            }


                            if (YPoint < 0)
                            {
                                //RadChartHealthData.Visible = false;
                                // ButtonPrint.Visible = false;
                                //tableBMITrend.Visible = false;
                                //BMITrend.Visible = false;                        
                            }
                        }
                    }
                    objectChartSeries.DataXColumn = "AxisX";
                    RadChartHealthData.DataSource = dataSetGraphValue;
                    //RadChartHealthData.PlotArea.YAxis.AxisLabel.TextBlock.Text = "Height";
                    objectChartSeries.PlotArea.Appearance.Dimensions.Margins.Right = new Telerik.Charting.Styles.Unit("5%");
                    RadChartHealthData.PlotArea.Appearance.Dimensions.Margins.Right = new Telerik.Charting.Styles.Unit("5%");
                    RadChartHealthData.DataBind();                    
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected int MonthDeffrence()
        {
            TimeSpan tspn = EndDate - StartDate;
            int month = tspn.Days / 30;
            return month + 1;
        }

        protected int MonthDeffrenceForLegend(DateTime date1)
        {
            middledate = date1;
            TimeSpan tspn = date1 - StartDate;
            int month = tspn.Days / 30;
            return month;
        }
        protected int MonthDeffrenceFornoneGraph(DateTime date1)
        {
            TimeSpan tspn;
            if (middledate < StartDate)
            {
                tspn = date1 - StartDate;
                middledate = date1;
            }
            else
            {
                tspn = date1 - middledate;
            }
            int month = tspn.Days / 30;
            return month;
        }
        protected int MonthDeffrenceForTrailingnoneGraph(DateTime date1)
        {
            TimeSpan tspn = EndDate - date1;
            int month = tspn.Days / 31;
            return month;
        }



        protected int MonthName(int month)
        {
            return month % 12;
        }
        protected void GetMinMaxValue()
        {
            dataSetGraphValue = new DataSet();
            Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
            objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
            try
            {
                //Added By Chandan For MultiGarph
                dataSetGraphValue = objApplicationCommonFunctions.GetGraphValue(ClientId, HealthDataCatgeoryId, HealthDataCatgeoryName, StartDate, EndDate);
                if (dataSetGraphValue.Tables[0].Rows.Count > 0)
                {
                    string maxVal = Convert.ToString(dataSetGraphValue.Tables[0].Compute("Max(ItemValue)", string.Empty));
                    string minVal = Convert.ToString(dataSetGraphValue.Tables[0].Compute("Min(ItemValue)", string.Empty));
                    MinimumValue = Convert.ToDouble(minVal);
                    MaximumValue = Convert.ToDouble(maxVal);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}