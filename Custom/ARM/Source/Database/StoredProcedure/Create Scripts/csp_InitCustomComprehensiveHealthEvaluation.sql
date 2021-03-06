/****** Object:  StoredProcedure [dbo].[csp_InitCustomComprehensiveHealthEvaluation]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomComprehensiveHealthEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomComprehensiveHealthEvaluation] --2,550,N''
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomComprehensiveHealthEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_InitCustomComprehensiveHealthEvaluation]        
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitComprehensiveHealthEvaluation]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       06/Feb/2013       Bernardin               To Retrieve Data           */  
  /*      14/Feb/2013       Veena                   Other Substance use format change           */      
    
 /*********************************************************************/        
Declare @MostRecentCarePlanVersionId int
Declare @MostRecentDiagnosisVersionId int
Declare @MostRecentDiagnosisAssessmentVersionId int
Declare @DIAGNOSISDIAGNOSED int
Declare @MentalHealthDiagnoses varchar(max)
Declare @CurrentDDDiagnoses varchar(max)
Declare @AlcoholUse varchar(max)
Declare @OtherSubstanceUse varchar(max)
Declare @Height varchar(50)
Declare @Weight varchar(50)
Declare @BMI varchar(50)
Declare @BloodPressure varchar(200)
Declare @RiskSuicideIdeation  char(1) 
Declare @RiskSuicideIdeationComment varchar(max)
Declare @RiskSuicideIntent char(1)
Declare @RiskSuicideIntentComment varchar(max)
Declare @RiskSuicidePriorAttempts char(1) 
Declare @RiskSuicidePriorAttemptsComment varchar(max)
Declare @RiskPriorHospitalization char(1) 
Declare @RiskPriorHospitalizationComment varchar(max)
Declare @RiskPhysicalAggressionSelf char(1) 
Declare @RiskPhysicalAggressionSelfComment varchar(max)
Declare @RiskVerbalAggressionOthers char(1) 
Declare @RiskVerbalAggressionOthersComment varchar(max)
Declare @RiskPhysicalAggressionObjects char(1)
Declare @RiskPhysicalAggressionObjectsComment varchar(max)
Declare @RiskPhysicalAggressionPeople char(1) 
Declare @RiskPhysicalAggressionPeopleComment varchar(max)
Declare @RiskReportRiskTaking char(1) 
Declare @RiskReportRiskTakingComment varchar(max)
Declare @RiskThreatClientPersonalSafety char(1)
Declare @RiskThreatClientPersonalSafetyComment varchar(max)
Declare @EffectiveDate Varchar(25)
Declare @VersionDIAG as bigint
Declare @DocumentIDDIAG as bigint                                                                             
Begin                                              
    
Begin try

select  @DIAGNOSISDIAGNOSED = GlobalCodeId from  dbo.GlobalCodes
where   Category = ''XDIAGNOSISSOURCE'' and CodeName = ''Diagnosed'' and ISNULL(RecordDeleted, ''N'') <> ''Y''
-- Get most recent Diagnosis document version id
select top 1 @MostRecentDiagnosisVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 5 and d.Status = 22 and ISNULL(d.RecordDeleted, ''N'') <> ''Y'' order by d.EffectiveDate desc,d.DocumentId desc
-- Get most recent Diagnoses Assessment document version id
select top 1 @MostRecentDiagnosisAssessmentVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 1486 and d.Status = 22 and ISNULL(d.RecordDeleted, ''N'') <> ''Y'' order by d.EffectiveDate desc,d.DocumentId desc
-- Get CurrentMentalHealthDiagnoses values

SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull(Dc.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 
SET    @MentalHealthDiagnoses = '''';


set @MentalHealthDiagnoses=''Effective Date:''+ @EffectiveDate

--+ CHAR(13) +''Type''+ char(9) + ''ICD 9''  + char(9) + ''ICD 10'' + char(9)+ ''DSM5'' + char(9) + ''Description'' + CHAR(13)        

--select @MentalHealthDiagnoses = @MentalHealthDiagnoses + ISNULL(cast(b.CodeName AS varchar),char(9)) + char(9)+ ISNULL(cast(a.ICD9Code as varchar),char(9)) +char(9) + ISNULL(cast(a.ICD10Code as varchar),char(9))+ char(9)+ case ISNULL(cast(ICD10.DSMVCode AS varchar),char(9)) when ''Y'' then ''Yes'' else ''No'' end + char(9) + ISNULL(cast(ICD10.ICDDescription as varchar),'''') + char(13)         
--from DocumentDiagnosisCodes a                              
-- INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
-- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
--where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                           
-- and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder 
 
-- Get CurrentDDDiagnoses values
Set @CurrentDDDiagnoses = '''';
select @CurrentDDDiagnoses = @CurrentDDDiagnoses + CAST(dx.DSMCode AS VARCHAR(12)) + case when CAST(dx.Axis AS VARCHAR(12)) =''1'' then '' - Axis I - '' else '' - Axis II - '' end + dsm.DSMDescription + '' - Diagnosed'' + + CHAR(13) 
from DiagnosesIandII as dx join diagnosisdsmDescriptions as dsm on dsm.DSMCode = dx.DsmCode and dsm.DSMNumber = dx.DSMNumber
where DocumentVersionId = @MostRecentDiagnosisVersionId and (dx.DSMCode like ''317%'' or dx.DSMCode  like ''318%'' or dx.DSMCode  like ''319%'')

Select @AlcoholUse = case when ISNULL(AlcoholUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(AlcoholUseCurrentFrequency)+''.'' else '''' end +case when AlcoholUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(AlcoholUsePastFrequency)+''.'' else '' '' end + CHAR(10) +case when AlcoholUseReceivedTreatment =''Y'' then ''Client has received treatment for use of this substance.''else '''' end 
from CustomDocumentDiagnosticAssessments Where DocumentversionId = @MostRecentDiagnosisAssessmentVersionId

SET @OtherSubstanceUse = '''';
Select @OtherSubstanceUse = case when (ISNULL(CocaineUseWithin30Days, ''N'') =''Y'' or ISNULL(CocaineUseWithin30Days, ''N'') =''Y'' or CocaineUseWithinLifetime =''Y'') then ''Cocaine / Crack - '' else '''' end + case when ISNULL(CocaineUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(CocaineUseCurrentFrequency)+''.'' else '''' end +case when CocaineUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(CocaineUsePastFrequency)+''.'' else '''' end +case when CocaineUseReceivedTreatment =''Y'' then( CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end + 
			   case when (ISNULL(SedtativeUseWithin30Days, ''N'') =''Y'' or ISNULL(SedtativeUseWithinLifetime, ''N'') =''Y'' or SedtativeUseReceivedTreatment =''Y'') then(CHAR(13)+''Sedatives /Hypnotics - '' )else '''' end + case when ISNULL(SedtativeUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(SedtativeUseCurrentFrequency)+''.'' else '''' end +case when SedtativeUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(SedtativeUsePastFrequency)+''.'' else '''' end +case when SedtativeUseReceivedTreatment =''Y'' then( CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end +
			   case when (ISNULL(HallucinogenUseWithin30Days, ''N'') =''Y'' or ISNULL(HallucinogenUseWithinLifetime, ''N'') =''Y'' or HallucinogenUseReceivedTreatment =''Y'') then(CHAR(13) + ''Hallucinogens - '' )else '''' end  + case when ISNULL(HallucinogenUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(HallucinogenUseCurrentFrequency)+''.'' else '''' end +case when HallucinogenUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(HallucinogenUsePastFrequency)+''.'' else '''' end +case when HallucinogenUseReceivedTreatment =''Y'' then ( CHAR(10) +''Client has received treatment for use of this substance.'')else '''' end +
			   case when (ISNULL(StimulantUseWithin30Days, ''N'') =''Y'' or ISNULL(StimulantUseWithinLifetime, ''N'') =''Y'' or StimulantUseReceivedTreatment =''Y'') then (CHAR(13) + ''Stimulants - '') else '''' end  + case when ISNULL(StimulantUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(StimulantUseCurrentFrequency)+''.'' else '''' end +case when StimulantUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(StimulantUsePastFrequency)+''.'' else '''' end + case when StimulantUseReceivedTreatment =''Y'' then(CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end +
			   case when (ISNULL(NarcoticUseWithin30Days, ''N'') =''Y'' or ISNULL(NarcoticUseWithinLifetime, ''N'') =''Y'' or NarcoticUseReceivedTreatment =''Y'') then (CHAR(13) + ''Narcotics - '') else '''' end + case when ISNULL(NarcoticUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(NarcoticUseCurrentFrequency) +''.''else '''' end +case when NarcoticUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(NarcoticUsePastFrequency)+''.'' else '''' end +case when NarcoticUseReceivedTreatment =''Y'' then ( CHAR(10) +''Client has received treatment for use of this substance.'')else '''' end  +
			   case when (ISNULL(MarijuanaUseWithin30Days, ''N'') =''Y'' or ISNULL(MarijuanaUseWithinLifetime, ''N'') =''Y'' or MarijuanaUseReceivedTreatment =''Y'') then(CHAR(13) + ''Marijuana - '' )else '''' end + case when ISNULL(MarijuanaUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(MarijuanaUseCurrentFrequency)+''.'' else '''' end +case when MarijuanaUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(MarijuanaUsePastFrequency)+''.'' else '''' end +case when MarijuanaUseReceivedTreatment =''Y'' then( CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end + 
			   case when (ISNULL(InhalantsUseWithin30Days, ''N'') =''Y'' or ISNULL(InhalantsUseWithinLifetime, ''N'') =''Y'' or InhalantsUseReceivedTreatment =''Y'') then( CHAR(13) + ''Inhalants - '' )else '''' end + case when ISNULL(InhalantsUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(InhalantsUseCurrentFrequency)+''.'' else '''' end +case when InhalantsUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(InhalantsUsePastFrequency)+''.'' else '''' end +case when InhalantsUseReceivedTreatment =''Y'' then( CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end   + 
			   case when (ISNULL(OtherUseWithin30Days, ''N'') =''Y'' or ISNULL(OtherUseWithinLifetime, ''N'') =''Y'' or OtherUseReceivedTreatment =''Y'') then( CHAR(13) + ''Others - '') else '''' end +case when ISNULL(OtherUseWithin30Days, ''N'') =''Y'' then ''Current frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(OtherUseCurrentFrequency)+''.'' else '''' end +case when OtherUseWithinLifetime =''Y'' then ''Past frequency of use: ''+  dbo.csf_GetGlobalCodeNameById(OtherUsePastFrequency)+''.'' else '''' end +case when OtherUseReceivedTreatment =''Y'' then( CHAR(10) + ''Client has received treatment for use of this substance.'')else '''' end     
from CustomDocumentDiagnosticAssessments Where DocumentversionId = @MostRecentDiagnosisAssessmentVersionId

-- Get Height Weight BMI
SELECT @Height = convert(decimal(18,2), hd.ItemValue1),@Weight = convert(decimal(18,2), hd.ItemValue2),@BMI = convert(decimal(18,4), hd.ItemValue3)
FROM         HealthData AS hd INNER JOIN HealthDataCategories AS HDC ON hd.HealthDataCategoryId = HDC.HealthDataCategoryId 
                      WHERE hd.ClientId = @ClientID and HDC.CategoryName = ''Height Weight BMI''
-- Get Blood Pressure values
SELECT @BloodPressure = convert(varchar(50), convert(decimal(18,0), hd.ItemValue1))+''/''+ convert(varchar(50), convert(decimal(18,0), hd.ItemValue2)) 
FROM         HealthData AS hd INNER JOIN
                      HealthDataCategories AS HDC ON hd.HealthDataCategoryId = HDC.HealthDataCategoryId 
                      WHERE hd.ClientId = @ClientID and HDC.CategoryName = ''Blood Pressure''
                      
-- Get the value from CustomDocumentDiagnosticAssessments table               
SELECT    @RiskSuicideIdeation = RiskSuicideIdeation,@RiskSuicideIdeationComment = RiskSuicideIdeationComment, @RiskSuicideIntent = RiskSuicideIntent, @RiskSuicideIntentComment = RiskSuicideIntentComment, @RiskSuicidePriorAttempts = RiskSuicidePriorAttempts, @RiskSuicidePriorAttemptsComment = RiskSuicidePriorAttemptsComment, @RiskPriorHospitalization = RiskPriorHospitalization, 
           @RiskPriorHospitalizationComment = RiskPriorHospitalizationComment, @RiskPhysicalAggressionSelf = RiskPhysicalAggressionSelf, @RiskPhysicalAggressionSelfComment= RiskPhysicalAggressionSelfComment, @RiskVerbalAggressionOthers = RiskVerbalAggressionOthers, @RiskVerbalAggressionOthersComment = RiskVerbalAggressionOthersComment, @RiskPhysicalAggressionObjects = RiskPhysicalAggressionObjects, 
           @RiskPhysicalAggressionObjectsComment = RiskPhysicalAggressionObjectsComment, @RiskPhysicalAggressionPeople = RiskPhysicalAggressionPeople, @RiskPhysicalAggressionPeopleComment = RiskPhysicalAggressionPeopleComment, @RiskReportRiskTaking = RiskReportRiskTaking, @RiskReportRiskTakingComment = RiskReportRiskTakingComment, @RiskThreatClientPersonalSafety = RiskThreatClientPersonalSafety, 
           @RiskThreatClientPersonalSafetyComment = RiskThreatClientPersonalSafetyComment
FROM CustomDocumentDiagnosticAssessments WHERE DocumentversionId = @MostRecentDiagnosisAssessmentVersionId 
                                            
-- CustomDocumentHealthHomeHealthEvaluations                      
Select TOP 1 ''CustomDocumentHealthHomeHealthEvaluations'' AS TableName, -1 as ''DocumentVersionId'', 
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate, 
@MentalHealthDiagnoses as CurrentMentalHealthDiagnoses,
@CurrentDDDiagnoses as CurrentDDDiagnoses,
@AlcoholUse as AlcoholUse,
@OtherSubstanceUse as SubstanceUseOther,
@Height as ClientHeight,
@Weight as ClientWeight,
@BMI as ClientBMI,
@BloodPressure as ClientBloodPressure,
@RiskSuicideIdeation as RiskSuicideIdeation, 
@RiskSuicideIdeationComment as RiskSuicideIdeationComment, 
@RiskSuicideIntent as RiskSuicideIntent, 
@RiskSuicideIntentComment as RiskSuicideIntentComment, 
@RiskSuicidePriorAttempts as RiskSuicidePriorAttempt, 
@RiskSuicidePriorAttemptsComment as RiskSuicidePriorAttemptsComment, 
@RiskPriorHospitalization as RiskPriorHospitalization, 
@RiskPriorHospitalizationComment as RiskPriorHospitalizationComment, 
@RiskPhysicalAggressionSelf as RiskPhysicalAggressionSelf, 
@RiskPhysicalAggressionSelfComment as RiskPhysicalAggressionSelfComment, 
@RiskVerbalAggressionOthers as RiskVerbalAggressionOther, 
@RiskVerbalAggressionOthersComment as RiskVerbalAggressionOthersComment, 
@RiskPhysicalAggressionObjects as RiskPhysicalAggressionObject, 
@RiskPhysicalAggressionObjectsComment as RiskPhysicalAggressionObjectsComment, 
@RiskPhysicalAggressionPeople as RiskPhysicalAggressionPeople, 
@RiskPhysicalAggressionPeopleComment as RiskPhysicalAggressionPeopleComment, 
@RiskReportRiskTaking as RiskReportRiskTaking, 
@RiskReportRiskTakingComment as RiskReportRiskTakingComment, 
@RiskThreatClientPersonalSafety as RiskThreatClientPersonalSafety, 
@RiskThreatClientPersonalSafetyComment as RiskThreatClientPersonalSafetyComment
from systemconfigurations s left outer join CustomDocumentHealthHomeHealthEvaluations CDHHHE                                                                     
on s.Databaseversion = -1


-- CustomDocumentHealthHomeCarePlanDiagnoses
select  PlaceHolder.TableName,
		(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int) * -1) as CustomDocumentHealthHomeCarePlanDiagnosisId,
		dx3.CreatedBy,
		dx3.CreatedDate,
		dx3.ModifiedBy,
		dx3.ModifiedDate,
		dx3.RecordDeleted,
		dx3.DeletedBy,
		dx3.DeletedDate,
		CAST(-1 as int) as DocumentVersionId,
		(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int)) as SequenceNumber,
		LEFT(icd.ICDDescription, 200) as ReportedDiagnosis,
		@DIAGNOSISDIAGNOSED as DiagnosisSource,
		''Harbor'' as TreatmentProvider
from    (
		 select ''CustomDocumentHealthHomeCarePlanDiagnoses'' as TableName,
				@MostRecentCarePlanVersionId as DocumentVersionId
		) as PlaceHolder 
cross join dbo.DiagnosesIIICodes as dx3
join    dbo.DiagnosisICDCodes as icd on icd.ICDCode = dx3.ICDCode
where   dx3.DocumentVersionId = @MostRecentDiagnosisVersionId
		and ISNULL(dx3.RecordDeleted, ''N'') <> ''Y''


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
                        
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomComprehensiveHealthEvaluation'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END
' 
END
GO
