using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System;
using System.IO;
using System.Data;
using System.Text;
using System.Drawing.Imaging;
using System.Drawing.Printing;
using System.Collections.Generic;
using System.Drawing;

namespace Streamline.BaseLayer
{
    public class RDLCPrint : IDisposable
    {
        private int m_currentPageIndex;
        private string _path;
        private string _pathToDeleteDirectories;
        private string _FolderId;
        private IList<Stream> m_streams;
        static string _strFoldersToBeDeleted = System.Configuration.ConfigurationSettings.AppSettings["ScriptFoldersToBeDeleted"].ToString();
        

        public RDLCPrint()
        {
            m_currentPageIndex = 0;
        }

        public void Run(LocalReport report, string path, string FolderId, bool FlagForDeletion, bool ChartPrinting)
        {
            try
            {
                _strFoldersToBeDeleted = _strFoldersToBeDeleted.ToUpper();
                _path = path.ToString();
                _FolderId = FolderId;

                if ((FlagForDeletion == true) && (System.IO.Directory.Exists(_path + "\\")) && _strFoldersToBeDeleted == "TRUE")
                {
                    foreach (string s in System.IO.Directory.GetDirectories(_path))
                    {
                        foreach (string s1 in System.IO.Directory.GetFiles(s))
                        {
                            if (s1.ToUpper().IndexOf(".RDLC") == -1)
                                System.IO.File.Delete(s1);
                        }
                        if (!(s.EndsWith("RDLC") || s.EndsWith("RDLC\\")) && Directory.GetFiles(s).Length == 0)
                            System.IO.Directory.Delete(s);
                    }

                }

                if (!System.IO.Directory.Exists(_path + "\\"))
                    System.IO.Directory.CreateDirectory(_path + "\\");

                if (ChartPrinting == false)
                    _path = path.ToString() + "\\";
                else
                {
                    _path = path.ToString() + "\\" + "ChartScripts" + "\\";
                    if (!System.IO.Directory.Exists(_path))
                        System.IO.Directory.CreateDirectory(_path);
                }

                Export(report);
                m_currentPageIndex = 0;
                //Print();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        // Export the given report as an JPEG  file.
        private void Export(LocalReport report)
        {
            try
            {

                string deviceInfo = "";
                string rotateflag = "N";
                DataSet DatasetSystemConfigurationKeys = null;
                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
                {
                    deviceInfo =
                  "<DeviceInfo>" +
                  "  <OutputFormat>JPEG</OutputFormat>" +
                  "  <PageWidth>11.30in</PageWidth>" +
                  "  <PageHeight>8.75in</PageHeight>" +
                  "  <MarginTop>0.0in</MarginTop>" +
                  "  <MarginLeft>0.0in</MarginLeft>" +
                  "  <MarginRight>0.0in</MarginRight>" +
                  "  <MarginBottom>0.0in</MarginBottom>" +
                  "</DeviceInfo>";

                   
                  rotateflag = "Y";
                   
 
                }

                else
                {
                    deviceInfo =
                     "<DeviceInfo>" +
                     "  <OutputFormat>JPEG</OutputFormat>" +
                     "  <PageWidth>8.0in</PageWidth>" +
                     "  <PageHeight>10.5in</PageHeight>" +
                     "  <MarginTop>0.25in</MarginTop>" +
                     "  <MarginLeft>0.0in</MarginLeft>" +
                     "  <MarginRight>0.0in</MarginRight>" +
                     "  <MarginBottom>0.0in</MarginBottom>" +
                     "</DeviceInfo>";
                }
                Warning[] warnings;
                m_streams = new List<Stream>();
                report.Render("Image", deviceInfo, CreateStream, out warnings);
                
                List<String> list = new List<String>();
                int i = 0;
                foreach (Stream stream in m_streams)
                {
                    stream.Position = 0;
                    list.Add(((System.IO.FileStream)(stream)).Name);
                    stream.Close();
                }

                if (rotateflag == "Y")
                {
                    foreach (string s in list)
                    {
                        using (System.Drawing.Image image = System.Drawing.Image.FromFile(s))
                        {
                            image.RotateFlip(RotateFlipType.Rotate270FlipNone);
                            System.IO.File.Delete(s);
                            image.Save(s, System.Drawing.Imaging.ImageFormat.Jpeg);
                            image.Dispose();
                        }

                    }
                }

            }
            catch (Exception ex)
            {
                throw (ex);

            }

        }


        //Created by Loveena in ref to Task#2634 to increase the width of Prescriber Preview Report
        public void RunPreview(LocalReport report, string path, string FolderId, bool FlagForDeletion, bool ChartPrinting)
        {
            try
            {
                _strFoldersToBeDeleted = _strFoldersToBeDeleted.ToUpper();
                _path = path.ToString();
                _FolderId = FolderId;

                if ((FlagForDeletion == true) && (System.IO.Directory.Exists(_path + "\\")) && _strFoldersToBeDeleted == "TRUE")
                {
                    foreach (string s in System.IO.Directory.GetDirectories(_path))
                    {
                        foreach (string s1 in System.IO.Directory.GetFiles(s))
                        {
                            if (s1.ToUpper().IndexOf(".RDLC") == -1)
                                System.IO.File.Delete(s1);
                        }
                        if (!(s.EndsWith("RDLC") || s.EndsWith("RDLC\\")) && Directory.GetFiles(s).Length == 0)
                            System.IO.Directory.Delete(s);
                    }

                }


                if (!System.IO.Directory.Exists(_path + "\\"))
                    System.IO.Directory.CreateDirectory(_path + "\\");

                if (ChartPrinting == false)
                    _path = path.ToString() + "\\";
                else
                {
                    _path = path.ToString() + "\\" + "ChartScripts" + "\\";
                    if (!System.IO.Directory.Exists(_path))
                        System.IO.Directory.CreateDirectory(_path);
                }

                ExportPreview(report);
                m_currentPageIndex = 0;
                //Print();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        //Created by Loveena in ref to Task#2634 to increase the width of Prescriber Preview Report
        // Export the given report as an JPEG  file.
        private void ExportPreview(LocalReport report)
        {
            try
            {
                string deviceInfo =
                 "<DeviceInfo>" +
                     "  <OutputFormat>JPEG</OutputFormat>" +
                     "  <PageWidth>10.0in</PageWidth>" +
                     "  <PageHeight>11in</PageHeight>" +
                     "  <MarginTop>0.25in</MarginTop>" +
                     "  <MarginLeft>0.0in</MarginLeft>" +
                     "  <MarginRight>0.0in</MarginRight>" +
                     "  <MarginBottom>0.0in</MarginBottom>" +
                     "</DeviceInfo>";



                Warning[] warnings;
                m_streams = new List<Stream>();
                report.Render("Image", deviceInfo, CreateStream, out warnings);

                foreach (Stream stream in m_streams)
                {
                    stream.Position = 0;
                    stream.Close();
                }
            }
            catch (Exception ex)
            {
                throw (ex);

            }

        }

        public void RunConsent(LocalReport report, string path, string FolderId, bool FlagForDeletion, bool ChartPrinting)
        {
            try
            {
                _strFoldersToBeDeleted = _strFoldersToBeDeleted.ToUpper();
                _path = path.ToString();
                _FolderId = FolderId;

                if ((FlagForDeletion == true) && (System.IO.Directory.Exists(_path + "\\")) && _strFoldersToBeDeleted == "TRUE")
                {
                    foreach (string s in System.IO.Directory.GetDirectories(_path))
                    {
                        foreach (string s1 in System.IO.Directory.GetFiles(s))
                        {
                            if (s1.ToUpper().IndexOf(".RDLC") == -1)
                                System.IO.File.Delete(s1);
                        }
                        if (!(s.EndsWith("RDLC") || s.EndsWith("RDLC\\")) && Directory.GetFiles(s).Length == 0)
                            System.IO.Directory.Delete(s);
                    }

                }

                if (!System.IO.Directory.Exists(_path + "\\"))
                    System.IO.Directory.CreateDirectory(_path + "\\");

                if (ChartPrinting == false)
                    _path = path.ToString() + "\\";
                else
                {
                    _path = path.ToString() + "\\" + "ChartScripts" + "\\";
                    if (!System.IO.Directory.Exists(_path))
                        System.IO.Directory.CreateDirectory(_path);
                }

                ExportConsent(report);
                m_currentPageIndex = 0;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        // Export the given report as an JPEG  file.
        private void ExportConsent(LocalReport report)
        {
            try
            {
                string deviceInfo =
                 "<DeviceInfo>" +
                 "  <OutputFormat>JPEG</OutputFormat>" +
                 "  <PageWidth>8.0in</PageWidth>" +
                 "  <PageHeight>9in</PageHeight>" +
                 "  <MarginTop>0.25in</MarginTop>" +
                 "  <MarginLeft>0.0in</MarginLeft>" +
                 "  <MarginRight>0.0in</MarginRight>" +
                 "  <MarginBottom>0.0in</MarginBottom>" +
                 "</DeviceInfo>";

                Warning[] warnings;
                m_streams = new List<Stream>();
                report.Render("Image", deviceInfo, CreateStream, out warnings);

                foreach (Stream stream in m_streams)
                {
                    stream.Position = 0;
                    stream.Close();
                }
            }
            catch (Exception ex)
            {
                throw (ex);

            }

        }

        // Routine to provide to the report renderer, in order to
        //    save an image for each page of the report.
        private Stream CreateStream(string name, string fileNameExtension, Encoding encoding, string mimeType, bool willSeek)
        {

            try
            {

                Stream stream = null;

                if (name.IndexOf("_") > 0)
                {
                    string[] splitIndex = name.Split('_');
                    string fileName = splitIndex[1];
                    if (splitIndex[1].Length == 1)
                        fileName = "00" + splitIndex[1];
                    else if (splitIndex[1].Length == 2)
                        fileName = "0" + splitIndex[1];
                    fileName = fileName + _FolderId;
                    stream = new FileStream(_path + fileName + "." + fileNameExtension, FileMode.Create);
                }
                else
                {
                    name = name + _FolderId;
                    stream = new FileStream(_path + name + "." + fileNameExtension, FileMode.Create);
                }

                m_streams.Add(stream);
                return stream;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {

            }

        }


        // Handler for PrintPageEvents
        private void PrintPage(object sender, PrintPageEventArgs ev)
        {
            try
            {

                Metafile pageImage = new Metafile(m_streams[m_currentPageIndex]);
                ev.Graphics.DrawImage(pageImage, ev.PageBounds);

                pageImage.Save(_path + "\\" + System.Web.HttpContext.Current.Session.SessionID.ToString() + m_currentPageIndex + System.Guid.NewGuid().ToString() + ".jpg", ImageFormat.Jpeg);

                m_currentPageIndex++;
                ev.HasMorePages = (m_currentPageIndex < m_streams.Count);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {

            }
        }

        private void Print()
        {
            try
            {
                //const string printerName ="Microsoft Office Document Image Writer";
                if (m_streams == null || m_streams.Count == 0)
                    return;
                PrintDocument printDoc = new PrintDocument();

                printDoc.PrintPage += new PrintPageEventHandler(PrintPage);
                printDoc.Print();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        public void Dispose()
        {
            try
            {
                if (m_streams != null)
                {
                    foreach (Stream stream in m_streams)
                        stream.Close();
                    m_streams = null;
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
            }
        }

        public void DeleteRenderedImages(string path)
        {
            try
            {
                //Check Existence of User's Directory
                if (System.IO.Directory.Exists(path))
                {
                    foreach (string s1 in System.IO.Directory.GetFiles(path))
                    {
                        if (s1.ToUpper().IndexOf(".RDLC") == -1)
                            System.IO.File.Delete(s1);
                    }
                    if (System.IO.Directory.Exists(path + "\\ChartScripts"))
                    {
                        foreach (string s1 in System.IO.Directory.GetFiles(path + "\\ChartScripts\\"))
                        {
                            if (s1.ToUpper().IndexOf(".RDLC") == -1)
                                System.IO.File.Delete(s1);
                        }
                    }

                }


            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

    }
}