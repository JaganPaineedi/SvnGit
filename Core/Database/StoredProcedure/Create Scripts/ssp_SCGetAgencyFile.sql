IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAgencyFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAgencyFile]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAgencyFile] (      
 @Agencyid INT      
 ,@ExternalCollectionChargeIds VARCHAR(max)   
 ,@UpdateRecords VARCHAR(1)   
 )      
AS      
BEGIN      
 /*********************************************************************/      
 /* Stored Procedure: dbo.[ssp_SCGetAgencyFile]                */      
 /* Creation Date:    10 Feb 2017                                        */      
 /* Created By :    Vithobha                               */      
 /*                                                                   */      
 /* Purpose: To get Agency File   */      
 /*                                                                   */      
 /*   Updates:                                                          */      
 /*       Date              Author                  Purpose                                    */      
 /*********************************************************************/      
 BEGIN TRY      
  DECLARE @AgencySpname VARCHAR(200)      
  DECLARE @ExternalCollectionFileBatchId INT      
      
  SELECT @AgencySpname = FileFormatSP      
  FROM CollectionAgencies      
  WHERE CollectionAgencyId = @Agencyid      
      
  EXEC @AgencySpname @Agencyid      
   ,@ExternalCollectionChargeIds,@ExternalCollectionFileBatchId= @ExternalCollectionFileBatchId OUTPUT      
      
  SELECT  CreatedFileName      
   ,FileContent      
  FROM ExternalCollectionFileBatches WHERE ExternalCollectionFileBatchId= @ExternalCollectionFileBatchId      
   
   IF @UpdateRecords = 'Y'  
   BEGIN
	   UPDATE Charges set ExternalCollectionStatus =(Select GlobalCodeId From GlobalCOdes Where Category='ExtCollectionStatus' and Code='Sent to Collection Agency' AND ISNULL(RecordDeleted, 'N') = 'N')       
	   WHERE ChargeId in (SELECT ChargeId from ExternalCollectionCharges WHERE ExternalCollectionChargeId in ( SELECT item FROM [dbo].fnSplit(@ExternalCollectionChargeIds, ',') ) AND ISNULL(RecordDeleted, 'N') = 'N' )    
   END    
   
 END TRY      
     
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAgencyFile') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
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


