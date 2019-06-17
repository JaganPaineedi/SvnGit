
/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientData]    Script Date: 05/15/2013 18:47:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetClientData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetClientData]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetClientData]    Script Date: 05/15/2013 18:47:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     
                        
CREATE procedure [dbo].[ssp_SCWebGetClientData]                
@ClientID as bigint                                                                                                                              
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>f
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
--17.12.2014 jagan added UserStaffId,AllergiesLastReviewedBy,AllergiesLastReviewedDate,AllergiesReviewStatus,HasNoMedications,ProfessionalSuffix  to clients table and added CareTeamMember,MailingName, ProfessionalSuffix  to clientcontacts table
-- 01/04/2015 - Munish Sood - Modified for SWMBH - Support 741
-- 27.Apr.2015	Rohith Uppin		Missing column AssociatedClientId added. Task#366 SWMBH Support.
-- 10.19.2015      Vichee          Modified the ssp to add logic for Organization in Client Information Network- 180 Customizations - #609
-- 10.29.2015      Vichee       Modified the ssp to add logic for OrganizationRelation GlobalCodes in ClientContacts table  Network- 180 Customizations - #609
-- 05-02-2016      Shruthi.S    CountyOfResidenceText and CountyOfTreatmentText.Ref : #275 EII.
--25-02-2016 - Lakshmi - Commented this is the line of code "isnull(ClientContacts.Active, 'Y') as Active" from  clientcontacts and								 uncommented	this line "ClientContacts.Active" for vally support #285
-- 22-302016 Rajesh S Added GenderIdentity Enginieering initiative - 300
-- 17 May 2016 Varun Added SexualOrientation column to Clients. Ref: Meaningful Use Stage 3 - #4
-- 10 Feb 2017	Vithobha		Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830
-- 14 Aug 2017	Rahul Kulkarni	EI#507 Changed Alias from Phone to PhoneNumber
--05 feb 2018   Neethu       Added trim function to trim extraspace for LastName and FirstName   Spring River-Support Go Live #115 
--26 mar 2018   Neethu       Added condition to check if firstname and last name is null          Spring River-Support Go Live #115 
--26 April 2018   Vinod kumar    Added Code to fetch top 1 records from ClienEpisodes information as part of Keystone Build Cycle Task # 6 .And also Removed the Commented codes from the stored procedure.
--								 Why:In ClientInformationGeneralpage ClientEpisodes Table Not available.
--17 May 2018   Bernardin        Selecting all values from ClienEpisodes table.Because Client Episodes values are not selecting after save. Core Bugs# 2612 
/*19 Aug 2018	Alok Kumar		Modified query to join ExternalReferralProviders table with Clients table for 'Primary Care Physician' section of Demographics tab.	
								Also modified query related to ClientEpisodes table to return some more columns.	Ref#618 EII.	*/
/*21 March 2019	Venkatesh MR		Exclude the phone numbers which are Null or empty. Ref Task Aspen Point Build Cycle Tasks 948*/
-- =============================================                                                                                                                            
as                      
 BEGIN
 BEGIN TRY    
 
 	DECLARE @PhysicianContact INT
	DECLARE @ProviderTypeId INT
	SET @ProviderTypeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='PCPROVIDERTYPE' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')
	SET @PhysicianContact = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE Category='RELATIONSHIP' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician') AND ISNULL(RecordDeleted, 'N') = 'N')
               
                      
