/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomComprehensiveHealthEvaluation]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomComprehensiveHealthEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomComprehensiveHealthEvaluation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomComprehensiveHealthEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetCustomComprehensiveHealthEvaluation]
@DocumentVersionId INT
AS
/*********************************************************************/                                                                
 /* Stored Procedure: [csp_SCGetCustomComprehensiveHealthEvaluation]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       06/Feb/2013       Bernardin               To Retrieve Data           */  
  /*      14/Feb/2013       Veena                   Other Substance use format change           */      
    
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

SELECT                CDHHHE.DocumentVersionId, CDHHHE.CreatedBy, CDHHHE.CreatedDate, CDHHHE.ModifiedBy, CDHHHE.ModifiedDate, CDHHHE.RecordDeleted, CDHHHE.DeletedBy, CDHHHE.DeletedDate,
                      @CurrentMentalHealthDiagnoses as CurrentMentalHealthDiagnoses, CDHHHE.CurrentDDDiagnoses, 
                      CDHHHE.RiskReportedByClient, CDHHHE.RiskSuicideIdeation, 
                      CDHHHE.RiskSuicideIdeationComment, CDHHHE.RiskSuicideIntent, 
                      CDHHHE.RiskSuicideIntentComment, CDHHHE.RiskSuicidePriorAttempt, 
                      CDHHHE.RiskSuicidePriorAttemptsComment, CDHHHE.RiskPriorHospitalization, 
                      CDHHHE.RiskPriorHospitalizationComment, CDHHHE.RiskPhysicalAggressionSelf, 
                      CDHHHE.RiskPhysicalAggressionSelfComment, CDHHHE.RiskVerbalAggressionOther, 
                      CDHHHE.RiskVerbalAggressionOthersComment, 
                      CDHHHE.RiskPhysicalAggressionObject, 
                      CDHHHE.RiskPhysicalAggressionObjectsComment, 
                      CDHHHE.RiskPhysicalAggressionPeople, 
                      CDHHHE.RiskPhysicalAggressionPeopleComment, CDHHHE.RiskReportRiskTaking, 
                      CDHHHE.RiskReportRiskTakingComment, CDHHHE.RiskThreatClientPersonalSafety, 
                      CDHHHE.RiskThreatClientPersonalSafetyComment, CDHHHE.AlcoholUse, 
                      CDHHHE.TobaccoCurrentEveryDay, CDHHHE.TobaccoCurrentSomeDay, 
                      CDHHHE.TobaccoUsesSmokeless, CDHHHE.TobaccoCurrentStatusUnknown, 
                      CDHHHE.TobaccoFormerSmoke, CDHHHE.TobaccoNeverSmoker, 
                      CDHHHE.TobaccoUnknownEverSmoked, CDHHHE.SubstanceUseOther, 
                      CDHHHE.SubstanceUseEverReferredTreatment, 
                      CDHHHE.SubstanceUseEverReferredTreatmentComment, 
                      CDHHHE.SubstanceUseCurrentTreatment, 
                      CDHHHE.SubstanceUseCurrentTreatmentComment, CDHHHE.CurrentAODFacility, 
                      CDHHHE.CurrentAODFacilityComment, CDHHHE.ClientReportsHighCholesterol, 
                      CDHHHE.ClientReportsDiabetes, CDHHHE.ClientReportsHypertension, 
                      CDHHHE.ClientReportsAsthmaCOPDChronicInfection, 
                      CDHHHE.ClientReportsChronicPain, CDHHHE.ClientReportsCardiovascularDisease, 
                      CDHHHE.ClientHeight, CDHHHE.ClientWeight, 
                      CDHHHE.ClientBMI, CDHHHE.MostRecentMetabolicScreeningDate, 
                      CDHHHE.ClientWaistCircumference, CDHHHE.ClientTriglycerideLevel, 
                      CDHHHE.ClientHDL, CDHHHE.ClientBloodPressure, 
                      CDHHHE.AnyOtherHealthCondition, CDHHHE.LabWorkOtherTestsUpToDate, 
                      CDHHHE.LabWorkOtherTestsComment, CDHHHE.LongTermCareCurrent, 
                      CDHHHE.LongTermCareComment, CDHHHE.HospitalCareCurrent, 
                      CDHHHE.HospitalCareComment, CDHHHE.SocialServiceNeedHousing, 
                      CDHHHE.SocialServiceNeedEmployment, 
                      CDHHHE.SocialServiceNeedAccessHealthcare, 
                      CDHHHE.SocialServiceNeedEducationalProblem, 
                      CDHHHE.SocialServiceNeedLegalAid, CDHHHE.SocialServiceNeedFoodClothing, 
                      CDHHHE.SocialServiceNeedAssistBenefitsApplication, 
                      CDHHHE.SocialServiceNeedCriminalJustice, CDHHHE.SocialServiceNeedOther, 
                      CDHHHE.SocialServiceNeedOtherComment, CDHHHE.ClientGuardianParticipatedInPlan 

FROM         CustomDocumentHealthHomeHealthEvaluations AS CDHHHE
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 
         
SELECT  CDHHCPD.CustomDocumentHealthHomeCarePlanDiagnosisId,CDHHCPD.CreatedBy, CDHHCPD.CreatedDate, CDHHCPD.ModifiedBy, CDHHCPD.ModifiedDate, CDHHCPD.RecordDeleted, CDHHCPD.DeletedBy, CDHHCPD.DeletedDate,CDHHCPD.DocumentVersionId,
        CDHHCPD.SequenceNumber, CDHHCPD.ReportedDiagnosis, CDHHCPD.DiagnosisSource, CDHHCPD.TreatmentProvider                     
        FROM              CustomDocumentHealthHomeCarePlanDiagnoses AS CDHHCPD
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 

SELECT     CustomDocumentHealthHomeCarePlanPESNeedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate,DocumentVersionId,
                      PsychosocialSupportNeedSequence, PsychosocialSupportNeedType, PsychosocialSupportNeedPlan,dbo.csf_GetGlobalCodeNameById(PsychosocialSupportNeedType) AS SupportNeed
FROM         CustomDocumentHealthHomeCarePlanPESNeeds
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
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes 
 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                      
     
 and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder   

END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomComprehensiveHealthEvaluation'')
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END
' 
END
GO
