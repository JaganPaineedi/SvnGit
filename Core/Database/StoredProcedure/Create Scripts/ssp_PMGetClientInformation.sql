IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   OBJECT_ID = OBJECT_ID(N'[ssp_PMGetClientInformation]')
                    AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
    DROP PROCEDURE [dbo].[ssp_PMGetClientInformation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_PMGetClientInformation]
    @ClientID AS BIGINT ,
    @FirstName AS type_FirstName_Encrypted = NULL ,
    @LastName AS type_LastName_Encrypted = NULL ,
    @DOB AS DATE = NULL ,
    @SSN AS type_SSN_Encrypted = NULL ,
    @Active AS type_Active = NULL ,
    @FinanciallyResponsible AS type_YOrN = NULL ,
    @DoesNotSpeakEnglish AS type_YOrN = NULL,
    @CreatedBy As type_CurrentUser = NULL,
    @StaffId AS INT = NULL,
    @ProviderId as INT = NULL
    
AS /********************************************************************************                                                  
-- Stored Procedure: ssp_PMGetClientInformation
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the Client Information page.
--
-- Author:  Praveen Potnuru
-- Date:    12 Sep 2011
-- Modified
-- Kneale   Nov 10, 2011 Added additional parameters plus added code to handle -1 clientid
--                       to insert an retrieve the new client id
--Modified
-- Ponnin Selvan Nov 24 2011 Added additional parameters as CreatedBy to insert the LoggedIn User for the CreatedBy and ModifiedBy user
-- Ponnin Selvan DEc 02 2011 Modified File Name
-- Ponnin Selvan Dec 08 2011 Added two columns in the ClientContacts select statement(LastNameSoundex and FirstNameSoundex)
-- Ponnin Selvan Dec 14 2011 Added insert statement for StaffClients table to display the client in the client Search page.
-- Rakesh Garg   12Jan 2012  Due to datamodel change in 10.672 As in GlobalCodes table Column RowIdentifier & ExternalReferenceId has been removed
-- MSuma		 Jan 16 2012 Removed Custom Stored Procedures
-- PSelvan		 Apr 21 2012 Threshold Development phase III (Offshore)task #12
-- PSelvan       Apr 26 2012 ClientCMHSPPIHPServices column added in ClientHospitalization table
-- Maninder      Apr 27 2012 Clients table added columns  ,[MobilePhoneProvider],[SchedulingPreferenceMonday],[SchedulingPreferenceTuesday],[SchedulingPreferenceWednesday],[SchedulingPreferenceThursday],[SchedulingPreferenceFriday],[GeographicLocation],[SchedulingComment] 
-- PSelvan       May 24 2012 Added new column EraPost911 for the Thresholds - Bugs/Features (Offshore) #1066
-- Rahul Aneja   Aug 30 2012 Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data
-- 25Sept2012	Shifali		 Added Columns Locked,LockedBy ,LockedDate  in table ClientInformationReleases (Ref Task# 417)
							 Pm client information: Lock release of information log is not working
-- 4-OCt-2012	Ponnin		Removed custom table "Customveteransinformation" and added scsp_ClientInformationVeteransInfo for get the Verteran information details.						 
-- 07-Dec-2012	AmitSr		Checked record exists in StaffClients with StaffId,ClientId before insert,#16, 3.5x Issues, Client Information(SC):- Exception occurred while creating the new client.
-- 20-12-2012   Saurav Pande Comment the code for Insert in StaffClients table as values in this table will be inserted through trigger TriggerInsert_Clients w.rf to task 1663 in Kalamazoo Go Live Project(This is commented becuase of Kalamazoo issue)
-- 15-Feb-2013  Varinder Verma   Added Variable @CustomStateReportingcount. Ref the task #2736  Thresholds - Bugs/Features (Offshore). 
-- 27-Feb-2013   Rachna Singh    Added 'scsp_UpdateNewClientsFinanciallyResponsible' to call csp_PostUpdateClientsInformation and remove call of 'csp_PostUpdateClientsInformation' from 'scsp_ClientInformationVeteransInfo' 
								w.r.t Task #432 in CentraWellness-Bugs/Features
--18 March -2013 Saurav Pande	Remove this 'scsp_UpdateNewClientsFinanciallyResponsible' to call csp_PostUpdateClientsInformation w.r.t task #14 in Centra Wellness Customizations.
								They don't want to make the "Financial Information Comelete checkbox 'Y'"
--13 May 2013    Bernardin      Added insert statement to add Staff and Client id in StaffClient table. Thresholds - Bugs/Features (Offshore) Task # 3045
-- 04 June		 Pradeep		Added new column Client.CauseofDeath for the task #33 (Core bugs and features)
-- 06 June		 Pradeep		Added new columns FosterCareLicence,PrimaryPhysicianId in the Clients table and the modification is done for the task #34
-- June 13, 2013	Wasif Butt	Added isnull check for client contacts to select 'Y'
-- 11/12/2013		Gayathri Naik		Task #1260 in Core Bugs project. Added ClientDemographicInformationDeclines Table to retrieve the data which client declined to provide. 
-- 11/20/2013		Gayathri Naik		Moved the CustomVeteransInformation table at the end
-- 20 Jan 2014	RQuigley		Add order by to episode query to ensure proper dropdown order.
-- 19-Feb-2014  Vaibhav Khare	Adding new FQHC tab
-- 18 Mar 2014  Manju P		    Added 'Not Reportable' for ThreeHourDisposition wrt task #681 Customization Bugs
-- 25-Apr-2014  Vaibhav Khare  Reorder table Getdata table.Putted VeteransInfo in the Last of get data 
-- May 27 2014	Pradeep.A		Added StaffId
-- Jun 16 2014	Pradeep.A		Renamed StaffId to UserStaffId.
-- Aug 27 2014	Rohtih			2 new tables added. Task#49 CM to SC
--Aug 28 2014  Veena S Mani    Added columns to the client table which is missing in the Get SP.columns are AllergiesLastReviewedBy,AllergiesLastReviewedDate,AllergiesReviewStatus,HasNoMedications columns added.Core Bugs# 1623
-- Sep 25 2014 Rohith Uppin		New table(ClientsSADemographics) added for task#9 CM to SC(also part of task#49)
--Oct 30 2014	Deej			Added a new scsp_implementation for selecting CustomFieldsData KCMHSAS 3.5 Implementation #99
-- 14.Nov.2014	Rohith Uppin	New parameter ProivderId and MasterRecord column value is setting now.. Task#139 CM to SC.
-- 22 Oct 2014  Hussain Khusro  Added 3 missing columns "RecordDeleted", "DeletedDate" and "DeletedBy" in select clause of "CustomStateReporting" table w.r.t task #1651 Core Bugs.
-- Nov 17 2014 Pradeep.A		Added ProfessionalSuffix column to Clients and ClientContacts table.
-- Nov 26 2014 Anto				Added Visitors table for Woods customization 801
-- Nov 1 2014	Malathi Shiva	Added scsp instead of csp
-- 11/24/2014	Chethan N		for Creating Patient Portal Staff on creation of Client based on systemconfiguration Key USEPATIENTPORTAL task no #50.9 Macon County-Design  
-- 11 Mar 2015	Avi Goyal		What : Added FamilyContacts
								Why : Task # 907.1 Family Tab to Client Information Screen ; Project : Valley - Customizations
-- 27-03-2015	Vaibhav Khare	Change the name of the ssp_SCCreationofPatientStaff in condition check which is using for creating patient portal task no #50.9 Macon County-Design  
-- 14.May.2015	Rohith Uppin	FamilyContacts table moved to last order. Task#44 -  	Valley Client Acceptance Testing Issues.
-- 29-0402015	Pradeep.A	    Added SSP_GetClientPicture to select the active Client Picture
-- 01 Sep 2015	Avi Goyal		What : Added checked for recode category RELATIONFAMILY to fetch records for Family Tab
								Why : Task # 907.1 Family Tab to Client Information Screen ; Project : Valley - Customizations
-- 13 Oct 2015  Arjun K R       Code to Convert Active column to 'Y' if the value is NULL is removed. Task #32 CEI Support Go Live
-- 10.19.2015      Vichee       Modified the ssp to add logic for Organization in Client Information  Network- 180 Customizations - #609
-- 10.29.2015      Vichee       Modified the ssp to add logic for OrganizationRelation GlobalCodes in ClientContacts table  Network- 180 Customizations - #609
-- 28.01.2016      Shruthi.S    Added CountyOfResidenceText and CountyOfTreatmentText.Ref : #275 EII.
-- 22-302016 Rajesh S Added GenderIdentity Enginieering initiative - 300
--  17 May 2016 Varun Added ClientEthnicities table and SexualOrientation column to Clients
                Ref: Meaningful Use Stage 3 - #4
  /*24 May 2016 Venkatesh  Create a Client Plan with GR plan once we create a client in Inquiry - Ref Task - 136 in Camino Environment Issue Tracking*/                    
