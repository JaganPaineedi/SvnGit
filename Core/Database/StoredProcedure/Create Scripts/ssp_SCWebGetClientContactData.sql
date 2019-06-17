
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientContactData]    Script Date: 05/15/2013 18:39:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientContactData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetClientContactData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientContactData]    Script Date: 05/15/2013 18:39:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientData]    Script Date: 04/22/2013 15:56:53 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientData]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[ssp_SCWebGetClientData]
--GO


--/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientInformation]    Script Date: 04/22/2013 15:56:53 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




  
                      
CREATE procedure [dbo].[ssp_SCWebGetClientContactData]              
@ClientID as bigint                                                                                                                            
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
--17.12.2014 jagan added CareTeamMember,MailingName, ProfessionalSuffix  to clientcontacts table
--11.04.2015 Modified by Vichee to add GlobalCode OrganizationRelation in ClientContacts table Network 180 - Customization #609
--01.JULY.2016  Akwinass         Added the missing column AssociatedClientId in ClientContacts Table (Task #2287 Core Bugs)
--26 mar 2018   Neethu           Added condition to check if firstname and last name is null          Spring River-Support Go Live #115 

-- =============================================
as                    
 BEGIN
 Begin try           
                    
--Clients                                                                                                                           
--SELECT     ClientId, ExternalClientId, Active, MRN, LastName, FirstName, MiddleName, Prefix, Suffix, SSN, SUBSTRING(SSN, 6, 9) AS ShortSSN, CONVERT(Varchar(5),                                       
--                      DATEDIFF(YEAR, DOB, GETDATE()) - 1) + ' Years' AS Age, Sex, DOB, PrimaryClinicianId, CountyOfResidence, CountyOfTreatment, CorrectionStatus, Email, Comment,                                             
--                      LivingArrangement, NumberOfBeds, MinimumWage, FinanciallyResponsible, AnnualHouseholdIncome, NumberOfDependents, MaritalStatus, EmploymentStatus,                                             
--                      EmploymentInformation, MilitaryStatus, EducationalStatus, DoesNotSpeakEnglish, PrimaryLanguage, CurrentEpisodeNumber, AssignedAdminStaffId,                                             
--          InpatientCaseManager, InformationComplete, PrimaryProgramId, LastNameSoundex, FirstNameSoundex, CurrentBalance, CareManagementId, HispanicOrigin,                                             
--                      DeceasedOn, LastStatementDate, LastPaymentId, LastClientStatementId, DoNotSendStatement, DoNotSendStatementReason, AccountingNotes, MasterRecord,                          
--                      ProviderPrimaryClinicianId, RowIdentifier, ExternalReferenceId, CreatedBy, DoNotOverwritePlan, Disposition,NoKnownAllergies, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                             
--                      DeletedDate, DeletedBy,ReminderPreference,MobilePhoneProvider,SchedulingPreferenceMonday,SchedulingPreferenceTuesday,SchedulingPreferenceWednesday,SchedulingPreferenceThursday,
--                      SchedulingPreferenceFriday,GeographicLocation,SchedulingComment                                            
--FROM         Clients                                            
--WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
--             RecordDeleted = 'N')                                            
                     
                                                                     
--ClientContacts                                                                                                                          
-- Select query added on 18th April '08 (originally modified by Priya on 2nd April '08) - the order is changed and the field Sex has been renamed from SEX to Sex                                                                                
--(because in the  dataset there were two fields with name Sex)                                                                                                
SELECT     'D' AS 'DeleteButton', 'N' AS 'RadioButton', ClientContacts.ClientContactId, ClientContacts.ClientId,                                               
                      ClientContacts.LastName + ', ' + ClientContacts.FirstName AS Contact, GlobalCodes.CodeName, GlobalCodes.CodeName AS RelationshipText,                                              
                          (SELECT     TOP (1) PhoneNumber                                              
                            FROM          ClientContactPhones                                              
                            WHERE      (ClientContactId = ClientContacts.ClientContactId) AND (PhoneNumber IS NOT NULL) AND (ISNULL(RecordDeleted, 'N') = 'N')                                              
                            ORDER BY PhoneType) AS Phone, ClientContacts.Organization, ClientContacts.SSN,  
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
                      ClientContacts.CareTeamMember,
						ClientContacts.MailingName, 
                      --ClientContacts.Active,  
                      isnull(ClientContacts.Active, 'Y') as 'Active',  
                      CASE WHEN ClientContacts.EmergencyContact ='N' THEN 'No' WHEN  ClientContacts.EmergencyContact = 'Y' THEN 'Yes' END  AS [EmergencyText],  
                      CASE WHEN ClientContacts.FinanciallyResponsible ='N' THEN 'No' WHEN  ClientContacts.FinanciallyResponsible = 'Y' THEN 'Yes' END  AS [FinResponsibleText],  
                      CASE WHEN ClientContacts.HouseholdMember ='N' THEN 'No' WHEN  ClientContacts.HouseholdMember = 'Y' THEN 'Yes' END  AS [HouseholdNumberText],
                      CASE WHEN ClientContacts.CareTeamMember = 'N'	THEN 'No' WHEN ClientContacts.CareTeamMember = 'Y'	THEN 'Yes'	END AS [CareTeamMemberText],                                                              
                      CASE WHEN ClientContacts.Active ='N' THEN 'No' WHEN  ClientContacts.Active = 'Y' THEN 'Yes' END  AS [ActiveText],
                      ProfessionalSuffix,
                      AssociatedClientId
