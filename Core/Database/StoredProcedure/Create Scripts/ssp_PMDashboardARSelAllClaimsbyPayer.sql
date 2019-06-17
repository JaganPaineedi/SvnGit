/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardARSelAllClaimsbyPayer]    Script Date: 10/15/2015 09:57:45 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDashboardARSelAllClaimsbyPayer]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMDashboardARSelAllClaimsbyPayer]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMDashboardARSelAllClaimsbyPayer]    Script Date: 10/15/2015 09:57:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMDashboardARSelAllClaimsbyPayer] --550,'2015-06-09 13:02:37.167'
	(
	@StaffId INT
	,@DOS VARCHAR(10)
	,@FinancialAssignmentId INT  
	)
AS
BEGIN
	BEGIN TRY
		/******************************************************************************    
		**  File: dbo.ssp_PMDashboardARSelAllClaimsbyPayer.prc    
		**  Name: dbo.ssp_PMDashboardARSelAllClaimsbyPayer    
		**  Desc: This SP returns the data required by dashboard  for Account Receivable  
		**    
		**  This template can be customized:    
		**                  
		**  Return values:    
		**     
		**  Called by:       
		**                  
		**  Parameters:    
		**  Input       Output    
		**     ----------       -----------    
		**    
		**  Auth: Veena S Mani
		**  Date:  09/06/2015    
		*******************************************************************************    
		**  Change History    
		*******************************************************************************    
		**  Date:     Author:     Description:    
		**  --------  --------    -------------------------------------------    
		15.Oct.15		Shankha		Added Capitated = N/NULL for CoverPlan JOIN Woodlands - Support> 177
		10.Nov.15		Shankha		Removed Capitated check and made LEFT join for ClientCoveragePlans and CoveragePlans to allow Client totals
		21.Dec.15		Rohith uppin	Design modified & FinancialAssignment filter added. Task#535 Harbour Support.
		19.Aug.16		Gautam      Removed the hard coded StaffId ,Task #640, Thresholds - Support > SC: AR Widgets - Total not the same (6/10)
		*******************************************************************************/
		DECLARE @Id INT
			,@Amount MONEY
			,@Date DATETIME
			,@local_StaffId INT
			,@local_DOS VARCHAR(10)

		SET @local_StaffId = @StaffId
		SET @local_DOS = @DOS
		
		  DECLARE @ChargeResponsibleDays VARCHAR(MAX)  
		  DECLARE @ClientFirstLastName VARCHAR(25)  
		  DECLARE @ClientLastLastName VARCHAR(25)  
		  DECLARE @ClientLastNameCount INT = 0  
		  	  
		  CREATE TABLE #ClientLastNameSearch (LastNameSearch VARCHAR(50))  
		  
		  IF ISNULL(@FinancialAssignmentId, - 1) <> - 1  
		  BEGIN  
		   SELECT @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom  
			,@ClientLastLastName = FinancialAssignmentChargeClientLastNameTo  
		   FROM FinancialAssignments  
		   WHERE FinancialAssignmentId = @FinancialAssignmentId  
			AND ISNULL(RecordDeleted, 'N') = 'N'  
		  
		   INSERT INTO #ClientLastNameSearch  
		   EXEC ssp_SCGetPatientSearchValues @ClientFirstLastName  
			,@ClientLastLastName  
		  
		   IF EXISTS (  
			 SELECT 1  
			 FROM #ClientLastNameSearch  
			 )  
		   BEGIN  
			SET @ClientLastNameCount = 1  
		   END  
		  END  
		  
		  IF ISNULL(@FinancialAssignmentId, - 1) <> - 1  
		   SET @ChargeResponsibleDays = (  
			 SELECT ChargeResponsibleDays  
			 FROM FinancialAssignments  
			 WHERE FinancialAssignmentId = @FinancialAssignmentId  
			  AND ISNULL(RecordDeleted, 'N') = 'N'  
			 )  
		    

		CREATE TABLE #T1 (
			[Id] INT IDENTITY(101, 1)
			,PayerId INT
			,PayerName VARCHAR(50)
			,[0-30] MONEY DEFAULT 0
			,[31-60] MONEY DEFAULT 0
			,[61-90] MONEY DEFAULT 0
			,[91-120] MONEY DEFAULT 0
			,[121-150] MONEY DEFAULT 0
			,[151-180] MONEY DEFAULT 0
			,[181-365] MONEY DEFAULT 0
			,[>1 Year] MONEY DEFAULT 0
			,Total MONEY DEFAULT 0
			,Filter VARCHAR(10) DEFAULT 'DOS'
			)

		DECLARE @CurrentDate DATETIME

		SELECT @CurrentDate = CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))

		INSERT INTO #T1 (
			PayerId
			,PayerName
			,[0-30]
			,[31-60]
			,[61-90]
			,[91-120]
			,[121-150]
			,[151-180]
			,[181-365]
			,[>1 Year]
			,Total
			)
		SELECT --CASE WHEN b.Priority = 0 THEN 0
			--  ELSE 
			d.PayerId
			-- END
			,
			-- CASE WHEN b.Priority = 0 THEN
			-- 'Client'
			-- ELSE 
			d.PayerName
			--END 
			,[0-30] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) <= 30
						THEN a.Balance
					ELSE 0
					END)
			,[31-60] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 31
							AND 60
						THEN a.Balance
					ELSE 0
					END)
			,[61-90] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 61
							AND 90
						THEN a.Balance
					ELSE 0
					END)
			,[91-120] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 91
							AND 120
						THEN a.Balance
					ELSE 0
					END)
			,[121-150] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 121
							AND 150
						THEN a.Balance
					ELSE 0
					END)
			,[151-180] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 151
							AND 180
						THEN a.Balance
					ELSE 0
					END)
			,[181-365] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 181
							AND 365
						THEN a.Balance
					ELSE 0
					END)
			,[>1 Year] = SUM(CASE 
					WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) > 365
						THEN a.Balance
					ELSE 0
					END)
			,Total = SUM(a.Balance)
		FROM OpenCharges a
		JOIN Charges b ON (a.ChargeId = b.ChargeId)
			AND ISNULL(b.RecordDeleted, 'N') = 'N' --AND  b.Priority <> 0 
		JOIN Services g ON (b.ServiceId = g.ServiceId)
			AND ISNULL(g.RecordDeleted, 'N') = 'N'
		JOIN Clients cl ON (cl.ClientId = g.ClientId)
			--AND ISNULL(cl.RecordDeleted, 'N') = 'N'
		 JOIN ClientCoveragePlans b1 ON (b.ClientCoveragePlanId = b1.ClientCoveragePlanId)		-- Shankha 11/10
			AND ISNULL(b1.RecordDeleted, 'N') = 'N'
		LEFT JOIN CoveragePlans c ON (b1.CoveragePLanId = c.CoveragePLanId)							-- Shankha 11/10				
			--AND ISNULL(c.RecordDeleted, 'N') = 'N'
		LEFT JOIN Payers d ON (c.PayerId = d.PayerId)
			--AND ISNULL(d.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes e ON (d.PayerType = e.GlobalCodeId)
		LEFT JOIN Staff st ON st.StaffId = g.ClinicianId
			--AND ISNULL(st.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes pc ON pc.ProcedureCodeId = g.ProcedureCodeId
			--AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		--Moved this to join
		JOIN StaffClients sc ON sc.StaffId = @local_StaffId
			AND sc.ClientId = cl.ClientId
		WHERE ( ( ISNULL(b.DoNotBill,'N')='N' ) OR ( b.LastBilledDate IS NOT NULL AND ISNULL(b.DoNotBill,'N') = 'Y' ) )
		AND
		(ISNULL(@FinancialAssignmentId, - 1) = - 1  
				OR (  
				 (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargeProgram, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentPrograms FAP  
				   WHERE FAP.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAP.AssignmentType = 8979  
					AND FAP.ProgramId = g.ProgramId  
					AND ISNULL(FAP.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargePlan, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentPlans FAPL  
				   WHERE FAPL.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAPL.AssignmentType = 8979  
					AND FAPL.CoveragePlanId = c.CoveragePlanId  
					AND ISNULL(FAPL.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargePayer, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentPayers FAPP  
				   WHERE FAPP.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAPP.AssignmentType = 8979  
					AND FAPP.PayerId = d.PayerId  
					AND ISNULL(FAPP.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargePayerType, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentPayerTypes FAPT  
				   WHERE FAPT.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAPT.PayerTypeId = d.PayerType  
					AND FAPT.AssignmentType = 8979  
					AND ISNULL(FAPT.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargeProcedureCode, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentProcedureCodes FAPC  
				   WHERE FAPC.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAPC.AssignmentType = 8979  
					AND FAPC.ProcedureCodeId = pc.ProcedureCodeId  
					AND ISNULL(FAPC.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargeLocation, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignmentLocations FAL  
				   WHERE FAL.FinancialAssignmentId = @FinancialAssignmentId  
					AND FAL.AssignmentType = 8979  
					AND FAL.LocationId = g.LocationId  
					AND ISNULL(FAL.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargeServiceArea, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM Programs P  
				   WHERE ISNULL(P.RecordDeleted, 'N') = 'N'  
					AND EXISTS (  
					 SELECT 1  
					 FROM FinancialAssignmentServiceAreas FAS  
					 WHERE FAS.FinancialAssignmentId = @FinancialAssignmentId  
					  AND P.ProgramId = g.ProgramId  
					  AND P.ServiceAreaId = FAS.ServiceAreaId  
					  AND FAS.AssignmentType = 8979  
					  AND ISNULL(FAS.RecordDeleted, 'N') = 'N'  
					 )  
				   )  
				  )  
				 AND (  
				  EXISTS (  
				   SELECT 1  
				   FROM FinancialAssignments  
				   WHERE FinancialAssignmentId = @FinancialAssignmentId  
					AND ISNULL(AllChargeErrorReason, 'N') = 'Y'  
					AND ISNULL(RecordDeleted, 'N') = 'N'  
				   )  
				  OR EXISTS (  
				   SELECT 1  
				   FROM ChargeErrors che  
				   WHERE che.ChargeId = a.ChargeId  
					AND EXISTS (  
					 SELECT *  
					 FROM FinancialAssignmentErrorReasons FAE  
					 WHERE FAE.ErrorReasonId = che.ErrorType  
					  AND FAE.AssignmentType = 8979  
					  AND ISNULL(FAE.RecordDeleted, 'N') = 'N'  
					 )  
					AND ISNULL(che.RecordDeleted, 'N') = 'N'  
				   )  
				  )  
				 AND (  
				  ISNULL(@ChargeResponsibleDays, - 1) = - 1  
				  OR (  
				   g.DateOfService < CASE   
					WHEN @ChargeResponsibleDays = 8980  
					 THEN CONVERT(VARCHAR, DATEADD(dd, - 90, GETDATE()), 101)  
					WHEN @ChargeResponsibleDays = 8981  
					 THEN CONVERT(VARCHAR, DATEADD(dd, - 180, GETDATE()), 101)  
					WHEN @ChargeResponsibleDays = 8982  
					 THEN CONVERT(VARCHAR, DATEADD(dd, - 360, GETDATE()), 101)  
					END  
				   )  
				  )  
				 )  
				)
		GROUP BY --CASE WHEN b.Priority = 0 THEN 0
			--ELSE
			d.PayerId
			--END 
			,
			--CASE WHEN b.Priority = 0 THEN 'Client'
			--   ELSE 
			d.PayerName

		--  END  
		INSERT INTO #T1 (
			PayerId
			,PayerName
			,[0-30]
			,[31-60]
			,[61-90]
			,[91-120]
			,[121-150]
			,[151-180]
			,[181-365]
			,[>1 Year]
			,Total
			,Filter
			)
		SELECT - 1
			,'Total'
			,SUM([0-30])
			,SUM([31-60])
			,SUM([61-90])
			,SUM([91-120])
			,SUM([121-150])
			,SUM([151-180])
			,SUM([181-365])
			,SUM([>1 Year])
			,SUM([Total])
			,'DOS'
		FROM #T1

		SELECT [Id]
			,PayerId
			,PayerName
			,'$' + ISNULL(CONVERT(VARCHAR, [0-30], 1), '0.00') AS [0-30]
			,--'1' Added by Gayathri for Currency
			'$' + ISNULL(CONVERT(VARCHAR, [31-60], 1), '0.00') AS [31-60]
			,'$' + ISNULL(CONVERT(VARCHAR, [61-90], 1), '0.00') AS [61-90]
			,'$' + ISNULL(CONVERT(VARCHAR, [91-120], 1), '0.00') AS [91-120]
			,'$' + ISNULL(CONVERT(VARCHAR, [121-150], 1), '0.00') AS [121-150]
			,'$' + ISNULL(CONVERT(VARCHAR, [151-180], 1), '0.00') AS [151-180]
			,'$' + ISNULL(CONVERT(VARCHAR, [181-365], 1), '0.00') AS [181-365]
			,'$' + ISNULL(CONVERT(VARCHAR, [>1 Year], 1), '0.00') AS [>1 Year]
			,'$' + ISNULL(CONVERT(VARCHAR, Total, 1), '0.00') AS Total
			,Filter
		FROM #T1
		ORDER BY
			--CASE PayerId
			-- WHEN 0 THEN 'ZZZZZ0'
			--WHEN 1 THEN 'ZZZZZ1'
			-- WHEN -1 THEN 'ZZZZZ2'
			-- ELSE 
			PayerName
			-- END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMDashboardARSelAllClaimsbyPayer') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


