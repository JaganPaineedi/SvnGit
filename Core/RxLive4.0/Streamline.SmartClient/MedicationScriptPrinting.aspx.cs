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
using System.IO;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Collections.Generic;
using Streamline.UserBusinessServices.DataSets;


public partial class MedicationScriptPrinting : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    public string Printfourprescriptionsperpage = "N";
    public enum OrderStatus
    {
        Success,
        Failure
    }
    protected override void Page_Load(object sender, EventArgs e)
    {
        FileStream fs;
        TextWriter ts;
        string _strScriptIds = "";
        ArrayList ScriptArrays;
        string _strChartScriptIds = "";
        ArrayList ChartScriptArrays;
        bool _strFaxSendStatus = false;
        string _strFaxFaildMessage = "";
        Dictionary<string, string> filePathList = new Dictionary<string, string>();

        string imagePath = string.Empty;
        try
        {


            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
            #endregion

            string strPath = "";
            string FileName = "";

            DataSet DatasetSystemConfigurationKeys = null;
            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
            {
                Printheader.Text = "";
                Printfourprescriptionsperpage = "Y";
            }


            fs = new FileStream(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\Report.html"), FileMode.Create);
            ts = new StreamWriter(fs);
            _strScriptIds = Request.QueryString["varScriptIds"].ToString();
            if (Request.QueryString["varChartScriptIds"] != null)
                _strChartScriptIds = Request.QueryString["varChartScriptIds"].ToString();
            _strFaxSendStatus = Convert.ToBoolean(Request.QueryString["varFaxSendStatus"]);

            string strPageHtml = "";
            ScriptArrays = new ArrayList();
            if (_strScriptIds.Contains("^"))
                ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, "^");
            else if (_strScriptIds.Contains(","))
                ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, ",");
            else
                ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, ",");

            ChartScriptArrays = new ArrayList();
            if (_strChartScriptIds.Contains("^"))
                ChartScriptArrays = ApplicationCommonFunctions.StringSplit(_strChartScriptIds, "^");
            else if (_strChartScriptIds.Contains(","))
                ChartScriptArrays = ApplicationCommonFunctions.StringSplit(_strChartScriptIds, ",");
            else
                ChartScriptArrays = ApplicationCommonFunctions.StringSplit(_strChartScriptIds, ",");

            if (_strFaxSendStatus == false)
            {
                _strFaxFaildMessage = "Script could not be faxed at this time.  The fax server is not available.  Please print the script or re-fax the script later.";
                strPageHtml += "<span style='float:left;position:absolute;padding-left:30%;color:Red;text-align:center;font-size: 12px;font-family:Microsoft Sans Serif;'><b>" + _strFaxFaildMessage + "</b></span><br/>";
            }
            //End here
            for (int i = 0; i < ScriptArrays.Count; i++)
            {

                foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                {
                    FileName = file.Substring(file.LastIndexOf("\\") + 1);
                    if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString()) >= 0))
                    {
                        strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'  style='width:100%' />";
                        imagePath = "RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                        filePathList.Add(FileName, imagePath);
                    }
                    strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                    strPath = strPath.Replace(@"\", "/");
                }
            }

            //Get the Images from ChartScripts Folder
            for (int i = 0; i < ChartScriptArrays.Count; i++)
            {
                if (
                    Directory.Exists(
                        Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\")))
                {
                    foreach (
                        string file in
                            Directory.GetFiles(
                                Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\"))
                        )
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) &&
                            (FileName.IndexOf(ChartScriptArrays[i].ToString()) >= 0))
                            strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" +
                                           "ChartScripts" + "\\" + FileName + "'  style='width:100%' />";
                        strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\" +
                                  FileName;
                    }
                }
            }

            //byte[] photo = org_logo(imagePath);
            string pageHTMLWithWatermark = string.Empty;

            bool printWithWatermark = false;
            int drugCategory = 0;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedicationOrders _DataSetOrderDetails = Session["DataSetOrderDetails"] as DataSetClientMedicationOrders;
            string PharmacyName = Convert.ToString(Session["PharmacyName"]);
            string OrderingMethod = Convert.ToString(Session["OrderingMethod"]);
            if (OrderingMethod.Contains("Elec"))
            {
                if (Session["MedicationOrderStatus"] != null && Convert.ToString(Session["MedicationOrderStatus"]).Equals("Successful") &&
                    Session["DrugCategory"] != null)
                {
                    drugCategory = Convert.ToInt32(Session["DrugCategory"]);
                    if (drugCategory >= 2)
                    {
                        foreach (KeyValuePair<string, string> imageParameters in filePathList)
                        {
                            string phyisicalPathName = AddWatermark(imageParameters.Value, imageParameters.Key, OrderStatus.Success);
                            pageHTMLWithWatermark += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + phyisicalPathName + "'/>";
                            printWithWatermark = true;
                        }
                    }
                }
                else if (Session["MedicationOrderStatus"] != null && !Convert.ToString(Session["MedicationOrderStatus"]).Equals("Successful") &&
                    Session["DrugCategory"] != null)
                {
                    drugCategory = Convert.ToInt32(Session["DrugCategory"]);
                    foreach (KeyValuePair<string, string> imageParameters in filePathList)
                    {
                        string phyisicalPathName = AddWatermark(imageParameters.Value, imageParameters.Key, OrderStatus.Failure);
                        pageHTMLWithWatermark += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + phyisicalPathName + "'/>";
                        printWithWatermark = true;
                    }
                }
            }
            else
            {
                if (Session["MedicationOrderStatus"] != null && !Convert.ToString(Session["MedicationOrderStatus"]).Equals("Successful") &&
                    Session["DrugCategory"] != null)
                {
                    drugCategory = Convert.ToInt32(Session["DrugCategory"]);
                    foreach (KeyValuePair<string, string> imageParameters in filePathList)
                    {
                        if (ChartScriptArrays.Count == 0)
                        {
                            string phyisicalPathName = AddOriginalPrescriptionImage(imageParameters.Value, imageParameters.Key);
                            pageHTMLWithWatermark += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + phyisicalPathName + "'/>";
                            printWithWatermark = true;
                        }
                    }
                }
                printWithWatermark = true;
            }

            ts.Close();
            if (printWithWatermark && pageHTMLWithWatermark != "")
                Response.Write(pageHTMLWithWatermark);
            else
                strPageHtml = strPageHtml.Replace(@"\", "/");
                Response.Write(strPageHtml);
            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "printScript();", true);

        }
        catch (Exception ex)
        {
            Response.Write("Error While Generating Report"+ex.Message.ToString());
        }
        finally
        {
            fs = null;
            ts = null;
            _strScriptIds = null;
            ScriptArrays = null;
            ChartScriptArrays = null;
            _strChartScriptIds = null;

        }
    }

    private string AddOriginalPrescriptionImage(string virtualPath, string fileName)
    {
        using (Bitmap bmp = new Bitmap(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, virtualPath), false))
        {
            using (Graphics grp = Graphics.FromImage(bmp))
            {
                Brush originalBrush = new SolidBrush(System.Drawing.Color.Black);
                System.Drawing.Image imgOriginalPrescriptionText = System.Drawing.Image.FromFile(AppDomain.CurrentDomain.BaseDirectory + "\\RDLC\\OriginalPrescriptionText.jpg");
                grp.DrawImage(imgOriginalPrescriptionText, 1, 180);

            }
            return GenerateFileNameWithWatermark(virtualPath, bmp);
        }
    }

    private string AddWatermark(string virtualPath, string fileName, OrderStatus orderStatus)
    {
        Streamline.UserBusinessServices.DataSets.DataSetClientMedicationOrders _DataSetOrderDetails = Session["DataSetOrderDetails"] as DataSetClientMedicationOrders;
        string PharmacyName = Convert.ToString(Session["PharmacyName"]);
        string watermarkText = string.Empty;
        if (orderStatus == OrderStatus.Success)
        {
            watermarkText = "Copies not for dispensing";
        }
        else
        {
            watermarkText = "Original Attempt Date: " + _DataSetOrderDetails.Tables["ClientMedications"].Rows[0]["CreatedDate"].ToString() + "\nOriginal Prescription Status: " + Convert.ToString(Session["MedicationOrderStatus"])
                           + "\nOriginal Prescription Pharmacy: " + PharmacyName + "\nPresciption Originally Intended to be transmitted electronically";
        }

        //Read the File into a Bitmap.
        using (Bitmap bmp = new Bitmap(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, virtualPath), false))
        {
            using (Graphics grp = Graphics.FromImage(bmp))
            {
                double tangent = (double)bmp.Height /
                              (double)bmp.Width;

                // convert arctangent to degrees
                double angle = Math.Atan(tangent) * (180 / Math.PI);

                // Pythagoras here :-/
                // a^2 = b^2 + c^2 ; a = sqrt(b^2 + c^2)
                double halfHypotenuse = Math.Sqrt((bmp.Height
                                       * bmp.Height) +
                                       (bmp.Width *
                                       bmp.Width)) / 2;

                FontStyle fontStyle = FontStyle.Regular;
                int maxFontSize = 75;
                string fontName = "Arial";
                Font font = new Font(fontName, maxFontSize,
                                     fontStyle);
                Color color = Color.FromArgb(40, Color.Gray);
                for (int i = maxFontSize; i > 0; i--)
                {
                    font = new Font(fontName, i, fontStyle);
                    SizeF sizef = grp.MeasureString(watermarkText,
                                   font, int.MaxValue);

                    double sin = Math.Sin(angle * (Math.PI / 180));
                    double cos = Math.Cos(angle * (Math.PI / 180));

                    double opp1 = sin * sizef.Width;
                    double adj1 = cos * sizef.Height;

                    double opp2 = sin * sizef.Height;
                    double adj2 = cos * sizef.Width;

                    if (opp1 + adj1 < bmp.Height &&
                        opp2 + adj2 < bmp.Width)
                    {
                        break;
                    }
                }

                //Set the Color of the Watermark text.
                Brush brush = new SolidBrush(Color.Gray);
                if (orderStatus == OrderStatus.Success)
                {
                    // Horizontally and vertically aligned the string
                    // This makes the placement Point the physical 
                    // center of the string instead of top-left.
                    StringFormat stringFormat = new StringFormat();
                    stringFormat.Alignment = StringAlignment.Center;
                    stringFormat.LineAlignment = StringAlignment.Center;

                    // Calculate the size of the string (Graphics
                    // .MeasureString)
                    // and see if it fits in the bitmap completely. 
                    // If it doesn’t, strink the font and check 
                    // again... and again until it does fit.


                    grp.SmoothingMode = SmoothingMode.AntiAlias;
                    grp.RotateTransform((float)angle);

                    ////Set the Font and its size.
                    //Font font = new System.Drawing.Font("Arial", 30, FontStyle.Bold, GraphicsUnit.Pixel);

                    //Determine the size of the Watermark text.
                    SizeF textSize = new SizeF();
                    textSize = grp.MeasureString(watermarkText, font);
                    grp.CompositingMode = CompositingMode.SourceOver;

                    StringFormat sf = new StringFormat();
                    sf.FormatFlags = StringFormatFlags.DirectionVertical;
                    float x = 10;
                    float y = 10;

                    //Position the text and draw it on the image.
                    Point position = new Point(10, 150);

                    grp.DrawString(watermarkText, font, new SolidBrush(color), new Point((int)halfHypotenuse, 0), stringFormat);
                }
                else
                {
                    //font={[Font: Name=Arial, Size=29, Units=3, GdiCharSet=1, GdiVerticalFont=False]};
                    fontStyle = FontStyle.Regular;
                    maxFontSize = 9;
                    font = new Font(fontName, maxFontSize,
                                         fontStyle);
                    Brush myBrush = new SolidBrush(System.Drawing.Color.Black);
                    grp.DrawString(watermarkText, font, myBrush, 1, 650);
                }

                return GenerateFileNameWithWatermark(virtualPath, bmp);
            }
        }
    }

    /// <summary>
    /// Generate File Name With Watermark
    /// </summary>
    /// <param name="virtualPath"></param>
    /// <param name="bmp"></param>
    /// <returns></returns>
    private static string GenerateFileNameWithWatermark(string virtualPath, Bitmap bmp)
    {
        using (MemoryStream memoryStream = new MemoryStream())
        {
            //Save the Watermarked image to the MemoryStream.
            bmp.Save(memoryStream, ImageFormat.Jpeg);
            System.Drawing.Image img = System.Drawing.Image.FromStream(memoryStream);
            string phyisicalPathName = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, virtualPath);
            string fileNameWithWatermark = string.Empty;
            if (phyisicalPathName.Contains(".jpeg"))
            {
                int start = phyisicalPathName.IndexOf(".jpeg");
                phyisicalPathName = phyisicalPathName.Insert(start, "_WatermarkAdded");
                int index1 = phyisicalPathName.LastIndexOf('\\');
                fileNameWithWatermark = phyisicalPathName.Remove(0, index1).Replace("\\", "");
            }

            img.Save(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, phyisicalPathName));

            return fileNameWithWatermark;
        }
    }
}
