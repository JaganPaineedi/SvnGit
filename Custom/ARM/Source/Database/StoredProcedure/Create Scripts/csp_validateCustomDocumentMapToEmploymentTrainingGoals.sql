/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentMapToEmploymentTrainingGoals]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentTrainingGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentTrainingGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentTrainingGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentTrainingGoals]        
@DocumentVersionId Int, @TabId int      
As        
  
BEGIN  
  
BEGIN TRY      
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)
   

CREATE TABLE [#CustomDocumentMapToEmploymentTrainingGoals] (
 EmploymentTrainingGoalId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,DocumentVersionId int
,TrainingGoal varchar(max)

)        
        
INSERT INTO [#CustomDocumentMapToEmploymentTrainingGoals](  
 EmploymentTrainingGoalId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,TrainingGoal
)  
select   
  EmploymentTrainingGoalId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,TrainingGoal
from CustomDocumentMapToEmploymentTrainingGoals a         
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

SELECT ''CustomDocumentMapToEmploymentTrainingGoals'', ''DeletedBy'', ''Training Goals  - At least 1 training goal is required'',@TabId ,1
where not exists ( select 1 from #CustomDocumentMapToEmploymentTrainingGoals )

union
SELECT ''CustomDocumentMapToEmploymentTrainingGoals'', ''DeletedBy'', ''Training Goals  - Training goal text is required'',@TabId ,1
FROM #CustomDocumentMapToEmploymentTrainingGoals
WHERE LEN(LTRIM(RTRIM(ISNULL(TrainingGoal, '''')))) = 0

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
