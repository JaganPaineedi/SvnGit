IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDeleteDocumentVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebDeleteDocumentVersion]
GO
  
CREATE PROCEDURE [dbo].[ssp_SCWebDeleteDocumentVersion]                                                                       
( 
 @DocumentId int,	                                                                             
 @DocumentVersionId as int,                                                                              
 @DeletedBy as varchar(30)              
)                                                                              
AS                                                                              
/*********************************************************************/                                                                                
/* Stored Procedure: dbo.ssp_SCWebDeleteDocumentVersion                */                                                                                
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC             */                                                                                
/* Creation Date:   20 Feb 2012                                         */                                                                                
/*                                                                   */                                                                                
/* Purpose:This procedure is used to Delete the custom documents */                                                                              
/*                                                                   */                                                                              
/* Input Parameters: @DocumentId, @DeletedBy     */                                                                              
/*                                                                   */                                                                                
/* Output Parameters:        */                                                                                
/*                                                                   */                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                
/*                                                                   */                                                                                
/* Called By:                                                        */                                                                                
/*                                                                   */                                                                                
/* Calls:                                                            */                                                                                
/*                                                                   */                                                                                
/* Data Modifications:                                               */                                                                                
/*                                                                   */                                                                                
/* Updates:                                                          */                                                                                
/*  Date                Author               Purpose                                    */                                                                                
/* 20/2/2012			Maninder			Delete Document version  */
-- 03/05/2018			jcarlson			Andrews Center SGL 19 - fixed logic that was updating the AuthorId to the current version author Id
/*********************************************************************/                                                                                 
                                          
  Begin        
                                                               
                          
   BEGIN TRY        
if(@DocumentId<>0)         
  begin  
     
 
update DocumentVersions set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where DocumentVersionId=@DocumentVersionId                                                                            
update DocumentSignatures set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where DocumentId=@DocumentId and SignedDocumentVersionId is null 
update CustomFieldsData set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() where PrimaryKey1 =@DocumentVersionID                                                                   
    
exec scsp_SCWebDeleteDocuments @DocumentId,@DeletedBy     
 
UPDATE d 
SET d.AuthorId = dv.AuthorId,
d.InProgressDocumentVersionId = d.CurrentDocumentVersionId,
d.CurrentVersionStatus = d.[Status]
FROM Documents AS d
JOIN DocumentVersions AS dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
WHERE d.DocumentId = @DocumentId 
 
end       
           
END TRY                                          
  BEGIN CATCH                                          
   DECLARE @Error varchar(8000)                                                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                     
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebDeleteDocumentVersion')                                                                     
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                      
         + '*****' + Convert(varchar,ERROR_STATE())                                                                    
        RAISERROR                                                                     
   (                                                                    
     @Error, -- Message text.                                  
     16, -- Severity.                                                                    
     1 -- State.                                                                    
    );                                                                    
  END CATCH       
           
           
           
  End   
