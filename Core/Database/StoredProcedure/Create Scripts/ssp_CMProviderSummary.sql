
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_CMProviderSummary]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_CMProviderSummary] 

GO 


SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_CMProviderSummary] (@ProviderId INT, 
                                                @StaffId    INT) 
AS 
/*********************************************************************/ 
/* Stored Procedure: ssp_MemberSummary								 */ 
/* Copyright: 2005 Provider Claim Management System					 */ 
/* Creation Date:  12/04/2005										 */ 
/*                                                                   */ 
/* Purpose: it will returns detail of the selected provider          */ 
/*                                                                   */ 
/* Input Parameters: @ProviderId									 */
/*				   : @StaffId										 */ 
/*                                                                   */ 
/* Output Parameters:												 */ 
/*                                                                   */ 
/* Return:Roles of the user											 */ 
/*                                                                   */ 
/* Called By:                                                        */ 
/*                                                                   */ 
/* Calls:                                                            */ 
/*                                                                   */ 
/* Data Modifications:                                               */ 
/*                                                                   */ 
/* Updates:                                                          */ 
/*  Date         Author           Purpose							 */ 
/* 12/04/2005  Rakesh Sharan     Created                             */ 
/* 09/04/2014  Manju P           Modified- What/Why:Care Management to SmartCare Tasl#19 Provider - Provider Summary  */ 
/*								 Staff table has been used instead of user table & used try.. catch for error handling */ 
/*								 Removed commented blocks of code	 */ 
/* 24/04/2014  Manju P			 Retained the case of table names and column names */
/* 19/06/2014  Manju P			 selected the top 1 row for provider info */
/* 12/08/2014  Malathi Shiva	 Task#19: Care Management to SmartCare:
1. Site Type , Primary Site, and Site Status are displayed twice  
2. For few Providers, Site Address is displayed instead of Primary Site 
because Biling Check was missing in the storedprocedure so there were 2 addresses displayed by the core sp so as the binding was incorrect*/
/* 20/12/2016  Sib sankar   Modified for Primary only  appear on the provider summary Task # 86 AspenPointe - Support Go Live*/
/* 08 AUG 2018	MJensen		Primary site info is duplicated when there are multiple addresses.		SWMBH Enhancements #816		*/
/* 07 Jan 2019  Gautam      Modified code for Performance issue. Related to task ,Task #1128,Kalamazoo Build Cycle Tasks */
/*********************************************************************/ 
    DECLARE @InsurerId INT 
    -- Variables declared to hold different values as on 07/06/2006 
    DECLARE @Pended MONEY 
    DECLARE @PendedMoreThan60Days MONEY 
    DECLARE @PayableAmount MONEY 
    DECLARE @PayablePast30Days MONEY 
    DECLARE @CreditReceivable MONEY 

  BEGIN 
      BEGIN try 
      
		Create Table #ClaimLineHistoryDate
		(ClaimLineId int,
		 ActivityDate DateTime,
		 ClaimedAmount Money)
		 
          -- fetch PrimaryInsurerId for the current user 
          IF ( (SELECT AllInsurers 
                FROM   Staff 
                WHERE  StaffId = @StaffId 
                       AND IsNull(RecordDeleted, 'N') = 'N') = 'Y' ) 
            SET @InsurerId=0 
          ELSE 
            SELECT @InsurerId = PrimaryInsurerId 
            FROM   Staff 
            WHERE  StaffId = @StaffId 
                   AND IsNull(RecordDeleted, 'N') = 'N' 

          DECLARE @FromDate VARCHAR(10) 

          SELECT @FromDate = CASE 
                               WHEN (SELECT FiscalMonth 
                                     FROM   SystemConfigurations) > 
                                    month(getdate()) 
                             THEN 
                               (SELECT ltrim(str(FiscalMonth)) 
                                FROM 
                             SystemConfigurations) 
                               + '/1/' 
                               + ltrim(str 
                               ( 
                               year(getdate())-1)) 
                               ELSE (SELECT ltrim(str(FiscalMonth)) 
                                     FROM   SystemConfigurations) 
                                    + '/1/' + ltrim(str(year(getdate()))) 
                             END 

          --Providers Table  0 
          SELECT TOP 1 Providers.ProviderId, 
                 CASE Providers.ProviderType 
                   WHEN 'I' THEN Providers.ProviderName + ', ' 
                                 + Providers.FirstName 
                   WHEN 'F' THEN Providers.ProviderName 
                 END                                              AS 
                 ProviderName, 
                 ( CONVERT(VARCHAR(10), Contracts.EndDate, 101) ) AS EndDate, 
                 (SELECT CASE 
                           WHEN( Providers.Active ) = 'Y' THEN 'Active' 
                           ELSE 'InActive' 
                         END)                                     AS Active, 
                 (SELECT CASE 
                           WHEN( Providers.NonNetwork ) = 'Y' THEN 'No' 
                           ELSE 'Yes' 
                         END)                                     AS NonNetwork, 
                 (SELECT CASE 
                           WHEN( Providers.ProviderType ) = 'F' THEN 'Facility' 
                           ELSE 'Individual' 
                         END)                                     AS 
                 ProviderType, 
                 ltrim(ProviderContacts.LastName + ', ' 
                       + ProviderContacts.FirstName)              AS ContactName 
                 , 
                 CASE 
                   WHEN IsNull(ProviderContacts.WorkPhone, '') = '' THEN 
                   ProviderContacts.MobilePhone 
                   ELSE ProviderContacts.WorkPhone 
                 END                                              AS WorkPhone, 
                 Providers.Comment, 
                 ProviderContacts.ProviderContactId 
                 ,Providers.PrimarySiteId
          FROM   Providers 
                 LEFT JOIN Contracts 
                        ON Contracts.ProviderId = Providers.ProviderId 
                           AND isnull(Contracts.RecordDeleted, 'N') = 'N' 
                 LEFT JOIN ProviderContacts 
                        ON ProviderContacts.ProviderContactId = 
                           Providers.PrimaryContactId 
                           AND isnull(ProviderContacts.RecordDeleted, 'N') = 'N' 
          WHERE  Providers.ProviderId = @ProviderId 
                 AND isnull(Providers.RecordDeleted, 'N') = 'N' 

          IF EXISTS(SELECT ContractId 
                    FROM   Contracts 
                    WHERE  ProviderId = @ProviderId 
                           AND ( RecordDeleted = 'N' 
                                  OR RecordDeleted IS NULL ) 
                           AND Status = 'A') 
            BEGIN 
                SELECT TOP 1 ContractId, 
                             ( CONVERT(VARCHAR(10), Contracts.EndDate, 101) ) AS 
                             EndDate 
                FROM   Contracts 
                WHERE  ProviderId = @ProviderId 
                       AND ( RecordDeleted = 'N' 
                              OR RecordDeleted IS NULL ) 
                       AND Status = 'A' 
                ORDER  BY EndDate 
            END 
          ELSE 
            BEGIN 
                SELECT TOP 1 ContractId, 
                             ( CONVERT(VARCHAR(10), Contracts.EndDate, 101) ) AS 
                             EndDate 
                FROM   Contracts 
                WHERE  ProviderId = @ProviderId 
                       AND ( RecordDeleted = 'N' 
                              OR RecordDeleted IS NULL ) 
                       AND Status = 'I' 
                ORDER  BY EndDate DESC 
            END 

          --Sites Table 1 
          SELECT TOP 1 Sites.SiteName, 
                 Sites.ProviderId, 
                 Sites.SiteId, 
                 (SELECT CASE 
                           WHEN( Sites.Active ) = 'Y' THEN 'Active' 
                           ELSE 'InActive' 
                         END)                              AS Active, 
                 SiteAddressess.Address, 
                 SiteAddressess.City, 
                 ( Substring(SiteAddressess.State, 1, 3) ) AS State, 
                 SiteAddressess.Zip, 
                 GlobalCodes.CodeName 
          FROM   Sites 
                 LEFT JOIN Providers 
                        ON Providers.ProviderId = Sites.ProviderId 
                           AND isnull(Providers.RecordDeleted, 'N') = 'N' 
                 LEFT JOIN SiteAddressess 
                        ON SiteAddressess.SiteId = Sites.SiteId 
                           AND isnull(SiteAddressess.RecordDeleted, 'N') = 'N' 
                 LEFT JOIN GlobalCodes 
                        ON GlobalCodes.GlobalCodeId = Sites.SiteType 
                           AND isnull(GlobalCodes.RecordDeleted, 'N') = 'N' 
				 LEFT JOIN GlobalCodes gc
						ON gc.GlobalCodeId = SiteAddressess.AddressType
							AND Isnull(gc.RecordDeleted,'N') = 'N'
          WHERE  Providers.ProviderId = @ProviderId 
                 AND Providers.PrimarySiteId = Sites.SiteId 
                 AND isnull(Sites.RecordDeleted, 'N') = 'N' 
		  ORDER BY SiteAddressess.Billing DESC, gc.SortOrder


          -- Last Check 
          SELECT TOP 1 '$' + CONVERT(VARCHAR(25), c.Amount, 1) + ' on ' 
                       + CONVERT(VARCHAR(10), c.CheckDate, 101) + ' #' 
                       + CONVERT(VARCHAR(50), c.CheckNumber) AS Amount, 
                       c.CheckId, 
                       c.InsurerId 
          FROM   Checks c 
          WHERE  c.ProviderId = @ProviderId 
                 AND IsNull(c.Voided, 'N') = 'N' 
                 AND IsNull(c.RecordDeleted, 'N') = 'N' 
                 AND ( c.InsurerId = @InsurerId 
                        OR @InsurerId = 0 ) 
          ORDER  BY c.CreatedDate DESC 

          --Sites Table for Non Primary Site Name 3 
          SELECT Sites.SiteName, 
                 Sites.SiteId 
          FROM   Providers, 
                 Sites 
          WHERE  Providers.ProviderId = Sites.ProviderId 
                 AND Providers.ProviderId = @ProviderId 
                 AND Providers.PrimarySiteId != Sites.SiteId 
                 AND isnull(Providers.RecordDeleted, 'N') = 'N' 
                 AND IsNull(Sites.RecordDeleted, 'N') = 'N' 
                 AND IsNull(Sites.Active, 'N') = 'Y' 
          ORDER  BY Sites.SiteName 

          --Insurers Table 4 
          SELECT Insurers.InsurerName, 
                 Insurers.InsurerId 
          FROM   Providers, 
                 ProviderInsurers, 
                 Insurers 
          WHERE  Insurers.InsurerId = ProviderInsurers.InsurerId 
                 AND isnull(Insurers.RecordDeleted, 'N') = 'N' 
                 AND Providers.ProviderId = ProviderInsurers.ProviderId 
                 AND isnull(ProviderInsurers.RecordDeleted, 'N') = 'N' 
                 AND Providers.ProviderId = @ProviderId 
                 AND isnull(Providers.RecordDeleted, 'N') = 'N' 
                 AND Insurers.Active = 'Y' 
          ORDER  BY Insurers.InsurerName 

          --Affilliates 5 
          SELECT CASE Providers.ProviderType 
                   WHEN 'I' THEN Providers.ProviderName + ', ' 
                                 + Providers.FirstName 
                   WHEN 'F' THEN Providers.ProviderName 
                 END AS ProviderName 
          FROM   Providers 
          WHERE  Providers.ProviderID IN (SELECT Providers.ProviderID 
                                          FROM   ProviderAffiliates, 
                                                 Providers 
                                          WHERE 
                        ProviderAffiliates.AffiliateProviderId = 
                        Providers.ProviderId 
                        AND ProviderAffiliates.ProviderID = @ProviderId 
                        AND isnull(Providers.RecordDeleted, 'N') = 'N' 
                        AND IsNull(ProviderAffiliates.RecordDeleted, 'N') = 'N') 
                 AND Providers.Active = 'Y' 
          ORDER  BY ProviderName 
			
		Insert into #ClaimLineHistoryDate
		(ClaimLineId,ClaimedAmount,ActivityDate)
		Select cl.ClaimLineId	,cl.ClaimedAmount,Max(ch.ActivityDate) as ActivityDate				
		FROM ClaimLines cl
		INNER JOIN Claims c ON c.ClaimId = cl.ClaimId
			AND IsNull(c.RecordDeleted, 'N') = 'N'
		INNER JOIN Sites s ON c.SiteId = s.SiteId
			AND IsNull(s.RecordDeleted, 'N') = 'N'
		INNER JOIN Providers p ON s.ProviderId = p.ProviderId
			AND IsNull(p.RecordDeleted, 'N') = 'N'
			AND p.Active = 'Y'
		INNER JOIN ClaimLineHistory ch on cl.ClaimLineId= ch.ClaimLineId
			and IsNull(ch.RecordDeleted, 'N') = 'N'
		WHERE p.ProviderId = @ProviderId
		AND cl.STATUS = 2027
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
			AND (
				c.Insurerid = @InsurerId
				OR IsNull(@InsurerId, 0) = 0)
		group by cl.ClaimLineId	,cl.ClaimedAmount		
		
          -- Query to fetch data for Pended, PendedMoreThan60Days, PayableAmount, PayablePast30Days & CreditReceivable  (07/06/2006) 
          SELECT @Pended = SUM(CASE 
					WHEN cl.STATUS = 2027
						AND cl.ClaimedAmount > 0
						THEN cl.ClaimedAmount
					ELSE 0
					END)
			,@PendedMoreThan60Days = SUM(CASE 
					WHEN cl.STATUS = 2027
						AND cl.ClaimedAmount > 0
						AND Datediff(d, IsNull(clh.ActivityDate, GetDate()), GetDate()) >= 60
						THEN cl.ClaimedAmount
					ELSE 0
					END)
			,@PayableAmount = SUM(CASE 
					WHEN cl.STATUS IN (
							2023
							,2025
							)
						AND cl.PayableAmount > 0
						THEN cl.PayableAmount
					ELSE 0
					END)
			,@PayablePast30Days = SUM(CASE 
					WHEN cl.STATUS IN (
							2023
							,2025
							)
						AND cl.PayableAmount > 0
						AND Datediff(d, c.CleanClaimDate, GetDate()) >= 30
						THEN cl.PayableAmount
					ELSE 0
					END)
			,@CreditReceivable = - SUM(CASE 
					WHEN cl.PayableAmount < 0
						THEN cl.PayableAmount
					ELSE 0
					END)
		FROM ClaimLines cl
		INNER JOIN Claims c ON c.ClaimId = cl.ClaimId
			AND IsNull(c.RecordDeleted, 'N') = 'N'
		INNER JOIN Sites s ON c.SiteId = s.SiteId
			AND IsNull(s.RecordDeleted, 'N') = 'N'
		INNER JOIN Providers p ON s.ProviderId = p.ProviderId
			AND IsNull(p.RecordDeleted, 'N') = 'N'
			AND p.Active = 'Y'
		LEFT JOIN #ClaimLineHistoryDate clh ON clh.ClaimLineId = cl.ClaimLineId
		WHERE p.ProviderId = @ProviderId
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
			AND (
				c.Insurerid = @InsurerId
				OR IsNull(@InsurerId, 0) = 0
				)


          --Pended Table 6 
          SELECT '$' 
                 + CONVERT(VARCHAR(25), NULLIF(@Pended, 0), 1) AS Pended 

          --Paid YTD 7 
          SELECT '$' 
                 + CONVERT(VARCHAR(25), sum(Checks.Amount), 1) AS PaidYTD, 
                 @FromDate                                     AS FromDate 
          FROM   dbo.Checks 
          WHERE  ( ProviderId = @ProviderId ) 
                 AND ( ISNULL(RecordDeleted, 'N') = 'N' ) 
                 AND CheckDate BETWEEN @FromDate AND getDate() 
                 AND IsNull(Voided, 'N') = 'N' 
                 AND ( Checks.InsurerId = @InsurerId 
                        OR IsNull(@InsurerId, 0) = 0 ) 

          -- For Payable Past 30 Days 8  
          SELECT '$' 
                 + CONVERT(VARCHAR(25), NULLIF(@PayablePast30Days, 0), 1) AS PayablePast30days 

          ---PayableAmount 9 
          SELECT '$' 
                 + CONVERT(VARCHAR(25), NULLIF(@PayableAmount, 0), 1) AS PayableAmount 

          -- Credit/Receivable 10 
          SELECT '$' 
                 + CONVERT(VARCHAR(25), NULLIF(@CreditReceivable, 0), 1) AS AmountPaid 

          --Pended 60 days  Table 11 
          SELECT '$' 
                 + CONVERT(VARCHAR(25), NULLIF(@PendedMoreThan60Days, 0), 1) AS Pended60Days 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_CMProviderSummary') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                   
                      16, 
                      -- Severity.                                                                                                   
                      1 
          -- State.                                                                                                   
          ); 
      END catch 
  END 

GO   