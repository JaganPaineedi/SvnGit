   
 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_NEWRDLSCGetVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_NEWRDLSCGetVitals]
GO   
   
CREATE PROCEDURE [dbo].[csp_NEWRDLSCGetVitals] (@DocumentVersionId int  )    
AS    
/*********************************************************************/    
/* Stored Procedure: [csp_NEWRDLSCGetVitals] 737170
34708
  */    
/*       Date              Author                  Purpose                   */    
/*      12-29-2014         PABITRA              To Get Vitals Data          */    
/*********************************************************************/    
BEGIN    
 BEGIN TRY  
 DECLARE @ClientId INT    
  
  DECLARE @DateOfService DATETIME    
   
   SELECT @ClientId = D.ClientId    
    ,@DateOfService=S.DateOfService      
   FROM Documents D      
    INNER JOIN Services S ON D.ServiceId=S.ServiceId      
   WHERE D.InProgressDocumentVersionId=@DocumentVersionId AND      
   IsNull(D.RecordDeleted,'N')='N'      
   AND IsNull(S.RecordDeleted,'N')='N'     
   
  DECLARE @IntegerCodeId INT    
    
  SET @IntegerCodeId = (    
    SELECT integercodeid    
    FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICNOTEVITAL')    
    )    

  

EXEC csp_RDLGetClientHealthData @ClientId,@IntegerCodeId

 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())  
   + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
  'csp_NEWRDLSCGetVitals') + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +   
  CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                                    
    16    
    ,-- Severity.                                                                                                                    
    1 -- State.                                                                                                                    
    );    
 END CATCH    
END 