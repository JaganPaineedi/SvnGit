IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_SCPostUpdateRegistrationDocument]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_SCPostUpdateRegistrationDocument] 

GO 

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[csp_SCPostUpdateRegistrationDocument]
-- csp_SCPostUpdateRegistrationDocument 4, 550,'ADMIN', ''
(@ScreenKeyId       INT
 ,@StaffId          INT
 ,@CurrentUser      VARCHAR(30)
 ,@CustomParameters XML)
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCPostUpdateRegistrationDocument]               */
/* Creation Date:  08 Sept 2014                                    */
/* Author:  Malathi Shiva                     */
/* Purpose: To update data after sign */
/* Data Modifications:                   */
/*  Modified By    Modified Date    Purpose        */
/*   jcarlson		10/9/2015	  commented out creation of program enrollment and updated clientprograms to primary = 'N' per New Directions - Support Go Live 55
	 tremisoski		10/14/2015		Changed to ensure we would not enroll multiple episodes or programs
	 jcarlson		11/12/2015	added in logic to move data from custom table to core tables, such at client phones, address, missing data in clients custom clients etc.
                                                          */
--   jcarlson		12/30/2015 ClientIsSubscriber to 'Yes' in the creation of client coverage plans
-- jcarlson		1/18/2016	  updated creation of client addreses, if it already exists, then update current record
-- jcarlson         1/19/2016   added in creation of client address history records
-- MD				03/29/2019  Added logic to hard delete the record deleted marked entry of CustomClients table to avoid primary key constrain error w.r.t New Directions - Support Go Live #941
-- MD				03/29/2019  Changed the INNER JOIN to LEFT JOIN with GlobalCodes for first update statement because it was not updating if military status is null w.r.t New Directions - Support Go Live #935
  /*********************************************************************/
  BEGIN
      BEGIN TRY

	  -- Make sure this is the first signer of this version, otherwise return
	  -- Just in case we ever decide to allow edits of admission documents.
	if exists (
		select *
		from DocumentSignatures as ds
		join Documents as d on d.DocumentId = ds.DocumentId and d.CurrentDocumentVersionId = ds.SignedDocumentVersionId and ds.StaffId <> d.AuthorId
		where ds.DocumentId = @ScreenKeyId
		and ds.SignatureDate is not null
	)
		RETURN
	
      DECLARE @ClientId int

      SELECT @ClientId = ClientId FROM Documents WHERE DocumentId = @ScreenKeyId AND ISNULL(RecordDeleted,'N')='N'

          UPDATE  C
            SET     C.FirstName = CDR.FirstName ,
                    C.MiddleName = CDR.MiddleName ,
                    C.LastName = CDR.LastName ,
                    C.SSN = CDR.SSN ,
                    C.DOB = CDR.DateOfBirth ,
                    c.Sex = CASE WHEN ( SELECT  GlobalCodeId
                                        FROM    GlobalCodes
                                        WHERE   GlobalCodeId = CDR.Sex
                                      ) = 5555 THEN 'M'
                                 WHEN ( SELECT  GlobalCodeId
                                        FROM    GlobalCodes
                                        WHERE   GlobalCodeId = CDR.Sex
                                      ) = 5556 THEN 'F'
                                 ELSE NULL
                            END ,
                    c.MaritalStatus = CDR.MaritalStatus ,
                    c.PrimaryLanguage = CDR.PrimaryLanguage ,
                    C.HispanicOrigin = CDR.HispanicOrigin ,
                    c.AccountingNotes = CDR.Financialcomment ,
                    C.PrimaryClinicianId = CDR.PrimaryCareCoOrdinatorId ,
                    C.Suffix = CDR.Suffix ,
                    C.MilitaryStatus = cast(msgc.ExternalCode1 AS int) , --e1 is for client core mapping
                    C.CountyOfTreatment = CDR.CountyOfTreatment ,
                    C.CountyOfResidence = CDR.ResidenceCounty ,
                    C.AnnualHouseholdIncome = CDR.HouseholdAnnualIncome ,
                    C.NumberOfDependents = CDR.DependentsInHousehold ,
                    C.LivingArrangement = CDR.LivingArrangments,
                    c.EducationalStatus = CDR.EducationalLevel,
                    c.EmploymentStatus = CDR.EmploymentStatus

            FROM    dbo.CustomDocumentRegistrations CDR
                    INNER JOIN dbo.Documents D ON D.DocumentId = @ScreenKeyId
                                              AND InProgressDocumentVersionId = CDR.DocumentVersionId
                                              AND ISNULL(D.RecordDeleted,'N')='N'
                    INNER JOIN dbo.Clients C ON D.ClientId = C.ClientId 
                    AND ISNULL(c.RecordDeleted,'N')='N'
                    LEFT JOIN dbo.GlobalCodes msgc ON msgc.GlobalCodeId = cdr.MilitaryService
                    AND msgc.Category = 'XMILITARYSERVICE'
                    AND ISNULL(msgc.RecordDeleted,'N')='N'
                    WHERE ISNULL(CDR.RecordDeleted,'N')='N'

          IF NOT EXISTS (SELECT 1
                         FROM   dbo.ClientRaces CR
                                INNER JOIN dbo.Documents D
                                        ON d.ClientId = cr.ClientId
                                        AND ISNULL(D.RecordDeleted,'N')='N'
                                INNER JOIN dbo.CustomDocumentRegistrations CDR
                                        ON CDR.Race = Cr.RaceId
                                        AND ISNULL(CDR.RecordDeleted,'N')='N'
                         WHERE  D.DocumentId = @ScreenKeyId
						  AND ISNULL(CR.RecordDeleted,'N')='N')
            BEGIN
                INSERT INTO dbo.ClientRaces
                            (ClientId
                             ,RaceId)
                SELECT D.ClientId
                       ,CDR.Race
                FROM   dbo.Documents D
                       INNER JOIN dbo.CustomDocumentRegistrations CDR
                               ON CDR.DocumentVersionId =
                                  D.InProgressDocumentVersionId
                                  AND cdr.Race IS NOT NULL
                                  AND ISNULL(CDR.RecordDeleted,'N')='N'
                       INNER JOIN clients C
                               ON D.ClientId = C.ClientId
                               AND ISNULL(C.RecordDeleted,'N')='N'
                WHERE  D.DocumentId = @ScreenKeyId
                AND ISNULL(D.RecordDeleted,'N')='N'
            END

          DECLARE @EpisodeNumber INT

          SET @EpisodeNumber = (SELECT Max(CE.EpisodeNumber) + 1
                                FROM   dbo.ClientEpisodes CE
                                WHERE ClientId = @ClientId
                                AND ISNULL(CE.RecordDeleted,'N')='N' )

          IF(@EpisodeNumber is null)
         BEGIN
			SET @EpisodeNumber = 1
         END


          INSERT INTO ClientEpisodes
                      (ClientId
                       ,EpisodeNumber
                       , IntakeStaff
                       ,RegistrationDate
                       ,[Status]
                       ,ReferralDate
                       ,ReferralType
                       ,ReferralSubtype
                       ,ReferralAdditionalInformation
                       ,ReferralName
                       )
          SELECT D.ClientId
                 ,@EpisodeNumber
                 ,@StaffId
                 ,CDR.RegistrationDate
                 ,100
                 ,CDR.ReferralDate
                 ,CDR.ReferralType
                 ,CDR.ReferralSubtype
                 , ISNULL(CDR.ReferralOrganization + '/ ','')
                  + ISNULL(CDR.ReferrralFirstName + '/ ','') + ISNULL(CDR.ReferrralLastName + '/ ','')
                  + ISNULL(CDR.ReferrralAddress1 + '/ ','')
                  + ISNULL(CDR.ReferrralAddress2 + ', ','')  + ISNULL(CDR.ReferrralCity + ', ','')
                  + ISNULL(CDR.ReferrralState + ', ','')  + ISNULL(CDR.ReferrralZipCode + ', ','')
                  + ISNULL(CDR.ReferrralPhone + ', ','')  + ISNULL(CDR.ReferrralEmail + '/ ','') + ISNULL(CDR.ReferrralComment,'') ,
                  cdr.ReferrralLastName + ', ' + cdr.ReferrralFirstName
                  
          FROM   dbo.Documents D
                 INNER JOIN CustomDocumentRegistrations CDR
                         ON CDR.DocumentVersionId =
                            D.InProgressDocumentVersionId
                            AND CDR.RegistrationDate IS NOT NULL
                            AND ISNULL(CDR.RecordDeleted,'N')='N'
                 INNER JOIN dbo.Clients C
                         ON C.ClientId = D.ClientId
                         AND ISNULL(C.RecordDeleted,'N')='N'
          WHERE  D.DocumentId = @ScreenKeyId
          AND ISNULL(D.RecordDeleted,'N')='N'
          -- only add episode if one does not exist
          and not exists (
			select *
			from ClientEpisodes as ce2
			where ce2.ClientId = d.ClientId
			and ce2.[Status] <> 102	-- non-discharged episode
			and isnull(ce2.RecordDeleted, 'N') = 'N'
		)

		-- jcarlson ND-SGL 55 this was causing the creation of duplicate program
		if
		-- signed document has a program selection
		exists (
			select *
			from Documents as d
            JOIN CustomDocumentRegistrations CDR ON CDR.DocumentVersionId = D.InProgressDocumentVersionId
				WHERE  D.DocumentId = @ScreenKeyId
				and CDR.PrimaryProgramId is not null
				and isnull(d.RecordDeleted, 'N') = 'N'
				and isnull(cdr.RecordDeleted, 'N') = 'N'
		)
		-- client program assignment does not exist
		and not exists (
			select *
			from ClientPrograms as cpg
			join Documents as d on d.ClientId = cpg.ClientId
            JOIN CustomDocumentRegistrations CDR ON CDR.DocumentVersionId = D.InProgressDocumentVersionId
				WHERE  D.DocumentId = @ScreenKeyId
				and CDR.PrimaryProgramId = cpg.ProgramId
				and cpg.[Status] <> 5
				and isnull(cpg.RecordDeleted, 'N') = 'N'
				and isnull(d.RecordDeleted, 'N') = 'N'
				and isnull(cdr.RecordDeleted, 'N') = 'N'
		)
		begin
				
			
          UPDATE dbo.ClientPrograms
          SET    PrimaryAssignment = 'N'
          FROM   dbo.Documents D
          WHERE  D.DocumentId = @ScreenKeyId
                 AND D.ClientId = ClientPrograms.ClientId
                 AND ISNULL(D.RecordDeleted,'N')='N'

          INSERT INTO ClientPrograms
                      (ClientId
                       ,ProgramId
                       ,[Status]
                       ,AssignedStaffId
                       ,RequestedDate
                       ,EnrolledDate
                       ,PrimaryAssignment
                       )
          SELECT D.ClientId
                 ,CDR.PrimaryProgramId
                 ,CDR.ProgramStatus
                 ,CDR.PrimaryCareCoOrdinatorId
                 ,CDR.ProgramRequestedDate
                 ,CDR.ProgramEnrolledDate
                 ,'Y'
          FROM   dbo.Documents D
                 INNER JOIN dbo.CustomDocumentRegistrations CDR
                         ON CDR.DocumentVersionId = D.InProgressDocumentVersionId
                            AND PrimaryProgramId IS NOT NULL
                            AND ISNULL(CDR.RecordDeleted,'N')='N'
          WHERE  D.DocumentId = @ScreenKeyId
          AND ISNULL(D.RecordDeleted,'N')='N'

          INSERT INTO ClientProgramHistory
                      (ClientProgramId
                       ,[Status]
                       ,AssignedStaffId
                       ,RequestedDate
                       ,EnrolledDate
                       ,PrimaryAssignment)
          SELECT Scope_identity()
                 ,[Status]
                 ,AssignedStaffId
                 ,RequestedDate
                 ,EnrolledDate
                 ,PrimaryAssignment
          FROM   ClientPrograms
          WHERE  ClientProgramId = Scope_identity()

		end
		
		-- removed dead code
		---new code jcarlson 11/12/2015 modified from valley registration document post sign script
