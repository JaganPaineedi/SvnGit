/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomCrisisManagementandContingencyPlan]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomCrisisManagementandContingencyPlan] --209
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetCustomCrisisManagementandContingencyPlan]
@DocumentVersionId INT
AS
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_SCGetCustomCrisisManagementandContingencyPlan]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       28/Feb/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/   

BEGIN

BEGIN TRY
 Declare @VersionDIAG as bigint 
 Declare @ClientId int 
   Declare @EffectiveDate Varchar(25)
   Declare @DocumentIDDIAG as bigint 
 
   SET @ClientId = (
			SELECT ClientId
			FROM documents doc
			INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
			WHERE DocumentVersionId = @DocumentVersionId
				AND ISNULL(docv.RecordDeleted, ''N'') <> ''Y''
			)
			 SELECT  top 1  @VersionDIAG = a.CurrentDocumentVersionId 
FROM    Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = 
DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate
(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull
(Dc.RecordDeleted,''N'')<>''Y''                                                                      
                 
order by a.EffectiveDate desc,a.ModifiedDate desc


SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull(Dc.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 

declare @CurrentMentalHealthDiagnoses varchar(max)
  
set @CurrentMentalHealthDiagnoses =''Effective Date:''+ @EffectiveDate  

SELECT     DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, ClinicianFacilitatingDischarge, 
                      @CurrentMentalHealthDiagnoses as CurrentMentalHealthDiagnoses, CurrentDDDiagnoses, CurrentMedication, PrimaryCarePhysician, PrimaryCarePhysicianPhone, 
                      PharmacyName, PharmacyPhone, FirstSupportContactName, FirstSupportContactPhone, SecondarySupportContactName, SecondarySupportContactPhone, 
                      DescriptionImmediateNeed, CurrentTreatment, PersonalSafetyConcern, SituationsTriggerCrisis, InterventionsPreferred, SituationsAppropriateToEmergencyDepartment,
                       SpecialSituationsPlan, SpecialSituationsPlanNA, CareManagerName, CareManagerPhone, QualifiedHealthHomeSpecialistName, 
                      QualifiedHealthHomeSpecialistPhone, AfterHoursProfessionalContactName, AfterHoursProfessionalContactPhone, ClientGuardianParticipatedInPlan,SituationsAppropriateToEmergencyDepartmentNA
FROM         CustomDocumentHealthHomeCrisisPlans
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 
 
 SELECT  CustomDocumentHealthHomeCarePlanDiagnosisId,CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate,DocumentVersionId,
        SequenceNumber, ReportedDiagnosis, DiagnosisSource, TreatmentProvider                     
        FROM              CustomDocumentHealthHomeCarePlanDiagnoses
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)        

SELECT     HomeCrisisPlanTypeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DocumentVersionId, SequenceNumber, 
                      CrisisTypeName, CrisisTypePlan
FROM         CustomDocumentHealthHomeCrisisPlanTypes
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 

SELECT     HealthHomeMentalHealthCrisisPlanStepId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DocumentVersionId, StepNumber, 
                      StepDescription
FROM         CustomDocumentHealthHomeMentalHealthCrisisPlanSteps 
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 

SELECT     HealthHomeCommPlanFamilyMemberId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DocumentVersionId, 
                      FamilyMemberName, FamilyMemberPhone
FROM         CustomDocumentHealthHomeCommPlanFamilyMembers
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 


 select ''CurrentDiagnoses'' as TableName
 ,(CAST(ROW_NUMBER() over (order by ICD10.ICDDescription) as int) * -1) as CurrentDiagnosesId
 ,CodeName , a.ICD9Code,a.ICD10Code
 ,case ISNULL(ICD10.DSMVCode,'''') when ''Y'' then ''Yes'' else ''No'' end as DSMVCode
 
 ,ICD10.ICDDescription 
 ,a.CreatedBy,
		a.CreatedDate,
		a.ModifiedBy,
		a.ModifiedDate,
		a.RecordDeleted,
		a.DeletedBy,
		a.DeletedDate      
from DocumentDiagnosisCodes a                              
 INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.ICD10CodeId          
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes 
 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                      
     
 and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder   
END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomCrisisManagementandContingencyPlan'')
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END' 
END
GO
