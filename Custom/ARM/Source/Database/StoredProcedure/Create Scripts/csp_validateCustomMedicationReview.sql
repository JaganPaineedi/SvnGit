/****** Object:  StoredProcedure [dbo].[csp_validateCustomMedicationReview]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicationReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMedicationReview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicationReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       PROCEDURE [dbo].[csp_validateCustomMedicationReview]
@DocumentVersionId Int  
as

Return

/*

DECLARE @DocumentCodeId INT
DECLARE @ServiceId INT
SELECT @DocumentCodeId = DocumentCodeId, @ServiceId = ServiceId 
	From Documents 
	Where CurrentDocumentVersionId = @DocumentVersionId



--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #CustomMedicationReviews
(
	DocumentVersionId int,
	Subjective varchar(max),
	Objective varchar(max),
	Assessment varchar(max),
	PlanDetail varchar(max),
	Aims varchar(max),
	SideEffects varchar(max),
	Changes varchar(max),
	Efficacy varchar(max),
	MedicationConsentGiven varchar(max),
	UnderstoodEducation varchar(max),
	GivenToCareProvide varchar(max),
	NextSession varchar(max)
	)
INSERT into #CustomMedicationReviews
(
	DocumentVersionId,
	Subjective,
	Objective,
	Assessment,
	PlanDetail,
	Aims,
	SideEffects,
	Changes,
	Efficacy,
	MedicationConsentGiven,
	UnderstoodEducation,
	GivenToCareProvide,
	NextSession
	)
SELECT
	a.DocumentVersionId,
	a.Subjective,
	a.Objective,
	a.Assessment,
	a.PlanDetail,
	a.Aims,
	a.SideEffects,
	a.Changes,
	a.Efficacy,
	a.MedicationConsentGiven,
	a.UnderstoodEducation,
	a.GivenToCareProvide,
	a.NextSession
	from CustomMedicationReviews a
	Where DocumentVersionId = @DocumentVersionId

--
--DX Tables
--
Create Table #DiagnosesIandII
(
	DocumentVersionId int,
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
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
RecordDeleted, DeletedDate, DeletedBy )

select
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
 RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier, 
 a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate,
 a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM DiagnosesIAndII a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''


CREATE TABLE #DiagnosesV (
	DocumentVersionId int,
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
DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,
 DeletedDate, DeletedBy
)
select
DocumentVersionId, AxisV, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted,
a.DeletedDate, a.DeletedBy
FROM DiagnosesV a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''

--
-- DECLARE VARIABLES
--
declare @Variables varchar(max)
declare @DocumentType varchar(20)


--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int, @DocumentCodeId int, @ServiceId int
					Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId) + ''
					Set @DocumentCodeId = '' + convert(varchar(20), @DocumentCodeId) + ''
					Set @ServiceId = '' + isnull(convert(varchar(20), @ServiceId),'''')

set @DocumentType = NULL

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables


/*
Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

SELECT ''CustomMedicationReviews'' , ''Subjective'', ''Note - Subjective must be specified.''
From #CustomMedicationReviews
Where ISNULL(Subjective, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''Objective'', ''Note - Objective must be specified.''
From #CustomMedicationReviews
Where ISNULL(Objective, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''Assessment'', ''Note - Assessment must be specified.''
From #CustomMedicationReviews
Where ISNULL(Assessment, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''PlanDetail'', ''Note - Plan must be specified.''
From #CustomMedicationReviews
Where ISNULL(PlanDetail, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''Aims'', ''Note - Aims must be specified.''
From #CustomMedicationReviews
Where ISNULL(Aims, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''SideEffects'', ''Medications/Next Session - Side Effects must be specified.''
From #CustomMedicationReviews
Where ISNULL(SideEffects, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''Changes'', ''Medications/Next Session - Changes must be specified.''
From #CustomMedicationReviews
Where ISNULL(Changes, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''Efficacy'', ''Medications/Next Session - Efficacy must be specified.''
From #CustomMedicationReviews
Where ISNULL(Efficacy, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''MedicationConsentGiven'', ''Medications/Next Session - Medication Consent Given must be specified.''
From #CustomMedicationReviews
Where ISNULL(MedicationConsentGiven, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''UnderstoodEducation'', ''Medications/Next Session - Understood Education must be specified.''
From #CustomMedicationReviews
Where ISNULL(UnderstoodEducation, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''GivenToCareProvide'', ''Medications/Next Session - Given to Care Provider must be specified.''
From #CustomMedicationReviews
Where ISNULL(GivenToCareProvide, '''')= ''''
UNION
SELECT ''CustomMedicationReviews'' , ''NextSession'', ''Medications/Next Session - Next Session must be specified.''
From #CustomMedicationReviews
Where ISNULL(NextSession, '''')= ''''
Union
Select ''CustomMedicationReviews'', ''DeletedBy'', ''Service - Attending physician must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.AttendingId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId
Union
Select ''CustomMedicationReviews'', ''DeletedBy'', ''Service - Location must be specified.''
From services s
join documents d on d.serviceid = s.serviceId
Where s.LocationId is null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
and d.CurrentDocumentVersionId = @DocumentVersionId


--Diagnosis Validation
exec csp_validateDiagnosis @DocumentVersionId	
	
*/

if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomMedicationReviews failed.  Contact your system administrator.''


*/
' 
END
GO
