/****** Object:  StoredProcedure [dbo].[csp_scUpdateInquiryClientContacts]    Script Date: 08/16/2013 17:51:52 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_scUpdateInquiryClientContacts]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[csp_scUpdateInquiryClientContacts]
GO

  
CREATE PROCEDURE [dbo].[csp_scUpdateInquiryClientContacts]
    (
      @InquiryId INT ,
      @ClientId INT ,
      @CurrentUser VARCHAR(50)
    )  
/******************************************************************************  
**  File:   
**  Name: csp_scUpdateInquiryClientContacts   
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
   10-Oct-2012	Vichee	 Added Active='Y' while inserting the details into ClientContacts table. Core-Bugs 1198	
   01-Jun-2015	NJain	 Added Number of Dependents in CustomClients to post update
/*	Venkatesh MR	6/03/2015		#111 Post Update Household annual income  to Client CUstom Fields*/	
/*	Alok Kumar		01/18/2016		Post Update ReferralReason from CustomInquiries to ClientEpisodes		*/ 
/*										for task##175 New Directions - Support Go Live						*/
/*	Alok Kumar		03/30/2016		Updated Clients CurrentEpisodeNumber to 1 when ClientEpisodes is created from Inquiry		*/ 
/*										for task##175 New Directions - Support Go Live						*/
*************************************************************************************************************/
AS
    BEGIN  
  
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
            @GardianComment VARCHAR(MAX) ,
            @GuardianPhoneNumber VARCHAR(128) ,
            @GuardianSameAsCaller CHAR(1) ,
            @MemberPhone VARCHAR(100)  
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
  --, @GuardianRelation = GuardianRelation, @GuardianDOB = GuardianDOB, @GardianComment = GardianComment  
                ,
                @GuardianPhoneNumber = GuardianPhoneNumber ,
                @GuardianSameAsCaller = ISNULL(GuardianSameAsCaller, 'N') ,
                @MemberPhone = MemberPhone
        FROM    CustomInquiries
        WHERE   InquiryId = @InquiryId  
  
  ---- Update Client Information -----  
        UPDATE  C
        SET     C.FirstName = CI.MemberFirstName ,
                C.LastName = CI.MemberLastName ,
                C.MiddleName = CI.MemberMiddleName ,
                C.SSN = CI.SSN ,
                C.DOB = CI.DateOfBirth ,
                C.Email = CI.MemberEmail ,
                C.LivingArrangement = CI.Living ,
                C.NumberOfBeds = CI.NoOfBeds ,
                C.CountyOfResidence = CI.CountyOfResidence ,
                C.CorrectionStatus = CI.CorrectionStatus    
   --, C.EducationalStatus = CI.Education   
                ,
                C.EmploymentStatus = CI.EmploymentStatus ,
                C.AnnualHouseholdIncome = CI.IncomeGeneralHouseholdAnnualIncome ,
                C.NumberOfDependents = CI.IncomeGeneralDependents ,
                C.MaritalStatus = CI.OtherDemographicsMaritalStatus   
   --, C.EmploymentInformation = CI.EmployerName    
   --, C.MinimumWage = CASE WHEN rtrim(ltrim(CI.MinimumWage)) = 'Y' THEN 'Yes' ELSE 'No' END   
   --, C.Sex = CI.Sex   
                ,
                C.ModifiedDate = GETDATE() ,
                C.ModifiedBy = @CurrentUser ,
                C.PrimaryLanguage = CI.PrimarySpokenLanguage
        FROM    Clients C
                INNER JOIN CustomInquiries CI ON CI.ClientId = C.ClientId
        WHERE   CI.InquiryId = @inquiryId 
  
        DECLARE @ClientEpisodesCount INT
        DECLARE @CustomClientsCount INT
        SELECT  @ClientEpisodesCount = COUNT(*)
        FROM    ClientEpisodes
        WHERE   ClientId = @ClientId
        SELECT  @CustomClientsCount = COUNT(*)
        FROM    CustomClients
        WHERE   ClientId = @ClientId
  
        DECLARE @CreatedBy VARCHAR(100)
        DECLARE @CreatedDate DATETIME
   
        SELECT  @CreatedBy = CreatedBy ,
                @CreatedDate = CreatedDate
        FROM    Clients
        WHERE   ClientId = @ClientId
        IF ( @ClientEpisodesCount > 0 )
            BEGIN
                UPDATE  CE
                SET     CE.ReferralDate = CI.ReferralDate ,
                        CE.ReferralName = CI.ReferalLastName + ', ' + CI.ReferalFirstName ,
                        CE.ReferralType = CI.ReferralType ,
                        CE.ReferralSubtype = CI.ReferralSubtype,
                        CE.ReferralReason1 = CI.ReferralReason,
                        CE.ReferralReason2 = CI.ReferralReason,
                        CE.ReferralReason3 = CI.ReferralReason               
                FROM    ClientEpisodes CE
                INNER JOIN Clients C ON CE.ClientId = C.ClientId AND C.CurrentEpisodeNumber = CE.EpisodeNumber
                INNER JOIN CustomInquiries CI ON CI.ClientId = C.ClientId
				WHERE   CI.InquiryId = @inquiryId
            END
        ELSE
            BEGIN
                DECLARE @ReferralDate DATETIME
                DECLARE @ReferralName VARCHAR(200)
                DECLARE @ReferralType INT
                DECLARE @ReferralSubtype INT
                DECLARE @ReferralReason INT
                
                SELECT  @ReferralDate = ReferralDate ,
                        @ReferralName = ReferalLastName + ', ' + ReferalFirstName ,
                        @ReferralType = ReferralType ,
                        @ReferralSubtype = ReferralSubtype,
                        @ReferralReason = ReferralReason
                FROM    CustomInquiries
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
                          ReferralSubtype,
                          ReferralReason1,
                          ReferralReason2,
                          ReferralReason3
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
                          @ReferralSubtype,
                          @ReferralReason,
                          @ReferralReason,
                          @ReferralReason
                        )
                        
               UPDATE Clients SET CurrentEpisodeNumber = 1 WHERE ClientId = @ClientId
               
            END
  
        IF ( @CustomClientsCount > 0 )
            BEGIN  
                UPDATE  CC
                SET     CC.Legal = CI.OtherDemographicsLegal ,
                        CC.EducationLevel = CI.Education 
                FROM    CustomClients CC
                        INNER JOIN CustomInquiries CI ON CI.ClientId = CC.ClientId
                WHERE   CI.InquiryId = @inquiryId   
            END
        ELSE
            BEGIN
                DECLARE @OtherDemographicsLegal INT
                SELECT  @OtherDemographicsLegal = OtherDemographicsLegal
                FROM    CustomInquiries
                WHERE   InquiryId = @inquiryId
                INSERT  INTO CustomClients
                        ( CreatedBy ,
                          CreatedDate ,
                          ModifiedBy ,
                          ModifiedDate ,
                          ClientId ,
                          Legal 
                        )
                        SELECT  @CreatedBy ,
                                @CreatedDate ,
                                @CreatedBy ,
                                @CreatedDate ,
                                @ClientId ,
                                @OtherDemographicsLegal 
                        FROM    dbo.CustomInquiries
                        WHERE   InquiryId = @inquiryId   

            END
  
  ------------------------------------------------------------------------  
  
  ------ Update Client Address ------------------  
        IF EXISTS ( SELECT  1
                    FROM    ClientAddresses CA
                            INNER JOIN CustomInquiries CI ON CI.ClientId = CA.ClientId
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
                        INNER JOIN CustomInquiries CI ON CI.ClientId = CA.ClientId
                                                         AND CA.AddressType = 90 -- 90 = Home    
                WHERE   CI.InquiryId = @inquiryId    
            END  
        ELSE
            BEGIN  
                IF EXISTS ( SELECT  1
                            FROM    CustomInquiries CI
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
                                FROM    CustomInquiries
                                WHERE   InquiryId = @inquiryId   
                    END  
            END  
  -----------------------------------------------  
  
  -- Update Client Episode Informations ----------  
        UPDATE  CE
        SET     CE.ReferralDate = CI.ReferralDate ,
                CE.ReferralType = CI.ReferralType ,
                CE.ReferralSubtype = CI.ReferralSubtype ,
                CE.ReferralName = CI.ReferralName ,
                CE.ReferralAdditionalInformation = CI.ReferralAdditionalInformation ,
                CE.ModifiedDate = GETDATE() ,
                CE.ModifiedBy = @CurrentUser,
                CE.ReferralReason1 = CI.ReferralReason,
                CE.ReferralReason2 = CI.ReferralReason,
                CE.ReferralReason3 = CI.ReferralReason
        FROM    ClientEpisodes CE
                INNER JOIN Clients C ON CE.ClientId = C.ClientId
                                        AND C.CurrentEpisodeNumber = CE.EpisodeNumber
                INNER JOIN CustomInquiries CI ON CI.ClientId = C.ClientId
        WHERE   CI.InquiryId = @inquiryId  
  -----------------------------------------------  
  
 /* 1. Insert Row in ClientContract for Inquirer  
    2. Insert Row in Client Contract for Emergency contract.  
    3. If Client CustomInquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian   
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
 -- 3. If Client CustomInquiries.ClientCanLegalySign = 'N' then enter row in client contracts for Guardian   
 --  Whether user has selected any other relaship in the popup dropdown  
        IF @GuardianSameAsCaller = 'N'
            AND EXISTS ( SELECT 1
                         FROM   CustomInquiries
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
                                  @GardianComment ,
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
                                    [Comment] = @GardianComment ,
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
                    WHERE   ClientId = @ClientId )
            BEGIN  
                UPDATE  CP
                SET     CP.PhoneNumber = CI.MemberPhone ,
                        CP.PhoneNumberText = CI.MemberPhone ,
                        CP.ModifiedDate = GETDATE() ,
                        CP.ModifiedBy = @CurrentUser
                FROM    ClientPhones CP
                        INNER JOIN CustomInquiries CI ON CI.ClientId = CP.ClientId
                WHERE   CI.InquiryId = @inquiryId   
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
                          @MemberPhone ,
                          @MemberPhone ,
                          30 ,
                          'N'
                        )  
            END  
    
    END
GO


