/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccountDetail]    Script Date: 01/08/2016 09:54:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_PMClientAccountDetail]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ClientID INT ,
    @PaidUnPaidService INT ,
    @Payers INT ,
    @ClinicianId INT ,
    @ProgramId INT ,
    @Services INT ,
    @BalanceDays INT ,
    @Dates INT ,
    @FromDate DATETIME = NULL ,
    @ToDate DATETIME = NULL ,
    @OtherFilter INT
AS /****************************************************************************** 
** File: ssp_PMClientAccountDetail.sql
** Name: ssp_PMClientAccountDetail
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Client Accoutns tab
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 14/06/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 14/06/2011		Mary Suma			Query to return Client Account Details
-------- 			-------- 			--------------- 
-- 22/09/2011		Girish  			Split Parent data from child data
-- 23 Sep 2011      Girish              Added HasChild column to the final parent select
-- 28 Sep 2011      Girish              Changed caching tables PMClientAccountDetail(Child) to ListPagePMClientAccountDetails(Child)	
-- 28 Sep 2011      Girish              Added ClientCoveragePlanId to the child resultset
-- 29 Sep 2011      Girish              Added Tempid to dynamic sort 
-- 12 oct 2011      Girish              Changed tablenames and columnnames (adj to adjustment and baldaysold to balancedaysold)									
-- 23 oct 2011      MSuma               Tuning 
-- 23 Nov 2011      MSuma               Modified DateFOrmat
-- 28 Mar 2012      PSelvan		        Performance Tuning.	 
-- 10 Apr 2012      PSelvan				Removed where condition in the table #ResultSetChild to get the child table result.
-- 22 Apr 2012      PSelvan				Export implemeted.
-- 24 Apr 2012      PSelvan				Column TableName removed from the export return datatable.
-- 25 May 2012      PSelvan             Changed varchar to DateTime for DOS column of #ResultSetParent
-- 08 Apr 2013		DVeale				Added criteria to exclude deleted service records
-- 30 Dec 2013      Bernardin           Selected ServiceId and DOS and Order By DOS for Venture Region 3.5 Implementation Task # 453
--	JAN-17-2013		dharvey				Added RecordDeleted check to reflect accurate results
-- 08 Jan 2016		njain				Removed "=" from this logic for a.DateOfService <= dateadd(dd, 1, @ToDate). The "=" pulls in services at 12AM from next date which is incorrect. 
										AND ( @ToDate IS NULL
                                              OR a.DateOfService < DATEADD(dd, 1, @ToDate)
                                            )   
--02/10/2017      jcarlson       Keystone Customizations 69 - increased ProcedureName length to 500 to handle procedure code display as increasing to 75 											      
*******************************************************************************/


    BEGIN                                                              
        BEGIN TRY
		
	
	
            CREATE TABLE #Charges
                (
                  ServiceId INT NULL ,
                  ChargeId INT NULL ,
                  Priority INT NULL ,
                  DateOfService DATETIME NULL ,
                  ProcedureCodeId INT NULL ,
                  Unit INT NULL ,
                  UnitType INT NULL ,
                  CoveragePlanId INT NULL ,
                  InsuredId VARCHAR(25) NULL ,
                  Charges MONEY NULL ,
                  Unbilled MONEY NULL ,
                  Billed MONEY NULL ,
                  Payments MONEY NULL ,
                  Adjustments MONEY NULL ,
                  Balance MONEY NULL ,
                  BalanceOldDays INT NULL ,
                  ClientCoveragePlanId INT NULL
                )              
              
            CREATE TABLE #Services
                (
                  ServiceId INT NULL ,
                  DateOfService DATETIME NULL ,
                  ProcedureCodeId INT NULL ,
                  Unit INT NULL ,
                  UnitType INT NULL ,
                  Charges MONEY NULL ,
                  Unbilled MONEY NULL ,
                  Billed MONEY NULL ,
                  Payments MONEY NULL ,
                  Adjustments MONEY NULL ,
                  Balance MONEY NULL ,
                  BalanceOldDays INT NULL
                )    
	
	
            CREATE TABLE #ResultSet
                (
                  TempID INT IDENTITY(1, 1) ,
                  RowNumber INT ,
                  PageNumber INT ,
                  Id INT ,
                  ParentId INT ,
                  ServiceId INT ,
                  Priority INT ,
                  DOS VARCHAR(101) ,
                  DateOfService DATETIME ,
                  ProcedureName VARCHAR(500) ,
                  Charges MONEY ,
                  Unbilled MONEY ,
                  Billed MONEY ,
                  Payments MONEY ,
                  Adjustment MONEY ,
                  Balance MONEY ,
                  BalanceDaysOld INT ,
                  ClientCoveragePlanId INT
                )  
	
            CREATE TABLE #ResultSetParent
                (
                  TempID INT ,
                  RowNumber INT ,
                  PageNumber INT ,
                  Id INT ,
                  ParentId INT ,
                  ServiceId INT ,
                  Priority INT ,
                  DOS DATETIME ,
                  DateOfService DATETIME ,
                  ProcedureName VARCHAR(500) ,
                  Charges MONEY ,
                  Unbilled MONEY ,
                  Billed MONEY ,
                  Payments MONEY ,
                  Adjustment MONEY ,
                  Balance MONEY ,
                  BalanceDaysOld INT ,
                  ClientCoveragePlanId INT
                )  
            CREATE TABLE #ResultSetChild
                (
                  TempID INT ,
                  RowNumber INT ,
                  PageNumber INT ,
                  Id INT ,
                  ParentId INT ,
                  ServiceId INT ,
                  Priority INT ,
                  DOS VARCHAR(101) ,
                  DateOfService DATETIME ,
                  ProcedureName VARCHAR(500) ,
                  Charges MONEY ,
                  Unbilled MONEY ,
                  Billed MONEY ,
                  Payments MONEY ,
                  Adjustment MONEY ,
                  Balance MONEY ,
                  BalanceDaysOld INT ,
                  ClientCoveragePlanId INT
                )  
	
            IF @FromDate = '1/1/1900'
                SET @FromDate = NULL              
            IF @ToDate = '1/1/1900'
                SET @ToDate = NULL              
              
            IF @Dates <> 1
                BEGIN              
                    IF @Dates <> 5
                        SET @FromDate = DATEADD(dd, CASE @Dates
                                                      WHEN 2 THEN -30
                                                      WHEN 3 THEN -60
                                                      WHEN 4 THEN -90
                                                    END, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))              
                    ELSE
                        SET @FromDate = DATEADD(dd, -90, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))              
		              
                    IF @Dates = 5
                        SET @ToDate = DATEADD(dd, -90, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))              
	 --ELSE              
	 -- SET @ToDate = NULL              
                END  
            DECLARE @CustomFilters TABLE ( ServiceId INT )                                                  
            DECLARE @ApplyFilterClicked CHAR(1)
            DECLARE @CustomFiltersApplied CHAR(1)
		
            SET @SortExpression = RTRIM(LTRIM(@SortExpression))
            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'DOS DESC'
		
	
		
		-- 
		-- New retrieve - the request came by clicking on the Apply Filter button                   
		--
            SET @ApplyFilterClicked = 'Y' 
            SET @CustomFiltersApplied = 'N'                                                 
		--SET @PageNumber = 1
		
            IF @OtherFilter > 10000
                BEGIN
                    SET @CustomFiltersApplied = 'Y'
			
                    INSERT  INTO @CustomFilters
                            ( ServiceId
                            )
                            EXEC scsp_PMClientAccountDetail @ClientID = @ClientID, @PaidUnPaidService = @PaidUnPaidService, @Payers = @Payers, @ClinicianId = @ClinicianId, @ProgramId = @ProgramId, @Services = @Services, @BalanceDays = @BalanceDays, @Dates = @Dates, @FromDate = @FromDate, @ToDate = @ToDate, @OtherFilter = @OtherFilter	
                END	
		
		
	--
	--  Find only billable procedure codes for the corresponding coverage plan
	--
            BEGIN
                SET FORCEPLAN ON  
	
	---Added by MSuma for Tuning
				
				
				
				
				
                IF @CustomFiltersApplied = 'N'
                    BEGIN
                        INSERT  INTO @CustomFilters
                                ( ServiceId
                                )
                                SELECT DISTINCT
                                        a.ServiceId
                                FROM    Services a
                                        JOIN Charges b ON ( a.ServiceId = b.ServiceId )
                                        LEFT JOIN ARLedger c ON ( b.ChargeId = c.ChargeId )
                                        LEFT JOIN OpenCharges d ON ( b.ChargeId = d.ChargeId )
                                        LEFT JOIN ClientCoveragePlans e ON ( b.ClientCoveragePlanId = e.ClientCoveragePlanId )
                                WHERE   a.ClientId = @ClientID
                                        AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  -- 4/8/13 DV -- removes deleted records appearing in client accounts screen (Harbor Support task 40)
                                        AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
                                        AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                                        AND ( ( @Services = 2
                                                AND a.Status = 76
                                              )
                                              OR ( @Services <> 2
                                                   AND a.Status <> 76
                                                 )
                                            )
                                        AND ( @PaidUnPaidService = 2
                                              OR EXISTS ( SELECT    *
                                                          FROM      Charges c1
                                                                    JOIN OpenCharges d1 ON c1.ChargeId = d1.ChargeId
                                                          WHERE     a.ServiceId = c1.ServiceId )
                                            )
                                        AND ( @Payers = -2
                                              OR ( @Payers = -3
                                                   AND ( b.Priority > 0
                                                         OR ( b.Priority = 0
                                                              AND EXISTS ( SELECT   *
                                                                           FROM     Charges y
                                                                           WHERE    b.ServiceId = y.ServiceId
                                                                                    AND b.ChargeId <> y.ChargeId )
                                                            )
                                                       )
                                                 )
                                              OR ( @Payers = -1
                                                   AND EXISTS ( SELECT  *
                                                                FROM    Charges y
                                                                WHERE   a.ServiceId = y.ServiceId
                                                                        AND y.Priority = 0 )
                                                 )
                                              OR ( @Payers > 0
                                                   AND EXISTS ( SELECT  *
                                                                FROM    Charges z
                                                                WHERE   a.ServiceId = z.ServiceId
                                                                        AND z.ClientCoveragePlanId = @Payers )
                                                 )
                                            )
                                        AND ( @ClinicianId = -1
                                              OR a.ClinicianId = @ClinicianId
                                            )
                                        AND ( @ProgramId = -1
                                              OR a.ProgramId = @ProgramId
                                            )
                                        AND ( @BalanceDays = 1
                                              OR ( @BalanceDays = 2
                                                   AND a.DateOfService < DATEADD(dd, -90, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
                                                 )
                                              OR ( @BalanceDays = 3
                                                   AND a.DateOfService < DATEADD(dd, -180, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
                                                 )
                                              OR ( @BalanceDays = 4
                                                   AND a.DateOfService < DATEADD(dd, -360, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
                                                 )
                                            )
                                        AND ( @FromDate IS NULL
                                              OR a.DateOfService >= @FromDate
                                            )
                                        AND ( @ToDate IS NULL
                                              OR a.DateOfService < DATEADD(dd, 1, @ToDate)
                                            )              
		              

                    END
	---End Added by MSuma
	
	
                INSERT  INTO #Charges
                        ( ServiceId ,
                          ChargeId ,
                          Priority ,
                          DateOfService ,
                          ProcedureCodeId ,
                          Unit ,
                          UnitType ,
                          CoveragePlanId ,
                          InsuredId ,
                          Charges ,
                          Unbilled ,
                          Billed ,
                          Payments ,
                          Adjustments ,
                          Balance ,
                          BalanceOldDays ,
                          ClientCoveragePlanId
	                    )
                        SELECT  a.ServiceId ,
                                b.ChargeId ,
                                b.Priority , 
		--a.DateOfService, 
                                CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 18, 3)) AS DateOfService ,
                                a.ProcedureCodeId ,
                                a.Unit ,
                                a.UnitType ,
                                e.CoveragePlanId ,
                                e.InsuredId ,
                                SUM(CASE WHEN c.LedgerType IN ( 4201, 4204 ) THEN c.Amount
                                         ELSE 0
                                    END) ,
                                SUM(CASE WHEN b.LastBilledDate IS NULL THEN c.Amount
                                         ELSE 0
                                    END) ,
                                SUM(CASE WHEN b.LastBilledDate IS NOT NULL THEN c.Amount
                                         ELSE 0
                                    END) ,   --Added by kuldeep ref task 203 on 21-dec-2006             
                                SUM(CASE WHEN c.LedgerType = 4202 THEN -c.Amount
                                         ELSE 0
                                    END) ,
                                SUM(CASE WHEN c.LedgerType = 4203 THEN -c.Amount
                                         ELSE 0
                                    END) ,
                                SUM(c.Amount) ,
                                DATEDIFF(dd, a.DateOfService, GETDATE()) ,
                                e.ClientCoveragePlanId
                        FROM    @CustomFilters a1
                                JOIN Services a ON ( a.ServiceId = a1.ServiceId )
                                JOIN Charges b ON ( a.ServiceId = b.ServiceId
                                                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                                  )
                                LEFT JOIN ARLedger c ON ( b.ChargeId = c.ChargeId
                                                          AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                                        )
                                LEFT JOIN OpenCharges d ON ( b.ChargeId = d.ChargeId
                                                             AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                                           )
                                LEFT JOIN ClientCoveragePlans e ON ( b.ClientCoveragePlanId = e.ClientCoveragePlanId )
                        GROUP BY a.ServiceId ,
                                b.ChargeId ,
                                b.Priority ,
                                a.DateOfService ,
                                a.ProcedureCodeId ,
                                a.Unit ,
                                a.UnitType ,
                                e.CoveragePlanId ,
                                e.InsuredId ,
                                DATEDIFF(dd, a.DateOfService, GETDATE()) ,
                                e.ClientCoveragePlanId          
         
                SET FORCEPLAN OFF     
                INSERT  INTO #Services
                        ( ServiceId ,
                          DateOfService ,
                          ProcedureCodeId ,
                          Unit ,
                          UnitType ,
                          Charges ,
                          Unbilled ,
                          Billed ,
                          Payments ,
                          Adjustments ,
                          Balance ,
                          BalanceOldDays
		                )
                        SELECT  ServiceId ,
                                DateOfService ,
                                ProcedureCodeId ,
                                Unit ,
                                UnitType ,
                                SUM(Charges) ,
                                SUM(Unbilled) ,
                                SUM(Billed) ,
                                SUM(Payments) ,
                                SUM(Adjustments) ,
                                SUM(Balance) ,
                                BalanceOldDays
                        FROM    #Charges
                        GROUP BY ServiceId ,
                                DateOfService ,
                                ProcedureCodeId ,
                                Unit ,
                                UnitType ,
                                BalanceOldDays   


                INSERT  INTO #ResultSet
                        ( Id ,
                          ParentId ,
                          ServiceId ,
                          Priority ,
                          DOS ,
                          DateOfService ,
                          ProcedureName ,
                          Charges ,
                          Unbilled ,
                          Billed ,
                          Payments ,
                          Adjustment ,
                          Balance ,
                          BalanceDaysOld ,
                          ClientCoveragePlanId

		                )
                        SELECT  0 ,
                                a.ServiceId ,
                                a.ServiceId ,
                                -1 ,
                                CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8)) ,              
			--CONVERT(VARCHAR,a.DateOfService,101),        
                                CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8)) ,
                                b.DisplayAs + ' ' + CONVERT(VARCHAR(20), a.Unit, 6) + ' ' + c.CodeName ,
                                CONVERT(VARCHAR(20), a.Charges) ,
                                CONVERT(VARCHAR(20), a.Unbilled) ,
                                CONVERT(VARCHAR(20), a.Billed) ,
                                CONVERT(VARCHAR(20), a.Payments) ,
                                CONVERT(VARCHAR(20), a.Adjustments) ,
                                CONVERT(VARCHAR(20), a.Balance) ,
                                CONVERT(VARCHAR(20), a.BalanceOldDays) ,
                                NULL
                        FROM    #Services a
                                JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )
                                JOIN GlobalCodes c ON ( a.UnitType = c.GlobalCodeId )
                        UNION
                        SELECT  0 ,
                                a.ServiceId ,
                                a.ServiceId ,
                                CASE WHEN a.Priority = 0 THEN 20000
                                     ELSE a.Priority
                                END ,
                                CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8)) ,
                                CONVERT(VARCHAR, a.DateOfService, 101) ,
                                ISNULL(RTRIM(b.DisplayAs) + ' ' + ISNULL(a.InsuredId, ''), 'Client') ,
                                CONVERT(VARCHAR(20), a.Charges) ,
                                CONVERT(VARCHAR(20), a.Unbilled) ,
                                CONVERT(VARCHAR(20), a.Billed) ,
                                CONVERT(VARCHAR(20), a.Payments) ,
                                CONVERT(VARCHAR(20), a.Adjustments) ,
                                CONVERT(VARCHAR(20), a.Balance) ,
                                CONVERT(VARCHAR(20), a.BalanceOldDays) ,
                                a.ClientCoveragePlanId
                        FROM    #Charges a
                                LEFT JOIN CoveragePlans b ON ( a.CoveragePlanId = b.CoveragePlanId )
                        ORDER BY 3 ,
                                4 ASC      
		
                UPDATE  a
                SET     Id = b.TempID ,
                        ServiceId = NULL ,
                        DOS = NULL
                FROM    #ResultSet a
                        JOIN #ResultSet b ON ( a.ServiceId = b.ServiceId )
                WHERE   b.Priority = -1
                        AND a.Priority <> -1   
			
                INSERT  INTO #ResultSetParent
                        SELECT  *
                        FROM    #ResultSet
                        WHERE   Id = 0
			
                INSERT  INTO #ResultSetChild
                        SELECT  *
                        FROM    #ResultSet
                        WHERE   Id != 0	
			
			
							
                UPDATE  d
                SET     RowNumber = rn.RowNumber ,
                        PageNumber = ( rn.RowNumber / @PageSize ) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0
                                                                         ELSE 1
                                                                    END
                FROM    #ResultSetParent d
                        JOIN ( SELECT   TempID ,
                                        ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'ServiceId' THEN ServiceId
                                                                     END, CASE WHEN @SortExpression = 'ServiceId DESC' THEN ServiceId
                                                                          END DESC, CASE WHEN @SortExpression = 'DOS' THEN DOS
                                                                                    END, CASE WHEN @SortExpression = 'DOS DESC' THEN DOS
                                                                                         END DESC, CASE WHEN @SortExpression = 'ProcedureName' THEN ProcedureName
                                                                                                   END, CASE WHEN @SortExpression = 'ProcedureName DESC' THEN ProcedureName
                                                                                                        END DESC, CASE WHEN @SortExpression = 'Charges' THEN Charges
                                                                                                                  END, CASE WHEN @SortExpression = 'Charges DESC' THEN Charges
                                                                                                                       END DESC, CASE WHEN @SortExpression = 'UnBilled' THEN UnBilled
                                                                                                                                 END, CASE WHEN @SortExpression = 'UnBilled DESC' THEN UnBilled
                                                                                                                                      END DESC, CASE WHEN @SortExpression = 'Billed' THEN Billed
                                                                                                                                                END, CASE WHEN @SortExpression = 'Billed DESC' THEN Billed
                                                                                                                                                     END DESC, CASE WHEN @SortExpression = 'Payments' THEN Payments
                                                                                                                                                               END, CASE WHEN @SortExpression = 'Payments DESC' THEN Payments
                                                                                                                                                                    END DESC, CASE WHEN @SortExpression = 'Adj' THEN Adjustment
                                                                                                                                                                              END, CASE WHEN @SortExpression = 'Adj DESC' THEN Adjustment
                                                                                                                                                                                   END DESC, CASE WHEN @SortExpression = 'Balance' THEN Balance
                                                                                                                                                                                             END, CASE WHEN @SortExpression = 'Balance DESC' THEN Balance
                                                                                                                                                                                                  END DESC, CASE WHEN @SortExpression = 'BalDaysOld' THEN BalanceDaysOld
                                                                                                                                                                                                            END, CASE WHEN @SortExpression = 'BalDaysOld DESC' THEN BalanceDaysOld
                                                                                                                                                                                                                 END DESC, TempId ) AS RowNumber
                               FROM     #ResultSetParent
                             ) rn ON rn.TempID = d.TempID 
				
				
                DECLARE @counts INT
                SET @counts = ( SELECT  COUNT(*) AS totalrows
                                FROM    #ResultSetParent
                              )
				
				
				
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( 0 )
                                  ELSE ( @PageSize )
                             END )
                        TempID ,
                        Id ,
                        ServiceId ,
                        CAST(DOS AS DATETIME) AS DOS ,
                        CONVERT(VARCHAR(19), DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 18, 2)) AS DateOfService ,
                        ProcedureName AS 'Procedure' ,
                        RowNumber ,
                        PageNumber ,
                        ProcedureName ,
                        Adjustment ,
                        BalanceDaysOld ,
                        CASE WHEN Charges IS NULL THEN '0'
                             ELSE Charges
                        END AS Charges ,
                        CASE WHEN Unbilled IS NULL THEN '0'
                             ELSE Unbilled
                        END AS Unbilled ,
                        CASE WHEN Billed IS NULL THEN '0'
                             ELSE Billed
                        END AS Billed ,
                        CASE WHEN Payments IS NULL THEN '0'
                             ELSE Payments
                        END AS Payments ,
                        CASE WHEN Adjustment IS NULL THEN '0'
                             ELSE Adjustment
                        END AS Adj ,
                        CASE WHEN Balance IS NULL THEN '0'
                             ELSE Balance
                        END AS Balance ,
                        BalanceDaysOld AS 'Bal Days Old' ,
                        ( SELECT    CASE COUNT(*)
                                      WHEN 0 THEN 'none'
                                      ELSE 'block'
                                    END
                          FROM      #ResultSetChild A
                          WHERE     A.Id = #ResultSetParent.TempID
                        ) AS HasChild
                INTO    #ResultSetParentFinal
                FROM    #ResultSetParent
                ORDER BY RowNumber
				
				
				
                IF ( SELECT ISNULL(COUNT(*), 0)
                     FROM   #ResultSetParentFinal
                   ) < 1
                    BEGIN
                        SELECT  0 AS PageNumber ,
                                0 AS NumberOfPages ,
                                0 NumberOfRows
                    END
                ELSE
                    BEGIN                              
                        SELECT TOP 1
                                @PageNumber AS PageNumber ,
                                CASE ( @counts % @PageSize )
                                  WHEN 0 THEN ISNULL(( @counts / @PageSize ), 0)
                                  ELSE ISNULL(( @counts / @PageSize ), 0) + 1
                                END AS NumberOfPages ,
                                ISNULL(@counts, 0) AS NumberOfRows
                        FROM    #ResultSetParentFinal  
                    END       
				
    
                IF ( @PageNumber = -1 )
                    BEGIN 
   -- SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (ISNULL(@counts,0)) ELSE (@PageSize) END) 
                        SELECT  RANK() OVER ( ORDER BY A.TempID, A.Id ) AS GroupNumber ,
                                A.ServiceId AS ServiceId ,
                                A.DOS AS DOS ,
        --B.DateOfService,          
                                A.ProcedureName AS [Procedure] ,
                                A.Charges AS Charges ,
                                A.Unbilled AS Unbilled ,
                                A.Billed AS Billed ,
                                A.Payments AS Payments ,
                                A.Adjustment AS Adjustment ,
                                A.Balance AS Balance ,
                                A.BalanceDaysOld AS BalanceDaysOld
                        FROM    #ResultSetParent A
                        UNION
                        SELECT  RANK() OVER ( ORDER BY A.TempID, A.Id ) AS GroupNumber ,
		-- Select ServiceId and DOS for Venture Region 3.5 Implementation Task # 453
		--NULL As ServiceId,
		--NULL AS DOS,
                                B.ServiceId AS Serviceid ,
                                B.DOS AS DOS ,
        --B.DateOfService,          
                                A.ProcedureName AS [Procedure] ,
                                A.Charges AS Charges ,
                                A.Unbilled AS Unbilled ,
                                A.Billed AS Billed ,
                                A.Payments AS Payments ,
                                A.Adjustment AS Adjustment ,
                                A.Balance AS Balance ,
                                A.BalanceDaysOld AS BalanceDaysOld
                        FROM    #ResultSetChild A
                                JOIN #ResultSetParent B ON A.Id = B.TempID 
		-- Order By DOS for Venture Region 3.5 Implementation Task # 453
                        ORDER BY DOS DESC;
				 
                    END 
    
                ELSE
                    BEGIN
                        SELECT  TempID AS Id ,
                                Id AS ParentId ,
                                ServiceId ,
                                CAST(DOS AS DATETIME) AS DOS ,
                                DateOfService AS DateOfService ,                 
			 --convert(varchar(19), DateOfService, 101)+ ' '+  
				--ltrim(substring(convert(varchar(19), DateOfService, 100), 12, 6) )+ ' '+ 
				--ltrim(substring(convert(varchar(19), DateOfService, 100), 18, 2) ) AS DateOfService,              
                                ProcedureName AS 'Procedure' ,
                                CASE WHEN Charges IS NULL THEN '0'
                                     ELSE Charges
                                END AS Charges ,
                                CASE WHEN Unbilled IS NULL THEN '0'
                                     ELSE Unbilled
                                END AS Unbilled ,
                                CASE WHEN Billed IS NULL THEN '0'
                                     ELSE Billed
                                END AS Billed ,
                                CASE WHEN Payments IS NULL THEN '0'
                                     ELSE Payments
                                END AS Payments ,
                                CASE WHEN Adjustment IS NULL THEN '0'
                                     ELSE Adjustment
                                END AS Adj ,
                                CASE WHEN Balance IS NULL THEN '0'
                                     ELSE Balance
                                END AS Balance ,
                                BalanceDaysOld AS 'Bal Days Old' ,
                                ( SELECT    CASE COUNT(*)
                                              WHEN 0 THEN 'none'
                                              ELSE 'block'
                                            END
                                  FROM      #ResultSetChild A
                                  WHERE     A.Id = #ResultSetParentFinal.TempID
                                ) AS HasChild
                        FROM    #ResultSetParentFinal
                        ORDER BY RowNumber
		
	
                        SELECT  A.TempID AS Id ,
                                A.Id AS ParentId ,
                                B.ServiceId ,
                                CAST(A.DOS AS DATETIME) AS DOS ,
                                CONVERT(VARCHAR(19), A.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), A.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), A.DateOfService, 100), 18, 2)) AS DateOfService ,
                                A.ProcedureName AS 'Procedure' ,
                                CASE WHEN A.Charges IS NULL THEN '0'
                                     ELSE A.Charges
                                END AS Charges ,
                                CASE WHEN A.Unbilled IS NULL THEN '0'
                                     ELSE A.Unbilled
                                END AS Unbilled ,
                                CASE WHEN A.Billed IS NULL THEN '0'
                                     ELSE A.Billed
                                END AS Billed ,
                                CASE WHEN A.Payments IS NULL THEN '0'
                                     ELSE A.Payments
                                END AS Payments ,
                                CASE WHEN A.Adjustment IS NULL THEN '0'
                                     ELSE A.Adjustment
                                END AS Adj ,
                                CASE WHEN A.Balance IS NULL THEN '0'
                                     ELSE A.Balance
                                END AS Balance ,
                                A.BalanceDaysOld AS 'Bal Days Old' ,
                                A.ClientCoveragePlanId
                        FROM    #ResultSetChild A
                                JOIN #ResultSetParent B ON A.Id = B.TempID    
                    END                              
  
            END
        END TRY
	
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientAccountDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
        END CATCH
    END

GO
