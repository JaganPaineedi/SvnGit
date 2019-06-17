/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccounts]    Script Date: 04/09/2012 17:19:28 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMClientAccounts]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PMClientAccounts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccounts]    Script Date: 04/09/2012 17:19:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.ssp_PMClientAccounts
/********************************************************************************                                                    
-- Stored Procedure: ssp_PMClientAccounts  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Procedure to return data for the Client Accounts list page.  
--  
-- Author:  Girish Sanaba  
-- Date:    19 Apr 2011  
--  
-- *****History****  
--27 Aug 2011		Girish		moved @CustomFilters logic from 'where clause' to 'from clause' to speed it up 
								moved Stafclients logic from 'where clause' to 'from clause' to speed it up
								included clientcoveragehistory to join of clientcoverageplan for InformationComplete = 714
					 
-- 31-Aug-2011		MSuma		Included Additonal criteria for ClientMonthlyDeductibles	
-- 10.07.2011		Girish		Added condition for isselected check for allonpage		
-- 10.10.2011		MSuma		Included additional column ClientCoveragePlanId		
-- 27.10.2011		MSuma		Included additional column FinancialActivityId and PaymentId	
-- April 9, 2012    Kneale      Reconfigured the custom filter search	 
-- April 13, 2012   Ponnin      Modified Paging for Tuning	 
-- 13.04.2012       PSelvan     Added Conditions for NumberOfPages. 
-- 14.04.2012       MSuma		Modified ClientList for Tuning 
-- 06.05.2012       MSuma		Dashboard Changes for Not verified in 30 Days
-- 06.14.2012       MSuma       Update third Party Balance based on Sum(Balance) with Priority <>0
-- 04.Mar.2013		Deej		Changes Made in the customFilter Logic
-- 08.29.2013       SFarber     Changed logic for 'Monthly Deductible Not Updated Last Month' 
-- 17.Apr.2015		Revathi		what:FinancialAssignment filter added 
								why:task #950 Valley - Customizations
-- 24.Aug.2015      Gautam      What: The code to create Temp table #ClientLastNameSearch move to top
								why : Task#320,	Thresholds - Support	
-- 15-DEC-2015      Basudev Sahu Modified For Task #609 Network180 Customization
-- 26.Feb.2016		NJain		Modified logic to Compare Total Balance against External Code 1 field
								Added GlobalSubCodeId = 722 (Any Balance) to @TotalBalance IS NULL condition															
								Modified Total Balance calculation to look at all Charge Priorities
								Modified 3rd Party Balance calculation to subtract Client Balance from the Total Balance
								Added Delete statement to remove Clients from #ResultSet that are not in @TotalBalanceTable
-- 06.15.2016       SFarber     Added #ClientLastNameSearch logic for all cases,Bradford - Environment Issues Tracking: #113
-- 07.27.2016		NJain		Updated to filter based on Client Balance instead of Total Balance, parameter @TotalBalance									
*********************************************************************************/
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ClientStatusId INT ,
    @EpisodeStatusId INT ,
    @ProgramId INT ,
    @InformationComplete INT ,
    @LastNameIndex INT ,
    @PrimaryClinicianId INT ,
    @TotalBalance INT ,
    @BalanceFlag INT ,
    @RowSelectionList VARCHAR(MAX) ,
    @OtherFilter INT ,
    @StaffId INT ,
    @FinancialAssignmentId INT
