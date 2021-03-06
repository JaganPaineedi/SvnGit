IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomIndividualServiceNoteCurrentLifeEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomIndividualServiceNoteCurrentLifeEvent] 
GO
    
CREATE  PROCEDURE [dbo].[csp_RDLCustomIndividualServiceNoteCurrentLifeEvent] ( 
@DocumentVersionId INT=0) 
/************************************************* 
  Date:			Author:				Description:                             
   
  -------------------------------------------------------------------------             
 07-Jan-2015    Malathi Shiva       What: Psychiatric Team Meeting Service Client Life Events  information 
									Why:task #824 Woods-Customizations 
************************************************/ 
AS 
  BEGIN 
      BEGIN TRY 
          DECLARE @ClientId INT 
          DECLARE @ServiceId INT 

          SELECT @ClientId = D.ClientId, 
                 @ServiceId = D.ServiceId 
          FROM   Documents D 
          WHERE  ISNULL(D.RecordDeleted, 'N') = 'N' 
                 AND D.InProgressDocumentVersionId = @DocumentVersionId 

          EXEC csp_CustomDocumentGetCurrentLifeEvents 
            @ClientId, 
            @DocumentVersionId, 
            @ServiceId 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'csp_RDLCustomIndividualServiceNoteCurrentLifeEvent') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,/* Message text.*/16,/* Severity.*/ 1 /*State.*/ ); 
      END CATCH 
  END 