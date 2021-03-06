/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomScreenForServices]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomScreenForServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomScreenForServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomScreenForServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE         PROCEDURE [dbo].[csp_RequiredCustomScreenForServices]    
  @documentCodeId Int    
as    
    
     
--This required returns two fields      
--Field1 = TableName      
--Field2 = ColumnName      
    
      
Insert into #RequiredFieldReturnTable      
(    
TableName,      
ColumnName     
)        
  
    
  
    
SELECT ''CustomScreenForServices'' , ''DateOfScreen''  
UNION    
SELECT ''CustomScreenForServices'' , ''EventStartTime''  
UNION    
SELECT ''CustomScreenForServices'' , ''DispositionTime''  
UNION    
SELECT ''CustomScreenForServices'' , ''EventStopTime''  
UNION    
SELECT ''CustomScreenForServices'' , ''ElapsedTimeOfScreen''  
UNION    
SELECT ''CustomScreenForServices'' , ''ScreeningCompletedBy''  
UNION    
SELECT ''CustomScreenForServices'' , ''County''  
UNION    
SELECT ''CustomScreenForServices'' , ''Ethnicity''  
UNION    
SELECT ''CustomScreenForServices'' , ''MaritalStatus''  
UNION    
SELECT ''CustomScreenForServices'' , ''Sex''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientName''  
UNION    
SELECT ''CustomScreenForServices'' , ''DateOfBirth''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientAddress''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientCity''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientState''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientZip''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientCounty''  
UNION    
SELECT ''CustomScreenForServices'' , ''ClientHomePhone''  
UNION    
SELECT ''CustomScreenForServices'' , ''EmergencyContact''  
UNION    
SELECT ''CustomScreenForServices'' , ''RelationWithClient''  
  
  
    
-- REFERRAL SOURCE    
UNION    
SELECT ''CustomScreenForServices'', ''ReferralSourceType''  
UNION    
SELECT ''CustomScreenForServices'', ''ReferralSouceName''  
UNION    
SELECT ''CustomScreenForServices'', ''Location''  
UNION    
SELECT ''CustomScreenForServices'', ''ReferralSourceContacted''  
UNION    
SELECT ''CustomScreenForServices'', ''ReferralSourceContactedDetail''  
    
    
UNION    
SELECT ''CustomScreenForServices'', ''JustificationForReferral''  
    
    
UNION    
SELECT ''CustomScreenForServices'', ''Aggressive''  
    
UNION    
SELECT ''CustomScreenForServices'', ''AWOLRisk''  
UNION    
SELECT ''CustomScreenForServices'', ''AWOLRiskDetail''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Physical''  
UNION    
SELECT ''CustomScreenForServices'', ''PhysicalDetail''  
UNION    
SELECT ''CustomScreenForServices'', ''Ideation''  
UNION    
SELECT ''CustomScreenForServices'', ''IdeationDetail''  
UNION    
SELECT ''CustomScreenForServices'', ''SexualActingOut''  
UNION    
SELECT ''CustomScreenForServices'', ''SexualActingOutDetail''  
UNION    
SELECT ''CustomScreenForServices'', ''Verbal''  
UNION    
SELECT ''CustomScreenForServices'', ''VerbalDetail''  
UNION    
SELECT ''CustomScreenForServices'', ''DestructionOfProperty''  
UNION    
SELECT ''CustomScreenForServices'', ''DestructionOfPropertyDetail''  
  
UNION    
SELECT ''CustomScreenForServices'', ''History''  
  
UNION    
SELECT ''CustomScreenForServices'', ''ChargesPending''   
    
UNION    
SELECT ''CustomScreenForServices'', ''ChargesPendingDetail''  
    
UNION    
SELECT ''CustomScreenForServices'', ''JailHold''  
UNION    
SELECT ''CustomScreenForServices'' , ''CurrentSuicidalIdeation''  
UNION    
SELECT ''CustomScreenForServices'', ''EgoExplanation''  
  
    
UNION    
SELECT ''CustomScreenForServices'', ''HasPlanDetail''  
    
UNION    
SELECT ''CustomScreenForServices'', ''AccessToMeansDetail''  
    
    
    
-- SLAP Questions    
UNION    
SELECT ''CustomScreenForServices'', ''HistorySuicidalAttempts''  
    
UNION    
SELECT ''CustomScreenForServices'', ''HistoryFamily''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Diagnosis''  
UNION    
SELECT ''CustomScreenForServices'', ''PreviousRescue''  
UNION    
SELECT ''CustomScreenForServices'', ''FamilySupport''  
UNION    
SELECT ''CustomScreenForServices'', ''FamilyUnwillingToHelp''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Dependence''  
  
UNION    
SELECT ''CustomScreenForServices'', ''ConstrictedThinking''  
  
UNION    
SELECT ''CustomScreenForServices'', ''EgosyntonicAttitude''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Helplessness''  
UNION    
SELECT ''CustomScreenForServices'', ''Hopelessness''  
  
UNION    
SELECT ''CustomScreenForServices'', ''MakingPreparations''  
UNION    
SELECT ''CustomScreenForServices'', ''NoAmbivalence''  
UNION    
SELECT ''CustomScreenForServices'', ''SelfHarmfulBehaviour''  
UNION    
SELECT ''CustomScreenForServices'', ''SelfHarmfulBehaviourDetail''  
  
    
UNION    
SELECT ''CustomScreenForServices'', ''OutcomeDetail''  
  
    
UNION    
SELECT ''CustomScreenForServices'', ''NameOfPrimaryCarePhysician''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Allergies''  
UNION    
SELECT ''CustomScreenForServices'' , ''CurrentHealthConcerns''  
UNION    
SELECT ''CustomScreenForServices'', ''ConsumerRequested''  
    
UNION    
SELECT ''CustomScreenForServices'', ''Recommended''  
UNION    
SELECT ''CustomScreenForServices'' , ''OtherFacilityName''  
UNION    
SELECT ''CustomScreenForServices'' , ''Summary''  
    
    
    
 --Full Mental Status    
-- exec csp_validateFullMentalStatus @documentId, @documentCodeId    
 --if @@error <> 0 goto error    
     
 --SU Assessment Validation    
 --exec csp_validateCustomSUAssessments @documentId, @documentCodeId    
 --if @@error <> 0 goto error    
     
 --Diagnosis Validation    
 --exec csp_validateDiagnosis @documentId, @documentCodeId    
 --if @@error <> 0 goto error    
     
    
    
    
    
if @@error <> 0 goto error    
    
    
    
    
    
return    
    
error:    
raiserror 50000 ''csp_RequiredCustomScreenForServices  failed.  Contact your system administrator.''
' 
END
GO
