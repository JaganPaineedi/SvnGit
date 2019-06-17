SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  1
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[Ssp_pmpostpaymentsgetselectedservices]')
                    AND type IN (N'P', N'PC') ) 
    DROP PROCEDURE [dbo].Ssp_pmpostpaymentsgetselectedservices
GO


CREATE PROCEDURE [Ssp_pmpostpaymentsgetselectedservices] 
@SessionId VARCHAR(max), 
@InstanceId INT, 
@RowSelectionList VARCHAR(max) = '' ,
@SelectedService VARCHAR(MAX)=''
/******************************************************************************  
** File: ssp_PMPostPaymentsGetSelectedServices.sql 
** Name: ssp_PMPostPaymentsGetSelectedServices 
** Desc:   
**  
**  
** This template can be customized:  
**  
** Return values: Filter Values -  Post Payments Find Services List Page 
**  
** Called by:  
**  
** Parameters:  
** Input Output  
** ---------- -----------  
** N/A   Dropdown values 
** Auth: Mary Suma 
** Date: 17/10/2011 
*******************************************************************************  
** Change History  
*******************************************************************************  
** Date:       Author:    Description:  
** 17/10/2011    MSuma     Query to retrieve the selected Services 
** 06/12/2011    MSuma     Formatted Amount column 
** 17/04/2012    Deej     Added a new optional parameter @RowSelectionList to avoid multiple sp call in the code
** 28/06/2012    MSuma     Added fix for @RowSelectionList to avoid multiple user error include session in update
** 01/22/2012    Deej     CoveragePlans list has been pulled for the selected serviceIds 
** 02/28/2013    Deej     Corrected the Coverageplan selection logic 
** 6/19/2013      Javed      Made a change to left join and added criteria to only show billable payers.
** 6/25/2013        Javed      changes made by Javed 
** 07/22/2013       SFarber    Fixed Coverage Plan selection logic.  
** 25-Nov-2013      Deej     ListPagePMPostPayments.IsSelected column set to 0 logic has been moved to down so that it updates only after the select statement
**  DEC-9-2013    dharvey    Added sort on Name, DateOfService for task #345 Venture Region 
**  DEC-16-2013    dharvey    Moved Row IsSelected update until end of result sets 
** JAN-9-2013     dharvey   Summit Pointe Support #1985 Removed IsSelected UPDATE to allow coverage information to be returned with Select+
** 22-Ma-2104	  Pselvan   Added new parameter @SelectedService to get the Payment posting record for selected services.
** 20-Feb-2015    Pselvan	Column names are changed to case sensitive as used in dataset (Ex: clientid to ClientId) Why: Duplicate columns are created in the dataset while merging. - For task #255 and #256 of Allegan 3.5 Implementation.
-- 10-March-2016  MJensen   Moved get next payer section from ssp_PMPostPaymentsServicesSearchSel to this proc per Thresholds 358
-- 5/27/2016      Hemant    What:Included Parameter snipping logic to improve the performance.
                            Why:New Directions - Support Go Live #361
-- 09-DEC-2016    Akwinass  What:Added #NextPayer table to get Next Payer ClientCoveragePlanId.
                            Why: Task #306 Woods - Support Go Live
-- 12/19/2017     jwheeler  Updated Error Handler to aid in debugging.  Added logic to ensure nextpayer cannot exceed 50 chars and cause string or binary error.
--11/02/2018      Shivam    What: Set Balance to 0.0
                            Why:Key Pointe Build Cycle Tasks#23

*******************************************************************************/ 
AS 
  BEGIN 
      BEGIN try 
      DECLARE @errormessage VARCHAR(MAX)
      --Start: Hemant 5/27/2016  
      DECLARE @LOCAL_SessionId VARCHAR(max) =@SessionId; 
      DECLARE @LOCAL_InstanceId INT =@InstanceId; 
      DECLARE @LOCAL_RowSelectionList VARCHAR(max) = @RowSelectionList;
      DECLARE @LOCAL_SelectedService VARCHAR(MAX)= @SelectedService 
      --End: Hemant 5/27/2016 
      
       
		IF OBJECT_ID('tempdb..#NextPayer') IS NOT NULL
			DROP TABLE #NextPayer

		CREATE TABLE #NextPayer (
			ServiceId INT
			,NextPayer VARCHAR(8000)
			,COBOrder INT
			,ClientCoveragePlanId INT
			)

      
          -- Added by Deej--------- 
          CREATE TABLE #rowselection 
            ( 
               rownumber  INT, 
               isselected BIT 
            ) 
			Create table #SelectedServices
			(
				ServiceId INT
			)
          INSERT INTO #rowselection 
                      (rownumber, 
                       isselected) 
          SELECT ids, 
                 isselected 
          FROM   dbo.Splitjsonstring(@LOCAL_RowSelectionList, ',') 
		INSERT INTO #SelectedServices(ServiceId)
		SELECT item FROM dbo.fnSplit(@LOCAL_SelectedService,',')
		
          --Commented by Suma   
          --UPDATE ListPagePMPostPayments      
          --SET IsSelected = a.IsSelected      
          --FROM #RowSelection a      
          --WHERE a.RowNumber = ListPagePMPostPayments.RowNumber   
          --Added by Suma 
          UPDATE LP 
          SET    LP.isselected = a.isselected 
          FROM   #rowselection a 
                 JOIN listpagepmpostpayments LP 
                   ON a.rownumber = LP.rownumber 
                      AND LP.sessionid = @LOCAL_SessionId 
                      AND LP.instanceid = @LOCAL_InstanceId 

          ------------------

			--Update Next Payer   added 10 March 2016 MJensen 
			    
			;

		WITH CTE_CurrentCob (
			ListPagePostPaymentsId
			,CurrentCOB
			)
		AS (
			SELECT lpp.ListPagePMPostPaymentId
				,ISNULL(cch.COBOrder, 0)
			FROM ListPagePMPostPayments lpp
			JOIN Services s ON lpp.ServiceId = s.ServiceId
			JOIN Charges c ON lpp.ChargeId = c.ChargeId
			JOIN ClientCoverageHistory cch ON c.ClientCoveragePlanId = cch.ClientCoveragePlanId
			WHERE lpp.IsSelected = 1
				AND lpp.sessionid = @LOCAL_SessionId
				AND lpp.instanceid = @LOCAL_InstanceId
				AND cch.StartDate <= s.DateOfService
				AND (
					cch.EndDate IS NULL
					OR cch.EndDate >= s.DateOfService
					)
				AND ISNULL(cch.RecordDeleted, 'N') = 'N'
			)
			,CTE_NextPayer (
			ServiceId
			,NextPayer
			,COBOrder
			,ClientCoveragePlanId -- 09-DEC-2016 Akwinass
			)
		AS (
			SELECT t.ServiceId
				,LEFT(cp.DisplayAs, 50 - LEN(' ' + ISNULL(ccp.InsuredId, ''))) + ' ' + ISNULL(ccp.InsuredId, '')
				--,cp.DisplayAs + ' ' + ISNULL(ccp.InsuredId, '')
				,ROW_NUMBER() OVER (
					PARTITION BY t.ServiceId ORDER BY cch.COBOrder
					)
				,ccp.ClientCoveragePlanId
			FROM listpagepmpostpayments t
			JOIN CTE_CurrentCob ccc ON ccc.ListPagePostPaymentsId = t.ListPagePMPostPaymentId
			JOIN Services s ON s.ServiceId = t.Serviceid
			JOIN Programs p ON p.ProgramId = s.ProgramId
			JOIN ClientCoveragePlans ccp ON ccp.ClientId = s.ClientId
			JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
				AND cch.ServiceAreaId = p.ServiceAreaId
			JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
			WHERE t.IsSelected = 1
				AND t.sessionid = @LOCAL_SessionId
				AND t.instanceid = @LOCAL_InstanceId
				AND cch.StartDate <= s.DateOfService
				AND (
					cch.EndDate IS NULL
					OR DATEADD(dd, 1, cch.EndDate) > s.DateOfService
					)
				AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
				AND ISNULL(cch.RecordDeleted, 'N') = 'N'
				AND ccc.CurrentCOB < cch.COBOrder
				AND ccc.CurrentCOB > 0
				-- Check if procedure is billable
				AND NOT EXISTS (
					SELECT *
					FROM CoveragePlanRules cpr
					WHERE (
							(
								cpr.CoveragePlanId = cp.CoveragePlanId
								AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
								)
							OR (
								cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
								AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
								)
							)
						AND cpr.RuleTypeId = 4267
						AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
						AND (
							cpr.AppliesToAllProcedureCodes = 'Y'
							OR EXISTS (
								SELECT *
								FROM CoveragePlanRuleVariables cprv
								WHERE cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
									AND cprv.ProcedureCodeId = s.ProcedureCodeId
									AND ISNULL(cprv.RecordDeleted, 'N') = 'N'
								)
							)
					)
				-- Check if Program is billable
				AND NOT EXISTS (
					SELECT *
					FROM ProgramPlans pp
					WHERE pp.CoveragePlanId = cp.CoveragePlanId
						AND pp.ProgramId = s.ProgramId
						AND ISNULL(pp.RecordDeleted, 'N') = 'N'
					)
			)
		INSERT INTO #NextPayer(ServiceId,NextPayer,COBOrder,ClientCoveragePlanId)-- 09-DEC-2016 Akwinass
		SELECT ServiceId,NextPayer,COBOrder,ClientCoveragePlanId FROM CTE_NextPayer
		
		UPDATE t
		SET NextPayer = np.NextPayer
		FROM listpagepmpostpayments t
		JOIN #NextPayer np ON np.ServiceId = t.Serviceid
		WHERE np.COBOrder = 1


		------------------		  
		   
         SELECT ServiceId, 
                 ClientId, 
                 [Name], 
                 DateOfService, 
                 Unit, 
                 Charge, 
                 ChargeId, 
                 Priority, 
                 CASE 
                   WHEN balance IS NOT NULL THEN Cast( 
                   CONVERT(DECIMAL(38, 2), balance) AS 
                   VARCHAR (255)
                                                 ) 
                   ELSE Cast('0.00' AS VARCHAR(255)) 
                 END                              AS Payment, 
                 CONVERT(VARCHAR(255), adjustment, 25) AS Adjustment, 
                 IsNull(Balance,'0.00') as Balance,
                 LedgerType, 
                 ClaimBatchId, 
                 CoveragePlanId, 
                 NextPayer, 
                 IsSelected, 
                 ListPagePMPostPaymentId, 
                 'N'                              AS DonotBill1, 
                 'N'                              AS Flagged, 
                 Cast(balance AS VARCHAR(255))         AS NewBalance, 
                 '0.00'                           AS Transfer1, 
                 '0.00'                           AS Adjustment1,
                 -- 09-DEC-2016 Akwinass 
                 (SELECT TOP 1 ClientCoveragePlanId FROM #NextPayer NP WHERE NP.ServiceId = lp.ServiceId) AS ClientCoveragePlanId
          FROM   listpagepmpostpayments lp
          WHERE  sessionid = @LOCAL_SessionId 
                 AND instanceid = @LOCAL_InstanceId 
                 AND isselected = 1 
         -- ORDER  BY [name],  dateofservice
		 
		UNION 
		
		SELECT ss.ServiceId, 
                 ClientId, 
                 [Name], 
                 DateOfService, 
                 Unit, 
                 Charge, 
                 ChargeId, 
                 Priority, 
                 CASE 
                   WHEN balance IS NOT NULL THEN Cast( 
                   CONVERT(DECIMAL(38, 2), balance) AS 
                   VARCHAR 
                                                 ) 
                   ELSE Cast('0.00' AS VARCHAR) 
                 END                              AS Payment, 
                 CONVERT(VARCHAR, adjustment, 25) AS Adjustment, 
                 IsNull(Balance,'0.00') as Balance, 
                 LedgerType, 
                 ClaimBatchId, 
                 CoveragePlanId, 
                 NextPayer, 
                 IsSelected, 
                 ListPagePMPostPaymentId, 
                 'N'                              AS DonotBill1, 
                 'N'                              AS Flagged, 
                 Cast(balance AS VARCHAR(255))         AS NewBalance, 
                 '0.00'                           AS Transfer1, 
                 '0.00'                           AS Adjustment1,
                 -- 09-DEC-2016 Akwinass 
                 (SELECT TOP 1 ClientCoveragePlanId FROM #NextPayer NP WHERE NP.ServiceId = lp.ServiceId) AS ClientCoveragePlanId
          FROM    listpagepmpostpayments lp
          inner join  #SelectedServices ss on ss.ServiceId=lp.ServiceId
          WHERE  sessionid = @LOCAL_SessionId 
                 AND instanceid = @LOCAL_InstanceId 
         ORDER  BY [name], dateofservice
		
		
          ----Added by Suma 
          --      UPDATE  LP 
          --      SET     LP.IsSelected = 0 
          --      FROM    ListPagePMPostPayments LP 
          --      WHERE   LP.SessionId = @SessionId 
          --              AND LP.InstanceId = @InstanceId     
          -- Select coverage plans that can be use for Transfer To   
          SELECT DISTINCT ccp.ClientCoveragePlanId, 
                          cp.CoveragePlanId, 
                          cp.displayas + ' ' + Isnull(ccp.insuredid, '') 
                          + '(' 
                          + CONVERT(VARCHAR(255), Isnull(cch.coborder, '')) 
                          + ')' AS DisplayAs, 
                          s.ClientId, 
                          cch.StartDate, 
                          cch.EndDate, 
                          cch.CobOrder, 
                          s.ServiceId, 
                          p.ServiceAreaId, 
                          s.ProgramId 
          FROM   listpagepmpostpayments t 
                 JOIN services s 
                   ON s.serviceid = t.serviceid 
                 JOIN programs p 
                   ON p.programid = s.programid 
                 JOIN clientcoverageplans ccp 
                   ON ccp.clientid = s.clientid 
                 JOIN clientcoveragehistory cch 
                   ON cch.clientcoverageplanid = ccp.clientcoverageplanid 
                      AND cch.serviceareaid = p.serviceareaid 
                 JOIN coverageplans cp 
                   ON cp.coverageplanid = ccp.coverageplanid 
                 LEFT JOIN charges c 
                        ON c.chargeid = t.chargeid 
                           AND Isnull(c.recorddeleted, 'N') = 'N' 
          WHERE  t.sessionid = @LOCAL_SessionId 
                 AND t.instanceid = @LOCAL_InstanceId 
                 AND t.isselected = 1 
                 AND ( c.clientcoverageplanid IS NULL 
                        OR c.clientcoverageplanid <> ccp.clientcoverageplanid ) 
                 AND cch.startdate <= s.dateofservice 
                 AND ( cch.enddate IS NULL 
                        OR Dateadd(dd, 1, cch.enddate) > s.dateofservice ) 
                 AND Isnull(ccp.recorddeleted, 'N') = 'N' 
                 AND Isnull(cch.recorddeleted, 'N') = 'N' 
                 -- Check if procedure is billable 
                 AND NOT EXISTS (SELECT * 
                                 FROM   coverageplanrules cpr 
                                 WHERE  ( ( cpr.coverageplanid = 
                                            cp.coverageplanid 
                                            AND Isnull(cp.billingrulestemplate, 
                                                'T') = 
                                                'T' 
                                          ) 
                                           OR ( cpr.coverageplanid = 
                                                cp.usebillingrulestemplateid 
                                                AND 
                                          Isnull(cp.billingrulestemplate, 
                                          'T') = 
                                          'O' ) 
                                        ) 
                                        AND cpr.ruletypeid = 4267 
                                        AND Isnull(cpr.recorddeleted, 'N') = 'N' 
                                        AND ( cpr.appliestoallprocedurecodes = 
                                              'Y' 
                                               OR EXISTS 
                                              (SELECT * 
                                               FROM 
                                                  coverageplanrulevariables 
                                                  cprv 
                                                          WHERE 
                                              cprv.coverageplanruleid = 
      cpr.coverageplanruleid 
      AND cprv.procedurecodeid 
          = 
          s.procedurecodeid 
      AND 
      Isnull(cprv.recorddeleted, 
      'N') 
      = 
      'N') )) 
      -- Check if Program is billable 
      AND NOT EXISTS (SELECT * 
      FROM   programplans pp 
      WHERE  pp.coverageplanid = cp.coverageplanid 
      AND pp.programid = s.programid 
      AND Isnull(pp.recorddeleted, 'N') = 'N') 
      ORDER  BY s.serviceid, 
      cch.coborder 

  -- 
          DECLARE @ServiceChargeTable SERVICECHARGETABLETYPE 

          INSERT INTO @ServiceChargeTable 
          SELECT ChargeId, 
                 ClientId, 
                 DateOfService, 
                 '' 
          FROM   listpagepmpostpayments 
          WHERE  isselected = 1 
                 AND sessionid = @LOCAL_SessionId 
                 AND instanceid = @LOCAL_InstanceId 

          CREATE TABLE #tempinfo 
            ( 
               custominformation VARCHAR(max), 
               chargeid          INT 
            ) 

          INSERT INTO #tempinfo 
          EXEC Scsp_pmpaymentadjselectservicestab 
            @ServiceChargeTable 

          SELECT custominformation, 
                 chargeid 
          FROM   #tempinfo 

          DROP TABLE #tempinfo 
      ---   
      /* Removed IsSelected UPDATE to allow coverage information to be returned with Select+ */
      ----Added by Suma - moved by dharvey 
      --         UPDATE  LP 
      --         SET     LP.IsSelected = 0 
      --         FROM    ListPagePMPostPayments LP 
      --         WHERE   LP.SessionId = @SessionId 
      --                 AND LP.InstanceId = @InstanceId     
      END try 

    BEGIN CATCH  --SQL Prompt Formatting Off
        --IF @@Trancount > @SaveTranCount
        --ROLLBACK TRAN
                 
        DECLARE @ErrorBlockLineLen INTEGER = 0
        DECLARE @ErrorBlockGotTheFormat BIT = 0
        DECLARE @ErrorFormatIndent Integer = 3
        DECLARE @ErrorBlockBeenThrough INTEGER = NULL -- must be set to null
        DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
        DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))
                  
        WHILE @ErrorBlockGotTheFormat = 0
        BEGIN
            IF @ErrorBlockBeenThrough IS NOT NULL
                SELECT @ErrorBlockGotTheFormat = 1
            SET @errormessage = Space(isnull(@ErrorFormatIndent,0)) + @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + Char(13) + char(10)
            SET @errormessage += Char(13) + char(10) + Space(isnull(@ErrorFormatIndent,0)) +'-------->' + ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + '<--------' + Char(13) + char(10) --
                + Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + Char(13) + char(10) --
                + Space(isnull(@ErrorFormatIndent,0)) + UPPER(@ThisProcedureName + ' Variable dump:') + Char(13) + char(10) --
                + Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + Char(13) + char(10) --
                + Space(isnull(@ErrorFormatIndent,0)) + '@SessionId:............<' + ISNULL(CAST(@SessionId             AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
                + Space(isnull(@ErrorFormatIndent,0)) + '@InstanceId:...........<' + ISNULL(CAST(@InstanceId            AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
                + Space(isnull(@ErrorFormatIndent,0)) + '@RowSelectionList:.....<' + ISNULL(CAST(@RowSelectionList      AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
                + Space(isnull(@ErrorFormatIndent,0)) + '@SelectedService:......<' + ISNULL(CAST(@SelectedService       AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
            SELECT @ErrorBlockLineLen = MAX(LEN(RTRIM(item)))  
                FROM dbo.fnSplit(@errormessage, Char(13) + char(10))
            SELECT @ErrorBlockBeenThrough= 1
        END
        RAISERROR('%s',16,1,@errormessage)   --SQL Prompt Formatting On
    END CATCH
      --SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  END 


GO