-- 09.Jun.2016	Alok Kumar		Added column 'DoNotLeaveMessage' in ClientPhones for task#333 Engineering Improvement Initiatives- NBL(I)
-- 19.Jun.2016	Ponnin			Changed INNER join to LEFT join for ClientContacts table to show all the contacts. Why For Bradford - Environment Issues Tracking #126 
-- 10 Feb 2017	Vithobha		Added InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830
-- 16-Aug-2017  Sachin			What : Added FirstNameSoundex and LastNameSoundex Columns for Update into Clients Table as Soundex.
--								Why : Core Bugs #2400
-- 14.Jul.2017	Alok Kumar		Added columns ProviderType, ProviderId in table ClientEpisodes for task#47 - Meaningful Use - Stage 3
-- 30 Oct 2017	Anto		    Added SchedulingPreferenceSaturday and SchedulingPreferenceSunday columns in Clients table, Texas Customizations #124
-- 30 Jan 2018	Kavya		    Added SCSP scsp_ClientInformationEpisodeDischarge to make record deleted of individual treatment plan Todo's when the clientepisode discharged#AspenPoint SGL 650
-- 14 Aug 2017	Rahul Kulkarni	Changed Alias from Phone to PhoneNumber for EI#507
-- 29 Aug 2018  Ponnin			Set Financially Responsible as Yes for newly created client until new client contact is created with financially responsible as Yes. CHC - Support Go Live #249.
-- 23 Oct 2018  Ponnin			By default set Financially Responsible as Yes for new client. Removed the isnull condition and set 'Y' as default. CHC - Support Go Live #249.
*********************************************************************************/


BEGIN
BEGIN TRY 

	DECLARE @MasterRecord CHAR
	SET @MasterRecord = 'Y'
	
	IF	@ProviderId > 0
		BEGIN			
			DECLARE @IsSubstanceUseProvider CHAR
					
			SELECT @IsSubstanceUseProvider = ISNULL(SubstanceUseProvider,'N')
			FROM Providers 
			WHERE ProviderId = @ProviderId and ISNULL(RecordDeleted,'N') <> 'Y'
				
			IF @IsSubstanceUseProvider = 'Y'
				SET @MasterRecord = 'N'
		END
										
					
    IF @ClientID = -1 
        BEGIN  
			INSERT  INTO Clients
                    ( FirstName ,
                      LastName ,
                      DOB ,
                      SSN ,
                      Active ,
                      FinanciallyResponsible ,
                      DoesNotSpeakEnglish,
                      MasterRecord,
                      CreatedBy,
                      ModifiedBy ,
                      ClientType,
                      FirstNameSoundex,
                      LastNameSoundex
                    )
            VALUES  ( ISNULL(@FirstName,'') ,
                      ISNULL(@LastName,'') ,
                      ISNULL(@DOB, GETDATE()) ,
                      ISNULL(@SSN,'') ,
                      ISNULL(@Active,'Y') ,
                      'Y' ,
                      ISNULL(@DoesNotSpeakEnglish,'N'),
                      @MasterRecord,
                      ISNULL(@CreatedBy,''),
                      ISNULL(@CreatedBy,''),
                      'I',
                      SOUNDEX(@FirstName) ,
                      SOUNDEX(@LastName)
                    ) 
                    
                   
		
            SELECT  @ClientID = @@Identity    
            -- Added by Venkatesh for task Camino Environment issue Tracking - 136
            IF EXISTS (SELECT  *  
				        FROM    sys.objects  
				        WHERE   OBJECT_ID = OBJECT_ID(N'[scsp_CreateClientPlans]')  
				                AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 )   
				                BEGIN  
						exec scsp_CreateClientPlans @ClientID  
			  END      
            
            insert into CustomStateReporting (ClientId ) values (@ClientID)
            -- Added by Bernardin w.r.f Thresholds - Bugs/Features (Offshore) Task # 3045
            insert into StaffClients (StaffId, ClientId)
            select     VSP.StaffId,@ClientID from ViewStaffPermissions as VSP INNER JOIN
                      Staff as s on VSP.StaffId = s.StaffId where VSP.PermissionTemplateType = 5705 and VSP.PermissionItemId = 5741
                      and not exists(select * from StaffClients SC  where SC.StaffId = VSP.StaffId and ClientId = @ClientID) and ( s.RecordDeleted IS NULL OR s.RecordDeleted = 'N') 
           -- Changes end here  
              -- Commented by Saurav Pande w.rf to task 1663 in Kalamazoo Go Live Project We take this from 3.x Merged
          --  if not exists(select 1 from StaffClients where StaffId=@StaffId and ClientId=@ClientID)
         --   begin
		--		insert into StaffClients (StaffId,ClientId) values (@StaffId,@ClientID);
		--	end
		
		--Commented by saurav Pande w.r.t task #14
		--IF EXISTS (SELECT  *
       --     FROM    sys.objects
       --     WHERE   OBJECT_ID = OBJECT_ID(N'[scsp_UpdateNewClientsFinanciallyResponsible]')
       --             AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
       --             BEGIN
	--	exec scsp_UpdateNewClientsFinanciallyResponsible @ClientID
	--	END		
	
		--End here
		
		select @ClientID as ClientId;
		------ Calling for Creating patient portal Staff  
		IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   OBJECT_ID = OBJECT_ID(N'[ssp_SCCreationofPatientStaff]')
                    AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
                    BEGIN
			 EXEC [dbo].ssp_SCCreationofPatientStaff @ClientID
		 END
   return;
        END     
        
  declare @customveteranscount int
       
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomVeteransInformation]'))
begin
set @customveteranscount  = (select count(*) from CustomVeteransInformation where ClientId = @ClientID)
       if(@customveteranscount = 0)
       begin
       insert into CustomVeteransInformation  (ClientId ) values (@ClientID)    
       end
