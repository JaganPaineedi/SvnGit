IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_RDLGetClientContacts]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_RDLGetClientContacts] 

GO 

CREATE PROCEDURE [dbo].[csp_RDLGetClientContacts] 
-- csp_GetClientContacts 2                     
(@DocumentVersionID INT) 

AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_GetClientContacts]               */ 
/* Creation Date:  08 Sept 2014                                    */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To load data after save */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN TRY 
      declare @ClientID int  
            set @ClientID = (select ClientId from documents where InProgressDocumentVersionId =@DocumentVersionID )         
	EXEC csp_GetClientContacts 
        @ClientID
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                  + '*****' 
                  + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                  'csp_RDLGetClientContacts') 
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error,-- Message text.                       
                  16,-- Severity.                       
                  1 -- State.                       
      ); 
  END CATCH 

GO 