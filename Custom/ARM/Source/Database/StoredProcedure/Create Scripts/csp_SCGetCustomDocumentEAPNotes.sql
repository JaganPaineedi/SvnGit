/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentEAPNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentEAPNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentEAPNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentEAPNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
create PROCEDURE  [dbo].[csp_SCGetCustomDocumentEAPNotes] 
@DocumentVersionId INT      
AS  
      
BEGIN

BEGIN TRY  
              
SELECT      DocumentVersionId,
            CreatedBy,
            CreatedDate,
            ModifiedBy,
            ModifiedDate,
            RecordDeleted,
            DeletedBy,
            DeletedDate,
            Narrative               
 FROM       CustomDocumentEAPNotes    
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)        
      
END TRY  
                                                                                         
  BEGIN CATCH 
       
    DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetCustomDocumentEAPNotes'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
    RAISERROR                                                                                 
   (                                                   
    @Error, -- Message text.                                                                                
    16, -- Severity.                                                                                
    1 -- State.                                                                                
   );  
                                                                               
  END CATCH  
                  
END 
' 
END
GO
