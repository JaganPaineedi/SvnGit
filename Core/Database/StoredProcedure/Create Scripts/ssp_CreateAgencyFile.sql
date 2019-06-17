
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateAgencyFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CreateAgencyFile]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CreateAgencyFile] (      
 @Agencyid INT      
 ,@ExternalCollectionChargeIds VARCHAR(max)   
  ,@ExternalCollectionFileBatchId INT OUTPUT 
 )      
AS      
BEGIN      
 /*********************************************************************/      
 /* Stored Procedure: dbo.[ssp_SCGetAgencyFile]                */      
 /* Copyright: 2007 Provider Access Application            */      
 /* Creation Date:    10 Feb 2017                                        */      
 /* Created By :    Vithobha                               */      
 /*                                                                   */      
 /* Purpose: To get Agency File   */      
 /*                                                                   */      
 /*   Updates:                                                          */      
 /*       Date              Author                  Purpose                                    */      
 /*********************************************************************/      
 BEGIN TRY      
  --DECLARE @ExternalCollectionFileBatchId INT      
  
  INSERT INTO ExternalCollectionFileBatches (      
   CreatedFileName      
   ,SentDate      
   ,FileContent      
   )      
  VALUES (      
   'ExternalAgencyFile.txt'      
   ,GETDATE()      
   ,'test file creation'      
   )      
      
  SELECT @ExternalCollectionFileBatchId = SCOPE_IDENTITY()      
  UPDATE ExternalCollectionFileBatches set CreatedFileName = 'ExternalAgencyFile_' + convert(varchar(10),@ExternalCollectionFileBatchId) +'.txt'    
  WHERE ExternalCollectionFileBatchId=@ExternalCollectionFileBatchId    
      
  INSERT INTO ExternalCollectionFileBatchDetails (ExternalCollectionFileBatchId,ExternalCollectionChargeId) 
  SELECT @ExternalCollectionFileBatchId,item FROM [dbo].fnSplit(@ExternalCollectionChargeIds, ',')
   
    
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreateAgencyFile') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
  RAISERROR (      
    @Error      
    ,-- Message text.                    
    16      
    ,-- Severity.                    
    1 -- State.                    
    )      
 END CATCH      
END 
GO


