/****** Object:  StoredProcedure [dbo].[ssp_scUpdateInquiryClientContacts]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_scUpdateInquiryClientContacts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_scUpdateInquiryClientContacts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_scUpdateInquiryClientContacts]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_scUpdateInquiryClientContacts]            
    (            
      @InquiryId INT ,            
      @ClientId INT ,            
      @CurrentUser VARCHAR(50),
      @StaffId INT            
    )              
/******************************************************************************              
**  File:         
**  Created by : RK       
**  Name: ssp_scUpdateInquiryClientContacts               
**  Desc: Create event for the Inquire after completing the status of the inquiry.               
**  Parameters:              
**  Input              
 @InquiryId INT,              
 @ClientId INT,              
 @CurrentUser VARCHAR(50)              
**  Output     ----------       -----------              
**               
**  Auth:  Pralyankar Kumar Singh              
**  Date:  March 18, 2012              
*******************************************************************************              
**  Change History               
*******************************************************************************              
**  Date:  Author:    Description:              
**  --------  --------    -------------------------------------------              
**22-May -2013  Pselvan  insert into ClientAddresses table, if no row exist for Inquiry address (pulled from Centrawellness)              
  22-May -2013  Pselvan  Else Condition added to avoid duplicate row insertion in ClientAddresses table. (Same change required for Centrawellness also)              
  /*19 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*/                
   10-Oct-2012 Vichee  Added Active='Y' while inserting the details into ClientContacts table. Core-Bugs 1198             
   01-Jun-2015 NJain  Added Number of Dependents in CustomClients to post update            
