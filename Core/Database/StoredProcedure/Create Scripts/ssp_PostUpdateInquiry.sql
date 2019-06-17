/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateInquiry]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateInquiry]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PostUpdateInquiry]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateInquiry]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [DBO].[ssp_PostUpdateInquiry]          
    @ScreenKeyId INT ,          
    @StaffId INT ,          
    @CurrentUser VARCHAR(30) ,          
    @CustomParameters XML            
  
/************************************************************************************************                                    
**  File:                                                       
**  Name: ssp_PostUpdateInquiry                                                      
**  Desc: This storeProcedure will executed on post update of Inquiry             
**            
**  Parameters:             
**  Input   @ScreenKeyId INT,            
 @StaffId INT,            
 @CurrentUser VARCHAR(30),            
 @CustomParameters XML             
**  Output     ----------       -----------             
**              
**  Auth:  RK         
**  Date:  Dec 19, 2017            
*************************************************************************************************            
**  Change History              
*************************************************************************************************             
**  Date:   Author:   Description:             
**  --------  --------  -------------------------------------------------------------            
** Jan 4, 2012  Pralyankar  Created.            
**  23 Jan 2012  Sudhir Singh updated for column [SSNUnknown]            
**  3 FEB 2012  Sudhir Singh    UPDATE THE GLOBALCODES IN PCM            
** March 18, 2012 Pralyankar  Modified to call sp for updating Client Contacts for inquiry.            
** March 21, 2012 Pralyankar  Modified messages for inquiry.            
**  April 4, 2012 Pralyankar  Modified for Getting UserCode from CM Database.            
**  April 20, 2012 Pralyankar  Modified for pulling staff ID from StaffDatabaseAccess table.            
   15 Feb 2013  Saurav Pande Taken From CentraWellness Folder w.r.t task#13 in Newaygo Customizations             
** 08 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*            
** 04 FEB 2014 dknewtson Remmoving validation and insert information for AssignedTo, GatheredBy - This information is unneccesary in CM.          
** 04 FEB 2014 dknewtson Adding Identity_Insert on to insert on CustomInquiryEvents table to prevent errors being thrown on insert.          
** 05/19/2015  njain  Added post update per the new fields added to Client Custom Fields, Valley Client Acceptance Testing Issues #47          
** 01 Jun 2015 Venkatesh Check the condition whether coverage plans are duplicate or not from ClientCoveragePlans table.Ref Task no 88 in Valley Client Acceptence Testing.          
** 09/03/2015  njain  Added clientid join on update ClientCoveragePlans - Valley Go Live          
*************************************************************************************************/          
AS          
    BEGIN            
            
 ------ Get ID of System Database ------            
        DECLARE @CurrentDatabaseDatabaseId INT            
        SELECT  @CurrentDatabaseDatabaseId = SystemDatabaseId          
        FROM    SystemConfigurations            
 ----------------------------------------            
            
        DECLARE @ClientID INT ,          
            @CareManagementId INT ,          
            @InquiryEventId INT ,          
            @InProgressStatusClientID INT ,          
            @FirstName VARCHAR(50) ,          
            @LastName VARCHAR(50) ,          
            @DOB DATETIME ,          
            @SSN VARCHAR(15) ,          
            @AssignedPopulation INT ,          
            @PreviousCareManagementId INT ,          
            @MasterStaffId INT ,          
            @MasterStaffUserCode VARCHAR(100) ,          
            @GatheredBy INT ,          
            @RecordedBy INT ,          
            @AssignedToStaffId INT            
              
        DECLARE @DynamicQuery NVARCHAR(4000)            
       DECLARE @UpdateClientContacts CHAR(1)            
        DECLARE @InquiryStartDate DATETIME          
            
        DECLARE @ValidationErrors TABLE          
            (          
              TableName VARCHAR(200) ,          
              ColumnName VARCHAR(200) ,          
     ErrorMessage VARCHAR(2000) ,          
              PageIndex INT ,          
              TabOrder INT ,          
              ValidationOrder INT          
           )              
            
        BEGIN TRY            
            SET nocount ON              
          
            UPDATE  CCP          
            SET     CCP.GroupNumber = CI.GroupId ,          
                    CCP.InsuredId = CI.InsuredId          
            FROM    ClientCoveragePlans CCP          
                    INNER JOIN InquiryCoverageInformations CI ON CI.CoveragePlanId = CCP.CoveragePlanId          
                                                                         AND CI.InquiryId = @ScreenKeyId          
                    JOIN dbo.Inquiries inq ON inq.InquiryId = CI.InquiryId          
                                                    AND inq.ClientId = CCP.ClientId          
                                                                                   
          
 -----------------------------------------------------------            
    --Push the vlaues into clientcoverageplans          
            IF EXISTS ( SELECT  *          
                        FROM    InquiryCoverageInformations          
                        WHERE   InquiryId = @ScreenKeyId )          
                BEGIN          
                    SELECT  @ClientID = ClientId ,          
                            @InquiryStartDate = InquiryStartDateTime          
                    FROM    inquiries          
                    WHERE   InquiryId = @ScreenKeyId          
                            AND ISNULL(RecordDeleted, 'N') = 'N'          
                                              
                    INSERT  INTO ClientCoveragePlans          
                            ( ClientId ,          
                              CoveragePlanId ,          
                              InsuredId ,          
                              GroupNumber ,          
                              ClientIsSubscriber ,          
                              ClientHasMonthlyDeductible ,          
                              ModifiedDate          
                            )          
                            SELECT  @ClientID AS ClientId ,          
                                    CoveragePlanId ,          
                                    InsuredId ,          
                                    GroupId AS GroupNumber,          
                                    'N' AS ClientIsSubscriber,          
                                    'N' AS ClientHasMonthlyDeductible,          
                                    ModifiedDate          
                            FROM    InquiryCoverageInformations CI          
                            WHERE   CI.InquiryId = @ScreenKeyId  AND ISNULL(CI.RecordDeleted, 'N') = 'N'         
                                    AND NOT EXISTS ( SELECT *          
                                                     FROM   ClientCoveragePlans CC          
                                                     WHERE  cc.ClientId = @ClientID          
                                                            AND CC.CoveragePlanId = CI.CoveragePlanId          
                                                            AND CC.InsuredId = CI.InsuredId 
                                                            AND ISNULL(CC.RecordDeleted, 'N') = 'N')          
                END          
            --DECLARE @InsuranceComment VARCHAR(100)          
            SET @ClientID = ( SELECT    ClientId          
                              FROM      Inquiries          
                              WHERE     InquiryId = @ScreenKeyId          
                            )             
  ----------------------------------------------------          
   
 
  --Push the vlaues into ClientCoveragePlanNotes
	  IF EXISTS ( SELECT  1 FROM ClientCoveragePlanNotes CC          
							JOIN Inquiries CI ON CC.ClientId = CI.ClientId AND CI.InquiryId = @ScreenKeyId 
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(CI.RecordDeleted, 'N') = 'N')
							
			BEGIN
					UPDATE  CC SET CC.CoverageInformation = CI.CoverageInformation
							FROM ClientCoveragePlanNotes CC          
							JOIN Inquiries CI ON CC.ClientId = CI.ClientId AND CI.InquiryId = @ScreenKeyId
							Where ISNULL(CC.RecordDeleted, 'N') = 'N' And ISNULL(CI.RecordDeleted, 'N') = 'N'
			END
		ELSE
			BEGIN
					INSERT  INTO ClientCoveragePlanNotes          
								( ClientId ,          
								  CoverageInformation    
								)          
							SELECT  ClientId ,          
									CoverageInformation       
							FROM    Inquiries           
							WHERE   InquiryId = @ScreenKeyId And ISNULL(RecordDeleted, 'N') = 'N'
			END
			
			
	-- Inserting Flag details
		DECLARE @FlagTypeId int 
		SET @FlagTypeId = (SELECT Top 1 FlagTypeId FROM dbo.FlagTypes WHERE FlagType = 'Client Plan Coverage Information')

		IF NOT EXISTS(SELECT 1 FROM dbo.ClientNotes b
									Inner Join dbo.Inquiries a on b.ClientId = a.ClientId AND  b.StartDate = a.InquiryStartDateTime
									AND a.InquiryId = @ScreenKeyId --AND a.CoverageInformation IS NOT NULL
									WHERE b.NoteType = @FlagTypeId
									  AND ISNULL(b.RecordDeleted, 'N') = 'N')
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
								a.ClientId,
								@FlagTypeId,
								4501,
								SUBSTRING(a.CoverageInformation,1,100),
								'Y',
								a.InquiryStartDateTime,
								@CurrentUser,
								@CurrentUser
							  FROM dbo.Inquiries a
							  WHERE a.InquiryId = @ScreenKeyId AND a.CoverageInformation IS NOT NULL
		END
		ELSE
		BEGIN
		
				DECLARE @ModifiedDate datetime
				DECLARE @Note varchar(100)
				--DECLARE @ClientId int
				DECLARE @ClientNoteStartDate datetime
				
				SET @ModifiedDate = GetDate();
				
				Select top 1 @Note = SUBSTRING(a.CoverageInformation,1,100), @ClientId = a.ClientId, @ClientNoteStartDate = b.StartDate
					FROM dbo.ClientNotes b
					Inner Join dbo.Inquiries a on b.ClientId = a.ClientId AND  b.StartDate = a.InquiryStartDateTime
					AND a.InquiryId = @ScreenKeyId --AND a.CoverageInformation IS NOT NULL
					WHERE b.NoteType = @FlagTypeId AND ISNULL(b.RecordDeleted, 'N') = 'N'
		

			    Update  ClientNotes  
				Set  ModifiedDate = GetDate(), ModifiedBy = @CurrentUser, Note = @Note
				Where  ClientId = @ClientId AND  StartDate = @ClientNoteStartDate
				AND NoteType = @FlagTypeId
		END
										  
 -- -------------------------------------------------------
 -- Clients
      
            IF EXISTS ( SELECT  *          
                        FROM    Clients CC          
                                JOIN Inquiries CI ON CC.ClientId = CI.ClientId          
                                                           AND CI.InquiryId = @ScreenKeyId )          
                BEGIN          
                    UPDATE  CC          
                    SET     CC.Sex = CASE WHEN CI.Sex = 'M' THEN 'M'          
                                          WHEN CI.Sex = 'F' THEN 'F'          
											ELSE NULL          
										END        
						FROM    Clients CC          
								JOIN Inquiries CI ON CC.ClientId = CI.ClientId          
                                           AND CI.InquiryId = @ScreenKeyId           
                END          
            ELSE          
                BEGIN          
                    INSERT  INTO Clients          
                            ( ClientId ,          
                              Sex    
							)          
                            SELECT  ClientId ,          
                                    Sex       
                            FROM    Inquiries          
                            WHERE   InquiryId = @ScreenKeyId           
           
                END            
          
  -------------------------------------------------------------          
            
            
            
            IF EXISTS ( SELECT  CoveragePlanId          
                        FROM    ClientCoveragePlans          
                        WHERE   ClientId = @ClientID          
     GROUP BY CoveragePlanId          
                        HAVING  COUNT(*) > 1 )          
                BEGIN          
                    DECLARE @Notetype INT          
                    SET @Notetype = ( SELECT Top 1   FlagTypeId          
                                      FROM      FlagTypes          
                                      WHERE     FlagType = 'Duplicate Insurance Plan'          
                                    )          
                    UPDATE  ClientNotes          
                    SET     RecordDeleted = 'Y'          
                    WHERE   Notetype = @Notetype          
                            AND Note = 'Duplicate Insurance Plan'          
                            AND ClientId = @ClientID          
                    INSERT  INTO ClientNotes          
                            ( ClientId ,          
                              NoteType ,          
                              Active ,          
                              Note ,          
                              StartDate          
                            )          
                    VALUES  ( @ClientID ,          
                              @Notetype ,          
                              'Y' ,          
                              'Duplicate Insurance Plan' ,          
                              CONVERT(DATE, @InquiryStartDate)          
                            )          
                END          
            ELSE          
                BEGIN           
                    UPDATE  ClientNotes          
                    SET     RecordDeleted = 'Y'          
                    WHERE   Notetype = @Notetype          
                            AND Note = 'Duplicate Insurance Plan'          
                            AND ClientId = @ClientID          
                END          
  ----------------------------------------------------          
           
          
 /*  >>--------> Get PCM Master DB Name <--------<<   */            
            DECLARE @DBName VARCHAR(50)      
            SET @DBName = [dbo].[fn_GetPCMMasterDBName]()            
 -- >>>>>>>------------------------------------------------------->            
            SET @UpdateClientContacts = 'N'            
            
 ---- Get Core Globalcode ID for Inquiry Status Completed ----            
            DECLARE @CompletedGlobalCodeId INT            
            SELECT  @CompletedGlobalCodeId = GlobalCodeId          
            FROM    GlobalCodes          
            WHERE   Category = 'INQUIRYSTATUS'          
                    AND Code = 'COMPLETE'              
 ---------------------------------------------------------------            
            
            SELECT  @InProgressStatusClientID = ClientId,          
                    @GatheredBy = GatheredBy ,          
                    @RecordedBy = RecordedBy ,          
                    @AssignedToStaffId = AssignedToStaffId          
         FROM    inquiries          
            WHERE   InquiryId = @ScreenKeyId          
                    AND ISNULL(RecordDeleted, 'N') = 'N'            
            
          
 ---- IF Status is Not Complete then do not create Event --------            
            IF EXISTS ( SELECT  1          
                        FROM    inquiries          
                        WHERE   InquiryId = @ScreenKeyId          
                                AND ISNULL(RecordDeleted, 'N') = 'N'          
                                AND InquiryStatus = @CompletedGlobalCodeId )-- Inquiry Status Completed            
                BEGIN            
                    SELECT  @ClientID = ClientId ,          
                 @InquiryEventId = InquiryEventId           
                    FROM    inquiries          
                    WHERE   InquiryId = @ScreenKeyId          
                            AND ISNULL(RecordDeleted, 'N') = 'N'            
                END-- IF EXISTS(SELECT 1 FROM inquiries WHERE InquiryId = @ScreenKeyId  and isnull(RecordDeleted,'N') = 'N' AND InquiryStatus = @CompletedGlobalCodeId )            
            
 -- If Client ID is greater than zero then update Client Infromation In Clients(Clients, ClientContact, ClientContactPhones, clientepisodes) table            
 -- Update Client Contacts only if Inquiry is not completed. Here "isnull(@InquiryEventId,0) = 0" is used for checking this condition.            
            IF ISNULL(@InProgressStatusClientID, 0) > 0          
                AND ISNULL(@InquiryEventId, 0) = 0          
                BEGIN            
                    EXEC ssp_scUpdateInquiryClientContacts @ScreenKeyId, @InProgressStatusClientID, @CurrentUser, @StaffId            
                    SET @UpdateClientContacts = 'Y'            
                END            
          
          
 -- Check If @InquiryEventId >0 then Delete the InquiryEvent From CM/PA Database            
            IF ( ISNULL(@InProgressStatusClientID, 0) = 0          
                 AND @InquiryEventId > 0          
               )          
           BEGIN            
                    EXEC ssp_scRemoveInquiryClient @ScreenKeyId, @StaffId, @CurrentUser            
                    RETURN ---- If Client ID is null in Inquiries table then return from the SP            
                END            
            ELSE          
                IF ( ISNULL(@ClientID, 0) = 0          
                     AND ISNULL(@InquiryEventId, 0) = 0          
                   )          
                    BEGIN            
                        RETURN ---- If Client ID is null in Inquiries table then return from the SP            
                    END            
            
                ELSE          
                    IF ( ISNULL(@ClientID, 0) > 0          
                         AND ISNULL(@InquiryEventId, 0) > 0          
                       )          
                        BEGIN            
  ---------------- Get Previous CareManagementId  ------------            
                            SET @DynamicQuery = 'SELECT @PreviousCareManagementId = ClientId FROM [' + @DBName + '].[dbo].[Events] WHERE EventId = ' + CAST(@InquiryEventId AS VARCHAR(10))            
                            EXEC sp_executesql @DynamicQuery, N'@PreviousCareManagementId INT OUTPUT', @PreviousCareManagementId OUTPUT            
   ------------------------------------------------------------            
                        END            
            
 ------- Get User Code of Staff from CM/PA Database -------------->            
            SET @DynamicQuery = 'SELECT @MasterStaffId = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + CAST(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' + 
