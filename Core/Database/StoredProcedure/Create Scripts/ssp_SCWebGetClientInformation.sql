/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientInformation]    Script Date: 04/16/2012 12:02:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetClientInformation]
GO


--ssp_SCWebGetClientInformation 2110308
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientInformation]    Script Date: 04/16/2012 12:02:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



  
                      
CREATE procedure [dbo].[ssp_SCWebGetClientInformation]              
@ClientID as bigint                                                                                                                            
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
-- 19-03-2012 Sourabh		Added ClientCMHSPPIHPServices column with ref to task#564 (Merged for threshold thread from 3.x thread - By Shifali)
--28-03-2012 Rakesh-II    missing columns are added to table named ClientEpisode Done to resolve concurrency. By Rakesh-II Task 623  (Merged for threshold thread from 3.x thread - By Shifali)
-- 27-03-2012 TRemisoski	Corrected logic for determination for the Medicaid Insured Id(Merged for threshold thread from 3.x thread - By Shifali)
--  21.12.2011 Jagdeep Hundal   commented two  columns   [RowIdentifier], [ExternalReferenceId] of  GlobalCodes tables                
--  16.04.2012 Davinderk   Task#-2(Team Scheduling-Threshold Phase III) Add new columns into table clients [SchedulingPreferenceMonday],[SchedulingPreferenceTuesday],[SchedulingPreferenceWednesday],
[SchedulingPreferenceThursday],[SchedulingPreferenceFriday],[GeographicLocation],[SchedulingComment]
-- 24Apr2012	Vikas Kashyap	TAsk# 14 (Release of Information Log)Added New field in List of Releases grid Remind/DaysBeforeEndDate  
-- 7July2012	Shifali			Added Columns Locked,LockedBy ,LockedDate  in table ClientInformationReleases 
/*Added by Rahul ANeja #4 Referral Summit Pointe*/
--28 August 2012	Rahul Aneja	Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data
     -----ClientPrimaryCareReferral
-- 04 June		 Pradeep		Added new column CauseofDeath for the task #33 (Core bugs and features)
-- 06 June		 Pradeep		Added new columns FosterCareLicence,PrimaryPhysicianId for #37-Core bugs and features and #54-Philhaven development and related chages for #34.
-- 12 Nov 	 Gayathri Naik		Task #1260 in Core Bugs project. Added ClientDemographicInformationDeclines Table to retrieve the data which client declined to provide. 
-- May 27 2014	Pradeep.A		Added StaffId
-- Jun 16 2014	Pradeep.A		Renamed StaffId to UserStaffId
--July 22 2014  Shruthi.S       Added configuration based showing and hiding CM tabs and also added conditions to handle if tables doesn’t exist in 3.5x and 4.0x.Ref #49 CM to SC.
-- July 25 2014	Rohith Uppin	Custom table(CustomClientSubstanceUseHistory) change to Core table(ClientSubstanceUseHistory). - Task#49 CM to SC.
--  Aug 14 2014	Scooter		Corrected JOIN on ClientCoverageHistory and ClientCoveragePlans
-- Aug 27 2014	Rohith Uppin	Task#49 chagnes are moved to PMClient Summary and reverting Task#49 related changes from this SP

--Aug 28 2014  Veena S Mani    Added columns to the client table which is missing in the Get SP.columns are AllergiesLastReviewedBy,AllergiesLastReviewedDate,AllergiesReviewStatus,HasNoMedications columns added.Core Bugs# 1623
--Oct 30 2014	Deej			Added a new scsp_implementation for selecting CustomFieldsData KCMHSAS 3.5 Implementation #99
-- Nov 17 2014 Pradeep.A		Added ProfessionalSuffix column to Clients and ClientContacts table.
-- Nov 18 2014 Anto				Added CustomVisitors table for WoodsCustomization 801
-- Nov 1 2014	Malathi Shiva	Added scsp instead of csp
-- 16 Mar 2015	Avi Goyal		What : Added FamilyContacts
								Why : Task # 907.1 Family Tab to Client Information Screen ; Project : Valley - Customizations
-- 01 Sep 2015	Avi Goyal		What : Added checked for recode category RELATIONFAMILY to fetch records for Family Tab
								Why : Task # 907.1 Family Tab to Client Information Screen ; Project : Valley - Customizations
-- 10.19.2015      Vichee          Modified the ssp to add logic for Organization in Client Information  Network- 180 Customizations - #609
-- 10.29.2015      Vichee       Modified the ssp to add logic for OrganizationRelation GlobalCodes in ClientContacts table  Network- 180 Customizations - #609
-- 28.01.2016      Shruthi.S    Added CountyOfResidenceText and CountyOfTreatmentText.Ref : #275 EII.
-- 22-302016 Rajesh S Added GenderIdentity Enginieering initiative - 300
-- 17-May 2016 Varun Added ClientEthnicities table and SexualOrientation column to Clients.Ref: Meaningful Use Stage 3 - #4
-- 09.Jun.2016	Alok Kumar		Added column 'DoNotLeaveMessage' in ClientPhones for task#333 Engineering Improvement Initiatives- NBL(I)
-- 19.Jun.2016	Ponnin			Changed INNER join to LEFT join for ClientContacts table to show all the contacts. Why For Bradford - Environment Issues Tracking #126 
-- 01.Aug.2016	Chethan N		What : Added column 'ReferringProviderId' to table 'ClientPrimaryCareExternalReferrals'
--								Why : Engineering Improvement Initiatives- NBL(I) task# 388
-- 10 Feb 2017	Vithobha		Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830
-- 14 Aug 2017	Rahul Kulkarni	Changed Alias from Phone to PhoneNumber for EI#507
-- 30 Oct 2017	Anto		    Added SchedulingPreferenceSaturday and SchedulingPreferenceSunday columns in Clients table, Texas Customizations #124
--03 Apr 2018	Vandana			Added a new column in Clients table 'PreferredGenderPronoun'		
--04 Dec 2018	Ravichandra		What : Renamed from [ProviderName] to [ExternalReferralProviderId] in table ClientPrimaryCareExternalReferrals 
--								Why : Engineering Improvement Initiatives- NBL(I) task# 441				
		