--Clients                                                                                                                             
SELECT   Top 1  C.ClientId, C.ExternalClientId, C.Active, C.MRN, C.LastName, C.FirstName, C.MiddleName, C.Prefix, C.Suffix, C.SSN, SUBSTRING(C.SSN, 6, 9) AS ShortSSN, CONVERT(Varchar(5),                                         
                      DATEDIFF(YEAR, C.DOB, GETDATE()) - 1) + ' Years' AS Age, C.Sex, C.DOB, C.PrimaryClinicianId, C.CountyOfResidence, C.CountyOfTreatment, C.CorrectionStatus, C.Email, C.Comment,                                               
                      C.LivingArrangement, C.NumberOfBeds, C.MinimumWage, C.FinanciallyResponsible, C.AnnualHouseholdIncome, C.NumberOfDependents, C.MaritalStatus, C.EmploymentStatus,                                               
                      C.EmploymentInformation, C.MilitaryStatus, C.EducationalStatus, C.DoesNotSpeakEnglish, C.PrimaryLanguage, C.CurrentEpisodeNumber, C.AssignedAdminStaffId,                                               
          C.InpatientCaseManager, C.InformationComplete, C.PrimaryProgramId, C.LastNameSoundex, C.FirstNameSoundex, C.CurrentBalance, CareManagementId, C.HispanicOrigin,                                               
                      C.DeceasedOn, C.LastStatementDate, C.LastPaymentId, C.LastClientStatementId, C.DoNotSendStatement, C.DoNotSendStatementReason, C.AccountingNotes, C.MasterRecord,                            
                      C.ProviderPrimaryClinicianId, C.RowIdentifier, C.ExternalReferenceId, C.CreatedBy, C.DoNotOverwritePlan, C.Disposition,C.NoKnownAllergies, C.CreatedDate, C.ModifiedBy, C.ModifiedDate, C.RecordDeleted,                                               
                      C.DeletedDate, C.DeletedBy,C.ReminderPreference,C.MobilePhoneProvider,C.SchedulingPreferenceMonday,C.SchedulingPreferenceTuesday,C.SchedulingPreferenceWednesday,C.SchedulingPreferenceThursday,  
                      C.SchedulingPreferenceFriday,C.GeographicLocation,C.SchedulingComment,C.CauseofDeath,C.FosterCareLicence,C.PrimaryPhysicianId,C.UserStaffId,C.PreferredGenderPronoun	-- Aug 28 2014  Veena S Mani    Added columns 
	,C.AllergiesLastReviewedBy
	,C.AllergiesLastReviewedDate
	,C.AllergiesReviewStatus
	,C.HasNoMedications
	,C.ProfessionalSuffix  
	-- Added By Vichee 19/10/2015
	 ,C.ClientType       
    ,C.OrganizationName    
     ,C.EIN    
    ,SUBSTRING(C.EIN, 6, 9) AS ShortEIN
      -- end by Vichee 
      ,Ltrim(Rtrim(Ct.CountyName)) + ' - ' + St.StateAbbreviation as CountyOfResidenceText
       ,Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation as CountyOfTreatmentText
       ,C.GenderIdentity
       ,C.SexualOrientation
		,C.InternalCollections
		,C.ExternalCollections  
		,C.ExternalReferralProviderId
		,C.ClientDoesNotHavePCP
		,Erp.OrganizationName AS PCPOrganizationName
		,Erp.PhoneNumber AS PCPPhone
		,Erp.Email AS PCPEmail  
    FROM    Clients C      
left join Counties Ct on Ct.CountyFIPS = C.CountyOfResidence 
left join Counties CF on CF.CountyFIPS = C.CountyOfTreatment  
left join States St on St.StateFIPs = Ct.StateFIPs
left join States Ss on Ss.StateFIPs = CF.StateFIPs  
LEFT JOIN ExternalReferralProviders Erp ON Erp.ExternalReferralProviderId = C.ExternalReferralProviderId 
	AND ISNULL(Erp.RecordDeleted, 'N') = 'N' AND Erp.[Type] IN (@PhysicianContact,@ProviderTypeId)                           
WHERE     (ClientId = @ClientID) AND (C.RecordDeleted IS NULL OR                                            
             C.RecordDeleted = 'N')                                       
                       
                                                                       
--ClientContacts                                                                                                                          
-- Select query added on 18th April '08 (originally modified by Priya on 2nd April '08) - the order is changed and the field Sex has been renamed from SEX to Sex                                                                                
--(because in the  dataset there were two fields with name Sex)                                                                                                
SELECT     'D' AS 'DeleteButton', 'N' AS 'RadioButton', ClientContacts.ClientContactId, ClientContacts.ClientId,                                               
                    LTRIM(RTRIM( ClientContacts.LastName ))+ ', ' + LTRIM(RTRIM(ClientContacts.FirstName)) AS Contact, GlobalCodes.CodeName, GlobalCodes.CodeName AS RelationshipText,     --05 feb 2018  Neethu                                    
                          (SELECT     TOP (1) PhoneNumber                                              
                            FROM          ClientContactPhones                                              
                            WHERE      (ClientContactId = ClientContacts.ClientContactId) AND (PhoneNumber IS NOT NULL) AND (ISNULL(RecordDeleted, 'N') = 'N')                                              
                            ORDER BY PhoneType) AS PhoneNumber, -- 14 Aug 2017	Rahul Kulkarni
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
                       ClientContacts.CareTeamMember,
						ClientContacts.MailingName,
                      ClientContacts.Active, --  Lakshmi 25/02/2016  
                     -- isnull(ClientContacts.Active, 'Y') as 'Active',
                      CASE WHEN ClientContacts.EmergencyContact ='N' THEN 'No' WHEN  ClientContacts.EmergencyContact = 'Y' THEN 'Yes' END  AS [EmergencyText],
                      CASE WHEN ClientContacts.FinanciallyResponsible ='N' THEN 'No' WHEN  ClientContacts.FinanciallyResponsible = 'Y' THEN 'Yes' END  AS [FinResponsibleText],
                      CASE WHEN ClientContacts.HouseholdMember ='N' THEN 'No' WHEN  ClientContacts.HouseholdMember = 'Y' THEN 'Yes' END  AS [HouseholdNumberText],      
                      CASE WHEN ClientContacts.CareTeamMember = 'N'	THEN 'No' WHEN ClientContacts.CareTeamMember = 'Y'	THEN 'Yes'	END AS [CareTeamMemberText],                                                      
                      CASE WHEN ClientContacts.Active ='N' THEN 'No' WHEN  ClientContacts.Active = 'Y' THEN 'Yes' END  AS [ActiveText],
                      ProfessionalSuffix,
                      AssociatedClientId
