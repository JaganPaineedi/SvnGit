/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentPreventionServicesNotes]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentPreventionServicesNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_validateCustomDocumentPreventionServicesNotes]      
@DocumentVersionId Int      
as  
BEGIN

BEGIN TRY    
           
CREATE TABLE #CustomDocumentPreventionServicesNotes (      
 DocumentVersionId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,NumberOfParticipants int
,DescriptionOfPreventionActivity varchar(max)
)      
      
INSERT INTO #CustomDocumentPreventionServicesNotes(      
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,NumberOfParticipants
,DescriptionOfPreventionActivity
)      
select      
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,NumberOfParticipants
,DescriptionOfPreventionActivity
from #CustomDocumentPreventionServicesNotes a       
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

SELECT ''CustomDocumentPreventionServicesNotes'', ''DeletedBy'', ''General  - Number of participants section is required'',1 ,1
FROM #CustomDocumentPreventionServicesNotes
WHERE ISNULL(NumberOfParticipants,0) = 0

UNION
SELECT ''CustomDocumentPreventionServicesNotes'', ''DeletedBy'', ''General  - Description of prevention activity section is required'',1 ,1
FROM #CustomDocumentPreventionServicesNotes 
WHERE LEN(LTRIM(RTRIM(ISNULL(DescriptionOfPreventionActivity, '''')))) = 0


UNION
SELECT ''Services'', ''DeletedBy'',''Service  - Other person must be present if client is not present for this Service'' ,0,1
FROM #CustomDocumentPreventionServicesNotes c
join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
join Documents d on d.DocumentId = dv.DocumentId
join Services s on s.ServiceId = d.ServiceId
where isnull(s.ClientWasPresent,''N'')<>''Y''
and isnull(s.OtherPersonsPresent,''N'') <> ''Y''

--UNION
--SELECT ''Services'', ''DeletedBy'',''Service  - Billable must be selected for this service'' ,0,1
--FROM #CustomDocumentPreventionServicesNotes c
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.Billable,''N'')<>''Y''

--exec dbo.csp_ValidateServiceGoal @ServiceId 

--exec dbo.csp_ValidateServiceObjective @ServiceId

END TRY

BEGIN CATCH

 DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomDocumentPreventionServicesNotes'')                                                                                 
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