end
--Added By Varinder Verma 15-Feb-2013 Ref the task #2736  Thresholds - Bugs/Features (Offshore). 
   declare @CustomStateReportingcount int  

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomStateReporting]'))  
begin  
set @CustomStateReportingcount  = (select count(*) from CustomStateReporting where ClientId = @ClientID)  
       if(@CustomStateReportingcount = 0)  
       begin  
       insert into CustomStateReporting  (ClientId ) values (@ClientID)      
       end  
end       
-----End 

               
--Clients                                                                                                                         
    SELECT Top 1 C.ClientId ,
            C.ExternalClientId ,
            C.Active ,
            C.MRN ,
            C.LastName ,
            C.FirstName ,
            C.MiddleName ,
            C.Prefix ,
            C.Suffix ,
            C.SSN ,
            SUBSTRING(C.SSN, 6, 9) AS ShortSSN ,
            CONVERT(VARCHAR(5), DATEDIFF(YEAR, C.DOB, GETDATE()) - 1) + ' Years' AS Age ,
            C.Sex ,
            C.DOB ,
            C.PrimaryClinicianId ,
            C.CountyOfResidence ,
            C.CountyOfTreatment ,
            C.CorrectionStatus ,
            C.Email ,
            C.Comment ,
            C.LivingArrangement ,
            C.NumberOfBeds ,
            C.MinimumWage ,
            C.FinanciallyResponsible ,
            C.AnnualHouseholdIncome ,
            C.NumberOfDependents ,
            C.MaritalStatus ,
            C.EmploymentStatus ,
            C.EmploymentInformation ,
            C.MilitaryStatus ,
            C.EducationalStatus ,
            C.DoesNotSpeakEnglish ,
            C.PrimaryLanguage ,
            C.CurrentEpisodeNumber ,
            C.AssignedAdminStaffId ,
            C.InpatientCaseManager ,
            C.InformationComplete ,
            C.PrimaryProgramId ,
            C.LastNameSoundex ,
            C.FirstNameSoundex ,
            C.CurrentBalance ,
            C.CareManagementId ,
            C.HispanicOrigin ,
            C.DeceasedOn ,
            C.LastStatementDate ,
            C.LastPaymentId ,
            C.LastClientStatementId ,
            C.DoNotSendStatement ,
            C.DoNotSendStatementReason ,
            C.AccountingNotes ,
            C.MasterRecord ,
            C.ProviderPrimaryClinicianId ,
            C.RowIdentifier ,
            C.ExternalReferenceId ,
            C.CreatedBy ,
            C.DoNotOverwritePlan ,
            C.Disposition ,
            C.NoKnownAllergies ,
            C.CreatedDate ,
            C.ModifiedBy ,
            C.ModifiedDate ,
            C.RecordDeleted ,
            C.DeletedDate ,
            C.DeletedBy ,
            C.ReminderPreference,
            C.MobilePhoneProvider,
			C.SchedulingPreferenceMonday,
			C.SchedulingPreferenceTuesday,
			C.SchedulingPreferenceWednesday,
			C.SchedulingPreferenceThursday,
			C.SchedulingPreferenceFriday,
			C.GeographicLocation,
			C.SchedulingComment,
			C.CauseofDeath,
			C.FosterCareLicence,
			C.PrimaryPhysicianId,
			C.UserStaffId, 
			-- Aug 28 2014  Veena S Mani    Added below 4 columns.
			C.AllergiesLastReviewedBy,
			C.AllergiesLastReviewedDate,
			C.AllergiesReviewStatus,
			C.HasNoMedications,
			C.ProfessionalSuffix,
			-- Added By Vichee 19/10/2015
			C.ClientType,			
			C.OrganizationName ,
			C.EIN,
			SUBSTRING(C.EIN, 6, 9) AS ShortEIN 
			 -- end by Vichee
	  ,Ltrim(Rtrim(Ct.CountyName)) + ' - ' + St.StateAbbreviation as CountyOfResidenceText
       ,Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation as CountyOfTreatmentText
       ,C.GenderIdentity
       ,C.SexualOrientation
       -- 10 Feb 2017	Vithobha
       ,C.InternalCollections
		,C.ExternalCollections
	   ,C.SchedulingPreferenceSaturday
	   ,C.SchedulingPreferenceSunday
	   --07 Feb 2018 Vandana
	   ,C.PreferredGenderPronoun
    FROM    Clients C      
left join Counties Ct on Ct.CountyFIPS = C.CountyOfResidence 
left join Counties CF on CF.CountyFIPS = C.CountyOfTreatment  
left join States St on St.StateFIPs = Ct.StateFIPs
left join States Ss on Ss.StateFIPs = CF.StateFIPs                              
WHERE     (ClientId = @ClientID) AND (C.RecordDeleted IS NULL OR                                            
             RecordDeleted = 'N')                                           
--ClientEpisodes                                                                                                                               
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
            CE.ProviderType,							--14.Jul.2017	Alok Kumar
            CE.ProviderId
    FROM    ClientEpisodes AS CE
            LEFT OUTER JOIN GlobalCodes AS GC ON CE.Status = GC.GlobalCodeId
    WHERE   ( CE.ClientId = @ClientID )
            AND ( CE.RecordDeleted IS NULL
                  OR CE.RecordDeleted = 'N'
                )                                            
	ORDER BY CE.EpisodeNumber ASC
     ------------------------30 Jan 2018	Kavya  ------------------------
           IF EXISTS (SELECT  *    
            FROM    sys.objects    
            WHERE   OBJECT_ID = OBJECT_ID(N'[scsp_ClientInformationEpisodeDischarge]')    
                    )     
                    BEGIN   
 EXEC [scsp_ClientInformationEpisodeDischarge] @ClientID
 END
          
    ----------------- END-------------------------------------                                 
                                                                   
--ClientPhones                                                                                                                       
    SELECT  ClientPhones.ClientPhoneId ,
            ClientPhones.ClientId ,
            ClientPhones.PhoneType ,
            ClientPhones.PhoneNumber ,
            ClientPhones.PhoneNumberText ,
            ClientPhones.IsPrimary ,
            ClientPhones.DoNotContact ,
            ClientPhones.RowIdentifier ,
            ClientPhones.ExternalReferenceId ,
            ClientPhones.CreatedBy ,
            ClientPhones.CreatedDate ,
            ClientPhones.ModifiedBy ,
            ClientPhones.ModifiedDate ,
            ClientPhones.RecordDeleted ,
            ClientPhones.DeletedDate ,
            ClientPhones.DeletedBy ,
            GlobalCodes.SortOrder ,
            ClientPhones.DoNotLeaveMessage		-- 09.Jun.2016	Alok Kumar
    FROM    ClientPhones
            INNER JOIN GlobalCodes ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId
    WHERE   ( ClientPhones.ClientId = @ClientID )
            AND ( ISNULL(ClientPhones.RecordDeleted, 'N') = 'N' )
            AND ( GlobalCodes.Active = 'Y' )
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )                                                                                           
                                          
