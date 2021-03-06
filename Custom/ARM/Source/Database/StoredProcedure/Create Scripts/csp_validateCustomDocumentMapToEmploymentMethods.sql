/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentMapToEmploymentMethods]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentMethods]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentMethods]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentMapToEmploymentMethods]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_validateCustomDocumentMapToEmploymentMethods]        
@DocumentVersionId Int, @TabId int, @Type varchar(1)        
As        
  
BEGIN  
  
BEGIN TRY      
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)
   

CREATE TABLE [#CustomDocumentMapToEmploymentMethods] (
 EmploymentMethodId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,DocumentVersionId int
,MethodType char(1)
,MethodsTechniques varchar(max)
,ProvidedBy int
)        
        
INSERT INTO [#CustomDocumentMapToEmploymentMethods](  
 EmploymentMethodId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,MethodType
,MethodsTechniques
,ProvidedBy
)  
select   
 EmploymentMethodId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,MethodType
,MethodsTechniques
,ProvidedBy
from CustomDocumentMapToEmploymentMethods a         
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


SELECT ''CustomDocumentMapToEmploymentMethods'', ''DeletedBy''
,''Methods  - At least 1 '' + Case @Type when ''D'' then ''development'' when ''C'' then ''coaching'' end + '' method is required'' 
,@TabId ,1
where Not exists ( select 1 from #CustomDocumentMapToEmploymentMethods a where a.MethodType = @Type  )

UNION
SELECT ''CustomDocumentMapToEmploymentMethods'', ''DeletedBy''
,''Methods  - ''+Case @Type when ''D'' then ''Development'' when ''C'' then ''Coaching'' end +'' Provided by is required''
,@TabId ,2
FROM #CustomDocumentMapToEmploymentMethods
WHERE LEN(LTRIM(RTRIM(ISNULL(ProvidedBy, '''')))) = 0
and MethodType = @Type

UNION
SELECT ''CustomDocumentMapToEmploymentMethods'', ''DeletedBy''
,''Methods  - ''+Case @Type when ''D'' then ''Development'' when ''C'' then ''Coaching'' end +'' method text section is required''
,@TabId ,3
FROM #CustomDocumentMapToEmploymentMethods
WHERE LEN(LTRIM(RTRIM(ISNULL(MethodsTechniques, '''')))) = 0
and MethodType = @Type
        
        
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
