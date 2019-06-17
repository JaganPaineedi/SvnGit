using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using Microsoft.ApplicationBlocks.ExceptionManagement;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Threading;


/// <summary>
/// Summary description for ImageServerWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class ImageServerWebService : System.Web.Services.WebService
{


    public ImageServerWebService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    #region MemberVariables
    private SqlConnection sqlConnection;
    private string sqlConnectionString;
    private SqlParameter[] sParam;
    private DataSet _dsDocumentScans;
    private Int32 _DocumentId;
    private Int32 _ImageRecordId;
    SqlTransaction objSqlTransaction = null;
    private bool _boolCommittedImagesTable = false;
    #endregion
    private DataSet decom(byte[] data)
    {

        var dt = new DataSet();
        try
        {

            var formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            formatter.AssemblyFormat = System.Runtime.Serialization.Formatters.FormatterAssemblyStyle.Simple;
            //formatter.Binder = new MyBinder();
            using (var ms = new MemoryStream(data))
            {
                using (var desr = new GZipStream(ms, CompressionMode.Decompress, true))
                {
                    dt = formatter.Deserialize(desr) as DataSet;
                }
            }
        }
        catch (Exception ex)
        {
            dt = null;   // removed error handling logic!
        }
        return dt;



    }


    //private DataTable decom(byte[] data)
    //{

    //    var dt = new DataTable();
    //    try
    //    {

    //        var formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
    //        formatter.AssemblyFormat = System.Runtime.Serialization.Formatters.FormatterAssemblyStyle.Simple;
    //        formatter.Binder = new MyBinder();
    //        using (var ms = new MemoryStream(data))
    //        {
    //            using (var desr = new GZipStream(ms, CompressionMode.Decompress, true))
    //            {
    //                dt = formatter.Deserialize(desr) as DataTable;
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        dt = null;   // removed error handling logic!
    //    }
    //    return dt;



    //}


    private DataSet DecompressData(byte[] data)
    {
        DataSet ds = new DataSet();
        try
        {
            MemoryStream memStream = new MemoryStream(data);
            GZipStream unzipStream = new GZipStream(memStream, CompressionMode.Decompress);

            ds.ReadXml(unzipStream, XmlReadMode.ReadSchema);
            unzipStream.Close();
            memStream.Close();
        }
        catch (Exception ex)
        {
            ds = null;
        }
        return ds;
    }

    private byte[] CompressData(DataSet ds)
    {
        byte[] data;
        try
        {
            MemoryStream memStream = new MemoryStream();
            GZipStream zipStream = new GZipStream(memStream, CompressionMode.Compress);

            ds.WriteXml(zipStream, XmlWriteMode.WriteSchema);
            zipStream.Close();
            data = memStream.ToArray();
            memStream.Close();
        }
        catch
        {
            data = null;

        }

        return data;
    }

    private byte[] SerializeAndCompress(DataSet dt)
    {
        dt.RemotingFormat = SerializationFormat.Binary;
        using (MemoryStream msCompressed = new MemoryStream())
        using (GZipStream gZipStream = new GZipStream(msCompressed, CompressionMode.Compress))
        using (MemoryStream msDecompressed = new MemoryStream())
        {
            System.Runtime.Serialization.Formatters.Binary.BinaryFormatter formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            formatter.AssemblyFormat = System.Runtime.Serialization.Formatters.FormatterAssemblyStyle.Simple;
            //formatter.Binder = new MyBinder();
            formatter.Serialize(msDecompressed, dt);

            byte[] byteArray = msDecompressed.ToArray();

            gZipStream.Write(byteArray, 0, byteArray.Length);
            gZipStream.Close();
            return msCompressed.ToArray();
        }

    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string TestingMethod()
    {
        return "Testing Method";
    }

    [WebMethod]
    /// <summary>
    /// Author - Sonia Dhamija
    /// Ref 2314 MRS : Ability to create Local Servers
    /// </summary>
    /// <param name="ImageRecordId"></param>
    /// <returns></returns>
    public DataTable GetImagesfromDatabase(Int32 ImageRecordId)
    {
        DataTable dataTableImages = null;
        SqlConnection sqlConnectionImages = null;
        try
        {
            // return ImageRecordId;
            sParam = new SqlParameter[1];
            // dsImages = new DataTable();
            string _strImageDatabaseConnectionString = "";
            //_strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            dataTableImages = new DataTable();
            sParam[0] = new SqlParameter("@ImageRecordId", SqlDbType.Int);
            sParam[0].Value = ImageRecordId;
           
            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            dataTableImages = SqlHelper.ExecuteDataset(sqlConnectionImages, "ssp_SCWebGetScannedOrUploadedImages", sParam).Tables[0];
            dataTableImages.TableName = "ImageRecordItems";
            return dataTableImages;
        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {

            sqlConnectionImages = null;

            if (dataTableImages != null)
                dataTableImages.Dispose();

            sqlConnectionImages = null;
        }
    }

    [WebMethod]
    /// <summary>
    /// Author - Sonia Dhamija
    /// Ref 2314 MRS : Ability to create Local Servers
    /// </summary>
    /// <param name="ImageRecordId"></param>
    /// <returns></returns>
    public DataTable GetScannedImagesfromDatabase(Int32 ImageRecordId)
    {
        DataTable dataTableImages = null;
        SqlConnection sqlConnectionImages = null;
        try
        {
            // return ImageRecordId;
            sParam = new SqlParameter[1];
            // dsImages = new DataTable();
            string _strImageDatabaseConnectionString = "";
            //_strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            dataTableImages = new DataTable();
            sParam[0] = new SqlParameter("@ImageRecordId", SqlDbType.Int);
            sParam[0].Value = ImageRecordId;
            

            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            dataTableImages = SqlHelper.ExecuteDataset(sqlConnectionImages, "ssp_SCWebGetScannedImages", sParam).Tables[0];
            dataTableImages.TableName = "ImageRecordItems";
            return dataTableImages;
        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {

            sqlConnectionImages = null;

            if (dataTableImages != null)
                dataTableImages.Dispose();

            sqlConnectionImages = null;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="BatchId"></param>
    /// <returns></returns>
    [WebMethod]
    public DataTable GetScannedBatchImagesfromDatabase(String ImageRecordIdList)
    {
        DataTable dataTableImages = null;
        SqlConnection sqlConnectionImages = null;
        
        try
        {
            // return ImageRecordId;
            sParam = new SqlParameter[1];
            // dsImages = new DataTable();
            string _strImageDatabaseConnectionString = "";
            //_strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            dataTableImages = new DataTable();
            sParam[0] = new SqlParameter("@ImageRecordIdList", SqlDbType.VarChar);
            sParam[0].Value = ImageRecordIdList;


            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            dataTableImages = SqlHelper.ExecuteDataset(sqlConnectionImages, "ssp_SCWebGetScannedBatchImages", sParam).Tables[0];
            dataTableImages.TableName = "ImageRecordItems";
            return dataTableImages;
        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {

            sqlConnectionImages = null;

            if (dataTableImages != null)
                dataTableImages.Dispose();

            sqlConnectionImages = null;
        }
    }


    [WebMethod]
    /// <summary>
    /// Author - Sonia Dhamija
    /// Ref 2314 MRS : Ability to create Local Servers
    /// <Purpose>To Update Images On ImageServerDatabase</Purpose>
    /// </summary>
    /// <param name="ImageRecordId"></param>
    /// <returns></returns>
    public DataTable UpdateImagesOnImageServerDatabase(Int32 ImageRecordId, DataSet dsDocumentScans, bool UpdateMRSRelatedTables)
    {
        String _strImageDatabaseConnectionString = "";
        SqlDataAdapter objSqlDataAdapterImages = null;
        SqlCommandBuilder objSqlCommandBuilderImages = null;
        SqlConnection sqlConnectionDxImages = null;
        SqlCommand objSqlCommandImages = null;
        SqlTransaction objSqlTransactionImages = null;
        DataTable objectDataTable = null;
        string _SqlQuery = "";
       
        try
        {
            if (ImageRecordId != 0) //In Case ImageRecordId > 0 then its case of records Updation only
            {

                _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
                if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                    throw new Exception("Error opening connection for Image DatabaseConfigurationName");
                sqlConnectionDxImages = new SqlConnection(_strImageDatabaseConnectionString);
               // objSqlCommandImages.CommandTimeout = 1000; 
                sqlConnectionDxImages.Open();
                objSqlTransactionImages = null;
                objSqlTransactionImages = sqlConnectionDxImages.BeginTransaction();
                for (int i = 0; i < dsDocumentScans.Tables["ImageRecordItems"].Rows.Count; i++)
                {
                    if (dsDocumentScans.Tables["ImageRecordItems"].Rows[i]["ImageRecordId"] == System.DBNull.Value || Convert.ToInt32(dsDocumentScans.Tables["ImageRecordItems"].Rows[i]["ImageRecordId"].ToString()) <= 0)
                        dsDocumentScans.Tables["ImageRecordItems"].Rows[i]["ImageRecordId"] = ImageRecordId;
                }
                string scannedtype = Convert.ToString(dsDocumentScans.Tables["ImageRecords"].Rows[0]["ScannedOrUploaded"].ToString());
                // _SqlQuery = "Select * from ImageRecordItems where ItemImage is not null";
                _SqlQuery = "Select * from ImageRecordItems where ImageRecordId= " + ImageRecordId;
                objSqlCommandImages = new SqlCommand(_SqlQuery, sqlConnectionDxImages);
                objSqlDataAdapterImages = new SqlDataAdapter(objSqlCommandImages);
                objSqlDataAdapterImages.SelectCommand.Transaction = objSqlTransactionImages;
                objSqlCommandBuilderImages = new SqlCommandBuilder(objSqlDataAdapterImages);
                objSqlDataAdapterImages.InsertCommand = objSqlCommandBuilderImages.GetInsertCommand();
                objSqlDataAdapterImages.InsertCommand.Transaction = objSqlTransactionImages;
                objSqlDataAdapterImages.UpdateCommand = objSqlCommandBuilderImages.GetUpdateCommand();
                objSqlDataAdapterImages.UpdateCommand.Transaction = objSqlTransactionImages;
                objSqlDataAdapterImages.UpdateBatchSize = 10;
                objSqlDataAdapterImages.Update(dsDocumentScans.Tables["ImageRecordItems"]);

                

                objSqlTransactionImages.Commit();
                sqlConnectionDxImages.Close();
                objectDataTable = new DataTable();
                if (scannedtype == "S")
                {
                    objectDataTable = GetScannedImagesfromDatabase(ImageRecordId);
                }
                else
                {
                    objectDataTable = GetImagesfromDatabase(ImageRecordId);
                }




            }


            return objectDataTable;
        }
        catch (Exception ex)
        {
            throw new Exception("Image record Item issue" + ex.Message.ToString());
            objSqlTransaction.Rollback();
            sqlConnectionDxImages.Close();
           
            //if (_boolCommittedImagesTable == true)
            //    DeleteImages(_strImageDatabaseConnectionString, _dsOriginalDocumentScans);
            //return null;
            //throw (ex);
        }
        finally
        {
            if (objSqlDataAdapterImages != null)
                objSqlDataAdapterImages.Dispose();
            if (objSqlCommandBuilderImages != null)
                objSqlCommandBuilderImages.Dispose();
            if (sqlConnectionDxImages != null)
                sqlConnectionDxImages.Dispose();
            if (objSqlCommandImages != null)
                objSqlCommandImages.Dispose();
            _strImageDatabaseConnectionString = null;
        }

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="dsDocumentScans"></param>
    /// <returns></returns>
    [WebMethod]
    public DataSet UpdateBatchImageOnImageServerDatabase(int BatchId, DataSet dsDocumentScans)
    {
        String _strImageDatabaseConnectionString = "";
        SqlDataAdapter objSqlDataAdapterImages = null;
        SqlCommandBuilder objSqlCommandBuilderImages = null;
        SqlConnection sqlConnectionDxImages = null;
        SqlCommand objSqlCommandImages = null;
        SqlTransaction objSqlTransactionImages = null;
        DataTable objectDataTable = null;
        string _SqlQuery = "";

        

       // DataSet dsDocumentScans = decom(data); //DecompressData(data);
        //DataSet dsnew = decom(data);
      

        try
        {
            //if (ImageRecordId != 0) //In Case ImageRecordId > 0 then its case of records Updation only
            //{

                _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
                if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                    throw new Exception("Error opening connection for Image DatabaseConfigurationName");
                sqlConnectionDxImages = new SqlConnection(_strImageDatabaseConnectionString);
                // objSqlCommandImages.CommandTimeout = 1000; 
                sqlConnectionDxImages.Open();
                objSqlTransactionImages = null;
                objSqlTransactionImages = sqlConnectionDxImages.BeginTransaction();
                var result = from r in dsDocumentScans.Tables["ImageRecordItems"].AsEnumerable()
                             group r by r.Field<int>("ImageRecordId") into IdGroup
                             let row = IdGroup.First()
                             select new
                             {
                                 ImageRecordId = row.Field<int>("ImageRecordId"),

                             };
                string imageId = string.Empty;
                bool flag = true;
                foreach (var r in result)
                {
                    if (flag == true)
                    {
                        flag = false;
                    }
                    else
                    {
                        imageId += ",";
                    }
                    imageId += Convert.ToString(r.ImageRecordId);
                }
                string scannedtype = "S";// Convert.ToString(dsDocumentScans.Tables["ImageRecords"].Rows[0]["ScannedOrUploaded"].ToString());
                // _SqlQuery = "Select * from ImageRecordItems where ItemImage is not null";
                _SqlQuery = "Select * from ImageRecordItems where ImageRecordId IN (" + imageId + ")";
                objSqlCommandImages = new SqlCommand(_SqlQuery, sqlConnectionDxImages);
                objSqlDataAdapterImages = new SqlDataAdapter(objSqlCommandImages);
                objSqlDataAdapterImages.SelectCommand.Transaction = objSqlTransactionImages;
                objSqlCommandBuilderImages = new SqlCommandBuilder(objSqlDataAdapterImages);
                objSqlDataAdapterImages.InsertCommand = objSqlCommandBuilderImages.GetInsertCommand();
                objSqlDataAdapterImages.InsertCommand.Transaction = objSqlTransactionImages;
                objSqlDataAdapterImages.UpdateCommand = objSqlCommandBuilderImages.GetUpdateCommand();
                objSqlDataAdapterImages.UpdateCommand.Transaction = objSqlTransactionImages;
                objSqlDataAdapterImages.UpdateBatchSize = 20;
                objSqlDataAdapterImages.Update(dsDocumentScans.Tables["ImageRecordItems"]);

                

                objSqlTransactionImages.Commit();
                sqlConnectionDxImages.Close();
                objectDataTable = new DataTable();
                objectDataTable = GetScannedBatchImagesfromDatabase(imageId);




           // }
                DataSet objDs = new DataSet();
                objDs.Tables.Add(objectDataTable.Copy());
                return objDs;
        }
        catch (Exception ex)
        {
            objSqlTransaction.Rollback();
            sqlConnectionDxImages.Close();
            //if (_boolCommittedImagesTable == true)
            //    DeleteImages(_strImageDatabaseConnectionString, _dsOriginalDocumentScans);
            return null;
            //throw (ex);
        }
        finally
        {
            if (objSqlDataAdapterImages != null)
                objSqlDataAdapterImages.Dispose();
            if (objSqlCommandBuilderImages != null)
                objSqlCommandBuilderImages.Dispose();
            if (sqlConnectionDxImages != null)
                sqlConnectionDxImages.Dispose();
            if (objSqlCommandImages != null)
                objSqlCommandImages.Dispose();
            _strImageDatabaseConnectionString = null;
        }
    }

    [WebMethod]
    /// <summary>
    /// <Author>Sonia Dhamija</Author>
    /// </summary>
    /// <Purpose>To Delete the All Scanned Medical Records Pages with ImageRecordId</Purpose>
    /// Ref Task #   2360 
    /// <param name="ImageRecordId"></param>
    public bool DeleteImageRecordItems(Int32 ImageRecordId, string UserCode)
    {
        string _strImageDatabaseConnectionString;
        SqlConnection sqlConnectionImages = null;
        SqlTransaction objectSqlTransaction = null;
        //MainApplicationService.ScannedMedicalRecords objectMainApplicationService = null;
        try
        {
           // if (DeleteMainTablesData == true)
            //{
            //    objectMainApplicationService = new MainApplicationService.ScannedMedicalRecords();
            //    objectMainApplicationService.DeleteScannedMedicalRecords(ImageRecordId, UserCode, -1, false);
          //  }

            _strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            if (sqlConnectionImages.State != ConnectionState.Open)
            {
                sqlConnectionImages.Open();
            }
            objectSqlTransaction = sqlConnectionImages.BeginTransaction();
            sParam = new SqlParameter[2];
            sParam[0] = new SqlParameter("@ImageRecordId", SqlDbType.Int);
            sParam[0].Value = ImageRecordId;
            sParam[1] = new SqlParameter("@UserCode", SqlDbType.VarChar);
            sParam[1].Value = UserCode;
            SqlHelper.ExecuteNonQuery(objectSqlTransaction, CommandType.StoredProcedure, "ssp_PMDeleteImageRecordItems", sParam);
            objectSqlTransaction.Commit();
            return true;


        }
        catch (Exception ex)
        {
            objectSqlTransaction.Rollback();
            return false;
        }
        finally
        {
            if (sqlConnectionImages.State == ConnectionState.Open)
            {
                sqlConnectionImages.Close();
            }
            sqlConnectionImages = null;           
            objectSqlTransaction = null;
        }

    }


    [WebMethod]
    public DataSet GetImageRecordItemId(Int32 ImageRecordId)
    {
        string _strImageDatabaseConnectionString;
        SqlConnection sqlConnectionImages = null;
        SqlTransaction objectSqlTransaction = null;
        DataSet DatasetImage = new DataSet();
        //MainApplicationService.ScannedMedicalRecords objectMainApplicationService = null;
        try
        {
            // if (DeleteMainTablesData == true)
            //{
            //    objectMainApplicationService = new MainApplicationService.ScannedMedicalRecords();
            //    objectMainApplicationService.DeleteScannedMedicalRecords(ImageRecordId, UserCode, -1, false);
            //  }

            _strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            //sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            //if (sqlConnectionImages.State != ConnectionState.Open)
            //{
            //    sqlConnectionImages.Open();
            //}
            // objectSqlTransaction = sqlConnectionImages.BeginTransaction();
            sParam = new SqlParameter[1];
            sParam[0] = new SqlParameter("@ImageRecordItemId", SqlDbType.Int);
            sParam[0].Value = ImageRecordId;
           
            SqlHelper.FillDataset(_strImageDatabaseConnectionString, CommandType.StoredProcedure, "ssp_GetImageRecordItem", DatasetImage, new string[] { "ListPageSCAlerts", "Alerts" }, sParam);
            return DatasetImage;

        }
        catch (Exception ex)
        {
            objectSqlTransaction.Rollback();
            return null;
        }
        finally
        {
           
        }

    }


    [WebMethod]
    /// <summary>
    /// Author - Akwinass
    /// To get multiple image record items
    /// </summary>
    /// <param name="ImageRecordIds"></param>
    /// <returns></returns>
    public DataTable GetMultipleImagesfromDatabase(string ImageRecordIds)
    {
        DataTable dataTableImages = null;
        SqlConnection sqlConnectionImages = null;
        try
        {
            // return ImageRecordId;
            sParam = new SqlParameter[1];
            // dsImages = new DataTable();
            string _strImageDatabaseConnectionString = "";
            //_strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            dataTableImages = new DataTable();
            sParam[0] = new SqlParameter("@ImageRecordIds", SqlDbType.VarChar);
            sParam[0].Value = ImageRecordIds;

            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            dataTableImages = SqlHelper.ExecuteDataset(sqlConnectionImages, "ssp_SCGetReportImageRecordServices", sParam).Tables[0];
            dataTableImages.TableName = "ImageRecordItems";
            return dataTableImages;
        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {

            sqlConnectionImages = null;

            if (dataTableImages != null)
                dataTableImages.Dispose();

            sqlConnectionImages = null;
        }
    }

 [WebMethod]
    /// <summary>
    /// Author - Akwinass
    /// To move image record items when performing move documents.
    /// </summary>
    /// <param name="ImageRecordIds"></param>
    /// <returns></returns>
    public void MoveImageRecordItems(string XMLImageRecords)
    {
        SqlConnection sqlConnectionImages = null;
        try
        {
            sParam = new SqlParameter[1];
            string _strImageDatabaseConnectionString = "";
            _strImageDatabaseConnectionString = System.Configuration.ConfigurationManager.AppSettings.Get("ImageDatabaseConnectionString");
            if (_strImageDatabaseConnectionString == "" || _strImageDatabaseConnectionString == null)
                throw new Exception("Error opening connection for Image DatabaseConfigurationName");
            sParam[0] = new SqlParameter("@XMLImageRecords", SqlDbType.VarChar);
            sParam[0].Value = XMLImageRecords;

            sqlConnectionImages = new SqlConnection(_strImageDatabaseConnectionString);
            SqlHelper.ExecuteNonQuery(sqlConnectionImages, "ssp_SCMoveImageRecordItems", sParam);
        }
        catch (Exception ex)
        {

            throw (ex);
        }
        finally
        {

            sqlConnectionImages = null;
        }
    }


}