FROM         ClientContacts INNER JOIN                                              
                      GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y' AND                                               
                      ((GlobalCodes.Category = 'RELATIONSHIP')  OR (GlobalCodes.Category = 'OrganizationRelation')) --Added by Vichee11032015                                    
WHERE   ClientContacts.FirstName is not null AND (ClientContacts.FirstName <> '') AND   ClientContacts.Lastname is not null AND (ClientContacts.Lastname<> '' )  --Neethu 26 mar 2018 
AND      (ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y') AND (ClientContacts.ClientId = @ClientID)                                              
                                                         
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
                                            
                                            
---- ClientHospitalizations                  
--SELECT  HospitalizationId, ClientId, PreScreenDate, ThreeHourDisposition,                                
--case ThreeHourDisposition when 'N' then 'No' when 'Y' then 'Yes' else '' end as ThreeHourDispositionText ,                   
--PerformedBy,Hospitalized, case Hospitalized when 'N' then 'No' when 'Y' then 'Yes' else '' end as HospitalizedText,                                 
--Hospital,HospitalText, AdmitDate, DischargeDate, SystemSevenDayFollowUp,                                 
--case SystemSevenDayFollowUp when 'N' then 'No' when 'Y' then 'Yes' else '' end as SystemSevenDayFollowUpText,                                
--SevenDayFollowUp,                                        
--case SevenDayFollowUp when 'N' then 'No' when 'Y' then 'Yes' else '' end as SevenDayFollowUpText,DxCriteriaMet,                                
--case DxCriteriaMet when 'N' then 'No' when 'Y' then 'Yes' else '' end as DxCriteriaMetText,CancellationOrNoShow,                                
--case CancellationOrNoShow when 'N' then 'No' when 'Y' then 'Yes' else '' end as CancellationOrNoShowText,                  
--ClientRefusedService, FollowUpException, FollowUpExceptionReason, Comment, ClientWasTransferred,                                
--case ClientWasTransferred when 'N' then 'No' when 'Y' then 'Yes' else '' end as ClientWasTransferredText,                       
--DeclinedServicesReason, RowIdentifier, ExternalReferenceId, CreatedBy, CreatedDate, ModifiedBy,ClientCMHSPPIHPServices,                                 
--ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
--FROM ClientHospitalizations LEFT OUTER JOIN                                            
--(select s.SiteId, case when isnull(s.SiteName,'')='' then  rtrim(p.ProviderName)                                                
--else rtrim(p.ProviderName) + ' - ' + ltrim(s.SiteName)                                               
--end  as HospitalText                                            
--from Providers p                                               
--left outer  join Sites s on p.ProviderID = s.ProviderID and isnull(s.RecordDeleted,'N')='N' ) AS Hospital                                            
--ON ClientHospitalizations.Hospital=Hospital.SiteId                                            
--WHERE (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
-- RecordDeleted = 'N')                                 
                                
                                     
----ClientCoverageReports                                            
--select cch.ClientCoverageHistoryId as ClientCoverageId,                     
--       cch.StartDate,                     
--       cch.EndDate,                    
--       cp.CoveragePlanName,                    
--       ccp.InsuredId,                     
--       ccp.GroupNumber,                     
--       '' as AuthorizationRequired,                     
--       ccp.PlanContactPhone as ContactPhone,                     
--       ccp.ClientId,                     
--       cch.COBOrder as Priority,                    
--       cp.MedicaidPlan as Medicaid,                    
--       cch.CreatedBy,                                             
--       cch.CreatedDate,                     
--       cch.ModifiedBy,                     
--       cch.ModifiedDate,               
--       cch.RecordDeleted,                     
--       cch.DeletedDate,                     
--       cch.DeletedBy                                            
--  from ClientcoveragePlans as ccp                      
--       join CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId                      
--       join ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId                      
-- where ccp.ClientId = @ClientId                      
--   and datediff(day, cch.StartDate, getdate()) >= 0                      
--   and (cch.EndDate is null or datediff(day, cch.EndDate, getdate()) <= 0)                      
--   and isnull(ccp.RecordDeleted, 'N') = 'N'                                              
--   and isnull(cch.RecordDeleted, 'N') = 'N'                      
-- order by cch.StartDate desc, Priority                                             
                                            
                                            
---- CustomTimeliness                                                                          
--SELECT     ClientEpisodeId, ServicePopulationMI, ServicePopulationDD, ServicePopulationSUD, ServicePopulationMIManualOverride, ServicePopulationDDManualOverride,                                             
--                      ServicePopulationSUDManualOverride, ServicePopulationMIManualDetermination, ServicePopulationDDManualDetermination,                                             
--                      ServicePopulationSUDManualDetermination, DiagnosticCategory, SystemDateOfInitialRequest, SystemDateOfInitialAssessment, SystemDaysRequestToAssessment,                                             
--            ManualDateOfInitialRequest, ManualDateOfInitialAssessment, ManualDaysRequestToAssessment, InitialStatus, InitialReason, SystemDateOfTreatment,                                             
--                      SystemDaysAssessmentToTreatment, SystemTreatmentServiceId, SystemInitialAssessmentServiceId, ManualDateOfTreatment, ManualDaysAssessmentToTreatment,                                            
--                       OnGoingStatus, OnGoingReason, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
--FROM         CustomTimeliness                                            
--WHERE     (ClientEpisodeId IN                                            
--                          (SELECT     ClientEpisodeId                                            
--           FROM          ClientEpisodes                                            
--                            WHERE      (ClientId = @ClientId) AND (ISNULL(RecordDeleted, 'N') = 'N'))) AND (ISNULL(RecordDeleted, 'N') = 'N')                                            
                                            
                                            
----GlobalCodes                   
--SELECT     GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder, ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2,                                             
--                      Bitmap, BitmapImage, Color, 
--                      --RowIdentifier, ExternalReferenceId, 
--                      CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy, RecordDeleted, DeletedDate                                            
--FROM         GlobalCodes                                            
--WHERE     (1 = 2)                                            
                                            
                                            
----Staff                                            
--SELECT     StaffId, UserCode, LastName, FirstName, MiddleName, Active, SSN, Sex, DOB, EmploymentStart, EmploymentEnd, LicenseNumber, TaxonomyCode, Degree,                                             
--           SigningSuffix, CoSignerId, CosignRequired, Clinician, Attending, ProgramManager, IntakeStaff, AppointmentSearch, CoSigner, AdminStaff, Prescriber,      
--                      LastSynchronizedId, UserPassword, AllowedPrinting, Email, PhoneNumber, OfficePhone1, OfficePhone2, CellPhone, HomePhone, PagerNumber, Address, City, State,                                             
--                      Zip, AddressDisplay, InLineSpellCheck, DisplayPrimaryClients, FontName, FontSize, SynchronizationOnStart, SynchronizationOnClose, EncryptionSwitch,                                             
--                  PrimaryRoleId, PrimaryProgramId, LastVisit, PasswordExpires, PasswordExpiresNextLogin, PasswordExpirationDate, SendConnectionInformation,                                             
--                      PasswordSendMethod, PasswordCallPhoneNumber, AccessCareManagement, AccessSmartCare, AccessPracticeManagement, Administrator, CanViewStaffProductivity,                                    
--                       CanCreateManageStaff, Comment, ProductivityDashboardUnit, ProductivityComment, TargetsComment, HomePage, DefaultReceptionViewId,                                             
--                      DefaultCalenderViewType, DefaultCalendarStaffId, DefaultMultiStaffViewId, DefaultProgramViewId, DefaultCalendarIncrement, UsePrimaryProgramForCaseload,                                             
--                      EHRUser, DefaultReceptionStatus, NationalProviderId, ClientPagePreferences, RetainMessagesDays, MedicationDaysDefault, ViewDocumentsBanner,                                             
--                      ExternalReferenceId, DEANumber, Supervisor, DefaultPrescribingLocation, DefaultImageServerId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,                                   
--                      RecordDeleted, DeletedDate, DeletedBy                                            
--FROM         Staff                                            
--WHERE     (1 = 2)                                            
                                            
                                            
----Counties                                            
--Select [CountyFIPS]                                                                                    
--      ,[CountyName]                                                                                    
--      ,[StateFIPS]                                        
--      ,[RowIdentifier] from  Counties where 1=2                                                
                                             
----States                                                                                                                  
--SELECT  StateFIPS, StateAbbreviation, StateName, RowIdentifier                                            
--FROM         States                                            
--WHERE     (1 = 2)                                            
                                            
----ClientFinancialSummaryReports                                                                       
--SELECT     ClientId, CoverageBalanceCurrent, CoverageBalance30, CoverageBalance90, CoverageBalance180, CoverageBalanceTotal, ClientBalanceCurrent, ClientBalance30,                                             
--                      ClientBalance90, ClientBalance180, ClientBalanceTotal, ClientLastPaymentAmount, ClientLastPaymentDate, FeeArrangement, Comment, CreatedBy, CreatedDate,                                             
--                      ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                           
--FROM         ClientFinancialSummaryReports                                            
--WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
--                      RecordDeleted = 'N')                                            
                                                                  
                                                                  
----SystemConfigurations                                            
--SELECT     OrganizationName, ClientBannerDocument1, ClientBannerDocument2, ClientBannerDocument3, ClientBannerDocument4, ClientBannerDocument5,                                             
--                      ClientBannerDocument6, StateFIPS, LastUserName, FiscalMonth, DatabaseVersion, CustomDatabaseVersion, SmartCareVersionMinimum,                                             
--                      SmartCareVersionMaximum, PracticeManagementVersionMinimum, PracticeManagementVersionMaximum, CareManagementVersionMinimum,                           
--                      CareManagementVersionMaximum, ProviderAccessVersionMinimum, ProviderAccessVersionMaximum, CareManagementServer, CareManagementDatabase,                                             
--                      AutoCreateDiagnosisFromAssessment, CareManagementInsurerId, IntializeAssessmentDiagnosis, CareManagementInsurerName, CareManagementComment,                                             
--       ClientStatementSort1, ClientStatementSort2, SCDefaultDoNotComplete, PMDefaultDoNotComplete, MedicationDaysDefault, MedicationDatabaseVersion,                                             
--                      RecurringAppointmentsExpandedFromDays, RecurringAppointmentsExpandedToDays, RecurringAppointmentsExpandedFrom, RecurringAppointmentsExpandedTo,                                             
--   ProgramsBannerText, ShowGroupsBanner, ShowBedCensusBanner, FilterTPAuthorizationCodesByAssigned, ShowTPProceduresViewMode, DisableNoShowNotes,                                             
--                      DisableCancelNotes, CredentialingExpirationMonths, CredentialingApproachingExpirationDays, ImageDatabaseConfigurationName,                                             
--                      MedicationPatientOverviewTemplate, ScannedMedicalRecordAuthorId, AssessmentBannerId, TreatmentPlanBannerId, PeriodicReviewBannerId,                                             
--                      GeneralDocumentsBannerId, DiagnosisBannerId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate                                            
--FROM         SystemConfigurations                                            
--WHERE     (1 = 2)                                          
                                            
