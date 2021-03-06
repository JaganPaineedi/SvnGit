/****** Object:  StoredProcedure [dbo].[csp_InitCustomCrisisInterventionsStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisInterventionsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCrisisInterventionsStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisInterventionsStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomCrisisInterventionsStandardInitialization]              
(                            
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml      
)                                                    
As                                                      
 /*********************************************************************/                                                                    
 /* Stored Procedure: [csp_InitCustomCrisisInterventionsStandardInitialization]               */                                                           
 /* Creation Date:  18/March/2010                                    */                                                                    
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
 /*********************************************************************/                                                                     
Begin                                                    
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

      
  
SELECT TOP 1 ''CustomCrisisInterventions'' AS TableName,  
      -1 as ''DocumentVersionId''              
      ,[DateOfCrisisIntervention]              
      ,[ScreeningComletedBy]              
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
      ,[SuicidalIdeationWithin48]              
      ,[SuicidalIdeationWithin14]              
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
      ,[Hopelessness]                  ,[MakingPreparations]              
      ,[NoAmbivalence]              
      ,[SelfHarmfulBehaviour]              
      ,[SelfHarmfulBehaviourDetail]              
      ,[OutcomeDetail]              
      ,[NumberOfHospitalizations]              
      ,[CurrentTherapist]              
   ,[ConsumerRequested]              
      ,[OtherRequested]              
      ,[Recommended]              
      ,[OtherRecommended]              
      ,[RequestNotAuthorized]              
      ,[HospitalizationStatus]              
      ,[FacilityName]              
      ,[OtherFacilityName]              
      ,[Summary]              
      ,[FacilityProviderId]              
      ,[FacilitySiteId]              
      ,[NotifyStaffId1]              
      ,[NotifyStaffId2]              
      ,[NotifyStaffId3]              
      ,[NotifyStaffId4]              
      ,[NotificationMessage]              
      ,[NotificationSent]              
      ,[Modality]              
 ,'''' as CreatedBy,                      
 getdate() as CreatedDate,                      
 '''' as ModifiedBy,                      
 getdate() as ModifiedDate                        
 from systemconfigurations s left outer join CustomCrisisInterventions          
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
  
                                     
end try                                                    
                                                                                             
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomCrisisInterventionsStandardInitialization'')                                                                                   
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
