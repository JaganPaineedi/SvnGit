IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_PMClaimsProcessingData')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_PMClaimsProcessingData;
    END;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMClaimsProcessingData]
	/********************************************************************************                                                        
-- Stored Procedure: ssp_PMClaimsProcessingData      
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: Procedure to return data for the Claims Processing popup list page.      
--      
-- Author:  Girish Sanaba      
-- Date:    08.29.2011      
--      
-- *****History****      
-- 09.07.2011 Girish		Changed left join listpagepmchargesandclaims to left join #chargeerrors in final select    
-- 09.27.2011 Girish		Changed 0 to -1 for dummy dropdown value for Get list of Batches  
-- 10.11.2011 Girish		Uncommented recorddeleted check on claimbatchcharges as it is necessary  
-- 10.20.2011 Girish		Added condition to accomodate hyperlink clicking of processid and batchid  
-- 06.12.11   MSuma			Updated ErrorMessages after processing  
-- 01.06.2012 Shruthi.S		Added check for hyperlink if batchid hyperlink clicked then update 'all batches' processid from claimbatches table  
-- 11.01.2012 MSuma			Fix to retrieve correct batchid and processid  
-- 25.03.2012 Shruthi.S		With rowselection and  isselected changes included
-- 16/04/2012 Shruthi.S		Added table valued type for uniqueid
-- 28/06/2012 MSuma			Removed TempTable and Constraint
-- 29/06/2012 Msuma			Change the status as Selected in same batch with has few Processed Charges
-- 01/07/2012 Msuma			Added total Charges
-- 03/12/2014 NJain			Added the not null condition when getting ClaimFormatId from CoveragePlanClaimFormats
-- 13/03/2014 Md Hussain	Added check for Electronic Claim if Generate Electronic Claim clicked then update 'File Name' of claimbatches table 
--							for task #157 Philhaven Development  
-- 20/08/2014 Bernrdin		BatchStatus is modified before sorting and commentted the update statement. Core Bugs # 435 
-- 10/15/2015 NJain			Added Order by in the Advanced Claim Formats selection
-- 11/24/2015 Varun			Added ClaimLineItemId (Engineering Improvements #220.1)
-- 12/02/2015 Wasif Butt	Fixed results based on batchId, processId, updated page number, row and charge calculation. 
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName
-- 01/21/2015 NJain			Added @PageSize = 200, sometimes the application sends 100 which is incorrect
							Added logic to set @PageNumber to 1 when its 0
							On the last set of select statements, added logic to only return records for the page using:
								AND a.RowNumber > ( ( @PageNumber - 1 ) * @PageSize )
                                AND a.RowNumber <= ( @PageNumber * @PageSize )
							Commented out "WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )" when inserting into #FinalResultSet. Everything should be								inserted in #FinalResulSet to return correct totals
-- 07/18/2016 NJain			Updated to Set ClaimProcessId = -1 when ClaimBatchId is not null and <> -1		
-- -- 10/19/2016 NJain			Added check to also look at procedurecodeid when looking at the advanced claim formats	
									Also removed "use Valley QA from the ssp"
									
--11/21/2016  Chita Ranjan  Changed the length of ClaimBatch column in #ClaimBatches temptable from Varchar(100) to Varchar(200) and Added RTRIM to temporary variable BatchName .Core Bugs #74     									
-- 02/09/2017  NJain		Updated to get ClaimLineItemId when inserting into the CTE PaymentResultSet, so that this field can be sorted by. Also commented out the Update statement							that gets this data later. MFS SGL #70
-- 03/17/2017  NJain		If a billed batch is opened, the Charge status should always say Billed and no Warnings should display		
							Added the following condition when inserting into #ChargeErrors
							Philhaven Support #167
							
							JOIN dbo.ClaimBatches c ON c.ClaimBatchId = b.ClaimBatchId
							WHERE   c.BilledDate IS NULL
-- 05/05/2017	MJensen		Add hook to scsp  A Renewed Mind - Support Task #598							
-- 08/07/2018   Hemant      What: Added @ClaimBatchId check to pull the proper data for the selected batch.
                            Why:  If you select a batch that was not the first batch created by the process, 
                                  on selecting the Create Claim File button it switches to the first batch created. 
                            Project: Philhaven-Support #378.3 																																																																																																																																																																																																			  
*********************************************************************************/
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ClaimProcessId INT ,
    @ClaimBatchId INT ,
    @Electronic CHAR ,
    @RowSelectionList VARCHAR(MAX) ,
    @UserCode VARCHAR(50) ,
    @HyperFlag CHAR(1) ,
	--@UniqueId Varchar(Max) 
    @UniqueIdTable UniqueIdTableType READONLY
