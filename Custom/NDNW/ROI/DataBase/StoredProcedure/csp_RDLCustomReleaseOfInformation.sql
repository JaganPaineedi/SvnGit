IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomReleaseOfInformation]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_RDLCustomReleaseOfInformation] 
  END 

GO 

/********************************************************************************                                                    
-- Stored Procedure: csp_RDLCustomReleaseOfInformation  342842
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: For report  RDLCustomReleaseOfInformation.      
--      
-- Author:  Atul Pandey
-- Date:    22/Jan/2013 
   
Modified Date            Name             Description
22/Jan/2013          Atul Pandey          Created
05/Feb/2013          Sanjay Bhardwaj      Modified wrt #2 in Newaygo Customization
								          1. Get OldDocumentVersionId using DocumentVersionId and then pass to main query
*********************************************************************************/ 
CREATE PROCEDURE [dbo].[csp_RDLCustomReleaseOfInformation] 
(
@DocumentVersionId INT
) 
AS 
  BEGIN Try 
    declare @ODocumentVersionId INT
    update CustomDocumentReleaseOfInformations
    set OldDocumentVersionId=DocumentVersionId
    where DocumentVersionId=@DocumentVersionId and OldDocumentVersionId is null
    select @ODocumentVersionId=OldDocumentVersionId from CustomDocumentReleaseOfInformations where DocumentVersionId=@DocumentVersionId
    select distinct ReleaseOfInformationId,c.ClientId
     from  CustomDocumentReleaseOfInformations CDR		
		  inner join DocumentVersions DV on dv.DocumentVersionId=CDR.DocumentVersionId   
		  inner join Documents D on D.DocumentId=Dv.DocumentId   
		  inner join Clients C on D.ClientId=C.ClientId  
      where CDR.OldDocumentVersionId =@ODocumentVersionId
        AND ISNULL(CDR.RecordDeleted,'N')='N'
        AND ISNULL(DV.RecordDeleted,'N')='N'
        AND ISNULL(D.RecordDeleted,'N')='N'
        AND ISNULL(C.RecordDeleted,'N')='N'


  
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + 
                              CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
                  + 
                              isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                              'csp_RDLCustomReleaseOfInformation') + 
                              '*****' + CONVERT(VARCHAR, ERROR_LINE()) + 
                  '*****ERROR_SEVERITY=' + 
                              CONVERT(VARCHAR, ERROR_SEVERITY()) + 
                  '*****ERROR_STATE=' 
                  + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1/*State*/ ) 
  END CATCH 