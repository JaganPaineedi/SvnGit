/****** Object:  StoredProcedure [dbo].[csp_validateDiagnosis]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE    PROCEDURE [dbo].[csp_validateDiagnosis]
	@DocumentVersionId int,
	@TabOrder int = 1

--
-- change log
--
-- 2012.06.08 - Allow rule-out to be primary dx
as

DECLARE @DocumentCodeId INT
select @DocumentCodeId = DocumentCodeId
from dbo.Documents as d
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
where dv.DocumentVersionId = @DocumentVersionid

Create Table #DocumentDiagnosisCodes        
(        
 ICD10CodeId Varchar(20) NULL ,        
 ICD10Code Varchar(20) NULL ,        
 ICD9Code Varchar(20) NULL ,        
 DiagnosisType int,        
 RuleOut char(1),        
 Billable char(1),        
 Severity int,       
 DiagnosisOrder int NOT NULL ,        
 Specifier text NULL ,        
 CreatedBy varchar(100),        
 CreatedDate Datetime,        
 ModifiedBy varchar(100),        
 ModifiedDate Datetime,        
 RecordDeleted char(1),        
 DeletedDate datetime NULL ,        
 DeletedBy varchar(100) ,
 DocumentVersionId int       
)        
Insert into #DocumentDiagnosisCodes        
(        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId)        
        
select        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId        
FROM DocumentDiagnosisCodes        
where documentversionId = @documentversionId        
and isnull(RecordDeleted,''N'') = ''N''
    

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)

   SELECT ''DocumentDiagnosisCodes'',''DiagnosisType'',''Only one primary type should be available'', @TabOrder, 2 From #DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and((Select Count(*) AS RecordCount from #DocumentDiagnosisCodes WHERE DocumentVersionId = @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,''N'') = ''N'') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)
	UNION
	SELECT ''DocumentDiagnosisCodes'',''DiagnosisType'',''Primary Diagnosis must have a billing order of 1'', @TabOrder, 3 From #DocumentDiagnosisCodes where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)

return

error:
raiserror 50000 ''csp_validateDiagnosis failed.  Contact your system administrator.''



' 
END
GO
