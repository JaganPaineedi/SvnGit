/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentActivityNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentActivityNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentActivityNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentActivityNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create   PROCEDURE [dbo].[csp_validateCustomDocumentActivityNotes]      
@DocumentVersionId Int      
AS
 
BEGIN

BEGIN TRY    
      
      
CREATE TABLE [#CustomDocumentActivityNotes] (      
            DocumentVersionId int NULL,
            Narrative varchar(max) null 
)      
      
INSERT INTO [#CustomDocumentActivityNotes](      
            DocumentVersionId,
            Narrative
)      
select      
            a.DocumentVersionId,
            a.Narrative
from CustomDocumentActivityNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')=''N''      
    
    
--    
-- DECLARE VARIABLES    
--    
declare @Variables varchar(max)    
declare @DocumentType varchar(20)    
Declare @DocumentCodeId int    
    
    
--    
-- DECLARE TABLE SELECT VARIABLES    
--    
set @Variables = ''Declare @DocumentVersionId int    
     Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)        
    
    
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)    
set @DocumentType = NULL    
    
--    
-- Exec csp_validateDocumentsTableSelect to determine validation list    
--    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables  
 
END TRY     
      
BEGIN CATCH     
   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_validateCustomDocumentActivityNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH    
      
return  

END' 
END
GO
