/****** Object:  StoredProcedure [dbo].[ssp_CreatePerDiemServices]    Script Date: 25-09-2018 18:11:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreatePerDiemServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE [dbo].[ssp_CreatePerDiemServices]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_CreatePerDiemServices]    Script Date: 25-09-2018 18:11:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CreatePerDiemServices] (
	@ClientId INT = NULL
	,@FromDate DATETIME = NULL --'9/10/2018'
	)
AS
/*********************************************************************************/
/* Stored Procedure: ssp_CreatePerDiemServices          */
/* Copyright: Streamline Healthcare Solutions           */
/* Creation Date:  25-SEP-2018							*/
/* Purpose: Per Diem Service Creation Process	        */
/* Input Parameters:									*/
/* Output Parameters:@ClientId,@FromDate				*/
/*      OtherFilter										*/
/* Return:												*/
/* Called By:											*/
/* Calls:												*/
/* Data Modifications:									*/
/* Updates:												*/
/* Date              Author             Purpose         */
/* 9/25/2018		 Ravi				What: copied logic from CCC-Customizations #500.3  Per Diem Service Creation Process
										Why :Engineering Improvement Initiatives #715	*/
/*********************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CreatedBy VARCHAR(100) = 'AutoPerDiemCharges'

		IF @FromDate IS NULL
			SET @FromDate = CAST(GETDATE() AS DATE)

		CREATE TABLE #ServicesToCreate (
			ClientId INT
			,ProgramId INT
			,BillableProcedureCode INT
			,LocationId INT
			,ClinicianId INT
			,DateofService DATETIME
			,[Status] INT
			,[Unit] INT
			,Billable CHAR(1)
			)

		INSERT INTO #ServicesToCreate (
			ClientId
			,ProgramId
			,BillableProcedureCode
			,LocationId
			,ClinicianId
			,DateofService
			,[Status]
			,[Unit]
			,Billable
			)
		SELECT DISTINCT a.ClientId
			,b.ProgramId
			,d.BillableProcedureCode
			,d.LocationId
			,d.ClinicianID
			,dt.DATE AS DateofService
			,71 AS [Status]
			,1 AS [Unit]
			,CASE 
				WHEN ISNULL(e.NotBillable, 'N') = 'N'
					THEN 'Y'
				ELSE 'N'
				END AS Billable
		FROM dbo.Clients a
		JOIN dbo.ClientPrograms b ON b.ClientId = a.ClientId
		JOIN dbo.Programs c ON c.ProgramId = b.ProgramId
		JOIN dbo.PerDiemBillingConfigurations d ON d.ProgramId = b.ProgramId
		JOIN dbo.ProcedureCodes e ON e.ProcedureCodeId = d.BillableProcedureCode
		CROSS APPLY dbo.Dates dt
		WHERE CAST(dt.DATE AS DATE) >= @FromDate
			AND CAST(dt.DATE AS DATE) < CAST(GETDATE() AS DATE)
			AND CAST(dt.DATE AS DATE) BETWEEN CAST(b.EnrolledDate AS DATE)
				AND CAST(ISNULL(b.DischargedDate, '12/31/2199') AS DATE)
			AND (
				(
					ISNULL(d.BillDischargeDate, 'N') = 'N'
					AND CAST(dt.DATE AS DATE) < CAST(ISNULL(b.DischargedDate, '12/31/2199') AS DATE)
					)
				OR (
					ISNULL(d.BillDischargeDate, 'N') = 'Y'
					AND CAST(dt.DATE AS DATE) <= CAST(ISNULL(b.DischargedDate, '12/31/2199') AS DATE)
					)
				)
			AND CAST(dt.DATE AS DATE) BETWEEN d.FromDate
				AND ISNULL(d.ToDate, '12/31/2199')
			AND (
				a.ClientId = @ClientId
				OR @ClientId IS NULL
				)
			AND NOT EXISTS (
				SELECT 1
				FROM Services sv
				WHERE sv.ClientId = a.ClientId
					AND CAST(sv.DateOfService AS DATE) = CAST(dt.DATE AS DATE)
					AND sv.ProcedureCodeId = d.BillableProcedureCode
					AND sv.ProgramId = d.ProgramID
					AND sv.STATUS IN (
						71
						,75
						)
					AND ISNULL(sv.RecordDeleted, 'N') = 'N'
				) -- Same Client, DOS, Procedure Code, Program -- service does not exist in Show or Complete status
			AND (
				(d.NonBillableProcedureCode IS NULL) -- Non Billable Procedure Code id not needed
				OR (
					d.NonBillableProcedureCode IS NOT NULL
					AND EXISTS (
						SELECT 1
						FROM dbo.Documents dc
						JOIN dbo.Services sv ON sv.ServiceId = dc.ServiceId
						WHERE dc.STATUS = 22
							AND sv.STATUS IN (
								71
								,75
								)
							AND dc.ClientId = a.ClientId
							AND CAST(dc.EffectiveDate AS DATE) = CAST(dt.DATE AS DATE)
							AND sv.ProcedureCodeId = d.NonBillableProcedureCode
							AND ISNULL(sv.RecordDeleted, 'N') = 'N'
						)
					) -- Non billable procedure code id is needed
				)

		BEGIN TRAN

		INSERT INTO dbo.Services (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ClientId
			,ProcedureCodeId
			,DateOfService
			,EndDateOfService
			,Unit
			,UnitType
			,STATUS
			,ClinicianId
			,ProgramId
			,LocationId
			,Billable
			,ClientWasPresent
			,DateTimeIn
			,DateTimeOut
			)
		SELECT @CreatedBy
			,GETDATE()
			,@CreatedBy
			,GETDATE()
			,ClientId
			,BillableProcedureCode
			,DateofService
			,DateofService
			,Unit
			,116
			,STATUS
			,ClinicianID
			,ProgramId
			,LocationId
			,Billable
			,'Y'
			,DateofService
			,DateofService
		FROM #ServicesToCreate

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreatePerDiemServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                          ;       
				16
				,-- Severity.                                                                                                
				1 -- State.                                                                                                
				);
	END CATCH
END
GO