DECLARE @InProgressDocumentVersionId INT
SELECT @InProgressDocumentVersionId = d.InProgressDocumentVersionId 
FROM dbo.Documents d
WHERE d.DocumentId = @ScreenKeyId
AND ISNULL(d.RecordDeleted,'N')='N'
-----------------------------------------------------------  
BEGIN
UPDATE CCP
 SET CCP.GroupNumber= CI.GroupId
, CCP.InsuredId= CI.InsuredId
,CCP.Comment = CI.Comment
FROM dbo.ClientCoveragePlans CCP
INNER JOIN CustomRegistrationCoveragePlans CI ON CI.CoveragePlanId=CCP.CoveragePlanId 
	   								  AND CI.DocumentVersionId= @InProgressDocumentVersionId
									  AND CCp.ClientId= @ClientID
									  AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
WHERE ISNULL(ccp.RecordDeleted,'N')='N'
END 
    --Push the values into clientcoverageplans
            IF EXISTS ( SELECT  1
                        FROM    CustomRegistrationCoveragePlans crcp
                        WHERE   crcp.DocumentVersionId = @InProgressDocumentVersionId
                         AND ISNULL(crcp.RecordDeleted,'N')='N')
                BEGIN
                                    
                    INSERT  INTO dbo.ClientCoveragePlans
                            ( ClientId ,
                              CoveragePlanId ,
                              InsuredId ,
                              GroupNumber ,
                              ClientIsSubscriber ,
                              ClientHasMonthlyDeductible ,
                              ModifiedDate,
                              Comment
                            )
                            SELECT  @ClientID ,
                                    CoveragePlanId ,
                                    InsuredId ,
                                    GroupId ,
                                    'Y' ,
                                    'N' ,
                                    ModifiedDate,
                                    CI.Comment
                            FROM    dbo.CustomRegistrationCoveragePlans CI
                            WHERE   DocumentVersionId = @InProgressDocumentVersionId
                                    AND ISNULL(CI.RecordDeleted, 'N') = 'N'
                                    AND NOT EXISTS ( SELECT *
                                                     FROM   dbo.ClientCoveragePlans CC
                                                     WHERE  cc.ClientId = @ClientID
                                                            AND CC.CoveragePlanId = CI.CoveragePlanId
                                                            AND CC.InsuredId = CI.InsuredId 
                                                            AND ISNULL(CC.RecordDeleted, 'N') = 'N' )
                END            
                
