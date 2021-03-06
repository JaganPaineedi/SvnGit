/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentMapToEmploymentResponsibilities]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentResponsibilities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentResponsibilities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentResponsibilities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentResponsibilities]        
@DocumentVersionId Int, @TabId int, @Type varchar(1)        
As        
  
BEGIN  
  
BEGIN TRY      
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)
   

CREATE TABLE [#CustomDocumentMapToEmploymentResponsibilities] (
 EmploymentResponsibilityId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,DocumentVersionId int
,ResponsibilityType char(1)
,ResponsibilityComment varchar(max)
)        
        
INSERT INTO [#CustomDocumentMapToEmploymentResponsibilities](  
EmploymentResponsibilityId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,ResponsibilityType
,ResponsibilityComment
)  
select   
 EmploymentResponsibilityId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,ResponsibilityType
,ResponsibilityComment
from CustomDocumentMapToEmploymentResponsibilities a         
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


SELECT ''CustomDocumentMapToEmploymentResponsibilities'', ''DeletedBy''
,''Responsibilities  - At least 1 '' + Case @Type when ''D'' then ''development'' when ''C'' then ''coaching'' end + '' responsibiliy is required'' 
,@TabId ,1
where Not exists ( select 1 from #CustomDocumentMapToEmploymentResponsibilities a where a.ResponsibilityType = @Type  )

UNION
SELECT ''CustomDocumentMapToEmploymentResponsibilities'', ''DeletedBy''
,''Responsibilities  - ''+Case @Type when ''D'' then ''Development'' when ''C'' then ''Coaching'' end +'' responsibiliy text section is required''
,@TabId ,2
FROM #CustomDocumentMapToEmploymentResponsibilities
WHERE LEN(LTRIM(RTRIM(ISNULL(ResponsibilityComment, '''')))) = 0
and ResponsibilityType = @Type

        
        
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