--ClientAddresses                                               
    SELECT  ClientAddresses.ClientAddressId ,
            ClientAddresses.ClientId ,
            ClientAddresses.AddressType ,
            ClientAddresses.Address ,
            ClientAddresses.City ,
            ClientAddresses.State ,
            ClientAddresses.Zip ,
            ClientAddresses.Display ,
            ClientAddresses.Billing ,
            ClientAddresses.RowIdentifier ,
            ClientAddresses.ExternalReferenceId ,
            ClientAddresses.CreatedBy ,
            ClientAddresses.CreatedDate ,
            ClientAddresses.ModifiedBy ,
            ClientAddresses.ModifiedDate ,
            ClientAddresses.RecordDeleted ,
            ClientAddresses.DeletedDate ,
            ClientAddresses.DeletedBy ,
            GlobalCodes.SortOrder
    FROM    ClientAddresses
            INNER JOIN GlobalCodes ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId
    WHERE   ( ClientAddresses.ClientId = @ClientID )
            AND ( ISNULL(ClientAddresses.RecordDeleted, 'N') = 'N' )
            AND ( GlobalCodes.Active = 'Y' )
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )                      
                                                                   
--ClientContacts                                                                                                                      
-- Select query added on 18th April '08 (originally modified by Priya on 2nd April '08) - the order is changed and the field Sex has been renamed from SEX to Sex                                                                            
--(because in the  dataset there were two fields with name Sex)                                                                                            
    SELECT  'D' AS 'DeleteButton' ,
            'N' AS 'RadioButton' ,
            ClientContacts.ClientContactId ,
            ClientContacts.ClientId ,
            ClientContacts.LastName + ', ' + ClientContacts.FirstName AS Contact ,
            GlobalCodes.CodeName ,
            GlobalCodes.CodeName AS RelationshipText ,
            ( SELECT TOP ( 1 )
                        PhoneNumber
              FROM      ClientContactPhones
              WHERE     ( ClientContactId = ClientContacts.ClientContactId )
                        AND ( PhoneNumber IS NOT NULL )
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' )
              ORDER BY  PhoneType
            ) AS PhoneNumber , -- 14 Aug 2017	Rahul Kulkarni
            ClientContacts.Organization ,
            ClientContacts.SSN ,
            ClientContacts.Sex ,
            ClientContacts.Guardian ,
            CASE WHEN ClientContacts.Guardian = 'N' THEN 'No'
                 WHEN ClientContacts.Guardian = 'Y' THEN 'Yes'
            END AS [GuardianText] ,
            ClientContacts.EmergencyContact ,
            ClientContacts.FinanciallyResponsible ,
            ClientContacts.DOB ,
            ClientContacts.ListAs ,
            ClientContacts.Email ,
            ( SELECT TOP ( 1 )
                        Address
              FROM      ClientContactAddresses
              WHERE     ( ClientContactId = ClientContacts.ClientContactId )
                        AND ( Address IS NOT NULL )
              ORDER BY  AddressType
            ) AS Address ,
            ClientContacts.Comment ,
            ClientContacts.Relationship ,
            ClientContacts.FirstName ,
            ClientContacts.LastName ,
            ClientContacts.MiddleName ,
            ClientContacts.Prefix ,
            ClientContacts.Suffix , 
                      --ClientContacts.RowIdentifier, ClientContacts.ExternalReferenceId,
            ClientContacts.CreatedBy ,
            ClientContacts.CreatedDate ,
            ClientContacts.ModifiedBy ,
            ClientContacts.ModifiedDate ,
            ClientContacts.RecordDeleted ,
            ClientContacts.DeletedDate ,
            ClientContacts.DeletedBy,
            LastNameSoundex,
            FirstNameSoundex,
            ClientContacts.HouseholdMember,
			ClientContacts.CareTeamMember,
	        ClientContacts.MailingName,
			ClientContacts.AssociatedClientId,
        CASE 
		WHEN ClientContacts.CareTeamMember = 'N'
			THEN 'No'
		WHEN ClientContacts.CareTeamMember = 'Y'
			THEN 'Yes'
		END AS [CareTeamMemberText],


           -- isnull(ClientContacts.Active, 'Y') as 'Active',
            ClientContacts.Active as 'Active',
            CASE WHEN ClientContacts.EmergencyContact ='N' THEN 'No' WHEN  ClientContacts.EmergencyContact = 'Y' THEN 'Yes' END  AS [EmergencyText],
            CASE WHEN ClientContacts.FinanciallyResponsible ='N' THEN 'No' WHEN  ClientContacts.FinanciallyResponsible = 'Y' THEN 'Yes' END  AS [FinResponsibleText],
            CASE WHEN ClientContacts.HouseholdMember ='N' THEN 'No' WHEN  ClientContacts.HouseholdMember = 'Y' THEN 'Yes' END  AS [HouseholdNumberText],                               
            CASE WHEN ClientContacts.Active ='N' THEN 'No' WHEN  ClientContacts.Active = 'Y' THEN 'Yes' END  AS [ActiveText]
            ,ProfessionalSuffix
    FROM    ClientContacts
            LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship
                                      AND ISNULL(GlobalCodes.RecordDeleted,
                                                 'N') <> 'Y'
                                      AND ((GlobalCodes.Category = 'RELATIONSHIP')  OR (GlobalCodes.Category = 'OrganizationRelation')) --Added by Vichee10292015
    WHERE   ( ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y' )
            AND ( ClientContacts.ClientId = @ClientID )                                           
                                                       
--clientcontactphones                                                                                                                       
    SELECT  ClientContactPhones.ContactPhoneId ,
            ClientContactPhones.ClientContactId ,
            ClientContactPhones.PhoneType ,
            ClientContactPhones.PhoneNumber ,
            ClientContactPhones.PhoneNumberText ,
            ClientContactPhones.RowIdentifier ,
            ClientContactPhones.ExternalReferenceId ,
            ClientContactPhones.CreatedBy ,
            ClientContactPhones.CreatedDate ,
            ClientContactPhones.ModifiedBy ,
            ClientContactPhones.ModifiedDate ,
            ClientContactPhones.RecordDeleted ,
            ClientContactPhones.DeletedDate ,
            ClientContactPhones.DeletedBy ,
            GlobalCodes.SortOrder
    FROM    ClientContactPhones
            INNER JOIN ClientContacts ON ClientContacts.ClientContactId = ClientContactPhones.ClientContactId
                                         AND ClientContacts.ClientId = @ClientID
                                         AND ISNULL(ClientContacts.RecordDeleted,
                                                    'N') = 'N'
            INNER JOIN GlobalCodes ON ClientContactPhones.PhoneType = GlobalCodes.GlobalCodeId
    WHERE   ( ISNULL(ClientContactPhones.RecordDeleted, 'N') = 'N' )
            AND ( GlobalCodes.Active = 'Y' )
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )                                           
                                                                                                                      