/* Venkatesh MR 6/03/2015  #111 Post Update Household annual income  to Client CUstom Fields*/            
/* Venkatesh MR 11/06/2015  #65 Valley Go Live Support - Uncomment the Guardian relation which has to update in the Client Information*/             
/*  Vijeta Sinha    07/04/2017      #1124 Valley Go Live Support - Added the logic to Update member-phone of inquiry by Home phone of clientphones and cell-phone by of Inquiry by Mobile of ClientPhones.     */                         
*******************************************************************************/            
AS            
BEGIN                   
  BEGIN try               
              
 -- Query               
 -- 1. In Client contacts table we habe no filed for phone numbers so do you want to skip these fields.              
 -- 2. Whatever information we will insert in client contact table that should be updated in PCM database as well. Please confirm.              
 -- 3.               
              
 ---- Inquirer fields ----------              
        DECLARE @InquirerFirstName VARCHAR(50) ,            
            @InquirerLastName VARCHAR(50) ,            
            @InquirerMiddleName VARCHAR(50) ,            
            @InquirerRelationToMember INT ,            
            @InquirerPhone VARCHAR(100) ,            
            @InquirerEmail VARCHAR(100)              
  -- Emergency access Fields -----              
            ,            
            @EmergencyContactRelationToClient INT ,            
            @EmergencyContactFirstName VARCHAR(50) ,            
            @EmergencyContactLastName VARCHAR(50) ,            
            @EmergencyContactHomePhone VARCHAR(100) ,            
            @EmergencyContactCellPhone VARCHAR(100) ,            
            @EmergencyContactWorkPhone VARCHAR(100) ,            
            @EmergencyContactSameAsCaller CHAR(1) ,            
            @ClientCanLegalySign CHAR(1) ,            
            @GuardianFirstName VARCHAR(50) ,            
            @GuardianLastName VARCHAR(50) ,            
            @GuardianRelation INT ,            
            @GuardianDOB VARCHAR(20) ,            
            @GuardianComment VARCHAR(MAX) ,        
            @GuardianPhoneNumber VARCHAR(128) ,            
            @GuardianSameAsCaller CHAR(1) ,            
 @MemberPhone VARCHAR(100),            
            @MemberCell VARCHAR(100)              
 --------------------------------              
 DECLARE @ClientContactId INT ,            
            @EmergencyClientContactId INT              
              
              
        SELECT  @InquirerFirstName = InquirerFirstName ,            
                @InquirerLastName = InquirerLastName ,            
                @InquirerMiddleName = InquirerMiddleName ,            
				@InquirerRelationToMember = InquirerRelationToMember ,            
                @InquirerPhone = InquirerPhone ,            
                @InquirerEmail = InquirerEmail              
  -- Emergency access Fields -----              
                ,            
                @EmergencyContactSameAsCaller = EmergencyContactSameAsCaller ,            
                @EmergencyContactRelationToClient = EmergencyContactRelationToClient ,            
                @EmergencyContactFirstName = EmergencyContactFirstName ,            
                @EmergencyContactLastName = EmergencyContactLastName ,            
                @EmergencyContactHomePhone = EmergencyContactHomePhone ,            
                @EmergencyContactCellPhone = EmergencyContactCellPhone ,            
                @EmergencyContactWorkPhone = EmergencyContactWorkPhone              
  -- Guardian Information -----              
                ,            
                @ClientCanLegalySign = ClientCanLegalySign ,            
                @GuardianFirstName = GuardianFirstName ,            
                @GuardianLastName = GuardianLastName              
				,@GuardianRelation = GuardianRelation, @GuardianDOB = GuardianDOB, @GuardianComment = GuardianComment              
                ,            
                @GuardianPhoneNumber = GuardianPhoneNumber ,            
                @GuardianSameAsCaller = ISNULL(GuardianSameAsCaller, 'N') ,            
                @MemberPhone = MemberPhone,            
                @MemberCell = MemberCell            
        FROM    Inquiries            
        WHERE   InquiryId = @InquiryId              
              
  ---- Update Client Information -----              
        UPDATE  C            
        SET     C.FirstName = CI.MemberFirstName ,            
                C.LastName = CI.MemberLastName ,            
                C.MiddleName = CI.MemberMiddleName ,            
                C.SSN = CI.SSN ,            
                C.DOB = CI.DateOfBirth ,            
                C.Email = CI.MemberEmail ,                     
                C.NumberOfBeds = CI.NoOfBeds ,            
                C.CountyOfResidence = CI.CountyOfResidence ,            
                C.CorrectionStatus = CI.CorrectionStatus ,  
                   --Added by rk              
				C.EducationalStatus = CI.EducationalStatus ,                 
                C.EmploymentStatus = CI.EmploymentStatus ,               
                C.MaritalStatus = CI.MaritalStatus          
                --Earlier one commented by rk           
			   --, C.Sex = CI.Sex               
                ,            
                C.ModifiedDate = GETDATE() ,            
                C.ModifiedBy = @CurrentUser ,            
                C.PrimaryLanguage = CI.PrimaryLanguage  ,   
    --Added by rk  ------------------------------------------------------------------
			  C.Active = CI.Active     
			 ,C.Prefix =CI.Prefix     
			 ,C.Suffix    =CI.Suffix     
			 ,C.PrimaryClinicianId  =CI.PrimaryClinicianId       
			 ,C.Comment    =CI.Comment    
			 ,C.FinanciallyResponsible   =CI.FinanciallyResponsible  
			 ,C.CountyOfTreatment = CI.CountyOfTreatment
			 ,C.LivingArrangement    =CI.LivingArrangement     
			 ,C.AnnualHouseholdIncome    =CI.AnnualHouseholdIncome     
			 ,C.NumberOfDependents  =CI.NumberOfDependents     
			 ,C.EmploymentInformation    =CI.EmploymentInformation     
			 ,C.MilitaryStatus   =CI.MilitaryStatus   
			 ,C.DoesNotSpeakEnglish  =CI.DoesNotSpeakEnglish  
			 ,C.HispanicOrigin    =CI.HispanicOrigin      
			 ,C.DeceasedOn    =CI.DeceasedOn      
			 ,C.ReminderPreference  =CI.ReminderPreference       
			 ,C.MobilePhoneProvider   =CI.MobilePhoneProvider     
			 ,C.SchedulingPreferenceMonday   =CI.SchedulingPreferenceMonday        
			 ,C.SchedulingPreferenceTuesday    =CI.SchedulingPreferenceTuesday     
			 ,C.SchedulingPreferenceWednesday    =CI.SchedulingPreferenceWednesday       
			 ,C.SchedulingPreferenceThursday   =CI.SchedulingPreferenceThursday      
			 ,C.SchedulingPreferenceFriday    =CI.SchedulingPreferenceFriday        
			 ,C.GeographicLocation   =CI.GeographicLocation      
			 ,C.SchedulingComment    =CI.SchedulingComment       
			 ,C.CauseOfDeath    =CI.CauseOfDeath        
			 ,C.GenderIdentity    =CI.GenderIdentity       
			 ,C.SexualOrientation    =CI.SexualOrientation     
			 ,C.PrimaryPhysicianId   =CI.PrimaryPhysicianId        
			 ,C.ProfessionalSuffix =CI.ProfessionalSuffix     
			 ,C.PreferredGenderPronoun =CI.PreferredGenderPronoun 
     -----End rk----------------------------------------------               
           
                          
        FROM    Clients C            
                INNER JOIN Inquiries CI ON CI.ClientId = C.ClientId            
        WHERE   CI.InquiryId = @inquiryId     
          
        ----Start rk--------------------------------------------------------------  
        --Delete and insert the races from Inquiry  
  UPDATE  ClientRaces            
  SET            
    RecordDeleted = 'Y' ,            
    DeletedDate = GETDATE() ,            
    DeletedBy = @CurrentUser      
  WHERE   ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'    
  
  INSERT INTO ClientRaces (ClientId,RaceId,CreatedBy,CreatedDate)  
  SELECT @ClientId,RaceId,CreatedBy,CreatedDate  
  FROM InquiryClientRaces   
  WHERE InquiryId=@InquiryId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'             
          
         --Delete and insert the ClientDemographicInformationDeclines from Inquiry  
  UPDATE  ClientDemographicInformationDeclines            
  SET            
    RecordDeleted = 'Y' ,            
    DeletedDate = GETDATE() ,            
    DeletedBy = @CurrentUser      
  WHERE   ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'     
  
  INSERT INTO ClientDemographicInformationDeclines (ClientId,ClientDemographicsId,CreatedBy,CreatedDate)  
  SELECT @ClientId,ClientDemographicsId,CreatedBy,CreatedDate  
  FROM InquiryClientDemographicInformationDeclines   
  WHERE InquiryId=@InquiryId AND RecordDeleted is null          
          
         --Delete and insert the ClientEthnicities from Inquiry  
  UPDATE  ClientEthnicities            
  SET       
    RecordDeleted = 'Y' ,            
    DeletedDate = GETDATE() ,            
    DeletedBy = @CurrentUser      
  WHERE   ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'      
  
  INSERT INTO ClientEthnicities (ClientId,EthnicityId,CreatedBy,CreatedDate)  
  SELECT @ClientId,EthnicityId,CreatedBy,CreatedDate  
  FROM InquiryClientEthnicities   
  WHERE InquiryId=@InquiryId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'     
    
 
 --Delete and insert the ClientPictures from Inquiry  
 
  DECLARE @UploadedBy INT 
  SET  @UploadedBy = @StaffId
         
  UPDATE  ClientPictures            
  SET          
    ModifiedDate = GETDATE(),            
    ModifiedBy = @CurrentUser,
    UploadedBy=@UploadedBy,
    UploadedOn=GETDATE(),    
    Active='N'     
  WHERE   ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N' AND Active='Y'      
  
  INSERT INTO ClientPictures (ClientId,Picture,PictureFileName,Active,CreatedBy,CreatedDate,UploadedBy,UploadedOn)  
  SELECT @ClientId,Picture,PictureFileName,Active,CreatedBy,CreatedDate,@UploadedBy,GETDATE()  
  FROM InquiryClientPictures   
  WHERE InquiryId=@InquiryId AND ISNULL(RecordDeleted, 'N') = 'N' and ISNULL(RecordDeleted, 'N') = 'N'  AND Active='Y'   
    
  -----------End rk------------------------------------------------------                           
              
        DECLARE @ClientEpisodesCount INT            
        SELECT  @ClientEpisodesCount = COUNT(*)            
        FROM    ClientEpisodes            
        WHERE   ClientId = @ClientId                   
              
        DECLARE @CreatedBy VARCHAR(100)          
        DECLARE @CreatedDate DATETIME            
               
        SELECT  @CreatedBy = CreatedBy ,            
                @CreatedDate = CreatedDate            
        FROM    Clients            
        WHERE   ClientId = @ClientId            
        IF ( @ClientId > 0 )            
            BEGIN            
                UPDATE  CE            
                SET     CE.ReferralDate = CI.ReferralDate ,            
                        CE.ReferralName = CI.ReferalLastName + ', ' + CI.ReferalFirstName ,            
                        CE.ReferralType = CI.ReferralType ,            
                        CE.ReferralSubtype = CI.ReferralSubtype            
                FROM    ClientEpisodes CE            
                        INNER JOIN Inquiries CI ON CI.ClientId = CE.ClientId            
                WHERE   CI.InquiryId = @inquiryId            
            END            
        ELSE            
            BEGIN            
                DECLARE @ReferralDate DATETIME            
                DECLARE @ReferralName VARCHAR(200)            
                DECLARE @ReferralType INT            
                DECLARE @ReferralSubtype INT            
                SELECT  @ReferralDate = ReferralDate ,            
                        @ReferralName = ReferalLastName + ', ' + ReferalFirstName ,            
                        @ReferralType = ReferralType ,            
                        @ReferralSubtype = ReferralSubtype            
                FROM    Inquiries            
                WHERE   InquiryId = @inquiryId            
                INSERT  INTO ClientEpisodes            
                        ( CreatedBy ,            
                          CreatedDate ,            
                          ModifiedBy ,            
                          ModifiedDate ,            
                          ClientId ,            
                          EpisodeNumber ,            
                          ReferralDate ,            
                          ReferralName ,            
                          ReferralType ,          
                          ReferralSubtype            
                        )            
                VALUES  ( @CreatedBy ,            
                          @CreatedDate ,            
                          @CreatedBy ,            
                          @CreatedDate ,            
                          @ClientId ,            
                          1 ,            
                          @ReferralDate ,            
                          @ReferralName ,            
                          @ReferralType ,            
                          @ReferralSubtype            
                        )            
            END            
                           
              
  ------ Update Client Address ------------------              
        IF EXISTS ( SELECT  1            
                    FROM    ClientAddresses CA            
                            INNER JOIN Inquiries CI ON CI.ClientId = CA.ClientId            
                                                             AND CA.AddressType = 90 -- 90 = Home                
                    WHERE   CI.InquiryId = @inquiryId )            
            BEGIN              
				UPDATE  CA            
                SET     CA.Address = CI.Address1 ,         
                        CA.City = CI.City ,            
                        CA.State = CI.State ,            
                        CA.Zip = CI.ZipCode ,            
                        CA.ModifiedDate = GETDATE() ,            
                        CA.ModifiedBy = @CurrentUser            
				FROM    ClientAddresses CA            
                        INNER JOIN Inquiries CI ON CI.ClientId = CA.ClientId            
                                                         AND CA.AddressType = 90 -- 90 = Home                
                WHERE   CI.InquiryId = @inquiryId                
            END              
        ELSE            
            BEGIN              
                IF EXISTS ( SELECT  1            
                            FROM    Inquiries CI            
                            WHERE   CI.ClientId IS NOT NULL            
                                    AND CI.InquiryId = @inquiryId )            
                    BEGIN              
                        INSERT  INTO ClientAddresses            
                                ( ClientId ,            
                                  AddressType ,            
                                  Address ,            
                                  City ,            
                                  State ,            
                                  Zip ,            
                                  RowIdentifier ,            
                                  CreatedBy ,            
                                  CreatedDate ,            
                                  ModifiedBy ,            
                                  ModifiedDate              
                                )            
                                SELECT  ClientId ,            
                                        90 ,            
                                        Address1 ,            
                                        City ,            
                                        State ,            
                                        ZipCode ,            
                                        NEWID() ,            
                                        @CurrentUser ,            
                                        GETDATE() ,            
                                        @CurrentUser ,            
                                        GETDATE()            
                                FROM    Inquiries            
                                WHERE   InquiryId = @inquiryId               
                    END              
            END              
  -----------------------------------------------              
   ------ Update Client History Address ------------------              
                       IF EXISTS ( SELECT  1            
										FROM    Inquiries CI            
												WHERE   CI.ClientId IS NOT NULL            
														AND CI.InquiryId = @inquiryId )            
                    BEGIN              
                        INSERT  INTO ClientAddressHistory            
                                ( ClientId ,            
                                  AddressType ,            
                                  Address ,            
                                  City ,            
                                  State ,            
                                  Zip ,            
                                  Display,            
                                  RowIdentifier ,            
                                  CreatedBy ,            
                                  CreatedDate ,            
                                  ModifiedBy ,            
                                  ModifiedDate              
                                )            
								SELECT  ClientId ,            
                                        90 ,            
                                        Address1 ,            
                                        City ,            
                                        State ,            
										ZipCode ,            
                                        Address1+' '+City+','+State+' '+ZipCode,            
                                        NEWID() ,            
										@CurrentUser ,            
                                        GETDATE() ,            
                                        @CurrentUser ,            
                                     GETDATE()            
                                FROM    Inquiries            
                                WHERE   InquiryId = @inquiryId               
                    END              
                          
  -----------------------------------------------              
              
  -- Update Client Episod Informations ----------              
        UPDATE  CE            
        SET     CE.ReferralDate = CI.ReferralDate ,            
                CE.ReferralType = CI.ReferralType ,            
                CE.ReferralSubtype = CI.ReferralSubtype ,            
                CE.ReferralName = CI.ReferralName ,            
				CE.ReferralAdditionalInformation = CI.ReferralAdditionalInformation ,            
                CE.ModifiedDate = GETDATE() ,            
                CE.ModifiedBy = @CurrentUser            
        FROM    ClientEpisodes CE            
                INNER JOIN Clients C ON CE.ClientId = C.ClientId            
                                        AND C.CurrentEpisodeNumber = CE.EpisodeNumber            
                INNER JOIN Inquiries CI ON CI.ClientId = C.ClientId            
        WHERE   CI.InquiryId = @inquiryId              
  -----------------------------------------------              
              
 /* 1. Insert Row in ClientContract for Inquirer              
    2. Insert Row in Client Contract for Emergency contract.              
    3. If Client Inquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian               
   Whether user has selected any other relaship in the popup dropdown              
 */              
              
 -- 1. Insert Row in ClientContract for Inquirer              
        SELECT  @ClientContactId = ClientContactId            
        FROM    ClientContacts            
        WHERE   ClientId = @ClientId            
                AND ISNULL(RecordDeleted, 'N') = 'N'            
                AND ( ( [FirstName] = @InquirerFirstName            
                        AND LastName = @InquirerLastName            
                      )            
                      OR ( [FirstName] = @InquirerFirstName            
                           AND Relationship = @InquirerRelationToMember            
                         )            
                      OR ( [LastName] = @InquirerLastName            
                           AND Relationship = @InquirerRelationToMember            
                         )            
                      OR Relationship = @InquirerRelationToMember            
                    )              
              
        IF ISNULL(@ClientContactId, 0) > 0            
            AND ISNULL(@InquirerRelationToMember, 0) <> 6781            
            AND @InquirerRelationToMember > 0            
            BEGIN -- Update Existing record              
                UPDATE  ClientContacts            
                SET     ListAs = ISNULL(@InquirerLastName, '') + ', ' + ISNULL(@InquirerFirstName, '') ,            
                        FirstName = ISNULL(@InquirerFirstName, '') ,            
                        LastName = ISNULL(@InquirerLastName, '') ,            
                        Email = @InquirerEmail ,            
                        Guardian = @GuardianSameAsCaller ,            
                        Relationship = @InquirerRelationToMember ,            
                        [LastNameSoundex] = SOUNDEX(@InquirerLastName) ,            
                        [FirstNameSoundex] = SOUNDEX(@InquirerFirstName) ,            
                        ModifiedBy = @CurrentUser ,            
                        ModifiedDate = GETDATE() ,            
                        [EmergencyContact] = ISNULL(@EmergencyContactSameAsCaller, 'N')            
                WHERE   ClientContactId = @ClientContactId              
            END              
        ELSE            
            IF ISNULL(@InquirerRelationToMember, 0) <> 6781            
                AND @InquirerRelationToMember > 0 -- Insert new record              
                BEGIN              
                    INSERT  INTO [ClientContacts]            
                            ( [CreatedBy] ,            
                              [CreatedDate] ,            
                              [ModifiedBy] ,            
                              [ModifiedDate] ,            
                              [ListAs] ,            
                              [ClientId] ,            
                              [Relationship] ,            
                              [FirstName] ,            
                              [LastName] ,            
                              [FinanciallyResponsible] ,            
                              [Guardian] ,            
                              [EmergencyContact] ,            
                              [LastNameSoundex] ,            
                              [FirstNameSoundex] ,            
                              Email ,            
                              Active              
                            )            
                    VALUES  ( @CurrentUser ,            
                              GETDATE() ,            
                              @CurrentUser ,            
                              GETDATE() ,            
                              ISNULL(@InquirerLastName, '') + ', ' + ISNULL(@InquirerFirstName, '') ,            
                              @ClientId ,            
                              @InquirerRelationToMember ,            
                              ISNULL(@InquirerFirstName, '') ,            
                              ISNULL(@InquirerLastName, '') ,            
                              'N' ,            
                              @GuardianSameAsCaller ,            
                              ISNULL(@EmergencyContactSameAsCaller, 'N') ,            
                              SOUNDEX(@InquirerLastName) ,            
                              SOUNDEX(@InquirerFirstName) ,            
                              @InquirerEmail ,            
                              'Y'            
                            )              
                    SELECT  @ClientContactId = @@identity               
                END              
              
    -- 30 = Home Phone              
    -- 31 = Business              
    -- 34 = Mobile              
    -- 38 = Other              
        IF ( ISNULL(@InquirerPhone, '') <> ''            
             AND @ClientContactId > 0            
           )--isnull(@EmergencyContactSameAsCaller,'N')  = 'Y')              
            BEGIN              
                IF EXISTS ( SELECT  1            
                            FROM    ClientContactPhones            
                            WHERE   ClientContactId = @ClientContactId         
                                    AND PhoneType = 30 )            
                    BEGIN              
                        UPDATE  ClientContactPhones            
                        SET     PhoneNumber = @InquirerPhone ,            
                                PhoneNumberText = dbo.[csf_PhoneNumberStripped](@InquirerPhone) ,            
                                ModifiedBy = @CurrentUser ,            
                                ModifiedDate = GETDATE()            
                        WHERE   ClientContactId = @ClientContactId            
                                AND PhoneType = 30              
                    END              
                ELSE            
                    BEGIN              
                        INSERT  INTO ClientContactPhones            
                                ( [CreatedBy] ,            
                                  [CreatedDate] ,            
     [ModifiedBy] ,            
                                  [ModifiedDate] ,            
                                  ClientContactId ,            
                                  PhoneNumber ,            
                                  PhoneNumberText ,            
                                  PhoneType            
                                )            
                   VALUES  ( @CurrentUser ,            
                                  GETDATE() ,            
                                  @CurrentUser ,            
                                  GETDATE() ,            
                                  @ClientContactId ,            
                                  @InquirerPhone ,            
                                  dbo.[csf_PhoneNumberStripped](@InquirerPhone) ,            
                                  30            
                                )              
                    END              
            END              
 /*******************************************************************************************************/              
              
               
 -- 2. Insert Row in Client Contract for Emergency contract.              
        IF ISNULL(@EmergencyContactSameAsCaller, 'N') = 'N'            
            BEGIN              
  --print 'in For Emergency'              
                SET @EmergencyClientContactId = NULL              
            SELECT  @EmergencyClientContactId = ClientContactId            
                FROM    ClientContacts            
                WHERE   ClientId = @ClientId            
                        AND ISNULL(RecordDeleted, 'N') = 'N'            
                        AND ( ( [FirstName] = @EmergencyContactFirstName            
                                AND LastName = @EmergencyContactLastName            
                              )            
                              OR ( [FirstName] = @EmergencyContactFirstName            
                                   AND Relationship = @EmergencyContactRelationToClient            
                                 )            
                              OR ( [LastName] = @EmergencyContactLastName            
                                   AND Relationship = @EmergencyContactRelationToClient            
                                 )            
                              OR Relationship = @EmergencyContactRelationToClient            
                            )              
              
                IF ISNULL(@EmergencyClientContactId, 0) > 0            
                    AND @EmergencyContactRelationToClient > 0            
                    BEGIN -- Update Existing record              
                        UPDATE  ClientContacts            
                        SET     ListAs = ISNULL(@EmergencyContactLastName, '') + ', ' + ISNULL(@EmergencyContactFirstName, '') ,            
                                FirstName = ISNULL(@EmergencyContactFirstName, '') ,            
                                LastName = ISNULL(@EmergencyContactLastName, '') ,            
                                Relationship = @EmergencyContactRelationToClient ,            
                                [LastNameSoundex] = SOUNDEX(@EmergencyContactLastName) ,            
                  [FirstNameSoundex] = SOUNDEX(@EmergencyContactFirstName) ,            
                                [EmergencyContact] = 'Y' ,            
                                ModifiedBy = @CurrentUser ,            
                                ModifiedDate = GETDATE()            
                        WHERE   ClientContactId = @EmergencyClientContactId              
                    END              
                ELSE            
                    IF @EmergencyContactRelationToClient > 0 -- Insert new record              
                        BEGIN              
                            INSERT  INTO [ClientContacts]            
                                    ( [CreatedBy] ,            
                                      [CreatedDate] ,            
                                      [ModifiedBy] ,            
                                      [ModifiedDate] ,        
                                      [ListAs] ,            
                                      [ClientId] ,            
                                      [Relationship] ,            
                                      [FirstName] ,            
                                      [LastName] ,            
                                      [FinanciallyResponsible] ,            
                                      [Guardian] ,            
                                      [EmergencyContact] ,            
      [LastNameSoundex] ,            
                                      [FirstNameSoundex] ,            
                                      [Active]              
                                    )            
                            VALUES  ( @CurrentUser ,            
                                      GETDATE() ,            
                                      @CurrentUser ,            
                                      GETDATE() ,            
                                      ISNULL(@EmergencyContactLastName, '') + ', ' + ISNULL(@EmergencyContactFirstName, '') ,            
                                      @ClientId ,            
                                      @EmergencyContactRelationToClient ,            
                                      ISNULL(@EmergencyContactFirstName, '') ,            
                                      ISNULL(@EmergencyContactLastName, '') ,            
                                      'N' ,            
                                      'N' ,            
                                      'Y' --@EmergencyContactSameAsCaller               
              ,            
                                      SOUNDEX(@EmergencyContactLastName) ,            
                                      SOUNDEX(@EmergencyContactFirstName) ,            
                                      'Y'               
                                    )              
                            SELECT  @EmergencyClientContactId = @@identity               
                        END               
            END --IF @EmergencyContactSameAsCaller = 'N'              
               
 -- If Emergency Contact is same caller then               
        IF ISNULL(@EmergencyContactSameAsCaller, 'N') = 'Y'            
            BEGIN              
                SET @EmergencyClientContactId = @ClientContactId              
            END              
               
        IF @EmergencyClientContactId > 0            
            AND ( ISNULL(@EmergencyContactHomePhone, '') <> ''            
                  OR ISNULL(@EmergencyContactCellPhone, '') <> ''            
                )            
            BEGIN              
                 
   ---- Update Home Phone -----              
                IF ISNULL(@EmergencyContactHomePhone, '') <> ''            
         BEGIN              
                        IF EXISTS ( SELECT  1            
                                    FROM    ClientContactPhones            
                                    WHERE   ClientContactId = @EmergencyClientContactId            
                                            AND PhoneType = 30 )            
                            BEGIN              
                                UPDATE  ClientContactPhones            
                                SET     PhoneNumber = ISNULL(@EmergencyContactHomePhone, '') ,            
                                        PhoneNumberText = dbo.[csf_PhoneNumberStripped](ISNULL(@EmergencyContactHomePhone, '')) ,            
                                        ModifiedBy = @CurrentUser ,            
                                        ModifiedDate = GETDATE()            
                                WHERE   ClientContactId = @EmergencyClientContactId       
                                        AND PhoneType = 30              
                            END              
                        ELSE            
                            BEGIN              
                                INSERT  INTO ClientContactPhones            
