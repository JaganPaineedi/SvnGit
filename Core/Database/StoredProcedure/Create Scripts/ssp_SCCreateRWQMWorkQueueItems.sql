
/****** Object:  StoredProcedure [dbo].[ssp_SCCreateRWQMWorkQueueItems]    Script Date: 03/22/2018 18:53:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateRWQMWorkQueueItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCreateRWQMWorkQueueItems]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCreateRWQMWorkQueueItems]    Script Date: 03/22/2018 18:53:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCCreateRWQMWorkQueueItems]
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCCreateRWQMWorkQueueItems            */
/* Creation Date:    11/July/2017                */
/* Purpose:  To Create Work Queue items based on Rules, Finanical Assignments and otehrs  */
/*    Exec ssp_SCCreateRWQMWorkQueueItems                                          */
/* Input Parameters:                           */
/*  Date   Author   Purpose              */
/* 11/July/2017  Gautam   Created    task #44 ,AHN-Customizations > Revenue Work Queue Management     
   16/Feb/2018   Gautam   Change the code as per new requirements mentioned in task #44 ,AHN-Customizations       
  ********************************************************************/
BEGIN
	DECLARE @RWQMRuleId INT
		,@RulePriority INT
		,@RuleType INT
		,@RuleNumberOfDays INT
	DECLARE @Balance MONEY
		,@IncludeFlaggedCharges VARCHAR(1)
		,@DaysToDueDate INT
		,@DaysToOverdue INT
	DECLARE @AllChargeActions VARCHAR(1)
		,@ChargesActions VARCHAR(250)
		,@AllChargeStatuses VARCHAR(1)
	DECLARE @ChargeStatuses VARCHAR(250)
	DECLARE @AllFinancialAssignments VARCHAR(1)
		,@FinancialAssignments VARCHAR(250)
	DECLARE @ChargeResponsibleDays INT
	DECLARE @ClientFirstLastName VARCHAR(25)
	DECLARE @ClientLastLastName VARCHAR(25)
	DECLARE @ClientLastNameCount INT = 0
	DECLARE @IncludeClientCharge CHAR(1)
	DECLARE @ExcludePayerCharges CHAR(1)
	DECLARE @ClientFinancialResponsible char(1)	 

	BEGIN TRY
		IF OBJECT_ID('tempdb..#RWQMRule') IS NOT NULL
			DROP TABLE #RWQMRule

		IF OBJECT_ID('tempdb..#RWQMRuleQueueItems') IS NOT NULL
			DROP TABLE #RWQMRuleQueueItems
		
		IF OBJECT_ID('tempdb..#RWQMRuleQueueItemsFA') IS NOT NULL
			DROP TABLE #RWQMRuleQueueItemsFA

		IF OBJECT_ID('tempdb..#RWQMRuleChargeActions') IS NOT NULL
			DROP TABLE #RWQMRuleChargeActions

		IF OBJECT_ID('tempdb..#RWQMRulePreviousActions') IS NOT NULL
			DROP TABLE #RWQMRulePreviousActions

		IF OBJECT_ID('tempdb..#RWQMRuleFinancialAssign') IS NOT NULL
			DROP TABLE #RWQMRuleFinancialAssign

		IF OBJECT_ID('tempdb..#ClientLastNameSearch') IS NOT NULL
			DROP TABLE #ClientLastNameSearch

		IF OBJECT_ID('tempdb..#GetFirstInitialChargeId') IS NOT NULL
			DROP TABLE #GetFirstInitialChargeId
		
		IF OBJECT_ID('tempdb..#GetInitialChargeFromChargeFilters') IS NOT NULL
			DROP TABLE #GetInitialChargeFromChargeFilters
				
		CREATE TABLE #GetFirstInitialChargeId (ChargeId INT)
		
		CREATE TABLE #GetInitialChargeFromChargeFilters (ChargeId INT)

		CREATE TABLE #RWQMRuleQueueItems (
			ChargeId INT
			,FinancialAssignmentId INT
			,DueDate DATE
			,OverdueDate DATE
			,RWQMRuleId INT
			,RWQMAssignedId INT
			,RWQMAssignedBackupId INT
			)
			
		CREATE TABLE #RWQMRuleQueueItemsFA (
			ChargeId INT
			,FinancialAssignmentId INT
			,RWQMRuleId INT
			,RWQMAssignedId INT
			,RWQMAssignedBackupId INT
			)
			
		CREATE TABLE #RWQMRule (
			RWQMRuleId INT
			,RulePriority INT
			,RuleType INT
			,RuleNumberOfDays INT
			,Balance MONEY
			,IncludeFlaggedCharges VARCHAR(1)
			,DaysToDueDate INT
			,DaysToOverdue INT
			,AllChargeActions VARCHAR(1)
			,ChargesActions VARCHAR(250)
			,AllChargeStatuses VARCHAR(1)
			,ChargeStatuses VARCHAR(250)
			,AllFinancialAssignments VARCHAR(1)
			,FinancialAssignments VARCHAR(250)
			,ClientLastNameFrom VARCHAR(25)
			,ClientLastNameTo VARCHAR(25)
			,ChargeResponsibleDays INT
			,ChargeIncludeClientCharge VARCHAR(1)
			,RWQMAssignedId INT
			,RWQMAssignedBackupId INT
			,ExcludePayerCharges VARCHAR(1)
			,ClientFinancialResponsible CHAR(1)
			)

		CREATE TABLE #RWQMRuleChargeActions (
			RWQMRuleId INT
			,RWQMActionId INT
			,ChargeStatus INT
			,PreviousActionId INT
			)

		CREATE TABLE #RWQMRuleFinancialAssign (
			RWQMRuleId INT
			,FinancialAssignmentId INT
			,FinancialAssignmentChargeClientLastNameFrom VARCHAR(25)
			,FinancialAssignmentChargeClientLastNameTo VARCHAR(25)
			,ChargeResponsibleDays INT
			,ChargeIncludeClientCharge VARCHAR(1)
			,RWQMAssignedId INT
			,RWQMAssignedBackupId INT
			,ExcludePayerCharges VARCHAR(1)
			,ClientFinancialResponsible CHAR(1)
			)

		CREATE TABLE #ClientLastNameSearch (LastNameSearch VARCHAR(50))

		CREATE TABLE #RWQMRulePreviousActions (
			RWQMRuleId INT
			,RWQMActionId INT
			,PreviousActionId INT
			)

		INSERT INTO #RWQMRule (
			RWQMRuleId
			,RulePriority
			,RuleType
			,RuleNumberOfDays
			,Balance
			,IncludeFlaggedCharges
			,DaysToDueDate
			,DaysToOverdue
			,AllChargeActions
			,ChargesActions
			,AllChargeStatuses
			,ChargeStatuses
			,AllFinancialAssignments
			,FinancialAssignments
			,ClientLastNameFrom 
			,ClientLastNameTo 
			,ChargeResponsibleDays 
			,ChargeIncludeClientCharge 
			,RWQMAssignedId 
			,ExcludePayerCharges 
			,ClientFinancialResponsible 
			)
		SELECT RR.RWQMRuleId
			,RR.RulePriority
			,RR.RuleType
			,RR.RuleNumberOfDays
			,--RR.RWQMRuleName,  
			RR.Balance
			,RR.IncludeFlaggedCharges
			,RR.DaysToDueDate
			,RR.DaysToOverdue
			,RR.AllChargeActions
			,RR.ChargesActions
			,RR.AllChargeStatuses
			,RR.ChargeStatuses
			,RR.AllFinancialAssignments
			,RR.FinancialAssignments
			,RR.FinancialAssignmentChargeClientLastNameFrom 
			,RR.FinancialAssignmentChargeClientLastNameTo 
			,RR.ChargeResponsibleDays 
			,RR.IncludeClientCharge 
			,RR.DefaultStaffId 
			,RR.ExcludePayerCharges 
			,RR.ClientFinancialResponsible 
		FROM RWQMRules RR
		WHERE cast(RR.StartDate AS DATE) <= cast(GetDate() AS DATE)
			AND (
				RR.EndDate IS NULL
				OR cast(RR.EndDate AS DATE) >= cast(GetDate() AS DATE)
				)
			AND ISnull(RR.RecordDeleted, 'N') = 'N'
			AND RR.Active = 'Y'

		--and RWQMRuleId in (1)  
		INSERT INTO #RWQMRuleChargeActions (
			RWQMRuleId
			,RWQMActionId
			,ChargeStatus
			) --PreviousActionId  
		SELECT DISTINCT r.RWQMRuleId
			,rc.RWQMActionId
			,rs.ChargeStatus
		FROM #RWQMRule r
		JOIN RWQMRuleChargeActions rc ON r.RWQMRuleId = rc.RWQMRuleId
			AND ISnull(rc.RecordDeleted, 'N') = 'N'
		Left JOIN RWQMActionChargeStatuses rs ON rs.RWQMActionId = rc.RWQMActionId
			AND ISnull(rs.RecordDeleted, 'N') = 'N'

		--select * from #RWQMRuleChargeActions  
		INSERT INTO #RWQMRulePreviousActions (
			RWQMRuleId
			,RWQMActionId
			,PreviousActionId
			)
		SELECT DISTINCT r.RWQMRuleId
			,rs.RWQMActionId
			,rs.PreviousActionId
		FROM #RWQMRule r
		JOIN RWQMRuleChargeActions rc ON r.RWQMRuleId = rc.RWQMRuleId
			AND ISnull(rc.RecordDeleted, 'N') = 'N'
		Left JOIN RWQMPreviousActions rs ON rs.RWQMActionId = rc.RWQMActionId
			AND ISnull(rs.RecordDeleted, 'N') = 'N'

		INSERT INTO #RWQMRuleFinancialAssign (
			RWQMRuleId
			,FinancialAssignmentId
			,FinancialAssignmentChargeClientLastNameFrom
			,FinancialAssignmentChargeClientLastNameTo
			,ChargeResponsibleDays
			,ChargeIncludeClientCharge
			,RWQMAssignedId
			,RWQMAssignedBackupId
			,ExcludePayerCharges
			,ClientFinancialResponsible
			)
		SELECT ra.RWQMRuleId
			,ra.FinancialAssignmentId
			,FA.FinancialAssignmentChargeClientLastNameFrom
			,FA.FinancialAssignmentChargeClientLastNameTo
			,FA.ChargeResponsibleDays
			,FA.ChargeIncludeClientCharge
			,FA.RWQMAssignedId
			,FA.RWQMAssignedBackupId
			,FA.ExcludePayerCharges
			,FA.ClientFinancialResponsible
		FROM RWQMRuleFinancialAssignments ra
		JOIN FinancialAssignments FA ON ra.FinancialAssignmentId = FA.FinancialAssignmentId
		WHERE ISnull(ra.RecordDeleted, 'N') = 'N'
			AND ISnull(FA.RecordDeleted, 'N') = 'N'
		
		INSERT INTO #RWQMRuleFinancialAssign (
			RWQMRuleId
			,FinancialAssignmentId
			,FinancialAssignmentChargeClientLastNameFrom
			,FinancialAssignmentChargeClientLastNameTo
			,ChargeResponsibleDays
			,ChargeIncludeClientCharge
			,RWQMAssignedId
			,RWQMAssignedBackupId
			,ExcludePayerCharges
			,ClientFinancialResponsible
			)
		SELECT ra.RWQMRuleId
			,FA1.FinancialAssignmentId
			,FA1.FinancialAssignmentChargeClientLastNameFrom
			,FA1.FinancialAssignmentChargeClientLastNameTo
			,FA1.ChargeResponsibleDays
			,FA1.ChargeIncludeClientCharge
			,FA1.RWQMAssignedId
			,FA1.RWQMAssignedBackupId
			,FA1.ExcludePayerCharges
			,FA1.ClientFinancialResponsible
		FROM #RWQMRule ra
		cross JOIN (Select top 1  FA.FinancialAssignmentId,FA.FinancialAssignmentChargeClientLastNameFrom
			,FA.FinancialAssignmentChargeClientLastNameTo
			,FA.ChargeResponsibleDays
			,FA.ChargeIncludeClientCharge
			,FA.RWQMAssignedId
			,FA.RWQMAssignedBackupId
			,FA.ExcludePayerCharges
			,FA.ClientFinancialResponsible
			From FinancialAssignments FA where ISnull(FA.RecordDeleted, 'N') = 'N') FA1
		WHERE ra.AllFinancialAssignments = 'Y'
		and not exists(Select 1 from #RWQMRuleFinancialAssign RF where ra.RWQMRuleId=RF.RWQMRuleId)
			
		
		--select * from #RWQMRulePreviousActions  
		--select * from #RWQMRuleFinancialAssign  
		--select * from #RWQMRule  
		DECLARE RWQMRuleCur CURSOR FAST_FORWARD
		FOR
		SELECT RR.RWQMRuleId
			,RR.RulePriority
			,RR.RuleType
			,RR.RuleNumberOfDays
			,--RR.RWQMRuleName,  
			RR.Balance
			,RR.IncludeFlaggedCharges
			,RR.DaysToDueDate
			,RR.DaysToOverdue
			,RR.AllChargeActions
			,RR.ChargesActions
			,RR.AllChargeStatuses
			,RR.ChargeStatuses
			,RR.AllFinancialAssignments
			,RR.FinancialAssignments
			,RR.ClientLastNameFrom --Rule Details tab
			,RR.ClientLastNameTo 
			,RR.ChargeResponsibleDays 
			,RR.ChargeIncludeClientCharge 
			,RR.ExcludePayerCharges 
			,RR.ClientFinancialResponsible 
		FROM #RWQMRule RR
		ORDER BY RR.RuleType ASC

		OPEN RWQMRuleCur

		FETCH RWQMRuleCur
		INTO @RWQMRuleId
			,@RulePriority
			,@RuleType
			,@RuleNumberOfDays
			,@Balance
			,@IncludeFlaggedCharges
			,@DaysToDueDate
			,@DaysToOverdue
			,@AllChargeActions
			,@ChargesActions
			,@AllChargeStatuses
			,@ChargeStatuses
			,@AllFinancialAssignments
			,@FinancialAssignments
			,@ClientFirstLastName
			,@ClientLastLastName
			,@ChargeResponsibleDays
			,@IncludeClientCharge
			,@ExcludePayerCharges
			,@ClientFinancialResponsible

		WHILE @@fetch_status = 0
		BEGIN
			TRUNCATE TABLE #ClientLastNameSearch
			
			INSERT INTO #ClientLastNameSearch
			EXEC dbo.ssp_SCGetPatientSearchValues @ClientFirstLastName
				,@ClientLastLastName

			IF EXISTS (
					SELECT 1
					FROM #ClientLastNameSearch
					)
			BEGIN
				SET @ClientLastNameCount = 1
			END
			-- Get charges from Charge details filter
			INSERT INTO #GetInitialChargeFromChargeFilters (ChargeId)		
			SELECT c.ChargeId
			FROM Charges c
			INNER JOIN Services s ON (c.ServiceId = s.ServiceId)
				AND isnull(s.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(c.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.ExcludeChargeFromQueue, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM #GetInitialChargeFromChargeFilters g
					WHERE c.ChargeId = g.chargeId
					)
				AND ISNULL(c.ChargeStatus, 0) <> 9458 -- Closed
				AND (
					SELECT SUM(oc.Amount)
					FROM ARLedger oc
					WHERE oc.ChargeId = c.ChargeId
						AND ISNULL(oc.RecordDeleted, 'N') = 'N'
					) > 0
				AND s.STATUS <> 76 -- Not include Error services
				AND (
					isnull(@Balance, 0) = 0
					OR (
						@Balance > 0
						AND (
							SELECT SUM(oc.Amount)
							FROM ARLedger oc
							WHERE oc.ChargeId = c.ChargeId
								AND ISNULL(oc.RecordDeleted, 'N') = 'N'
							) > isnull(@Balance, 0)
						)
					)
				AND (
					isnull(@IncludeFlaggedCharges, 'N') = 'N'
					OR (
						isnull(@IncludeFlaggedCharges, 'N') = 'Y'
						AND c.Flagged = 'Y'
						)
					)
				--X days after date of service  
				AND (
					(
						@RuleType = 9459
						AND cast(getdate() AS DATE) >= DateAdd(D, @RuleNumberOfDays, cast(s.DateOfService AS DATE))
						)
					OR --X days after bill date  
					(
						@RuleType = 9460
						AND c.FirstBilledDate <= DateAdd(D, @RuleNumberOfDays, cast(c.FirstBilledDate AS DATE))
						)
					OR --X days after charge transfer  
					(
						@RuleType = 9461
						AND EXISTS (
							SELECT 1
							FROM ArLedger ar
							WHERE ar.ChargeId = c.ChargeId
								AND ar.PostedDate <= DateAdd(D, @RuleNumberOfDays, cast(ar.PostedDate AS DATE))
								AND ar.LedgerType = 4204
								AND ISNULL(ar.RecordDeleted, 'N') = 'N'
							)
						)
					OR --X days after first statement  
					(
						@RuleType = 9462
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 csb.PrintedDate
								FROM ClientStatements cs
								JOIN ClientStatementBatches csb ON csb.ClientStatementBatchId = cs.ClientStatementBatchId
								WHERE (cs.ClientId = s.ClientId)
									AND ISNULL(cs.RecordDeleted, 'N') = 'N'
									AND ISNULL(csb.RecordDeleted, 'N') = 'N'
								ORDER BY csb.PrintedDate DESC
								) ab
							WHERE ab.PrintedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					OR --X days after action  
					(
						@RuleType = 9463
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 RW.ModifiedDate
								FROM RWQMWorkQueue RW
								WHERE c.ChargeId = RW.ChargeId
									AND RW.RWQMActionId IS NOT NULL
									AND ISNULL(RW.RecordDeleted, 'N') = 'N'
								ORDER BY RW.ModifiedDate DESC
								) ac
							WHERE ac.ModifiedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					OR --X days after Status  
					(
						@RuleType = 9464
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 CS.ModifiedDate
								FROM ChargeStatusHistory CS
								WHERE c.ChargeId = CS.ChargeId
									AND ISNULL(CS.RecordDeleted, 'N') = 'N'
								ORDER BY CS.ModifiedDate DESC
								) ah
							WHERE ah.ModifiedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					)
				AND (
					isnull(@AllChargeActions, 'N') = 'Y' -- include charge with following actions  
					OR (
						(
							EXISTS (
								SELECT 1
								FROM RWQMActions FA
								JOIN #RWQMRuleChargeActions RF ON FA.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllAllowedChargeStatus, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMActionChargeStatuses FAP
								JOIN #RWQMRuleChargeActions RF ON FAP.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAP.ChargeStatus = c.ChargeStatus
									AND isnull(FAP.RecordDeleted, 'N') = 'N'
								)
							)
						OR (
							EXISTS (
								SELECT 1
								FROM RWQMActions FA
								JOIN #RWQMRulePreviousActions RF ON FA.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllAllowedPreviousAction, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMPreviousActions FAPL
								JOIN #RWQMRulePreviousActions RF ON FAPL.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE EXISTS (
										SELECT 1
										FROM RWQMWorkQueue RW
										WHERE RW.ChargeId = c.ChargeId
											AND RW.RWQMActionId = FAPL.PreviousActionId
											AND isnull(RW.RecordDeleted, 'N') = 'N'
										)
								)
							)
						)
					)
			
			-- Now more filter on initial selected charge on client name ,Payers, Plan, Programs and others
			INSERT INTO #RWQMRuleQueueItems (
				ChargeId
				,RWQMRuleId
				)
			SELECT g.ChargeId
				,@RWQMRuleId
			FROM #GetInitialChargeFromChargeFilters g
			INNER JOIN Charges c ON (c.ChargeId = g.ChargeId)
			INNER JOIN Services s ON (c.ServiceId = s.ServiceId)
				AND isnull(s.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients cl ON (cl.ClientId = s.ClientId)
				AND (
					EXISTS (
						SELECT 1
						FROM #ClientLastNameSearch f
						WHERE cl.LastName collate DATABASE_DEFAULT LIKE F.LastNameSearch collate DATABASE_DEFAULT
						)
					OR (
						isnull(@ClientLastNameCount, 0) = 0
						AND cl.LastName = cl.LastName
						)
					)
			INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			LEFT JOIN ClientCoveragePlans b1 ON (c.ClientCoveragePlanId = b1.ClientCoveragePlanId)
			LEFT JOIN CoveragePlans cp ON (b1.CoveragePLanId = cp.CoveragePLanId)
			LEFT JOIN Payers d ON (cp.PayerId = d.PayerId)
			--left join GlobalCodes e on (d.PayerType = e.GlobalCodeId)  
			LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
			LEFT JOIN Programs pr ON pr.programId = s.programId
				AND ISNULL(pr.RecordDeleted, 'N') = 'N'
			LEFT JOIN ServiceAreas ser ON ser.ServiceAreaId = pr.ServiceAreaId
				AND ISNULL(ser.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(c.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM #RWQMRuleQueueItems R
					WHERE R.ChargeId = g.ChargeId
					)
				AND s.STATUS <> 76
				AND ( -- Include charge with following status
					@AllChargeStatuses = 'Y'
					OR EXISTS (
						SELECT 1
						FROM RWQMRuleChargeStatuses RR
						WHERE RR.RWQMRuleId = @RWQMRuleId
							AND RR.ChargeStatuses = c.ChargeStatus
							AND isnull(RR.RecordDeleted, 'N') = 'N'
						)
					)
				AND (
					( -- Payer Type
					EXISTS (	SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargePayerType, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRulePayerTypes RUPT
								WHERE RUPT.RWQMRuleId = @RWQMRuleId and RUPT.PayerTypeId = d.PayerType
									AND isnull(RUPT.RecordDeleted, 'N') = 'N'
								)
							)
						AND (-- coveragePlans
							EXISTS (SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargePlan, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRulePlans RPLA
								WHERE RPLA.RWQMRuleId = @RWQMRuleId and RPLA.CoveragePlanId = cp.CoveragePlanId
									AND isnull(RPLA.RecordDeleted, 'N') = 'N'
								)	
							)
						AND ( -- Payer Id
							EXISTS (SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargePayer, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRulePayers RRPS
								WHERE RRPS.RWQMRuleId = @RWQMRuleId and RRPS.PayerId = d.PayerId
									AND isnull(RRPS.RecordDeleted, 'N') = 'N'
								)		
							)
						AND ( -- Program
							EXISTS (	SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeProgram, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRulePrograms RRPR
								WHERE RRPR.RWQMRuleId = @RWQMRuleId and RRPR.ProgramId = s.ProgramId
									AND isnull(RRPR.RecordDeleted, 'N') = 'N'
								)
							)
						AND ( -- ProcedureCodeId
							EXISTS (	SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeProcedureCode, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRuleProcedureCodes RRPC
								WHERE RRPC.RWQMRuleId = @RWQMRuleId and RRPC.ProcedureCodeId = pc.ProcedureCodeId
									AND isnull(RRPC.RecordDeleted, 'N') = 'N'
								)
							)
						AND ( -- LocationId
							EXISTS (	SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeLocation, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMRuleLocations RRL
								WHERE RRL.RWQMRuleId = @RWQMRuleId and RRL.LocationId = s.LocationId
									AND isnull(RRL.RecordDeleted, 'N') = 'N'
								)
							)
						AND ( -- Adjustment codes
							EXISTS (	SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeAdjustmentCodes, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM ARLedger ar
								WHERE ar.ChargeId = c.ChargeId
									AND EXISTS (
										SELECT *
										FROM RWQMRuleAdjustmentCodes FAE
										WHERE FAE.RWQMRuleId = @RWQMRuleId and FAE.AdjustmentCodes = ar.AdjustmentCode
											AND isnull(FAE.RecordDeleted, 'N') = 'N'
										)
									AND isnull(ar.RecordDeleted, 'N') = 'N'
								)
							)
						AND ( --ServiceAreas
							EXISTS (SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeServiceArea, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM Programs P
								WHERE isnull(P.RecordDeleted, 'N') = 'N'
									AND EXISTS (
										SELECT 1
										FROM RWQMRuleServiceAreas FAS
										WHERE FAS.RWQMRuleId = @RWQMRuleId and P.ProgramId = s.ProgramId
											AND P.ServiceAreaId = FAS.ServiceAreaId
											AND isnull(FAS.RecordDeleted, 'N') = 'N'
										)
								)
							)
						AND ( --ErrorReasons 
							EXISTS (SELECT 1
								FROM RWQMRules RU
								WHERE RU.RWQMRuleId = @RWQMRuleId and isnull(RU.AllChargeErrorReason, 'N') = 'Y'
									AND isnull(RU.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM ChargeErrors che
								WHERE che.ChargeId = g.ChargeId
									AND EXISTS (
										SELECT *
										FROM RWQMRuleErrorReasons FAE
										WHERE FAE.ErrorReasonId = che.ErrorType
											and FAE.RWQMRuleId = @RWQMRuleId
											AND isnull(FAE.RecordDeleted, 'N') = 'N'
										)
									AND isnull(che.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							(
								SELECT  ISNULL(ChargeResponsibleDays, - 1)
								FROM RWQMRules RR
								WHERE RR.RWQMRuleId = @RWQMRuleId
								) = - 1
							OR (
								s.DateOfService < CASE 
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8980
										THEN convert(VARCHAR, dateadd(dd, - 90, getdate()), 101)
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8981
										THEN convert(VARCHAR, dateadd(dd, - 180, getdate()), 101)
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8982
										THEN convert(VARCHAR, dateadd(dd, - 360, getdate()), 101)
									END
								)
							)
						--                        and ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId)='Y'  
						--                        or ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId) = 'N'   
						--and c.Priority = 0 and c.ClientCoveragePlanId is null )  
						--                        or   ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId) = 'N'  
						--                            and c.Priority > 0))   
						AND ( ISNULL(@ExcludePayerCharges, 'N')= 'N'
							OR (
								(ISNULL(@ExcludePayerCharges, 'N')= 'Y'
								AND c.ClientCoveragePlanId IS NULL )
							)
							)
						AND ( 
								( ISNULL(@ClientFinancialResponsible, 'N') = 'N')
							OR (
								( ISNULL(@ClientFinancialResponsible, 'N') = 'C'
								AND ISNULL(cl.FinanciallyResponsible, 'N') = 'Y'
								)
								)
							OR (
								( ISNULL(@ClientFinancialResponsible, 'N') = 'F'
									AND EXISTS (
										SELECT 1
										FROM ClientContacts CC
										WHERE Cl.ClientId = CC.ClientId
											AND (
												ISNULL(Cl.FinanciallyResponsible, 'N') = 'Y'
												OR ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
												)
												)
								)
								)
							)
			)
			-- update #RWQMRuleQueueItems with DueDate,OverdueDate   
			UPDATE RW
			SET RW.DueDate = CASE 
					WHEN @DaysToDueDate >= 0
						THEN DateAdd(D, @DaysToDueDate, cast(Getdate() AS DATE))
					END
				,RW.OverdueDate = CASE 
					WHEN @DaysToOverdue >= 0
						THEN DateAdd(D, @DaysToOverdue, cast(Getdate() AS DATE))
					END
				,RW.FinancialAssignmentId = (
					SELECT TOP 1 RR.FinancialAssignmentId
					FROM #RWQMRuleFinancialAssign RR
					WHERE RR.RWQMRuleId = @RWQMRuleId
					)
				
			FROM #RWQMRuleQueueItems RW
			WHERE RW.RWQMRuleId = @RWQMRuleId
			
			-- Get Charges based on FinancialAssignments selection
			IF (ISNULL(@AllFinancialAssignments, 'N') = 'N'
				AND len(@FinancialAssignments) > 0) or (ISNULL(@AllFinancialAssignments, 'N') = 'ALL' 
					and (Select count(*) From FinancialAssignments where ISnull(RecordDeleted, 'N')='N')=1)
			BEGIN
				DECLARE RWQMFinCur CURSOR FAST_FORWARD
				FOR
				SELECT RR.FinancialAssignmentChargeClientLastNameFrom
					,RR.FinancialAssignmentChargeClientLastNameTo
				FROM #RWQMRuleFinancialAssign RR
				WHERE RR.RWQMRuleId = @RWQMRuleId

				OPEN RWQMFinCur

				FETCH RWQMFinCur
				INTO @ClientFirstLastName
					,@ClientLastLastName

				WHILE @@fetch_status = 0
				BEGIN
					INSERT INTO #ClientLastNameSearch
					EXEC dbo.ssp_SCGetPatientSearchValues @ClientFirstLastName
						,@ClientLastLastName

					IF EXISTS (
							SELECT 1
							FROM #ClientLastNameSearch
							)
					BEGIN
						SET @ClientLastNameCount = 1
					END

					FETCH RWQMFinCur
					INTO @ClientFirstLastName
						,@ClientLastLastName
				END -- Fetch  

				CLOSE RWQMFinCur

				DEALLOCATE RWQMFinCur
			END
			
			
			INSERT INTO #GetFirstInitialChargeId (ChargeId)
			SELECT c.ChargeId
			FROM Charges c
			INNER JOIN Services s ON (c.ServiceId = s.ServiceId)
				AND isnull(s.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(c.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.ExcludeChargeFromQueue, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM #GetFirstInitialChargeId g
					WHERE c.ChargeId = g.chargeId
					)
				AND ISNULL(c.ChargeStatus, 0) <> 9458 -- Closed
				AND (
					SELECT SUM(oc.Amount)
					FROM ARLedger oc
					WHERE oc.ChargeId = c.ChargeId
						AND ISNULL(oc.RecordDeleted, 'N') = 'N'
					) > 0
				AND s.STATUS <> 76
				AND (
					isnull(@Balance, 0) = 0
					OR (
						@Balance > 0
						AND (
							SELECT SUM(oc.Amount)
							FROM ARLedger oc
							WHERE oc.ChargeId = c.ChargeId
								AND ISNULL(oc.RecordDeleted, 'N') = 'N'
							) > isnull(@Balance, 0)
						)
					)
				AND (
					isnull(@IncludeFlaggedCharges, 'N') = 'N'
					OR (
						isnull(@IncludeFlaggedCharges, 'N') = 'Y'
						AND c.Flagged = 'Y'
						)
					)
				--X days after date of service  
				AND (
					(
						@RuleType = 9459
						AND cast(getdate() AS DATE) >= DateAdd(D, @RuleNumberOfDays, cast(s.DateOfService AS DATE))
						)
					OR --X days after bill date  
					(
						@RuleType = 9460
						AND c.FirstBilledDate <= DateAdd(D, @RuleNumberOfDays, cast(c.FirstBilledDate AS DATE))
						)
					OR --X days after charge transfer  
					(
						@RuleType = 9461
						AND EXISTS (
							SELECT 1
							FROM ArLedger ar
							WHERE ar.ChargeId = c.ChargeId
								AND ar.PostedDate <= DateAdd(D, @RuleNumberOfDays, cast(ar.PostedDate AS DATE))
								AND ar.LedgerType = 4204
								AND ISNULL(ar.RecordDeleted, 'N') = 'N'
							)
						)
					OR --X days after first statement  
					(
						@RuleType = 9462
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 csb.PrintedDate
								FROM ClientStatements cs
								JOIN ClientStatementBatches csb ON csb.ClientStatementBatchId = cs.ClientStatementBatchId
								WHERE (cs.ClientId = s.ClientId)
									AND ISNULL(cs.RecordDeleted, 'N') = 'N'
									AND ISNULL(csb.RecordDeleted, 'N') = 'N'
								ORDER BY csb.PrintedDate DESC
								) ab
							WHERE ab.PrintedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					OR --X days after action  
					(
						@RuleType = 9463
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 RW.ModifiedDate
								FROM RWQMWorkQueue RW
								WHERE c.ChargeId = RW.ChargeId
									AND RW.RWQMActionId IS NOT NULL
									AND ISNULL(RW.RecordDeleted, 'N') = 'N'
								ORDER BY RW.ModifiedDate DESC
								) ac
							WHERE ac.ModifiedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					OR --X days after Status  
					(
						@RuleType = 9464
						AND EXISTS (
							SELECT 1
							FROM (
								SELECT TOP 1 CS.ModifiedDate
								FROM ChargeStatusHistory CS
								WHERE c.ChargeId = CS.ChargeId
									AND ISNULL(CS.RecordDeleted, 'N') = 'N'
								ORDER BY CS.ModifiedDate DESC
								) ah
							WHERE ah.ModifiedDate <= DateAdd(D, (- 1) * @RuleNumberOfDays, cast(GetDate() AS DATE))
							)
						)
					)
				AND (
					isnull(@AllChargeActions, 'N') = 'Y' -- include charge with following actions  
					OR (
						(
							EXISTS (
								SELECT 1
								FROM RWQMActions FA
								JOIN #RWQMRuleChargeActions RF ON FA.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllAllowedChargeStatus, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMActionChargeStatuses FAP
								JOIN #RWQMRuleChargeActions RF ON FAP.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAP.ChargeStatus = c.ChargeStatus
									AND isnull(FAP.RecordDeleted, 'N') = 'N'
								)
							)
						OR (
							EXISTS (
								SELECT 1
								FROM RWQMActions FA
								JOIN #RWQMRulePreviousActions RF ON FA.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllAllowedPreviousAction, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM RWQMPreviousActions FAPL
								JOIN #RWQMRulePreviousActions RF ON FAPL.RWQMActionId = RF.RWQMActionId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE EXISTS (
										SELECT 1
										FROM RWQMWorkQueue RW
										WHERE RW.ChargeId = c.ChargeId
											AND RW.RWQMActionId = FAPL.PreviousActionId
											AND isnull(RW.RecordDeleted, 'N') = 'N'
										)
								)
							)
						)
					)

			-- include charge with following statuses ChargeStatus,Financial Assignments  
			INSERT INTO #RWQMRuleQueueItemsFA (
				ChargeId
				,RWQMRuleId
				)
			SELECT g.ChargeId
				,@RWQMRuleId
			FROM #GetFirstInitialChargeId g
			INNER JOIN Charges c ON (c.ChargeId = g.ChargeId)
			INNER JOIN Services s ON (c.ServiceId = s.ServiceId)
				AND isnull(s.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients cl ON (cl.ClientId = s.ClientId)
				AND (
					EXISTS (
						SELECT 1
						FROM #ClientLastNameSearch f
						WHERE cl.LastName collate DATABASE_DEFAULT LIKE F.LastNameSearch collate DATABASE_DEFAULT
						)
					OR (
						isnull(@ClientLastNameCount, 0) = 0
						AND cl.LastName = cl.LastName
						)
					)
			INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			LEFT JOIN ClientCoveragePlans b1 ON (c.ClientCoveragePlanId = b1.ClientCoveragePlanId)
			LEFT JOIN CoveragePlans cp ON (b1.CoveragePLanId = cp.CoveragePLanId)
			LEFT JOIN Payers d ON (cp.PayerId = d.PayerId)
			--left join GlobalCodes e on (d.PayerType = e.GlobalCodeId)  
			LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
			LEFT JOIN Programs pr ON pr.programId = s.programId
				AND ISNULL(pr.RecordDeleted, 'N') = 'N'
			LEFT JOIN ServiceAreas ser ON ser.ServiceAreaId = pr.ServiceAreaId
				AND ISNULL(ser.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(c.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM #RWQMRuleQueueItemsFA R
					WHERE R.ChargeId = g.ChargeId
					)
				AND s.STATUS <> 76
				AND (
					@AllChargeStatuses = 'Y'
					OR EXISTS (
						SELECT 1
						FROM RWQMRuleChargeStatuses RR
						WHERE RR.RWQMRuleId = @RWQMRuleId
							AND RR.ChargeStatuses = c.ChargeStatus
							AND isnull(RR.RecordDeleted, 'N') = 'N'
						)
					)
				AND (
					isnull(@AllFinancialAssignments, 'N') = 'Y'
					OR (
						(
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeProgram, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPrograms FAP
								JOIN #RWQMRuleFinancialAssign RF ON FAP.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAP.AssignmentType = 8979
									AND FAP.ProgramId = s.ProgramId
									AND isnull(FAP.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargePlan, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPlans FAPL
								JOIN #RWQMRuleFinancialAssign RF ON FAPL.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAPL.AssignmentType = 8979
									AND FAPL.CoveragePlanId = cp.CoveragePlanId
									AND isnull(FAPL.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargePayer, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPayers FAPP
								JOIN #RWQMRuleFinancialAssign RF ON FAPP.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAPP.AssignmentType = 8979
									AND FAPP.PayerId = d.PayerId
									AND isnull(FAPP.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargePayerType, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPayerTypes FAPT
								JOIN #RWQMRuleFinancialAssign RF ON FAPT.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAPT.PayerTypeId = d.PayerType
									AND FAPT.AssignmentType = 8979
									AND isnull(FAPT.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeProcedureCode, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentProcedureCodes FAPC
								JOIN #RWQMRuleFinancialAssign RF ON FAPC.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAPC.AssignmentType = 8979
									AND FAPC.ProcedureCodeId = pc.ProcedureCodeId
									AND isnull(FAPC.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeLocation, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentLocations FAL
								JOIN #RWQMRuleFinancialAssign RF ON FAL.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE FAL.AssignmentType = 8979
									AND FAL.LocationId = s.LocationId
									AND isnull(FAL.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeAdjustmentCodes, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM ARLedger ar
								WHERE ar.ChargeId = c.ChargeId
									AND EXISTS (
										SELECT *
										FROM FinancialAssignmentAdjustmentCodes FAE
										JOIN #RWQMRuleFinancialAssign RF ON FAE.FinancialAssignmentId = RF.FinancialAssignmentId
											AND RF.RWQMRuleId = @RWQMRuleId
										WHERE FAE.AdjustmentCodes = ar.AdjustmentCode
											AND FAE.AssignmentType = 8979
											AND isnull(FAE.RecordDeleted, 'N') = 'N'
										)
									AND isnull(ar.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeServiceArea, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM Programs P
								WHERE isnull(P.RecordDeleted, 'N') = 'N'
									AND EXISTS (
										SELECT 1
										FROM FinancialAssignmentServiceAreas FAS
										JOIN #RWQMRuleFinancialAssign RF ON FAS.FinancialAssignmentId = RF.FinancialAssignmentId
											AND RF.RWQMRuleId = @RWQMRuleId
										WHERE P.ProgramId = s.ProgramId
											AND P.ServiceAreaId = FAS.ServiceAreaId
											AND FAS.AssignmentType = 8979
											AND isnull(FAS.RecordDeleted, 'N') = 'N'
										)
								)
							)
						AND (
							EXISTS (
								SELECT 1
								FROM FinancialAssignments FA
								JOIN #RWQMRuleFinancialAssign RF ON FA.FinancialAssignmentId = RF.FinancialAssignmentId
									AND RF.RWQMRuleId = @RWQMRuleId
								WHERE isnull(FA.AllChargeErrorReason, 'N') = 'Y'
									AND isnull(FA.RecordDeleted, 'N') = 'N'
								)
							OR EXISTS (
								SELECT 1
								FROM ChargeErrors che
								WHERE che.ChargeId = g.ChargeId
									AND EXISTS (
										SELECT *
										FROM FinancialAssignmentErrorReasons FAE
										JOIN #RWQMRuleFinancialAssign RF ON FAE.FinancialAssignmentId = RF.FinancialAssignmentId
											AND RF.RWQMRuleId = @RWQMRuleId
										WHERE FAE.ErrorReasonId = che.ErrorType
											AND FAE.AssignmentType = 8979
											AND isnull(FAE.RecordDeleted, 'N') = 'N'
										)
									AND isnull(che.RecordDeleted, 'N') = 'N'
								)
							)
						AND (
							(
								SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
								FROM #RWQMRuleFinancialAssign RR
								WHERE RR.RWQMRuleId = @RWQMRuleId
								) = - 1
							OR (
								s.DateOfService < CASE 
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8980
										THEN convert(VARCHAR, dateadd(dd, - 90, getdate()), 101)
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8981
										THEN convert(VARCHAR, dateadd(dd, - 180, getdate()), 101)
									WHEN (
											SELECT TOP 1 ISNULL(ChargeResponsibleDays, - 1)
											FROM #RWQMRuleFinancialAssign RR
											WHERE RR.RWQMRuleId = @RWQMRuleId
											) = 8982
										THEN convert(VARCHAR, dateadd(dd, - 360, getdate()), 101)
									END
								)
							)
						--                        and ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId)='Y'  
						--                        or ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId) = 'N'   
						--and c.Priority = 0 and c.ClientCoveragePlanId is null )  
						--                        or   ((Select top 1 ISNULL(ChargeIncludeClientCharge,'N') From #RWQMRuleFinancialAssign RR Where RR.RWQMRuleId=@RWQMRuleId) = 'N'  
						--                            and c.Priority > 0))   
						AND (
							(
								SELECT TOP 1 ISNULL(ExcludePayerCharges, 'N')
								FROM #RWQMRuleFinancialAssign RR
								WHERE RR.RWQMRuleId = @RWQMRuleId
								) = 'N'
							OR (
								(
									SELECT TOP 1 ISNULL(ExcludePayerCharges, 'N')
									FROM #RWQMRuleFinancialAssign RR
									WHERE RR.RWQMRuleId = @RWQMRuleId
									) = 'Y'
								AND c.ClientCoveragePlanId IS NULL
								)
							)
						AND (
							(
								SELECT TOP 1 ISNULL(ClientFinancialResponsible, 'N')
								FROM #RWQMRuleFinancialAssign RR
								WHERE RR.RWQMRuleId = @RWQMRuleId
								) = 'N'
							OR (
								(
									SELECT TOP 1 ISNULL(ClientFinancialResponsible, 'N')
									FROM #RWQMRuleFinancialAssign RR
									WHERE RR.RWQMRuleId = @RWQMRuleId
									) = 'C'
								AND ISNULL(cl.FinanciallyResponsible, 'N') = 'Y'
								)
							)
						OR (
							(
								SELECT TOP 1 ISNULL(ClientFinancialResponsible, 'N')
								FROM #RWQMRuleFinancialAssign RR
								WHERE RR.RWQMRuleId = @RWQMRuleId
								) = 'F'
							AND EXISTS (
								SELECT 1
								FROM ClientContacts CC
								WHERE Cl.ClientId = CC.ClientId
									AND (
										ISNULL(Cl.FinanciallyResponsible, 'N') = 'Y'
										OR ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
										)
								)
							)
						)
					)

			-- update #RWQMRuleQueueItemsFA with AssignedId,AssignedBackupId   
			UPDATE RW
			SET RW.FinancialAssignmentId = (
					SELECT TOP 1 RR.FinancialAssignmentId
					FROM #RWQMRuleFinancialAssign RR
					WHERE RR.RWQMRuleId = @RWQMRuleId
					)
				,RW.RWQMAssignedId = (
					SELECT TOP 1 RR.RWQMAssignedId
					FROM #RWQMRuleFinancialAssign RR
					WHERE RR.RWQMRuleId = @RWQMRuleId
					)
				,RW.RWQMAssignedBackupId = (
					SELECT TOP 1 RR.RWQMAssignedBackupId
					FROM #RWQMRuleFinancialAssign RR
					WHERE RR.RWQMRuleId = @RWQMRuleId
					)
			FROM #RWQMRuleQueueItemsFA RW
			WHERE RW.RWQMRuleId = @RWQMRuleId

			--select * from #RWQMRuleQueueItemsFA  
			FETCH RWQMRuleCur
			INTO @RWQMRuleId
				,@RulePriority
				,@RuleType
				,@RuleNumberOfDays
				,@Balance
				,@IncludeFlaggedCharges
				,@DaysToDueDate
				,@DaysToOverdue
				,@AllChargeActions
				,@ChargesActions
				,@AllChargeStatuses
				,@ChargeStatuses
				,@AllFinancialAssignments
				,@FinancialAssignments
				,@ClientFirstLastName
				,@ClientLastLastName
				,@ChargeResponsibleDays
				,@IncludeClientCharge
				,@ExcludePayerCharges
				,@ClientFinancialResponsible
		END -- Fetch  

		CLOSE RWQMRuleCur

		DEALLOCATE RWQMRuleCur
		
		-- update #RWQMRuleQueueItems with RWQMAssignedId & RWQMAssignedBackupId for matching ChargeId
		UPDATE RW
			SET RW.RWQMAssignedId = RWF.RWQMAssignedId
				,RW.RWQMAssignedBackupId = RWF.RWQMAssignedBackupId 
			FROM #RWQMRuleQueueItems RW join #RWQMRuleQueueItemsFA RWF on RW.ChargeId= RWF.ChargeId
		
		-- update #RWQMRuleQueueItems RWQMAssignedId & RWQMAssignedBackupId with default StaffId for rule if it is null
		UPDATE RW
			SET RW.RWQMAssignedId = RWF.DefaultStaffId
				,RW.RWQMAssignedBackupId = RWF.DefaultStaffId
			FROM #RWQMRuleQueueItems RW join RWQMRules RWF on RW.RWQMRuleId= RWF.RWQMRuleId
			Where (RW.RWQMAssignedId is null or RW.RWQMAssignedBackupId is null)
			
			
		INSERT INTO RWQMWorkQueue (
			ChargeId
			,FinancialAssignmentId
			,RWQMRuleId
			,DueDate
			,OverdueDate
			,RWQMAssignedId
			,RWQMAssignedBackupId
			)
		SELECT RR.ChargeId
			,RR.FinancialAssignmentId
			,RR.RWQMRuleId
			,RR.DueDate
			,RR.OverdueDate
			,RR.RWQMAssignedId
			,RR.RWQMAssignedBackupId
		FROM #RWQMRuleQueueItems RR
		WHERE NOT EXISTS (
				SELECT 1
				FROM RWQMWorkQueue RW
				WHERE RR.ChargeId = RW.ChargeId
					AND RW.RWQMActionId IS NULL
					AND ISNULL(RW.RecordDeleted, 'N') = 'N'
				)
			--select * from #RWQMRuleQueueItems  
			--select * from RWQMWorkQueue  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(MAX)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateRWQMWorkQueueItems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                   
				16
				,
				-- Severity.                                                                                   
				1
				-- State.                                                                                   
				);
	END CATCH
END

GO


