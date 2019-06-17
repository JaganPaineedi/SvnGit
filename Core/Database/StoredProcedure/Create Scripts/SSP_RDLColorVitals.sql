   
 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_RDLColorVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_RDLColorVitals]
GO   
   
CREATE PROCEDURE [dbo].[SSP_RDLColorVitals] (@DocumentVersionId int  )    
AS    
/*********************************************************************/    
/* Stored Procedure: [SSP_RDLColorVitals] 741057
  */    
/*       Date              Author                  Purpose                   */    
/*      30-05-2018         PABITRA              To Get Vitals Data          */    
/*********************************************************************/    
BEGIN    
 BEGIN TRY  
 DECLARE @ClientId INT    
  
  DECLARE @DateOfService DATETIME    
   
   SELECT @ClientId = D.ClientId    
   FROM Documents D      
   WHERE D.InProgressDocumentVersionId=@DocumentVersionId AND      
   IsNull(D.RecordDeleted,'N')='N'          
   
  DECLARE @IntegerCodeId INT    
    
  SET @IntegerCodeId = 110
    
EXEC SCSP_RDLGetClientHealthData @ClientId,@IntegerCodeId

 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())  
   + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
  'SSP_RDLColorVitals') + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
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