DECLARE @PCPRelation INT
            DECLARE @ClientContactId INT
            SET @PCPRelation = ( SELECT GlobalCodeId
                                 FROM   GlobalCodes
                                 WHERE  Code = 'Primary Physician'
                                        AND Category = 'RELATIONSHIP' AND ISNULL(RecordDeleted,'N')='N' AND ISNULL(Active,'Y')='Y'
                               )
                             
          
          
            DECLARE @ERPAddres VARCHAR(100)
            DECLARE @ERPPhone VARCHAR(50)
            DECLARE @ERPCity VARCHAR(30)
            DECLARE @ERPState CHAR(2)
            DECLARE @ERPZip VARCHAR(12)
            DECLARE @ERPListAs VARCHAR(700)
            DECLARE @ERPFirstName VARCHAR(100)
            DECLARE @ERPLastName VARCHAR(100)
            DECLARE @ERPOrganization VARCHAR(250)
            DECLARE @ERPEmail VARCHAR(100)
            DECLARE @ERPSuffix INT
          
            SELECT  @ERPAddres = ERP.Address ,
                    @ERPPhone = Erp.PhoneNumber ,
                    @ERPCity = ERP.City ,
                    @ERPState = S.StateAbbreviation ,
                    @ERPZip = ERP.ZipCode ,
                    @ERPListAs = ERP.Name ,
                    @ERPFirstName = ERP.FirstName ,
                    @ERPLastName = ERP.LastName ,
                    @ERPOrganization = ERP.OrganizationName ,
                    @ERPEmail = ERP.Email ,
                    @ERPSuffix = ERP.Suffix
            FROM    ExternalReferralProviders ERP
                    LEFT JOIN CustomDocumentRegistrations CDR ON CDR.PrimaryCarePhysician = ERP.ExternalReferralProviderId
                    LEFT JOIN States S ON S.StateFIPS = ERP.State
            WHERE   CDR.DocumentVersionId = @InProgressDocumentVersionId
          
          IF NOT EXISTS (SELECT 1 FROM dbo.ClientContacts cc WHERE cc.ClientId = @ClientId AND cc.Relationship = @PCPRelation 
						  AND  ISNULL(@ERPFirstName, ' ') = cc.FirstName AND ISNULL(@ERPLastName, ' ') = cc.LastName
						  AND cc.Organization = @ERPOrganization
						  AND cc.Email = @ERPEmail
						  AND cc.Active = 'Y'
						  AND ISNULL(cc.RecordDeleted,'N')='N'
						  
						  )
						  AND EXISTS (SELECT 1 FROM dbo.CustomDocumentRegistrations a WHERE a.DocumentVersionId = @InProgressDocumentVersionId
						  AND ISNULL(a.RecordDeleted,'N')='N'
						  AND a.ClientWithOutPCP <> 'Y' ---pcp drop down is selected
						  )
						  BEGIN
											 
            INSERT  INTO clientcontacts
                    ( ListAs ,
                      ClientId ,
                      Relationship ,
                      FirstName ,
                      LastName ,
                      Organization ,
                      Email ,
                      Active ,
                      Suffix
                    )
            VALUES  ( ISNULL(@ERPListAs, ' ') ,
                      @ClientId ,
                      @PCPRelation ,
                      ISNULL(@ERPFirstName, ' ') ,
                      ISNULL(@ERPLastName, ' ') ,
                      @ERPOrganization ,
                      @ERPEmail ,
                      'Y' ,
                      @ERPSuffix
                    )
          
            SET @ClientContactId = SCOPE_IDENTITY()
          
            IF @ERPPhone IS NOT NULL
                BEGIN
                    DECLARE @regex INT ,
                        @string VARCHAR(100)
                    SET @string = '(897) 004-5637'
                    SET @regex = PATINDEX('%[^a-zA-Z0-9  ]%', @string)
                    WHILE @regex > 0
                        BEGIN
                            SET @string = STUFF(@string, @regex, 1, ' ')
                            SET @regex = PATINDEX('%[^a-zA-Z0-9  ]%', @string)			
                        END		
			
                    INSERT  INTO ClientContactPhones
                            ( ClientContactId ,
                              PhoneType ,
                              PhoneNumber ,
                              PhoneNumberText
                            )
                    VALUES  ( @ClientContactId ,
                              30 ,
                              @ERPPhone ,
                              REPLACE(@string, ' ', '')
                            )
                END
			
          
            IF @ERPAddres IS NOT NULL
                BEGIN
                    INSERT  INTO ClientContactAddresses
                            ( ClientContactId ,
                              AddressType ,
                              [Address] ,
                              City ,
                              [State] ,
                              Zip ,
                              Display ,
                              Mailing
                            )
                    VALUES  ( @ClientContactId ,
                              90 ,
                              @ERPAddres ,
                              @ERPCity ,
                              @ERPState ,
                              @ERPZip ,
                              @ERPAddres + ' ' + @ERPCity + ', ' + @ERPState + ' ' + @ERPZip ,
                              'N'
                            )
                END          
                
                END 
      ---------END For task 171 in VCAT   
