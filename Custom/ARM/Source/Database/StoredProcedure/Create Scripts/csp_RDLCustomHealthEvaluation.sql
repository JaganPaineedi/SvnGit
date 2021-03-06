/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHealthEvaluation]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHealthEvaluation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHealthEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCustomHealthEvaluation]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Veena S Mani
-- Create date: 08/02/2013
-- Description:	To get data for Custom Health Evaluation RDL.
-- ============================================= 
Declare @VersionDIAG as bigint
Declare @DocumentIDDIAG as bigint
Declare @MentalHealthDiagnoses varchar(max)
Declare @EffectiveDate Varchar(25)
declare @ClientId Int

	SET @ClientId = (
				SELECT ClientId
				FROM documents doc
				INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
				WHERE DocumentVersionId = @DocumentVersionId
					AND ISNULL(docv.RecordDeleted, ''N'') <> ''Y''
				)

SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull(Dc.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 


SET    @MentalHealthDiagnoses = '''';
set @MentalHealthDiagnoses=''Effective Date:''+ @EffectiveDate

+ CHAR(13) +''Type''+ char(9) + ''ICD 9''  + char(9) + ''ICD 10'' + char(9)+ ''DSM5'' + char(9) + ''Description'' + CHAR(13)        

select @MentalHealthDiagnoses = @MentalHealthDiagnoses + ISNULL(cast(b.CodeName AS varchar),char(9)) + char(9)+ ISNULL(cast(a.ICD9Code as varchar),char(9)) +char(9) + ISNULL(cast(a.ICD10Code as varchar),char(9))+ char(9)+ case ISNULL(cast(ICD10.DSMVCode AS varchar),char(9)) when ''Y'' then ''Yes'' else ''No'' end + char(9) + ISNULL(cast(ICD10.ICDDescription as varchar),'''') + char(13)         
from DocumentDiagnosisCodes a                              
 INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                           
 and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder 


SELECT  CDHHCP.DocumentVersionId,  
		CDHHCP.CreatedBy,  
		CDHHCP.CreatedDate,  
		CDHHCP.ModifiedBy,  
		CDHHCP.ModifiedDate,  
		CDHHCP.RecordDeleted,  
		CDHHCP.DeletedBy,  
		CDHHCP.DeletedDate,  
		@MentalHealthDiagnoses as CurrentMentalHealthDiagnoses,  
		CurrentDDDiagnoses,  
		RiskReportedByClient,  
		RiskSuicideIdeation,  
		RiskSuicideIdeationComment,  
		RiskSuicideIntent,  
		RiskSuicideIntentComment,  
		RiskSuicidePriorAttempt,  
		RiskSuicidePriorAttemptsComment,  
		RiskPriorHospitalization,  
		RiskPriorHospitalizationComment,  
		RiskPhysicalAggressionSelf,  
		RiskPhysicalAggressionSelfComment,  
		RiskVerbalAggressionOther,  
		RiskVerbalAggressionOthersComment,  
		RiskPhysicalAggressionObject,  
		RiskPhysicalAggressionObjectsComment,  
		RiskPhysicalAggressionPeople,  
		RiskPhysicalAggressionPeopleComment,  
		RiskReportRiskTaking,  
		RiskReportRiskTakingComment,  
		RiskThreatClientPersonalSafety,  
		RiskThreatClientPersonalSafetyComment,  
		AlcoholUse,  
		TobaccoCurrentEveryDay,  
		TobaccoCurrentSomeDay,  
		TobaccoUsesSmokeless,  
		TobaccoCurrentStatusUnknown,  
		TobaccoFormerSmoke,  
		TobaccoNeverSmoker,  
		TobaccoUnknownEverSmoked,  
		SubstanceUseOther,  
		SubstanceUseEverReferredTreatment,  
		SubstanceUseEverReferredTreatmentComment,  
		SubstanceUseCurrentTreatment,  
		SubstanceUseCurrentTreatmentComment,  
		CurrentAODFacility,  
		CurrentAODFacilityComment,  
		ClientReportsHighCholesterol,  
		ClientReportsDiabetes,  
		ClientReportsHypertension,  
		ClientReportsAsthmaCOPDChronicInfection,  
		ClientReportsChronicPain,  
		ClientReportsCardiovascularDisease,  
		ClientHeight,  
		ClientWeight,  
		ClientBMI,  
		CONVERT(VARCHAR(10), MostRecentMetabolicScreeningDate, 101) as MostRecentMetabolicScreeningDate,  
		ClientWaistCircumference,  
		ClientTriglycerideLevel,  
		ClientHDL,  
		ClientBloodPressure,  
		AnyOtherHealthCondition,  
		LabWorkOtherTestsUpToDate,  
		LabWorkOtherTestsComment,  
		LongTermCareCurrent,  
		LongTermCareComment,  
		HospitalCareCurrent,  
		HospitalCareComment,  
		SocialServiceNeedHousing,  
		SocialServiceNeedEmployment,  
		SocialServiceNeedAccessHealthcare,  
		SocialServiceNeedEducationalProblem,  
		SocialServiceNeedLegalAid,  
		SocialServiceNeedFoodClothing,  
		SocialServiceNeedAssistBenefitsApplication,  
		SocialServiceNeedCriminalJustice,  
		SocialServiceNeedOther,  
		SocialServiceNeedOtherComment,  
		ClientGuardianParticipatedInPlan,  
		Clients.FirstName + '' '' + Clients.LastName AS ClientName,  
		Clients.ClientId  
FROM       CustomDocumentHealthHomeHealthEvaluations AS CDHHCP 
				INNER JOIN  
                      DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId  AND (CDHHCP.DocumentVersionId = @DocumentVersionId) 
                INNER JOIN  
                      Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId 
                      --AND   
                      --DV.DocumentVersionId = Documents.InProgressDocumentVersionId 
                      INNER JOIN  
                      Clients ON Documents.ClientId = Clients.ClientId  
WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') --AND (CDHHCP.DocumentVersionId = @DocumentVersionId)  
               
--Checking For Errors                            
If (@@error!=0)                                                        
 Begin                                                        
  RAISERROR  20006   ''[csp_RDLCustomHealthEvaluation] : An Error Occured''                                                         
  Return                                                        
 End                                                                 
End
' 
END
GO
