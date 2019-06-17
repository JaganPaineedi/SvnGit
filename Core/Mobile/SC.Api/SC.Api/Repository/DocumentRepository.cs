using System;
using SC.Api.Models;
using System.Data;
using SC.Data;
using System.Data.SqlClient;
using System.Linq;
using Newtonsoft.Json;
using System.Data.Entity.Infrastructure;
using System.IO;

namespace SC.Api
{
    public class DocumentRepository : IDocumentRepository
    {
        SqlParameter[] _objectSqlParmeters = null;
        SqlConnection _sqlConnection = null;
        SqlTransaction _sqlTransaction = null;
        ICommonRepository _commonRepository = null;
        private SCMobile _ctx;

        public DocumentRepository(SCMobile ctx)
        {
            _ctx = ctx;
            _commonRepository = new CommonRepository(_ctx);
        }

        /// <summary>
        /// UpdateSignature
        /// </summary>
        /// <param name="sig"></param>
        /// <returns></returns>
        public _SCResult<ClientDocumentsModel> UpdateSignature(ClientDocumentsModel sig)
        {
            var _Ce = new _SCResult<ClientDocumentsModel>();

            if (!string.IsNullOrEmpty(sig.Signature.SignatureString))
            {
                //1
                _sqlConnection = new SqlConnection(_ctx.Database.Connection.ConnectionString);
                _sqlConnection.Open();

                _sqlTransaction = _sqlConnection.BeginTransaction(IsolationLevel.ReadUncommitted, "_sqlTransaction");
                sig.Signature.SignatureString = sig.Signature.SignatureString.Replace("data:image/png;base64,", "");

                var signatureImageBytes = Convert.FromBase64String(SC.Base.CommonFunctions.EncodeBase64(sig.Signature.SignatureString));



                //var path = "C:\\Users\\pradeepa\\AppData\\Local\\Microsoft\\Windows\\INetCache\\test123.jpeg";
                //System.Drawing.Image newImage;
                //using (MemoryStream stream = new MemoryStream(signatureImageBytes))
                //{
                //    newImage = System.Drawing.Image.FromStream(stream, true);
                //    newImage.Save(path);
                //    //img.Attributes.Add("src", strFileName);
                //}

                ScreenModel sModel = _commonRepository.GetScreenDetail(sig.DocumentCodeId);

                var userCode = _ctx.Documents
                    .Where(d => d.DocumentId == sig.DocumentId)
                    .Select(d => d.ModifiedBy).FirstOrDefault();
                var ClientId = sig.IsClient == "Y" ? sig.ClientId : 0;

                SignedByClient(ClientId, sig.DocumentId, signatureImageBytes, sig.SignatureId, sig.DocumentVersionId, userCode, _sqlTransaction);

                DataSet dataset = ExecuteUpdateStoredProcedure(_sqlTransaction, sModel.PostUpdateStoredProcedure, sig.DocumentId, sig.AuthorId, userCode, "");

                if (dataset.Tables.Count > 0 && dataset.Tables["PostUpdateErrorDetails"].Rows.Count > 0)
                {
                    _sqlTransaction.Rollback();
                    _Ce.NoteValidationMessages = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(dataset));
                }
                else
                {
                    _sqlTransaction.Commit();

                    DocumentPDFGenerationQueue queue = new DocumentPDFGenerationQueue();
                    queue.DocumentPDFGenerationQueueId = -1;
                    queue.CreatedBy = "APIDocumentRepository";
                    queue.CreatedDate = DateTime.Now;
                    queue.ModifiedBy = "APIDocumentRepository";
                    queue.ModifiedDate = DateTime.Now;
                    queue.DocumentVersionId = Convert.ToInt32(sig.DocumentVersionId);

                    _ctx.DocumentPDFGenerationQueue.Add(queue);

                    _ctx.SaveChanges();

                    _Ce.SavedResult = GetDocumentModel(sig.DocumentVersionId);
                    _Ce.DeleteObjectStoreData = true;
                    _Ce.DeleteUnsavedChanges = true;
                    _Ce.SavedId = _Ce.SavedResult.DocumentVersionId;
                    _Ce.UnsavedId = _Ce.SavedResult.DocumentVersionId;
                }

                //Call SignDocument Function
                //1. Convert Signature String to Bytes
                //2. Call SignedbyClient
                //3. Pass DocumentId and get ssp_SCGetDocumentDetailOfDocumentID Documents table data using ssp_SCGetDocumentDetailOfDocumentID (TNOT REQUIRED) - Get CurrentUser From Modified By ModifiedBy
                //4. Call ssp_SCSignatureSignedByClient passig parameters Transaction
                //5. Call DocumentPostSignatureUpdates- StaffId,DocumentId,Transaction,
                //6. Call DocumentPostSignatureUpdates ssp_SCDocumentPostSignatureUpdates Pass UserId and DocumentId
                //7. Call ExceutePostUpdateScreenStoredProcedureCore GetSP name from Screens.PostUpdateScreenStoredProcedureCore for the DocumentCodeId and rerurn PostUpdateErrorDetails Table
                //8. If record found in PostUpdateErrorDetails, Rollback transaction Otherwise call ExecuteUpdateStoredProcedure With Screens .PostUpdateStoredProcedure. 
                //9. If records found PostUpdateErrorDetails in Rollback Otherwise Commit
            }
            return _Ce;
        }

