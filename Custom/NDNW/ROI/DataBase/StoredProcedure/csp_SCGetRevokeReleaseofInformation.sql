IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_SCGetRevokeReleaseofInformation')
	BEGIN
		DROP  Procedure  csp_SCGetRevokeReleaseofInformation
	END

GO

CREATE PROCEDURE [dbo].[csp_SCGetRevokeReleaseofInformation]       
 @DocumentVersionId int             
AS    
/***************************************************************************/             
/* Stored Procedure: [csp_SCGetRevokeReleaseofInformation] 667296 */                                                             
/* Copyright: 2006 Streamline SmartCare               */                                                                      
/* Creation Date:  January 17,2013                 */                                                                      
/* Purpose: Gets Data */                                                                     
/* Input Parameters: @DocumentVersionId            */                                                                    
/* Output Parameters:                   */                                                                      
/* Return:  0=success, otherwise an error number                           */       
/* Purpose to show the web document for Revoke Release of Information  */                                                            
/* Calls:                                                                  */                            
/* Data Modifications:                                                     */                            
/* Updates:                                                                */                            
/* Date       Author        Purpose        */                            
/* 01/17/2013 Atul Pandey   Created        */   
/* 15 Feb 2019 K.Soujanya   Added ClientUnableToGiveWrittenConsent and RevokeROSComments in select statement as per the requirement, Why:New Directions - Enhancements,#22   */    
/***************************************************************************/                
  BEGIN    
  BEGIN TRY      
   SELECT [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientInformationReleaseId]
      ,[StaffId]
      ,[RevokeEndDate]
      ,[ClientUnableToGiveWrittenConsent]
      ,[RevokeROSComments]
  FROM [dbo].[CustomDocumentRevokeReleaseOfInformations]
 where [DocumentVersionId]=@DocumentVersionId
 and ISNULL( [RecordDeleted],'N')='N'

    
  End Try    
  BEGIN CATCH                                                     
  DECLARE @Error varchar(8000)                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetRevokeReleaseofInformation')                                                       
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                        
  + '*****' + Convert(varchar,ERROR_STATE())                                                      
 RAISERROR                                                       
 (                                                      
     @Error, -- Message text.                                                      
  16, -- Severity.                                                      
  1 -- State.                                                      
 );                                                      
 END CATCH       
END 