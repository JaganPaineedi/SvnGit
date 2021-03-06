/****** Object:  StoredProcedure [dbo].[csp_SCUpdateElectronicEligibilityData]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCUpdateElectronicEligibilityData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCUpdateElectronicEligibilityData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCUpdateElectronicEligibilityData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_SCUpdateElectronicEligibilityData]
    @EligibilityVerificationRequestId AS INTEGER ,
    @ClientId AS INTEGER ,
    @InquiryId AS INTEGER
AS -- =============================================
-- Author:		Suhail Ali
-- Create date: 1/3/2012
-- Description:	
-- Parse the eligibility xml response and update the following data:
--1. Links Eligibility Verification to Client Id and/or Inquiry 
--   Id CustomInquiryElectronicEligibilityVerificationRequests
--2. ResponseText - convert the response xml to human-readable text
--3. Check for error in XML response and if error exists, set request error code and text 
--4. Create rows in ElectronicEligibilityVerificationCoveragePlans table for each coverage plan returned in XML response.  This will be used by the stored proc 
--	 csp_SCUpdateElectronicEligibilityClientCoveragePlan to update the client coverage plans automatically
-- =============================================
    BEGIN
        BEGIN TRY
            IF ( ( @ClientId IS NULL
                   OR @ClientId < 0
                 )
                 AND ( @InquiryId IS NULL
                       OR @InquiryId < 0
                     )
               ) 
                RAISERROR (N''Either a valid Client id and/or Inquiry Id must be specified.'', 16, 1) 
	--1. Links Eligibility Verification to Client Id and/or Inquiry 
	--   Id CustomInquiryElectronicEligibilityVerificationRequests
            IF ( @ClientId IS NOT NULL ) 
                BEGIN
                    UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]
                    SET     [ClientId] = @ClientId
                    WHERE   [EligibilityVerificationRequestId] = @EligibilityVerificationRequestId
                END	

            IF ( @InquiryId IS NOT NULL ) 
                BEGIN
                    INSERT  INTO [dbo].[CustomInquiryElectronicEligibilityVerificationRequests]
                            ( [EligibilityVerificationRequestId] ,
                              [InquiryId]
				   
                            )
                    VALUES  ( @EligibilityVerificationRequestId ,
                              @InquiryId				   
                            )	
                END	
	
	--2. If the response contains an error message then mark the request as error and 
	--	  populate error text
            UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]
            SET     [RequestReturnCode] = 1 , -- error
                    RequestErrorMessage = T.item.value(''data((rejection/rejectreason)[1])'',
                                                       ''varchar(100)'')
            FROM    dbo.[ElectronicEligibilityVerificationRequests] AS response
                    CROSS APPLY VerifiedXMLResponse.nodes(''//subscriber'') AS T ( Item )
            WHERE   T.item.exist(''.[rejection]'') = 1
                    AND response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId 

	--3 If subscriber insured id was not passed in for the 270 request then let''s set it from the 271 response
            UPDATE  dbo.[ElectronicEligibilityVerificationRequests]
            SET     SubscriberInsuredId = T.item.value(''data((patientid)[1])'',
                                                       ''varchar(25)'')
            FROM    dbo.[ElectronicEligibilityVerificationRequests] AS response
                    CROSS APPLY VerifiedXMLResponse.nodes(''//subscriber'') AS T ( Item )
            WHERE   T.item.exist(''.[patientid]'') = 1
                    AND response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                    AND ( SubscriberInsuredId IS NULL
                          OR LEN(SubscriberInsuredId) < 2
                        )

	--4. Create rows in ElectronicEligibilityVerificationCoveragePlans table 
	--   for each coverage plan returned in XML response.  
			
			-- Delete any existing coverage plan before re-populating the records
            DELETE  FROM dbo.ElectronicEligibilityVerificationCoveragePlans
            WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId
	
            DECLARE @ResponseCoveragePlans TABLE
                (
                  EligibilityVerificationRequestId INT ,
                  Info VARCHAR(100) ,
                  InsuranceType VARCHAR(100) ,
                  PlanCoverageDescription VARCHAR(100) ,
                  Message1 VARCHAR(500) ,
                  EntityCode VARCHAR(100) ,
                  EntityInformationContact VARCHAR(100) ,
                  CoveragePlanId INT ,
                  VerifiedResponseType VARCHAR(25) ,
                  CoverageStartDate DATE ,
                  CoverageEndDate DATE ,
                  ServiceStartDate DATE ,
                  ServiceEndDate DATE ,
                  ClientId INT
                ) ;
            WITH    MatchCoverageWithUnParsedServiceDates
                      AS ( SELECT   response.EligibilityVerificationRequestId ,
                                    T.item.value(''data((info)[1])'',
                                                 ''varchar(100)'') AS Info ,
                                    T.item.value(''data((insurancetype)[1])'',
                                                 ''varchar(100)'') AS InsuranceType ,
                                    T.item.value(''data((plancoveragedescription)[1])'',
                                                 ''varchar(100)'') AS PlanCoverageDescription ,
                                    T.item.value(''data((message)[1])'',
                                                 ''varchar(500)'') AS Message1 ,
                                    T.item.value(''data((benefitentity/entitycode)[1])'',
                                                 ''varchar(100)'') AS EntityCode ,
                                    T.item.value(''data((benefitentity/informationcontact)[1])'',
                                                 ''varchar(100)'') AS EntityInformationContact ,
                                    CoveragePlanId ,
                                    VerifiedResponseType ,
                                    T.item.value(''data((date-of-service)[1])'',
                                                 ''varchar(50)'') AS ServiceDates ,
                                    response.DateOfServiceStart AS ServiceStartDate ,
                                    response.DateOfServiceEnd AS ServiceEndDate ,
                                    response.ClientId AS ClientId
                           FROM     dbo.[ElectronicEligibilityVerificationRequests]
                                    AS response
                                    CROSS APPLY VerifiedXMLResponse.nodes(''//benefit'')
                                    AS T ( Item )
                                    INNER JOIN dbo.CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping
                                    AS map ON response.ElectronicEligibilityVerificationPayerId = map.ElectronicEligibilityVerificationPayerId
                           WHERE    response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                    AND ( ( BenefitMessage1 IS NOT NULL
                                            AND T.item.exist(''.[(info = sql:column("BenefitInfo") or not(info)) and (insurancetype = sql:column("BenefitInsuranceType") or not(insurancetype)) and (plancoveragedescription = sql:column("BenefitPlanCoverageDescription") or not(plancoveragedescription)) and contains(message[1],sql:column("BenefitMessage1")) and (benefitentity/entitycode = sql:column("BenefitEntityCode") or not(benefitentity/entitycode)) and (benefitentity/informationcontact = sql:column("BenefitEntityInformationContact") or not(benefitentity/informationcontact))]'') = 1
                                          )
                                          OR ( BenefitMessage1 IS NULL
                                               AND T.item.exist(''.[(info = sql:column("BenefitInfo") or not(info)) and (insurancetype = sql:column("BenefitInsuranceType") or not(insurancetype)) and (plancoveragedescription = sql:column("BenefitPlanCoverageDescription") or not(plancoveragedescription)) and (benefitentity/entitycode = sql:column("BenefitEntityCode") or not(benefitentity/entitycode)) and (benefitentity/informationcontact = sql:column("BenefitEntityInformationContact") or not(benefitentity/informationcontact))]'') = 1
                                             )
                                          OR ( BenefitInfo = ''Primary Care Provider''
                                               AND T.item.exist(''.[(info = sql:column("BenefitInfo") or not(info)) and (insurancetype = sql:column("BenefitInsuranceType") or not(insurancetype)) and (plancoveragedescription = sql:column("BenefitPlanCoverageDescription") or not(plancoveragedescription)) and (benefitentity/entitycode = sql:column("BenefitEntityCode") or not(benefitentity/entitycode))]'') = 1
                                             )
                                        )
                         ),
                    CalculateCoverageDatesFromServiceDates
                      AS ( SELECT   EligibilityVerificationRequestId ,
                                    Info ,
                                    InsuranceType ,
                                    PlanCoverageDescription ,
                                    Message1 ,
                                    EntityCode ,
                                    EntityInformationContact ,
                                    CoveragePlanId ,
                                    VerifiedResponseType ,
                                    CASE WHEN a.DateSeparator > 0
                                         THEN CAST(LEFT(ServiceDates,
                                                        a.DateSeparator - 1) AS DATE)
                                         ELSE CAST(ServiceDates AS DATE)
                                    END AS BenefitStartDate ,
                                    CASE WHEN a.DateSeparator > 0
                                         THEN CAST(RIGHT(ServiceDates,
                                                         a.DateSeparator - 1) AS DATE)
                                         ELSE CAST(ServiceDates AS DATE)
                                    END AS BenefitEndDate ,
                                    ServiceStartDate ,
                                    ServiceEndDate ,
                                    ClientId
                           FROM     MatchCoverageWithUnParsedServiceDates
                                    CROSS APPLY ( SELECT    CHARINDEX(''-'',
                                                              ServiceDates) AS DateSeparator
                                                ) AS A
                         )
                INSERT  INTO @ResponseCoveragePlans
                        ( EligibilityVerificationRequestId ,
                          Info ,
                          InsuranceType ,
                          PlanCoverageDescription ,
                          Message1 ,
                          EntityCode ,
                          EntityInformationContact ,
                          CoveragePlanId ,
                          VerifiedResponseType ,
                          CoverageStartDate ,
                          CoverageEndDate ,
                          ServiceStartDate ,
                          ServiceEndDate ,
                          ClientId			  
			      )
                        SELECT  EligibilityVerificationRequestId ,
                                Info ,
                                InsuranceType ,
                                PlanCoverageDescription ,
                                Message1 ,
                                EntityCode ,
                                EntityInformationContact ,
                                CoveragePlanId ,
                                VerifiedResponseType ,
                                CASE WHEN BenefitStartDate > ServiceStartDate
                                     THEN BenefitStartDate
                                     ELSE NULL
                                END AS CoverageStartDate ,
                                CASE WHEN BenefitEndDate < ServiceEndDate
                                     THEN BenefitEndDate
                                     ELSE NULL
                                END AS CoverageEndDate ,
                                ServiceStartDate ,
                                ServiceEndDate ,
                                ClientId
                        FROM    CalculateCoverageDatesFromServiceDates

		/* If the beneift records returned from 271 do not 
			all match all the expected benefits then flag
		*/		                                                      
            IF ( SELECT CASE WHEN a.CountOfBenefitsMatched = b.CountOfTotalBenefits
                             THEN 1
                             ELSE 0
                        END
                 FROM   ( SELECT    COUNT(*) AS CountOfBenefitsMatched
                          FROM      ( SELECT  DISTINCT
                                                Info ,
                                                InsuranceType ,
                                                PlanCoverageDescription ,
                                                Message1 ,
                                                EntityCode ,
                                                EntityInformationContact ,
                                                CoverageStartDate ,
                                                CoverageEndDate
                                      FROM      @ResponseCoveragePlans
                                    ) ia
                        ) a
                        CROSS JOIN ( SELECT ISNULL(VerifiedXMLResponse.value(''count(//benefit)'',
                                                              ''int''), 0) AS CountOfTotalBenefits
                                     FROM   [dbo].[ElectronicEligibilityVerificationRequests]
                                            AS response
                                     WHERE  response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                   ) b
               ) = 1 
                UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]
                SET     AbleToParseXMLResponseBenefits = ''Y''
                WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId
            ELSE 
                UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]
                SET     AbleToParseXMLResponseBenefits = ''N''
                WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId ;


	/* If no client then just insert the coverage returned from xml and mark all coverages for manual updates*/
            IF EXISTS ( SELECT  *
                        FROM    [dbo].[ElectronicEligibilityVerificationRequests]
                        WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                AND ClientId IS NULL ) 
                BEGIN
                    INSERT  INTO [dbo].[ElectronicEligibilityVerificationCoveragePlans]
                            ( [EligibilityVerificationRequestId] ,
                              [CoveragePlanId] ,
                              [VerifiedResponseType] ,
                              [CoverageStartDate] ,
                              [CoverageEndDate] ,
                              [IsCoverageActive] ,
                              [IsNewCoverage] ,
                              [IsSpendown] ,
                              [HasSpendBeenMet] ,
                              [DoesCoverageNeedManualChange]
                            )
                            SELECT  EligibilityVerificationRequestId ,
                                    CoveragePlanId ,
                                    VerifiedResponseType ,
                                    CoverageStartDate ,
                                    CoverageEndDate ,
                                    CAST(CASE WHEN VerifiedResponseType IN (
                                                   ''Billable'', ''Spendown'' )
                                              THEN ''Y''
                                              ELSE ''N''
                                         END AS CHAR(1)) AS IsCoverageActive ,
                                    NULL AS IsNewCoverage ,
                                    CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                              THEN ''Y''
                                              ELSE ''N''
                                         END AS CHAR(1)) AS IsSpendown ,
                                    CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                              THEN ''N''
                                              ELSE ''Y''
                                         END AS CHAR(1)) AS HasSpendBeenMet ,
                                    CAST(''Y'' AS CHAR(1)) AS DoesCoverageNeedManualChange
                            FROM    @ResponseCoveragePlans
                            WHERE   CoveragePlanId IS NOT NULL
                END
            ELSE 
                BEGIN

		/* 
			Process 271 response coverages that are NOT IN in client coverage 
			State Change: New Coverage 
			Can auto update client coverage? Yes.  New coverages will be automatically created 
			
		*/
		
                    INSERT  INTO [dbo].[ElectronicEligibilityVerificationCoveragePlans]
                            ( [EligibilityVerificationRequestId] ,
                              [CoveragePlanId] ,
                              [VerifiedResponseType] ,
                              [CoverageStartDate] ,
                              [CoverageEndDate] ,
                              [ServiceAreaId] ,
                              [IsCoverageActive] ,
                              [IsNewCoverage] ,
                              [IsSpendown] ,
                              [HasSpendBeenMet] ,
                              [Comment] ,
                              [DoesCoverageNeedManualChange]
                            )
                            SELECT  EligibilityVerificationRequestId ,
                                    rspcvg.CoveragePlanId ,
                                    VerifiedResponseType ,
                                    CASE WHEN VerifiedResponseType = ''Billable''
                                         THEN ISNULL([CoverageStartDate],
                                                     [ServiceStartDate])
                                         ELSE CoverageStartDate
                                    END AS CoverageStartDate ,
                                    CoverageEndDate ,
                                    SrvcArea.ServiceAreaId ,
                                    CAST(CASE WHEN VerifiedResponseType = ''Billable''
                                              THEN ''Y''
                                              ELSE ''N''
                                         END AS CHAR(1)) AS IsCoverageActive ,
                                    CAST(''Y'' AS CHAR(1)) AS IsNewCoverage ,
                                    CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                              THEN ''Y''
                                              ELSE ''N''
                                         END AS CHAR(1)) AS IsSpendown ,
                                    CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                              THEN ''N''
                                              ELSE ''Y''
                                         END AS CHAR(1)) AS HasSpendBeenMet ,
                                    ''Current coverage billing to new billing state: NotBillableTo''
                                    + ISNULL(VerifiedResponseType, ''Error'')
                                    + CHAR(13)
                                    + ''Current coverage billing state: NotBillable''
                                    + CHAR(13)
                                    + ''User entered service start date: ''
                                    + ISNULL(CAST(ServiceStartDate AS VARCHAR(10)),
                                             '''') + CHAR(13)
                                    + ''User entered service end date: ''
                                    + ISNULL(CAST(ServiceEndDate AS VARCHAR(10)),
                                             '''') + CHAR(13) AS Comment ,
                                    CAST(''N'' AS CHAR(1)) AS DoesCoverageNeedManualChange
                            FROM    @ResponseCoveragePlans AS rspcvg
                                    LEFT OUTER JOIN dbo.ClientCoveragePlans AS clientcvg ON rspcvg.CoveragePlanId = clientcvg.CoveragePlanId
                                                              AND clientcvg.ClientId = rspcvg.ClientId
                                    CROSS JOIN ( SELECT MIN(ServiceAreaId) AS ServiceAreaId
                                                 FROM   ServiceAreas
                                               ) SrvcArea
                            WHERE   clientcvg.CoveragePlanId IS NULL
                                    AND rspcvg.CoveragePlanId IS NOT NULL
                        
		/* 
			Process 271 response coverages that are IN in client coverage 
			State Change: current client coverage -> response set to billable or not billable based on response info or setup new coverage
			Can auto update client coverage? Maybe.  If the coverage dates are accurately returned to make the coverage billable or non-billable then Yes else No			
		*/		
;
                    WITH    EligibilityCoveragePlans
                              AS ( SELECT   rspcvg.EligibilityVerificationRequestId ,
                                            clientcvg.CoveragePlanId ,
                                            clientcvg.ClientCoveragePlanId ,
                                            clientcvg.ClientId ,
                                            CAST(rspcvg.CoverageStartDate AS DATE) AS CoverageStartDate ,
                                            CAST(rspcvg.CoverageEndDate AS DATE) AS CoverageEndDate ,
                                            rspcvg.VerifiedResponseType ,
                                            SrvcArea.ServiceAreaId ,
                                            cch.StartDate AS CurrentCoverageStartDate ,
                                            cch.Enddate AS CurrentCoverageEndDate ,
                                            maxcch.MaxCoverageStartDate ,
                                            maxcch.MaxCoverageEndDate ,
                                            rspcvg.ServiceStartDate ,
                                            rspcvg.ServiceEndDate ,
                                            CASE WHEN ( ( cch.StartDate <= CAST(GETDATE() AS DATE)
                                                          AND cch.EndDate IS NULL
                                                        )
                                                        OR ( CAST(GETDATE() AS DATE) BETWEEN cch.StartDate
                                                              AND
                                                              cch.EndDate )
                                                      ) THEN ''Billable''
                                                 WHEN ( cch.Enddate < CAST(GETDATE() AS DATE)
                                                        AND cch.EndDate IS NOT NULL
                                                      ) THEN ''Not Billable''
                                                 WHEN ( cch.Startdate IS NULL
                                                        AND cch.EndDate IS NULL
                                                      ) THEN ''Not Billable''
                                                 ELSE ''Error'' -- no need to update coverage dates when service dates are checking past coverage history 
                                            END AS CurrentCoverage
                                   FROM     @ResponseCoveragePlans AS rspcvg
                                            INNER JOIN dbo.ClientCoveragePlans
                                            AS clientcvg ON rspcvg.CoveragePlanId = clientcvg.CoveragePlanId
                                                            AND clientcvg.ClientId = rspcvg.ClientId
                                            LEFT OUTER JOIN ( SELECT
                                                              CAST(icch.StartDate AS DATE) AS StartDate ,
                                                              CAST(icch.EndDate AS DATE) AS EndDate ,
                                                              icch.ClientCoveragePlanId
                                                              FROM
                                                              dbo.ClientCoverageHistory icch
                                                              WHERE
                                                              CAST(StartDate AS DATE) <= CAST(GETDATE() AS DATE)
                                                              AND ( EndDate IS NULL
                                                              OR CAST(EndDate AS DATE) >= CAST(GETDATE() AS DATE)
                                                              )
                                                            ) AS cch ON cch.ClientCoveragePlanId = clientcvg.ClientCoveragePlanId
                                            LEFT OUTER JOIN ( SELECT
                                                              MAX(CAST(icch.StartDate AS DATE)) AS MaxCoverageStartDate ,
                                                              MAX(CAST(icch.EndDate AS DATE)) AS MaxCoverageEndDate ,
                                                              icch.ClientCoveragePlanId
                                                              FROM
                                                              dbo.ClientCoverageHistory icch
                                                              GROUP BY icch.ClientCoveragePlanId
                                                            ) AS maxcch ON maxcch.ClientCoveragePlanId = clientcvg.ClientCoveragePlanId
                                            CROSS JOIN ( SELECT
                                                              MIN(ServiceAreaId) AS ServiceAreaId
                                                         FROM ServiceAreas
                                                       ) SrvcArea
                                   WHERE    rspcvg.CoveragePlanId IS NOT NULL
                                 ),
                            CalculatedCoveragePlansChanges
                              AS ( SELECT   EligibilityVerificationRequestId ,
                                            CoveragePlanId ,
                                            ClientCoveragePlanId ,
                                            VerifiedResponseType ,
                                            CoverageStartDate ,
                                            CoverageEndDate ,
                                            CurrentCoverageStartDate ,
                                            CurrentCoverageEndDate ,
                                            MaxCoverageStartDate ,
                                            MaxCoverageEndDate ,
                                            CurrentCoverage ,
                                            ServiceStartDate ,
                                            ServiceEndDate ,
                                            ServiceAreaId ,
                                            CAST(CASE WHEN VerifiedResponseType IN (
                                                           ''Billable'',
                                                           ''Spendown'' )
                                                      THEN ''Y''
                                                      ELSE ''N''
                                                 END AS CHAR(1)) AS IsCoverageActive ,
                                            CAST(CASE WHEN CoveragePlanId IS NULL
                                                      THEN ''Y''
                                                      ELSE ''N''
                                                 END AS CHAR(1)) AS IsNewCoverage ,
                                            CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                                      THEN ''Y''
                                                      ELSE ''N''
                                                 END AS CHAR(1)) AS IsSpendown ,
                                            CAST(CASE WHEN VerifiedResponseType = ''Spendown''
                                                      THEN ''N''
                                                      ELSE ''Y''
                                                 END AS CHAR(1)) AS HasSpendBeenMet ,
                                            CASE WHEN -- Found a coverage with same coverage end date so just update verified date
                                                      ( ( SELECT
                                                              MIN(icch.EndDate)
                                                          FROM
                                                              dbo.ClientCoveragePlans iccp
                                                              INNER JOIN dbo.ClientCoverageHistory icch ON iccp.ClientCoveragePlanId = icch.ClientCoveragePlanId
                                                          WHERE
                                                              iccp.CoveragePlanId = EligibilityCoveragePlans.CoveragePlanId
                                                              AND iccp.ClientId = EligibilityCoveragePlans.ClientId
                                                              AND CAST(icch.EndDate AS DATE) = CAST(EligibilityCoveragePlans.CoverageEndDate AS DATE)
                                                        ) IS NOT NULL
                                                        AND CoverageEndDate IS NOT NULL
                                                      )
                                                 THEN ''MatchesExistingCoverageEndDate''
                                                 WHEN	-- Found a coverage with same coverage start date so just update verified date
                                                      ( ( SELECT
                                                              MIN(icch.StartDate)
                                                          FROM
                                                              dbo.ClientCoveragePlans iccp
                                                              INNER JOIN dbo.ClientCoverageHistory icch ON iccp.ClientCoveragePlanId = icch.ClientCoveragePlanId
                                                          WHERE
                                                              iccp.CoveragePlanId = EligibilityCoveragePlans.CoveragePlanId
                                                              AND iccp.ClientId = EligibilityCoveragePlans.ClientId
                                                              AND CAST(icch.StartDate AS DATE) = CAST(EligibilityCoveragePlans.CoverageStartDate AS DATE)
                                                        ) IS NOT NULL
                                                        AND CoverageStartDate IS NOT NULL
                                                      )
                                                 THEN ''MatchesExistingCoverageStartDate''
                                                 WHEN -- If it''s currently non-billable and the response still says it''s still non-billable with no coverage end date in response then just update verified date
                                                      ( VerifiedResponseType IN (
                                                        ''Not Billable'',
                                                        ''Spendown'' )
                                                        AND CurrentCoverage = ''Not Billable''
                                                        AND CoverageStartDate IS NULL
                                                        AND CoverageEndDate IS NULL
                                                      )
                                                 THEN ''ContinuesToBeNotBillable''
                                                 WHEN -- If it''s currently billable and the response still says it''s still billable with no coverage start date in response then just update verified date
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CoverageStartDate IS NULL
                                                        AND CoverageEndDate IS NULL
                                                      )
                                                 THEN ''ContinuesToBeBillable''
                                                 WHEN -- If it changed state and we have coverage date from the response 
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Not Billable''
                                                        AND ( CurrentCoverageEndDate < CoverageStartDate
                                                              OR CurrentCoverageEndDate IS NULL
                                                            )
                                                        AND CoverageStartDate IS NOT NULL
                                                      )
                                                 THEN ''NonBillableToBillableWithStartDate''
                                                 WHEN -- If it changed state and we do not have a precise start date (don''t worry, we''ll see if we can use service start date instead)
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Not Billable''
                                                        AND ( CurrentCoverageEndDate < ServiceStartDate
                                                              OR CurrentCoverageEndDate IS NULL
                                                            )
                                                        AND ServiceStartDate IS NOT NULL
                                                        AND CoverageStartDate IS NULL
                                                      )
                                                 THEN ''NonBillableToBillableWithNoStartDate''
                                                 WHEN ( VerifiedResponseType IN (
                                                        ''Not Billable'',
                                                        ''Spendown'' )
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CurrentCoverageStartDate < CoverageEndDate
                                                        AND CoverageEndDate IS NOT NULL
                                                      )
                                                 THEN ''BillableToNonBillableWithEndDate''
                                                 WHEN ( VerifiedResponseType IN (
                                                        ''Not Billable'',
                                                        ''Spendown'' )
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CurrentCoverageStartDate <= ServiceStartDate
                                                        AND CoverageEndDate IS NULL
                                                      )
                                                 THEN ''BillableToNonBillableWithNoEndDate''
                                                 WHEN -- currently billable with end date -> non-billable (gap)  -> billable 
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CoverageStartDate IS NOT NULL
                                                        AND ( CoverageStartDate > CurrentCoverageEndDate
                                                              OR ( SELECT
                                                              MAX(iecp.CoverageEndDate)
                                                              FROM
                                                              EligibilityCoveragePlans iecp
                                                              WHERE
                                                              iecp.CoverageStartDate IS NULL
                                                              AND iecp.CoverageEndDate IS NOT NULL
                                                              AND iecp.CoverageEndDate < EligibilityCoveragePlans.CoverageStartDate
                                                              AND iecp.CoveragePlanId = EligibilityCoveragePlans.CoveragePlanId
                                                              ) IS NOT NULL
                                                            )
                                                      )
                                                 THEN ''BillableToNonBillableToBillableAgainWithStartDate''
                                                 WHEN -- currently billable -> billable with end date (same as non-billable)
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CoverageEndDate IS NOT NULL
                                                        AND CoverageStartDate IS NULL
                                                        AND CoverageEndDate > CurrentCoverageStartDate
                                                      )
                                                 THEN ''BillableToNonBillableWithFutureEndDate''
                                                 WHEN -- currently billable with end date -> billable with no end date. This when initially the coverage has an end date in the future but then it comes back with no end date
                                                      ( VerifiedResponseType = ''Billable''
                                                        AND CurrentCoverage = ''Billable''
                                                        AND CoverageEndDate IS NULL
                                                        AND CurrentCoverageEndDate IS NOT NULL
                                                        AND CurrentCoverageEndDate < ServiceEndDate -- make sure the user is checking past the current coverage end date
                                                        AND CurrentCoverageEndDate > ISNULL(CoverageStartDate,
                                                              ServiceStartDate) -- also, make sure the user is check before the current coverage start date
                                                        
                                                      )
                                                 THEN ''BillableWithEndDateToBillableToNoEndDate''
                                                 ELSE ''Unknown'' -- This will be if it''s spendown or we don''t have coverage dates to set it automatically or we just didn''t think of this scenario
                                            END AS CoverageState
                                   FROM     EligibilityCoveragePlans
                                 )
                        INSERT  INTO [dbo].[ElectronicEligibilityVerificationCoveragePlans]
                                ( [EligibilityVerificationRequestId] ,
                                  [CoveragePlanId] ,
                                  [VerifiedResponseType] ,
                                  [CoverageStartDate] ,
                                  [CoverageEndDate] ,
                                  [ServiceAreaId] ,
                                  [IsCoverageActive] ,
                                  [IsNewCoverage] ,
                                  [IsSpendown] ,
                                  [HasSpendBeenMet] ,
                                  [Comment] ,
                                  [DoesCoverageNeedManualChange]
                                )
                                SELECT  EligibilityVerificationRequestId ,
                                        CoveragePlanId ,
                                        VerifiedResponseType ,
                                        CASE WHEN CoverageState = ''NonBillableToBillableWithNoStartDate''
                                             THEN CASE WHEN MaxCoverageEndDate < ServiceStartDate
                                                       THEN ServiceStartDate
                                                       ELSE DATEADD(dd, 1,
                                                              ISNULL(CurrentCoverageEndDate,
                                                              MaxCoverageEndDate))
                                                  END
                                             WHEN CoverageState = ''BillableWithEndDateToBillableToNoEndDate''
                                             THEN DATEADD(dd, 1,
                                                          CurrentCoverageEndDate) -- Just make it billable the day after the current coverage end date
                                             ELSE CoverageStartDate
                                        END AS CoverageStartDate ,
										CASE WHEN CoverageState = ''BillableToNonBillableWithNoEndDate''
                                             THEN CASE WHEN CurrentCoverageStartDate >= ServiceStartDate
                                                       THEN DATEADD(dd, 1,
                                                              CurrentCoverageStartDate)
                                                       ELSE ServiceStartDate
                                                  END 
                                        END AS CoverageEndDate ,
                                        ServiceAreaId ,
                                        IsCoverageActive ,
                                        IsNewCoverage ,
                                        IsSpendown ,
                                        HasSpendBeenMet ,
                                        ''Current coverage billing to new billing state: ''
                                        + ISNULL(CoverageState, ''Error'')
                                        + CHAR(13)
                                        + ''Current coverage billing state: ''
                                        + ISNULL(CurrentCoverage, '''')
                                        + CHAR(13)
                                        + ''Current coverage start date: ''
                                        + ISNULL(CAST(CurrentCoverageStartDate AS VARCHAR(10)),
                                                 '''') + CHAR(13)
                                        + ''Current coverage end date: ''
                                        + ISNULL(CAST(CurrentCoverageEndDate AS VARCHAR(10)),
                                                 '''') + CHAR(13)
                                        + ''Max coverage start date: ''
                                        + ISNULL(CAST(MaxCoverageStartDate AS VARCHAR(10)),
                                                 '''') + CHAR(13)
                                        + ''Max coverage end date: ''
                                        + ISNULL(CAST(MaxCoverageEndDate AS VARCHAR(10)),
                                                 '''') + CHAR(13)
                                        + ''User entered service start date: ''
                                        + ISNULL(CAST(ServiceStartDate AS VARCHAR(10)),
                                                 '''') + CHAR(13)
                                        + ''User entered service end date: ''
                                        + ISNULL(CAST(ServiceEndDate AS VARCHAR(10)),
                                                 '''') + CHAR(13) AS Comment ,
                                        CASE WHEN CoverageState IN (
                                                  ''MatchesExistingCoverageEndDate'',
                                                  ''MatchesExistingCoverageStartDate'',
                                                  ''ContinuesToBeNotBillable'',
                                                  ''ContinuesToBeBillable'' )
                                             THEN NULL
                                             WHEN CoverageState = ''Unknown''
                                             THEN ''Y''
                                             ELSE ''N''
                                        END AS DoesCoverageNeedManualChange
                                FROM    CalculatedCoveragePlansChanges
            		
		/* 
			Get back client coverages that are NOT in 271 response
			State Change: current client coverage billable or not billable -> not billable 
			Can auto update client coverage: Yes if coverage end date can be derived from service dates
		*/

;
                    WITH    InactiveCoverages
                              AS ( SELECT DISTINCT
                                            response.EligibilityVerificationRequestId ,
                                            clientcvg.CoveragePlanId ,
                                            CAST(''Not Billable'' AS VARCHAR(20)) AS VerifiedResponseType ,
                                            SrvcArea.ServiceAreaId ,
                                            CASE WHEN ( ( cch.StartDate <= CAST(GETDATE() AS DATE)
                                                          AND cch.EndDate IS NULL
                                                        )
                                                        OR ( CAST(GETDATE() AS DATE) BETWEEN cch.StartDate
                                                              AND
                                                              cch.EndDate )
                                                      ) THEN ''Billable''
                                                 ELSE NULL
                                            END AS CurrentCoverage ,
                                            DateOfServiceStart AS ServiceStartDate ,
                                            DateOfServiceEnd AS ServiceEndDate ,
                                            cch.StartDate AS CurrentCoverageStartDate ,
                                            cch.Enddate AS CurrentCoverageEndDate
                                   FROM     dbo.[ElectronicEligibilityVerificationRequests]
                                            AS response
                                            INNER JOIN dbo.ClientCoveragePlans
                                            AS clientcvg ON response.ClientId = clientcvg.ClientId
                                            INNER JOIN dbo.CoveragePlans cvg ON cvg.CoveragePlanId = clientcvg.CoveragePlanId
                                                              AND cvg.ElectronicEligibilityVerificationPayerId = response.ElectronicEligibilityVerificationPayerId
                                            LEFT OUTER JOIN ( SELECT
                                                              CAST(icch.StartDate AS DATE) AS StartDate ,
                                                              CAST(icch.EndDate AS DATE) AS EndDate ,
                                                              icch.ClientCoveragePlanId
                                                              FROM
                                                              dbo.ClientCoverageHistory icch
                                                              WHERE
                                                              CAST(StartDate AS DATE) <= CAST(GETDATE() AS DATE)
                                                              AND ( EndDate IS NULL
                                                              OR CAST(EndDate AS DATE) >= CAST(GETDATE() AS DATE)
                                                              )
                                                            ) AS cch ON cch.ClientCoveragePlanId = clientcvg.ClientCoveragePlanId
                                            CROSS JOIN ( SELECT
                                                              MIN(ServiceAreaId) AS ServiceAreaId
                                                         FROM ServiceAreas
                                                       ) SrvcArea
                                   WHERE    response.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                            AND clientcvg.CoveragePlanId NOT IN (
                                            SELECT  irspcvg.CoveragePlanId
                                            FROM    @ResponseCoveragePlans AS irspcvg
                                            WHERE   irspcvg.CoveragePlanId IS NOT NULL )
                                 ),
                            InactiveCoveragesEndDate
                              AS ( SELECT   EligibilityVerificationRequestId ,
                                            CoveragePlanId ,
                                            VerifiedResponseType ,
                                            ServiceAreaId ,
                                            CurrentCoverage ,
                                            CurrentCoverageStartDate ,
                                            CurrentCoverageEndDate ,
                                            ServiceStartDate ,
                                            ServiceEndDate ,
                                            NULL AS CoverageStartDate ,
                                            CASE WHEN ServiceStartDate > CurrentCoverageStartDate
                                                 THEN ServiceStartDate
                                                 WHEN ServiceEndDate > CurrentCoverageEndDate
                                                 THEN ServiceEndDate
                                                 ELSE NULL
                                            END AS CoverageEndDate
                                   FROM     InactiveCoverages
                                 )
                        INSERT  INTO [dbo].[ElectronicEligibilityVerificationCoveragePlans]
                                ( [EligibilityVerificationRequestId] ,
                                  [CoveragePlanId] ,
                                  [VerifiedResponseType] ,
                                  [CoverageStartDate] ,
                                  [CoverageEndDate] ,
                                  [ServiceAreaId] ,
                                  [IsCoverageActive] ,
                                  [IsNewCoverage] ,
                                  [IsSpendown] ,
                                  [HasSpendBeenMet] ,
                                  [DoesCoverageNeedManualChange]
                            
                                )
                                SELECT  EligibilityVerificationRequestId ,
                                        CoveragePlanId ,
                                        VerifiedResponseType ,
                                        CoverageStartDate ,
                                        CoverageEndDate ,
                                        ServiceAreaId ,                   
										--CurrentCoverage ,
										--ServiceStartDate ,
										--ServiceEndDate ,
										--CurrentCoverageStartDate,
										--CurrentCoverageEndDate,            
                                        CAST(''N'' AS CHAR(1)) AS IsCoverageActive ,
                                        CAST(''N'' AS CHAR(1)) AS IsNewCoverage ,
                                        CAST(''N'' AS CHAR(1)) AS IsSpendown ,
                                        CAST(''N'' AS CHAR(1)) AS HasSpendBeenMet ,
                                        CASE WHEN CurrentCoverage = ''Billable''
                                                  AND CoverageEndDate IS NOT NULL
                                             THEN ''N''
                                             WHEN CurrentCoverage = ''Billable''
                                                  AND CoverageEndDate IS NULL
                                             THEN ''Y''
                                             ELSE NULL
                                        END AS DoesCoverageNeedManualChange
                                FROM    InactiveCoveragesEndDate                                    
                END	
            
		-- Threshold Business Rule #1 - If benefit section returns one of the ICP plans, then the "Medicaid Prof" and 
		-- "Medicaid MRO" plans should be ended for the period that ICP is active.			
            UPDATE  [dbo].[ElectronicEligibilityVerificationCoveragePlans]
            SET     VerifiedResponseType = ''Not Billable'' ,
                    DoesCoverageNeedManualChange = ''Y''
            FROM    [dbo].[ElectronicEligibilityVerificationCoveragePlans] cvg
                    INNER JOIN dbo.CoveragePlans plans ON cvg.CoveragePlanId = plans.CoveragePlanId
            WHERE   CoveragePlanName IN ( ''Medicaid MRO'',
                                          ''Medicaid Professional'' )
                    AND cvg.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                    AND EXISTS ( SELECT *
                                 FROM   [dbo].[ElectronicEligibilityVerificationCoveragePlans] icvg
                                        INNER JOIN dbo.CoveragePlans iplans ON icvg.CoveragePlanId = iplans.CoveragePlanId
                                 WHERE  icvg.EligibilityVerificationRequestId = cvg.EligibilityVerificationRequestId
                                        AND iplans.CoveragePlanName IN (
                                        ''ICP Aetna'', ''ICP IlliniCare'' )
                                        AND icvg.CoverageEndDate IS NULL
                                        AND VerifiedResponseType = ''Billable'' )
										
		-- Threshold Business Rule #2.	If benefit section returns Medicaid SASS plan, then the "Medicaid MRO" plan 
		-- should be ended for the period that SASS is active 
            UPDATE  [dbo].[ElectronicEligibilityVerificationCoveragePlans]
            SET     VerifiedResponseType = ''Not Billable'' ,
                    DoesCoverageNeedManualChange = ''Y''
            FROM    [dbo].[ElectronicEligibilityVerificationCoveragePlans] cvg
                    INNER JOIN dbo.CoveragePlans plans ON cvg.CoveragePlanId = plans.CoveragePlanId
            WHERE   CoveragePlanName IN ( ''Medicaid MRO'' )
                    AND cvg.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                    AND EXISTS ( SELECT *
                                 FROM   [dbo].[ElectronicEligibilityVerificationCoveragePlans] icvg
                                        INNER JOIN dbo.CoveragePlans iplans ON icvg.CoveragePlanId = iplans.CoveragePlanId
                                 WHERE  icvg.EligibilityVerificationRequestId = cvg.EligibilityVerificationRequestId
                                        AND iplans.CoveragePlanName IN (
                                        ''Medicaid SSAS'' )
                                        AND icvg.CoverageEndDate IS NULL
                                        AND VerifiedResponseType = ''Billable'' )

			-- Calculate COB Order by ranking coverages against the COB Priority in CustomElectronicEligibilityCoveragePlanCOBPriority
            UPDATE  dbo.ElectronicEligibilityVerificationCoveragePlans
            SET     COBOrder = CalcCOBOrder.COBOrder
            FROM    dbo.ElectronicEligibilityVerificationCoveragePlans eleccvg
                    INNER JOIN ( SELECT allcvg.CoveragePlanId ,
                                        allcvg.ClientId ,
                                        allcvg.EligibilityVerificationRequestId ,
                                        RANK() OVER ( PARTITION BY allcvg.ClientId ORDER BY COB.COBPriority ASC, allcvg.CoveragePlanId ASC ) AS COBOrder
                                 FROM   ( SELECT    cvg.CoveragePlanId , -- include coverages that will be started for COB Order calc.
                                                    hist.ClientId ,
                                                    cvg.EligibilityVerificationRequestId
                                          FROM      dbo.ElectronicEligibilityVerificationCoveragePlans cvg
                                                    INNER JOIN dbo.ElectronicEligibilityVerificationRequests hist ON cvg.EligibilityVerificationRequestId = hist.EligibilityVerificationRequestId
                                          WHERE     cvg.DoesCoverageNeedManualChange = ''N'' -- eligible for auto update?
                                                    AND cvg.CoverageStartDate IS NOT NULL -- only start coverage where coverage start dates are specified
                                          UNION
                                          ( SELECT  ccp.CoveragePlanId , -- include existing coverages in COB Order calc.
                                                    req.ClientId ,
                                                    req.EligibilityVerificationRequestId
                                            FROM    dbo.ClientCoveragePlans ccp
                                                    INNER JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                              AND cch.EndDate IS NULL
                                                    INNER JOIN dbo.ElectronicEligibilityVerificationRequests req ON req.ClientId = ccp.ClientId
                                            WHERE   req.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                          )
                                        ) allcvg
                                        INNER JOIN dbo.CustomElectronicEligibilityCoveragePlanCOBPriority COB ON allcvg.CoveragePlanId = COB.CoveragePlanId
                                                              AND allcvg.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                               ) CalcCOBOrder ON eleccvg.CoveragePlanId = CalcCOBOrder.CoveragePlanId
                                                 AND CalcCOBOrder.EligibilityVerificationRequestId = eleccvg.EligibilityVerificationRequestId			

                                                 
			-- Add to 271 Response XML summarized eligibility xml 
            UPDATE  dbo.ElectronicEligibilityVerificationRequests
            SET     VerifiedXMLResponse.modify(''delete /eligibilityresponse/SummaryCoverages'')
            WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId ;

            DECLARE @SummaryXML XML ;

            SELECT  @SummaryXML = Summary.SummaryXML
            FROM    ( SELECT    ( SELECT    ( SELECT    payer.ElectronicPayerName ,
                                                        UPPER(VerifiedResponseType) AS VerifiedResponseType ,
                                                        CAST(CoverageStartDate AS DATE) AS CoverageStartDate ,
                                                        CAST(CoverageEndDate AS DATE) AS CoverageEndDate
                                              FROM      dbo.ElectronicEligibilityVerificationCoveragePlans eleccvg
                                                        INNER JOIN dbo.CoveragePlans cvg ON eleccvg.CoveragePlanId = cvg.CoveragePlanId
                                                        INNER JOIN dbo.ElectronicEligibilityVerificationRequests req ON eleccvg.EligibilityVerificationRequestId = req.EligibilityVerificationRequestId
                                                        INNER JOIN dbo.ElectronicEligibilityVerificationPayers payer ON req.ElectronicEligibilityVerificationPayerId = payer.ElectronicEligibilityVerificationPayerId
                                              WHERE     eleccvg.EligibilityVerificationRequestId = @EligibilityVerificationRequestId
                                                        AND cvg.CoveragePlanName NOT IN (
                                                        ''Medicare Part B'',
                                                        ''OMH Non Medicaid'' )
                                              GROUP BY  payer.ElectronicPayerName ,
                                                        VerifiedResponseType ,
                                                        CoverageStartDate ,
                                                        CoverageEndDate
                                            FOR
                                              XML PATH(''SummaryCoverage'') ,
                                                  TYPE
                                            )
                                FOR
                                  XML PATH('''') ,
                                      ROOT(''SummaryCoverages'')
                                ) AS SummaryXML
                    ) Summary ;
                   

            UPDATE  dbo.ElectronicEligibilityVerificationRequests
            SET     VerifiedXMLResponse.modify(''insert sql:variable("@SummaryXML") into (/eligibilityresponse)[1]'')
            WHERE   EligibilityVerificationRequestId = @EligibilityVerificationRequestId ;
       
       
        	--2. Convert response xml to html
            UPDATE  [dbo].[ElectronicEligibilityVerificationRequests]
            SET     [VerifiedResponseText] = dbo.XmlTransform(history.VerifiedXMLResponse,
                                                              xsl.ResponseXSL)
            FROM    [dbo].[ElectronicEligibilityVerificationRequests] AS history
                    INNER JOIN dbo.ElectronicEligibilityVerificationPayers AS xsl ON history.ElectronicEligibilityVerificationPayerId = xsl.ElectronicEligibilityVerificationPayerId
            WHERE   history.EligibilityVerificationRequestId = @EligibilityVerificationRequestId 
            
        END TRY
        BEGIN CATCH 
            IF XACT_STATE() <> 0 
                ROLLBACK TRANSACTION ;

            IF ERROR_NUMBER() <> 0 
                EXECUTE dbo.ssp_RethrowError   -- this throws error number 50000 to the client with info in the message
	                           
        END CATCH ;
            
    END
' 
END
GO
