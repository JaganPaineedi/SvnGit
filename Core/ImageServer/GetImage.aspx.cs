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
using System.Data.SqlClient;
using System.Drawing.Imaging;
using System.Drawing;
using Microsoft.ApplicationBlocks.Data;

public partial class GetImage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsPostBack)
            {


                GetImageFromDataBase((Convert.ToInt32(Request.QueryString["ScannedMedicalRecordId"])), Convert.ToInt32(Request.QueryString["PageNumber"]));

            }
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }



    private void GetImageFromDataBase(int scannedMedicalRecordId, int pageNumber)
    {
        string _strImageDatabaseConnectionString = string.Empty;

        SqlParameter[] _sParam = null;
        SqlConnection _sqlConnectionImages = null;
        try
        {

            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");

            _sParam = new SqlParameter[2];

            _sParam[0] = new SqlParameter("@ScannedMedicalRecordId", SqlDbType.Int);
            _sParam[0].Value = scannedMedicalRecordId;

            _sParam[1] = new SqlParameter("@PageNumber", SqlDbType.Int);
            _sParam[1].Value = pageNumber;

            _sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);

            Object _objectScannedImage =  SqlHelper.ExecuteScalar(_sqlConnectionImages, CommandType.StoredProcedure, "ssp_SCGetImageScanned", _sParam);



            if (_objectScannedImage != null)
            {
                byte[] _imageStream = (byte[])_objectScannedImage;
                System.IO.MemoryStream _stream = new System.IO.MemoryStream(_imageStream, false);
                System.Drawing.Image _image = System.Drawing.Image.FromStream(_stream);

                if (doesFileNeedToBeScaled(_image))
                {
                    _image = scaleImage(_image);

                }

                Response.ContentType = "image/jpeg";
                _image.Save(Response.OutputStream, ImageFormat.Jpeg);
                _image.Dispose();

            }


        }
        catch (Exception ex)
        {
            throw ex;
        }



    }

    private bool doesFileNeedToBeScaled(System.Drawing.Image inputImage)
    {
        if (inputImage.Width > 850)
        {
            return true;
        }
        else return false;
    }

    public System.Drawing.Image scaleImage(System.Drawing.Image originalImage)
    {
        int newWidth = 850;
        int newHeight = 0;
        float aspectRatio = 0;

        aspectRatio = calculateAspectRatio(originalImage.Width, originalImage.Height);

        newHeight = 850 / Convert.ToInt32(aspectRatio);

        System.Drawing.Image result = new Bitmap(newWidth, newHeight);
        Graphics g = Graphics.FromImage(result);
        g.DrawImage(originalImage, 0, 0, newWidth, newHeight);
        return result;
    }

    private float calculateAspectRatio(float width, float height)
    {
        return width / height;
    }


}