*********************************************************************/                                                                                                                             
as                    
BEGIN
BEGIN TRY                     
--Clients                                                                                                                           
SELECT  Top 1  C.ClientId, C.ExternalClientId, C.Active, C.MRN, C.LastName, C.FirstName, C.MiddleName, C.Prefix, C.Suffix, C.SSN, SUBSTRING(C.SSN, 6, 9) AS ShortSSN, CONVERT(Varchar(5),                                       
                      DATEDIFF(YEAR, C.DOB, GETDATE()) - 1) + ' Years' AS Age, C.Sex, C.DOB, C.PrimaryClinicianId, C.CountyOfResidence, C.CountyOfTreatment, C.CorrectionStatus, C.Email, C.Comment,                                             
                      C.LivingArrangement, C.NumberOfBeds, C.MinimumWage, C.FinanciallyResponsible,C.AnnualHouseholdIncome, C.NumberOfDependents, C.MaritalStatus, C.EmploymentStatus,                                             
                      C.EmploymentInformation, C.MilitaryStatus, C.EducationalStatus, C.DoesNotSpeakEnglish, C.PrimaryLanguage, C.CurrentEpisodeNumber, C.AssignedAdminStaffId,                                             
          C.InpatientCaseManager, C.InformationComplete, C.PrimaryProgramId, C.LastNameSoundex, C.FirstNameSoundex, C.CurrentBalance, C.CareManagementId, C.HispanicOrigin,                                             
                      C.DeceasedOn, C.LastStatementDate, C.LastPaymentId, C.LastClientStatementId, C.DoNotSendStatement, C.DoNotSendStatementReason, C.AccountingNotes, C.MasterRecord,                          
                      C.ProviderPrimaryClinicianId, C.RowIdentifier, C.ExternalReferenceId, C.CreatedBy, C.DoNotOverwritePlan, C.Disposition,C.NoKnownAllergies, C.CreatedDate, C.ModifiedBy, C.ModifiedDate, C.RecordDeleted,                                             
                      C.DeletedDate, C.DeletedBy,C.ReminderPreference,C.MobilePhoneProvider,C.SchedulingPreferenceMonday,C.SchedulingPreferenceTuesday,C.SchedulingPreferenceWednesday,C.SchedulingPreferenceThursday,
                      C.SchedulingPreferenceFriday,C.GeographicLocation,C.SchedulingComment,C.CauseofDeath,C.FosterCareLicence,C.PrimaryPhysicianId,C.UserStaffId,C.AllergiesLastReviewedBy,C.AllergiesLastReviewedDate,C.AllergiesReviewStatus,C.HasNoMedications,C.ProfessionalSuffix                                          
                      -- Added By Vichee 19/10/2015
                      ,C.ClientType,C.OrganizationName,C.EIN,SUBSTRING(C.EIN, 6, 9) AS ShortEIN   -- end by Vichee
                      ,Ltrim(Rtrim(Ct.CountyName)) + ' - ' + St.StateAbbreviation as CountyOfResidenceText
                      ,Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation as CountyOfTreatmentText
                      ,C.GenderIdentity
                      ,C.SexualOrientation
                      -- 10 Feb 2017	Vithobha
						,C.InternalCollections
						,C.ExternalCollections
						,C.SchedulingPreferenceSaturday
						,C.SchedulingPreferenceSunday
						,C.PreferredGenderPronoun
FROM         Clients C      
left join Counties Ct on Ct.CountyFIPS = C.CountyOfResidence 
left join Counties CF on CF.CountyFIPS = C.CountyOfTreatment  
left join States St on St.StateFIPs = Ct.StateFIPs
left join States Ss on Ss.StateFIPs = CF.StateFIPs                              
WHERE     (ClientId = @ClientID) AND (C.RecordDeleted IS NULL OR                                            
             RecordDeleted = 'N')                                            
--ClientEpisodes                                                                                                                                 
SELECT     0 AS DeleteButton, CE.ClientEpisodeId, CE.ClientId, CE.EpisodeNumber, CE.RegistrationDate, CE.Status, CE.DischargeDate, CE.InitialRequestDate, CE.IntakeStaff,                                               
                      CE.AssessmentDate, CE.AssessmentFirstOffered, CE.AssessmentDeclinedReason, CE.TxStartDate, CE.TxStartFirstOffered, CE.TxStartDeclinedReason,                                               
                      CE.RegistrationComment, CE.ReferralSource, CE.ReferralType, CE.ReferralComment, CE.HasAlternateTreatmentOrder, CE.AlternateTreatmentOrderType,                                               
                      CE.AlternateTreatmentOrderExpirationDate
                      --Added BY Rakesh-II Task 623            
				   ,CE.ReferralDate
				  ,CE.ReferralSubtype
				  ,CE.ReferralName
				  ,CE.ReferralAdditionalInformation
				  ,CE.ReferralReason1
				  ,CE.ReferralReason2
				  ,CE.ReferralReason3
				  ,CE.ExternalReferralInformation
					--ends here,
                      
                      -----commented by priyanka
                      -- CE.RowIdentifier, CE.ExternalReferenceId,
                        ,CE.CreatedBy, CE.CreatedDate, CE.ModifiedBy, CE.ModifiedDate,                                               
                      CE.RecordDeleted, CE.DeletedDate, CE.DeletedBy, GC.CodeName                                              
FROM         ClientEpisodes AS CE INNER JOIN                                              
                      Clients ON CE.ClientId = Clients.ClientId AND CE.EpisodeNumber = Clients.CurrentEpisodeNumber LEFT OUTER JOIN                                              
                      GlobalCodes AS GC ON CE.Status = GC.GlobalCodeId                                              
WHERE     (CE.ClientId = @ClientID) AND (CE.RecordDeleted IS NULL OR                                              
                      CE.RecordDeleted = 'N')                                              
                                              
                                                                     
--ClientPhones                                                                                                                         
SELECT     ClientPhones.ClientPhoneId, ClientPhones.ClientId, ClientPhones.PhoneType, ClientPhones.PhoneNumber, ClientPhones.PhoneNumberText, ClientPhones.IsPrimary,                                             
                      ClientPhones.DoNotContact, ClientPhones.RowIdentifier, ClientPhones.ExternalReferenceId, ClientPhones.CreatedBy, ClientPhones.CreatedDate,                                             
                      ClientPhones.ModifiedBy, ClientPhones.ModifiedDate, ClientPhones.RecordDeleted, ClientPhones.DeletedDate, ClientPhones.DeletedBy,                                             
                      GlobalCodes.SortOrder ,ClientPhones.DoNotLeaveMessage   -- 09.Jun.2016	Alok Kumar                                         
FROM         ClientPhones INNER JOIN                                            
                      GlobalCodes ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId                                            
WHERE     (ClientPhones.ClientId = @ClientID) AND (ISNULL(ClientPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted,                                             
                      'N') = 'N')                                                                                             
                                            
