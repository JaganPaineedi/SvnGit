IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCPostSignatureUpdateRegistrations]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCPostSignatureUpdateRegistrations] 

GO 


CREATE PROCEDURE [dbo].[ssp_SCPostSignatureUpdateRegistrations] (@ScreenKeyId      INT, 
                                                       @StaffId          INT, 
                                                       @CurrentUser      VARCHAR (30), 
                                                       @CustomParameters XML) 
AS 
/************************************************************************************/ 
/* Stored Procedure: dbo.[ssp_SCPostSignatureUpdateRegistrations]        */ 
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */ 
/* Creation Date:   12/Jan/2018             */ 
/* Purpose: for post signature update logic for Registrations document*/
/* Input Parameters:  @ScreenKeyId int,@StaffId,@CurrentUse,@CustomParameters       */ 
/* Output Parameters:   None              */ 
/* Return:  0=success, otherwise an error number         */ 
/* Called By:                  */ 
/* Calls:                   */ 
/* Data Modifications:                */ 
/* Updates:                   */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
  /************************************************************************************/ 
  BEGIN 
      BEGIN try 
      
      DECLARE @ClientId int
      Set @ClientId = (Select Top 1 ClientId From Documents Where DocumentId = @ScreenKeyId)
      
      Declare @CurrentDate datetime
      Set @CurrentDate = GETDATE()
      
      
		-- General Tab
		--Updating to Clients Table
		UPDATE C
		SET C.ClientType = DR.ClientType
			,C.SSN = DR.SSN
			,C.PrimaryClinicianId = DR.PrimaryClinicianId
			,C.PrimaryPhysicianId = DR.PrimaryPhysicianId
			,C.Prefix = DR.Prefix
			,C.FirstName = DR.FirstName
			,C.MiddleName = DR.MiddleName
			,C.LastName = DR.LastName
			,C.Suffix = DR.Suffix
			,C.Email = DR.Email
			,C.Active = DR.Active
			,C.ProfessionalSuffix = DR.ProfessionalSuffix
			,C.EIN = DR.EIN
			,C.OrganizationName = DR.OrganizationName
			,C.Comment = DR.Comment
			,C.ModifiedDate = @CurrentDate           
            ,C.ModifiedBy = @CurrentUser 
		FROM Clients  C    
		Inner Join DocumentRegistrations DR ON DR.ClientId = C.ClientId   
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
      
      
      --Setting RecordDeleted = Y in ClientPhones Table
		Update CP
		SET CP.RecordDeleted = 'Y',
            CP.DeletedDate = @CurrentDate,           
            CP.DeletedBy = @CurrentUser                                            
		FROM ClientPhones CP 
		INNER JOIN DocumentRegistrationClientPhones DRCP ON DRCP.ClientId = CP.ClientId AND DRCP.PhoneType = CP.PhoneType
		Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCP.DocumentVersionId   
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CP.RecordDeleted, 'N') = 'N' AND ISNULL(DRCP.RecordDeleted, 'N') = 'N'
		
	   --Inserting in to ClientPhones Table
		INSERT  INTO ClientPhones            
			( CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			ClientId,
			PhoneType,
			PhoneNumber,
			PhoneNumberText,
			IsPrimary,
			DoNotContact,
			--ExternalReferenceId,
			DoNotLeaveMessage )
			
			Select
				@CurrentUser,
				@CurrentDate,
				@CurrentUser,
				@CurrentDate,
				DRCP.ClientId,
				DRCP.PhoneType,
				DRCP.PhoneNumber,
				DRCP.PhoneNumberText,
				DRCP.IsPrimary,
				DRCP.DoNotContact,
				--DRCP.ExternalReferenceId,
				DRCP.DoNotLeaveMessage 
		From DocumentRegistrationClientPhones DRCP 
		Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCP.DocumentVersionId   
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
		AND ISNULL(DRCP.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'

				
	--Setting RecordDeleted = Y in ClientAddresses Table
		Update CA
		SET CA.RecordDeleted = 'Y',
            CA.DeletedDate = @CurrentDate,           
            CA.DeletedBy = @CurrentUser                                            
		FROM ClientAddresses CA 
		INNER JOIN DocumentRegistrationClientAddresses DRCA ON DRCA.ClientId = CA.ClientId AND DRCA.AddressType = CA.AddressType
		Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCA.DocumentVersionId   
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CA.RecordDeleted, 'N') = 'N' AND ISNULL(DRCA.RecordDeleted, 'N') = 'N'		
				
				
	--Inserting in to ClientAddresses Table
		INSERT  INTO ClientAddresses            
		( ClientId,
			AddressType,
			[Address],
			City,
			[State],
			Zip,
			Display,
			Billing,
			--ExternalReferenceId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate )
				
		Select	
			DRCA.ClientId,
			DRCA.AddressType,
			DRCA.ClientAddress,
			DRCA.City,
			DRCA.ClientState,
			DRCA.Zip,
			DRCA.Display,
			DRCA.Billing,
			--ExternalReferenceId,
			@CurrentUser,
			@CurrentDate,
			@CurrentUser,
			@CurrentDate
	From DocumentRegistrationClientAddresses DRCA 
	Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCA.DocumentVersionId   
	Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
	WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
	AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DRCA.RecordDeleted, 'N') = 'N'
		
		
				
      
      
      
      
		-- Demographics Tab
		UPDATE C
		SET C.DOB = DRD.DOB
			--,C.Comment = DRD.Comment
			,C.Sex = DRD.Sex
			,C.MaritalStatus = DRD.MaritalStatus
			,C.GenderIdentity = DRD.GenderIdentity
			,C.SexualOrientation = DRD.SexualOrientation
			,C.DeceasedOn = DRD.DeceasedOn
			,C.CauseofDeath = DRD.CauseofDeath
			,C.ExternalReferralProviderId = DRD.ExternalReferralProviderId
			,C.ClientDoesNotHavePCP = DRD.ClientDoesNotHavePCP
			,C.FinanciallyResponsible = DRD.FinanciallyResponsible
			,C.AnnualHouseholdIncome = DRD.AnnualHouseholdIncome
			,C.NumberOfDependents = DRD.NumberOfDependents
			,C.LivingArrangement = DRD.LivingArrangement
			,C.CountyOfResidence = DRD.CountyOfResidence
			,C.CountyOfTreatment = DRD.CountyOfTreatment
			,C.EducationalStatus = DRD.EducationalStatus
			,C.MilitaryStatus = DRD.MilitaryStatus
			,C.EmploymentStatus = DRD.EmploymentStatus
			,C.EmploymentInformation = DRD.EmploymentInformation
			,C.PrimaryLanguage = DRD.PrimaryLanguage
			,C.DoesNotSpeakEnglish = DRD.DoesNotSpeakEnglish
			,C.HispanicOrigin = DRD.HispanicOrigin
			,C.ReminderPreference = DRD.ReminderPreference
			,C.MobilePhoneProvider = DRD.MobilePhoneProvider
			,C.SchedulingPreferenceMonday = DRD.SchedulingPreferenceMonday
			,C.SchedulingPreferenceTuesday = DRD.SchedulingPreferenceTuesday
			,C.SchedulingPreferenceWednesday = DRD.SchedulingPreferenceWednesday
			,C.SchedulingPreferenceThursday = DRD.SchedulingPreferenceThursday
			,C.SchedulingPreferenceFriday = DRD.SchedulingPreferenceFriday
			,C.GeographicLocation = DRD.GeographicLocation
			,C.SchedulingComment = DRD.SchedulingComment
			,C.PreferredGenderPronoun = DRD.PreferredGenderPronoun
			,C.ModifiedDate = @CurrentDate           
            ,C.ModifiedBy = @CurrentUser 
		FROM Clients  C    
		Inner Join DocumentRegistrations DR on DR.ClientId = C.ClientId
		Inner Join DocumentRegistrationDemographics DRD on DRD.DocumentVersionId = DR.DocumentVersionId    
		Inner Join Documents D ON D.CurrentDocumentVersionId = DRD.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
		AND ISNULL(DRD.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
      
      
      --Setting Active = N in ClientPictures Table
		Update CP
		SET CP.Active = 'N',
			CP.ModifiedDate = @CurrentDate,           
            CP.ModifiedBy = @CurrentUser 
			--CP.RecordDeleted = 'Y',
			--CP.DeletedDate = @CurrentDate,           
			--CP.DeletedBy = @CurrentUser                                            
		FROM ClientPictures CP 
		Inner Join DocumentRegistrations DR ON DR.ClientId = CP.ClientId  
		INNER JOIN DocumentRegistrationClientPictures DRCP ON DR.DocumentVersionId = DRCP.DocumentVersionId  
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CP.RecordDeleted, 'N') = 'N' AND ISNULL(DRCP.RecordDeleted, 'N') = 'N'		
				
				
	--Inserting in to ClientPictures Table
		INSERT  INTO ClientPictures            
		( ClientId,
			UploadedBy,
			UploadedOn,
			PictureFileName,
			Picture,
			Active,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate )
				
		Select	
			D.ClientId,
			DRCP.UploadedBy,
			DRCP.UploadedOn,
			DRCP.PictureFileName,
			DRCP.Picture,
			DRCP.Active,
			@CurrentUser,
			@CurrentDate,
			@CurrentUser,
			@CurrentDate
	From DocumentRegistrationClientPictures DRCP 
	Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCP.DocumentVersionId   
	Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
	WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
	AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DRCP.RecordDeleted, 'N') = 'N'

	
	--Setting RecordDeleted = Y in ClientRaces Table
		Update CR
		SET CR.RecordDeleted = 'Y',
			CR.DeletedDate = @CurrentDate,           
			CR.DeletedBy = @CurrentUser                                            
		FROM ClientRaces CR 
		Inner Join DocumentRegistrations DR ON DR.ClientId = CR.ClientId  
		INNER JOIN DocumentRegistrationClientRaces DRCR ON DR.DocumentVersionId = DRCR.DocumentVersionId  
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CR.RecordDeleted, 'N') = 'N' AND ISNULL(DRCR.RecordDeleted, 'N') = 'N'		
				
				
	--Inserting in to ClientRaces Table
		INSERT  INTO ClientRaces            
		( ClientId,
			RaceId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate )
				
		Select	
			D.ClientId,
			DRCR.RaceId,
			@CurrentUser,
			@CurrentDate,
			@CurrentUser,
			@CurrentDate
	From DocumentRegistrationClientRaces DRCR 
	Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCR.DocumentVersionId   
	Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
	WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
	AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DRCR.RecordDeleted, 'N') = 'N'
	
	
	
	--Setting RecordDeleted = Y in ClientEthnicities Table
		Update CE
		SET CE.RecordDeleted = 'Y',
			CE.DeletedDate = @CurrentDate,           
			CE.DeletedBy = @CurrentUser                                            
		FROM ClientEthnicities CE 
		Inner Join DocumentRegistrations DR ON DR.ClientId = CE.ClientId  
		INNER JOIN DocumentRegistrationClientEthnicities DRCE ON DR.DocumentVersionId = DRCE.DocumentVersionId  
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CE.RecordDeleted, 'N') = 'N' AND ISNULL(DRCE.RecordDeleted, 'N') = 'N'		
				
				
	--Inserting in to ClientEthnicities Table
		INSERT  INTO ClientEthnicities            
		( ClientId,
			EthnicityId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate )
				
		Select	
			D.ClientId,
			DRCE.EthnicityId,
			@CurrentUser,
			@CurrentDate,
			@CurrentUser,
			@CurrentDate
	From DocumentRegistrationClientEthnicities DRCE 
	Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRCE.DocumentVersionId   
	Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
	WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
	AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DRCE.RecordDeleted, 'N') = 'N'
	
	
	
		--Setting RecordDeleted = Y in ClientDemographicInformationDeclines Table
		Update CDID
		SET CDID.RecordDeleted = 'Y',
			CDID.DeletedDate = @CurrentDate,           
			CDID.DeletedBy = @CurrentUser                                            
		FROM ClientDemographicInformationDeclines CDID 
		Inner Join DocumentRegistrations DR ON DR.ClientId = CDID.ClientId  
		INNER JOIN DocumentRegistrationDemographicDeclines DRDD ON DR.DocumentVersionId = DRDD.DocumentVersionId  
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(CDID.RecordDeleted, 'N') = 'N' AND ISNULL(DRDD.RecordDeleted, 'N') = 'N'		
				
				
				
	--Inserting in to ClientDemographicInformationDeclines Table
		INSERT  INTO ClientDemographicInformationDeclines            
		( ClientId,
			ClientDemographicsId,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate )
				
		Select	
			D.ClientId,
			DRDD.ClientDeclinedToProvide,
			@CurrentUser,
			@CurrentDate,
			@CurrentUser,
			@CurrentDate
	From DocumentRegistrationDemographicDeclines DRDD 
	Inner Join DocumentRegistrations DR ON DR.DocumentVersionId = DRDD.DocumentVersionId   
	Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
	WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
	AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DRDD.RecordDeleted, 'N') = 'N'
      
      
      
		
		
		--Insurance Tab
	 --Push the values into ClientCoveragePlanNotes
		IF EXISTS ( SELECT  1 FROM ClientCoveragePlanNotes CC          
							Inner JOIN DocumentRegistrations DR ON CC.ClientId = DR.ClientId
							Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId AND D.DocumentId = @ScreenKeyId 
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(DR.RecordDeleted, 'N') = 'N' And ISNULL(D.RecordDeleted, 'N') = 'N') 
							
			BEGIN
					UPDATE  CC SET CC.CoverageInformation = DR.CoverageInformation
							FROM ClientCoveragePlanNotes CC 
							Inner JOIN DocumentRegistrations DR ON CC.ClientId = DR.ClientId
							Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId AND D.DocumentId = @ScreenKeyId         
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(DR.RecordDeleted, 'N') = 'N' And ISNULL(D.RecordDeleted, 'N') = 'N'
			END
		ELSE
			BEGIN
					INSERT  INTO ClientCoveragePlanNotes          
								( ClientId ,          
								  CoverageInformation    
								)          
							SELECT  D.ClientId ,          
									DR.CoverageInformation       
							FROM    DocumentRegistrations DR 
							Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId AND D.DocumentId = @ScreenKeyId         
							Where ISNULL(DR.RecordDeleted, 'N') = 'N' And ISNULL(D.RecordDeleted, 'N') = 'N'
			END
			
			
		-- Inserting Flag details
		DECLARE @FlagTypeId int 
		SET @FlagTypeId = (SELECT Top 1 FlagTypeId FROM dbo.FlagTypes WHERE FlagType = 'Client Plan Coverage Information')

		IF NOT EXISTS(SELECT 1 FROM dbo.ClientNotes b
									Inner Join dbo.DocumentRegistrations DR on b.ClientId = DR.ClientId 
									Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId AND  b.StartDate = D.EffectiveDate
									--AND DR.CoverageInformation IS NOT NULL
									WHERE D.DocumentId = @ScreenKeyId AND b.NoteType = @FlagTypeId AND ISNULL(D.RecordDeleted, 'N') = 'N'
									  AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(b.RecordDeleted, 'N') = 'N')
		BEGIN
		
			INSERT INTO ClientNotes (ClientId,
									NoteType,
									NoteLevel,
									Note,
									Active,
									StartDate,
									CreatedBy,
									ModifiedBy)
							SELECT
								D.ClientId,
								@FlagTypeId,
								4501,
								SUBSTRING(DR.CoverageInformation,1,100),
								'Y',
								D.EffectiveDate,
								@CurrentUser,
								@CurrentUser
							  FROM dbo.DocumentRegistrations DR
							  Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
							  WHERE D.DocumentId = @ScreenKeyId AND DR.CoverageInformation IS NOT NULL
							  AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
				DECLARE @Note varchar(100)
				DECLARE @ClientNoteStartDate datetime
				
				Select top 1 @Note = SUBSTRING(DR.CoverageInformation,1,100), @ClientId = D.ClientId, @ClientNoteStartDate = D.EffectiveDate
					FROM dbo.ClientNotes b
					Inner Join dbo.DocumentRegistrations DR on b.ClientId = DR.ClientId
					Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId AND  b.StartDate = D.EffectiveDate
					--AND DR.CoverageInformation IS NOT NULL
					WHERE D.DocumentId = @ScreenKeyId AND b.NoteType = @FlagTypeId AND ISNULL(b.RecordDeleted, 'N') = 'N'
					AND ISNULL(DR.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		

			    Update  ClientNotes  
				Set  ModifiedDate = @CurrentDate, ModifiedBy = @CurrentUser, Note = @Note
				Where  ClientId = @ClientId AND  StartDate = @ClientNoteStartDate
				AND NoteType = @FlagTypeId
		END
		
		
		
		
		
		
		--Episode Tab
		UPDATE CE
		SET CE.RegistrationComment = DRE.RegistrationComment	--Flows into Registration comment field in Episode tab of Client Information(c).
			,CE.ReferralDate = DRE.ReferralDate
			,CE.ReferralType = DRE.ReferralType
			,CE.ReferralSubtype = DRE.ReferralSubtype
			,CE.ReferralOrganizationName = DRE.ReferralOrganization
			,CE.ReferrralPhone = DRE.ReferrralPhone
			,CE.ReferrralFirstName = DRE.ReferrralFirstName
			,CE.ReferrralLastName = DRE.ReferrralLastName
			,CE.ReferrralAddressLine1 = DRE.ReferrralAddress1
			,CE.ReferrralAddressLine2 = DRE.ReferrralAddress2
			,CE.ReferrralCity = DRE.ReferrralCity
			,CE.ReferrralState = DRE.ReferrralState
			,CE.ReferrralZipCode = DRE.ReferrralZipCode
			,CE.ReferrralEmail = DRE.ReferrralEmail
			--,CE.ReferralComment = DRE.ReferrralComment
			,CE.ModifiedDate = @CurrentDate           
            ,CE.ModifiedBy = @CurrentUser 
            ,CE.ProviderId = DRE.ExternalReferralProviderId
            ,CE.ProviderType = DRE.ProviderType
            ,CE.ReferralReason1 = DRE.ReferralReason1
            ,CE.ReferralReason2 = DRE.ReferralReason2
            ,CE.ReferralReason3 = DRE.ReferralReason3
            ,CE.ReferralComment = DRE.ReferralComment
		FROM ClientEpisodes  CE   
		Inner Join DocumentRegistrations DR on DR.ClientId = CE.ClientId
		Inner Join DocumentRegistrationEpisodes DRE on DRE.DocumentVersionId = DR.DocumentVersionId    
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
		AND ISNULL(DRE.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		--AND CE.DischargeDate IS NOT NULL
		AND CE.EpisodeNumber = ( Select Top 1 GC.EpisodeNumber 
								FROM ClientEpisodes GC WHERE GC.ClientId = @ClientID 
								AND ISNULL(GC.RecordDeleted, 'N') = 'N' Order By GC.EpisodeNumber Desc )
		
		
		

      
      
		--Program Enrollment Tab
		UPDATE CP
		SET CP.AssignedStaffId = DRPE.AssignedStaffId
			,CP.ModifiedDate = @CurrentDate           
            ,CP.ModifiedBy = @CurrentUser 
		
		FROM ClientPrograms  CP   
		Inner Join DocumentRegistrations DR on DR.ClientId = CP.ClientId
		Inner Join DocumentRegistrationProgramEnrollments DRPE on DRPE.DocumentVersionId = DR.DocumentVersionId    
		Inner Join Documents D ON D.CurrentDocumentVersionId = DR.DocumentVersionId
		WHERE D.DocumentId = @ScreenKeyId AND ISNULL(DR.RecordDeleted, 'N') = 'N' 
		AND ISNULL(DRPE.RecordDeleted, 'N') = 'N' AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND CP.[Status] = ( Select Top 1 GC.GlobalCodeId 
							FROM GlobalCodes GC WHERE GC.Category='PROGRAMSTATUS' AND GC.CodeName = 'Enrolled' 
							AND GC.Active = 'Enrolled' AND ISNULL(GC.RecordDeleted, 'N') = 'N')
		
		
		
		

		 
      
		--Creating Client Release of Information Log entry    
		DECLARE @CurrentDocumentVersionId int,
				@CurrentVersionstatus int,
				--@clientid                 INT, 
				@ClientSignatureId int,
				@SignatureType varchar(1),
				@documentcodeid int,
				@authorid int

		DECLARE @ClientInformationReleases TABLE (
		  NewClientInformationReleaseId int NOT NULL
		)

		SELECT
		  @CurrentDocumentVersionId = currentdocumentversionid,
		  @CurrentVersionstatus = currentversionstatus,
		  @clientid = clientid,
		  @documentcodeid = documentcodeid,
		  @authorid = authorid
		FROM documents
		WHERE documentid = @ScreenKeyId
		AND ISNULL(recorddeleted, 'N') = 'N'

		/*Add by sanjayb 5/feb/2013 #2*/
		SELECT
		  @ClientSignatureId = @CustomParameters.value('Root[1]/Parameters[1]/@SignerId', 'bigint')

		SELECT
		  @SignatureType = @CustomParameters.value('Root[1]/Parameters[1]/@SignerType', 'varchar(1)')

		/*End#2*/
		--Check Signed Document status i.e 22(signed) and Checking that Document ClientId is equal to SignatureId        
		IF (ISNULL(@CurrentVersionstatus, -1) = 22
		  AND ISNULL(@ClientSignatureId, -1) = @clientid)
		BEGIN
		  -------Creating Client Release of Information Log entry here                       
		  INSERT INTO clientinformationreleases ([clientid],
		  [releasetoid],
		  [releasetoname],
		  [startdate],
		  [enddate],
		  [comment],
		  [documentattached],
		  [locked],
		  [lockedby],
		  [lockeddate],
		  [createdby],
		  [createddate])
		  OUTPUT INSERTED.clientinformationreleaseid INTO @ClientInformationReleases
			SELECT
			  D.clientid,
			  CASE
				WHEN (CDRI.ReleaseType = 'C') THEN CDRI.ReleaseToFromContactId
				ELSE NULL
			  END,
			  CDRI.releasename,
			  CONVERT(varchar(10), D.effectivedate, 101),
			  CDRI.RecordsEndDate AS EndDate,
			  ISNULL(CDRI.releaseaddress + ' | ', '')
			  + ISNULL(CDRI.releasephonenumber + ' ', '')
			  + 'Program: ' + ISNULL(P.programname, NULL),
			  'Release of Information',
			  'Y',
			  @CurrentUser,
			  @CurrentDate,
			  @CurrentUser,
			  @CurrentDate
			FROM DocumentReleaseOfInformations CDRI
			JOIN DocumentVersions DV ON CDRI.DocumentVersionId = DV.DocumentVersionId
			JOIN Documents D ON DV.DocumentId = D.DocumentId
			LEFT JOIN ClientContacts CC ON CDRI.ReleaseToFromContactId = CC.ClientContactId
			LEFT JOIN programs P ON CDRI.programid = P.programid
			WHERE CDRI.documentversionid = @CurrentDocumentVersionId


			INSERT INTO ClientInformationReleaseDocuments (ClientInformationReleaseId, DocumentId)
			SELECT newclientinformationreleaseid, @ScreenKeyId FROM @ClientInformationReleases

		END
    
    
    
    
  END try 

BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCPostSignatureUpdateRegistrations')                                                                                                                       
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