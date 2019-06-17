IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetQIReporting]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetQIReporting]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetQIReporting] @ClientID AS BIGINT
	/*********************************************************************                                                                                          
-- Stored Procedure: dbo.ssp_SCGetClientInformation                                                                                                                             
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                           
-- Creation Date:    7/24/05                                                                                          
--                                                                                           
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                                                                                          
--                                                                                          
-- Updates:                                                                                          
--   Date       Author        Purpose                                                                                          
--  04.02.2008  SFarber       Modified to use DocumentTypeId when selecting from CustomFieldsData                                                                                          
--  04.02.2008  Ryan Noble    Added RecordDeleted check on CustomFieldsData                                                                                          
--  04.18.2008  Priya         Modified the query for client adderesses                                                                                        
--  03.06.2008  Sony John     Added RequestingAgencyName in select                                                                                       
--  07.17.2009  Sahil Bhagat  Removed SubstanceUseDisorderStatus field and add IndividualNotEnrolledOrEligible, ProgramOrPlanNotListed.                      
--  05.17.2010  Mahesh Sharma Added case statement on selection of ClientContacts.Guardian                      
--  11.15.2010  SFarber       Replaced logic for ClientCoverageReports.                      
--  04.01.2011 Maninder   Modified Query for CustomStateReporting to include additional columns                     
--  29.09.2011 Priyanka   commented two  columns   [CE.RowIdentifier], [CE.ExternalReferenceId] of  ClientEpisodes tables                  
--  15-12-2011 Rakesh     Add Parameter ClientId in when call sp csp_ClientInformationQIProgramPlan (Merged for threshold thread from 3.x thread - By Shifali)        
--  20-12-2011 Mamta Gupta  Ref Task 493 -Column added To bind Short SSN No. in Grid  (Merged for threshold thread from 3.x thread - By Shifali)  
-- 13-01-2012 Ponnin Selvan Added @ClientId as the parameter for the SP csp_ClientInformationQIProgramPlan and removed the RowIdentifier and ExternalReferenceId  
-- 19-03-2012 Sourabh  Added ClientCMHSPPIHPServices column with ref to task#564 (Merged for threshold thread from 3.x thread - By Shifali)  
--28-03-2012 Rakesh-II    missing columns are added to table named ClientEpisode Done to resolve concurrency. By Rakesh-II Task 623  (Merged for threshold thread from 3.x thread - By Shifali)  
-- 27-03-2012 TRemisoski Corrected logic for determination for the Medicaid Insured Id(Merged for threshold thread from 3.x thread - By Shifali)  
--  21.12.2011 Jagdeep Hundal   commented two  columns   [RowIdentifier], [ExternalReferenceId] of  GlobalCodes tables                  
--  16.04.2012 Davinderk   Task#-2(Team Scheduling-Threshold Phase III) Add new columns into table clients [SchedulingPreferenceMonday],[SchedulingPreferenceTuesday],[SchedulingPreferenceWednesday],  
[SchedulingPreferenceThursday],[SchedulingPreferenceFriday],[GeographicLocation],[SchedulingComment]  
-- 24Apr2012 Vikas Kashyap TAsk# 14 (Release of Information Log)Added New field in List of Releases grid Remind/DaysBeforeEndDate    
-- 7July2012 Shifali   Added Columns Locked,LockedBy ,LockedDate  in table ClientInformationReleases   
/*Added by Rahul ANeja #4 Referral Summit Pointe*/  
--28 August 2012 Rahul Aneja Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data  
     -----ClientPrimaryCareReferral  
-- 04 June   Pradeep  Added new column CauseofDeath for the task #33 (Core bugs and features)  
-- 06 June   Pradeep  Added new columns FosterCareLicence,PrimaryPhysicianId for #37-Core bugs and features and #54-Philhaven development and related chages for #34.  
-- 12 Nov   Gayathri Naik  Task #1260 in Core Bugs project. Added ClientDemographicInformationDeclines Table to retrieve the data which client declined to provide.   
-- 28 Feb 2014  Md Hussain K    Added condition to check for Null value for 'Active' Column in Client Contacts wrt task #93 Core Bugs  
-- 18 Mar 2014  Manju P      Added 'Not Reportable' for ThreeHourDisposition wrt task #681 Customization Bugs  
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 

---03 Mar 2016 - Vaibhav Khare  Moving logic to SCGetQIReporting
*************************************  ********************************/
AS
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetQIReporting]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC scsp_SCGetQIReporting @ClientID
END
ELSE
BEGIN
 
                  
--ClientRaces                                              
SELECT     ClientRaceId, ClientId, RaceId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                              
FROM         ClientRaces                                              
WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                              
  RecordDeleted = 'N')                                                 
                                                            


