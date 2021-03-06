/****** Object:  StoredProcedure [dbo].[csp_validateCustomHealthEvaluation]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHealthEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHealthEvaluation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHealthEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomHealthEvaluation]
@DocumentVersionId	Int
as

-- =============================================
-- Author:		Veena S Mani
-- Create date: 08/02/2013
-- Description:	To Validate for Custom Health Evaluation Document.
-- ============================================= 

Create Table #validationReturnTable
(TableName varchar(300),
 ColumnName varchar(200),
 ErrorMessage varchar(800),
 PageIndex int
)


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

Select ''CustomDocumentHealthHomeHealthEvaluations'', ''CurrentMentalHealthDiagnoses'', ''Current Mental Health Diagnoses must be specified''  
	From CustomDocumentHealthHomeHealthEvaluations
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(CurrentMentalHealthDiagnoses,'''')=''''
	
Union  
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''CurrentDDDiagnoses'', ''Current Developmental Disabilities must be specified''  
	From CustomDocumentHealthHomeHealthEvaluations
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(CurrentDDDiagnoses,'''')=''''
	
Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''TobaccoCurrentEveryDay'', ''At least one Tobacco use must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and isnull(TobaccoCurrentEveryDay,''N'')<>''Y'' and isnull(TobaccoCurrentSomeDay,''N'')<>''Y'' and isnull(TobaccoUsesSmokeless,''N'')<>''Y'' and isnull(TobaccoCurrentStatusUnknown,''N'')<>''Y'' and isnull(TobaccoFormerSmoke,''N'')<>''Y'' and isnull(TobaccoNeverSmoker,''N'')<>''Y'' and isnull(TobaccoUnknownEverSmoked,''N'')<>''Y'' and isnull(recordDeleted,''N'')=''N''

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''SubstanceUseEverReferredTreatmentComment'', ''Client ever been referred for substance abuse or tobacco cessation treatment comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  SubstanceUseEverReferredTreatmentComment is null and isnull(SubstanceUseEverReferredTreatment,''N'')=''Y'' and isnull(recordDeleted,''N'')=''N''


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''SubstanceUseCurrentTreatmentComment'', '' Client currently in substance abuse treatment or receiving tobacco cessation treatment Comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  SubstanceUseCurrentTreatmentComment is null and isnull(SubstanceUseCurrentTreatment,''N'')=''Y'' and isnull(recordDeleted,''N'')=''N''


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''CurrentAODFacilityComment'', ''AOD rehabilitation facility or anticipating transitioning in or out of an AOD rehabilitation facility in the next 90 days Comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  CurrentAODFacilityComment is null and isnull(CurrentAODFacility,''N'')=''Y'' and isnull(recordDeleted,''N'')=''N''


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''LabWorkOtherTestsComment'', ''clients lab work, monitoring tests(ex.EKG), and any other ordered testing from the clients PCP,any specialists, and Harbor treatment providers up to date Comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  LabWorkOtherTestsComment is null and isnull(LabWorkOtherTestsUpToDate,'''')=''N'' and isnull(recordDeleted,''N'')=''N''

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''LongTermCareComment'', '' client in long term care or anticipating transitioning to or out of a long term care facility within the next 90 days Comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  LongTermCareComment is null and isnull(LongTermCareCurrent,''N'')=''Y'' and isnull(recordDeleted,''N'')=''N''

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''HospitalCareComment'', ''client been hospitalized (for any reason) in the past 90 days or does the client anticipate being hospitalized (ex.planned surgery) within the next 90 days Comment must be specified''
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and  HospitalCareComment  is null and isnull(HospitalCareCurrent,''N'')=''Y'' and isnull(recordDeleted,''N'')=''N''

--modifications on 19/02/13

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskSuicideIdeation'', ''Risk Suicide Ideation must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskSuicideIdeation is null

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskSuicideIntent'', ''Risk Suicide Intent must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskSuicideIntent is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskSuicidePriorAttempt'', ''Risk Suicide Prior Attempts must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskSuicidePriorAttempt is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskPriorHospitalization'', ''Risk Prior Hospitalization must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskPriorHospitalization is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskPhysicalAggressionSelf'', ''Risk Physical Aggression Self must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskPhysicalAggressionSelf is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskVerbalAggressionOther'', ''Risk Verbal Aggression Others must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskVerbalAggressionOther is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskPhysicalAggressionObject'', ''Risk Physical Aggression Object must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskPhysicalAggressionObject is null 

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskPhysicalAggressionPeople'', ''Risk Physical Aggression People must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskPhysicalAggressionPeople is null 
Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskReportRiskTaking'', ''Risk Report Risk Taking must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskReportRiskTaking is null 


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''RiskThreatClientPersonalSafety'', ''Risk Threat Client Personal Safety must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and RiskThreatClientPersonalSafety is null 





Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''AlcoholUse'', ''Alcohol Use must be specified''  
	From CustomDocumentHealthHomeHealthEvaluations
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(AlcoholUse,'''')=''''
	

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''SubstanceUseOther'', ''Substance Use Other must be specified''  
	From CustomDocumentHealthHomeHealthEvaluations
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(SubstanceUseOther,'''')=''''
	

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''SubstanceUseEverReferredTreatment'', ''Substance Use Ever Referred Treatment must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and SubstanceUseEverReferredTreatment is null
Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''SubstanceUseCurrentTreatment'', ''Substance Use Current Treatment must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and SubstanceUseCurrentTreatment is null


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''CurrentAODFacility'', ''Current AOD Facility must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and CurrentAODFacility is null


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''LabWorkOtherTestsUpToDate'', ''Lab Work Other Tests UpToDate must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and LabWorkOtherTestsUpToDate is null
Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''LongTermCareCurrent'', ''Long Term Care Current must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and LongTermCareCurrent is null


Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''HospitalCareCurrent'', ''Hospital Care Current must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and HospitalCareCurrent is null

Union
Select ''CustomDocumentHealthHomeHealthEvaluations'', ''ClientGuardianParticipatedInPlan'', ''Client Guardian Participated In Plan must be specified''  
       From CustomDocumentHealthHomeHealthEvaluations
       Where DocumentVersionId = @DocumentVersionId and isnull(ClientGuardianParticipatedInPlan,''N'')<>''Y''
--Check to make sure record exists in custom table for @DocumentCodeId

If not exists (Select 1 from CustomDocumentHealthHomeHealthEvaluations Where DocumentVersionId = @DocumentVersionId)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomDocumentHealthHomeHealthEvaluations'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomDocumentHealthHomeHealthEvaluations Where DocumentVersionId = @DocumentVersionId)
end
select * from #validationReturnTable
if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomHealthEvaluation failed.  Contact your system administrator.''
' 
END
GO
