/****** Object:  StoredProcedure [dbo].[csp_RequiredCustomHospitalizationPrescreen]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomHospitalizationPrescreen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RequiredCustomHospitalizationPrescreen]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RequiredCustomHospitalizationPrescreen]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_RequiredCustomHospitalizationPrescreen]      
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
    
      
SELECT ''CustomHospitalizationPrescreens'', ''DateOfPrescreen''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''InitialCallTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ElapsedTimeOfScreen''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''CHMStatus''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''EventStartTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''TravelTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ScreenContactType''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''DispositionTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ReferralToProviderTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''EventStopTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ProviderResponseTime''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ScreeningCompletedBy''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''County''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Ethnicity''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MaritalStatus''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Sex''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientName''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''DateOfBirth''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientAddress''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientCity''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientState''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientZip''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientCounty''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ClientHomePhone''    
      
--REPORTED PAYMENT SOURCE      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Indigent''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PrivateDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''EmployerName''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''EmployerNumber''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MedicareType''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MedicareNumber''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MedicaidType''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MedicaidNumber''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''OtherReportedPaymentSourceDetail''    
-- REFERRAL SOURCE      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ReferralSourceType''    
    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ReferralSouceName''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Location''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ReferralSourceContacted''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ReferralSourceContactedDetail''    
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''JustificationForReferral''    
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Aggressive''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AWOLRisk''    
    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AWOLRiskDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Physical''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PhysicalDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Ideation''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''IdeationDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''SexualActingOut''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''SexualActingOutDetail''          
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Verbal''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''VerbalDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''DestructionOfProperty''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''DestructionOfPropertyDetail''    
    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''History''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ChargesPending''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ChargesPendingDetail''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''JailHold''    
      
      
     
UNION       
SELECT ''CustomHospitalizationPrescreens'', ''EgoExplanation''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''HasPlanDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AccessToMeansDetail''    
      
-- SLAP Questions      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''HistorySuicidalAttempts''      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''HistoryFamily''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Diagnosis''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PreviousRescue''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilySupport''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilyUnwillingToHelp''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ConstrictedThinking''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''EgosyntonicAttitude''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Helplessness''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Hopelessness''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''MakingPreparations''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''NoAmbivalence''    
      
    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''CurrentSelfHarmfulBehaviourDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''CurrentSelfHarmfulBehaviourOutcomeDetail''    
      
    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PreviousSelfHarmfulBehaviourDetail''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PreviousSelfHarmfulBehaviourOutcome''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilyHistory''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilyHistoryDetail''    
      
    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''NameOfPrimaryCarePhysician''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Allergies''    
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''CurrentHealthConcerns''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PreviosHealthConcerns''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PsychiatricSymptoms''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PossibleHarmToSelf''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''PossibleHarmToOther''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''DrugComplication''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Disruption''    
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''IntensityOfService''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''ConsumerRequested''    
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Recommended''    
      
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''HospitalizationStatus''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''OtherFacilityName''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AlternativeServicesAgreed''    
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AlternativeServices''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AlternativeServicesDetail''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''AdequateNoticeGiven''    
      
      
      
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilyNotification''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''FamilyMemeberName''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''Summary''    
UNION      
SELECT ''CustomHospitalizationPrescreens'', ''SignedByConsumer''    
      

      
if @@error <> 0 goto error      
      
     
      
return      
      
error:      
raiserror 50000 ''csp_RequiredCustomHospitalizationPrescreen  failed.  Contact your system administrator.''
' 
END
GO