----Providers                                            
--SELECT     ProviderId, ProviderType, Active, NonNetwork, DataEntryComplete, ProviderName, FirstName, ExternalId, Website, Comment, PrimarySiteId, PrimaryContactId,                                             
--                      ContractingContactId, ApplyTaxIDToAllSites, ProviderIdAppliesToAllSites, POSAppliesToAllSites, TaxonomyAppliesToAllSites, NPIAppliesToAllSites,                                             
--                      DataEntryCompleteForAuthorization, UsesProviderAccess, SubstanceUseProvider, AccessAgency, CredentialApproachingExpiration, RowIdentifier, CreatedBy,                             
--                      CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
--FROM         Providers                                            
--WHERE     (1 = 2)                                            
                                            
----ClientRaces                                            
--SELECT     ClientRaceId, ClientId, RaceId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
--FROM         ClientRaces                                            
--WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
--  RecordDeleted = 'N')                                               
                     
----ClientInformationReleases                                            
--Select   Case                                                                    
--   When (SELECT     COUNT(*)                                    
--  FROM         ClientInformationReleaseDocuments INNER JOIN                                  
--                      ClientInformationReleases AS CIR ON ClientInformationReleaseDocuments.ClientInformationReleaseId = CIR.ClientInformationReleaseId                                  
--  WHERE     (CIR.ClientInformationReleaseId = CIR.ClientInformationReleaseId)                                   
--  AND (ISNULL(ClientInformationReleaseDocuments.RecordDeleted, 'N') = 'N') ) > 1 Then 'Multiple Documents'                                                                  
--  Else ( select DocumentCodes.DocumentName from DocumentCodes inner join Documents on Documents.DocumentCodeId=DocumentCodes.DocumentCodeId                                                                  
--  inner join ClientInformationReleaseDocuments on Documents.DocumentId= ClientInformationReleaseDocuments.DocumentId                                                                  
--  inner join ClientInformationReleases as CIR on ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId= CIR.ClientInformationReleaseId                                                                  
--  where ClientInformationReleaseDocuments.ClientInformationReleaseId=ClientInformationReleases.ClientInformationReleaseId and ISNULL(ClientInformationReleaseDocuments.RecordDeleted,'N')='N' )                                                               
  
   
                                                                         