( [CreatedBy] ,            
                                          [CreatedDate] ,            
                                          [ModifiedBy] ,            
                                          [ModifiedDate] ,            
                                          ClientContactId ,            
                                          PhoneNumber ,            
                                          PhoneNumberText ,            
                                          PhoneType            
                                        )            
                                VALUES  ( @CurrentUser ,            
                                          GETDATE() ,            
                                          @CurrentUser ,            
                                          GETDATE() ,            
                                          @EmergencyClientContactId ,            
                                          ISNULL(@EmergencyContactHomePhone, '') ,            
                                          dbo.[csf_PhoneNumberStripped](ISNULL(@EmergencyContactHomePhone, '')) ,            
                                          30            
                                        )              
                            END               
                    END              
              
                IF ( ISNULL(@EmergencyContactCellPhone, '') <> '' )            
                    BEGIN              
     ---- Update Cell Phone ---------------              
                        IF EXISTS ( SELECT  1            
                                    FROM    ClientContactPhones            
                                    WHERE   ClientContactId = @EmergencyClientContactId            
                                            AND PhoneType = 34 )            
                            BEGIN              
                                UPDATE  ClientContactPhones            
                                SET     PhoneNumber = @EmergencyContactCellPhone ,            
                                        PhoneNumberText = dbo.[csf_PhoneNumberStripped](@EmergencyContactCellPhone) ,            
                                        ModifiedBy = @CurrentUser ,            
                                        ModifiedDate = GETDATE()            
                                WHERE   ClientContactId = @EmergencyClientContactId            
                                        AND PhoneType = 34              
                            END              
                        ELSE            
                            BEGIN              
                                INSERT  INTO ClientContactPhones            
                                        ( [CreatedBy] ,            
                                          [CreatedDate] ,            
                                          [ModifiedBy] ,            
                                          [ModifiedDate] ,            
                                          ClientContactId ,            
                                          PhoneNumber ,            
                                          PhoneNumberText ,            
                                          PhoneType            
                                        )            
                                VALUES  ( @CurrentUser ,            
                                          GETDATE() ,            
                                          @CurrentUser ,            
                                          GETDATE() ,            
                                          @EmergencyClientContactId ,            
                                          @EmergencyContactCellPhone ,            
                                          dbo.[csf_PhoneNumberStripped](@EmergencyContactCellPhone) ,            
                                          34            
                                        )              
                            END               
                    END             
                
                IF ( ISNULL(@EmergencyContactWorkPhone, '') <> '' )            
           BEGIN              
     ---- Update Cell Phone ---------------              
                        IF EXISTS ( SELECT  1            
                                    FROM    ClientContactPhones            
                                    WHERE   ClientContactId = @EmergencyClientContactId            
                                            AND PhoneType = 31 )            
                            BEGIN              
                                UPDATE  ClientContactPhones            
                                SET     PhoneNumber = @EmergencyContactWorkPhone ,            
                                        PhoneNumberText = dbo.[csf_PhoneNumberStripped](@EmergencyContactWorkPhone) ,            
                                        ModifiedBy = @CurrentUser ,            
                                        ModifiedDate = GETDATE()            
                                WHERE   ClientContactId = @EmergencyClientContactId            
                                        AND PhoneType = 31              
                   END              
                        ELSE            
                            BEGIN              
                                INSERT  INTO ClientContactPhones            
                                        ( [CreatedBy] ,            
                                          [CreatedDate] ,            
                                          [ModifiedBy] ,            
                                          [ModifiedDate] ,            
                                          ClientContactId ,            
                                          PhoneNumber ,            
                                          PhoneNumberText ,            
                                          PhoneType            
                                        )            
                                VALUES  ( @CurrentUser ,            
                                          GETDATE() ,            
                                          @CurrentUser ,            
                                          GETDATE() ,            
                                          @EmergencyClientContactId ,            
                                          @EmergencyContactWorkPhone ,            
                                          dbo.[csf_PhoneNumberStripped](@EmergencyContactWorkPhone) ,            
                                          31            
      )              
                            END               
                    END            
                
                 
   -- 34              
            END              
 ---- End of  "2. Insert Row in Client Contract for Emergency contract" --------              
              
              
        SET @ClientContactId = 0               
 -- 3. If Client Inquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian               
 --  Whether user has selected any other relaship in the popup dropdown              
        IF @GuardianSameAsCaller = 'N'            
            AND EXISTS ( SELECT 1            
                         FROM   Inquiries            
                         WHERE  ClientID = @ClientId            
                                AND InquiryId = @InquiryId            
                                AND ClientCanLegalySign = 'N' )            
            AND ( @GuardianFirstName <> ''            
                  OR @GuardianLastName <> ''            
                )            
            BEGIN              
                
                SELECT  @ClientContactId = ClientContactId            
    FROM    ClientContacts            
                WHERE   ClientId = @ClientId            
                        AND [Guardian] = 'Y'            
                        AND ISNULL(RecordDeleted, 'N') = 'N'              
                IF ISNULL(@ClientContactId, 0) = 0            
                    AND @GuardianRelation > 0            
                    BEGIN              
              
    --print 'Insert Guardian'              
                        INSERT  INTO [ClientContacts]            
                 ( [CreatedBy] ,            
                                  [CreatedDate] ,            
                                  [ModifiedBy] ,            
                                  [ModifiedDate] ,            
                                  [ListAs] ,            
                                  [ClientId] ,            
                                  [Relationship] ,            
                                  [FirstName] ,            
                                  [LastName] ,            
                                  [FinanciallyResponsible] ,            
                                  [DOB] ,            
                                  [Guardian] ,            
                                  [EmergencyContact] ,            
                                  [Comment] ,            
                                  [LastNameSoundex] ,            
                                  [FirstNameSoundex]              
                                )            
                        VALUES  ( @CurrentUser ,            
                                  GETDATE() ,            
                                  @CurrentUser ,            
                                  GETDATE() ,            
                                  ISNULL(@GuardianLastName, '') + ', ' + ISNULL(@GuardianFirstName, '') ,            
              @ClientId ,            
                                  @GuardianRelation               
     -- As Discussed with David on March 19, The Guardian Information should be updated with Guardian = 'Y' in Client contacts table.              
                                  ,            
                                  ISNULL(@GuardianFirstName, '') ,            
                                  ISNULL(@GuardianLastName, '') ,            
                                  'N' ,            
                                  @GuardianDOB ,            
                                  'Y' --CASE WHEN @GuardianRelation = 10060 THEN 'Y' ELSE 'N' END               
                                  ,            
                                  'N' -- As this is guardian information so this field will have 'N' value.  --ISNULL(EmergencyContactSameAsCaller,'N')               
                                  ,            
                                  @GuardianComment ,            
                                  SOUNDEX(@GuardianLastName) ,            
                                  SOUNDEX(@GuardianFirstName)            
                                )              
                        SET @ClientContactId = @@identity               
                    END              
                ELSE            
                    IF ( @GuardianFirstName <> ''            
                         OR @GuardianLastName <> ''            
                       )            
                        AND @GuardianRelation > 0            
          BEGIN              
    --print 'Update Guardian'              
                            UPDATE  [ClientContacts]            
                            SET     ListAs = ISNULL(@GuardianLastName, '') + ', ' + ISNULL(@GuardianFirstName, '') ,            
                                    FirstName = ISNULL(@GuardianFirstName, '') ,            
                                    LastName = ISNULL(@GuardianLastName, '') ,            
                                    [Relationship] = @GuardianRelation ,            
                                    [DOB] = @GuardianDOB ,            
                                    [Comment] = @GuardianComment ,            
                                    [LastNameSoundex] = SOUNDEX(@GuardianLastName) ,            
                                    [FirstNameSoundex] = SOUNDEX(@GuardianFirstName) ,            
                                    [EmergencyContact] = 'N' ,            
                                    ModifiedBy = @CurrentUser ,            
                                    ModifiedDate = GETDATE()            
                            WHERE   ClientContactId = @ClientContactId               
                        END       
            END              
                
              
        IF ISNULL(@GuardianPhoneNumber, '') <> ''            
            AND @ClientContactId > 0            
            BEGIN              
   ---- Update Home Phone -----              
                IF EXISTS ( SELECT  1            
                            FROM    ClientContactPhones            
                            WHERE   ClientContactId = @ClientContactId            
                                    AND PhoneType = 30 )            
                    BEGIN              
                        UPDATE  ClientContactPhones            
                        SET     PhoneNumber = @GuardianPhoneNumber ,            
                                PhoneNumberText = dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber) ,            
                                ModifiedBy = @CurrentUser ,            
                                ModifiedDate = GETDATE()            
                        WHERE   ClientContactId = @ClientContactId            
                                AND PhoneType = 30              
                    END              
                ELSE            
                    BEGIN              
                        INSERT  INTO ClientContactPhones            
                                ( [CreatedBy] ,            
                                  [CreatedDate] ,            
                                  [ModifiedBy] ,            
                                  [ModifiedDate] ,            
                                  ClientContactId ,            
                                  PhoneNumber ,            
                           PhoneNumberText ,            
                                  PhoneType            
                                )            
                        VALUES  ( @CurrentUser ,            
                                  GETDATE() ,            
                                  @CurrentUser ,            
                                  GETDATE() ,            
                                  @ClientContactId ,            
                                  @GuardianPhoneNumber ,            
                                  dbo.[csf_PhoneNumberStripped](@GuardianPhoneNumber) ,            
                                  30            
                                )              
                    END                 
            END              
                
  /*              
  Belwo  upadate is written By Rakesh-II w r t task 2 in Centra wellness               
  */              
      IF EXISTS ( SELECT  1            
                    FROM    ClientPhones            
                    WHERE   ClientId = @ClientId AND PhoneType=30 )            
            BEGIN              
                UPDATE  CP            
                SET     CP.PhoneNumber = CI.MemberPhone ,            
                        CP.PhoneNumberText = CI.MemberPhone ,            
                        CP.ModifiedDate = GETDATE() ,            
                        CP.ModifiedBy = @CurrentUser            
                FROM    ClientPhones CP            
                        INNER JOIN Inquiries CI ON CI.ClientId = CP.ClientId            
                WHERE   CI.InquiryId = @inquiryId  AND CP.PhoneType=30             
                AND CI.MemberPhone IS NOT NULL            
            END              
        ELSE IF (@MemberPhone IS NOT NULL)            
            BEGIN              
                INSERT  INTO ClientPhones            
                        ( [CreatedBy] ,            
                          [CreatedDate] ,            
                          [ModifiedBy] ,            
                          [ModifiedDate] ,            
                          ClientId ,            
                          PhoneNumber ,            
                          PhoneNumberText ,            
                          PhoneType ,            
                     IsPrimary            
                        )            
                VALUES  ( @CurrentUser ,            
                          GETDATE() ,            
                          @CurrentUser ,       
                          GETDATE() ,            
                          @ClientId ,            
                          @MemberPhone ,            
                          @MemberPhone ,            
                          30 ,            
                          'N'            
                        )              
            END                
            IF @MemberCell<>''            
            begin            
            IF EXISTS ( SELECT  1            
                    FROM    ClientPhones            
                    WHERE   ClientId = @ClientId AND PhoneType=34 )            
            BEGIN              
                UPDATE  CP            
                SET     CP.PhoneNumber = CI.MemberCell ,            
                        CP.PhoneNumberText = CI.MemberCell ,            
                        CP.ModifiedDate = GETDATE() ,            
                        CP.ModifiedBy = @CurrentUser            
                FROM    ClientPhones CP            
                        INNER JOIN Inquiries CI ON CI.ClientId = CP.ClientId            
                WHERE   CI.InquiryId = @inquiryId  AND CP.PhoneType=34             
            END              
        ELSE             
            BEGIN              
                INSERT  INTO ClientPhones            
                        ( [CreatedBy] ,            
                          [CreatedDate] ,            
                          [ModifiedBy] ,            
                          [ModifiedDate] ,            
                          ClientId ,            
                          PhoneNumber ,            
                          PhoneNumberText ,            
                          PhoneType ,            
                          IsPrimary            
                        )            
                VALUES  ( @CurrentUser ,            
                          GETDATE() ,            
                          @CurrentUser ,            
                          GETDATE() ,         
                          @ClientId ,            
                          @MemberCell ,            
                          @MemberCell ,            
                          34 ,            
                          'N'            
                        )              
            END               
        END   
                 
	END try      
	BEGIN catch                   
		DECLARE @Error VARCHAR(8000)                   
	              
		SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'                   
					+ CONVERT(VARCHAR(4000), Error_message())                   
					+ '*****'                   
					+ Isnull(CONVERT(VARCHAR, Error_procedure()),                   
					'ssp_scUpdateInquiryClientContacts' )                   
					+ '*****' + CONVERT(VARCHAR, Error_line())                   
					+ '*****' + CONVERT(VARCHAR, Error_severity())                   
					+ '*****' + CONVERT(VARCHAR, Error_state())                   
	              
		RAISERROR ( @Error,-- Message text.                                               
					16,-- Severity.                                               
					1 -- State.    
		);                   
	END catch                   
END   