--ClientAddresses                         
SELECT     ClientAddresses.ClientAddressId, ClientAddresses.ClientId, ClientAddresses.AddressType, ClientAddresses.Address, ClientAddresses.City, ClientAddresses.State,                                             
               ClientAddresses.Zip, ClientAddresses.Display, ClientAddresses.Billing, ClientAddresses.RowIdentifier, ClientAddresses.ExternalReferenceId,                                             
                      ClientAddresses.CreatedBy, ClientAddresses.CreatedDate, ClientAddresses.ModifiedBy, ClientAddresses.ModifiedDate, ClientAddresses.RecordDeleted,                                        
      ClientAddresses.DeletedDate, ClientAddresses.DeletedBy, GlobalCodes.SortOrder                                            
FROM         ClientAddresses INNER JOIN                                           
                    GlobalCodes ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId                                            
WHERE  (ClientAddresses.ClientId = @ClientID) AND (ISNULL(ClientAddresses.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND                                             
                      (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                        
                                                                     
--ClientContacts                                                                                                                        
-- Select query added on 18th April '08 (originally modified by Priya on 2nd April '08) - the order is changed and the field Sex has been renamed from SEX to Sex                                                                              
--(because in the  dataset there were two fields with name Sex)                                                                                              
SELECT     'D' AS 'DeleteButton', 'N' AS 'RadioButton', ClientContacts.ClientContactId, ClientContacts.ClientId,                                             
                      ClientContacts.LastName + ', ' + ClientContacts.FirstName AS Contact, GlobalCodes.CodeName, GlobalCodes.CodeName AS RelationshipText,                                            
                          (SELECT     TOP (1) PhoneNumber                                            
                            FROM          ClientContactPhones                                            
                            WHERE      (ClientContactId = ClientContacts.ClientContactId) AND (PhoneNumber IS NOT NULL) AND (ISNULL(RecordDeleted, 'N') = 'N')                                            
                            ORDER BY PhoneType) AS PhoneNumber,  -- 14 Aug 2017	Rahul Kulkarni
                             ClientContacts.Organization, ClientContacts.SSN,
                            --Column added by Mamta Gupta- Ref Task 493 - To bind Short SSN No. in Grid   
                            SUBSTRING(ClientContacts.SSN, 6, 9) AS ShortSSN
                            , ClientContacts.Sex,                                       
                            ClientContacts.Guardian,                                       
                             CASE WHEN ClientContacts.Guardian ='N' THEN 'No' WHEN  ClientContacts.Guardian = 'Y' THEN 'Yes' END  AS [GuardianText],                                           
                      ClientContacts.EmergencyContact, ClientContacts.FinanciallyResponsible, ClientContacts.DOB, ClientContacts.ListAs, ClientContacts.Email,                                            
                          (SELECT     TOP (1) Address                                            
                            FROM          ClientContactAddresses                                            
                            WHERE      (ClientContactId = ClientContacts.ClientContactId) AND (Address IS NOT NULL)                                            
                            ORDER BY AddressType) AS Address, ClientContacts.Comment, ClientContacts.Relationship, ClientContacts.FirstName, ClientContacts.LastName,                                             
                      ClientContacts.MiddleName, ClientContacts.Prefix, ClientContacts.Suffix,   
                      --ClientContacts.RowIdentifier, ClientContacts.ExternalReferenceId,  
                      ClientContacts.CreatedBy,                                             
                      ClientContacts.CreatedDate, ClientContacts.ModifiedBy, ClientContacts.ModifiedDate, ClientContacts.RecordDeleted, ClientContacts.DeletedDate,                                             
                      ClientContacts.DeletedBy,LastNameSoundex,FirstNameSoundex,
                      ClientContacts.HouseholdMember,
                      ClientContacts.Active,
					  ClientContacts.CareTeamMember,
	        ClientContacts.MailingName,
	        ClientContacts.AssociatedClientId,
        CASE 
		WHEN ClientContacts.CareTeamMember = 'N'
			THEN 'No'
		WHEN ClientContacts.CareTeamMember = 'Y'
			THEN 'Yes'
		END AS [CareTeamMemberText],
                      CASE WHEN ClientContacts.EmergencyContact ='N' THEN 'No' WHEN  ClientContacts.EmergencyContact = 'Y' THEN 'Yes' END  AS [EmergencyText],
                      CASE WHEN ClientContacts.FinanciallyResponsible ='N' THEN 'No' WHEN  ClientContacts.FinanciallyResponsible = 'Y' THEN 'Yes' END  AS [FinResponsibleText],
                      CASE WHEN ClientContacts.HouseholdMember ='N' THEN 'No' WHEN  ClientContacts.HouseholdMember = 'Y' THEN 'Yes' END  AS [HouseholdNumberText],                               
                      CASE WHEN ClientContacts.Active ='N' THEN 'No' WHEN  ClientContacts.Active = 'Y' THEN 'Yes' END  AS [ActiveText]
                      ,ProfessionalSuffix
FROM         ClientContacts LEFT JOIN                                            
                      GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y' AND                                             
                        ((GlobalCodes.Category = 'RELATIONSHIP')  OR (GlobalCodes.Category = 'OrganizationRelation')) --Added by Vichee10292015
WHERE     (ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y') AND (ClientContacts.ClientId = @ClientID)                                             
                                                         
--clientcontactphones                                                                                                                         
SELECT     ClientContactPhones.ContactPhoneId, ClientContactPhones.ClientContactId, ClientContactPhones.PhoneType, ClientContactPhones.PhoneNumber,                                             
                      ClientContactPhones.PhoneNumberText, ClientContactPhones.RowIdentifier, ClientContactPhones.ExternalReferenceId, ClientContactPhones.CreatedBy,                                             
                      ClientContactPhones.CreatedDate, ClientContactPhones.ModifiedBy, ClientContactPhones.ModifiedDate, ClientContactPhones.RecordDeleted,                                             
                      ClientContactPhones.DeletedDate, ClientContactPhones.DeletedBy, GlobalCodes.SortOrder                                            
FROM         ClientContactPhones INNER JOIN                                            
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactPhones.ClientContactId AND ClientContacts.ClientId = @ClientID AND                                             
                      ISNULL(ClientContacts.RecordDeleted, 'N') = 'N' INNER JOIN                                            
                      GlobalCodes ON ClientContactPhones.PhoneType = GlobalCodes.GlobalCodeId                                            
WHERE     (ISNULL(ClientContactPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                                             
                                                                                                                        
--ClientContactaddresses                                                                                                                
SELECT     ClientContactAddresses.ContactAddressId, ClientContactAddresses.ClientContactId, ClientContactAddresses.AddressType, ClientContactAddresses.Address,                                             
                      ClientContactAddresses.City, ClientContactAddresses.State, ClientContactAddresses.Zip, ClientContactAddresses.Display, ClientContactAddresses.Mailing,                                             
         ClientContactAddresses.RowIdentifier, ClientContactAddresses.ExternalReferenceId, ClientContactAddresses.CreatedBy, ClientContactAddresses.CreatedDate,                                             
                      ClientContactAddresses.ModifiedBy, ClientContactAddresses.ModifiedDate, ClientContactAddresses.RecordDeleted, ClientContactAddresses.DeletedDate,                                             
                      ClientContactAddresses.DeletedBy, GlobalCodes.SortOrder                                            
FROM         ClientContactAddresses INNER JOIN                                            
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactAddresses.ClientContactId AND ClientContacts.ClientId = @ClientID AND                                             
                      ISNULL(ClientContacts.RecordDeleted, 'N') = 'N' INNER JOIN                                            
                      GlobalCodes ON ClientContactAddresses.AddressType = GlobalCodes.GlobalCodeId                                            
WHERE     (ISNULL(ClientContactAddresses.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                                            
                                            
                                            
-- ClientHospitalizations                  
SELECT  HospitalizationId, ClientId, PreScreenDate, ThreeHourDisposition,                                
case ThreeHourDisposition when 'N' then 'No' when 'Y' then 'Yes' else '' end as ThreeHourDispositionText ,                   
PerformedBy,Hospitalized, case Hospitalized when 'N' then 'No' when 'Y' then 'Yes' else '' end as HospitalizedText,                                 
Hospital,HospitalText, AdmitDate, DischargeDate, SystemSevenDayFollowUp,                                 
case SystemSevenDayFollowUp when 'N' then 'No' when 'Y' then 'Yes' else '' end as SystemSevenDayFollowUpText,                                
SevenDayFollowUp,                                        
case SevenDayFollowUp when 'N' then 'No' when 'Y' then 'Yes' else '' end as SevenDayFollowUpText,DxCriteriaMet,                                
case DxCriteriaMet when 'N' then 'No' when 'Y' then 'Yes' else '' end as DxCriteriaMetText,CancellationOrNoShow,                                
case CancellationOrNoShow when 'N' then 'No' when 'Y' then 'Yes' else '' end as CancellationOrNoShowText,                  
ClientRefusedService, FollowUpException, FollowUpExceptionReason, Comment, ClientWasTransferred,                                
case ClientWasTransferred when 'N' then 'No' when 'Y' then 'Yes' else '' end as ClientWasTransferredText,                       
DeclinedServicesReason, RowIdentifier, ExternalReferenceId, CreatedBy, CreatedDate, ModifiedBy,ClientCMHSPPIHPServices,                                 
ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
FROM ClientHospitalizations LEFT OUTER JOIN                                            
(select s.SiteId, case when isnull(s.SiteName,'')='' then  rtrim(p.ProviderName)                                                
else rtrim(p.ProviderName) + ' - ' + ltrim(s.SiteName)                                               
end  as HospitalText                                            
from Providers p                                               
left outer  join Sites s on p.ProviderID = s.ProviderID and isnull(s.RecordDeleted,'N')='N' ) AS Hospital                                            
ON ClientHospitalizations.Hospital=Hospital.SiteId                                            
WHERE (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
 RecordDeleted = 'N')                                 
                                
                                     
--ClientCoverageReports                                            
select cch.ClientCoverageHistoryId as ClientCoverageId,                     
       cch.StartDate,                     
       cch.EndDate,                    
       cp.CoveragePlanName,                    
       ccp.InsuredId,                     
       ccp.GroupNumber,                     
       '' as AuthorizationRequired,                     
       ccp.PlanContactPhone as ContactPhone,                     
       ccp.ClientId,                     
       cch.COBOrder as Priority,                    
       cp.MedicaidPlan as Medicaid,                    
       cch.CreatedBy,                                             
       cch.CreatedDate,                     
       cch.ModifiedBy,                     
       cch.ModifiedDate,               
       cch.RecordDeleted,                     
       cch.DeletedDate,                     
       cch.DeletedBy                                            
  from ClientcoveragePlans as ccp                      
       join CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId                      
       join ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId                      
 where ccp.ClientId = @ClientId                      
   and datediff(day, cch.StartDate, getdate()) >= 0                      
   and (cch.EndDate is null or datediff(day, cch.EndDate, getdate()) <= 0)                      
   and isnull(ccp.RecordDeleted, 'N') = 'N'                                              
   and isnull(cch.RecordDeleted, 'N') = 'N'                      
 order by cch.StartDate desc, Priority                                             
                                            
                                            
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
                                            
                                            
--GlobalCodes                   
SELECT     GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder, ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2,                                             
                      Bitmap, BitmapImage, Color, 
                      --RowIdentifier, ExternalReferenceId, 
                      CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy, RecordDeleted, DeletedDate                                            
FROM         GlobalCodes                                            
WHERE     (1 = 2)                                            
                                            
                                            
--Staff                                            
SELECT     StaffId, UserCode, LastName, FirstName, MiddleName, Active, SSN, Sex, DOB, EmploymentStart, EmploymentEnd, LicenseNumber, TaxonomyCode, Degree,                                             
           SigningSuffix, CoSignerId, CosignRequired, Clinician, Attending, ProgramManager, IntakeStaff, AppointmentSearch, CoSigner, AdminStaff, Prescriber,      
                      LastSynchronizedId, UserPassword, AllowedPrinting, Email, PhoneNumber, OfficePhone1, OfficePhone2, CellPhone, HomePhone, PagerNumber, Address, City, State,                                             
                      Zip, AddressDisplay, InLineSpellCheck, DisplayPrimaryClients, FontName, FontSize, SynchronizationOnStart, SynchronizationOnClose, EncryptionSwitch,                                             
                  PrimaryRoleId, PrimaryProgramId, LastVisit, PasswordExpires, PasswordExpiresNextLogin, PasswordExpirationDate, SendConnectionInformation,                                             
                      PasswordSendMethod, PasswordCallPhoneNumber, AccessCareManagement, AccessSmartCare, AccessPracticeManagement, Administrator, CanViewStaffProductivity,                                    
                       CanCreateManageStaff, Comment, ProductivityDashboardUnit, ProductivityComment, TargetsComment, HomePage, DefaultReceptionViewId,                                             
                      DefaultCalenderViewType, DefaultCalendarStaffId, DefaultMultiStaffViewId, DefaultProgramViewId, DefaultCalendarIncrement, UsePrimaryProgramForCaseload,                                             
                      EHRUser, DefaultReceptionStatus, NationalProviderId, ClientPagePreferences, RetainMessagesDays, MedicationDaysDefault, ViewDocumentsBanner,                                             
                      ExternalReferenceId, DEANumber, Supervisor, DefaultPrescribingLocation, DefaultImageServerId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,                                   
                      RecordDeleted, DeletedDate, DeletedBy,AllInsurers,PrimaryInsurerId,AllProviders,PrimaryProviderId                                           
FROM         Staff                                            
WHERE     (1 = 2)                                            
                                            
                                            
--Counties                                            
Select [CountyFIPS]                                                                                    
      ,[CountyName]                                                                                    
      ,[StateFIPS]                                        
      ,[RowIdentifier] from  Counties where 1=2                                                
                                             
--States                                                                                                                  
SELECT  StateFIPS, StateAbbreviation, StateName, RowIdentifier                                            
FROM         States                                            
WHERE     (1 = 2)                                            
                                            
--ClientFinancialSummaryReports                                                                       
SELECT     ClientId, CoverageBalanceCurrent, CoverageBalance30, CoverageBalance90, CoverageBalance180, CoverageBalanceTotal, ClientBalanceCurrent, ClientBalance30,                                             
                      ClientBalance90, ClientBalance180, ClientBalanceTotal, ClientLastPaymentAmount, ClientLastPaymentDate, FeeArrangement, Comment, CreatedBy, CreatedDate,                                             
                      ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                           
FROM         ClientFinancialSummaryReports                                            
WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
                      RecordDeleted = 'N')                                            
                                                                  
                                                                  
--SystemConfigurations                                            
SELECT     OrganizationName, ClientBannerDocument1, ClientBannerDocument2, ClientBannerDocument3, ClientBannerDocument4, ClientBannerDocument5,                                             
                      ClientBannerDocument6, StateFIPS, LastUserName, FiscalMonth, DatabaseVersion, CustomDatabaseVersion, SmartCareVersionMinimum,                                             
                      SmartCareVersionMaximum, PracticeManagementVersionMinimum, PracticeManagementVersionMaximum, CareManagementVersionMinimum,                           
                      CareManagementVersionMaximum, ProviderAccessVersionMinimum, ProviderAccessVersionMaximum, CareManagementServer, CareManagementDatabase,                                             
                      AutoCreateDiagnosisFromAssessment, CareManagementInsurerId, IntializeAssessmentDiagnosis, CareManagementInsurerName, CareManagementComment,                                             
       ClientStatementSort1, ClientStatementSort2, SCDefaultDoNotComplete, PMDefaultDoNotComplete, MedicationDaysDefault, MedicationDatabaseVersion,                                             
                      RecurringAppointmentsExpandedFromDays, RecurringAppointmentsExpandedToDays, RecurringAppointmentsExpandedFrom, RecurringAppointmentsExpandedTo,                                             
   ProgramsBannerText, ShowGroupsBanner, ShowBedCensusBanner, FilterTPAuthorizationCodesByAssigned, ShowTPProceduresViewMode, DisableNoShowNotes,                                             
                      DisableCancelNotes, CredentialingExpirationMonths, CredentialingApproachingExpirationDays, ImageDatabaseConfigurationName,                                             
                      MedicationPatientOverviewTemplate, ScannedMedicalRecordAuthorId, AssessmentBannerId, TreatmentPlanBannerId, PeriodicReviewBannerId,                                             
                      GeneralDocumentsBannerId, DiagnosisBannerId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate                                            
FROM         SystemConfigurations                                            
WHERE     (1 = 2)                                          
                                            
--Providers                                            
SELECT     ProviderId, ProviderType, Active, NonNetwork, DataEntryComplete, ProviderName, FirstName, ExternalId, Website, Comment, PrimarySiteId, PrimaryContactId,                                             
                      ContractingContactId, ApplyTaxIDToAllSites, ProviderIdAppliesToAllSites, POSAppliesToAllSites, TaxonomyAppliesToAllSites, NPIAppliesToAllSites,                                             
                      DataEntryCompleteForAuthorization, UsesProviderAccess, SubstanceUseProvider, AccessAgency, CredentialApproachingExpiration, RowIdentifier, CreatedBy,                             
                      CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
FROM         Providers                                            
WHERE     (1 = 2)                                            
                                            
--ClientRaces                                            
SELECT     ClientRaceId, ClientId, RaceId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
FROM         ClientRaces                                            
WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
  RecordDeleted = 'N')                                               
                     
--ClientInformationReleases                                            
Select   Case                                                                    
   When (SELECT     COUNT(*)                                    
  FROM         ClientInformationReleaseDocuments INNER JOIN                                  
                      ClientInformationReleases AS CIR ON ClientInformationReleaseDocuments.ClientInformationReleaseId = CIR.ClientInformationReleaseId                                  
  WHERE     (CIR.ClientInformationReleaseId = CIR.ClientInformationReleaseId)                                   
  AND (ISNULL(ClientInformationReleaseDocuments.RecordDeleted, 'N') = 'N') ) > 1 Then 'Multiple Documents'                                                                  
  Else ( select DocumentCodes.DocumentName from DocumentCodes inner join Documents on Documents.DocumentCodeId=DocumentCodes.DocumentCodeId                                                                  
  inner join ClientInformationReleaseDocuments on Documents.DocumentId= ClientInformationReleaseDocuments.DocumentId                                                                  
  inner join ClientInformationReleases as CIR on ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId= CIR.ClientInformationReleaseId                                                                  
  where ClientInformationReleaseDocuments.ClientInformationReleaseId=ClientInformationReleases.ClientInformationReleaseId and ISNULL(ClientInformationReleaseDocuments.RecordDeleted,'N')='N' )                                                               
  
   
                                                                         
  ENd as 'ReleaseDocuments'                  
    ,ClientInformationReleases.[ClientInformationReleaseId]                                                                        ,ClientInformationReleases.[ClientId]                                                                                       
  
   
    ,ClientInformationReleases.[ReleaseToId]                                                                                          
    ,ClientInformationReleases.[ReleaseToName]                                                      
    ,case when ClientInformationReleases.[StartDate] IS Not NULL then convert(varchar,ClientInformationReleases.[StartDate],101)                                                                               
            end AS [StartDate]                                                      
    ,case when ClientInformationReleases.[EndDate] IS Not NULL then convert(varchar,ClientInformationReleases.[EndDate],101)                                                                                
            end AS [EndDate]                                                                              
    ,ClientInformationReleases.[Comment]                                   
    ,ClientInformationReleases.[DocumentAttached]                                                                                          
    ,ClientInformationReleases.[RowIdentifier]                                                                                          
    ,ClientInformationReleases.[CreatedBy]                                                                           
    ,ClientInformationReleases.[CreatedDate]                                                                                          
    ,ClientInformationReleases.[ModifiedBy]                                                  
    ,ClientInformationReleases.[ModifiedDate]                                                                                          
    ,ClientInformationReleases.[RecordDeleted]                                                                                          
    ,ClientInformationReleases.[DeletedDate]                                                                                
   ,ClientInformationReleases.[DeletedBy]    
    ,Remind
    ,DaysBeforeEndDate                                                     
    ,Locked
    ,LockedBy  
    ,LockedDate 
    from ClientInformationReleases                                             
      Where isNull(ClientInformationReleases.RecordDeleted,'N')<>'Y' and ClientInformationReleases.ClientId=@ClientId                                     
                                          
                                          
--ClientInformationReleaseDocuments                                             
select                                                                          
 ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId                                                                        
,ClientInformationReleaseDocuments.ClientInformationReleaseId                                                                
,Documents.DocumentId                                                                        
, DocumentCodes.DocumentCodeId,DV.DocumentVersionId as [Version], DocumentCodes.DocumentName  --DV.Version                                                            
,case when Documents.EffectiveDate IS Not NULL then convert(varchar,Documents.EffectiveDate,101)                                                                                           
            end AS [EffectiveDate]                                                              
,gcs.CodeName as [Status]                                                              
,case when (st.LastName + ', ' + st.FirstName) IS not NULL then (st.LastName + ', ' + st.FirstName)                                                                                               
            end AS AuthorName                                                                        
,ClientInformationReleaseDocuments.[RowIdentifier]                                                                              
,ClientInformationReleaseDocuments.[CreatedBy]                                   
,ClientInformationReleaseDocuments.[CreatedDate]                                                                    
,ClientInformationReleaseDocuments.[ModifiedBy]                                                                                              
,ClientInformationReleaseDocuments.[ModifiedDate]                                                                                     
,ClientInformationReleaseDocuments.[RecordDeleted]                                                                                              
,ClientInformationReleaseDocuments.[DeletedDate]                                                                                     
,ClientInformationReleaseDocuments.[DeletedBy]                                                   
,'true' as AddButtonEnabled                                                                       
 from ClientInformationReleaseDocuments                                                           
 inner join                                                           
 ClientInformationReleases on ClientInformationReleases.ClientInformationReleaseId=ClientInformationReleaseDocuments.ClientInformationReleaseId and ISNULL(ClientInformationReleases.RecordDeleted,'N')='N'                                              
 inner join Documents on                                                                      
 ClientInformationReleaseDocuments.DocumentId=Documents.DocumentId                                                           
 inner join DocumentVersions as DV on DV.DocumentId= Documents.DocumentId  and DV.DocumentVersionId=Documents.CurrentDocumentVersionId                                                              
 inner join DocumentCodes on DocumentCodes.DocumentCodeId=Documents.DocumentCodeId                                                              
 inner join GlobalCodes as gcs on gcs.GlobalCodeId= Documents.Status                              
 inner join Staff as st on st.StaffId = Documents.AuthorId                                                             
 where isNull(ClientInformationReleaseDocuments.RecordDeleted,'N')='N'                                                              
  and ClientInformationReleases.ClientId=@ClientId                                                 
          
--ClientCoveragePlans    
--  modified by scooter, 2014-08-14:
--  changed "a" to "CCP", "b" to "CP", and "c" to "CCH"
--  changed INNER JOIN on ClientCoverageHistory from a self-join (!!) to a JOIN to ClientCoveragePlans (CCP)                                              
select top (1)
        CCP.CoveragePlanId,
        CCP.InsuredId,
        CCP.ClientId,
        CCP.ClientCoveragePlanId,
        CCH.COBOrder
from    ClientCoveragePlans as CCP
inner join CoveragePlans as CP on CP.CoveragePlanId = CCP.CoveragePlanId
inner join ClientCoverageHistory as CCH on CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
where   CCP.ClientId = @ClientId
        and CP.MedicaidPlan = 'Y'
        and ISNULL(CCP.RecordDeleted, 'N') <> 'Y'
        and ISNULL(CP.RecordDeleted, 'N') <> 'Y'
        and ISNULL(CCH.RecordDeleted, 'N') <> 'Y'
        and DATEDIFF(DAY, CCH.StartDate, GETDATE()) >= 0
        and (
             (CCH.EndDate is null)
             or (DATEDIFF(DAY, CCH.EndDate, GETDATE()) <= 0)
            )
order by CCH.COBOrder                                           
                                                                                                           
----ClientAliases                                                                                                
                                                                                                        
--SELECT     ClientAliasId, ClientId, LastName, FirstName, MiddleName, AliasType, AllowSearch, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                             
--                      DeletedDate, DeletedBy                             
--FROM         ClientAliases                                            
--WHERE     (ClientId = @ClientId) AND (RecordDeleted = 'N' OR                                            
--                      RecordDeleted IS NULL)                                       
    
 --ClientAliases    
 SELECT [ClientAliasId]    
      ,[ClientId]    
      ,[LastName]    
      ,[FirstName]    
      ,[MiddleName]    
      ,[AliasType]    
      ,[AllowSearch]    
      --,CA.[RowIdentifier]    
      ,CA.[CreatedBy]    
      ,CA.[CreatedDate]    
      ,CA.[ModifiedBy]    
      ,CA.[ModifiedDate]    
      ,CA.[RecordDeleted]    
      ,CA.[DeletedDate]    
      ,CA.[DeletedBy]    
      ,gc.CodeName as AliasTypeText    
      ,case CA.AllowSearch when 'Y' then 'Yes'     
       when 'N' then 'No'                                                                                          
       end AS AllowSearchText        
      ,LastNameSoundex    
      ,FirstNameSoundex                             
  FROM [ClientAliases] CA    
  Join GlobalCodes gc on CA.AliasType = gc.GlobalCodeId    
      
  WHERE (CA.ClientId = @ClientId) AND (CA.RecordDeleted = 'N' OR                                            
         CA.RecordDeleted IS NULL)                                                                   
                                                                                                                
                                                                                                         
 --CustomStateReporting                                
   SELECT     ClientId, AdoptionStudy, SSI, ParentofYoungChild, ChildFIAAbuse, ChildFIAOther, EarlyOnProgram, WrapAround, EPSDT, IndividualNotEnrolledOrEligibleForPlan,                   
                      ProgramOrPlanNotListed, HealthInformationDate,                   
                      AbilityToHear, HearingAid, AbilitytoSee, VisualAppliance, Pneumonia, Asthma, UpperRespiratory, Gastroesophageal, ChronicBowel, SeizureDisorder,                   
                      NeurologicalDisease, Diabetes, Hypertension, Obesity, DDInformationDate, CommunicationStyle, MakeSelfUnderstood, SupportWithMobility, NutritionalIntake,                   
                      SupportPersonalCare, Relationships, FamilyFriendSupportSystem, SupportForChallengingBehaviors, BehaviorPlanPresent, NumberOfAntiPsychoticMedications,                   
                      NumberOfOtherPsychotropicMedications, MajorMentalIllness,ModifiedBy,ModifiedDate,CreatedBy,CreatedDate                  
   FROM         CustomStateReporting                                            
   WHERE     (ClientId = @ClientId) AND (ISNULL(RecordDeleted, 'N') = 'N')                            
                               
                              
                                            
--QIProgramPlan                                                        
  Exec csp_ClientInformationQIProgramPlan  @ClientID                             
                                                           
--CustomCAFAS                                                
 Exec csp_ClientInformationQICafas    @ClientID                                                                                        
                                            
--CustomDDAssessment                                            
  Exec csp_ClientInformationQIDDReporting @ClientID                                           
  /*Custom Field Data are commented By Rahul Aneja on 28 August 2012 */
  /*Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data*/                                                                           
 /* SELECT [CustomFieldsDataId]                            
      ,[DocumentType]                            
      ,[DocumentCodeId]                            
      ,[PrimaryKey1]                            
      ,[PrimaryKey2]                            
      ,[ColumnVarchar1]                            
      ,[ColumnVarchar2]                            
      ,[ColumnVarchar3]                            
      ,[ColumnVarchar4]                            
      ,[ColumnVarchar5]                            
      ,[ColumnVarchar6]                         
      ,[ColumnVarchar7]                            
      ,[ColumnVarchar8]                            
      ,[ColumnVarchar9]                            
      ,[ColumnVarchar10]                            
      ,[ColumnVarchar11]                            
      ,[ColumnVarchar12]                            
      ,[ColumnVarchar13]                            
      ,[ColumnVarchar14]                            
      ,[ColumnVarchar15]                            
      ,[ColumnVarchar16]                            
      ,[ColumnVarchar17]                            
      ,[ColumnVarchar18]                            
      ,[ColumnVarchar19]                            
      ,[ColumnVarchar20]                            
      ,[ColumnText1]                            
      ,[ColumnText2]                            
     ,[ColumnText3]                            
      ,[ColumnText4]                            
      ,[ColumnText5]                            
      ,[ColumnText6]                            
      ,[ColumnText7]                            
      ,[ColumnText8]                            
      ,[ColumnText9]                            
      ,[ColumnText10]                            
      ,[ColumnInt1]                            
      ,[ColumnInt2]                            
      ,[ColumnInt3]                            
      ,[ColumnInt4]                            
      ,[ColumnInt5]                            
      ,[ColumnInt6]                            
      ,[ColumnInt7]                            
      ,[ColumnInt8]                            
      ,[ColumnInt9]                            
      ,[ColumnInt10]                            
      ,[ColumnDatetime1]                            
      ,[ColumnDatetime2]                            
 ,[ColumnDatetime3]                            
      ,[ColumnDatetime4]                            
     ,[ColumnDatetime5]                            
      ,[ColumnDatetime6]                            
      ,[ColumnDatetime7]                            
      ,[ColumnDatetime8]                            
      ,[ColumnDatetime9]                            
      ,[ColumnDatetime10]                            
      ,[ColumnDatetime11]                            
      ,[ColumnDatetime12]                            
      ,[ColumnDatetime13]                            
      ,[ColumnDatetime14]                            
      ,[ColumnDatetime15]                            
      ,[ColumnDatetime16]                            
      ,[ColumnDatetime17]                            
      ,[ColumnDatetime18]                            
      ,[ColumnDatetime19]                            
      ,[ColumnDatetime20]                            
      ,[ColumnGlobalCode1]                            
      ,[ColumnGlobalCode2]                            
      ,[ColumnGlobalCode3]                        
      ,[ColumnGlobalCode4]                            
      ,[ColumnGlobalCode5]                            
      ,[ColumnGlobalCode6]                            
      ,[ColumnGlobalCode7]                            
      ,[ColumnGlobalCode8]                            
      ,[ColumnGlobalCode9]                            
      ,[ColumnGlobalCode10]                            
      ,[ColumnGlobalCode11]                            
      ,[ColumnGlobalCode12]                            
      ,[ColumnGlobalCode13]                            
      ,[ColumnGlobalCode14]                            
      ,[ColumnGlobalCode15]                            
      ,[ColumnGlobalCode16]                            
      ,[ColumnGlobalCode17]                            
      ,[ColumnGlobalCode18]                            
    ,[ColumnGlobalCode19]                            
      ,[ColumnGlobalCode20]                            
      ,[ColumnMoney1]                            
      ,[ColumnMoney2]                            
      ,[ColumnMoney3]                            
      ,[ColumnMoney4]                            
      ,[ColumnMoney5]                            
      ,[ColumnMoney6]                            
      ,[ColumnMoney7]                            
      ,[ColumnMoney8]                            
      ,[ColumnMoney9]                            
      ,[ColumnMoney10]                            
      ,[RowIdentifier]                            
      ,[CreatedBy]                            
      ,[CreatedDate]                            
      ,[ModifiedBy]                            
      ,[ModifiedDate]                            
      ,[RecordDeleted]                            
      ,[DeletedDate]                            
      ,[DeletedBy]                            
  FROM [CustomFieldsData]                                                                
  where PrimaryKey1=@ClientID                        
  and   DocumentType=4941         */               
           /*Added by Rahul ANeja #4 Referral Summit Pointe*/
     -----ClientPrimaryCareReferral
SELECT [ClientPrimaryCareReferralId]  
      ,CPCR.[CreatedBy]  
      ,CPCR.[CreatedDate]  
      ,CPCR.[ModifiedBy]  
      ,CPCR.[ModifiedDate]  
      ,CPCR.[RecordDeleted]  
      ,CPCR.[DeletedDate]  
      ,CPCR.[DeletedBy]  
      ,[ClientId]  
      ,[ReferralDate]  
      ,[ReferralType]  
      ,[ReferralSubType]  
      ,[ProviderType]  
      ,ERPV.ExternalReferralProviderId AS 'ProviderName'  
      ,[ContactName]  
      ,CPCR.ProviderInformation  
      ,[ReferralReason1]  
      ,[ReferralReason2]  
      ,[ReferralReason3]  
      ,[Comment]  
  FROM [ClientPrimaryCareReferrals] CPCR
    Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCR.ProviderName  AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'    
  WHERE ClientId=@ClientId AND ISNULL(CPCR.RecordDeleted,'N')<>'Y' 
 --------ClientPrimaryCareExternalReferral 
 SELECT [ClientPrimaryCareExternalReferralId]  
      ,CPCER.[CreatedBy]  
      ,CPCER.[CreatedDate]  
      ,CPCER.[ModifiedBy]  
      ,CPCER.[ModifiedDate]  
      ,CPCER.[RecordDeleted]  
      ,CPCER.[DeletedBy]  
      ,CPCER.[DeletedDate]  
	  ,CPCER.[ClientId]  
      ,[ReferralDate]  
      ,[ProviderType]  
       ,ERPV.ExternalReferralProviderId AS 'ExternalReferralProviderId'   
      ,CPCER.ProviderInformation
      ,[ReferralReason1]  
      ,[ReferralReason2]  
      ,[ReferralReason3]  
      ,[ReasonComment]  
      ,[AppointmentDate]  
      ,[AppointmentTime]  
      ,[AppointmentComment]  
      ,[PatientAppointment]  
      ,[Reason]  
      ,[ReceiveInformation]  
      ,[FollowUp]  
      ,[Status]  
      ,[FollowUpComment]  
     ,ERPV.[Name] as 'ExternalReferralProviderIdText'   
      ,dbo.csf_GetGlobalCodeNameById(Status) AS 'StatusText'
      ,dbo.csf_GetGlobalCodeNameById(ProviderType) AS 'ProviderTypeText'
	  ,CPCER.ReferringProviderId
	  ,S.DisplayAs AS ReferringProviderName
  FROM [ClientPrimaryCareExternalReferrals] AS CPCER   
  Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCER.ExternalReferralProviderId AND ISNULL(ERPV.RecordDeleted,'N')<>'Y' 
  LEFT JOIN Staff S ON S.StaffId = CPCER.ReferringProviderId  
  WHERE CPCER.ClientId=@ClientID AND ISNULL(CPCER.RecordDeleted,'N')<>'Y'  ----ClientAliases    
 --SELECT [ClientAliasId]    
 --     ,[ClientId]    
 --     ,[LastName]    
 --     ,[FirstName]    
 --     ,[MiddleName]    
 --     ,[AliasType]    
 --     ,[AllowSearch]    
 --     ,[RowIdentifier]    
 --     ,[CreatedBy]    
 --     ,[CreatedDate]    
 --     ,[ModifiedBy]    
 --     ,[ModifiedDate]    
 --     ,[RecordDeleted]    
 --     ,[DeletedDate]    
 --     ,[DeletedBy]    
 -- FROM [ClientAliases]    
 -- WHERE (ClientId = @ClientId) AND (RecordDeleted = 'N' OR                                            
 --        RecordDeleted IS NULL)                 
                                                                              
 --CustomConfigurations                
  --SELECT TOP 1 [ReferralTransferReferenceUrl]    
  --FROM [CustomConfigurations]              
-- SELECT  top 1   MaximumNeeds, MaximumObjectives, MaximumInterventions, MaximumInterventionProcedures, TPDischargeCriteria, AssessmentInitializeAllFields,                 
--                      AssessmentInitializeStoredProc, AssessmentCreateAuthorizations, AssessmentProcedures, CafasURL, HRMAssessmentHealthAssesmentLabel,                 
--                      ScreenAssessmentExpirationDays, DLAScale, QITabEnableHealthMeasures, QITabEnableDDMeasures                
--FROM         dbo.CustomConfigurations   


--ClientDemographicInformationDeclines
Select   ClientDemographicInformationDeclineId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,ClientId
			,ClientDemographicsId
FROM    ClientDemographicInformationDeclines                                            
WHERE     (ClientId = @ClientID) AND  ISNULL(RecordDeleted, 'N') = 'N'
	
	--Changes By Deej for KCMHSAS 3.5 Implementation #99
	   EXEC scsp_ClientInformationCustomFieldsData @ClientId
	--Changes Ends Here
	
--Added the CustomVisitiors table 
 EXEC scsp_ClientInformationCustomVisitors @ClientId


--Added to fetch the SiblingsData
 EXEC scsp_ClientInformationCustomSiblings @ClientId
			
-- Added By Avi Goyal, on 16 Mar 2015 to add Family Tab to Client Info Screen			
-- FamilyContacts
SELECT 
	CC.LastName + ', ' + CC.FirstName AS FamilyContact
	,GC.CodeName AS Relation
	,(CASE 
		WHEN CC.Sex='M'
		THEN 'Male'
		WHEN CC.Sex='F'
		THEN 'Female'
		ELSE ''
	END) AS FamilySex
	,CONVERT(VARCHAR(10), CC.DOB, 101) AS FamilyDOB
	,CC.ClientId
	,(dbo.[GetAge]  (CC.DOB, GETDATE())) AS Age
	,CC.AssociatedClientId
FROM ClientContacts CC
INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=CC.Relationship AND ISNULL(GC.RecordDeleted,'N')='N' 			
WHERE (ISNULL(CC.RecordDeleted, 'N') <> 'Y')
	AND (CC.ClientId = @ClientId)
	-- Modified By Avi Goyal, on 01 Sep 2015
	AND EXISTS (
					SELECT 1 
					FROM Recodes R 
					INNER JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId AND RC.CategoryCode='RELATIONFAMILY' AND ISNULL(RC.RecordDeleted,'N')='N' 
					WHERE R.IntegerCodeId=CC.Relationship AND ISNULL(R.RecordDeleted,'N')='N' 
				)
   -- ClientPictures
   EXEC SSP_GetClientPicture @ClientId,'N'   

--ClientContactsAddressHistory
Select * from ClientContactsAddressHistory where 1 = 2

--ClientEthnicities
  SELECT [ClientEthnicityId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientId]
      ,[EthnicityId]
  FROM [dbo].[ClientEthnicities]
  WHERE     (ClientId = @ClientID) AND  ISNULL(RecordDeleted, 'N') = 'N' 
 
 END TRY                                            
                                                                                                           
 BEGIN CATCH   
                                                                                         
		DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetClientInformation')                                                
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                            
		+ '*****' + Convert(varchar,ERROR_STATE())                                                                          
	                                                        
		RAISERROR                                                                           
		(                                         
		  @Error, -- Message text.                                                                          
		  16, -- Severity.                                                                          
		  1 -- State.                                                                          
		);    
		 
 END CATCH     
END    


GO