--  ENd as 'ReleaseDocuments'                  
--    ,ClientInformationReleases.[ClientInformationReleaseId]                                                                        ,ClientInformationReleases.[ClientId]                                                                                       
  
   
--    ,ClientInformationReleases.[ReleaseToId]                                                                                          
--    ,ClientInformationReleases.[ReleaseToName]                                                      
--    ,case when ClientInformationReleases.[StartDate] IS Not NULL then convert(varchar,ClientInformationReleases.[StartDate],101)                                                                               
--            end AS [StartDate]                                                      
--    ,case when ClientInformationReleases.[EndDate] IS Not NULL then convert(varchar,ClientInformationReleases.[EndDate],101)                                                                                
--            end AS [EndDate]                                                                              
--    ,ClientInformationReleases.[Comment]                                   
--    ,ClientInformationReleases.[DocumentAttached]                                                                                          
--    ,ClientInformationReleases.[RowIdentifier]                                                                                          
--    ,ClientInformationReleases.[CreatedBy]                                                                           
--    ,ClientInformationReleases.[CreatedDate]                                                                                          
--    ,ClientInformationReleases.[ModifiedBy]                                                  
--    ,ClientInformationReleases.[ModifiedDate]                                                                                          
--    ,ClientInformationReleases.[RecordDeleted]                                                                                          
--    ,ClientInformationReleases.[DeletedDate]                                                                                
--   ,ClientInformationReleases.[DeletedBy]    
--    ,Remind
--    ,DaysBeforeEndDate                                                     
--    ,Locked
--    ,LockedBy  
--    ,LockedDate 
--    from ClientInformationReleases                                             
--      Where isNull(ClientInformationReleases.RecordDeleted,'N')<>'Y' and ClientInformationReleases.ClientId=@ClientId                                     
                                          
                                          
----ClientInformationReleaseDocuments                                             
--select                                                                          
-- ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId                                                                        
--,ClientInformationReleaseDocuments.ClientInformationReleaseId                                                                
--,Documents.DocumentId                                                                        
--, DocumentCodes.DocumentCodeId,DV.DocumentVersionId as [Version], DocumentCodes.DocumentName  --DV.Version                                                            
--,case when Documents.EffectiveDate IS Not NULL then convert(varchar,Documents.EffectiveDate,101)                                                                                           
--            end AS [EffectiveDate]                                                              
--,gcs.CodeName as [Status]                                                              
--,case when (st.LastName + ', ' + st.FirstName) IS not NULL then (st.LastName + ', ' + st.FirstName)                                                                                               
--            end AS AuthorName                                                                        
--,ClientInformationReleaseDocuments.[RowIdentifier]                                                                              
--,ClientInformationReleaseDocuments.[CreatedBy]                                   
--,ClientInformationReleaseDocuments.[CreatedDate]                                                                    
--,ClientInformationReleaseDocuments.[ModifiedBy]                                                                                              
--,ClientInformationReleaseDocuments.[ModifiedDate]                                                                                     
--,ClientInformationReleaseDocuments.[RecordDeleted]                                                                                              
--,ClientInformationReleaseDocuments.[DeletedDate]                                                                                     
--,ClientInformationReleaseDocuments.[DeletedBy]                                                   
--,'true' as AddButtonEnabled                                                                       
-- from ClientInformationReleaseDocuments                                                           
-- inner join                                                           
-- ClientInformationReleases on ClientInformationReleases.ClientInformationReleaseId=ClientInformationReleaseDocuments.ClientInformationReleaseId and ISNULL(ClientInformationReleases.RecordDeleted,'N')='N'                                              
-- inner join Documents on                                                                      
-- ClientInformationReleaseDocuments.DocumentId=Documents.DocumentId                                                           
-- inner join DocumentVersions as DV on DV.DocumentId= Documents.DocumentId  and DV.DocumentVersionId=Documents.CurrentDocumentVersionId                                                              
-- inner join DocumentCodes on DocumentCodes.DocumentCodeId=Documents.DocumentCodeId                                                              
-- inner join GlobalCodes as gcs on gcs.GlobalCodeId= Documents.Status                              
-- inner join Staff as st on st.StaffId = Documents.AuthorId                                                             
-- where isNull(ClientInformationReleaseDocuments.RecordDeleted,'N')='N'                                                              
--  and ClientInformationReleases.ClientId=@ClientId                                                 
          