        /// <summary>
        /// SignedByClient
        /// </summary>
        /// <param name="staffId"></param>
        /// <param name="documentId"></param>
        /// <param name="stringSignatureByte"></param>
        /// <param name="signatureId"></param>
        /// <param name="documentVersionId"></param>
        /// <param name="UserCode"></param>
        /// <param name="_sqlTransaction"></param>
        /// <returns></returns>
        public bool SignedByClient(int staffId, int documentId, byte[] stringSignatureByte, int signatureId, int documentVersionId, string UserCode, SqlTransaction _sqlTransaction)
        {
            //SqlConnection con = new SqlConnection(_ctx.Database.Connection.ConnectionString);
            //con.Open();

            SqlCommand cmd = new SqlCommand("ssp_SCSignatureSignedByClient", _sqlConnection, _sqlTransaction);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new SqlParameter("@ClientID", staffId));
            cmd.Parameters.Add(new SqlParameter("@DocumentID", documentId));
            cmd.Parameters.Add(new SqlParameter("@ClientSignedPaper", "N"));
            cmd.Parameters.Add(new SqlParameter("@SignatureData", stringSignatureByte));
            cmd.Parameters.Add(new SqlParameter("@SignatureID", signatureId));
            cmd.Parameters.Add(new SqlParameter("@DocumentVersionId", documentVersionId)); 
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", UserCode));

            cmd.ExecuteNonQuery();

            DocumentPostSignatureUpdates(staffId, documentId, _sqlTransaction);

            return false;
        }

        /// <summary>
        /// DocumentPostSignatureUpdates
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="documentId"></param>
        /// <param name="_sqlTransaction"></param>
        public void DocumentPostSignatureUpdates(int userId, int documentId, SqlTransaction _sqlTransaction)
        {
            try
            {
                //SqlConnection con = new SqlConnection(_ctx.Database.Connection.ConnectionString);
                //con.Open();

                SqlCommand cmd = new SqlCommand("ssp_SCDocumentPostSignatureUpdates", _sqlConnection, _sqlTransaction);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@CurrentUserId", userId));
                cmd.Parameters.Add(new SqlParameter("@DocumentId", documentId));

                cmd.ExecuteNonQuery();
            }
            finally { _objectSqlParmeters = null; }
        }

        internal DataSet ExecuteUpdateStoredProcedure(SqlTransaction sqlTrans, string storeProcedureName, int screenKeyId, Int32 staffId, string loggedInUser, string parametersXML)
        {
            DataSet dsPostUpdateStoredProcedureResult = new DataSet();
            DataSet datasetPostUpdateErrorDetails = new DataSet();
            try
            {
                if (!string.IsNullOrEmpty(storeProcedureName ))
                {
                    //SqlConnection con = new SqlConnection(_ctx.Database.Connection.ConnectionString);
                    //con.Open();

                    SqlCommand cmd = new SqlCommand(storeProcedureName, _sqlConnection, _sqlTransaction);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@ScreenKeyId", screenKeyId));
                    cmd.Parameters.Add(new SqlParameter("@StaffId", staffId));
                    cmd.Parameters.Add(new SqlParameter("@CurrentUser", loggedInUser));
                    cmd.Parameters.Add(new SqlParameter("@CustomParameters", parametersXML));
                    SqlDataAdapter _sqlAdpt = new SqlDataAdapter(cmd);

                    _sqlAdpt.Fill(dsPostUpdateStoredProcedureResult, "PostUpdateErrorDetails");

                    if (dsPostUpdateStoredProcedureResult != null)
                    {
                        if (dsPostUpdateStoredProcedureResult.Tables.Count > 0)
                        {
                            dsPostUpdateStoredProcedureResult.Tables[0].Columns[0].ColumnName = "TableName";
                            dsPostUpdateStoredProcedureResult.Tables[0].Columns[1].ColumnName = "ColumnName";
                            dsPostUpdateStoredProcedureResult.Tables[0].Columns[2].ColumnName = "ErrorMessage";
                            dsPostUpdateStoredProcedureResult.Tables[0].Columns[3].ColumnName = "PageIndex";
                            datasetPostUpdateErrorDetails.Merge(dsPostUpdateStoredProcedureResult.Tables["PostUpdateErrorDetails"]);
                        }

                    }

                }
                return datasetPostUpdateErrorDetails;
            }
            catch (Exception ex)
            {
                    string CustomExceptionInformation = string.Empty;
                    CustomExceptionInformation = "ExecuteUpdateStoredProcedure() method fails in Documents.cs file of DataServices component";
                    string exMsg = ex.ToString() + "~" + CustomExceptionInformation + "~" + "#" + ex.Message + "#";
                    throw new Exception(exMsg);
               
            }
            finally
            {
                if (datasetPostUpdateErrorDetails != null)
                {
                    datasetPostUpdateErrorDetails.Dispose();
                }
                if (dsPostUpdateStoredProcedureResult != null)
                {
                    dsPostUpdateStoredProcedureResult.Dispose();
                }
            }
        }

        public ClientDocumentsModel GetDocumentModel(int DocumentVersionId)
        {
            ClientDocumentsModel _clientDocuments = new ClientDocumentsModel();

            _ctx.Database.Initialize(force: false);

            var cmd = _ctx.Database.Connection.CreateCommand();
            cmd.CommandText = "[dbo].[smsp_GetDocument]";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            try
            {
                _ctx.Database.Connection.Open();
                cmd.Parameters.Add(new SqlParameter("DocumentVersionId", DocumentVersionId));
                var reader = cmd.ExecuteReader();

                _clientDocuments = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<Models.ClientDocumentsModel>(reader).FirstOrDefault();

            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetDocuments method." + ex.Message);
                throw excep;
            }
            finally
            { _ctx.Database.Connection.Close(); }

            return _clientDocuments;
        }
    }
}