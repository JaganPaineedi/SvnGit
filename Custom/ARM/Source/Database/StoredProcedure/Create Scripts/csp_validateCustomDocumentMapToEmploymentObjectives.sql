/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentMapToEmploymentObjectives]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentObjectives]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentObjectives]        
@DocumentVersionId Int, @TabId int, @Type varchar(1)        
As        
  
BEGIN  
  
BEGIN TRY      
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)
   

CREATE TABLE [#CustomDocumentMapToEmploymentObjectives] (
 EmploymentObjectiveId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,DocumentVersionId int
,ObjectiveType char(1)
,ObjectiveText varchar(max)
,ObjectiveTargetDate datetime
)        
        
INSERT INTO [#CustomDocumentMapToEmploymentObjectives](  
EmploymentObjectiveId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,ObjectiveType
,ObjectiveText
,ObjectiveTargetDate	   
)  
select   
 EmploymentObjectiveId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,ObjectiveType
,ObjectiveText
,ObjectiveTargetDate
from CustomDocumentMapToEmploymentObjectives a         
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''        
      

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

--SELECT ''CustomDocumentMapToEmploymentObjectives'', ''DeletedBy'', ''Objectives  - Objective type selection is required'',@TabId ,1
--FROM #CustomDocumentMapToEmploymentObjectives
--WHERE LEN(LTRIM(RTRIM(ISNULL(ObjectiveType, '''')))) = 0
SELECT ''CustomDocumentMapToEmploymentObjectives'', ''DeletedBy''
,''Objectives  - At least 2 '' + Case @Type when ''D'' then ''development'' when ''C'' then ''coaching'' end + '' objectives are required'' 
,@TabId ,1
where Not exists ( select count(1) from #CustomDocumentMapToEmploymentObjectives a where a.ObjectiveType = @Type having count(1) >= 2 )

UNION
SELECT ''CustomDocumentMapToEmploymentObjectives'', ''DeletedBy''
,''Objectives  - ''+Case @Type when ''D'' then ''Development'' when ''C'' then ''Coaching'' end +'' objective text section is required''
,@TabId ,2
FROM #CustomDocumentMapToEmploymentObjectives
WHERE LEN(LTRIM(RTRIM(ISNULL(ObjectiveText, '''')))) = 0
and ObjectiveType = @Type

UNION
SELECT ''CustomDocumentMapToEmploymentObjectives'', ''DeletedBy''
,''Objectives  - ''+Case @Type when ''D'' then ''Development'' when ''C'' then ''Coaching'' end +'' objective target date is required'',@TabId ,3
FROM #CustomDocumentMapToEmploymentObjectives
WHERE ISNULL(ObjectiveTargetDate, ''1/1/1900'') = ''1/1/1900''
and ObjectiveType = @Type
        
        
END TRY  
  
BEGIN CATCH  
     DECLARE @Error varchar(8000)                                                     
     SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
      + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),@StoredProcedure)                                                                                   
      + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                    
      + ''*****'' + Convert(varchar,ERROR_STATE())                                
     RAISERROR                                                                                   
     (                                                     
      @Error, -- Message text.                                                                                  
      16, -- Severity.                                                                                  
      1 -- State.                                                                                  
     );         
END CATCH  
  
RETURN   
END
' 
END
GO