----ClientCoveragePlans                                                  
--select top (1)
--        a.CoveragePlanId,
--        a.InsuredId,
--        a.ClientId,
--        a.ClientCoveragePlanId,
--        c.COBOrder
--from    ClientCoveragePlans as a
--inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId
--inner join ClientCoverageHistory as c on c.ClientCoveragePlanId = c.ClientCoveragePlanId
--where   a.ClientId = @ClientId
--        and b.MedicaidPlan = 'Y'
--        and ISNULL(a.RecordDeleted, 'N') <> 'Y'
--        and ISNULL(b.RecordDeleted, 'N') <> 'Y'
--        and ISNULL(c.RecordDeleted, 'N') <> 'Y'
--        and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0
--        and (
--             (c.EndDate is null)
--             or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)
--            )
--order by c.COBOrder                                           
                                                                                                           
------ClientAliases                                                                                                
                                                                                                        
----SELECT     ClientAliasId, ClientId, LastName, FirstName, MiddleName, AliasType, AllowSearch, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                             
----                      DeletedDate, DeletedBy                             
----FROM         ClientAliases                                            
----WHERE     (ClientId = @ClientId) AND (RecordDeleted = 'N' OR                                            
----                      RecordDeleted IS NULL)                                       
    
-- --ClientAliases    
-- SELECT [ClientAliasId]    
--      ,[ClientId]    
--      ,[LastName]    
--      ,[FirstName]    
--      ,[MiddleName]    
--      ,[AliasType]    
--      ,[AllowSearch]    
--      --,CA.[RowIdentifier]    
--      ,CA.[CreatedBy]    
--      ,CA.[CreatedDate]    
--      ,CA.[ModifiedBy]    
--      ,CA.[ModifiedDate]    
--      ,CA.[RecordDeleted]    
--      ,CA.[DeletedDate]    
--      ,CA.[DeletedBy]    
--      ,gc.CodeName as AliasTypeText    
--      ,case CA.AllowSearch when 'Y' then 'Yes'     
--       when 'N' then 'No'                                                                                          
--       end AS AllowSearchText        
--      ,LastNameSoundex    
--      ,FirstNameSoundex                             
--  FROM [ClientAliases] CA    
--  Join GlobalCodes gc on CA.AliasType = gc.GlobalCodeId    
      