CAST(@StaffId AS VARCHAR(10))            
            EXEC sp_executesql @DynamicQuery, N'@MasterStaffId INT OUTPUT', @MasterStaffId OUTPUT            
            
            SET @DynamicQuery = 'SELECT @MasterStaffUserCode = UserCode FROM [' + @DBName + '].[dbo].[Staff] WHERE StaffId = ' + CAST(@MasterStaffId AS VARCHAR(10))            
            EXEC sp_executesql @DynamicQuery, N'@MasterStaffUserCode VARCHAR(100) OUTPUT', @MasterStaffUserCode OUTPUT            
            
 
          
 --- Create master client -----            
            EXEC ssp_CreateMasterClient @MasterStaffUserCode, @ClientId, @CareManagementId OUTPUT            
 ------------------------------------------     
   
 ----------- Update CamemanagementId --------------------            
            IF ( @CareManagementId > 0 )          
                BEGIN            
                    UPDATE  Clients          
                    SET     CareManagementId = @CareManagementId          
                    WHERE   CLientId = @ClientId            
                END            
 --------------------------------------------------------       
           
           
-- If User has Chnages the Client from the page then remove the Previous Document/Event And create new .            
            IF ( @CareManagementId <> @PreviousCareManagementId          
          AND ISNULL(@InquiryEventId, 0) > 0          
               )          
                BEGIN            
                    EXEC ssp_scRemoveInquiryClient @ScreenKeyId, @StaffId, @MasterStaffUserCode            
                END            
 -------------------------------------------------------------------------------------------            
            
            
 ---- Execute dynamic query for creating InquiryEvent ----            
            DECLARE @CurrentDBName VARCHAR(50) ,          
                @NewEventId INT ,          
                @NewDocumentVersionID INT            
            SELECT  @CurrentDBName = DB_NAME()            
                    
            
 ---------- Get global codes from pcm ----------------------            
            DECLARE @UrgencyLevelCategory VARCHAR(20) ,          
                @UrgencyLevelCode VARCHAR(100) ,          
                @UrgencyLevel INT ,          
                @InquiryTypeCategory VARCHAR(20) ,          
                @InquiryTypeCode VARCHAR(100) ,          
    @InquiryType INT ,          
                @ContactTypeCategory VARCHAR(20) ,          
                @ContactTypeCode VARCHAR(100) ,          
                @ContactType INT ,          
                @SATypeCategory VARCHAR(20) ,          
                @SATypeCode VARCHAR(100) ,          
                @SAType INT ,          
                @PresentingPopulationCategory VARCHAR(20) ,          
                @PresentingPopulationCode VARCHAR(100) ,          
                @PresentingPopulation INT ,          
                @ReferralTypeCategory VARCHAR(20) ,          
                @ReferralTypeCode VARCHAR(100) ,          
                @ReferralType INT ,          
                @ReferralSubtypeCategory VARCHAR(20) ,          
                @ReferralSubtypeCode VARCHAR(100) ,          
                @ReferralSubtype INT ,          
                @LivingCategory VARCHAR(20) ,          
                @LivingCode VARCHAR(100) ,          
                @Living INT ,          
                @NoOfBedsCategory VARCHAR(20) ,          
                @NoOfBedsCode VARCHAR(100) ,          
                @NoOfBeds INT ,          
                @CorrectionStatusCategory VARCHAR(20) ,          
                @CorrectionStatusCode VARCHAR(100) ,          
                @CorrectionStatus INT ,          
                @EducationalStatusCategory VARCHAR(20) ,          
                @EducationalStatusCode VARCHAR(100) ,          
                @EducationalStatus INT ,          
                @EmploymentStatusCategory VARCHAR(20) ,          
                @EmploymentStatusCode VARCHAR(100) ,          
                @EmploymentStatus INT            
            
            SELECT  @UrgencyLevelCategory = ISNULL(ULC.Category, '') ,          
                    @UrgencyLevelCode = ISNULL(ULC.Code, '') ,          
                    @InquiryTypeCategory = ISNULL(ITC.Category, '') ,          
                    @InquiryTypeCode = ISNULL(ITC.Code, '') ,          
                    @ContactTypeCategory = ISNULL(CTC.Category, '') ,          
                    @ContactTypeCode = ISNULL(CTC.Code, '') ,          
                    @SATypeCategory = ISNULL(SATC.Category, '') ,          
                    @SATypeCode = ISNULL(SATC.Code, '')             
  --,@PresentingPopulationCategory = ISNULL(PPC.Category,''), @PresentingPopulationCode = ISNULL(PPC.Code,'')             
                    ,          
                    @ReferralTypeCategory = ISNULL(RTC.Category, '') ,          
                    @ReferralTypeCode = ISNULL(RTC.Code, '') ,          
                    @ReferralSubtypeCategory = ISNULL(RSTC.Category, '') ,          
                    @ReferralSubtypeCode = ISNULL(RSTC.Code, '') ,          
                    @LivingCategory = ISNULL(LC.Category, '') ,          
                    @LivingCode = ISNULL(LC.Code, '') ,          
                    @NoOfBedsCategory = ISNULL(NOBC.Category, '') ,          
                    @NoOfBedsCode = ISNULL(NOBC.Code, '') ,          
                    @CorrectionStatusCategory = ISNULL(CSC.Category, '') ,          
                    @CorrectionStatusCode = ISNULL(CSC.Code, '') ,          
                    @EducationalStatusCategory = ISNULL(EdSC.Category, '') ,          
                    @EducationalStatusCode = ISNULL(EdSC.Code, '') ,          
                    @EmploymentStatusCategory = ISNULL(EpSC.Category, '') ,          
                    @EmploymentStatusCode = ISNULL(EpSC.Code, '')          
            FROM    Inquiries CIE          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] ULC ON CIE.UrgencyLevel = ULC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] ITC ON CIE.InquiryType = ITC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] CTC ON CIE.ContactType = CTC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] SATC ON CIE.SAType = SATC.GlobalCodeId            
  --LEFT OUTER JOIN [dbo].[GlobalCodes] PPC ON CIE.PresentingPopulation = PPC.GlobalCodeId            
                    LEFT OUTER JOIN [dbo].[GlobalCodes] RTC ON CIE.ReferralType = RTC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] RSTC ON CIE.ReferralSubtype = RSTC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] LC ON CIE.Living = LC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] NOBC ON CIE.NoOfBeds = NOBC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] CSC ON CIE.CorrectionStatus = CSC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] EdSC ON CIE.EducationalStatus = EdSC.GlobalCodeId          
                    LEFT OUTER JOIN [dbo].[GlobalCodes] EpSC ON CIE.EmploymentStatus = EpSC.GlobalCodeId          
            WHERE   CIE.InquiryId = CAST(@ScreenKeyId AS VARCHAR)             
            
            
 ---- Delete existing record and insert new row for expected error----            
 --DELETE FROM @ValidationErrors            
 --INSERT INTO @ValidationErrors (TableName, ColumnName, ErrorMessage)                    
 --SELECT 'GlobalCode', 'GlobalCodeId', 'This inquiry is unable to be completed because the information needed for Inquiry does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'              
 -----------------------------------------------------------------             
            
            SET @DynamicQuery = 'select @UrgencyLevel = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @UrgencyLevelCategory + ''', ''' + @UrgencyLevelCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@UrgencyLevel INT output', @UrgencyLevel OUTPUT            
            SET @DynamicQuery = 'select @InquiryType = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @InquiryTypeCategory + ''', ''' + @InquiryTypeCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@InquiryType INT output', @InquiryType OUTPUT            
            SET @DynamicQuery = 'SELECT @ContactType = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @ContactTypeCategory + ''', ''' + @ContactTypeCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@ContactType INT output', @ContactType OUTPUT            
            SET @DynamicQuery = 'SELECT @SAType = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @SATypeCategory + ''', ''' + @SATypeCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@SAType INT output', @SAType OUTPUT             
            SET @DynamicQuery = 'select @PresentingPopulation = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @PresentingPopulationCategory + ''', ''' + @PresentingPopulationCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@PresentingPopulation INT output', @PresentingPopulation OUTPUT            
            SET @DynamicQuery = 'select @ReferralType = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @ReferralTypeCategory + ''', ''' + @ReferralTypeCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@ReferralType INT output', @ReferralType OUTPUT            
            SET @DynamicQuery = 'select @ReferralSubtype = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @ReferralSubtypeCategory + ''', ''' + @ReferralSubtypeCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@ReferralSubtype INT output', @ReferralSubtype OUTPUT            
            SET @DynamicQuery = 'select @Living = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @LivingCategory + ''', ''' + @LivingCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@Living INT output', @Living OUTPUT            
            SET @DynamicQuery = 'select @NoOfBeds = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @NoOfBedsCategory + ''', ''' + @NoOfBedsCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@NoOfBeds INT output', @NoOfBeds OUTPUT             
            SET @DynamicQuery = 'select @CorrectionStatus = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @CorrectionStatusCategory + ''', ''' + @CorrectionStatusCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@CorrectionStatus INT output', @CorrectionStatus OUTPUT            
            SET @DynamicQuery = 'select @EducationalStatus = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @EducationalStatusCategory + ''', ''' + @EducationalStatusCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@EducationalStatus INT output', @EducationalStatus OUTPUT             
            SET @DynamicQuery = 'select @EmploymentStatus = [' + @DBName + '].[dbo].[fn_GetGlobalCode](''' + @EmploymentStatusCategory + ''', ''' + @EmploymentStatusCode + ''')'            
            EXEC sp_executesql @DynamicQuery, N'@EmploymentStatus INT OUTPUT', @EmploymentStatus OUTPUT            
            
            DECLARE @PCMProgramId INT ,          
                @ProgramId INT            
            
            SELECT  @ProgramId = ProgramId          
            FROM    Inquiries          
            WHERE   inquiryId = @ScreenKeyId            
            
            
            
  -- Assigned to, Gathered By, and Recorded by does not need to validate accross           
 ------- Get Mapping StaffId From StaffDatabaseAccess table for Field 'GatheredBy', 'RecordDedBy' and 'AssignedToStaffId' ------            
            DECLARE /*@PCMGatheredBy INT,*/ @PCMRecordedBy INT--, @PCMAssignedToStaffId INT            
            
 --If isnull(@GatheredBy,0) >0             
 -- BEGIN            
 --  SET @DynamicQuery = 'SELECT @PCMGatheredBy = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' + cast(@GatheredBy as VARCHAR(10))            
 --  EXEC sp_executesql @DynamicQuery, N'@PCMGatheredBy INT OUTPUT', @PCMGatheredBy output            
 -- END            
            
            IF ISNULL(@RecordedBy, 0) > 0          
                BEGIN            
                    SET @DynamicQuery = 'SELECT @PCMRecordedBy = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + CAST(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId
  
    
      
        
 = ' + CAST(@RecordedBy AS VARCHAR(10))            
                    EXEC sp_executesql @DynamicQuery, N'@PCMRecordedBy INT OUTPUT', @PCMRecordedBy OUTPUT            
                END            
 --If isnull(@AssignedToStaffId,0) >0            
 -- BEGIN            
 --  SET @DynamicQuery = 'SELECT @PCMAssignedToStaffId = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' + cast(@AssignedToStaffId as VARCHAR(10))            
 --  EXEC sp_executesql @DynamicQuery, N'@PCMAssignedToStaffId INT OUTPUT', @PCMAssignedToStaffId output            
 -- END            
             
            IF (--(isnull(@GatheredBy,0) >0 and isnull(@PCMGatheredBy,0) = 0)             
  /*OR*/ (ISNULL(@RecordedBy, 0) > 0          
                 AND ISNULL(@PCMRecordedBy, 0) = 0)            
  --OR (isnull(@AssignedToStaffId,0) >0 and isnull(@PCMAssignedToStaffId,0) = 0)           
               )          
                BEGIN            
  ---- Delete existing record and insert new row for expected error ----            
  --Delete FROM @ValidationErrors            
  --insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)                    
 -- select 'StaffDatabaseAccess', 'StaffId', 'This inquiry is unable to be completed because the Staff Record for Recorded By Staff does not exist in the CareManagement system.  Please contact Technical Support to correct          
 --this problem.  Thank you'            
  -- + cast(isnull(@PCMGatheredBy,0) as VARCHAR) + ' ' + cast(isnull(@RecordedBy,0) as VARCHAR) + ' ' + cast(isnull(@PCMAssignedToStaffId,0) as VARCHAR) + ' -- ' + cast(isnull(@AssignedToStaffId,0) as VARCHAR)            
  -------------------------------------------------------------            
                    GOTO error            
                END            
 --------------------------------------------------------------------------------------------------------------            
            

 --  EXEC sp_executesql @DynamicQuery            
 --  ---------------------------------------------------------            
 -- END             
  /*NOTE -  As Per our discussion with David On Jan 13m 2012, We need not to create client with details filled by user on Inquiry Page ----            
  If user will link any client with Inquiry then we need to check its Care Management Id and if it not exist then we need to create this. */    
            
 ---- If No Error found in Execution of above scrip then Delete Rows from Validation Error, otherwise it will show wrong validation message in Post update message window ----             
            DELETE  FROM @ValidationErrors            
 ----------------------------------------            
            
            error:            
            IF ( SELECT COUNT(*)          
                 FROM   @ValidationErrors          
               ) > 0          
                BEGIN            
                    SELECT  *          
                    FROM    @ValidationErrors                 
                END            
        END TRY            
            
        BEGIN CATCH            
            
            IF ( SELECT COUNT(*)          
                 FROM   @ValidationErrors          
               ) > 0          
                BEGIN                 
                    SELECT  *          
                    FROM    @ValidationErrors                 
                END            
             
            DECLARE @ErrorMessage NVARCHAR(4000);            
            DECLARE @ErrorSeverity INT;            
            DECLARE @ErrorState INT;            
             
            SELECT  @ErrorMessage = ERROR_MESSAGE() ,          
                    @ErrorSeverity = ERROR_SEVERITY() ,          
                    @ErrorState = ERROR_STATE();            
 --INSERT INTO errorlog (ErrorMessage, ErrorType, CreatedBy, CreatedDate)            
 --   VALUES( @ErrorMessage, 'Error', 'twilliams', getdate())            
                
    -- Use RAISERROR inside the CATCH block to return             
    -- error information about the original error that             
    -- caused execution to jump to the CATCH block.            
    --RAISERROR (@ErrorMessage, -- Message text.            
    --           @ErrorSeverity, -- Severity.            
    --           @ErrorState -- State.            
    --           );             
        END CATCH            
            
    END-- END of the SP 