--CustomStateReporting                                  
   SELECT     ClientId, AdoptionStudy, SSI, ParentofYoungChild, ChildFIAAbuse, ChildFIAOther, EarlyOnProgram, WrapAround, EPSDT, IndividualNotEnrolledOrEligibleForPlan,                     
                      ProgramOrPlanNotListed, HealthInformationDate,                     
                      AbilityToHear, HearingAid, AbilitytoSee, VisualAppliance, Pneumonia, Asthma, UpperRespiratory, Gastroesophageal, ChronicBowel, SeizureDisorder,                     
                      NeurologicalDisease, Diabetes, Hypertension, Obesity, DDInformationDate, CommunicationStyle, MakeSelfUnderstood, SupportWithMobility, NutritionalIntake,                     
                      SupportPersonalCare, Relationships, FamilyFriendSupportSystem, SupportForChallengingBehaviors, BehaviorPlanPresent, NumberOfAntiPsychoticMedications,                     
                      NumberOfOtherPsychotropicMedications, MajorMentalIllness,ModifiedBy,ModifiedDate,CreatedBy,CreatedDate                    
   FROM         CustomStateReporting                                              
   WHERE     (ClientId = @ClientId) AND (ISNULL(RecordDeleted, 'N') = 'N')                              
                                 
                                

  
  
  --ClientCoveragePlans                                                    
select top (1)  
        a.CoveragePlanId,  
        a.InsuredId,  
        a.ClientId,  
        a.ClientCoveragePlanId,  
        c.COBOrder  
from    ClientCoveragePlans as a  
inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId  
inner join ClientCoverageHistory as c on c.ClientCoveragePlanId = c.ClientCoveragePlanId  
where   a.ClientId = @ClientId  
        and b.MedicaidPlan = 'Y'  
        and ISNULL(a.RecordDeleted, 'N') <> 'Y'  
        and ISNULL(b.RecordDeleted, 'N') <> 'Y'  
        and ISNULL(c.RecordDeleted, 'N') <> 'Y'  
        and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0  
        and (  
             (c.EndDate is null)  
             or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)  
            )  
order by c.COBOrder    

-- CustomTimeliness                                                                            
SELECT     ClientEpisodeId, ServicePopulationMI, ServicePopulationDD, ServicePopulationSUD, ServicePopulationMIManualOverride, ServicePopulationDDManualOverride,                                               
                      ServicePopulationSUDManualOverride, ServicePopulationMIManualDetermination, ServicePopulationDDManualDetermination,                                               
                      ServicePopulationSUDManualDetermination, DiagnosticCategory, SystemDateOfInitialRequest, SystemDateOfInitialAssessment, SystemDaysRequestToAssessment,                                               
            ManualDateOfInitialRequest, ManualDateOfInitialAssessment, ManualDaysRequestToAssessment, InitialStatus, InitialReason, SystemDateOfTreatment,                                               
                      SystemDaysAssessmentToTreatment, SystemTreatmentServiceId, SystemInitialAssessmentServiceId, ManualDateOfTreatment, ManualDaysAssessmentToTreatment,                                              
                       OnGoingStatus, OnGoingReason, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                              
FROM         CustomTimeliness                                              
WHERE     (ClientEpisodeId IN                                              
                          (SELECT     ClientEpisodeId                                              
           FROM          ClientEpisodes                                              
                            WHERE      (ClientId = @ClientId) AND (ISNULL(RecordDeleted, 'N') = 'N'))) AND (ISNULL(RecordDeleted, 'N') = 'N')                                              
                                              

 --QIProgramPlan                                                          
  Exec csp_ClientInformationQIProgramPlan  @ClientID  
 --CustomCAFAS                                                  
 Exec csp_ClientInformationQICafas    @ClientID     
 
 -- CustomTimeliness                                                                              
SELECT     ClientEpisodeId, ServicePopulationMI, ServicePopulationDD, ServicePopulationSUD, ServicePopulationMIManualOverride, ServicePopulationDDManualOverride,                                                 
                      ServicePopulationSUDManualOverride, ServicePopulationMIManualDetermination, ServicePopulationDDManualDetermination,                                                 
                      ServicePopulationSUDManualDetermination, DiagnosticCategory, SystemDateOfInitialRequest, SystemDateOfInitialAssessment, SystemDaysRequestToAssessment,                                                 
            ManualDateOfInitialRequest, ManualDateOfInitialAssessment, ManualDaysRequestToAssessment, InitialStatus, InitialReason, SystemDateOfTreatment,                                                 
                      SystemDaysAssessmentToTreatment, SystemTreatmentServiceId, SystemInitialAssessmentServiceId, ManualDateOfTreatment, ManualDaysAssessmentToTreatment,                                                
                       OnGoingStatus, OnGoingReason, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                                
FROM         CustomTimeliness                                                
WHERE     (ClientEpisodeId IN                                                
                          (SELECT     ClientEpisodeId                                                
           FROM          ClientEpisodes                                                
                            WHERE      (ClientId = @ClientID) AND (ISNULL(RecordDeleted, 'N') = 'N'))) AND (ISNULL(RecordDeleted, 'N') = 'N')                     
   
END

IF (@@error != 0)
BEGIN
	declare @ErrorMessage nvarchar(4000);  
  declare @ErrorSeverity int;  
  declare @ErrorState int;  
  
  select  @ErrorMessage = error_message(),
          @ErrorSeverity = error_severity(),
          @ErrorState = error_state();  
  
  raiserror (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
  

	RETURN (1)
END

RETURN (0)