--  WHERE (CA.ClientId = @ClientId) AND (CA.RecordDeleted = 'N' OR                                            
--         CA.RecordDeleted IS NULL)                                                                   
                                                                                                                
                                                                                                         
-- --CustomStateReporting                                
--   SELECT     ClientId, AdoptionStudy, SSI, ParentofYoungChild, ChildFIAAbuse, ChildFIAOther, EarlyOnProgram, WrapAround, EPSDT, IndividualNotEnrolledOrEligibleForPlan,                   
--                      ProgramOrPlanNotListed, HealthInformationDate,                   
--                      AbilityToHear, HearingAid, AbilitytoSee, VisualAppliance, Pneumonia, Asthma, UpperRespiratory, Gastroesophageal, ChronicBowel, SeizureDisorder,                   
--                      NeurologicalDisease, Diabetes, Hypertension, Obesity, DDInformationDate, CommunicationStyle, MakeSelfUnderstood, SupportWithMobility, NutritionalIntake,                   
--                      SupportPersonalCare, Relationships, FamilyFriendSupportSystem, SupportForChallengingBehaviors, BehaviorPlanPresent, NumberOfAntiPsychoticMedications,                   
--                      NumberOfOtherPsychotropicMedications, MajorMentalIllness,ModifiedBy,ModifiedDate,CreatedBy,CreatedDate                  
--   FROM         CustomStateReporting                                            
--   WHERE     (ClientId = @ClientId) AND (ISNULL(RecordDeleted, 'N') = 'N')                            
                               
                              
                                            
----QIProgramPlan                                                        
--  Exec csp_ClientInformationQIProgramPlan  @ClientID                             
                                                           
----CustomCAFAS                                                
-- Exec csp_ClientInformationQICafas    @ClientID                                                                                        
                                            