/************************************************************
* Client Addresses
************************************************************/
DECLARE @Address1 VARCHAR(MAX), @Address2 VARCHAR(MAX), @City VARCHAR(MAX), @State VARCHAR(MAX), @ZipCode VARCHAR(MAX), @ClientAddressId1 INT, @ClientAddressId2 int
                
                
SELECT @Address1 = cdr.[Address1],
	  @City = cdr.City,
	  @State = cdr.[State],
	  @ZipCode = cdr.ZipCode,
	  @Address2 = cdr.[Address2]
From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
	    AND ISNULL(cdr.RecordDeleted,'N')='N'               
                --clientaddresses address 1
                
                SELECT @ClientAddressId1 = ca.ClientAddressId FROM dbo.ClientAddresses ca 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE ca.AddressType= 90 AND ca.ClientId = @ClientId 
							 AND ISNULL(ca.RecordDeleted,'N')='N'
			 SELECT @ClientAddressId2 = ca.ClientAddressId FROM dbo.ClientAddresses ca 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE ca.AddressType= 93 AND ca.ClientId = @ClientId 
							 AND ISNULL(ca.RecordDeleted,'N')='N'
							 
                IF @ClientAddressId1 IS NULL 
				 BEGIN
					INSERT INTO ClientAddresses
						   ( ClientId
						   , AddressType
						   , [Address]
						   , City
						   , [State]
						   , Zip
						   , Display
						   , Billing
					  )
					  SELECT @ClientId,
								 90,
								 cdr.[Address1],
								 cdr.City,
								 cdr.[State],
								 cdr.ZipCode,
								 cdr.Address1 + ' ' + cdr.City + ', ' + cdr.[State] + ' ' + cdr.ZipCode ,
								 'Y'
						   From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
								    AND ISNULL(cdr.RecordDeleted,'N')='N'
								    AND cdr.Address1 IS NOT NULL 
					SET @ClientAddressId1 = SCOPE_IDENTITY()
				 END
			 ELSE
				 BEGIN
					UPDATE ClientAddresses 
					SET [Address] = @Address1,
					City = @City,
					[State] = @State,
					Zip = @ZipCode,
					Display = @Address1 + ' ' + @City + ', ' + @State + ' ' + @ZipCode 
					WHERE @ClientAddressId1 = ClientAddressId
					AND ClientId = @ClientId
					AND AddressType = 90
					AND @Address1 IS NOT NULL
				 END
--clientaddresses address 2                
                IF @ClientAddressId2 IS NULL 
				 BEGIN
				 INSERT INTO ClientAddresses
				         ( ClientId
				         , AddressType
				         , [Address]
				         , City
				         , [State]
				         , Zip
				         , Display
				         , Billing
				        )
				        SELECT @ClientId,
							  93,
							  cdr.[Address2],
							  cdr.City,
							  cdr.[State],
							  cdr.ZipCode,
							  cdr.Address2 + ' ' + cdr.City + ', ' + cdr.[State] + ' ' + cdr.ZipCode ,
							  'N'
					    From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
								AND ISNULL(cdr.RecordDeleted,'N')='N'
								AND cdr.Address2 IS NOT NULL 
					 SET @ClientAddressId2 = SCOPE_IDENTITY()
				 END
			ELSE
				BEGIN
					UPDATE ClientAddresses 
					SET [Address] = @Address2,
					City = @City,
					[State] = @State,
					Zip = @ZipCode,
					Display = @Address2 + ' ' + @City + ', ' + @State + ' ' + @ZipCode 
					WHERE ClientId = @ClientId
					AND AddressType = 93
					AND ClientAddressId = @ClientAddressId2
					AND ISNULL(RecordDeleted,'N')='N'
					AND @Address2 IS NOT NULL
				END
