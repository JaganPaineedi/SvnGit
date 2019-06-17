/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCommunicationAmountDueServices]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInternalCommunicationAmountDueServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInternalCommunicationAmountDueServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCommunicationAmountDueServices]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetInternalCommunicationAmountDueServices] @PageNumber INT = 1
	,@ClientId INT
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 07/JULY/2015  
-- Purpose     : To Get Service Records. 
-- Date              Author                  Purpose                   */
-- 02/10/2017      jcarlson       Keystone Customizations 69 - increased ProcedureName length to 500 to handle procedure code display as increasing to 75 
-- ============================================= 
BEGIN
	BEGIN TRY		
		DECLARE @PageSize INT = 5
		DECLARE @SortExpression VARCHAR(100) = 'DOS DESC'

		IF OBJECT_ID('tempdb..#CustomFilters') IS NOT NULL
			DROP TABLE #CustomFilters
		CREATE TABLE #CustomFilters (ServiceId INT)

		IF OBJECT_ID('tempdb..#Charges') IS NOT NULL
			DROP TABLE #Charges
		CREATE TABLE #Charges (
			ServiceId INT NULL
			,ChargeId INT NULL
			,Priority INT NULL
			,DateOfService DATETIME NULL
			,ProcedureCodeId INT NULL
			,ProgramId INT NULL
			,ClinicianId INT NULL
			,Unit INT NULL
			,UnitType INT NULL
			,CoveragePlanId INT NULL
			,InsuredId VARCHAR(25) NULL
			,Charges MONEY NULL
			,Unbilled MONEY NULL
			,Billed MONEY NULL
			,Payments MONEY NULL
			,Adjustments MONEY NULL
			,Balance MONEY NULL
			,BalanceOldDays INT NULL
			,ClientCoveragePlanId INT NULL
			)

		IF OBJECT_ID('tempdb..#Services') IS NOT NULL
			DROP TABLE #Services
		CREATE TABLE #Services (
			ServiceId INT NULL
			,DateOfService DATETIME NULL
			,ProcedureCodeId INT NULL
			,ProgramId INT NULL
			,ClinicianId INT NULL
			,Unit INT NULL
			,UnitType INT NULL
			,Charges MONEY NULL
			,Unbilled MONEY NULL
			,Billed MONEY NULL
			,Payments MONEY NULL
			,Adjustments MONEY NULL
			,Balance MONEY NULL
			,BalanceOldDays INT NULL
			)

		IF OBJECT_ID('tempdb..#ResultSet') IS NOT NULL
			DROP TABLE #ResultSet
		CREATE TABLE #ResultSet (
			TempID INT IDENTITY(1, 1)
			,RowNumber INT
			,PageNumber INT
			,Id INT
			,ParentId INT
			,ServiceId INT
			,Priority INT
			,DOS VARCHAR(101)
			,DateOfService DATETIME
			,ProcedureName VARCHAR(500)
			,ClinicianName VARCHAR(290)
			,ProgramName VARCHAR(290)
			,Charges MONEY
			,Unbilled MONEY
			,Billed MONEY
			,Payments MONEY
			,Adjustment MONEY
			,Balance MONEY
			,BalanceDaysOld INT
			,ClientCoveragePlanId INT
			)	

		IF OBJECT_ID('tempdb..#ResultSetParent') IS NOT NULL
			DROP TABLE #ResultSetParent	
		CREATE TABLE #ResultSetParent (
			TempID INT
			,RowNumber INT
			,PageNumber INT
			,Id INT
			,ParentId INT
			,ServiceId INT
			,Priority INT
			,DOS DATETIME
			,DateOfService DATETIME
			,ProcedureName VARCHAR(500)
			,ClinicianName VARCHAR(290)
			,ProgramName VARCHAR(290)
			,Charges MONEY
			,Unbilled MONEY
			,Billed MONEY
			,Payments MONEY
			,Adjustment MONEY
			,Balance MONEY
			,BalanceDaysOld INT
			,ClientCoveragePlanId INT
			)

		IF OBJECT_ID('tempdb..#ResultSetChild') IS NOT NULL
			DROP TABLE #ResultSetChild	
		CREATE TABLE #ResultSetChild (
			TempID INT
			,RowNumber INT
			,PageNumber INT
			,Id INT
			,ParentId INT
			,ServiceId INT
			,Priority INT
			,DOS VARCHAR(101)
			,DateOfService DATETIME
			,ProcedureName VARCHAR(500)
			,ClinicianName VARCHAR(290)
			,ProgramName VARCHAR(290)
			,Charges MONEY
			,Unbilled MONEY
			,Billed MONEY
			,Payments MONEY
			,Adjustment MONEY
			,Balance MONEY
			,BalanceDaysOld INT
			,ClientCoveragePlanId INT
			)
		 


		SET FORCEPLAN ON	
		INSERT INTO #CustomFilters(ServiceId)
		SELECT DISTINCT a.ServiceId
		FROM Services a
		JOIN Charges b ON (a.ServiceId = b.ServiceId)
		LEFT JOIN ARLedger c ON (b.ChargeId = c.ChargeId)
		LEFT JOIN OpenCharges d ON (b.ChargeId = d.ChargeId)
		LEFT JOIN ClientCoveragePlans e ON (b.ClientCoveragePlanId = e.ClientCoveragePlanId)
		WHERE ISNULL(a.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
			AND EXISTS (SELECT * FROM Charges c1 JOIN OpenCharges d1 ON c1.ChargeId = d1.ChargeId WHERE a.ServiceId = c1.ServiceId AND ISNULL(c1.RecordDeleted,'N') = 'N')
			AND EXISTS (SELECT * FROM Charges y WHERE a.ServiceId = y.ServiceId AND y.Priority = 0 AND ISNULL(y.RecordDeleted,'N') = 'N')
			AND a.ClientId = @ClientId
		    
		INSERT INTO #Charges (
			ServiceId
			,ChargeId
			,Priority
			,DateOfService
			,ProcedureCodeId
			,ProgramId
			,ClinicianId
			,Unit
			,UnitType
			,CoveragePlanId
			,InsuredId
			,Charges
			,Unbilled
			,Billed
			,Payments
			,Adjustments
			,Balance
			,BalanceOldDays
			,ClientCoveragePlanId
			)
		SELECT a.ServiceId
			,b.ChargeId
			,b.Priority
			,CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 18, 3)) AS DateOfService
			,a.ProcedureCodeId
			,a.ProgramId
			,a.ClinicianId
			,a.Unit
			,a.UnitType
			,e.CoveragePlanId
			,e.InsuredId
			,SUM(CASE WHEN c.LedgerType IN (4201,4204) THEN c.Amount ELSE 0 END)
			,SUM(CASE WHEN b.LastBilledDate IS NULL THEN c.Amount ELSE 0 END)
			,SUM(CASE WHEN b.LastBilledDate IS NOT NULL THEN c.Amount ELSE 0 END)
			,SUM(CASE WHEN c.LedgerType = 4202 THEN - c.Amount ELSE 0 END)
			,SUM(CASE WHEN c.LedgerType = 4203 THEN - c.Amount ELSE 0 END)
			,SUM(c.Amount)
			,datediff(dd, a.DateOfService, GETDATE())
			,e.ClientCoveragePlanId
		FROM #CustomFilters a1
		JOIN Services a ON (a.ServiceId = a1.ServiceId)
		JOIN Charges b ON (a.ServiceId = b.ServiceId AND ISNULL(b.RecordDeleted, 'N') = 'N')
		LEFT JOIN ARLedger c ON (b.ChargeId = c.ChargeId AND ISNULL(c.RecordDeleted, 'N') = 'N')
		LEFT JOIN OpenCharges d ON (b.ChargeId = d.ChargeId AND ISNULL(d.RecordDeleted, 'N') = 'N')
		LEFT JOIN ClientCoveragePlans e ON (b.ClientCoveragePlanId = e.ClientCoveragePlanId)
		GROUP BY a.ServiceId
			,b.ChargeId
			,b.Priority
			,a.DateOfService
			,a.ProcedureCodeId
			,a.Unit
			,a.UnitType
			,e.CoveragePlanId
			,e.InsuredId
			,datediff(dd, a.DateOfService, GETDATE())
			,e.ClientCoveragePlanId
			,a.ProgramId
			,a.ClinicianId
		SET FORCEPLAN OFF


		INSERT INTO #Services (
			ServiceId
			,DateOfService
			,ProcedureCodeId
			,ProgramId
			,ClinicianId
			,Unit
			,UnitType
			,Charges
			,Unbilled
			,Billed
			,Payments
			,Adjustments
			,Balance
			,BalanceOldDays
			)
		SELECT ServiceId
			,DateOfService
			,ProcedureCodeId
			,ProgramId
			,ClinicianId
			,Unit
			,UnitType
			,SUM(Charges)
			,SUM(Unbilled)
			,SUM(Billed)
			,SUM(Payments)
			,SUM(Adjustments)
			,SUM(Balance)
			,BalanceOldDays
		FROM #Charges
		GROUP BY ServiceId
			,DateOfService
			,ProcedureCodeId
			,Unit
			,UnitType
			,BalanceOldDays
			,ProgramId
			,ClinicianId
		 
		 
		 INSERT INTO #ResultSet (
			Id
			,ParentId
			,ServiceId
			,Priority
			,DOS
			,DateOfService
			,ProcedureName
			,ProgramName
			,ClinicianName
			,Charges
			,Unbilled
			,Billed
			,Payments
			,Adjustment
			,Balance
			,BalanceDaysOld
			,ClientCoveragePlanId
			)
		SELECT 0
			,a.ServiceId
			,a.ServiceId
			,- 1
			,CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8))
			,CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8))
			,b.DisplayAs + ' ' + CONVERT(VARCHAR(20), a.Unit, 6) + ' ' + c.CodeName
			,P.ProgramCode
			,S.LastName+', '+S.FirstName AS ClinicianName
			,CONVERT(VARCHAR(20), a.Charges)
			,CONVERT(VARCHAR(20), a.Unbilled)
			,CONVERT(VARCHAR(20), a.Billed)
			,CONVERT(VARCHAR(20), a.Payments)
			,CONVERT(VARCHAR(20), a.Adjustments)
			,CONVERT(VARCHAR(20), a.Balance)
			,CONVERT(VARCHAR(20), a.BalanceOldDays)
			,NULL
		FROM #Services a
		JOIN ProcedureCodes b ON (a.ProcedureCodeId = b.ProcedureCodeId)
		JOIN GlobalCodes c ON (a.UnitType = c.GlobalCodeId)
		LEFT JOIN Programs P ON a.ProgramId = P.ProgramId
		LEFT JOIN Staff S ON a.ClinicianId = S.StaffId

		UNION

		SELECT 0
			,a.ServiceId
			,a.ServiceId
			,CASE WHEN a.Priority = 0 THEN 20000 ELSE a.Priority END
			,CONVERT(VARCHAR, a.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), a.DateOfService, 100), 12, 8))
			,CONVERT(VARCHAR, a.DateOfService, 101)
			,ISNULL(RTRIM(b.DisplayAs) + ' ' + ISNULL(a.InsuredId, ''), 'Client')
			,P.ProgramCode
			,S.LastName+', '+S.FirstName AS ClinicianName
			,CONVERT(VARCHAR(20), a.Charges)
			,CONVERT(VARCHAR(20), a.Unbilled)
			,CONVERT(VARCHAR(20), a.Billed)
			,CONVERT(VARCHAR(20), a.Payments)
			,CONVERT(VARCHAR(20), a.Adjustments)
			,CONVERT(VARCHAR(20), a.Balance)
			,CONVERT(VARCHAR(20), a.BalanceOldDays)
			,a.ClientCoveragePlanId
		FROM #Charges a
		LEFT JOIN CoveragePlans b ON (a.CoveragePlanId = b.CoveragePlanId)
		LEFT JOIN Programs P ON a.ProgramId = P.ProgramId
		LEFT JOIN Staff S ON a.ClinicianId = S.StaffId
		ORDER BY 3,4 ASC

		UPDATE a
		SET Id = b.TempID
			,ServiceId = NULL
			,DOS = NULL
		FROM #ResultSet a
		JOIN #ResultSet b ON (a.ServiceId = b.ServiceId)
		WHERE b.Priority = - 1
			AND a.Priority <> - 1

		INSERT INTO #ResultSetParent
		SELECT *
		FROM #ResultSet
		WHERE Id = 0

		INSERT INTO #ResultSetChild
		SELECT *
		FROM #ResultSet
		WHERE Id != 0

		UPDATE d
		SET RowNumber = rn.RowNumber
			,PageNumber = (rn.RowNumber / @PageSize) + CASE 
				WHEN rn.RowNumber % @PageSize = 0
					THEN 0
				ELSE 1
				END
		FROM #ResultSetParent d
		JOIN (SELECT TempID
				,ROW_NUMBER() OVER (ORDER BY CASE WHEN @SortExpression = 'ServiceId' THEN ServiceId END
						,CASE WHEN @SortExpression = 'ServiceId DESC' THEN ServiceId END DESC
						,CASE WHEN @SortExpression = 'DOS' THEN DOS END
						,CASE WHEN @SortExpression = 'DOS DESC' THEN DOS END DESC
						,CASE WHEN @SortExpression = 'ProcedureName' THEN ProcedureName END
						,CASE WHEN @SortExpression = 'ProcedureName DESC' THEN ProcedureName END DESC
						,CASE WHEN @SortExpression = 'Charges' THEN Charges END
						,CASE WHEN @SortExpression = 'Charges DESC' THEN Charges END DESC
						,CASE WHEN @SortExpression = 'UnBilled' THEN UnBilled END
						,CASE WHEN @SortExpression = 'UnBilled DESC' THEN UnBilled END DESC
						,CASE WHEN @SortExpression = 'Billed' THEN Billed END
						,CASE WHEN @SortExpression = 'Billed DESC' THEN Billed END DESC
						,CASE WHEN @SortExpression = 'Payments' THEN Payments END
						,CASE WHEN @SortExpression = 'Payments DESC' THEN Payments END DESC
						,CASE WHEN @SortExpression = 'Adj' THEN Adjustment END
						,CASE WHEN @SortExpression = 'Adj DESC' THEN Adjustment END DESC
						,CASE WHEN @SortExpression = 'Balance' THEN Balance END
						,CASE WHEN @SortExpression = 'Balance DESC' THEN Balance END DESC
						,CASE WHEN @SortExpression = 'BalDaysOld' THEN BalanceDaysOld END
						,CASE WHEN @SortExpression = 'BalDaysOld DESC' THEN BalanceDaysOld END DESC
						,TempId
					) AS RowNumber
			FROM #ResultSetParent
			) rn ON rn.TempID = d.TempID

		DECLARE @counts INT
		DECLARE @TotalBalance MONEY

		SET @counts = (SELECT count(*) AS totalrows FROM #ResultSetParent)
		SELECT @TotalBalance = SUM(Balance) FROM #ResultSetParent

		SELECT TOP (CASE WHEN (@PageNumber = - 1) THEN (0) ELSE (@PageSize) END) TempID
			,Id
			,ServiceId
			,CAST(DOS AS DATETIME) AS DOS
			,convert(VARCHAR(19), DateOfService, 101) + ' ' + ltrim(substring(convert(VARCHAR(19), DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), DateOfService, 100), 18, 2)) AS DateOfService
			,ProcedureName AS 'Procedure'
			,ProgramName
			,ClinicianName
			,RowNumber
			,PageNumber
			,ProcedureName
			,Adjustment
			,BalanceDaysOld
			,CASE WHEN Charges IS NULL THEN '0' ELSE Charges END AS Charges
			,CASE WHEN Unbilled IS NULL THEN '0' ELSE Unbilled END AS Unbilled
			,CASE WHEN Billed IS NULL THEN '0' ELSE Billed END AS Billed
			,CASE WHEN Payments IS NULL THEN '0' ELSE Payments END AS Payments
			,CASE WHEN Adjustment IS NULL THEN '0' ELSE Adjustment END AS Adj
			,CASE WHEN Balance IS NULL THEN '0' ELSE Balance END AS Balance
			,BalanceDaysOld AS 'Bal Days Old'
			,(SELECT CASE COUNT(*) WHEN 0 THEN 'none' ELSE 'block' END FROM #ResultSetChild A WHERE A.Id = #ResultSetParent.TempID) AS HasChild
		INTO #ResultSetParentFinal
		FROM #ResultSetParent
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
		ORDER BY RowNumber

		IF (SELECT ISNULL(COUNT(*), 0) FROM #ResultSetParentFinal) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (@counts % @PageSize) WHEN 0 THEN ISNULL((@counts / @PageSize), 0) ELSE ISNULL((@counts / @PageSize), 0) + 1 END AS NumberOfPages
				,ISNULL(@counts, 0) AS NumberOfRows
			FROM #ResultSetParentFinal
		END
		 
		SELECT RowNumber,TempID AS Id
			,Id AS ParentId
			,ServiceId
			,CAST(DOS AS DATETIME) AS DOS
			,DateOfService AS DateOfService
			,ProcedureName AS 'Procedure'
			,ProgramName
			,ClinicianName
			,CASE WHEN Charges IS NULL THEN '0' ELSE Charges END AS Charges
			,CASE WHEN Unbilled IS NULL THEN '0' ELSE Unbilled END AS Unbilled
			,CASE WHEN Billed IS NULL THEN '0' ELSE Billed END AS Billed
			,CASE WHEN Payments IS NULL THEN '0' ELSE Payments END AS Payments
			,CASE WHEN Adjustment IS NULL THEN '0' ELSE Adjustment END AS Adj
			,CASE WHEN Balance IS NULL THEN '0' ELSE CAST(Balance AS DECIMAL(18,2)) END AS Balance
			,BalanceDaysOld AS 'Bal Days Old' 
			,(SELECT CASE COUNT(*) WHEN 0 THEN 'none' ELSE 'block' END FROM #ResultSetChild A WHERE A.Id = #ResultSetParentFinal.TempID) AS HasChild
		FROM #ResultSetParentFinal
		ORDER BY RowNumber

		--SELECT A.TempID AS Id
		--	,A.Id AS ParentId
		--	,B.ServiceId
		--	,CAST(A.DOS AS DATETIME) AS DOS
		--	,convert(VARCHAR(19), A.DateOfService, 101) + ' ' + ltrim(substring(convert(VARCHAR(19), A.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), A.DateOfService, 100), 18, 2)) AS DateOfService
		--	,A.ProcedureName AS 'Procedure'
		--	,CASE WHEN A.Charges IS NULL THEN '0' ELSE A.Charges END AS Charges
		--	,CASE WHEN A.Unbilled IS NULL THEN '0' ELSE A.Unbilled END AS Unbilled
		--	,CASE WHEN A.Billed IS NULL THEN '0' ELSE A.Billed END AS Billed
		--	,CASE WHEN A.Payments IS NULL THEN '0' ELSE A.Payments END AS Payments
		--	,CASE WHEN A.Adjustment IS NULL THEN '0' ELSE A.Adjustment END AS Adj
		--	,CASE WHEN A.Balance IS NULL THEN '0' ELSE A.Balance END AS Balance
		--	,A.BalanceDaysOld AS 'Bal Days Old'
		--	,A.ClientCoveragePlanId
		--FROM #ResultSetChild A
		--JOIN #ResultSetParent B ON A.Id = B.TempID

		SELECT CASE WHEN @TotalBalance IS NULL THEN '0.00' ELSE CAST(@TotalBalance AS DECIMAL(18,2)) END TotalBalance
		 
		 IF OBJECT_ID('tempdb..#ResultSetParentFinal') IS NOT NULL
			DROP TABLE #ResultSetParentFinal
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR ('ssp_SCGetInternalCommunicationAmountDueServices: An Error Occured',16,1)

			RETURN
		END
	END CATCH
END

GO