AS
    BEGIN
        BEGIN TRY
		--Added by Revathi	17.Apr.2015
            DECLARE @ClientFirstLastName VARCHAR(25)
            DECLARE @ClientLastLastName VARCHAR(25)
            DECLARE @ClientLastNameCount INT = 0
        
            CREATE TABLE #ClientLastNameSearch
                (
                  LastNameSearch VARCHAR(MAX)
                )
        
            IF ISNULL(@FinancialAssignmentId, -1) <> -1
                BEGIN
                    SELECT  @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom ,
                            @ClientLastLastName = FinancialAssignmentChargeClientLastNameTo
                    FROM    FinancialAssignments
                    WHERE   FinancialAssignmentId = @FinancialAssignmentId
                            AND ISNULL(RecordDeleted, 'N') = 'N'

                    INSERT  INTO #ClientLastNameSearch
                            EXEC ssp_SCGetPatientSearchValues @ClientFirstLastName, @ClientLastLastName
				
                    SET @ClientLastNameCount = ( SELECT COUNT(1)
                                                 FROM   #ClientLastNameSearch
                                               )	
                END
      
            CREATE TABLE #ResultSet
                (
                  RowNumber INT ,
                  PageNumber INT ,
                  ClientId INT ,
                  ClientName VARCHAR(100) ,
                  ClientBalance MONEY ,
                  LastStatement DATETIME ,--VARCHAR(100) ,
                  LastCltPaymentAndDate VARCHAR(100) ,
                  ThirdPartyBalance MONEY ,
                  PrimaryPlan VARCHAR(100) ,
                  NeedInformation VARCHAR(5) ,
                  IsSelected BIT ,
                  ClientCoveragePlanId INT ,
                  PaymentId INT ,
                  FinancialActivityId INT
                )

            DECLARE @CustomFilters TABLE ( ClientId INT )
            DECLARE @ApplyFilterClicked CHAR(1)
            DECLARE @CustomFiltersApplied CHAR(1)
            DECLARE @LastName CHAR(1)

            IF @LastNameIndex = -1
                SET @LastName = NULL
            ELSE
                SET @LastName = CHAR(@LastNameIndex)

            SET @SortExpression = RTRIM(LTRIM(@SortExpression))

            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'ClientName'
		-- New retrieve - the request came by clicking on the Apply Filter button                     
		--  
            SET @ApplyFilterClicked = 'Y'
            SET @CustomFiltersApplied = 'N'

            CREATE TABLE #ClientList
                (
                  ClientId INT PRIMARY KEY ,
                  InformationComplete CHAR(1) ,
                  PrimaryClinicianId INT ,
                  CurrentEpisodeNumber INT ,
                  LastName VARCHAR(50) ,
                  FirstName VARCHAR(50) ,
                  CurrentBalance MONEY ,
                  LastStatementDate DATETIME ,
                  LastPaymentId INT ,
                  ClientType CHAR(1) ,
                  OrganizationName VARCHAR(500)
                )

            IF @OtherFilter > 10000
                BEGIN
                    SET @CustomFiltersApplied = 'Y'

                    INSERT  INTO #ClientList
                            ( ClientId ,
                              InformationComplete ,
                              PrimaryClinicianId ,
                              CurrentEpisodeNumber ,
                              LastName ,
                              FirstName ,
                              CurrentBalance ,
                              LastStatementDate ,
                              LastPaymentId
                            )
                            EXEC scsp_PMClientAccounts @ClientStatusId = @ClientStatusId, @EpisodeStatusId = @EpisodeStatusId, @ProgramId = @ProgramId, @InformationComplete = @InformationComplete, @LastNameIndex = @LastNameIndex, @PrimaryClinicianId = @PrimaryClinicianId, @TotalBalance = @TotalBalance, @BalanceFlag = @BalanceFlag, @RowSelectionList = @RowSelectionList, @OtherFilter = @OtherFilter, @StaffId = @StaffId
                END

		--  
		-- User Selections  
		--             
            DECLARE @TotalBalanceTable TABLE
                (
                  ClientId INT NULL ,
                  TotalBalance MONEY NULL
                )

            IF @CustomFiltersApplied = 'N'
                BEGIN
                    DECLARE @ActiveStatus type_YOrN

                    SET @ActiveStatus = CASE WHEN @ClientStatusId = -1 THEN NULL
                                             WHEN @ClientStatusId = 1 THEN 'Y'
                                             WHEN @ClientStatusId = 2 THEN 'N'
                                        END

                    IF ( @InformationComplete = 715 )
                        BEGIN
                            INSERT  INTO #ClientList
                                    ( ClientId ,
                                      InformationComplete ,
                                      PrimaryClinicianId ,
                                      CurrentEpisodeNumber ,
                                      LastName ,
                                      FirstName ,
                                      CurrentBalance ,
                                      LastStatementDate ,
                                      LastPaymentId ,
                                      ClientType ,
                                      OrganizationName
                                    )
                                    SELECT DISTINCT
                                            a.clientid ,
                                            ISNULL(a.InformationComplete, 'N') ,
                                            a.PrimaryClinicianId ,
                                            CurrentEpisodeNumber ,
                                            LastName ,
                                            FirstName ,
                                            CurrentBalance ,
                                            LastStatementDate ,
                                            LastPaymentId ,
                                            a.ClientType ,
                                            a.OrganizationName
                                    FROM    clients a
                                            INNER JOIN dbo.StaffClients b ON ( a.ClientId = b.ClientId )
                                                                             AND b.StaffId = @StaffId
                                                                             AND ISNULL(a.RecordDeleted, 'N') = 'N'
					--Added by Revathi	17.Apr.2015            
                                                                             AND ( EXISTS ( SELECT  1
                                                                                            FROM    #ClientLastNameSearch f
                                                                                            WHERE   ISNULL(a.ClientType, 'I') = 'I'
                                                                                                    AND a.LastName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                                                   OR EXISTS ( SELECT   1
                                                                                               FROM     #ClientLastNameSearch f
                                                                                               WHERE    ISNULL(a.ClientType, 'I') = 'O'
                                                                                                        AND a.OrganizationName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                                                   OR ( ISNULL(@ClientLastNameCount, 0) = 0 )
                                                                                 )
                                            INNER JOIN ClientCoveragePlans ccp ON ccp.ClientId = a.ClientId
                                            INNER JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                                            INNER JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                    WHERE   ISNULL(a.Active, 'N') = ISNULL(@ActiveStatus, ISNULL(a.Active, 'N'))
                                            AND ( @LastName IS NULL
                                                  OR ( ISNULL(a.ClientType, 'I') = 'I'
                                                       AND a.LastName LIKE ( @LastName + '%' )
                                                     )
                                                  OR ( ISNULL(a.ClientType, 'I') = 'O'
                                                       AND a.OrganizationName LIKE ( @LastName + '%' )
                                                     )
                                                )
                                            AND ( @BalanceFlag = 0
                                                  OR ISNULL(a.CurrentBalance, 0) > 0
                                                )
                                            AND ISNULL(ccp.LastVerified, GETDATE()) <= DATEADD(dd, -30, GETDATE())
                                            AND ( ( cch.StartDate <= GETDATE()
                                                    AND cch.EndDate >= GETDATE()
                                                  )
                                                  OR ( cch.StartDate <= GETDATE()
                                                       AND cch.EndDate IS NULL
                                                     )
                                                )
                        END
                    ELSE
                        BEGIN
                            INSERT  INTO #ClientList
                                    ( ClientId ,
                                      InformationComplete ,
                                      PrimaryClinicianId ,
                                      CurrentEpisodeNumber ,
                                      LastName ,
                                      FirstName ,
                                      CurrentBalance ,
                                      LastStatementDate ,
                                      LastPaymentId ,
                                      ClientType ,
                                      OrganizationName
                                    )
                                    SELECT  a.clientid ,
                                            ISNULL(a.InformationComplete, 'N') ,
                                            a.PrimaryClinicianId ,
                                            CurrentEpisodeNumber ,
                                            LastName ,
                                            FirstName ,
                                            CurrentBalance ,
                                            LastStatementDate ,
                                            LastPaymentId ,
                                            a.ClientType ,
                                            a.OrganizationName
                                    FROM    clients a
                                            INNER JOIN dbo.StaffClients b ON ( a.ClientId = b.ClientId )
                                                                             AND b.StaffId = @StaffId
                                                                             AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                                                             AND ( EXISTS ( SELECT  1
                                                                                            FROM    #ClientLastNameSearch f
                                                                                            WHERE   ISNULL(a.ClientType, 'I') = 'I'
                                                                                                    AND a.LastName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                                                   OR EXISTS ( SELECT   1
                                                                                               FROM     #ClientLastNameSearch f
                                                                                               WHERE    ISNULL(a.ClientType, 'I') = 'O'
                                                                                                        AND a.OrganizationName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                                                   OR ( ISNULL(@ClientLastNameCount, 0) = 0 )
                                                                                 )
                                    WHERE   ISNULL(a.Active, 'N') = ISNULL(@ActiveStatus, ISNULL(a.Active, 'N'))
                                            AND ( @LastName IS NULL
                                                  OR a.LastName LIKE ( @LastName + '%' )
                                                )
                                            AND ( @BalanceFlag = 0
                                                  OR ISNULL(a.CurrentBalance, 0) > 0
                                                )
                        END

                    IF ( @EpisodeStatusId IN ( 702, 703, 704, 705 ) )
                        BEGIN
                            DELETE  FROM #ClientList
                            WHERE   clientid NOT IN ( SELECT    clientid
                                                      FROM      dbo.ClientEpisodes b
                                                      WHERE     b.ClientId = clientid
                                                                AND ( ( @EpisodeStatusId = 702
                                                                        AND b.STATUS <> 102
                                                                      )
                                                                      OR ( @EpisodeStatusId = 703
                                                                           AND b.STATUS = 100
                                                                         )
                                                                      OR ( @EpisodeStatusId = 704
                                                                           AND b.STATUS = 101
                                                                         )
                                                                      OR ( @EpisodeStatusId = 705
                                                                           AND b.STATUS = 102
                                                                         )
                                                                    ) )
                        END

                    IF @ProgramId = -1
                        BEGIN
                            DELETE  FROM #ClientList
                            WHERE   clientid NOT IN ( SELECT    clientid
                                                      FROM      clientprograms b
                                                      WHERE     b.ClientId = clientid
                                                                AND b.STATUS = 4
                                                                AND ISNULL(b.RecordDeleted, 'N') = 'N' )

 
                        END
                    ELSE
                        BEGIN
                            IF @ProgramId <> -1
                                AND @ProgramId <> 0
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   clientid NOT IN ( SELECT    clientid
                                                              FROM      clientprograms b
                                                              WHERE     b.ClientId = clientid
                                                                        AND @ProgramId = b.ProgramId
                                                                        AND ISNULL(b.RecordDeleted, 'N') = 'N'
								--Added by Revathi	17.Apr.2015                   
                                                                        AND ( ISNULL(@FinancialAssignmentId, -1) = -1
                                                                              OR ( EXISTS ( SELECT  1
                                                                                            FROM    FinancialAssignments
                                                                                            WHERE   FinancialAssignmentId = @FinancialAssignmentId
                                                                                                    AND ISNULL(AllChargeProgram, 'N') = 'Y'
                                                                                                    AND ISNULL(RecordDeleted, 'N') = 'N' )
                                                                                   OR EXISTS ( SELECT   1
                                                                                               FROM     FinancialAssignmentPrograms FAPP
                                                                                               WHERE    FAPP.FinancialAssignmentId = @FinancialAssignmentId
                                                                                                        AND FAPP.ProgramId = b.ProgramId
                                                                                                        AND FAPP.AssignmentType = 8979
                                                                                                        AND ISNULL(FAPP.RecordDeleted, 'N') = 'N' )
                                                                                 )
                                                                            ) )
                                END
                        END

                    IF @InformationComplete IN ( 712, 713, 714 )
                        BEGIN
                            IF @InformationComplete = 713
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   InformationComplete = 'Y'
                                END

                            IF @InformationComplete = 712
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   InformationComplete = 'Y'
                                            OR clientid NOT IN --(
						--SELECT  clientid
						--FROM    services b
						--WHERE   b.ClientId = clientid
						--        AND b.status IN ( 71, 75 )
						--        AND ISNULL(b.RecordDeleted,
						--                  'N') = 'N' )
						( SELECT    C.clientid
                          FROM      Clients c
                                    LEFT JOIN ClientEpisodes ce ON ce.ClientId = c.ClientId
                                                                   AND c.CurrentEpisodeNumber = ce.episodenumber
                                                                   AND ISNULL(ce.RecordDeleted, 'N') = 'N'
							--Moved this to join
                                    INNER JOIN StaffClients sc ON sc.StaffId = @StaffId
                                                                  AND sc.ClientId = c.ClientId
                          WHERE     EXISTS ( SELECT ServiceId
                                             FROM   Services s
                                             WHERE  s.ClientId = c.ClientId
                                                    AND s.STATUS IN ( 71, 75 ) -- Show/Complete       
                                                    AND ISNULL(s.RecordDeleted, 'N') = 'N' )
                                    AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(c.InformationComplete, 'N') = 'N'
                                    AND ISNULL(c.active, 'n') = 'Y'
								--AND ce.Status<>102  
								--Added by MSuma since CE has many status as NULL
                                    AND CE.STATUS IN ( 100, 101 ) )
                                END

                            IF @InformationComplete = 714
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   clientid NOT IN ( SELECT    c.ClientId
                                                              FROM      Clients c
                                                                        INNER JOIN StaffClients sc ON sc.StaffId = @StaffId
                                                                                                      AND sc.ClientId = c.ClientId
                                                              WHERE     ISNULL(c.RecordDeleted, 'N') = 'N'
                                                                        AND ( ( c.Active = 'Y'
                                                                                AND EXISTS ( SELECT *
                                                                                             FROM   ClientEpisodes ce
                                                                                             WHERE  ce.ClientId = c.ClientId
                                                                                                    AND ce.STATUS IN ( 100, 101 ) -- 'Registered', 'In Treatment' 
                                                                                                    AND ce.EpisodeNumber = c.CurrentEpisodeNumber
                                                                                                    AND ISNULL(ce.RecordDeleted, 'N') = 'N' )
                                                                              )
                                                                              OR EXISTS ( SELECT    *
                                                                                          FROM      ClientEpisodes ce
                                                                                          WHERE     ce.ClientId = c.ClientId
                                                                                                    AND ce.STATUS = 102 -- Discharged 
                                                                                                    AND CONVERT(CHAR(6), ce.DischargeDate, 112) = CONVERT(CHAR(6), DATEADD(mm, -1, GETDATE()), 112)
                                                                                                    AND ISNULL(ce.RecordDeleted, 'N') = 'N' )
                                                                              OR EXISTS ( SELECT    *
                                                                                          FROM      Services s
                                                                                          WHERE     s.ClientId = c.ClientId
                                                                                                    AND s.Billable = 'Y'
                                                                                                    AND s.STATUS IN ( 70, 71, 75 )
                                                                                                    AND CONVERT(CHAR(6), s.DateOfService, 112) = CONVERT(CHAR(6), DATEADD(mm, -1, GETDATE()), 112)
                                                                                                    AND ISNULL(s.RecordDeleted, 'N') = 'N' )
                                                                            )
                                                                        AND EXISTS ( SELECT *
                                                                                     FROM   ClientCoveragePlans cp
                                                                                            INNER JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                                                                     WHERE  cp.ClientId = c.ClientId
                                                                                            AND CONVERT(CHAR(6), cch.StartDate, 112) <= CONVERT(CHAR(6), DATEADD(mm, -1, GETDATE()), 112)
                                                                                            AND ( CONVERT(CHAR(6), cch.EndDate, 112) >= CONVERT(CHAR(6), DATEADD(mm, -1, GETDATE()), 112)
                                                                                                  OR cch.EndDate IS NULL
                                                                                                )
                                                                                            AND ISNULL(cch.RecordDeleted, 'N') = 'N'
                                                                                            AND ISNULL(cp.RecordDeleted, 'N') = 'N'
                                                                                            AND EXISTS ( SELECT *
                                                                                                         FROM   ClientMonthlyDeductibles cmd
                                                                                                         WHERE  cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                                                                                                AND cmd.DeductibleYear = YEAR(DATEADD(mm, -1, GETDATE()))
                                                                                                                AND cmd.DeductibleMonth = MONTH(DATEADD(mm, -1, GETDATE()))
                                                                                                                AND ( cmd.DeductibleMet = 'U'
                                                                                                                      OR ( cmd.DeductibleMet = 'Y'
                                                                                                                           AND cmd.DateMet IS NULL
                                                                                                                         )
                                                                                                                    )
                                                                                                                AND ISNULL(cmd.RecordDeleted, 'N') = 'N' ) ) )
                                END
                        END

                    IF @PrimaryClinicianId >= 0
                        BEGIN
                            IF @PrimaryClinicianId = 0
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   PrimaryClinicianId IS NOT NULL
                                END
                            ELSE
                                BEGIN
                                    DELETE  FROM #ClientList
                                    WHERE   ISNULL(PrimaryClinicianId, -1) <> @PrimaryClinicianId
                                END
                        END

                    INSERT  INTO @CustomFilters
                            ( ClientId )
                            SELECT  ClientId
                            FROM    #ClientList
                END

            INSERT  INTO #ResultSet
                    ( ClientId ,
                      ClientName ,
                      ClientBalance ,
                      LastStatement ,
                      LastCltPaymentAndDate ,
                      NeedInformation ,
                      IsSelected ,
                      PaymentId ,
                      FinancialActivityId
                    )
                    SELECT DISTINCT
                            a.ClientId ,
                            CASE WHEN ISNULL(a.ClientType, 'I') = 'I' THEN a.LastName + ', ' + a.FirstName
                                 ELSE a.OrganizationName
                            END AS ClientName ,
                            a.CurrentBalance ,
                            a.LastStatementDate ,
                            ISNULL('$' + CONVERT(VARCHAR, d.Amount) + ' ' + CONVERT(VARCHAR, d.DateReceived, 101), '') ,
                            CASE a.InformationComplete
                              WHEN 'Y' THEN 'No'
                              WHEN 'N' THEN 'Yes'
                            END ,
                            0 ,
                            d.PaymentId ,
                            d.FinancialActivityId
                    FROM    #ClientList a --JOIN Clients a ON x.ClientId = a.ClientId
			--JOIN StaffClients sc ON sc.ClientId = a.ClientId
                            LEFT JOIN ClientPrograms b ON a.ClientId = b.ClientId
                            LEFT JOIN ClientEpisodes c ON a.ClientId = c.ClientId
                                                          AND a.CurrentEpisodeNumber = c.Episodenumber
                            LEFT JOIN Payments d ON a.LastPaymentId = d.PaymentId
                            LEFT JOIN dbo.GlobalSubCodes gsc ON gsc.GlobalSubCodeId = @TotalBalance
                                                                AND ISNULL(gsc.RecordDeleted, 'N') = 'N'
                                                                AND gsc.Active = 'Y'
                    WHERE   ( ISNULL(a.CurrentBalance, 0) > ISNULL(CONVERT(DECIMAL, gsc.ExternalCode1), 0)
                              OR @TotalBalance = 722
                              OR @TotalBalance IS NULL
                            )

		-- Balance Section  
            --IF ( @TotalBalance IS NULL
            --     OR @TotalBalance = 722
            --   )
                --BEGIN
            INSERT  INTO @TotalBalanceTable
                    ( ClientId ,
                      TotalBalance
                    )
                    SELECT  a.ClientId ,
                            ISNULL(SUM(d.Balance), 0)
                    FROM    #ResultSet a
                            LEFT JOIN Services b ON ( a.ClientId = b.ClientId )
                            LEFT JOIN Charges c ON ( b.ServiceId = c.ServiceId )
                                                           --AND C.Priority <> 0
                            LEFT JOIN OpenCharges d ON ( c.ChargeId = d.ChargeId )
                    GROUP BY a.ClientId
            --    END
            --ELSE
            --    BEGIN
            --        INSERT  INTO @TotalBalanceTable
            --                ( ClientId ,
            --                  TotalBalance
            --                )
            --                SELECT  a.ClientId ,
            --                        ISNULL(SUM(d.Balance), 0)
            --                FROM    #ResultSet a
            --                        LEFT JOIN Services b ON ( a.ClientId = b.ClientId )
            --                        LEFT JOIN Charges c ON ( b.ServiceId = c.ServiceId )
            --                                               --AND C.Priority <> 0
            --                        LEFT JOIN OpenCharges d ON ( c.ChargeId = d.ChargeId )
            --                        LEFT JOIN dbo.GlobalSubCodes gsc ON gsc.GlobalSubCodeId = @TotalBalance
            --                                                            AND ISNULL(gsc.RecordDeleted, 'N') = 'N'
            --                                                            AND gsc.Active = 'Y'
            --                GROUP BY a.ClientId ,
            --                        gsc.ExternalCode1
            --                HAVING  ISNULL(SUM(d.Balance), 0) > ISNULL(CONVERT(DECIMAL, gsc.ExternalCode1), 0)
            --    END



            UPDATE  a
            SET     ThirdPartyBalance = ISNULL(b.TotalBalance, 0) - ISNULL(a.ClientBalance, 0)
            FROM    #ResultSet a
                    LEFT JOIN @TotalBalanceTable b ON ( a.ClientId = b.ClientId )
			
			
            DELETE  FROM #ResultSet
            WHERE   ClientId NOT IN ( SELECT DISTINCT
                                                ClientId
                                      FROM      @TotalBalanceTable )

		-- Primary Plan  
            UPDATE  a
            SET     PrimaryPlan = d.DisplayAs ,
                    ClientCoveragePlanId = b.ClientCoveragePlanId
            FROM    #ResultSet a
                    INNER JOIN ClientCoveragePlans b ON ( a.ClientId = b.ClientId )
                    INNER JOIN ClientCoverageHistory c ON ( b.ClientCoveragePlanId = c.ClientCoveragePlanId )
                    INNER JOIN CoveragePlans d ON ( b.CoveragePlanId = d.CoveragePlanId )
            WHERE   ISNULL(b.RecordDeleted, 'N') = 'N'
                    AND c.StartDate <= GETDATE()
                    AND ( c.EndDate IS NULL
                          OR c.EndDate > DATEADD(dd, 1, GETDATE())
                        )
                    AND c.COBOrder = 1;

            WITH    counts
                      AS ( SELECT   COUNT(*) AS totalrows
                           FROM     #ResultSet
                         ),
                    RankResultSet
                      AS ( SELECT   ClientId ,
                                    ClientName ,
                                    ClientBalance ,
                                    LastStatement ,
                                    LastCltPaymentAndDate ,
                                    ThirdPartyBalance ,
                                    PrimaryPlan ,
                                    NeedInformation ,
                                    IsSelected ,
                                    ClientCoveragePlanId ,
                                    PaymentId ,
                                    FinancialActivityId ,
                                    COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'ClientId' THEN ClientId
                                                           END
						, CASE WHEN @SortExpression = 'ClientId desc' THEN ClientId
                          END DESC
						, CASE WHEN @SortExpression = 'ClientName' THEN ClientName
                          END
						, CASE WHEN @SortExpression = 'ClientName desc' THEN ClientName
                          END DESC
						, CASE WHEN @SortExpression = 'ClientBalance' THEN ClientBalance
                          END
						, CASE WHEN @SortExpression = 'ClientBalance desc' THEN ClientBalance
                          END DESC
						, CASE WHEN @SortExpression = 'LastStatement' THEN LastStatement
                          END
						, CASE WHEN @SortExpression = 'LastStatement desc' THEN LastStatement
                          END DESC
						, CASE WHEN @SortExpression = 'LastCltPaymentAndDate' THEN LastCltPaymentAndDate
                          END
						, CASE WHEN @SortExpression = 'LastCltPaymentAndDate desc' THEN LastCltPaymentAndDate
                          END DESC
						, CASE WHEN @SortExpression = 'ThirdPartyBalance' THEN ThirdPartyBalance
                          END
						, CASE WHEN @SortExpression = 'ThirdPartyBalance desc' THEN ThirdPartyBalance
                          END DESC
						, CASE WHEN @SortExpression = 'PrimaryPlan' THEN PrimaryPlan
                          END
						, CASE WHEN @SortExpression = 'PrimaryPlan desc' THEN PrimaryPlan
                          END DESC
						, CASE WHEN @SortExpression = 'NeedInformation' THEN NeedInformation
                          END
						, CASE WHEN @SortExpression = 'NeedInformation desc' THEN NeedInformation
                          END DESC
						, ClientId ) AS RowNumber
                           FROM     #ResultSet
                         )
                SELECT TOP ( CASE WHEN ( @PageNumber = -1
                                         OR @RowSelectionList = 'all'
                                       ) THEN ( SELECT  ISNULL(totalrows, 0)
                                                FROM    counts
                                              )
                                  ELSE ( @PageSize )
                             END )
                        ClientId ,
                        ClientName ,
                        ClientBalance ,
                        LastStatement ,
                        LastCltPaymentAndDate ,
                        ThirdPartyBalance ,
                        PrimaryPlan ,
                        NeedInformation ,
                        IsSelected ,
                        ClientCoveragePlanId ,
                        PaymentId ,
                        FinancialActivityId ,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    RankResultSet
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

            IF LOWER(@RowSelectionList) = 'all'
                BEGIN
                    UPDATE  #FinalResultSet
                    SET     IsSelected = 1
                END
            ELSE
                BEGIN
                    IF LOWER(@RowSelectionList) = 'none'
                        BEGIN
                            UPDATE  #FinalResultSet
                            SET     IsSelected = 0
                        END
                    ELSE
                        IF LOWER(@RowSelectionList) = 'allonpage'
                            BEGIN
                                UPDATE  #FinalResultSet
                                SET     IsSelected = 1
					--WHERE   SessionId = @SessionId
					--        AND InstanceId = @InstanceId
					--        AND PageNumber != @PageNumber			
                            END
                        ELSE
                            BEGIN
                                CREATE TABLE #RowSelection
                                    (
                                      ClientId INT ,
                                      IsSelected BIT
                                    )

                                INSERT  INTO #RowSelection
                                        ( ClientId ,
                                          IsSelected
                                        )
                                        SELECT  ids ,
                                                IsSelected
                                        FROM    dbo.SplitJSONString(@RowSelectionList, ',')

                                UPDATE  #FinalResultSet
                                SET     IsSelected = a.IsSelected
                                FROM    #RowSelection a
                                WHERE   a.ClientId = #FinalResultSet.ClientId
                            END
                END

            IF ( SELECT ISNULL(COUNT(*), 0)
                 FROM   #FinalResultSet
               ) < 1
                BEGIN
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows ,
                            '' AS ArrayList
                END
            ELSE
                BEGIN
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(TotalCount, 0) AS NumberOfRows ,
                            '' AS ArrayList
                    FROM    #FinalResultSet
                END

            SELECT  ClientId ,
                    ClientName ,
                    ClientBalance ,
                    LastStatement ,
                    LastCltPaymentAndDate ,
                    ThirdPartyBalance ,
                    PrimaryPlan ,
                    NeedInformation ,
                    IsSelected ,
                    ClientCoveragePlanId ,
                    PaymentId ,
                    FinancialActivityId
            FROM    #FinalResultSet
            ORDER BY RowNumber
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientAccounts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
        END CATCH
    END
