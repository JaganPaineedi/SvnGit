/****** Object:  StoredProcedure [dbo].[ssp_SCListPageInternalCollectionCharges]    Script Date: 08/14/2015 12:48:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageInternalCollectionCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageInternalCollectionCharges]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageInternalCollectionCharges]    Script Date: 08/14/2015 12:48:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageInternalCollectionCharges] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@CollectionId INT
	,@ProcedureCodeId INT
	,@ClinicianId INT
	,@ProgramId INT
	,@DOSFromDate DATETIME
	,@DOSToDate DATETIME
	,@OtherFilter INT
	,@CurrentUserId INT
	/* *******************************************************************************/
	-- Stored Procedure: dbo.ssp_SCListPageInternalCollectionCharges                                                                                                          
	-- Copyright: Streamline Healthcate Solutions                                                                          
	--                                                                          
	-- Purpose: used by Internal Collections Charges List page Tab.           
	--    
	--                                                                          
	-- Updates:                                                                                                                                 
	-- Date				Author			Purpose                                                                          
	-- 23.JAN.2017		Akwinass		 Created.  
	-- 17.Nov.2017      Ajay			 Removed check  ISNULL(PC.RecordDeleted,'N') = 'N' from Program and ProcedureCodes tables, otherwise it won't show the old data. Renaissance - Dev Items:Task#830.4
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ChargeId INT)		
			
		DECLARE @FromNoteDate DATE
		DECLARE @ToNoteDate DATE
		SET @FromNoteDate = CASE WHEN ISNULL(@DOSFromDate,'1900-01-01') = '1900-01-01' THEN NULL ELSE CAST(@DOSFromDate AS DATE) END
		SET @ToNoteDate = CASE WHEN ISNULL(@DOSToDate,'1900-01-01') = '1900-01-01' THEN NULL ELSE CAST(@DOSToDate AS DATE) END
		
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		CREATE TABLE #ResultSet (
			ChargeId INT
			,ServiceId INT
			,ProcedureCodeId INT			
			,ClinicianId INT
			,ProgramId INT
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,ClinicianName VARCHAR(250)
			,ProgramName VARCHAR(250)
			,Charge MONEY
			,Balance MONEY
			,PaidAmount MONEY
			)

		SET @SortExpression = rtrim(ltrim(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'DateTime desc'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ChargeId)
			EXEC scsp_SCListPageInternalCollectionCharges @PageNumber = @PageNumber
				,@PageSize = @PageSize
				,@SortExpression = @SortExpression
				,@CollectionId = @CollectionId
				,@ProcedureCodeId = @ProcedureCodeId
				,@ClinicianId = @ClinicianId
				,@ProgramId = @ProgramId
				,@DOSFromDate = @DOSFromDate
				,@DOSToDate = @DOSToDate
				,@OtherFilter = @OtherFilter
				,@CurrentUserId = @CurrentUserId

		END
		
		INSERT INTO #ResultSet (
			ChargeId
			,ServiceId
			,ProcedureCodeId
			,ClinicianId
			,ProgramId
			,DateOfService
			,ProcedureCodeName
			,ClinicianName
			,ProgramName
			,Charge
			,Balance
			,PaidAmount
			)
		SELECT CH.ChargeId
			,CH.ServiceId
			,S.ProcedureCodeId
			,S.ClinicianId
			,S.ProgramId
			,S.DateOfService
			,PC.DisplayAs
			,ST.LastName+ ', ' +ST.FirstName
			,P.ProgramName	
			,S.Charge
			,OCH.Balance
			,TempPaidAmount.Amount		
		FROM Charges CH JOIN 
		Services S ON CH.ServiceId = S.ServiceId AND ISNULL(CH.RecordDeleted,'N') = 'N' AND ISNULL(S.RecordDeleted,'N') = 'N'
		LEFT JOIN dbo.OpenCharges OCH ON OCH.ChargeId = CH.ChargeId AND ISNULL(OCH.RecordDeleted,'N') = 'N'
		LEFT JOIN (SELECT C.ChargeId as NewChargeId, -SUM(ARL.Amount) as Amount FROM dbo.ARLedger ARL JOIN Charges C ON C.ChargeId=ARL.ChargeId	
					WHERE ARL.ChargeId = C.ChargeId AND ARL.LedgerType = 4202 AND ISNULL(ARL.RecordDeleted, 'N') = 'N' GROUP BY C.ChargeId) 
					AS TempPaidAmount on TempPaidAmount.NewChargeId = CH.ChargeId
		JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId -- Modified By Ajay
		JOIN Programs P ON S.ProgramId = P.ProgramId                     -- Modified By Ajay
		JOIN InternalCollectionCharges CCH ON CH.ChargeId = CCH.ChargeId AND CCH.CollectionId = @CollectionId AND ISNULL(CCH.RecordDeleted,'N') = 'N'
		JOIN Collections CL ON CCH.CollectionId = CL.CollectionId AND CL.CollectionId = @CollectionId
		LEFT JOIN Staff ST ON S.ClinicianId = ST.StaffId
		WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #CustomFilters cf WHERE cf.ChargeId = CH.ChargeId))
					OR (@CustomFiltersApplied = 'N'
						AND (CAST(S.DateOfService AS DATE) >= @FromNoteDate OR @FromNoteDate IS NULL)
						AND (CAST(S.DateOfService AS DATE) <= @ToNoteDate OR @ToNoteDate IS NULL)
						AND (S.ProcedureCodeId = @ProcedureCodeId OR @ProcedureCodeId = 0)	  
						AND (S.ClinicianId = @ClinicianId OR @ClinicianId = 0)
						AND (S.ProgramId = @ProgramId OR @ProgramId = 0)
						))

		;WITH Counts
		AS (SELECT Count(*) AS TotalRows FROM #ResultSet)
			,RankResultSet
		AS (SELECT ChargeId
				,ServiceId
				,ProcedureCodeId
				,ClinicianId
				,ProgramId
				,DateOfService
				,ProcedureCodeName
				,ClinicianName
				,ProgramName
				,Charge
				,Balance
				,PaidAmount
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (ORDER BY   CASE WHEN @SortExpression = 'DOS' THEN DateOfService END
										,CASE WHEN @SortExpression = 'DOS DESC' THEN DateOfService END DESC
										,CASE WHEN @SortExpression = 'ProcedureCode' THEN ProcedureCodeName END
										,CASE WHEN @SortExpression = 'ProcedureCode DESC' THEN ProcedureCodeName END DESC
										,CASE WHEN @SortExpression = 'Clinician' THEN ClinicianName END
										,CASE WHEN @SortExpression = 'Clinician DESC' THEN ClinicianName END DESC
										,CASE WHEN @SortExpression = 'Program' THEN ProgramName END
										,CASE WHEN @SortExpression = 'Program DESC' THEN ProgramName END DESC										
										,CASE WHEN @SortExpression = 'ChargeID' THEN ChargeId END
										,CASE WHEN @SortExpression = 'ChargeID DESC' THEN ChargeId END DESC	
										,CASE WHEN @SortExpression = 'Charge' THEN ClinicianName END
										,CASE WHEN @SortExpression = 'Charge DESC' THEN ClinicianName END DESC
										,CASE WHEN @SortExpression = 'Balance' THEN ProgramName END
										,CASE WHEN @SortExpression = 'Balance DESC' THEN ProgramName END DESC										
										,CASE WHEN @SortExpression = 'PaidAmount' THEN ChargeId END
										,CASE WHEN @SortExpression = 'PaidAmount DESC' THEN ChargeId END DESC										
					,ChargeId) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)THEN (SELECT Isnull(TotalRows, 0) FROM Counts)ELSE (@PageSize)END) ChargeId
			,ServiceId
			,ProcedureCodeId			
			,ClinicianId
			,ProgramId
			,DateOfService
			,ProcedureCodeName
			,ClinicianName
			,ProgramName
			,Charge
			,Balance
			,PaidAmount
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
		
		IF @PageSize=0 OR @PageSize=-1
		BEGIN
			SELECT @PageSize=COUNT(*) FROM #FinalResultSet
		END
		
		IF (SELECT Isnull(Count(*), 0) FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT ChargeId
			,ServiceId
			,ProcedureCodeId
			,ClinicianId
			,ProgramId
			,DateOfService
			,ProcedureCodeName
			,ClinicianName
			,ProgramName
			,Charge
			,Balance
			,PaidAmount
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageInternalCollectionCharges') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO


