/****** Object:  StoredProcedure [dbo].[csp_InitCustomScreenForServicesStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomScreenForServicesStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomScreenForServicesStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomScreenForServicesStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomScreenForServicesStandardInitialization]   
(                                  
 @ClientID int,                
 @StaffID int,              
 @CustomParameters xml            
)                                                          
As                                                            
 /*********************************************************************/                                                                          
 /* Stored Procedure: [csp_InitCustomScreenForServicesStandardInitialization]               */                                                                 
 /* Creation Date:  23/April/2010                                    */                                                                          
 /*                                                                   */                                                                          
 /* Purpose: To Initialize */                                                                         
 /*                                                                   */                                                                        
 /* Input Parameters:  */                                                                        
 /*                                                                   */                                                                           
 /* Output Parameters:                                */                                                                          
 /*                                                                   */                                                                          
 /* Return:   */                                                                          
 /*                                                                   */                                                                          
 /* Called By:CustomDocuments Class Of DataService    */                                                                
 /*      */                                                                
                                                                 
 /*                                                                   */                                                                          
 /* Calls:                                                            */                                                                          
 /*                                                                   */                                                                          
 /* Data Modifications:                                               */                                                                          
 /*                                                                   */                                                                          
 /*   Updates:                                                          */                                                                          
                                                                 
 /*       Date              Author                  Purpose                                    */               
 /*    19/07/2010        Damanpreet Kaur        Modified because of new data model */                                                             
 /*********************************************************************/                                                                           
Begin            
                         
declare @LatestDocumentVersionID int          
set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                                
from Documents a                                                    
where a.ClientId = @ClientID                                                    
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                    
and a.Status = 22                
and a.DocumentCodeId=5                                                     
and isNull(a.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc )                                                                                                             
                     
declare @ClientName as varchar(110),@Sex as Char(1),@MaritialStatus as int,      
@DOB as datetime,@SSN as varchar(25),@Address as varchar(150),@City as varchar(50),@State as varchar(2),      
@Zip as varchar(25),@Ethnicity as int,@Phone as varchar(80),@County as varchar(5),@GuardianName AS VARCHAR(100),      
@EmergencyPhone as varchar(50),@Relationship as int,@EmergencyContact as varchar(500),@GuardianPhone as varchar(80)       
      
