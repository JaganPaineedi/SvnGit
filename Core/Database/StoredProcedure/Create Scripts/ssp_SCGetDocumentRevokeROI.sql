IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetDocumentRevokeROI]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_SCGetDocumentRevokeROI] 
  END 

go 

CREATE PROCEDURE [dbo].[ssp_SCGetDocumentRevokeROI] @DocumentVersionId INT 
AS 
/***************************************************************************/ 
/* Stored Procedure: [ssp_SCGetDocumentRevokeROI] */ 
/* Copyright: 2006 Streamline SmartCare               */ 
/* Creation Date:  November 22,2017                 */ 
/* Purpose: Gets Data */ 
/* Input Parameters: @DocumentVersionId            */ 
/* Output Parameters:                   */ 
/* Return:  0=success, otherwise an error number                           */ 
/* Purpose to show the web document for Revoke Release of Information  */ 
/* Calls:                                                                  */ 
/* Data Modifications:                                                     */ 
/* Updates:                                                                */ 
/* Modified Date            Name           Description					   */
/* 22/Nov/2017         Alok Kumar          Created	(Ref: Task#2013 Spring River - Customizations) */
  /***************************************************************************/ 
  BEGIN 
      BEGIN try 
          SELECT [documentversionid], 
                 [createdby], 
                 [createddate], 
                 [modifiedby], 
                 [modifieddate], 
                 [recorddeleted], 
                 [deleteddate], 
                 [deletedby], 
                 [clientinformationreleaseid], 
                 [revokeenddate], 
                 [clientwrittenconsent] 
          FROM   [dbo].[DocumentRevokeReleaseOfInformations] 
          WHERE  [documentversionid] = @DocumentVersionId 
                 AND Isnull([recorddeleted], 'N') = 'N' 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SCGetDocumentRevokeROI') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                       
                      16, 
                      -- Severity.                                                       
                      1 
          -- State.                                                       
          ); 
      END catch 
  END 