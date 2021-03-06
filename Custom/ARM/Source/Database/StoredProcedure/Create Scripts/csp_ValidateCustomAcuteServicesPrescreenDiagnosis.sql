/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomAcuteServicesPrescreenDiagnosis]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAcuteServicesPrescreenDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomAcuteServicesPrescreenDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAcuteServicesPrescreenDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE [dbo].[csp_ValidateCustomAcuteServicesPrescreenDiagnosis]
@documentVersionId int
as

Create Table #DiagnosesIandII
(
	Axis int NOT NULL ,
	DSMCode char (6) NOT NULL ,
	DSMNumber int NOT NULL ,
	DiagnosisType int,
	RuleOut char(1),
	Billable char(1),
	Severity int,
	DSMVersion varchar (6) NULL ,
	DiagnosisOrder int NOT NULL ,
	Specifier text NULL ,
	RowIdentifier char(36),
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100) 
)
Insert into #DiagnosesIandII
(
Axis, DSMCode, DSMNumber, DiagnosisType,
RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,
 RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
RecordDeleted, DeletedDate, DeletedBy )

select
Axis, DSMCode, DSMNumber, DiagnosisType,
 RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier, 
a.RowIdentifier, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate,
 a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM DiagnosesIAndII a
where a.documentVersionId = @documentVersionId
and isnull(a.RecordDeleted,''N'') = ''N''

CREATE TABLE #DiagnosesV (
	AxisV int NULL ,
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100))

Insert into #DiagnosesV
(
AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,
 DeletedDate, DeletedBy
)
select
AxisV, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted,
a.DeletedDate, a.DeletedBy
FROM DiagnosesV a
where a.documentVersionId = @documentVersionId
and isnull(a.RecordDeleted,''N'') = ''N''




Insert into #validationReturnTable
	(TableName,
	ColumnName,
	ErrorMessage
	)

	Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please specify Axis I - II primary diagnosis''
		where not exists
		(select 1 from #diagnosesIandII where isnull(DSMCode,'''') <> '''' 
		 and DiagnosisType = 140
		 and isnull(Axis,'''') in (1, 2))
	UNION
	Select ''DiagnosesIandII'', ''DeletedBy'', ''Dx - Please select Axis I - II diagnosis type''
		where not exists
		(select 1 from #diagnosesIandII where isnull(DSMCode,'''') <> ''''
		and isnull(Axis,'''') in (1, 2) and isnull(DiagnosisType,'''') <> '''')	
	Union
	Select ''CustomDiagnosis'', ''DeletedBy'', ''Dx - V code or 799 cannot be primary diagnosis''
	where exists (Select 1 from #DiagnosesIAndII
				  where (DSMCode like ''V%'' or DSMCode like ''799%'')
				  and DiagnosisType = 140)
				  
	-- DJH Changed for Riverwood
	--UNION
	--Select ''DiagnosesV'', ''DeletedBy'', ''Dx - Please enter Axis V diagnosis''
	--	where not exists
	--	(select 1 from #DiagnosesV where isnull(AxisV,'''') <> '''')	



return

error:
raiserror 50000 ''csp_validateDiagnosis failed.  Contact your system administrator.''
' 
END
GO