AS
    BEGIN
        BEGIN TRY
            DECLARE @ApplyFilterClicked CHAR(1)

            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'BatchName'
                
                
            --IF @ClaimBatchId IS NOT NULL
            --    AND @ClaimBatchId <> -1
            --    BEGIN
            --        SELECT  @ClaimProcessId = -1
            --    END
                
                
		--     
		-- New retrieve - the request came by clicking on the Apply Filter button                       
		--    
		
            SELECT  @PageSize = 200
            SELECT  @PageNumber = CASE WHEN @PageNumber = 0 THEN 1
                                       ELSE @PageNumber
                                  END
		
		
            SET @ApplyFilterClicked = 'Y'

		--set @PageNumber = 1     
            CREATE TABLE #ClaimCharges
                (
                  ChargeId INT NOT NULL ,
                  CoveragePlanId INT NULL ,
                  PayerId INT NULL ,
                  ClaimFormatId INT NULL
                )

            CREATE TABLE #ClaimBatches
                (
                  ClaimProcessId INT NULL ,
                  ClaimBatchId INT NULL ,
                  BatchName VARCHAR(200) NULL ,  --Added by Chita Ranjan 11/21/2016
                  ClaimFormatId INT NULL ,
                  Electronic CHAR(1) NULL ,
                  StoredProcedure VARCHAR(100) NULL ,
                  SystemReportId INT NULL ,
                  STATUS VARCHAR(100) NULL ,
                  StatusId INT NULL ,
                  ProcessLater CHAR(1) NULL
                )

		--- Here Claim batches and ClaimBatchCharges are created    
            IF @HyperFlag = 'N'
                BEGIN
                    DECLARE @CurrentDate DATETIME

                    SELECT  @CurrentDate = GETDATE()

			--if (@ClaimBatchId = -1 or @ClaimProcessId = 0)  
			--begin  
			--insert into #ClaimCharges    
			--(ChargeId, CoveragePlanId, PayerId, ClaimFormatId)    
			--select C.ChargeId, CCP.CoveragePlanId,    
			--case when CP.CombineClaimsAtPayerLevel = 'Y' then CP.PayerId else null end,    
			--case when @Electronic = 'Y' then CP.ElectronicClaimFormatId else CP.PaperClaimFormatId end    
			--from ListPagePMChargesAndClaims RP    
			--JOIN Charges C ON (RP.ChargeId = C.ChargeId)    
			--JOIN ClientCoveragePlans CCP ON (C.ClientCoveragePlanId = CCP.ClientCoveragePlanId)    
			--JOIN CoveragePlans CP ON (CCP.CoveragePlanId = CP.CoveragePlanId)    
			--where RP.SessionId = @SessionId    
			--and RP.InstanceId = @InstanceId    
			--AND ((RP.IsSelected = 1)  OR (RP.ClaimBatchId =  @ClaimBatchId) OR (RP.ClaimProcessId =  @ClaimProcessId))  
			--Commented by shruthi   
			--CREATE TABLE #RowSelection (ChargeId INT, IsSelected BIT)  
			--INSERT INTO #RowSelection( ChargeId, IsSelected )   
			--SELECT ids,IsSelected   
			--FROM dbo.SplitJSONString(@UniqueId,',')  
                    CREATE TABLE #RowSelection ( ChargeId INT )

                    INSERT  INTO #RowSelection
                            SELECT  ChargeId
                            FROM    @UniqueIdTable

                    INSERT  INTO #ClaimCharges
                            ( ChargeId ,
                              CoveragePlanId ,
                              PayerId ,
                              ClaimFormatId
				            )
                            SELECT  C.ChargeId ,
                                    CCP.CoveragePlanId ,
                                    CASE WHEN CP.CombineClaimsAtPayerLevel = 'Y' THEN CP.PayerId
                                         ELSE NULL
                                    END ,
                                    CASE WHEN @Electronic = 'Y' THEN CP.ElectronicClaimFormatId
                                         ELSE CP.PaperClaimFormatId
                                    END
                            FROM    Charges C
                                    JOIN ClientCoveragePlans CCP ON ( C.ClientCoveragePlanId = CCP.ClientCoveragePlanId )
                                    JOIN CoveragePlans CP ON ( CCP.CoveragePlanId = CP.CoveragePlanId )
                                    JOIN #RowSelection a ON c.ChargeId IN ( a.ChargeId )
                            WHERE   ( c.ChargeId IN ( a.ChargeId ) )

			--update ListPagePMChargesAndClaims    
			--set IsSelected =0    
			--where SessionId = @SessionId    
			--and InstanceId =@InstanceId      
                    UPDATE  #ClaimCharges
                    SET     ClaimFormatId = ISNULL(( SELECT TOP 1
                                                            CASE WHEN @Electronic = 'Y' THEN f.ElectronicClaimFormatId
                                                                 ELSE f.PaperClaimFormatId
                                                            END
                                                     FROM   #ClaimCharges a
                                                            JOIN Charges b ON ( a.ChargeId = b.ChargeId )
                                                            JOIN Services c ON ( b.ServiceId = c.ServiceId )
                                                            JOIN ClientCoveragePlans d ON ( b.ClientCoveragePlanId = d.ClientCoveragePlanId )
                                                            JOIN CoveragePlans e ON ( d.CoveragePlanId = e.CoveragePlanId )
                                                            JOIN Staff h ON ( c.ClinicianId = h.StaffId )
                                                            JOIN CoveragePlanClaimFormats f ON ( e.CoveragePlanId = f.CoveragePlanId
                                                                                                 AND f.Active = 'Y'
                                                                                                 AND ISNULL(f.RecordDeleted, 'N') = 'N'
                                                                                                 AND ( f.ProgramId IS NULL
                                                                                                       OR c.ProgramId = f.ProgramId
                                                                                                     )
                                                                                                 AND ( f.StaffId IS NULL
                                                                                                       OR c.ClinicianId = f.StaffId
                                                                                                     )
                                                                                                 AND ( f.Degree IS NULL
                                                                                                       OR h.Degree = f.Degree
                                                                                                     )
                                                                                                 AND ( f.ProcedureCodeId IS NULL
                                                                                                       OR f.ProcedureCodeId = c.ProcedureCodeId
                                                                                                     )
                                                                                                 AND ( ( @Electronic = 'Y'
                                                                                                         AND f.ElectronicClaimFormatId IS NOT NULL
                                                                                                       )
                                                                                                       OR ( @Electronic <> 'Y'
                                                                                                            AND f.PaperClaimFormatId IS NOT NULL
                                                                                                          )
                                                                                                     )
                                                                                               )
                                                     WHERE  a.ChargeId = #ClaimCharges.ChargeId
                                                     ORDER BY ( CASE WHEN f.ProgramId = c.ProgramId THEN 1
                                                                     ELSE 0
                                                                END + CASE WHEN f.StaffId = c.ClinicianId THEN 1
                                                                           ELSE 0
                                                                      END + CASE WHEN f.Degree = h.Degree THEN 1
                                                                                 ELSE 0
                                                                            END ) DESC
                                                   ), ClaimFormatId)

                    INSERT  INTO ClaimProcesses
                            ( Electronic ,
                              CreatedDate ,
                              CreatedBy ,
                              ModifiedDate ,
                              ModifiedBy
				            )
                    VALUES  ( ISNULL(@Electronic, 'N') ,
                              @CurrentDate ,
                              @UserCode ,
                              @CurrentDate ,
                              @UserCode
				            )

                    SET @ClaimProcessId = @@Identity

                    INSERT  INTO ClaimBatches
                            ( ClaimProcessId ,
                              STATUS ,
                              CoveragePlanId ,
                              PayerId ,
                              ClaimFormatId ,
                              CreatedDate ,
                              CreatedBy ,
                              ModifiedDate ,
                              ModifiedBy
				            )
                            SELECT  @ClaimProcessId ,
                                    4521 ,
                                    CASE WHEN PayerId IS NULL THEN CoveragePlanId
                                         ELSE NULL
                                    END ,
                                    CASE WHEN PayerId IS NOT NULL THEN PayerId
                                         ELSE NULL
                                    END ,
                                    ClaimFormatId ,
                                    @CurrentDate ,
                                    @UserCode ,
                                    @CurrentDate ,
                                    @UserCode
                            FROM    #ClaimCharges
                            WHERE   ClaimFormatId IS NOT NULL
                            GROUP BY CASE WHEN PayerId IS NULL THEN CoveragePlanId
                                          ELSE NULL
                                     END ,
                                    CASE WHEN PayerId IS NOT NULL THEN PayerId
                                         ELSE NULL
                                    END ,
                                    ClaimFormatId

                    UPDATE  #ClaimCharges
                    SET     CoveragePlanId = NULL
                    WHERE   PayerId IS NOT NULL

                    INSERT  INTO ClaimBatchCharges
                            ( ClaimBatchId ,
                              ChargeId ,
                              CreatedDate ,
                              CreatedBy ,
                              ModifiedDate ,
                              ModifiedBy
				            )
                            SELECT  b.ClaimBatchId ,
                                    a.ChargeId ,
                                    @CurrentDate ,
                                    @UserCode ,
                                    @CurrentDate ,
                                    @UserCode
                            FROM    #ClaimCharges a
                                    JOIN ClaimBatches b ON ( ISNULL(a.PayerId, -1) = ISNULL(b.PayerId, -1)
                                                             AND ISNULL(a.CoveragePlanId, -1) = ISNULL(b.CoveragePlanId, -1)
                                                           )
                                                           AND a.ClaimFormatId = b.ClaimFormatId
                            WHERE   b.ClaimProcessId = @ClaimProcessId
                                    AND a.ClaimFormatId IS NOT NULL
                END

		---hyperlink change   
		--if @HyperFlag = 'Y' and @ClaimProcessId = 0  
		-- select @ClaimProcessId =  a.ClaimProcessId from ClaimBatches a    
		--JOIN ClaimFormats b ON (a.ClaimFormatId = b.ClaimFormatId)    
		--LEFT JOIN CoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId)    
		--LEFT JOIN Payers d ON (a.PayerId =  d.PayerId)    
		--JOIN GlobalCodes e ON (a.Status = e.GlobalCodeId)    
		--where (a.ClaimBatchId = @ClaimBatchId  or a.ClaimProcessId = @ClaimProcessId)   
		--and (a.RecordDeleted ='N' or a.RecordDeleted is null)   
		--Modified the logic to reteieve batch   
		---hyperlink change when batchis  
            IF ( @HyperFlag = 'Y'
                  AND (@ClaimProcessId = 0 or @ClaimBatchId > 0)   -- Hemant 09/07/2018
               )
                BEGIN
                    SELECT  @ClaimProcessId = a.ClaimProcessId
                    FROM    ClaimBatches a
                            JOIN ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
                            LEFT JOIN CoveragePlans c ON ( a.CoveragePlanId = c.CoveragePlanId )
                            LEFT JOIN Payers d ON ( a.PayerId = d.PayerId )
                            JOIN GlobalCodes e ON ( a.STATUS = e.GlobalCodeId )
                    WHERE   ( a.ClaimBatchId = @ClaimBatchId
                              OR a.ClaimProcessId = @ClaimProcessId
                            )
                            AND ( a.RecordDeleted = 'N'
                                  OR a.RecordDeleted IS NULL
                                )

                    INSERT  INTO #ClaimBatches
                            ( ClaimProcessId ,
                              ClaimBatchId ,
                              BatchName ,
                              ClaimFormatId ,
                              Electronic ,
                              StoredProcedure ,
                              SystemReportId ,
                              STATUS ,
                              StatusId ,
                              ProcessLater
				            )
                            SELECT  @ClaimProcessId AS ClaimProcessId ,
                                    -1 AS ClaimBatchId ,
                                    'All Batches' AS BatchName ,
                                    NULL AS ClaimFormatId ,
                                    NULL AS Electronic ,
                                    NULL AS StoredProcedure ,
                                    NULL AS SystemReportId ,
                                    NULL AS STATUS ,
                                    NULL AS StatusId ,
                                    NULL AS ProcessLater
                            UNION
                            SELECT  a.ClaimProcessId ,
                                    a.ClaimBatchId ,
                                    RTRIM(CONVERT(VARCHAR, ISNULL(a.ClaimBatchId, '')) + '-' + CASE WHEN a.CoveragePlanId IS NOT NULL THEN RTRIM(c.DisplayAs)
                                                                                                    ELSE RTRIM(d.PayerName)
                                                                                               END + '-' + CONVERT(VARCHAR, ISNULL(b.FormatName, ''))) AS BatchName ,   --Added by Chita Ranjan 11/21/2016
                                    a.ClaimFormatId ,
                                    ISNULL(b.Electronic, 'N') ,
                                    b.StoredProcedure ,
                                    b.SystemReportId ,
                                    e.CodeName ,
                                    a.STATUS ,
                                    a.ProcessLater
                            FROM    ClaimBatches a
                                    JOIN ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
                                    LEFT JOIN CoveragePlans c ON ( a.CoveragePlanId = c.CoveragePlanId )
                                    LEFT JOIN Payers d ON ( a.PayerId = d.PayerId )
                                    JOIN GlobalCodes e ON ( a.STATUS = e.GlobalCodeId )
                            WHERE   ( a.ClaimBatchId = @ClaimBatchId )
                                    AND ( a.RecordDeleted = 'N'
                                          OR a.RecordDeleted IS NULL
                                        )
                END
            ELSE
                BEGIN
			--end    
			-- Logic to retrieve data    
			-- Get list of Batches    
                    INSERT  INTO #ClaimBatches
                            ( ClaimProcessId ,
                              ClaimBatchId ,
                              BatchName ,
                              ClaimFormatId ,
                              Electronic ,
                              StoredProcedure ,
                              SystemReportId ,
                              STATUS ,
                              StatusId ,
                              ProcessLater
				            )
                            SELECT  @ClaimProcessId AS ClaimProcessId ,
                                    -1 AS ClaimBatchId ,
                                    'All Batches' AS BatchName ,
                                    NULL AS ClaimFormatId ,
                                    NULL AS Electronic ,
                                    NULL AS StoredProcedure ,
                                    NULL AS SystemReportId ,
                                    NULL AS STATUS ,
                                    NULL AS StatusId ,
                                    NULL AS ProcessLater
                            UNION
                            SELECT  a.ClaimProcessId ,
                                    a.ClaimBatchId ,
                                    RTRIM(CONVERT(VARCHAR, ISNULL(a.ClaimBatchId, '')) + '-' + CASE WHEN a.CoveragePlanId IS NOT NULL THEN RTRIM(c.DisplayAs)
                                                                                                    ELSE RTRIM(d.PayerName)
                                                                                               END + '-' + CONVERT(VARCHAR, ISNULL(b.FormatName, ''))) AS BatchName ,  --Added by Chita Ranjan 11/21/2016
                                    a.ClaimFormatId ,
                                    ISNULL(b.Electronic, 'N') ,
                                    b.StoredProcedure ,
                                    b.SystemReportId ,
                                    e.CodeName ,
                                    a.STATUS ,
                                    a.ProcessLater
                            FROM    ClaimBatches a
                                    JOIN ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
                                    LEFT JOIN CoveragePlans c ON ( a.CoveragePlanId = c.CoveragePlanId )
                                    LEFT JOIN Payers d ON ( a.PayerId = d.PayerId )
                                    JOIN GlobalCodes e ON ( a.STATUS = e.GlobalCodeId )
                            WHERE   ( a.ClaimBatchId = @ClaimBatchId
                                      OR a.ClaimProcessId = @ClaimProcessId
                                    )
                                    AND ( a.RecordDeleted = 'N'
                                          OR a.RecordDeleted IS NULL
                                        )
                END


		-- Set Electronic Y/N for 'All Batches' record    
            UPDATE  a
            SET     Electronic = b.Electronic
            FROM    #ClaimBatches a
                    CROSS JOIN #ClaimBatches b
            WHERE   a.ClaimBatchId = 0
                    AND b.ClaimBatchId <> 0

		-- Select Batches for dropdown    
            SELECT  ClaimProcessId ,
                    ClaimBatchId ,
                    BatchName ,
                    ClaimFormatId ,
                    Electronic ,
                    StoredProcedure ,
                    SystemReportId ,
                    StatusId ,
                    ProcessLater
            FROM    #ClaimBatches

            CREATE TABLE #ChargeErrors
                (
                  ChargeId INT ,
                  MaxChargeErrorId INT ,
                  ErrorMessage VARCHAR(500)
                )

            CREATE TABLE #ChargeErrorsAll
                (
                  ChargeId INT ,
                  ChargeErrorId INT ,
                  ErrorDescription VARCHAR(500)
                )

            INSERT  INTO #ChargeErrors
                    ( ChargeId
                    )
                    SELECT DISTINCT
                            b.ChargeId
                    FROM    #ClaimBatches a
                            JOIN ClaimBatchCharges b ON ( a.ClaimBatchId = b.ClaimBatchId )
                            JOIN dbo.ClaimBatches c ON c.ClaimBatchId = b.ClaimBatchId
                    WHERE   c.BilledDate IS NULL


            INSERT  INTO #ChargeErrorsAll
                    ( ChargeId ,
                      ChargeErrorId ,
                      ErrorDescription
			        )
                    SELECT  a.ChargeId ,
                            b.ChargeErrorId ,
                            b.ErrorDescription
                    FROM    #ChargeErrors a
                            JOIN ChargeErrors b ON ( a.ChargeId = b.ChargeId )
                    WHERE   ISNULL(b.RecordDeleted, 'N') <> 'Y'

		-- Showing a maximum of 3 errors            
            UPDATE  a
            SET     ErrorMessage = CASE WHEN LEN(b.ErrorDescription) > 300 THEN SUBSTRING(b.ErrorDescription, 1, 297) + '...'
                                        ELSE b.ErrorDescription
                                   END ,
                    MaxChargeErrorId = b.ChargeErrorId
            FROM    #ChargeErrors a
                    JOIN #ChargeErrorsAll b ON ( a.ChargeId = b.ChargeId )
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   #ChargeErrorsAll c
                                 WHERE  a.ChargeId = c.ChargeId
                                        AND b.ChargeErrorId > c.ChargeErrorId )

            UPDATE  a
            SET     ErrorMessage = CASE WHEN LEN(a.ErrorMessage + ', ' + b.ErrorDescription) > 300 THEN SUBSTRING(a.ErrorMessage + ', ' + b.ErrorDescription, 1, 297) + '...'
                                        ELSE a.ErrorMessage + ', ' + b.ErrorDescription
                                   END ,
                    MaxChargeErrorId = b.ChargeErrorId
            FROM    #ChargeErrors a
                    JOIN #ChargeErrorsAll b ON ( a.ChargeId = b.ChargeId )
            WHERE   b.ChargeErrorId > a.MaxChargeErrorId
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ChargeErrorsAll c
                                     WHERE  a.ChargeId = c.ChargeId
                                            AND c.ChargeErrorId > a.MaxChargeErrorId
                                            AND b.ChargeErrorId > c.ChargeErrorId )

            UPDATE  a
            SET     ErrorMessage = CASE WHEN LEN(a.ErrorMessage + ', ' + b.ErrorDescription) > 300 THEN SUBSTRING(a.ErrorMessage + ', ' + b.ErrorDescription, 1, 297) + '...'
                                        ELSE a.ErrorMessage + ', ' + b.ErrorDescription
                                   END ,
                    MaxChargeErrorId = b.ChargeErrorId
            FROM    #ChargeErrors a
                    JOIN #ChargeErrorsAll b ON ( a.ChargeId = b.ChargeId )
            WHERE   b.ChargeErrorId > a.MaxChargeErrorId
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ChargeErrorsAll c
                                     WHERE  a.ChargeId = c.ChargeId
                                            AND c.ChargeErrorId > a.MaxChargeErrorId
                                            AND b.ChargeErrorId > c.ChargeErrorId )

		-- Show the list of Coverage Plans that do not have Claim Formats associated    
            SELECT DISTINCT
                    b.DisplayAs AS CoveragePlan
            FROM    #ClaimCharges a
                    JOIN CoveragePlans b ON ( a.CoveragePlanId = b.CoveragePlanId )
            WHERE   a.ClaimFormatId IS NULL

		--commented by Shruthi.S 
		--CREATE TABLE #RowSelection1 (ChargeId1 INT, IsSelected1 BIT)  
		-- INSERT INTO #RowSelection1( ChargeId1, IsSelected1 )   
		-- SELECT ids,IsSelected   
		-- FROM dbo.SplitJSONString(@UniqueId,',')  
            CREATE TABLE #RowSelection1 ( ChargeId1 INT )

            INSERT  INTO #RowSelection1
                    SELECT  ChargeId
                    FROM    @UniqueIdTable;

            WITH    PaymentResultSet
                      AS ( SELECT   a.ClaimBatchId ,
                                    a.ClaimProcessId ,
                                    a.BatchName ,
                                    d.ServiceId ,
                                    e.CoveragePlanId ,
                                    d.ClientId ,
                                    f.DisplayAs AS PlanName ,
                                    CASE WHEN ISNULL(i.ClientType, 'I') = 'I' THEN i.LastName + ', ' + i.FirstName
                                         ELSE i.OrganizationName
                                    END AS ClientName ,
                                    d.DateOfService ,
                                    d.ProgramId ,
                                    h.ProgramCode ,
                                    j.LastName + ', ' + j.FirstName AS StaffName ,
                                    d.Charge ,
                                    g.DisplayAs AS ProcedureCode ,
				-- Modification starts here (Core Bugs # 435) Modified by Bernardin on 20/08/2014
				--a.Status  as BatchStatus,
                                    CASE WHEN z.ErrorMessage IS NOT NULL THEN 'Selected'
                                         ELSE a.STATUS
                                    END AS BatchStatus ,
				-- Modification end here (Core Bugs # 435) Modified by Bernardin on 20/08/2014 
                                    CONVERT(VARCHAR(1000), z.ErrorMessage) AS ErrorMessage ,
                                    a.StatusId ,
                                    b.ChargeId ,
                                    0 AS IsSelected ,
                                    ( SELECT    MAX(l.ClaimLineItemId)
                                      FROM      dbo.ClaimLineItemCharges k
                                                JOIN dbo.ClaimLineItems l ON l.ClaimLineItemId = k.ClaimLineItemId
                                                JOIN dbo.ClaimLineItemGroups m ON m.ClaimLineItemGroupId = l.ClaimLineItemGroupId
                                                                                  AND m.ClaimBatchId = a.ClaimBatchId
                                      WHERE     k.ChargeId = b.ChargeId
                                    ) AS ClaimLineItemId --Added by Varun (Engineering Improvements #220.1)
                           FROM     #ClaimBatches a
                                    JOIN ClaimBatchCharges b ON ( a.ClaimBatchId = b.ClaimBatchId )
                                    JOIN Charges c ON ( b.ChargeId = c.ChargeId )
                                    JOIN Services d ON ( c.ServiceId = d.ServiceId )
                                    JOIN ClientCoveragePlans e ON ( c.ClientCoveragePlanId = e.ClientCoveragePlanId )
                                    JOIN CoveragePlans f ON ( e.CoveragePlanId = f.CoveragePlanId )
                                    JOIN ProcedureCodes g ON ( d.ProcedureCodeId = g.ProcedureCodeId )
                                    JOIN Programs h ON ( d.ProgramId = h.ProgramId )
                                    JOIN Clients i ON ( d.ClientId = i.ClientId )
                                    LEFT JOIN #ChargeErrors z ON ( b.ChargeId = z.ChargeId )
                                    LEFT JOIN Staff j ON ( d.ClinicianId = j.StaffId )
                           WHERE    ISNULL(b.RecordDeleted, 'N') = 'N'
                         ),
			--order by a.BatchName, a.ClaimBatchId, ClientName, d.DateOfService    
                    counts
                      AS ( SELECT   COUNT(*) AS totalrows
                           FROM     PaymentResultSet
                         ),
                    RankResultSet
                      AS ( SELECT   [ClaimBatchId] ,
                                    [ClaimProcessId] ,
                                    [BatchName] ,
                                    [ServiceId] ,
                                    [CoveragePlanId] ,
                                    [ClientId] ,
                                    [PlanName] ,
                                    [ClientName] ,
                                    [DateOfService] ,
                                    [ProgramId] ,
                                    [ProgramCode] ,
                                    [StaffName] ,
                                    [Charge] ,
                                    [ProcedureCode] ,
                                    [BatchStatus] ,
                                    [ErrorMessage] ,
                                    [StatusId] ,
                                    [ChargeId] ,
                                    IsSelected ,
                                    [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                                    ,
                                    COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'BatchName' THEN BatchName
                                                           END
						, CASE WHEN @SortExpression = 'BatchName desc' THEN BatchName
                          END DESC
						, CASE WHEN @SortExpression = 'ServiceId' THEN ServiceId
                          END
						, CASE WHEN @SortExpression = 'ServiceId desc' THEN ServiceId
                          END DESC
						, CASE WHEN @SortExpression = 'PlanName' THEN PlanName
                          END
						, CASE WHEN @SortExpression = 'PlanName desc' THEN PlanName
                          END DESC
						, CASE WHEN @SortExpression = 'ClientId' THEN ClientId
                          END
						, CASE WHEN @SortExpression = 'ClientId desc' THEN ClientId
                          END DESC
						, CASE WHEN @SortExpression = 'ClientName' THEN ClientName
                          END
						, CASE WHEN @SortExpression = 'ClientName desc' THEN ClientName
                          END DESC
						, CASE WHEN @SortExpression = 'ProcedureCode' THEN ProcedureCode
                          END
						, CASE WHEN @SortExpression = 'ProcedureCode desc' THEN ProcedureCode
                          END DESC
						, CASE WHEN @SortExpression = 'DateOfService' THEN DateOfService
                          END
						, CASE WHEN @SortExpression = 'DateOfService desc' THEN DateOfService
                          END DESC
						, CASE WHEN @SortExpression = 'StaffName' THEN StaffName
                          END
						, CASE WHEN @SortExpression = 'StaffName desc' THEN StaffName
                          END DESC
						, CASE WHEN @SortExpression = 'Charge' THEN Charge
                          END
						, CASE WHEN @SortExpression = 'Charge desc' THEN Charge
                          END DESC
						, CASE WHEN @SortExpression = 'BatchStatus' THEN BatchStatus
                          END
						, CASE WHEN @SortExpression = 'BatchStatus desc' THEN BatchStatus
                          END DESC
						, CASE WHEN @SortExpression = 'ErrorMessage' THEN ErrorMessage
                          END
						, CASE WHEN @SortExpression = 'ErrorMessage desc' THEN ErrorMessage
                          END DESC
						, CASE WHEN @SortExpression = 'ProgramCode' THEN ProgramCode
                          END
						, CASE WHEN @SortExpression = 'ProgramCode desc' THEN ProgramCode
                          END DESC
						, CASE WHEN @SortExpression = 'IsSelected' THEN IsSelected
                          END
						, CASE WHEN @SortExpression = 'IsSelected desc' THEN IsSelected
                          END DESC
						, CASE WHEN @SortExpression = 'ClaimLineItemId' --Added by Varun (Engineering Improvements #220.1)
                                    THEN ClaimLineItemId
                          END
						, CASE WHEN @SortExpression = 'ClaimLineItemId desc' --Added by Varun (Engineering Improvements #220.1)
                                    THEN ClaimLineItemId
                          END DESC
						, ChargeId ) AS RowNumber
                           FROM     PaymentResultSet
                         ),
                    Selectedcounts
                      AS ( SELECT   COUNT(*) AS TotalSelectedRows
                           FROM     RankResultSet
                           WHERE    statusid = 4521
                           GROUP BY statusid
                         ),
                    SumCharge
                      AS ( SELECT   SUM(Charge) AS SumTotalCharges
                           FROM     RankResultSet
                         )
                SELECT TOP ( CASE WHEN ( @PageNumber = -1
                                         OR @RowSelectionList = 'all'
                                         OR @RowSelectionList = ''
                                       ) THEN ( SELECT  ISNULL(totalrows, 0)
                                                FROM    counts
                                              )
                                  ELSE ( @PageSize )
                             END )
                        [ClaimProcessId] ,
                        [ClaimBatchId] ,
                        [BatchName] ,
                        [ServiceId] ,
                        [CoveragePlanId] ,
                        [ClientId] ,
                        [PlanName] ,
                        [ClientName] ,
                        [DateOfService] ,
                        [ProgramId] ,
                        [ProgramCode] ,
                        [StaffName] ,
                        [Charge] ,
                        [ProcedureCode] ,
                        [BatchStatus] ,
                        [ErrorMessage] ,
                        [StatusId] ,
                        [ChargeId] ,
                        CONVERT(BIT, IsSelected) AS IsSelected ,
                        [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                        ,
                        TotalCount ,
                        RowNumber ,
                        ( SELECT    ISNULL(TotalSelectedRows, 0)
                          FROM      Selectedcounts
                        ) AS TotalSelectedRows ,
                        ( SELECT    SumTotalCharges
                          FROM      SumCharge
                        ) AS TotalSumCharges
                INTO    #FinalResultSet
                FROM    RankResultSet
                --WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

		--Added by MSuma to change the status as Selected in same batch with has few Processed Charges
            UPDATE  FR
            SET     StatusId = 4521
            FROM    #FinalResultSet FR
                    JOIN ChargeErrors CE ON FR.ChargeId = CE.ChargeID

		-- Modification starts here (Core Bugs # 435) Modified by Bernardin on 20/08/2014
		--UPDATE FR SET BatchStatus = 'Selected' FROM #FinalResultSet FR JOIN ChargeErrors CE on FR.ChargeId = CE.ChargeID
		-- Modification ends here (Core Bugs # 435) Modified by Bernardin on 20/08/2014
            DECLARE @TotalCharges MONEY
            DECLARE @TotalCount INT;

            SELECT TOP 1
                    @TotalCharges = SUM(Charge) ,
                    @TotalCount = COUNT(ChargeId)
            FROM    #FinalResultSet
            WHERE   ( ( @ClaimBatchId > 0
                        AND ClaimBatchId = @ClaimBatchId
                      )
                      OR ( @ClaimBatchId <= 0
                           AND ClaimProcessId = @ClaimProcessId
                         )
                    );
			
			
            SELECT TOP 1
                    @PageNumber AS PageNumber ,
                    ISNULL(( @TotalCount / @PageSize ), 0) + 1 AS NumberOfPages ,
                    ISNULL(@TotalCount, 0) AS NumberOfRows ,
                    @TotalCharges TotalCharges ,
                    '' AS ArrayList
            FROM    #FinalResultSet;

		--Commented by shruthi.s  
		--if((@UniqueId <> '') and @HyperFlag = 'Y' )  
		--BEGIN  
		--update rs    
		--set IsSelected = 1   
		--from #FinalResultSet rs  
		-- JOIN #RowSelection1 rsl on rs.ChargeId in (rsl.ChargeId1)                                            
		--END  
            IF LOWER(@RowSelectionList) = 'all'
                BEGIN
                    UPDATE  #FinalResultSet
                    SET     IsSelected = 1
                    WHERE   ( @ClaimBatchId = -1
                              OR ClaimBatchId = @ClaimBatchId
                            )
                            AND ( ClaimProcessId = @ClaimProcessId )
                END
            ELSE
                BEGIN
                    IF LOWER(@RowSelectionList) = 'none'
                        BEGIN
                            UPDATE  #FinalResultSet
                            SET     IsSelected = 0
                            WHERE   ( @ClaimBatchId = -1
                                      OR ClaimBatchId = @ClaimBatchId
                                    )
                                    AND ( ClaimProcessId = @ClaimProcessId )
                        END
                    ELSE
                        IF LOWER(@RowSelectionList) = 'allonpage'
                            BEGIN
                                UPDATE  #FinalResultSet
                                SET     IsSelected = 1
                                WHERE   --PageNumber = @PageNumber    and   
                                        ( @ClaimBatchId = -1
                                          OR ClaimBatchId = @ClaimBatchId
                                        )
                                        AND ( ClaimProcessId = @ClaimProcessId )

                                UPDATE  #FinalResultSet
                                SET     IsSelected = 0
                                WHERE   --PageNumber != @PageNumber and  
                                        ( @ClaimBatchId = -1
                                          OR ClaimBatchId = @ClaimBatchId
                                        )
                                        AND ( ClaimProcessId = @ClaimProcessId )
                            END
                END
		
		---- Update the Claim Line Item Id
		--Added by Varun (Engineering Improvements #220.1)
            --UPDATE  cf
            --SET     ClaimLineItemId = CB.ClaimLineItemId
            --FROM    #FinalResultSet CF
            --        JOIN ClaimLineItemGroups CBC ON CBC.ClaimBatchId = CF.ClaimBatchId
            --        JOIN ClaimLineItems CB ON CB.ClaimLineItemGroupId = CBC.ClaimLineItemGroupId
            --        JOIN ClaimLineItemCharges CLIC ON CLIC.ClaimLineItemId = CB.ClaimLineItemId
            --WHERE   ISNULL(CBC.RecordDeleted, 'N') = 'N'
            --        AND ISNULL(CB.RecordDeleted, 'N') = 'N'
            --        AND CLIC.ChargeId = CF.ChargeId
		
            IF ( @HyperFlag = 'N' )
                BEGIN
                    SELECT  [ClaimBatchId] ,
                            [ClaimProcessId] ,
                            [BatchName] ,
                            [ServiceId] ,
                            [CoveragePlanId] ,
                            [ClientId] ,
                            [PlanName] ,
                            [ClientName] ,
                            [DateOfService] ,
                            [ProgramId] ,
                            [ProgramCode] ,
                            [StaffName] ,
                            [Charge] ,
                            [ProcedureCode] ,
                            [BatchStatus] ,
                            [ErrorMessage] ,
                            [StatusId] ,
                            [ChargeId] ,
                            IsSelected ,
                            [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                            ,
                            ISNULL(TotalSelectedRows, 0) AS TotalSelectedRows
                    FROM    #FinalResultSet a
                            JOIN #RowSelection1 rs ON rs.ChargeId1 IN ( a.ChargeId )
                    WHERE   @SessionId = @SessionId
                            AND @InstanceId = @InstanceId
				--and PageNumber = @PageNumber   
                            AND a.ChargeId IN ( rs.ChargeId1 )
                            AND a.RowNumber > ( ( @PageNumber - 1 ) * @PageSize )
                            AND a.RowNumber <= ( @PageNumber * @PageSize )
                END
            ELSE
                IF ( @HyperFlag = 'Y'
                     AND @ClaimBatchId > 0
                   )
                    BEGIN
                        SELECT  [ClaimBatchId] ,
                                [ClaimProcessId] ,
                                [BatchName] ,
                                [ServiceId] ,
                                [CoveragePlanId] ,
                                [ClientId] ,
                                [PlanName] ,
                                [ClientName] ,
                                [DateOfService] ,
                                [ProgramId] ,
                                [ProgramCode] ,
                                [StaffName] ,
                                [Charge] ,
                                [ProcedureCode] ,
                                [BatchStatus] ,
                                [ErrorMessage] ,
                                [StatusId] ,
                                [ChargeId] ,
                                [IsSelected] ,
                                [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                                ,
                                ISNULL(TotalSelectedRows, 0) AS TotalSelectedRows
                        FROM    #FinalResultSet a
			--JOIN #RowSelection1 rs on rs.ChargeId1 in (a.ChargeId)                                            
                        WHERE   @SessionId = @SessionId
                                AND @InstanceId = @InstanceId
				--and PageNumber = @PageNumber   
                                AND a.ClaimBatchId = @ClaimBatchId
                                AND a.RowNumber > ( ( @PageNumber - 1 ) * @PageSize )
                                AND a.RowNumber <= ( @PageNumber * @PageSize )
                        ORDER BY RowNumber
                    END
                ELSE
                    IF ( @HyperFlag = 'Y'
                         AND @ClaimBatchId = '-1'
                         AND @ClaimProcessId > 0
                       )
                        BEGIN
                            SELECT  [ClaimBatchId] ,
                                    [ClaimProcessId] ,
                                    [BatchName] ,
                                    [ServiceId] ,
                                    [CoveragePlanId] ,
                                    [ClientId] ,
                                    [PlanName] ,
                                    [ClientName] ,
                                    [DateOfService] ,
                                    [ProgramId] ,
                                    [ProgramCode] ,
                                    [StaffName] ,
                                    [Charge] ,
                                    [ProcedureCode] ,
                                    [BatchStatus] ,
                                    [ErrorMessage] ,
                                    [StatusId] ,
                                    [ChargeId] ,
                                    [IsSelected] ,
                                    [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                                    ,
                                    ISNULL(TotalSelectedRows, 0) AS TotalSelectedRows
                            FROM    #FinalResultSet a
			--JOIN #RowSelection1 rs on rs.ChargeId1 in (a.ChargeId)                                            
                            WHERE   @SessionId = @SessionId
                                    AND @InstanceId = @InstanceId
				-- and PageNumber = @PageNumber   
                                    AND a.ClaimProcessId = @ClaimProcessId
                                    AND a.RowNumber > ( ( @PageNumber - 1 ) * @PageSize )
                                    AND a.RowNumber <= ( @PageNumber * @PageSize )
                            ORDER BY RowNumber
                        END
                    ELSE
                        IF ( @HyperFlag = 'Y'
                             AND @ClaimProcessId > 0
                           )
                            BEGIN
                                SELECT  [ClaimBatchId] ,
                                        [ClaimProcessId] ,
                                        [BatchName] ,
                                        [ServiceId] ,
                                        [CoveragePlanId] ,
                                        [ClientId] ,
                                        [PlanName] ,
                                        [ClientName] ,
                                        [DateOfService] ,
                                        [ProgramId] ,
                                        [ProgramCode] ,
                                        [StaffName] ,
                                        [Charge] ,
                                        [ProcedureCode] ,
                                        [BatchStatus] ,
                                        [ErrorMessage] ,
                                        [StatusId] ,
                                        [ChargeId] ,
                                        [IsSelected] ,
                                        [ClaimLineItemId] --Added by Varun (Engineering Improvements #220.1)
                                        ,
                                        ISNULL(TotalSelectedRows, 0) AS TotalSelectedRows
                                FROM    #FinalResultSet a
			--JOIN #RowSelection1 rs on rs.ChargeId1 in (a.ChargeId)                                            
                                WHERE   --@SessionId = @SessionId    
				--and @InstanceId = @InstanceId     and                                       
				--PageNumber = @PageNumber  and   
                                        a.ClaimProcessId = @ClaimProcessId
                                        AND a.RowNumber > ( ( @PageNumber - 1 ) * @PageSize )
                                        AND a.RowNumber <= ( @PageNumber * @PageSize )
                                ORDER BY RowNumber
                            END
		

		-- Added by Md Hussain Khusro on 13/March/2014
            IF @Electronic = 'Y'
                BEGIN
                    UPDATE  CM
                    SET     CM.[FileName] = Data.[FileName]
                    FROM    ClaimBatches CM ,
                            ( SELECT    cb.ClaimBatchId ,-- This logic is moved from SSP_PMGetClaimBatches
                                        ClaimProcessId ,
                                        CONVERT(VARCHAR, ISNULL(cb.ClaimBatchId, '')) + '-' + CASE WHEN cb.CoveragePlanId IS NOT NULL THEN dbo.GetFormattedString(RTRIM(cp.DisplayAs))
                                                                                                   ELSE dbo.GetFormattedString(RTRIM(d.PayerName))
                                                                                              END + '-' + CONVERT(VARCHAR, ISNULL(cf.FormatName, '')) + '.837' AS 'FileName'
                              FROM      ClaimBatches cb
                                        INNER JOIN ClaimFormats cf ON cf.ClaimFormatId = cb.ClaimFormatId
                                        INNER JOIN ( SELECT ClaimBatchId ,
                                                            MAX(ChargeId) AS ChargeId
                                                     FROM   ClaimBatchCharges
                                                     WHERE  RecordDeleted = 'N'
                                                            OR RecordDeleted IS NULL
                                                     GROUP BY ClaimBatchId
                                                   ) cbc ON cbc.ClaimBatchId = cb.ClaimBatchId
                                        INNER JOIN Charges c ON c.ChargeId = cbc.ChargeId
                                        LEFT JOIN ClientCoveragePlans ccp ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                        LEFT JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                                        LEFT JOIN Payers d ON d.PayerId = cb.PayerId
                              WHERE     ( cb.ClaimBatchId = @ClaimBatchId
                                          OR cb.ClaimProcessId = @ClaimProcessId
                                        )
                                        AND ( cb.RecordDeleted = 'N'
                                              OR cb.RecordDeleted IS NULL
                                            )
                            ) Data
                    WHERE   CM.ClaimBatchId = data.ClaimBatchId
                            AND CM.ClaimProcessId = data.ClaimProcessId
                            AND CM.FileName IS NULL
                            AND ISNULL(CM.RecordDeleted, 'N') = 'N'
                END
				--SELECT [ClaimBatchId]    
				--      ,[ClaimProcessId]    
				--      ,[BatchName]    
				--      ,[ServiceId]    
				--      ,[CoveragePlanId]    
				--      ,[ClientId]    
				--      ,[PlanName]    
				--      ,[ClientName]    
				--      ,[DateOfService]    
				--      ,[ProgramId]    
				--      ,[ProgramCode]    
				--      ,[StaffName]    
				--      ,[Charge]    
				--      ,[ProcedureCode]    
				--      ,[BatchStatus]    
				--      ,[ErrorMessage]    
				--      ,[StatusId]    
				--      ,[ChargeId]    
				--      ,[IsSelected]                           
				-- from ListPagePMClaimsProcessing                                            
				-- where SessionId = @SessionId                                            
				--  and InstanceId = @InstanceId                                            
				--  and PageNumber = @PageNumber                                            
				-- order by RowNumber
			
			
			IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'scsp_PMClaimsProcessingData')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
			BEGIN
			EXEC scsp_PMClaimsProcessingData @ClaimProcessId, @ClaimBatchId
			END 
			
			  
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClaimsProcessingData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.      
				16
				,-- Severity.      
				1 -- State.      
				);
        END CATCH
    END