--ClientContactaddresses                                                                                                              
    SELECT  ClientContactAddresses.ContactAddressId ,
            ClientContactAddresses.ClientContactId ,
            ClientContactAddresses.AddressType ,
            ClientContactAddresses.Address ,
            ClientContactAddresses.City ,
            ClientContactAddresses.State ,
            ClientContactAddresses.Zip ,
            ClientContactAddresses.Display ,
            ClientContactAddresses.Mailing ,
            ClientContactAddresses.RowIdentifier ,
            ClientContactAddresses.ExternalReferenceId ,
            ClientContactAddresses.CreatedBy ,
            ClientContactAddresses.CreatedDate ,
            ClientContactAddresses.ModifiedBy ,
            ClientContactAddresses.ModifiedDate ,
            ClientContactAddresses.RecordDeleted ,
            ClientContactAddresses.DeletedDate ,
            ClientContactAddresses.DeletedBy ,
            GlobalCodes.SortOrder
    FROM    ClientContactAddresses
            INNER JOIN ClientContacts ON ClientContacts.ClientContactId = ClientContactAddresses.ClientContactId
                                         AND ClientContacts.ClientId = @ClientID
                                         AND ISNULL(ClientContacts.RecordDeleted,
                                                    'N') = 'N'
            INNER JOIN GlobalCodes ON ClientContactAddresses.AddressType = GlobalCodes.GlobalCodeId
    WHERE   ( ISNULL(ClientContactAddresses.RecordDeleted, 'N') = 'N' )
            AND ( GlobalCodes.Active = 'Y' )
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )                                          
                                          
                                          
-- ClientHospitalizations                
    SELECT  HospitalizationId ,
            ClientId ,
            PreScreenDate ,
            ThreeHourDisposition ,
            CASE ThreeHourDisposition
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              --modified by manjup on 18/mar/2014 - customization bugs #681  
              WHEN 'NR' THEN 'Not Reportable'
              ELSE ''
            END AS ThreeHourDispositionText ,
            PerformedBy ,
            Hospitalized ,
            CASE Hospitalized
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS HospitalizedText ,
            Hospital ,
            HospitalText ,
            AdmitDate ,
            DischargeDate ,
            SystemSevenDayFollowUp ,
            CASE SystemSevenDayFollowUp
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS SystemSevenDayFollowUpText ,
            SevenDayFollowUp ,
            CASE SevenDayFollowUp
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS SevenDayFollowUpText ,
            DxCriteriaMet ,
            CASE DxCriteriaMet
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS DxCriteriaMetText ,
            CancellationOrNoShow ,
            CASE CancellationOrNoShow
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS CancellationOrNoShowText ,
            ClientRefusedService ,
            FollowUpException ,
            FollowUpExceptionReason ,
            Comment ,
            ClientWasTransferred ,
            CASE ClientWasTransferred
              WHEN 'N' THEN 'No'
              WHEN 'Y' THEN 'Yes'
              ELSE ''
            END AS ClientWasTransferredText ,
            DeclinedServicesReason ,
            RowIdentifier ,
            ExternalReferenceId ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate ,
            RecordDeleted ,
            DeletedDate ,
            DeletedBy,
            ClientCMHSPPIHPServices
    FROM    ClientHospitalizations
            LEFT OUTER JOIN ( SELECT    s.SiteId ,
                                        CASE WHEN ISNULL(s.SiteName, '') = ''
                                             THEN RTRIM(p.ProviderName)
                                             ELSE RTRIM(p.ProviderName)
                                                  + ' - ' + LTRIM(s.SiteName)
                                        END AS HospitalText
                              FROM      Providers p
                                        LEFT OUTER  JOIN Sites s ON p.ProviderID = s.ProviderID
                                                              AND ISNULL(s.RecordDeleted,
                                                              'N') = 'N'
                            ) AS Hospital ON ClientHospitalizations.Hospital = Hospital.SiteId
    WHERE   ( ClientId = @ClientID )
            AND ( RecordDeleted IS NULL
                  OR RecordDeleted = 'N'
                )                               
                              
                                   
--ClientCoverageReports                                          
    SELECT  cch.ClientCoverageHistoryId AS ClientCoverageId ,
            cch.StartDate ,
            cch.EndDate ,
            cp.CoveragePlanName ,
            ccp.InsuredId ,
            ccp.GroupNumber ,
            '' AS AuthorizationRequired ,
            ccp.PlanContactPhone AS ContactPhone ,
            ccp.ClientId ,
            cch.COBOrder AS Priority ,
            cp.MedicaidPlan AS Medicaid ,
            cch.CreatedBy ,
            cch.CreatedDate ,
            cch.ModifiedBy ,
            cch.ModifiedDate ,
            cch.RecordDeleted ,
            cch.DeletedDate ,
            cch.DeletedBy
    FROM    ClientcoveragePlans AS ccp
            JOIN CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
            JOIN ClientCoverageHistory AS cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
    WHERE   ccp.ClientId = @ClientId
            AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
            AND ( cch.EndDate IS NULL
                  OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
                )
            AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
            AND ISNULL(cch.RecordDeleted, 'N') = 'N'
    ORDER BY cch.StartDate DESC ,
            Priority                                           
                                          
                                          
-- CustomTimeliness                                                                        
    SELECT  ClientEpisodeId ,
            ServicePopulationMI ,
            ServicePopulationDD ,
            ServicePopulationSUD ,
            ServicePopulationMIManualOverride ,
            ServicePopulationDDManualOverride ,
            ServicePopulationSUDManualOverride ,
            ServicePopulationMIManualDetermination ,
            ServicePopulationDDManualDetermination ,
            ServicePopulationSUDManualDetermination ,
            DiagnosticCategory ,
            SystemDateOfInitialRequest ,
            SystemDateOfInitialAssessment ,
            SystemDaysRequestToAssessment ,
            ManualDateOfInitialRequest ,
            ManualDateOfInitialAssessment ,
            ManualDaysRequestToAssessment ,
            InitialStatus ,
            InitialReason ,
            SystemDateOfTreatment ,
            SystemDaysAssessmentToTreatment ,
            SystemTreatmentServiceId ,
            SystemInitialAssessmentServiceId ,
            ManualDateOfTreatment ,
            ManualDaysAssessmentToTreatment ,
            OnGoingStatus ,
            OnGoingReason ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate ,
            RecordDeleted ,
            DeletedDate ,
            DeletedBy
    FROM    CustomTimeliness
    WHERE   ( ClientEpisodeId IN (
              SELECT    ClientEpisodeId
              FROM      ClientEpisodes
              WHERE     ( ClientId = @ClientId )
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' ) ) )
            AND ( ISNULL(RecordDeleted, 'N') = 'N' )                                          
                                          
                                        
                                          
--ClientFinancialSummaryReports                                                                     
    SELECT  ClientId ,
            CoverageBalanceCurrent ,
            CoverageBalance30 ,
            CoverageBalance90 ,
            CoverageBalance180 ,
            CoverageBalanceTotal ,
            ClientBalanceCurrent ,
            ClientBalance30 ,
            ClientBalance90 ,
            ClientBalance180 ,
            ClientBalanceTotal ,
            ClientLastPaymentAmount ,
            ClientLastPaymentDate ,
            FeeArrangement ,
            Comment ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate ,
            RecordDeleted ,
            DeletedDate ,
            DeletedBy
    FROM    ClientFinancialSummaryReports
    WHERE   ( ClientId = @ClientID )
            AND ( RecordDeleted IS NULL
                  OR RecordDeleted = 'N'
                )                                          
                                        
                                          
--ClientRaces                                          
    SELECT  ClientRaceId ,
            ClientId ,
            RaceId ,
            RowIdentifier ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate ,
            RecordDeleted ,
            DeletedDate ,
            DeletedBy
    FROM    ClientRaces
    WHERE   ( ClientId = @ClientID )
            AND ( RecordDeleted IS NULL
                  OR RecordDeleted = 'N'
                )                                             
                   
--ClientInformationReleases                                          
    SELECT  CASE WHEN ( SELECT  COUNT(*)
                        FROM    ClientInformationReleaseDocuments
                                INNER JOIN ClientInformationReleases AS CIR ON ClientInformationReleaseDocuments.ClientInformationReleaseId = CIR.ClientInformationReleaseId
                        WHERE   ( CIR.ClientInformationReleaseId = CIR.ClientInformationReleaseId )
                                AND ( ISNULL(ClientInformationReleaseDocuments.RecordDeleted,
                                             'N') = 'N' )
                      ) > 1 THEN 'Multiple Documents'
                 ELSE ( SELECT  DocumentCodes.DocumentName
                        FROM    DocumentCodes
                                INNER JOIN Documents ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId
                                INNER JOIN ClientInformationReleaseDocuments ON Documents.DocumentId = ClientInformationReleaseDocuments.DocumentId
                                INNER JOIN ClientInformationReleases AS CIR ON ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId = CIR.ClientInformationReleaseId
                        WHERE   ClientInformationReleaseDocuments.ClientInformationReleaseId = ClientInformationReleases.ClientInformationReleaseId
                                AND ISNULL(ClientInformationReleaseDocuments.RecordDeleted,
                                           'N') = 'N'
                      )
            END AS 'ReleaseDocuments' ,
            ClientInformationReleases.[ClientInformationReleaseId] ,
            ClientInformationReleases.[ClientId] ,
            ClientInformationReleases.[ReleaseToId] ,
            ClientInformationReleases.[ReleaseToName] ,
            CASE WHEN ClientInformationReleases.[StartDate] IS NOT NULL
                 THEN CONVERT(VARCHAR, ClientInformationReleases.[StartDate], 101)
            END AS [StartDate] ,
            CASE WHEN ClientInformationReleases.[EndDate] IS NOT NULL
                 THEN CONVERT(VARCHAR, ClientInformationReleases.[EndDate], 101)
            END AS [EndDate] ,
            ClientInformationReleases.[Comment] ,
            ClientInformationReleases.[DocumentAttached] ,
            ClientInformationReleases.[RowIdentifier] ,
            ClientInformationReleases.[CreatedBy] ,
            ClientInformationReleases.[CreatedDate] ,
            ClientInformationReleases.[ModifiedBy] ,
            ClientInformationReleases.[ModifiedDate] ,
            ClientInformationReleases.[RecordDeleted] ,
            ClientInformationReleases.[DeletedDate] ,
            ClientInformationReleases.[DeletedBy],
            ClientInformationReleases.Remind,
            ClientInformationReleases.DaysBeforeEndDate
            ,Locked
			,LockedBy  
			,LockedDate 
    FROM    ClientInformationReleases
    WHERE   ISNULL(ClientInformationReleases.RecordDeleted, 'N') <> 'Y'
            AND ClientInformationReleases.ClientId = @ClientId                                         
                                        
                                       
--ClientInformationReleaseDocuments                                           
    SELECT  ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId ,
            ClientInformationReleaseDocuments.ClientInformationReleaseId ,
            Documents.DocumentId ,
            DocumentCodes.DocumentCodeId ,
            DV.DocumentVersionId AS [Version] ,
            DocumentCodes.DocumentName  --DV.Version                                                          
            ,
            CASE WHEN Documents.EffectiveDate IS NOT NULL
                 THEN CONVERT(VARCHAR, Documents.EffectiveDate, 101)
            END AS [EffectiveDate] ,
            gcs.CodeName AS [Status] ,
            CASE WHEN ( st.LastName + ', ' + st.FirstName ) IS NOT NULL
                 THEN ( st.LastName + ', ' + st.FirstName )
            END AS AuthorName ,
            ClientInformationReleaseDocuments.[RowIdentifier] ,
            ClientInformationReleaseDocuments.[CreatedBy] ,
            ClientInformationReleaseDocuments.[CreatedDate] ,
            ClientInformationReleaseDocuments.[ModifiedBy] ,
            ClientInformationReleaseDocuments.[ModifiedDate] ,
            ClientInformationReleaseDocuments.[RecordDeleted] ,
            ClientInformationReleaseDocuments.[DeletedDate] ,
            ClientInformationReleaseDocuments.[DeletedBy] ,
            'true' AS AddButtonEnabled
    FROM    ClientInformationReleaseDocuments
            INNER JOIN ClientInformationReleases ON ClientInformationReleases.ClientInformationReleaseId = ClientInformationReleaseDocuments.ClientInformationReleaseId
                                                    AND ISNULL(ClientInformationReleases.RecordDeleted,
                                                              'N') = 'N'
            INNER JOIN Documents ON ClientInformationReleaseDocuments.DocumentId = Documents.DocumentId
            INNER JOIN DocumentVersions AS DV ON DV.DocumentId = Documents.DocumentId
                                                 AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId
            INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeId = Documents.DocumentCodeId
            INNER JOIN GlobalCodes AS gcs ON gcs.GlobalCodeId = Documents.Status
            INNER JOIN Staff AS st ON st.StaffId = Documents.AuthorId
    WHERE   ISNULL(ClientInformationReleaseDocuments.RecordDeleted, 'N') = 'N'
            AND ClientInformationReleases.ClientId = @ClientId                                               
                                          
--ClientCoveragePlans                                                
    SELECT TOP ( 1 )
            ClientCoveragePlans.CoveragePlanId ,
            ClientCoveragePlans.InsuredId ,
            ClientCoveragePlans.ClientId ,
            ClientCoveragePlans.ClientCoveragePlanId ,
            ClientCoverageHistory.COBOrder
    FROM    ClientCoveragePlans
            INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId
            INNER JOIN ClientCoverageHistory ON ClientCoveragePlans.ClientCoveragePlanId = ClientCoverageHistory.ClientCoveragePlanId
    WHERE   ( CoveragePlans.MedicaidPlan = 'Y' )
            AND ( CoveragePlans.RecordDeleted = 'N'
                  OR CoveragePlans.RecordDeleted IS NULL
                )
            AND ( ClientCoveragePlans.RecordDeleted = 'N'
                  OR ClientCoveragePlans.RecordDeleted IS NULL
                )
            AND ( ClientCoverageHistory.RecordDeleted = 'N'
                  OR ClientCoverageHistory.RecordDeleted IS NULL
                )
            AND ( ClientCoverageHistory.StartDate <= GETDATE() )
            AND ( GETDATE() <= ClientCoverageHistory.EndDate )
            AND ( ClientCoveragePlans.ClientId = @ClientId )
            OR ( CoveragePlans.MedicaidPlan = 'Y' )
            AND ( CoveragePlans.RecordDeleted = 'N'
                  OR CoveragePlans.RecordDeleted IS NULL
                )
            AND ( ClientCoveragePlans.RecordDeleted = 'N'
                  OR ClientCoveragePlans.RecordDeleted IS NULL
                )
            AND ( ClientCoverageHistory.RecordDeleted = 'N'
                  OR ClientCoverageHistory.RecordDeleted IS NULL
                )
            AND ( ClientCoverageHistory.StartDate <= GETDATE() )
            AND ( ClientCoveragePlans.ClientId = @ClientId )
            AND ( ClientCoverageHistory.EndDate IS NULL )
    ORDER BY ClientCoverageHistory.COBOrder                                          
                                                                                                         
----ClientAliases                                                                                              
                                                                                                      
--SELECT     ClientAliasId, ClientId, LastName, FirstName, MiddleName, AliasType, AllowSearch, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                           
--                      DeletedDate, DeletedBy                           
--FROM         ClientAliases                                          
--WHERE     (ClientId = @ClientId) AND (RecordDeleted = 'N' OR                                          
--                      RecordDeleted IS NULL)                                     
  
 --ClientAliases  
    SELECT  [ClientAliasId] ,
            [ClientId] ,
            [LastName] ,
            [FirstName] ,
            [MiddleName] ,
            [AliasType] ,
            [AllowSearch]  
      --,CA.[RowIdentifier]  
            ,
            CA.[CreatedBy] ,
            CA.[CreatedDate] ,
            CA.[ModifiedBy] ,
            CA.[ModifiedDate] ,
            CA.[RecordDeleted] ,
            CA.[DeletedDate] ,
            CA.[DeletedBy] ,
            gc.CodeName AS AliasTypeText ,
            CASE CA.AllowSearch
              WHEN 'Y' THEN 'Yes'
              WHEN 'N' THEN 'No'
            END AS AllowSearchText ,
            LastNameSoundex ,
            FirstNameSoundex
    FROM    [ClientAliases] CA
            JOIN GlobalCodes gc ON CA.AliasType = gc.GlobalCodeId
    WHERE   ( CA.ClientId = @ClientId )
            AND ( CA.RecordDeleted = 'N'
                  OR CA.RecordDeleted IS NULL
                )                                                                 
                                                                                                              
                                                                                                       
 --CustomStateReporting                              
    SELECT  ClientId ,
            AdoptionStudy ,
            SSI ,
            ParentofYoungChild ,
            ChildFIAAbuse ,
            ChildFIAOther ,
            EarlyOnProgram ,
            WrapAround ,
            EPSDT ,
            IndividualNotEnrolledOrEligibleForPlan ,
            ProgramOrPlanNotListed ,
            HealthInformationDate ,
            AbilityToHear ,
            HearingAid ,
            AbilitytoSee ,
            VisualAppliance ,
            Pneumonia ,
            Asthma ,
            UpperRespiratory ,
            Gastroesophageal ,
            ChronicBowel ,
            SeizureDisorder ,
            NeurologicalDisease ,
            Diabetes ,
            Hypertension ,
            Obesity ,
            DDInformationDate ,
            CommunicationStyle ,
            MakeSelfUnderstood ,
            SupportWithMobility ,
            NutritionalIntake ,
            SupportPersonalCare ,
            Relationships ,
            FamilyFriendSupportSystem ,
            SupportForChallengingBehaviors ,
            BehaviorPlanPresent ,
            NumberOfAntiPsychoticMedications ,
            NumberOfOtherPsychotropicMedications ,
            MajorMentalIllness ,
            ModifiedBy ,
            ModifiedDate ,
            CreatedBy ,
            CreatedDate,
           -- RowIdentifier 
           -- Added by Hussain Khusro on 10/22/2014
            RecordDeleted,  
            DeletedDate,  
            DeletedBy  
            --End-----
    FROM    CustomStateReporting
    WHERE   ( ClientId = @ClientId )
            AND ( ISNULL(RecordDeleted, 'N') = 'N' )                          
                             
                          
                                          
--QIProgramPlan                                                      
    EXEC scsp_ClientInformationQIProgramPlan @ClientID                            
                                                         
--CustomCAFAS                                              
      EXEC scsp_ClientInformationQICafas @ClientID                                                                                      
                                          
--CustomDDAssessment                                          
    --EXEC csp_ClientInformationQIDDReporting @ClientID                                         
    /*Custom Field Data are commented By Rahul Aneja on 28 August 2012 */
  /*Remove Hard Code Custom Field Data Table For The CLient Information as this is implemented on architecture to get the data*/                                                                           
 /*                                                                        
    SELECT  [CustomFieldsDataId] ,
            [DocumentType] ,
            [DocumentCodeId] ,
            [PrimaryKey1] ,
            [PrimaryKey2] ,
            [ColumnVarchar1] ,
            [ColumnVarchar2] ,
            [ColumnVarchar3] ,
            [ColumnVarchar4] ,
            [ColumnVarchar5] ,
            [ColumnVarchar6] ,
            [ColumnVarchar7] ,
            [ColumnVarchar8] ,
            [ColumnVarchar9] ,
            [ColumnVarchar10] ,
            [ColumnVarchar11] ,
            [ColumnVarchar12] ,
            [ColumnVarchar13] ,
            [ColumnVarchar14] ,
            [ColumnVarchar15] ,
            [ColumnVarchar16] ,
            [ColumnVarchar17] ,
            [ColumnVarchar18] ,
            [ColumnVarchar19] ,
            [ColumnVarchar20] ,
            [ColumnText1] ,
            [ColumnText2] ,
            [ColumnText3] ,
            [ColumnText4] ,
            [ColumnText5] ,
            [ColumnText6] ,
            [ColumnText7] ,
            [ColumnText8] ,
            [ColumnText9] ,
            [ColumnText10] ,
            [ColumnInt1] ,
            [ColumnInt2] ,
            [ColumnInt3] ,
            [ColumnInt4] ,
            [ColumnInt5] ,
            [ColumnInt6] ,
            [ColumnInt7] ,
            [ColumnInt8] ,
            [ColumnInt9] ,
            [ColumnInt10] ,
            [ColumnDatetime1] ,
            [ColumnDatetime2] ,
            [ColumnDatetime3] ,
            [ColumnDatetime4] ,
            [ColumnDatetime5] ,
            [ColumnDatetime6] ,
            [ColumnDatetime7] ,
            [ColumnDatetime8] ,
            [ColumnDatetime9] ,
            [ColumnDatetime10] ,
            [ColumnDatetime11] ,
            [ColumnDatetime12] ,
            [ColumnDatetime13] ,
            [ColumnDatetime14] ,
            [ColumnDatetime15] ,
            [ColumnDatetime16] ,
            [ColumnDatetime17] ,
            [ColumnDatetime18] ,
            [ColumnDatetime19] ,
            [ColumnDatetime20] ,
            [ColumnGlobalCode1] ,
            [ColumnGlobalCode2] ,
            [ColumnGlobalCode3] ,
            [ColumnGlobalCode4] ,
            [ColumnGlobalCode5] ,
            [ColumnGlobalCode6] ,
            [ColumnGlobalCode7] ,
            [ColumnGlobalCode8] ,
            [ColumnGlobalCode9] ,
            [ColumnGlobalCode10] ,
            [ColumnGlobalCode11] ,
            [ColumnGlobalCode12] ,
            [ColumnGlobalCode13] ,
            [ColumnGlobalCode14] ,
            [ColumnGlobalCode15] ,
            [ColumnGlobalCode16] ,
            [ColumnGlobalCode17] ,
            [ColumnGlobalCode18] ,
            [ColumnGlobalCode19] ,
            [ColumnGlobalCode20] ,
            [ColumnMoney1] ,
            [ColumnMoney2] ,
            [ColumnMoney3] ,
            [ColumnMoney4] ,
            [ColumnMoney5] ,
            [ColumnMoney6] ,
            [ColumnMoney7] ,
            [ColumnMoney8] ,
            [ColumnMoney9] ,
            [ColumnMoney10] ,
            [RowIdentifier] ,
            [CreatedBy] ,
            [CreatedDate] ,
            [ModifiedBy] ,
            [ModifiedDate] ,
            [RecordDeleted] ,
            [DeletedDate] ,
            [DeletedBy]
    FROM    [CustomFieldsData]
    WHERE   PrimaryKey1 = @ClientID
            AND DocumentType = 4941   */                   
   
   
 
  
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

 
select ClientContactsAddressHistoryId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,
ClientContactId,
AddressType,
Address,
City,
State,
Zip,
Display,
Mailing from ClientContactsAddressHistory where ClientContactsAddressHistoryId=-1

  SELECT  [FQHCClientDemographicId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientId]
      ,[EntryDate]
      ,[DateofBirth]
      ,[Gender]
      ,[MaritalStaus]
      ,[HispanicOrigin]
      ,[Income]
      ,[IncomePoverty]
      ,[AgriculturalWorker]
      ,[HomelessStatus]
      ,[PublicHousing]
      ,[VeteranStatus]
  FROM [FQHCClientDemographics] 
  WHERE     (ClientId = @ClientID) AND  ISNULL(RecordDeleted, 'N') = 'N'  

SELECT  [FQHCClientRaceId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientId]
      ,[FQHCRaceID]
  FROM [FQHCClientRaces]
    WHERE     (ClientId = @ClientID) AND  ISNULL(RecordDeleted, 'N') = 'N'  
	--Changes By Deej for KCMHSAS 3.5 Implementation #99
	   EXEC scsp_ClientInformationCustomFieldsData @ClientId
	--Changes Ends Here
        
    -- CustomVeteransInformation
  exec scsp_ClientInformationVeteransInfo @ClientId
   
     
--Added the CustomVisitiors table 
 EXEC scsp_ClientInformationCustomVisitors @ClientId


--Added to fetch the SiblingsData
 EXEC scsp_ClientInformationCustomSiblings @ClientId
  
   --Special Rates.      
SELECT C.InsurerId,      
  INS.InsurerName as Insurer,      
  C.ContractName as Contract,      
  BLC.BillingCode as Code,      
  CR.BillingCodeId,      
  CR.ContractRate as Rate,      
  CR.StartDate as [From],      
  CR.EndDate as [To],      
  C.ProviderId,      
  C.ContractId,      
  Case P.ProviderType       
   When 'I' then P.ProviderName + ', ' + P.FirstName       
   When 'F' then P.ProviderName       
  End as ProviderName      
FROM ContractRates CR      
   LEFT OUTER JOIN Contracts C ON C.ContractId = CR.ContractId and Isnull(C.RecordDeleted,'N')<>'Y'      
   LEFT OUTER JOIN Insurers INS on INS.InsurerId = C.InsurerID and Isnull(INS.RecordDeleted,'N')<>'Y'      
   LEFT OUTER JOIN BillingCodes BLC on CR.BillingCodeId= BLC.BillingCodeId and Isnull(BLC.RecordDeleted,'N')<>'Y'            
   INNER JOIN Providers P on P.ProviderId = C.ProviderId and IsNull(P.RecordDeleted,'N')='N'      
         
WHERE CR.ClientId = @ClientID       
  and CR.Active = 'Y'       
  and Isnull(CR.RecordDeleted,'N')<>'Y'        
---For Substance History tab CM---      
    
--Substance Use History    
SELECT         
    CCSUS.ClientSubstanceUseHistoryId,    
 CCSUS.CreatedBy,    
 CCSUS.CreatedDate,    
 CCSUS.ModifiedBy,    
 CCSUS.ModifiedDate,    
 CCSUS.RecordDeleted,    
 CCSUS.DeletedDate,    
 CCSUS.DeletedBy,    
 CCSUS.SUDrugId,    
 CCSUS.AgeOfFirstUse,    
 CCSUS.Frequency,    
 CCSUS.[Route],
 CCSUS.LastUsed,    
 CCSUS.InitiallyPrescribed,    
 CCSUS.Preference,    
 CCSUS.ClientId    
  FROM ClientSubstanceUseHistory CCSUS     
  where (ISNULL(CCSUS.RecordDeleted,'N') <> 'Y' and CCSUS.ClientId = @ClientID) 
   
   
	SELECT ClientId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedDate,
			DeletedBy,
			CurrentLivingArrangement,
			CurrentAddress1,
			CurrentAddress2,
			CurrentCity,
			CurrentState,
			CureentZip,
			CountyOfResidence,
			Race,
			Ethnicity,
			PrimaryLanguage,
			MaritalStatus,
			MilitaryStatus,
			Education,
			CurrentlyInTraining,
			EmploymentStatus,
			EmploymentStatusSpecify,
			TotalAnnualIncome,
			NumberOfDependents
	FROM ClientsSADemographics
	WHERE ISNULL(RecordDeleted,'N') <> 'Y' and ClientId = @ClientID
	
-- Added By Avi Goyal, on 11 Mar 2015 to add Family Tab to Client Info Screen
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
  WHERE     (ClientId = @ClientId) AND  ISNULL(RecordDeleted, 'N') = 'N' 
 
 END TRY                                            
                                                                                                           
 BEGIN CATCH           
                                                                           
		DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PMGetClientInformation')                                                
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