----CustomDDAssessment                                            
--  Exec csp_ClientInformationQIDDReporting @ClientID                                           
--  /*Custom Field Data are commented By Rahul Aneja on 28 August 2012 */
--  /*Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data*/                                                                           
-- /* SELECT [CustomFieldsDataId]                            
--      ,[DocumentType]                            
--      ,[DocumentCodeId]                            
--      ,[PrimaryKey1]                            
--      ,[PrimaryKey2]                            
--      ,[ColumnVarchar1]                            
--      ,[ColumnVarchar2]                            
--      ,[ColumnVarchar3]                            
--      ,[ColumnVarchar4]                            
--      ,[ColumnVarchar5]                            
--      ,[ColumnVarchar6]                         
--      ,[ColumnVarchar7]                            
--      ,[ColumnVarchar8]                            
--      ,[ColumnVarchar9]                            
--      ,[ColumnVarchar10]                            
--      ,[ColumnVarchar11]                            
--      ,[ColumnVarchar12]                            
--      ,[ColumnVarchar13]                            
--      ,[ColumnVarchar14]                            
--      ,[ColumnVarchar15]                            
--      ,[ColumnVarchar16]                            
--      ,[ColumnVarchar17]                            
--      ,[ColumnVarchar18]                            
--      ,[ColumnVarchar19]                            
--      ,[ColumnVarchar20]                            
--      ,[ColumnText1]                            
--      ,[ColumnText2]                            
--     ,[ColumnText3]                            
--      ,[ColumnText4]                            
--      ,[ColumnText5]                            
--      ,[ColumnText6]                            
--      ,[ColumnText7]                            
--      ,[ColumnText8]                            
--      ,[ColumnText9]                            
--      ,[ColumnText10]                            
--      ,[ColumnInt1]                            
--      ,[ColumnInt2]                            
--      ,[ColumnInt3]                            
--      ,[ColumnInt4]                            
--      ,[ColumnInt5]                            
--      ,[ColumnInt6]                            
--      ,[ColumnInt7]                            
--      ,[ColumnInt8]                            
--      ,[ColumnInt9]                            
--      ,[ColumnInt10]                            
--      ,[ColumnDatetime1]                            
--      ,[ColumnDatetime2]                            
-- ,[ColumnDatetime3]                            
--      ,[ColumnDatetime4]                            
--     ,[ColumnDatetime5]                            
--      ,[ColumnDatetime6]                            
--      ,[ColumnDatetime7]                            
--      ,[ColumnDatetime8]                            
--      ,[ColumnDatetime9]                            
--      ,[ColumnDatetime10]                            
--      ,[ColumnDatetime11]                            
--      ,[ColumnDatetime12]                            
--      ,[ColumnDatetime13]                            
--      ,[ColumnDatetime14]                            
--      ,[ColumnDatetime15]                            
--      ,[ColumnDatetime16]                            
--      ,[ColumnDatetime17]                            
--      ,[ColumnDatetime18]                            
--      ,[ColumnDatetime19]                            
--      ,[ColumnDatetime20]                            
--      ,[ColumnGlobalCode1]                            
--      ,[ColumnGlobalCode2]                            
--      ,[ColumnGlobalCode3]                        
--      ,[ColumnGlobalCode4]                            
--      ,[ColumnGlobalCode5]                            
--      ,[ColumnGlobalCode6]                            
--      ,[ColumnGlobalCode7]                            
--      ,[ColumnGlobalCode8]                            
--      ,[ColumnGlobalCode9]                            
--      ,[ColumnGlobalCode10]                            
--      ,[ColumnGlobalCode11]                            
--      ,[ColumnGlobalCode12]                            
--      ,[ColumnGlobalCode13]                            
--      ,[ColumnGlobalCode14]                            
--      ,[ColumnGlobalCode15]                            
--      ,[ColumnGlobalCode16]                            
--      ,[ColumnGlobalCode17]                            
--      ,[ColumnGlobalCode18]                            
--    ,[ColumnGlobalCode19]                            
--      ,[ColumnGlobalCode20]                            
--      ,[ColumnMoney1]                            
--      ,[ColumnMoney2]                            
--      ,[ColumnMoney3]                            
--      ,[ColumnMoney4]                            
--      ,[ColumnMoney5]                            
--      ,[ColumnMoney6]                            
--      ,[ColumnMoney7]                            
--      ,[ColumnMoney8]                            
--      ,[ColumnMoney9]                            
--      ,[ColumnMoney10]                            
--      ,[RowIdentifier]                            
--      ,[CreatedBy]                            
--      ,[CreatedDate]                            
--      ,[ModifiedBy]                            
--      ,[ModifiedDate]                            
--      ,[RecordDeleted]                            
--      ,[DeletedDate]                            
--      ,[DeletedBy]                            
--  FROM [CustomFieldsData]                                                                
--  where PrimaryKey1=@ClientID                        
--  and   DocumentType=4941         */               
--           /*Added by Rahul ANeja #4 Referral Summit Pointe*/
--     -----ClientPrimaryCareReferral
--SELECT [ClientPrimaryCareReferralId]  
--      ,CPCR.[CreatedBy]  
--      ,CPCR.[CreatedDate]  
--      ,CPCR.[ModifiedBy]  
--      ,CPCR.[ModifiedDate]  
--      ,CPCR.[RecordDeleted]  
--      ,CPCR.[DeletedDate]  
--      ,CPCR.[DeletedBy]  
--      ,[ClientId]  
--      ,[ReferralDate]  
--      ,[ReferralType]  
--      ,[ReferralSubType]  
--      ,[ProviderType]  
--      ,ERPV.ExternalReferralProviderId AS 'ProviderName'  
--      ,[ContactName]  
--      ,CPCR.ProviderInformation  
--      ,[ReferralReason1]  
--      ,[ReferralReason2]  
--      ,[ReferralReason3]  
--      ,[Comment]  
--  FROM [ClientPrimaryCareReferrals] CPCR
--    Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCR.ProviderName  AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'    
--  WHERE ClientId=@ClientId AND ISNULL(CPCR.RecordDeleted,'N')<>'Y' 
-- --------ClientPrimaryCareExternalReferral 
-- SELECT [ClientPrimaryCareExternalReferralId]  
--      ,CPCER.[CreatedBy]  
--      ,CPCER.[CreatedDate]  
--      ,CPCER.[ModifiedBy]  
--      ,CPCER.[ModifiedDate]  
--      ,CPCER.[RecordDeleted]  
--      ,CPCER.[DeletedBy]  
--      ,CPCER.[DeletedDate]  
--	  ,CPCER.[ClientId]  
--      ,[ReferralDate]  
--      ,[ProviderType]  
--       ,ERPV.ExternalReferralProviderId AS 'ProviderName'   
--      ,CPCER.ProviderInformation
--      ,[ReferralReason1]  
--      ,[ReferralReason2]  
--      ,[ReferralReason3]  
--      ,[ReasonComment]  
--      ,[AppointmentDate]  
--      ,[AppointmentTime]  
--      ,[AppointmentComment]  
--      ,[PatientAppointment]  
--      ,[Reason]  
--      ,[ReceiveInformation]  
--      ,[FollowUp]  
--      ,[Status]  
--      ,[FollowUpComment]  
--     ,ERPV.[Name] as 'ProviderNameText'   
--      ,dbo.csf_GetGlobalCodeNameById(Status) AS 'StatusText'
--      ,dbo.csf_GetGlobalCodeNameById(ProviderType) AS 'ProviderTypeText'
   
