/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentEAPNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentEAPNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentEAPNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentEAPNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_validateCustomDocumentEAPNotes]      
@DocumentVersionId Int      
as  
BEGIN

BEGIN TRY    
           
CREATE TABLE [#CustomDocumentEAPNotes] (      
            DocumentVersionId int NULL,
            Narrative varchar(max) null 
)      
      
INSERT INTO [#CustomDocumentEAPNotes](      
            DocumentVersionId,
            Narrative
)      
select      
            a.DocumentVersionId,
            a.Narrative
from CustomDocumentEAPNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')=''N''   
    


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int, @ServiceId int

select @Sex = isnull(c.Sex,''U''), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId, 
	@DocumentCodeId = d.DocumentCodeId, @ServiceId = d.ServiceId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)

SELECT ''CustomDocumentEAPNotes'', ''DeletedBy'', ''General  - Narrative section is required'',1 ,1
FROM #CustomDocumentEAPNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(Narrative, '''')))) = 0

--UNION
--SELECT ''Services'', ''DeletedBy'',''Service  - Client must be present for this Service'' ,0,1
--FROM #CustomDocumentEAPNotes c
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.ClientWasPresent,''N'')<>''Y''

--UNION
--SELECT ''Services'', ''DeletedBy'',''Service  - Billable must be selected for this service'' ,0,1
--FROM #CustomDocumentEAPNotes c
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.Billable,''N'')<>''Y''

exec dbo.csp_ValidateServiceGoal @ServiceId 

exec dbo.csp_ValidateServiceObjective @ServiceId

/*   
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
*/      
END TRY

BEGIN CATCH

 DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomDocumentEAPNotes'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
    RAISERROR                                                                                 
   (                                                   
    @Error, -- Message text.                                                                                
    16, -- Severity.                                                                                
    1 -- State.                                                                                
   );  
   
END CATCH

return 

END     

' 
END
GO