FROM         ClientContacts INNER JOIN                                              
                      GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y' AND                                               
                      ((GlobalCodes.Category = 'RELATIONSHIP')  OR (GlobalCodes.Category = 'OrganizationRelation')) --Added by Vichee10292015
WHERE   ( ClientContacts.FirstName <> '') and (ClientContacts.lastname<> '' )-- Neeethu 26 mar 2018 
and  (ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y') AND (ClientContacts.ClientId = @ClientID)                                               
                                                           
--clientcontactphones                                                                                                                           
SELECT     ClientContactPhones.ContactPhoneId, ClientContactPhones.ClientContactId, ClientContactPhones.PhoneType, ClientContactPhones.PhoneNumber,                                               
                      ClientContactPhones.PhoneNumberText, ClientContactPhones.RowIdentifier, ClientContactPhones.ExternalReferenceId, ClientContactPhones.CreatedBy,                                               
                      ClientContactPhones.CreatedDate, ClientContactPhones.ModifiedBy, ClientContactPhones.ModifiedDate, ClientContactPhones.RecordDeleted,                                               
                  ClientContactPhones.DeletedDate, ClientContactPhones.DeletedBy, GlobalCodes.SortOrder                                              
FROM         ClientContactPhones INNER JOIN                                              
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactPhones.ClientContactId AND ClientContacts.ClientId = @ClientID AND                                               
                      ISNULL(ClientContacts.RecordDeleted, 'N') = 'N' INNER JOIN                                              
                      GlobalCodes ON ClientContactPhones.PhoneType = GlobalCodes.GlobalCodeId                                              
WHERE     (ISNULL(ClientContactPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N') AND (ISNULL(ClientContactPhones.PhoneNumber , '') <> '')
                                                                                                                          
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
                                              
                                                    
            
--ClientCoveragePlans                                                    
select top (1)  
        a.CoveragePlanId,  
        a.InsuredId,  
        a.ClientId,  
        a.ClientCoveragePlanId,  
        c.COBOrder  
from    ClientCoveragePlans as a  
inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId  
inner join ClientCoverageHistory as c on a.ClientCoveragePlanId = c.ClientCoveragePlanId  
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
                                                                                                             
----ClientEpisodes  
      SELECT  0 AS DeleteButton ,
            GC.CodeName ,
            CE.ClientEpisodeId ,
            CE.CreatedBy ,
            CE.CreatedDate ,
            CE.ModifiedBy ,
            CE.ModifiedDate ,
            CE.RecordDeleted ,
            CE.DeletedDate ,
            CE.DeletedBy ,
            CE.ClientId ,
            CE.EpisodeNumber ,
            CE.RegistrationDate ,
            CE.Status ,
            CE.DischargeDate ,
            CE.InitialRequestDate ,
            CE.IntakeStaff ,
            CE.AssessmentDate ,
            CE.AssessmentFirstOffered ,
            CE.AssessmentDeclinedReason ,
            CE.TxStartDate ,
            CE.TxStartFirstOffered ,
            CE.TxStartDeclinedReason ,
            CE.RegistrationComment ,
            CE.ReferralSource ,
            CE.ReferralDate ,
            CE.ReferralType ,
            CE.ReferralSubType ,
            CE.ReferralName ,
            CE.ReferralAdditionalInformation ,
            CE.ReferralReason1 ,
            CE.ReferralReason2 ,
            CE.ReferralReason3 ,
            CE.ReferralComment ,
            CE.ExternalReferralInformation ,
            CE.HasAlternateTreatmentOrder ,
            CE.AlternateTreatmentOrderType ,
            CE.AlternateTreatmentOrderExpirationDate,
            CE.ProviderType,							
            CE.ProviderId,
            CE.ReferralOrganizationName,
			CE.ReferrralPhone,
			CE.ReferrralFirstName,
			CE.ReferrralLastName,
			CE.ReferrralAddressLine1,
			CE.ReferrralAddressLine2,
			CE.ReferrralCity,
			CE.ReferrralState,
			CE.ReferrralZipCode,
			CE.ReferrralEmail
    FROM    ClientEpisodes AS CE
            LEFT OUTER JOIN GlobalCodes AS GC ON CE.Status = GC.GlobalCodeId
    WHERE   ( CE.ClientId = @ClientID )
            AND ( CE.RecordDeleted IS NULL
                  OR CE.RecordDeleted = 'N'
                )                                            
	ORDER BY CE.EpisodeNumber ASC 
    
              
                                                        
 END TRY                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetClientData')                                                                                     
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