Select @ClientName = ISNULL(LastName, '''') + '', '' + ISNULL(MiddleName, '''') + '' '' + ISNULL(FirstName, ''''),       
@Sex = Sex,@MaritialStatus=MaritalStatus,@DOB=DOB,@SSN=RIGHT(SSN,4),@County=CountyOfResidence       
from Clients      
where ClientId=@ClientID      
      
Select top 1 @Address = [Address],@City=City,@State=[State],@Zip=Zip      
from ClientAddresses      
where ClientId=@ClientID      
      
select @Ethnicity=RaceId from ClientRaces where ClientId=@ClientID      
      
set @Phone=(Select top 1 PhoneNumber from ClientContactPhones       
Join ClientContacts on       
ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and      
ClientContacts.ClientId=@ClientID and PhoneType=30      
and IsNull(ClientContacts.RecordDeleted,''N'')=''N'' and IsNull(ClientContactPhones.RecordDeleted,''N'')=''N'')      
      
Select top 1 @GuardianName=(case clientcontacts.guardian when ''N''              
     THEN ''''    
       when ''Y''             
     THEN ISNULL(ClientContacts.LastName, '''') + '', '' + ISNULL(ClientContacts.MiddleName, '''') + '' '' + ISNULL(ClientContacts.FirstName, '''')                  
     ELSE  
     ''''  
     END),    
      @EmergencyContact =          
     case clientcontacts.EmergencyContact when ''N''              
     THEN ''''    
       when ''Y''             
     THEN ISNULL(ClientContacts.LastName, '''') + '', '' + ISNULL(ClientContacts.MiddleName, '''') + '' '' + ISNULL(ClientContacts.FirstName, '''')                  
     ELSE  
     ''''  
     END  
              
FROM ClientContacts                             
WHERE (ClientId  = @ClientID)and  isnull(recorddeleted, ''N'') = ''N''     
      
Select  top 1 @Relationship=ClientContacts.Relationship,      
   @EmergencyPhone =               
     case when ClientContacts.EmergencyContact IS NULL OR ClientContacts.EmergencyContact = ''N''                           
     THEN ''''               
     ELSE       
 (Select top 1 PhoneNumber from ClientContactPhones where ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and               
                        
  IsNull(RecordDeleted,''N'')=''N'')              
     END ,    
     @GuardianPhone =               
     case when ClientContacts.Guardian IS NULL OR ClientContacts.Guardian = ''N''                           
     THEN ''''               
     ELSE       
 (Select top 1 PhoneNumber from ClientContactPhones where ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and               
                        
  IsNull(RecordDeleted,''N'')=''N'')              
     END                       
FROM ClientContactPhones                   
RIGHT OUTER JOIN ClientContacts ON ClientContactPhones.ClientContactId = ClientContacts.ClientContactId                   
   and isnull(ClientContactPhones.recorddeleted, ''N'') = ''N''                   
   and isnull(clientcontacts.recorddeleted, ''N'') = ''N''                    
RIGHT OUTER JOIN Clients ON ClientContacts.ClientId = Clients.ClientId                   
   and ClientContacts.EmergencyContact=''Y''                   
   and isnull(clientcontacts.recorddeleted, ''N'') = ''N''                    
   and isnull(clients.recorddeleted, ''N'') = ''N''                  
LEFT  OUTER JOIN ClientAddresses ON Clients.ClientId = ClientAddresses.ClientId                    
   and ( Clients.Recorddeleted is null  or Clients.Recorddeleted =''N'')                   
   and isnull(ClientAddresses.recorddeleted, ''N'') = ''N''                  
WHERE (Clients.ClientId = @ClientID)  
               
Begin try                                                                                         
if(exists        
(Select * from CustomScreenForServices C,Documents D,                
 DocumentVersions V                                           
 where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId and D.ClientId=@ClientID        
       and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))       
             
      
          
BEGIN                  
 SELECT TOP 1 ''CustomScreenForServices'' AS TableName,        
     C.[DocumentVersionId]                    
    ,[DateOfScreen]        
    ,[EventStartTime]        
    ,[DispositionTime]        
    ,[EventStopTime]        
    ,[ElapsedTimeOfScreen]        
    ,[ScreeningCompletedBy]        
    ,[County]        
    ,[OtherCounty]        
    ,@Ethnicity as [Ethnicity]        
    ,@MaritialStatus as [MaritalStatus]       
    ,@Sex as [Sex]        
    ,@ClientName as [ClientName]        
    ,[CMHCaseNumber]        
    ,@SSN as [SSN]       
    ,@DOB as [DateOfBirth]       
    ,@Address as [ClientAddress]      
    ,@City as [ClientCity]       
    ,@State as [ClientState]       
    ,@Zip  as [ClientZip]      
    ,@County as [ClientCounty]        
    ,@Phone as [ClientHomePhone]        
    ,@EmergencyContact as [EmergencyContact]         
    ,@Relationship as [RelationWithClient]        
    ,@EmergencyPhone as [EmergencyPhone]        
    ,@GuardianName as [GuardianName]        
    ,@GuardianPhone as [GuardianPhone]        
    ,[ReferralSourceType]        
    ,[OtherReferral]        
    ,[ReferralSouceName]        
    ,[Location]        
    ,[Phone]        
    ,[ReferralSourceContacted]        
    ,[ReferralSourceContactedDetail]        
    ,[JustificationForReferral]        
    ,[Aggressive]        
    ,[AWOLRisk]        
    ,[AWOLRiskDetail]        
    ,[Physical]        
    ,[PhysicalDetail]        
    ,[Ideation]        
    ,[IdeationDetail]        
    ,[SexualActingOut]        
    ,[SexualActingOutDetail]        
    ,[Verbal]        
    ,[VerbalDetail]        
    ,[DestructionOfProperty]        
    ,[DestructionOfPropertyDetail]        
    ,[History]        
    ,[ChargesPending]        
    ,[ChargesPendingDetail]        
    ,[JailHold]        
    ,[CurrentSuicidalIdeation]        
    ,[ActiveSuicidal]        
    ,[PassiveSuicidal]        
    ,[SuicidalIdeationWithin48Hours]        
    ,[SuicidalIdeationWithin14Days]        
    ,[SuicidalEgoSyntonic]        
    ,[SuicidalEgoDystonic]        
    ,[EgoExplanation]        
    ,[HasPlan]        
    ,[HasPlanDetail]        
    ,[AccessToMeans]        
    ,[AccessToMeansDetail]        
    ,[HistorySuicidalAttempts]        
    ,[HistoryFamily]        
    ,[Diagnosis]        
    ,[PreviousRescue]        
    ,[FamilySupport]        
    ,[FamilyUnwillingToHelp]        
    ,[Dependence]        
    ,[ConstrictedThinking]        
    ,[EgosyntonicAttitude]        
    ,[Helplessness]        
    ,[Hopelessness]        
    ,[MakingPreparations]        
    ,[NoAmbivalence]        
    ,[SelfHarmfulBehaviour]        
    ,[SelfHarmfulBehaviourDetail]        
    ,[OutcomeDetail]        
    ,[UnableToObtain]        
    ,[NumberOfInpatient]        
    ,[DateOfRecentInpatient]        
    ,[Facility]        
    ,[PreviosOutpatientTreatment]        
    ,[LastSeen]        
    ,[CurrentTherapist]        
    ,[NameOfPrimaryCarePhysician]        
    ,[PhysicianPhone]        
    ,[Allergies]        
    ,[CurrentHealthConcerns]        
    ,[ConsumerRequested]        
    ,[OtherRequested]        
    ,[Recommended]        
    ,[OtherRecommended]        
    ,[RequestNotAuthorized]        
    ,[HospitalizationStatus]        
    ,[FacilityName]        
    ,[OtherFacilityName]        
    ,[Summary]        
    ,[NoSubstanceUseSuspected]        
    ,[FamilySUHistory]        
    ,[ClientSUHistory]        
    ,[CurrentSubstanceUse]        
    ,[CurrentSubstanceUseSuspected]        
    ,[RecomendedSubstanceUse]        
    ,[SubstanceUseDetails]        
    ,[FacilityProviderId]        
    ,[FacilitySiteId]        
    ,[NotifyStaffId1]        
    ,[NotifyStaffId2]        
    ,[NotifyStaffId3]        
    ,[NotifyStaffId4]        
    ,[NotificationMessage]        
    ,[NotificationSent]        
    ,C.[CreatedBy]                    
    ,C.[CreatedDate]                    
    ,C.[ModifiedBy]                    
    ,C.[ModifiedDate]                   
    ,C.[RecordDeleted]                    
    ,C.[DeletedDate]                    
    ,C.[DeletedBy]                    
   FROM CustomScreenForServices C INNER JOIN        
  DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN        
  Documents AS D ON V.DocumentId = D.DocumentId        
  WHERE (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'')       
  AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')        
  ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC ,V.DocumentVersionId DESC           
         
 SELECT TOP 1 ''MentalStatus'' AS TableName,          
     M.[DocumentVersionId]          
    ,[UnableToAssess]          
   ,[AppearanceDressed]          
    ,[AppearanceAge]          
    ,[AppearanceAverageWeight]          
    ,[AppearanceAverageHeight]          
    ,[AppearanceGroomed]          
    ,[AppearanceHygiene]          
    ,[ApprearanceOther]          
    ,[AppearanceOtherText]          
    ,[BehaviorGait]          
    ,[BehaviorEyeContact]          
    ,[BehaviorTics]          
    ,[BehaviorTremors]          
    ,[BehaviorTwitches]          
    ,[BehaviorAgitated]          
    ,[BehaviorActivity]          
    ,[BehaviorLethargic]          
    ,[BehaviorAggressive]          
    ,[BehaviorNormalActivity]          
    ,[BehaviorOther]          
    ,[BehaviorOtherText]          
    ,[AttitudeCooperative]          
    ,[AttitudeDefensive]          
    ,[AttitudeReserved]          
    ,[AttitudeMistrustful]          
    ,[AttitudeOther]          
    ,[AttitudeOtherText]          
    ,[AffectBlunted]          
    ,[AffectCongruent]          
    ,[AffectUnremarkable]          
    ,[AffectUnableToAssess]          
    ,[AffectFlat]          
    ,[AffectRestricted]          
    ,[AffectExpansive]          
    ,[AffectAngry]          
    ,[AffectSad]          
    ,[AffectIrritable]          
    ,[AffectFearful]          
    ,[AffectMood]          
    ,[AffectOther]          
    ,[AffectOtherText]          
    ,[SpeechCoherent]          
    ,[SpeechSpeed]          
    ,[SpeechVerbal]          
    ,[SpeechClear]          
    ,[SpeechVolume]          
    ,[SpeechPressured]          
    ,[SpeechRepetitive]          
    ,[SpeechSpontaneous]          
    ,[SpeechSlurred]          
    ,[SpeechMonotonous]          
    ,[SpeechTalkative]          
    ,[SpeechEcholalia]          
    ,[SpeechOther]          
    ,[SpeechOtherText]          
    ,[ThoughtLucid]          
    ,[ThoughtParanoid]          
    ,[ThoughtDelusional]          
    ,[ThoughtTangential]          
    ,[ThoughtLoose]          
    ,[ThoughtPsychosis]          
    ,[ThoughtImpoverished]          
    ,[ThoughtConfused]          
    ,[ThoughtObsessive]          
    ,[ThoughtObsessiveText]          
    ,[ThoughtProcessingOther]          
    ,[MoodNeutral]          
    ,[MoodFriendly]          
    ,[MoodLabile]          
    ,[MoodAnxious]          
    ,[MoodGuilty]          
    ,[MoodIrritable]          
    ,[MoodFearful]          
    ,[MoodSad]          
    ,[MoodTearful]          
    ,[MoodAppropriate]          
    ,[MoodIncongruent]          
    ,[MoodOtherMoods]          
    ,[MoodOtherMoodsText]          
    ,[CognitionNormal]          
    ,[CognitionLimited]          
    ,[CognitionPhobias]          
    ,[CognitionObsessions]          
    ,[CognitionPreoccupation]          
    ,[CognitionOther]          
    ,[CognitionOtherText]          
    ,[AttentionAppropriate]          
    ,[AttentionGood]          
    ,[AttentionImpaired]          
    ,[AttentionOther]          
    ,[AttentionOtherText]          
    ,[LevelAlert]          
    ,[LevelSedate]          
    ,[LevelLethargic]          
    ,[LevelObtuned]          
    ,[LevelOther]          
    ,[LevelOtherText]          
    ,[PerceptualNo]          
    ,[PerceptualDelusions]          
    ,[PerceptualAuditory]          
    ,[PerceptualVisual]          
    ,[PerceptualOlfactory]          
    ,[PerceptualTactile]          
    ,[PerceptualDepersonalization]          
    ,[PerceptualIdeas]          
    ,[PerceptualParanoia]          
    ,[PerceptualOther]          
    ,[PerceptualOtherText]          
    ,[MemoryIntact]          
    ,[MemoryShortTerm]          
    ,[MemoryLongTerm]          
    ,[MemoryOther]          
    ,[MemoryOtherText]          
    ,[JudgementAware]          
    ,[JudgementUnderstandsOutcomes]          
    ,[JudgementUnderstandsNeed]          
    ,[JudgementRiskyBehavior]          
    ,[JudgementIntact]          
    ,[JudgementImpaired]          
    ,[JudgementImpairedText]          
    ,[JudgementOther]          
    ,[JudgementOtherText]          
    ,[OtherPx]          
    ,[OtherNotMedication]          
    ,[OtherEating]          
    ,[OtherEatingText]          
    ,[OtherSleep]          
    ,[OtherSleepText]          
    ,[OrientationPerson]          
    ,[OrientationPlace]          
    ,[OrientationTime]          
    ,[OrientationCircumstance]          
    ,[OrientationText]          
    ,[DisturbanceNoneNoted]          
    ,[DisturbanceDelusions]          
    ,[DisturbanceAuditory]          
    ,[DisturbanceVisual]          
    ,[DisturbanceOlfactory]          
    ,[DisturbanceTactile]          
    ,[DisturbanceDepersonalization]          
    ,[DisturbanceDerealization]          
    ,[DisturbanceIdeas]          
    ,[DisturbanceParanoia]          
    ,[DisturbanceOther]          
    ,[DisturbanceOtherText]          
    ,[RiskSuicideNotPresent]          
    ,[RiskSuicideIdeation]          
    ,[RiskSuicideActive]          
    ,[RiskSuicidePassive]          
    ,[RiskSuicideMeans]          
    ,[RiskSuicidePlan]          
    ,[RiskSuicideAttempt]          
    ,[RiskSuicideTxPlan]          
    ,[RiskHomicideNotPresent]          
    ,[RiskHomicideIdeation]          
    ,[RiskHomicideActive]          
    ,[RiskHomicidePassive]          
    ,[RiskHomicideMeans]          
    ,[RiskHomicidePlan]          
    ,[RiskHomicideAttempt]          
    ,[RiskHomicideTxPlan]          
    ,[RiskOther]          
    ,[RiskIntervention]          
    ,[ThoughtGrandiose]          
    ,[ThoughtFlightOfIdeas]          
    ,[ThoughtDisorganized]          
    ,[ThoughtBizarre]          
    ,[BehaviorCompulsive]          
    ,[BehaviorPeculiar]          
    ,[BehaviorManipulative]          
    ,M.[CreatedBy]          
    ,M.[CreatedDate]          
    ,M.[ModifiedBy]          
    ,M.[ModifiedDate]          
    ,M.[RecordDeleted]          
    ,M.[DeletedDate]          
    ,M.[DeletedBy]          
   FROM [MentalStatus]M,Documents D,                        
   DocumentVersions V                                
   where M.DocumentVersionId=V.DocumentVersionId and V.DocumentId=D.DocumentId                         
   and D.ClientId=@ClientID                        
   and D.Status=22  and IsNull(M.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                                     
   order by D.EffectiveDate Desc,D.ModifiedDate Desc            
           
                          
 Select TOP 1 ''CustomSubstanceUseHistory'' AS TableName,          
    [SubstanceUseHistoryId]                              
    ,C.DocumentVersionId           
    ,[Substance]          
    ,[AgeOfFirstUse]          
    ,[Method]          
    ,[CurrentFrequencyAmount]          
    ,[LengthOfBinge]          
    ,[LastUsed]          
    ,[Preferred]         
    ,C.[CreatedBy]          
    ,C.[CreatedDate]          
    ,C.[ModifiedBy]          
    ,C.[ModifiedDate]          
    ,C.[RecordDeleted]          
    ,C.[DeletedDate]          
    ,C.[DeletedBy]                              
 from CustomSubstanceUseHistory C INNER JOIN        
   DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN        
   Documents AS D ON V.DocumentId = D.DocumentId        
  WHERE (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'')         
  AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')        
  ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC ,V.DocumentVersionId DESC         
        
 Select Top 1 ''CustomSubstanceUseAssessments'' AS TableName,        
     C.[DocumentVersionId]        
    ,[VoluntaryAbstinenceTrial]        
    ,[Comment]        
    ,[HistoryOrCurrentDUI]        
    ,[NumberOfTimesDUI]        
    ,[HistoryOrCurrentDWI]        
    ,[NumberOfTimesDWI]        
    ,[HistoryOrCurrentMIP]        
    ,[NumberOfTimeMIP]        
    ,[HistoryOrCurrentBlackOuts]        
    ,[NumberOfTimesBlackOut]        
    ,[HistoryOrCurrentDomesticAbuse]        
    ,[NumberOfTimesDomesticAbuse]        
    ,[LossOfControl]        
    ,[IncreasedTolerance]        
    ,[OtherConsequence]        
    ,[OtherConsequenceDescription]        
    ,[RiskOfRelapse]        
    ,[PreviousTreatment]        
    ,[CurrentSubstanceAbuseTreatment]        
    ,[CurrentTreatmentProvider]        
    ,[CurrentSubstanceAbuseReferralToSAorTx]        
    ,[CurrentSubstanceAbuseRefferedReason]        
    ,[ToxicologyResults]        
    ,[ClientSAHistory]        
    ,[FamilySAHistory]        
    ,[NoSubstanceAbuseSuspected]        
    ,[CurrentSubstanceAbuse]        
    ,[SuspectedSubstanceAbuse]        
    ,[SubstanceAbuseDetail]        
    ,[SubstanceAbuseTxPlan]        
    ,[OdorOfSubstance]        
    ,[SlurredSpeech]        
    ,[WithdrawalSymptoms]        
    ,[DTOther]        
    ,[DTOtherText]        
    ,[Blackouts]        
    ,[RelatedArrests]        
    ,[RelatedSocialProblems]        
    ,[FrequentJobSchoolAbsence]        
    ,[NoneSynptomsReportedOrObserved]        
    ,C.[RowIdentifier]        
    ,C.[CreatedBy]        
    ,C.[CreatedDate]        
    ,C.[ModifiedBy]        
    ,C.[ModifiedDate]        
    ,C.[RecordDeleted]        
    ,C.[DeletedDate]        
    ,C.[DeletedBy]        
    From CustomSubstanceUseAssessments C  INNER JOIN        
   DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN        
   Documents AS D ON V.DocumentId = D.DocumentId        
  WHERE (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'')         
  AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')        
  ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC ,V.DocumentVersionId DESC         
                                               
                      
 SELECT ''DiagnosesIAndII'' AS TableName,DIandII.DiagnosisId,DIandII.DocumentVersionId,DIandII.Axis                                                  
 ,DIandII.DSMCode,DIandII.DSMNumber,DIandII.DiagnosisType,DIandII.RuleOut,DIandII.Billable                                                  
 ,DIandII.Severity,DIandII.DSMVersion,DIandII.DiagnosisOrder,DIandII.Specifier,DIandII.Source,DIandII.Remission,DIandII.RowIdentifier                                                  
 ,DIandII.CreatedBy,DIandII.CreatedDate,DIandII.ModifiedBy,DIandII.ModifiedDate,DIandII.RecordDeleted                                                  
 ,DIandII.DeletedDate,DIandII.DeletedBy,DSM.DSMDescription,case DIandII.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText                                                               
 from DiagnosesIAndII as DIandII                                 
 inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = DIandII.DSMCode and DSM.DSMNumber=DIandII.DSMNumber        
 inner join DocumentVersions V  on V.DocumentVersionId=DIandII.DocumentVersionId           
 inner join Documents D on  D.DocumentId= V.DocumentId and DIandII.DocumentVersionId=D.CurrentDocumentVersionId        
 where D.ClientId=@ClientID and D.Status=22 and IsNull(DIandII.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                      
 order by D.EffectiveDate desc        
                                          
  
 SELECT TOP 1 ''DiagnosesIII'' AS TableName,DIII.DocumentVersionId,DIII.Specification                                                  
 ,DIII.CreatedBy,DIII.CreatedDate,DIII.ModifiedBy,DIII.ModifiedDate,DIII.RecordDeleted,DIII.DeletedDate,DIII.DeletedBy                                                   
 from DiagnosesIII as DIII,Documents D, DocumentVersions V   where         
 D.DocumentId=V.DocumentId and V.DocumentVersionId=DIII.DocumentVersionId         
 and DIII.DocumentVersionId=D.CurrentDocumentVersionId  and D.ClientId=@ClientID                                        
 and D.Status=22 and IsNull(DIII.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                      
 order by D.EffectiveDate  desc      
         
        
      ----For DiagnosesIV--                                                  
 SELECT TOP 1 ''DiagnosesIV'' AS TableName,DIV.DocumentVersionId,DIV.PrimarySupport,DIV.SocialEnvironment,DIV.Educational                                                  
 ,DIV.Occupational,DIV.Housing,DIV.Economic,DIV.HealthcareServices,DIV.Legal,DIV.Other,DIV.Specification,DIV.CreatedBy                                                  
 ,DIV.CreatedDate,DIV.ModifiedBy,DIV.ModifiedDate,DIV.RecordDeleted,DIV.DeletedDate,DIV.DeletedBy                                                   
 from DiagnosesIV as DIV,Documents D, DocumentVersions V   where         
 D.DocumentId=V.DocumentId and V.DocumentVersionId=DIV.DocumentVersionId         
 and DIV.DocumentVersionId=D.CurrentDocumentVersionId  and D.ClientId=@ClientID                                        
 and D.Status=22 and IsNull(DIV.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                       order by D.EffectiveDate  desc        
        
      -----For DiagnosesV---                                                  
 SELECT TOP 1 ''DiagnosesV'' AS TableName,DV.DocumentVersionId,DV.AxisV,DV.CreatedBy,DV.CreatedDate,DV.ModifiedBy                                                  
 ,DV.ModifiedDate,DV.RecordDeleted,DV.DeletedDate,DV.DeletedBy                                                  
 from DiagnosesV as DV,Documents D, DocumentVersions V   where         
 D.DocumentId=V.DocumentId and V.DocumentVersionId=DV.DocumentVersionId         
 and DV.DocumentVersionId=D.CurrentDocumentVersionId  and D.ClientId=@ClientID                      
 and D.Status=22 and IsNull(DV.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                      
 order by D.EffectiveDate  desc    
     
   ----For DiagnosesIIICodes  
 SELECT  ''DiagnosesIIICodes'' AS TableName,DIIICod.DiagnosesIIICodeId,DIIICod.DocumentVersionId,DIIICod.ICDCode,DIIICod.Billable                                                  
 ,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy ,DICD.ICDDescription                                                   
 from DiagnosesIIICodes as DIIICod,Documents D, DocumentVersions V ,DiagnosisICDCodes as DICD   where         
 D.DocumentId=V.DocumentId and V.DocumentVersionId=DIIICod.DocumentVersionId         
 and DIIICod.DocumentVersionId=D.CurrentDocumentVersionId  and D.ClientId=@ClientID                                        
 and D.Status=22 and IsNull(DIIICod.RecordDeleted,''N'')=''N'' and DICD.ICDCode=DIIICod.ICDCode and IsNull(D.RecordDeleted,''N'')=''N''                                      
 order by D.EffectiveDate  desc       
 
  ----For DiagnosesIANDIIMaxOrder 
	SELECT  top 1 ''DiagnosesIANDIIMaxOrder'' as TableName,max(DiagnosisOrder) as DiagnosesMaxOrder,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate 
	from  DiagnosesIAndII 
	where DocumentVersionId=@LatestDocumentVersionID          
	and  IsNull(RecordDeleted,''N'')=''N''
	group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,
	DeletedDate order by DiagnosesMaxOrder desc
                  
END              
else                                          
BEGIN                  
        
SELECT TOP 1 ''CustomScreenForServices'' AS TableName,        
    -1 as ''DocumentVersionId''        
      ,[DateOfScreen]        
      ,[EventStartTime]        
      ,[DispositionTime]        
      ,[EventStopTime]        
      ,[ElapsedTimeOfScreen]        
      ,[ScreeningCompletedBy]        
      ,[County]        
      ,[OtherCounty]        
      ,@Ethnicity as [Ethnicity]      
      ,@MaritialStatus as [MaritalStatus]       
      ,@Sex as [Sex]        
      ,@ClientName as [ClientName]        
      ,[CMHCaseNumber]        
      ,@SSN as [SSN]       
      ,@DOB as [DateOfBirth]       
      ,@Address as [ClientAddress]      
      ,@City as [ClientCity]       
      ,@State as [ClientState]       
      ,@Zip as [ClientZip]      
      ,@County as [ClientCounty]         
      ,@Phone as [ClientHomePhone]        
      ,@EmergencyContact as [EmergencyContact]      
      ,@Relationship as [RelationWithClient]         
      ,@EmergencyPhone as [EmergencyPhone]      
      ,@GuardianName as [GuardianName]       
      ,@GuardianPhone as [GuardianPhone]        
      ,[ReferralSourceType]        
      ,[OtherReferral]        
      ,[ReferralSouceName]        
      ,[Location]        
      ,[Phone]        
      ,[ReferralSourceContacted]        
      ,[ReferralSourceContactedDetail]        
      ,[JustificationForReferral]        
      ,[Aggressive]        
      ,[AWOLRisk]        
      ,[AWOLRiskDetail]        
      ,[Physical]        
      ,[PhysicalDetail]        
      ,[Ideation]        
      ,[IdeationDetail]        
      ,[SexualActingOut]        
      ,[SexualActingOutDetail]        
      ,[Verbal]        
      ,[VerbalDetail]        
      ,[DestructionOfProperty]        
      ,[DestructionOfPropertyDetail]        
      ,[History]        
      ,[ChargesPending]        
      ,[ChargesPendingDetail]        
      ,[JailHold]        
      ,[CurrentSuicidalIdeation]        
      ,[ActiveSuicidal]        
      ,[PassiveSuicidal]        
      ,[SuicidalIdeationWithin48Hours]        
      ,[SuicidalIdeationWithin14Days]        
      ,[SuicidalEgoSyntonic]        
      ,[SuicidalEgoDystonic]        
      ,[EgoExplanation]        
      ,[HasPlan]        
      ,[HasPlanDetail]        
      ,[AccessToMeans]        
      ,[AccessToMeansDetail]        
      ,[HistorySuicidalAttempts]        
      ,[HistoryFamily]        
      ,[Diagnosis]        
      ,[PreviousRescue]        
      ,[FamilySupport]        
      ,[FamilyUnwillingToHelp]        
      ,[Dependence]        
      ,[ConstrictedThinking]        
      ,[EgosyntonicAttitude]        
      ,[Helplessness]        
      ,[Hopelessness]        
      ,[MakingPreparations]        
      ,[NoAmbivalence]        
      ,[SelfHarmfulBehaviour]        
      ,[SelfHarmfulBehaviourDetail]        
      ,[OutcomeDetail]        
      ,[UnableToObtain]        
      ,[NumberOfInpatient]        
      ,[DateOfRecentInpatient]        
      ,[Facility]        
      ,[PreviosOutpatientTreatment]        
      ,[LastSeen]        
      ,[CurrentTherapist]        
      ,[NameOfPrimaryCarePhysician]        
      ,[PhysicianPhone]        
      ,[Allergies]        
      ,[CurrentHealthConcerns]        
      ,[ConsumerRequested]        
      ,[OtherRequested]        
      ,[Recommended]        
      ,[OtherRecommended]        
      ,[RequestNotAuthorized]        
      ,[HospitalizationStatus]        
      ,[FacilityName]        
      ,[OtherFacilityName]        
      ,[Summary]        
      ,[NoSubstanceUseSuspected]        
      ,[FamilySUHistory]        
      ,[ClientSUHistory]        
      ,[CurrentSubstanceUse]        
      ,[CurrentSubstanceUseSuspected]        
      ,[RecomendedSubstanceUse]        
      ,[SubstanceUseDetails]        
      ,[FacilityProviderId]        
      ,[FacilitySiteId]        
      ,[NotifyStaffId1]        
      ,[NotifyStaffId2]        
      ,[NotifyStaffId3]        
      ,[NotifyStaffId4]        
      ,[NotificationMessage]        
      ,[NotificationSent]            
 ,'''' as CreatedBy,                            
 getdate() as CreatedDate,                            
 '''' as ModifiedBy,                     
 getdate() as ModifiedDate                
 from systemconfigurations s left outer join CustomScreenForServices                
 on s.Databaseversion = -1           
        
SELECT TOP 1 ''MentalStatus'' AS TableName,          
      -1 as ''DocumentVersionId''         
      ,[UnableToAssess]          
      ,[AppearanceDressed]          
      ,[AppearanceAge]          
      ,[AppearanceAverageWeight]          
      ,[AppearanceAverageHeight]          
      ,[AppearanceGroomed]          
      ,[AppearanceHygiene]          
      ,[ApprearanceOther]          
      ,[AppearanceOtherText]          
      ,[BehaviorGait]          
      ,[BehaviorEyeContact]          
      ,[BehaviorTics]          
      ,[BehaviorTremors]          
      ,[BehaviorTwitches]          
      ,[BehaviorAgitated]          
      ,[BehaviorActivity]          
      ,[BehaviorLethargic]          
      ,[BehaviorAggressive]          
      ,[BehaviorNormalActivity]          
      ,[BehaviorOther]          
      ,[BehaviorOtherText]          
      ,[AttitudeCooperative]          
      ,[AttitudeDefensive]          
      ,[AttitudeReserved]          
      ,[AttitudeMistrustful]          
      ,[AttitudeOther]          
      ,[AttitudeOtherText]          
      ,[AffectBlunted]          
      ,[AffectCongruent]          
      ,[AffectUnremarkable]          
      ,[AffectUnableToAssess]          
      ,[AffectFlat]          
      ,[AffectRestricted]          
      ,[AffectExpansive]          
      ,[AffectAngry]          
      ,[AffectSad]          
      ,[AffectIrritable]          
      ,[AffectFearful]          
      ,[AffectMood]          
      ,[AffectOther]          
      ,[AffectOtherText]          
      ,[SpeechCoherent]          
      ,[SpeechSpeed]          
      ,[SpeechVerbal]          
      ,[SpeechClear]          
      ,[SpeechVolume]          
      ,[SpeechPressured]          
      ,[SpeechRepetitive]          
      ,[SpeechSpontaneous]          
      ,[SpeechSlurred]          
      ,[SpeechMonotonous]          
      ,[SpeechTalkative]          
      ,[SpeechEcholalia]          
      ,[SpeechOther]          
      ,[SpeechOtherText]          
      ,[ThoughtLucid]          
      ,[ThoughtParanoid]          
      ,[ThoughtDelusional]          
      ,[ThoughtTangential]          
      ,[ThoughtLoose]          
      ,[ThoughtPsychosis]          
      ,[ThoughtImpoverished]          
      ,[ThoughtConfused]          
      ,[ThoughtObsessive]          
      ,[ThoughtObsessiveText]          
      ,[ThoughtProcessingOther]          
      ,[MoodNeutral]          
      ,[MoodFriendly]          
      ,[MoodLabile]          
      ,[MoodAnxious]          
      ,[MoodGuilty]          
      ,[MoodIrritable]          
      ,[MoodFearful]          
      ,[MoodSad]          
      ,[MoodTearful]          
      ,[MoodAppropriate]          
      ,[MoodIncongruent]          
      ,[MoodOtherMoods]          
      ,[MoodOtherMoodsText]          
     ,[CognitionNormal]          
      ,[CognitionLimited]          
      ,[CognitionPhobias]          
      ,[CognitionObsessions]          
      ,[CognitionPreoccupation]          
      ,[CognitionOther]          
      ,[CognitionOtherText]          
      ,[AttentionAppropriate]          
      ,[AttentionGood]          
      ,[AttentionImpaired]          
      ,[AttentionOther]          
      ,[AttentionOtherText]          
      ,[LevelAlert]          
      ,[LevelSedate]          
      ,[LevelLethargic]          
      ,[LevelObtuned]          
      ,[LevelOther]          
      ,[LevelOtherText]          
      ,[PerceptualNo]          
      ,[PerceptualDelusions]          
      ,[PerceptualAuditory]          
      ,[PerceptualVisual]          
      ,[PerceptualOlfactory]          
      ,[PerceptualTactile]          
      ,[PerceptualDepersonalization]          
      ,[PerceptualIdeas]          
      ,[PerceptualParanoia]          
      ,[PerceptualOther]          
      ,[PerceptualOtherText]          
      ,[MemoryIntact]          
      ,[MemoryShortTerm]          
      ,[MemoryLongTerm]          
      ,[MemoryOther]          
      ,[MemoryOtherText]          
      ,[JudgementAware]          
      ,[JudgementUnderstandsOutcomes]          
      ,[JudgementUnderstandsNeed]          
      ,[JudgementRiskyBehavior]          
      ,[JudgementIntact]          
      ,[JudgementImpaired]          
      ,[JudgementImpairedText]          
      ,[JudgementOther]          
      ,[JudgementOtherText]          
      ,[OtherPx]          
      ,[OtherNotMedication]          
      ,[OtherEating]          
      ,[OtherEatingText]          
      ,[OtherSleep]          
      ,[OtherSleepText]          
      ,[OrientationPerson]          
      ,[OrientationPlace]          
      ,[OrientationTime]          
      ,[OrientationCircumstance]          
     ,[OrientationText]          
      ,[DisturbanceNoneNoted]          
      ,[DisturbanceDelusions]          
      ,[DisturbanceAuditory]          
      ,[DisturbanceVisual]          
      ,[DisturbanceOlfactory]          
      ,[DisturbanceTactile]          
      ,[DisturbanceDepersonalization]          
      ,[DisturbanceDerealization]          
      ,[DisturbanceIdeas]          
      ,[DisturbanceParanoia]          
      ,[DisturbanceOther]          
      ,[DisturbanceOtherText]          
      ,[RiskSuicideNotPresent]          
      ,[RiskSuicideIdeation]          
      ,[RiskSuicideActive]          
      ,[RiskSuicidePassive]          
      ,[RiskSuicideMeans]          
      ,[RiskSuicidePlan]          
      ,[RiskSuicideAttempt]          
      ,[RiskSuicideTxPlan]          
      ,[RiskHomicideNotPresent]          
      ,[RiskHomicideIdeation]          
      ,[RiskHomicideActive]          
      ,[RiskHomicidePassive]          
      ,[RiskHomicideMeans]          
      ,[RiskHomicidePlan]          
      ,[RiskHomicideAttempt]          
      ,[RiskHomicideTxPlan]          
      ,[RiskOther]          
      ,[RiskIntervention]          
      ,[ThoughtGrandiose]          
      ,[ThoughtFlightOfIdeas]          
      ,[ThoughtDisorganized]          
      ,[ThoughtBizarre]          
      ,[BehaviorCompulsive]          
      ,[BehaviorPeculiar]          
      ,[BehaviorManipulative]               
   ,'''' as CreatedBy,                                      
   getdate() as CreatedDate,                                      
   '''' as ModifiedBy,                                      
   getdate() as ModifiedDate                                        
 from systemconfigurations s left outer join MentalStatus M                       
 on s.Databaseversion = -1               
                                
--Select TOP 1 ''CustomSubstanceUseHistory'' AS TableName,        
---1 as [SubstanceUseHistoryId],        
---1 as ''DocumentVersionId'',          
--''Y'' as Preferred,                                
--'''' as CreatedBy,                            
--getdate() as CreatedDate,                            
--'''' as ModifiedBy,                            
--getdate() as ModifiedDate                              
--from systemconfigurations s left outer join CustomSubstanceUseHistory                
--on s.Databaseversion = -1         
        
Select Top 1 ''CustomSubstanceUseAssessments'' AS TableName,        
       -1 as ''DocumentVersionId''        
      ,[VoluntaryAbstinenceTrial]        
      ,[Comment]        
      ,[HistoryOrCurrentDUI]        
      ,[NumberOfTimesDUI]        
      ,[HistoryOrCurrentDWI]       
      ,[NumberOfTimesDWI]        
      ,[HistoryOrCurrentMIP]        
      ,[NumberOfTimeMIP]        
      ,[HistoryOrCurrentBlackOuts]        
      ,[NumberOfTimesBlackOut]        
      ,[HistoryOrCurrentDomesticAbuse]        
      ,[NumberOfTimesDomesticAbuse]        
      ,[LossOfControl]        
      ,[IncreasedTolerance]        
      ,[OtherConsequence]        
      ,[OtherConsequenceDescription]        
      ,[RiskOfRelapse]        
      ,[PreviousTreatment]        
      ,[CurrentSubstanceAbuseTreatment]        
      ,[CurrentTreatmentProvider]        
      ,[CurrentSubstanceAbuseReferralToSAorTx]        
      ,[CurrentSubstanceAbuseRefferedReason]        
      ,[ToxicologyResults]        
       ,SubstanceAbuseAdmittedOrSuspected
      ,[ClientSAHistory]        
      ,[FamilySAHistory]        
      ,[NoSubstanceAbuseSuspected]        
       ,DUI30Days
       ,DUI5Years
       ,DWI30Days
       ,DWI5Years
       ,Possession30Days
       ,Possession5Years
      ,[CurrentSubstanceAbuse]        
      ,[SuspectedSubstanceAbuse]        
      ,[SubstanceAbuseDetail]        
      ,[SubstanceAbuseTxPlan]        
      ,[OdorOfSubstance]        
      ,[SlurredSpeech]        
      ,[WithdrawalSymptoms]        
      ,[DTOther]        
     ,[DTOtherText]        
      ,[Blackouts]        
      ,[RelatedArrests]        
      ,[RelatedSocialProblems]        
      ,[FrequentJobSchoolAbsence]        
      ,[NoneSynptomsReportedOrObserved]        
      ,[RowIdentifier],        
 '''' as CreatedBy,                            
 getdate() as CreatedDate,                            
 '''' as ModifiedBy,                            
 getdate() as ModifiedDate                              
 from systemconfigurations s left outer join CustomSubstanceUseAssessments                
 on s.Databaseversion = -1         
                      
SELECT TOP 1 ''DiagnosesIII'' AS TableName,DocumentVersionId,Specification                                                 
,DiagnosesIII.CreatedBy,DiagnosesIII.CreatedDate                                                
,DiagnosesIII.ModifiedBy,DiagnosesIII.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                                   
FROM systemconfigurations s left outer join DiagnosesIII                                                                                
on s.Databaseversion=-1                      
                            
----For DiagnosesIV--                                                  
SELECT TOP 1 ''DiagnosesIV'' AS TableName,DocumentVersionId,PrimarySupport,SocialEnvironment,Educational                                                  
,Occupational,Housing,Economic,HealthcareServices,Legal,Other,Specification,DiagnosesIV.CreatedBy                                                  
,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy                                                
,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy                                                   
FROM systemconfigurations s left outer join DiagnosesIV                                                                                
on s.Databaseversion=-1                   
                                     
-----For DiagnosesV---                                                  
SELECT TOP 1 ''DiagnosesV'' AS TableName,DocumentVersionId,AxisV                                                
,DiagnosesV.CreatedBy,DiagnosesV.CreatedDate                                                
,DiagnosesV.ModifiedBy                                                  
,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                     
FROM systemconfigurations s left outer join DiagnosesV                                                                                
on s.Databaseversion=-1         
              
END             
end try                                                          
                                                                                                   
BEGIN CATCH              
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomScreenForServicesStandardInitialization'')                                                                                         
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