--  FROM [ClientPrimaryCareExternalReferrals] AS CPCER   
--  Left Join ExternalReferralProviders ERPV on ERPV.ExternalReferralProviderId = CPCER.ProviderName AND ISNULL(ERPV.RecordDeleted,'N')<>'Y'   
--  WHERE CPCER.ClientId=@ClientID AND ISNULL(CPCER.RecordDeleted,'N')<>'Y'  ----ClientAliases    
-- --SELECT [ClientAliasId]    
-- --     ,[ClientId]    
-- --     ,[LastName]    
-- --     ,[FirstName]    
-- --     ,[MiddleName]    
-- --     ,[AliasType]    
-- --     ,[AllowSearch]    
-- --     ,[RowIdentifier]    
-- --     ,[CreatedBy]    
-- --     ,[CreatedDate]    
-- --     ,[ModifiedBy]    
-- --     ,[ModifiedDate]    
-- --     ,[RecordDeleted]    
-- --     ,[DeletedDate]    
-- --     ,[DeletedBy]    
-- -- FROM [ClientAliases]    
-- -- WHERE (ClientId = @ClientId) AND (RecordDeleted = 'N' OR                                            
-- --        RecordDeleted IS NULL)                 
                                                                              
-- --CustomConfigurations                
--  --SELECT TOP 1 [ReferralTransferReferenceUrl]    
--  --FROM [CustomConfigurations]              
---- SELECT  top 1   MaximumNeeds, MaximumObjectives, MaximumInterventions, MaximumInterventionProcedures, TPDischargeCriteria, AssessmentInitializeAllFields,                 
----                      AssessmentInitializeStoredProc, AssessmentCreateAuthorizations, AssessmentProcedures, CafasURL, HRMAssessmentHealthAssesmentLabel,                 
----                      ScreenAssessmentExpirationDays, DLAScale, QITabEnableHealthMeasures, QITabEnableDDMeasures                
----FROM         dbo.CustomConfigurations                
                                                      
   end try                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetClientContactData')                                                                                     
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