/*******************************************************************************
* Create Client Address History Records
*******************************************************************************/
INSERT INTO dbo.ClientAddressHistory (ClientId,AddressType,[Address],City,[State],Zip,Display,Billing,ExternalReferenceId )	
SELECT ClientId,AddressType,[Address],City,[State],Zip,Display,Billing, 'ND Admission Document'
FROM dbo.ClientAddresses 
WHERE ClientAddressId IN ( @ClientAddressId1, @ClientAddressId2 )					
AND ISNULL(RecordDeleted,'N')='N'	 
							 
							  
                ---clientphones Home Phone
                IF NOT EXISTS(SELECT 1 FROM dbo.ClientPhones cp 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
													   AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE cp.PhoneNumber = cdr.HomePhone
						  AND cp.PhoneType = 30 --home
						  AND cp.ClientId = @ClientId
						  AND ISNULL(cp.RecordDeleted,'N')='N'
						  AND cdr.HomePhone IS NOT NULL 
						  )
						  BEGIN
						  INSERT INTO dbo.ClientPhones(ClientId,PhoneType,PhoneNumber,PhoneNumberText)
						  SELECT
							 @ClientId,
							 30, --home
							 cdr.HomePhone,
							 dbo.csf_PhoneNumberStripped(cdr.HomePhone) 
						  From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N' 
											AND cdr.HomePhone IS NOT NULL 
						  END 
			                ---clientphones Home Phone 2
                IF NOT EXISTS(SELECT 1 FROM dbo.ClientPhones cp 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
													   AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE cp.PhoneNumber = cdr.HomePhone2
						  AND cp.PhoneType = 32 --home
						  AND cp.ClientId = @ClientId
						  AND ISNULL(cp.RecordDeleted,'N')='N'
						  AND cdr.HomePhone2 IS NOT NULL 
						  )
						  BEGIN
						  INSERT INTO dbo.ClientPhones(ClientId,PhoneType,PhoneNumber,PhoneNumberText)
						  SELECT
							 @ClientId,
							 32, --home2
							 cdr.HomePhone2,
							 dbo.csf_PhoneNumberStripped(cdr.HomePhone2) 
						  From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N' 
											AND cdr.HomePhone2 IS NOT NULL 
						  END 
						  --clientphones work
		IF NOT EXISTS(SELECT 1 FROM dbo.ClientPhones cp 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
													   AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE cp.PhoneNumber = cdr.WorkPhone
						  AND cp.PhoneType = 31 --buisness ...work
						  AND cp.ClientId = @ClientId
						  AND ISNULL(cp.RecordDeleted,'N')='N'
						  AND cdr.WorkPhone IS NOT NULL 
						  )
						  BEGIN
						  INSERT INTO dbo.ClientPhones(ClientId,PhoneType,PhoneNumber,PhoneNumberText)
						  SELECT
							 @ClientId,
							 31, --buisness ...work
							 cdr.WorkPhone,
							 dbo.csf_PhoneNumberStripped(cdr.WorkPhone) 
						  From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N' 
											AND cdr.WorkPhone IS NOT NULL
						  END 
                
       IF NOT EXISTS(SELECT 1 FROM dbo.ClientPhones cp 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
													   AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE cp.PhoneNumber = cdr.CellPhone
						  AND cp.PhoneType = 34 --moblie
						  AND cp.ClientId = @ClientId
						  AND ISNULL(cp.RecordDeleted,'N')='N'
						  AND cdr.CellPhone IS NOT NULL 
						  )
						  BEGIN
						  INSERT INTO dbo.ClientPhones(ClientId,PhoneType,PhoneNumber,PhoneNumberText)
						  SELECT
							 @ClientId,
							 34, --moblie
							 cdr.CellPhone,
							 dbo.csf_PhoneNumberStripped(cdr.CellPhone) 
						  From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N' 
											AND cdr.CellPhone IS NOT NULL
						  END 
	       IF NOT EXISTS(SELECT 1 FROM dbo.ClientPhones cp 
						  JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
													   AND ISNULL(cdr.RecordDeleted,'N')='N'
						  WHERE cp.PhoneNumber = cdr.MessagePhone
						  AND cp.PhoneType = 38 --moblie
						  AND cp.ClientId = @ClientId
						  AND ISNULL(cp.RecordDeleted,'N')='N'
						  AND cdr.MessagePhone IS NOT NULL 
						  )
						  BEGIN
						  INSERT INTO dbo.ClientPhones(ClientId,PhoneType,PhoneNumber,PhoneNumberText)
						  SELECT
							 @ClientId,
							 38, --moblie
							 cdr.MessagePhone,
							 dbo.csf_PhoneNumberStripped(cdr.MessagePhone) 
						  From dbo.CustomDocumentRegistrations cdr where cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N' 
											AND cdr.MessagePhone IS NOT NULL
						  END 
                
                -- Hard delete the record deleted entry and re-insert with new data to avoid primary key constraint error
                IF EXISTS (SELECT 1 FROM dbo.CustomClients WHERE ClientId = @ClientId AND ISNULL(RecordDeleted,'N')='Y')
                BEGIN
				DELETE FROM CustomClients WHERE ClientId = @ClientId AND ISNULL(RecordDeleted,'N')='Y'
                END
                
                IF EXISTS (SELECT 1 FROM dbo.CustomClients cc WHERE cc.ClientId = @ClientId AND ISNULL(cc.RecordDeleted,'N')='N')
                BEGIN
                UPDATE cc 
                SET cc.InterpreterNeeded = cdr.InterpreterNeeded,
				cc.Race = cast(rgc.ExternalCode2 AS int), --race mapping to XRACE
				cc.MaritalStatus = cast(msgc.ExternalCode2 AS int),
				cc.NumberOfArrestsLast30Days = cdr.NumberOfArrestsLast30Days,
				cc.EmploymentStatus = cdr.EmploymentStatus,
				cc.EducationLevel = cast(exgc.ExternalCode2 AS int ), --XEducationallevel
				cc.JusticeSystemInvolvement = cdr.JusticeSystemInvolvement,
				cc.AdvanceDirective = cdr.AdvanceDirective,
				cc.MilitaryService = casT(msxgc.ExternalCode2 AS int), --e2 RADIOYN
				cc.ForensicTreatment = cdr.ForensicTreatment,
				cc.CurrentlyEnrolledInEducation = cdr.VocationalRehab,
				cc.TobaccoUse = cast(ssgc.ExternalCode2 AS int), --xtobaccouse
				cc.Ethnicity = cast(hogc.ExternalCode2 AS int) --XEthnicity
				
                FROM dbo.CustomClients cc
                JOIN dbo.CustomDocumentRegistrations cdr ON cdr.DocumentVersionId = @InProgressDocumentVersionId
											AND ISNULL(cdr.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes rgc ON rgc.GlobalCodeId = cdr.Race
			AND rgc.Category = 'RACE'
			AND ISNULL(rgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes hogc ON hogc.GlobalCodeId = cdr.HispanicOrigin
			AND hogc.Category = 'HISPANICORIGIN'
			AND ISNULL(hogc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes msgc ON msgc.GlobalCodeId = cdr.MaritalStatus
			AND msgc.Category = 'MARITALSTATUS'
			AND ISNULL(msgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes msxgc ON msxgc.GlobalCodeId = cdr.MilitaryService
			AND msxgc.Category = 'XMILITARYSERVICE'
			AND ISNULL(msxgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes ssgc ON ssgc.GlobalCodeId = cdr.SmokingStatus
			AND ssgc.Category = 'XSMOKINGSTATUS'
			AND ISNULL(ssgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes exgc ON exgc.GlobalCodeId = cdr.EducationalLevel
			AND exgc.Category = 'EDUCATIONALSTATUS'
			AND ISNULL(exgc.RecordDeleted,'N')='N'
			 WHERE ISNULL(cc.RecordDeleted,'N')='N'
				    AND cc.ClientId = @ClientId
                END
                ELSE
                BEGIN
                INSERT INTO CustomClients (ClientId,InterpreterNeeded,Race,MaritalStatus,NumberOfArrestsLast30Days,EmploymentStatus
								    ,EducationLevel,JusticeSystemInvolvement,AdvanceDirective, MilitaryService, ForensicTreatment,CurrentlyEnrolledInEducation,TobaccoUse,
								    Ethnicity )
                SELECT 
                @ClientId,
                cdr.InterpreterNeeded,
                cast(rgc.ExternalCode2 AS int) , --race
                cast(msgc.ExternalCode2 AS int) , --marital status
                cdr.NumberOfArrestsLast30Days,
                cdr.EmploymentStatus,
                cast(exgc.ExternalCode2 AS int ), --educational level
                cdr.JusticeSystemInvolvement,
                cdr.AdvanceDirective,
                casT(msxgc.ExternalCode2 AS INT), --military service
                cdr.ForensicTreatment,
                cdr.VocationalRehab,
                cast(ssgc.ExternalCode2 AS int), --tobacco use smoking status
                cast(hogc.ExternalCode2 AS int)--hispanic origin
                From dbo.CustomDocumentRegistrations cdr 
			left JOIN dbo.GlobalCodes rgc ON rgc.GlobalCodeId = cdr.Race
			AND rgc.Category = 'RACE'
			AND ISNULL(rgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes hogc ON hogc.GlobalCodeId = cdr.HispanicOrigin
			AND hogc.Category = 'HISPANICORIGIN'
			AND ISNULL(hogc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes msgc ON msgc.GlobalCodeId = cdr.MaritalStatus
			AND msgc.Category = 'MARITALSTATUS'
			AND ISNULL(msgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes msxgc ON msxgc.GlobalCodeId = cdr.MilitaryService
			AND msxgc.Category = 'XMILITARYSERVICE'
			AND ISNULL(msxgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes ssgc ON ssgc.GlobalCodeId = cdr.SmokingStatus
			AND ssgc.Category = 'XSMOKINGSTATUS'
			AND ISNULL(ssgc.RecordDeleted,'N')='N'
			left JOIN dbo.GlobalCodes exgc ON exgc.GlobalCodeId = cdr.EducationalLevel
			AND exgc.Category = 'EDUCATIONALSTATUS'
			AND ISNULL(exgc.RecordDeleted,'N')='N'
                where cdr.DocumentVersionId = @InProgressDocumentVersionId
			 and ISNULL(cdr.RecordDeleted,'N')='N'
			 
                END
                         -- njain 4/30/2015 --jcarlson taken from valley post update script
            UPDATE  dbo.Clients
            SET     CurrentEpisodeNumber = ( SELECT MAX(EpisodeNumber)
                                             FROM   dbo.ClientEpisodes
                                             WHERE  ISNULL(RecordDeleted, 'N') = 'N'
                                                    AND ClientId = @ClientId
                                           )
            WHERE   ClientId = @ClientId
            
            
                     -- dknewtson 3/27/2015 --jcarlson taken from valley post update script
            IF EXISTS ( SELECT  1
                        FROM    dbo.Documents d
                        WHERE   d.DocumentId = @ScreenKeyId
                        AND ISNULL(d.RecordDeleted,'N')='N' )
                BEGIN
                    DECLARE @TitleXXNo VARCHAR(50)
                    SET @TitleXXNo = ( SELECT   SUBSTRING(c.FirstName, 1, 1) + '9' + SUBSTRING(c.LastName, 1, 1) + RIGHT('0' + CONVERT(VARCHAR, DATEPART(mm, c.DOB)), 2) + RIGHT('0' + CONVERT(VARCHAR, DATEPART(dd, c.DOB)), 2) + RIGHT(CONVERT(VARCHAR(5), DATEPART(yy, c.DOB), 114), 2) + c.Sex AS TitleXXNo
                                       FROM     dbo.Documents d
                                                JOIN Clients c ON c.ClientId = d.ClientId
                                       WHERE    DocumentId = @ScreenKeyId
                                     )
                                    
								UPDATE  CustomClients
								SET     TitleXXNo = @TitleXXNo
								WHERE   ClientId = @ClientId
									   AND RTRIM(LTRIM(ISNULL(TitleXXNo, ''))) = ''
									   AND ISNULL(RecordDeleted,'N')='N'
							 
                END  
                
                
                
                
----------------------------------------------------


      END TRY

      BEGIN CATCH
          DECLARE @Error VARCHAR(8000)

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())
                      + '*****'
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                      'csp_SCPostUpdateRegistrationDocument')
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())

          RAISERROR ( @Error,
                      -- Message text.
                      16,
                      -- Severity.
                      1
          -- State.
          );
      END CATCH
  END
GO