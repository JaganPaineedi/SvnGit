IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMedicationReviewNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentMedicationReviewNotes]
GO

CREATE procedure [dbo].[csp_ValidateCustomDocumentMedicationReviewNotes]
	@DocumentVersionId int

as




CREATE TABLE #CustomDocumentMedicationReviewNotes
(
 --***TABLE CREATE***--
 DocumentVersionId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,CurrentMedications varchar(max)
,PreviousTreatmentRecommendationsAndOrders varchar(max)
,PreviousChangesSinceLastVisit varchar(max)
,ChangesSinceLastVisit varchar(max)
,MedEducationSideEffectsDiscussed char(1)
,MedEducationAlternativesReviewed char(1)
,MedEducationAgreedRegimen char(1)
,MedEducationAwareOfSubstanceUseRisks char(1)
,MedEducationAwareOfEmergencySymptoms char(1)
,TreatmentRecommendationsAndOrders varchar(max)
,MedicationsPrescribed varchar(max)
,OtherInstructions varchar(max)
)


--***INSERT LIST***--
insert into #CustomDocumentMedicationReviewNotes (
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,CurrentMedications
,PreviousTreatmentRecommendationsAndOrders
,PreviousChangesSinceLastVisit
,ChangesSinceLastVisit
,MedEducationSideEffectsDiscussed
,MedEducationAlternativesReviewed
,MedEducationAgreedRegimen
,MedEducationAwareOfSubstanceUseRisks
,MedEducationAwareOfEmergencySymptoms
,TreatmentRecommendationsAndOrders
,MedicationsPrescribed
,OtherInstructions
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
,CurrentMedications
,PreviousTreatmentRecommendationsAndOrders
,PreviousChangesSinceLastVisit
,ChangesSinceLastVisit
,MedEducationSideEffectsDiscussed
,MedEducationAlternativesReviewed
,MedEducationAgreedRegimen
,MedEducationAwareOfSubstanceUseRisks
,MedEducationAwareOfEmergencySymptoms
,TreatmentRecommendationsAndOrders
,MedicationsPrescribed
,OtherInstructions
from CustomDocumentMedicationReviewNotes
where DocumentVersionId = @DocumentVersionId

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
and isnull(RecordDeleted,'N') = 'N'

declare @PharmManagementAuthCode int = 13
declare @MostRecentTxPlanVersionId int

declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int

select @Sex = isnull(c.Sex,'U'), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId, 
	@DocumentCodeId = d.DocumentCodeId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

select @MostRecentTxPlanVersionId = d.CurrentDocumentVersionId
from dbo.Documents as d
where d.ClientId = @ClientId
and d.Status = 22
and d.DocumentCodeId in (1483, 1484, 1485)
and ISNULL(d.RecordDeleted, 'N') <> 'Y'
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.Status = 22
	and d2.DocumentCodeId in (1483, 1484, 1485)
	and ((d2.EffectiveDate > d.EffectiveDate)
			or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
	and ISNULL(d2.RecordDeleted, 'N') <> 'Y'
)


insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)

SELECT 'DocumentDiagnosisCodes','DiagnosisType','Only one primary type should be available',0,1 From #DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and((Select Count(*) AS RecordCount from #DocumentDiagnosisCodes WHERE DocumentVersionId = @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,'N') = 'N') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)
UNION
SELECT 'DocumentDiagnosisCodes','DiagnosisType','Primary Diagnosis must have a billing order of 1',0,1 From #DocumentDiagnosisCodes where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)
UNION
SELECT 'CustomDocumentMedicationReviewNotes', 'DeletedBy', 'General  - Changes Since Last Visit section is required',1 ,1
FROM #CustomDocumentMedicationReviewNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(ChangesSinceLastVisit, '')))) = 0


UNION
SELECT 'CustomDocumentMedicationReviewNotes', 'DeletedBy', 'Medications  - Medication Education section is required',4 ,1
FROM #CustomDocumentMedicationReviewNotes
WHERE ISNULL(MedEducationSideEffectsDiscussed, 'N')='N'
and ISNULL(MedEducationAlternativesReviewed, 'N')='N'
and ISNULL(MedEducationAgreedRegimen, 'N')='N'
and ISNULL(MedEducationAwareOfSubstanceUseRisks, 'N')='N'
and ISNULL(MedEducationAwareOfEmergencySymptoms, 'N')='N'

UNION
SELECT 'CustomDocumentMedicationReviewNotes', 'DeletedBy', 'Medications  - Treatment Recommendations and Orders section is required',4 ,1
FROM #CustomDocumentMedicationReviewNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(TreatmentRecommendationsAndOrders, '')))) = 0

UNION
SELECT 'CustomDocumentMedicationReviewNotes', 'DeletedBy', 'Medications  - Medications Prescribed section is required',4 ,1
FROM #CustomDocumentMedicationReviewNotes
WHERE LEN(LTRIM(RTRIM(ISNULL(MedicationsPrescribed, '')))) = 0


exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId , 2




