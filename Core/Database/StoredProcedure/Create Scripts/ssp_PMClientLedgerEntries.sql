/****** Object:  StoredProcedure [dbo].[ssp_PMClientLedgerEntries]    Script Date: 10/14/2015 20:01:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientLedgerEntries]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMClientLedgerEntries]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientLedgerEntries]    Script Date: 10/14/2015 20:01:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMClientLedgerEntries]
	/* Param List */
	@ServiceId INT
	,@Payers INT
	,@ExcludeError CHAR(1)
AS
/******************************************************************************      
**  File: dbo.ssp_PMClientLedgerEntries.prc      
**  Name: ssp_PMClientLedgerEntries      
**  Desc: This sp returns the Ledger data for a service      
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:         
**                    
**  Parameters:      
**  Input       Output      
**     ----------      -----------      
**  @ServiceId      Ledger data.      
**  Auth: Mary Suma     
**  Date: 21-Jul-2011      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:			Author:			Description:      
**  --------		--------   -------------------------------------------      
	27.07.2011		Suma		Modified to CR, based on FinancialActivityType and to handle filter valeus on change 
								of Dropdown values 
	28.09.2011		Suma		Updated -2 for Client 
	29.11.2011		Suma		Included PAyer in Select 
    14.06.2012		Suma		Made Amount as -Amount  
    01.07.2012		Suma		Including Error Ledgers  
	01.07.2012		Pselvan		For Ace PMWebIssues #9
	08.Jan.2013		Rohith		Modified value from -3 to -1 for All payer dropdown
	06.May.2014		Venkatesh	Convert into the decimal fro task #1440 in corebugs
	06.May.2014		Venkatesh	Convert into the decimal fro task #1440 in corebugs
	15.Oct.2015		vkhare	    Added  adjustment code field
	05.Apr.2016		Alok Kumar	Added query to return one more column 'ServiceStatus' in 'Table: 05 ArLedger Entries' for task#305 Engineering Improvement Initiatives- NBL(I)
	12.Dec.2016    Chita Ranjan  Changed the length of variable ProcedureName from Varchar(50) to varchar(200) for task #74 Keystone - Customizations
/******************************************************************************      
**      Table: 00 ServiceDetail      
******************************************************************************/      */
BEGIN
	BEGIN TRY
		SELECT CONVERT(VARCHAR, S.DATEOFSERVICE, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DATEOFSERVICE, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DATEOFSERVICE, 100), 18, 3)) AS DATEOFSERVICE
			,CASE 
				WHEN PC.AllowDecimals = 'Y'
					THEN PC.DISPLAYAS + ' ' + CONVERT(VARCHAR, CONVERT(DECIMAL(18, 2), S.UNIT)) + ' ' + G.CODENAME -- Modified by Venkatesh       
				ELSE PC.DISPLAYAS + ' ' + CONVERT(VARCHAR, CONVERT(DECIMAL(18, 2), CONVERT(INT, S.UNIT))) + ' ' + G.CODENAME
				END ProcedureName
		FROM SERVICES S
		LEFT JOIN PROCEDURECODES PC ON S.PROCEDURECODEID = PC.PROCEDURECODEID
		LEFT JOIN GLOBALCODES G ON S.UNITTYPE = G.GLOBALCODEID
		WHERE S.SERVICEID = @ServiceId
			AND (
				S.RECORDDELETED IS NULL
				OR S.RECORDDELETED = 'N'
				)

		/******************************************************************************      
**      Table: 01 PayerDetail      
******************************************************************************/
		CREATE TABLE #ChargeSummary (
			Identity1 [bigint] IDENTITY(1, 1) NOT NULL
			,ServiceId INT
			,FlaggedImg INT
			,ProcedureName VARCHAR(200)--Added by Chita Ranjan
			,Charges MONEY
			,UnBilled VARCHAR(20)
			,Payments MONEY
			,Adj MONEY
			,Balance MONEY
			,Priority INT
			,ChargeId INT
			,RecordDeleted CHAR
			)

		INSERT INTO #ChargeSummary (
			ServiceId
			,FlaggedImg
			,ProcedureName
			,Charges
			,Unbilled
			,Payments
			,Adj
			,Balance
			,Priority
			,ChargeId
			,RecordDeleted
			)
		SELECT a.ServiceId
			,sum(CASE 
					WHEN FAL.Flagged = 'Y'
						THEN 1
					ELSE 0
					END)
			,isnull(RTRIM(cp.DisplayAs) + ' ' + isnull(e.InsuredId, ''), 'Client')
			,sum(CASE 
					WHEN c.LedgerType IN (
							4201
							,4204
							)
						THEN c.Amount
					ELSE 0
					END)
			,CASE cp.Capitated
				WHEN 'Y'
					THEN 'Capitated'
				ELSE convert(VARCHAR, sum(CASE 
								WHEN b.LastBilledDate IS NULL
									THEN c.Amount
								ELSE 0
								END))
				END
			,sum(CASE 
					WHEN c.LedgerType = 4202
						THEN c.Amount
					ELSE 0
					END)
			,sum(CASE 
					WHEN c.LedgerType = 4203
						THEN c.Amount
					ELSE 0
					END)
			,sum(c.Amount)
			,b.Priority
			,b.ChargeId
			,a.RecordDeleted
		FROM Services a
		JOIN Charges b ON (a.ServiceId = b.ServiceId)
		JOIN ARLedger c ON (b.ChargeId = c.ChargeId)
		LEFT JOIN FinancialActivityLines FAL ON FAL.FinancialActivityLineId = c.FinancialActivityLineId
		LEFT JOIN ClientCoveragePlans e ON (b.ClientCoveragePlanId = e.ClientCoveragePlanId)
		LEFT JOIN Coverageplans Cp ON e.CoveragePlanId = cp.CoveragePlanId
		WHERE a.ServiceId = @ServiceId
			AND isnull(a.RecordDeleted, 'N') <> 'Y'
			AND isnull(b.RecordDeleted, 'N') <> 'Y'
			AND isnull(c.RecordDeleted, 'N') <> 'Y'
		GROUP BY a.ServiceId
			,Cp.DisplayAs
			,e.InsuredId
			,cp.Capitated
			,b.Priority
			,b.ChargeId
			,a.RecordDeleted

		SELECT Identity1
			,ServiceId
			,CASE 
				WHEN FlaggedImg > 0
					THEN 1
				ELSE 0
				END FlaggedImg
			,ProcedureName AS Payer
			,Charges --'$' + Convert(Varchar,Charges,20) as Charges         
			,CASE 
				WHEN UnBilled = 'Capitated'
					THEN 'Capitated'
				ELSE '$' + UnBilled
				END AS UnBilled
			,Payments --'$' + Convert(Varchar,Payments,20) as Payments         
			,Adj --'$' + Convert(Varchar,Adj,20) as Adj           
			,Balance --'$' + Convert(Varchar,Balance,20) as Balance  
			,RecordDeleted
		FROM #ChargeSummary
		ORDER BY Priority ASC

		/******************************************************************************      
**      Table: 02 Charge/Current Total Balance      
******************************************************************************/
		SELECT (
				SELECT CONVERT(VARCHAR, S.DATEOFSERVICE, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DATEOFSERVICE, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DATEOFSERVICE, 100), 18, 3)) AS DateOfService
				FROM SERVICES S
				WHERE S.SERVICEID = @ServiceId
					AND (
						S.RECORDDELETED IS NULL
						OR S.RECORDDELETED = 'N'
						)
				) DOS
			,(
				SELECT PC.DISPLAYAS + ' ' + CONVERT(VARCHAR, CONVERT(DECIMAL(18, 2), S.UNIT), 6) + ' ' + G.CODENAME AS ProcedureName -- Modified by Venkatesh      
				FROM SERVICES S
				LEFT JOIN PROCEDURECODES PC ON S.PROCEDURECODEID = PC.PROCEDURECODEID
				LEFT JOIN GLOBALCODES G ON S.UNITTYPE = G.GLOBALCODEID
				WHERE S.SERVICEID = @ServiceId
					AND (
						S.RECORDDELETED IS NULL
						OR S.RECORDDELETED = 'N'
						)
				) 'Procedure'
			,CASE 
				WHEN SUM(Charges) IS NULL
					THEN '$0'
				ELSE '$' + Convert(VARCHAR, SUM(Charges), 20)
				END AS CurrentCharge
			,CASE 
				WHEN SUM(Balance) IS NULL
					THEN '$0'
				ELSE '$' + Convert(VARCHAR, SUM(Balance), 20)
				END AS CurrentTotalBalance
		FROM #ChargeSummary
		WHERE ServiceId = @ServiceId

		--DROP TABLE #ChargeSummary      
		/******************************************************************************      
**      Table: 03 Payers for service      
******************************************************************************/
		SELECT C.ChargeId
			,CASE 
				WHEN C.ClientCoveragePlanId IS NOT NULL
					THEN RTRIM(Cp.DisplayAs) + ' ' + isnull(CCP.InsuredId, '')
				ELSE 'Client'
				END AS ProcedureName
			,
			-- P.PayerId,      
			Cp.coveragePlanId
			,S.ClientId
			,C.Priority
			,CASE 
				WHEN C.ClientCoveragePlanId IS NOT NULL
					THEN Cp.coveragePlanId
				ELSE S.ClientId
				END AS Payer
		FROM Services S
		LEFT JOIN Charges C ON S.ServiceId = C.ServiceId
		LEFT JOIN ClientCoveragePlans CCP ON C.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		LEFT JOIN CoveragePlans Cp ON CCP.CoveragePlanId = Cp.CoveragePlanId
		WHERE S.ServiceId = @ServiceId
			AND (
				s.RecordDeleted IS NULL
				OR s.RecordDeleted = 'N'
				)
			AND EXISTS (
				SELECT *
				FROM arledger
				WHERE chargeid = C.ChargeId
				)
		
		UNION
		
		SELECT NULL ChargeId
			,' Make adjustment to..' AS ProcedureName
			,NULL coveragePlanId
			,NULL ClientId
			,NULL Priority
			,NULL Payer
		ORDER BY Priority

		/******************************************************************************      
**      Table: 04 Payer of all services of a client      
******************************************************************************/
		SELECT isnull(C.ClientCoveragePlanId, - 2) AS ClientCoveragePlanId
			,isnull(RTRIM(Cp.DisplayAs) + ' ' + isnull(CCP.InsuredId, ''), 'Client') AS ProcedureName
		FROM Services S
		LEFT JOIN Charges C ON S.ServiceId = C.ServiceId
		LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
		LEFT JOIN CoveragePlans Cp ON CCP.CoveragePlanId = Cp.CoveragePlanId
		WHERE S.ClientId = (
				SELECT ClientId
				FROM Services
				WHERE ServiceID = @ServiceId
				)
			AND (
				s.RecordDeleted IS NULL
				OR s.RecordDeleted = 'N'
				)
		
		UNION
		
		SELECT - 1 AS ClientCoveragePlanId
			,'All Payers' AS ProcedureName

		/******************************************************************************      
**      Table: 05 ArLedger Entries.      
******************************************************************************/
		IF OBJECT_ID('#FinancialActivitySummary') IS NOT NULL
		BEGIN
			DROP TABLE #FinancialActivitySummary;
		END
		
		--05.Apr.2016	Added by Alok Kumar for task#305 Engineering Improvement Initiatives- NBL(I)
		DECLARE @ServiceStatus int;
		Select @ServiceStatus = S.Status  FROM Services S WHERE S.ServiceId=@ServiceId 

		SELECT A.ArLedgerId
			,FA.FinancialActivityId
			,FAL.FinancialActivityLineId
			,P.PaymentId
			,@ServiceId AS ServiceId
			,A.ChargeId
			,PostedDate
			,GC.GlobalCodeId
			,GC.CodeName AS Activity
			,isnull(RTRIM(Cp.DisplayAs) + ' ' + isnull(CCP.InsuredId, ''), 'Client') AS Payer
			,GCL.CodeName AS Type
			,A.Amount
			,P.ReferenceNumber
			,FAL.Comment
			,isnull(MarkedAsError, 'N') AS MarkedAsError
			,A.CreatedBy
			,A.CreatedDate
			,CH.ClientCoveragePlanId
			,isnull(ErrorCorrection, 'N') AS ErrorCorrection
			,A.RecordDeleted
			,A.AccountingPeriodId
			,CASE 
				WHEN FAL.Flagged = 'Y'
					THEN 1
				ELSE 0
				END AS FlaggedButton
			,FAL.CurrentVersion
			,dbo.ssf_GetGlobalCodeNameById(A.AdjustmentCode) As AdjustmentCode
			,@ServiceStatus AS ServiceStatus		--05.Apr.2016	Added by Alok Kumar for task#305 Engineering Improvement Initiatives- NBL(I)
		INTO #FinancialActivitySummary
		FROM ArLedger A
		LEFT JOIN FinancialActivityLines FAL ON FAL.FinancialActivityLineId = A.FinancialActivityLineId
		LEFT JOIN FinancialActivities FA ON FA.FinancialActivityId = FAL.FinancialActivityId
		LEFT JOIN Payments P ON FA.FinancialActivityId = P.FinancialActivityId
		LEFT JOIN GlobalCodes GC ON FA.ActivityType = GC.GlobalCodeID
		LEFT JOIN GlobalCodes GCL ON A.LedgerType = GCL.GlobalCodeID
		LEFT JOIN Charges CH ON A.ChargeId = CH.ChargeId
		LEFT JOIN ClientCoveragePlans CCP ON CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		LEFT JOIN CoveragePlans Cp ON CP.CoveragePlanId = CCP.CoveragePlanId
		WHERE A.ChargeId IN (
				SELECT ChargeId
				FROM Charges
				WHERE ServiceID = @ServiceId
				)
			--AND ISNULL(A.MarkedAsError,'N')='N'  
			AND (
				A.RecordDeleted IS NULL
				OR A.RecordDeleted = 'N'
				)
			AND (
				@Payers = - 1
				OR CCP.ClientCoveragePlanId = @Payers
				OR (
					@Payers = - 2
					AND CP.CoveragePlanId IS NULL
					)
				)
		--AND 
		--(@ExcludeError = 'N' OR (@ExcludeError= 'Y'  ))
		--AND ISNULL(MarkedAsError,'N')='N'
		--AND ISNULL(ErrorCorrection,'N')= 'N' --Filter for ErrorCorrection since deleted Ledger Entries cannot be displayed.
		--AND A.Amount !=0 -- Filter to check if this is deleted from Ledger
		ORDER BY PostedDate DESC
			,LedgerType DESC

		-- 
		--DELETE FROM #FinancialActivitySummary  
		--	     WHERE FinancialActivityLineId not in 
		--	 (select fs.FinancialActivityLineId from #FinancialActivitySummary fs join ARLedger ar 
		--			on fs.FinancialActivityLineId = ar.FinancialActivityLineId 
		--			where 
		--			fs.CurrentVersion = ar.FinancialActivityVersion )
		IF (@ExcludeError = 'Y')
			DELETE
			FROM #FinancialActivitySummary
			WHERE MarkedAsError = 'Y'
				OR ErrorCorrection = 'Y'

		SELECT ArLedgerId
			,FinancialActivityId
			,FinancialActivityLineId
			,PaymentId
			,ServiceId
			,ChargeId
			,PostedDate
			,GlobalCodeId
			,Activity
			,Payer
			,Type
			,Amount AS Amount
			,ReferenceNumber
			,Comment
			,MarkedAsError
			,CreatedBy
			,CreatedDate
			,ClientCoveragePlanId
			,ErrorCorrection
			,RecordDeleted
			,AccountingPeriodId
			,FlaggedButton
			,CurrentVersion
			,AdjustmentCode
			,ServiceStatus			--05.Apr.2016	Added by Alok Kumar for task#305 Engineering Improvement Initiatives- NBL(I)
		FROM #FinancialActivitySummary
			/******************************************************************************      
**      Table: 06 FinancialActivity Types      
******************************************************************************/
			--select GlobalCodeId,
			--		CodeName,
			--		Category
			-- from 
			--		GlobalCodes 
			-- where 
			--		Category like 'FINANCIALACTIVITY' 
			-- AND
			-- Active = 'Y'
			-- AND 
			-- ISNULL(RecordDeleted,'N')='N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientLedgerEntries') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO


