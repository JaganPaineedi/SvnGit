/****** Object:  StoredProcedure [dbo].[ssp_SCListPageFinancialActivity]    Script Date: 02/17/2015 12:37:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageFinancialActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageFinancialActivity]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageFinancialActivity]    Script Date: 02/17/2015 12:37:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageFinancialActivity] (
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@StaffId INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@ChargeCreated CHAR(1)
	,@ClientStatement CHAR(1)
	,@PayerInvoiceSent CHAR(1)
	,@ClientPayment CHAR(1)
	,@PayerPayment CHAR(1)
	,@AuthorizationActivity CHAR(1)
	,@CoveragePlanActivity CHAR(1)
	,@EligibilityVerification CHAR(1)
	,@ClientFlag CHAR(1)
	,@ClientStaffContacts CHAR(1)
	,@Collections CHAR(1)
	,@OtherFilter INT
	)
/********************************************************************************                                                 
** Stored Procedure: ssp_SCListPageFinancialActivity                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 04-FEB-2015	   Akwinass			   Created
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClick AS CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ActivityDate desc'

		CREATE TABLE #ResultSet (
			 FinancialActivityHistoryId int identity(1,1) NOT NULL
			,ActivityDate DATETIME
			,Activity VARCHAR(250)
			,[Description] VARCHAR(1500)
			,Staff VARCHAR(250)
			,ChargeId INT
			,ClientStatementId INT
			,ClientNoteId INT
			,NoteType INT 
			,NoteLevel INT 
			,NoteCreatedBy VARCHAR(30)
			,ClientContactNoteId INT
			,PaymentID INT
			,FinancialActivityId INT
			,EligibilityVerificationRequestId INT
			,AuthorizationId INT
			,AuthorizationDocumentId INT
			,ClientCoveragePlanId INT
			)

		CREATE TABLE #CustomFilters (ActivityDate DATETIME
			,Activity VARCHAR(250)
			,[Description] VARCHAR(1500)
			,Staff VARCHAR(250)
			,ChargeId INT
			,ClientStatementId INT
			,ClientNoteId INT
			,NoteType INT 
			,NoteLevel INT 
			,NoteCreatedBy VARCHAR(30)
			,ClientContactNoteId INT
			,PaymentID INT
			,FinancialActivityId INT
			,EligibilityVerificationRequestId INT
			,AuthorizationId INT
			,AuthorizationDocumentId INT
			,ClientCoveragePlanId INT)

		--Get custom filters                                                    
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_SCListPageFinancialActivity', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters (ActivityDate,Activity,[Description],Staff,ChargeId,ClientStatementId,ClientNoteId,NoteType,NoteLevel,NoteCreatedBy,ClientContactNoteId,PaymentID,FinancialActivityId,EligibilityVerificationRequestId,AuthorizationId,AuthorizationDocumentId,ClientCoveragePlanId)
				EXEC scsp_SCListPageFinancialActivity @PageNumber,@PageSize,@SortExpression,@ClientId,@StaffId,@FromDate,@ToDate,@ChargeCreated,@ClientStatement,@PayerInvoiceSent,@ClientPayment,@PayerPayment,@AuthorizationActivity,@CoveragePlanActivity,@EligibilityVerification,@ClientFlag,@ClientStaffContacts,@Collections,@OtherFilter
			END
		END

		IF @CustomFiltersApplied = 'N'
		BEGIN
			IF ISNULL(@ChargeCreated,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ChargeId)
				EXEC ssp_SCGetFinancialActivityChargesAndClaims @ClientId, @StaffId, @FromDate, @ToDate
			END
			
			IF ISNULL(@ClientStatement,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ClientStatementId)
				EXEC ssp_SCGetFinancialActivityClientStatements @ClientId, @StaffId, @FromDate, @ToDate
			END
			
			IF ISNULL(@ClientPayment,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,PaymentID,FinancialActivityId)
				EXEC ssp_SCGetFinancialActivityClientPayments @ClientId, @StaffId, @FromDate, @ToDate, 4325
			END
			
			IF ISNULL(@PayerPayment,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,PaymentID,FinancialActivityId)
				EXEC ssp_SCGetFinancialActivityClientPayments @ClientId, @StaffId, @FromDate, @ToDate, 4323, 'PLAN'
				
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,PaymentID,FinancialActivityId)
				EXEC ssp_SCGetFinancialActivityClientPayments @ClientId, @StaffId, @FromDate, @ToDate, 4323, 'PAYER'
			END
			
			IF ISNULL(@AuthorizationActivity,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,AuthorizationId,AuthorizationDocumentId)
				EXEC ssp_SCGetFinancialActivityAuthorizationChangeLog @ClientId, @StaffId, @FromDate, @ToDate
			END	
			
			IF ISNULL(@CoveragePlanActivity,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ClientCoveragePlanId)
				EXEC ssp_SCGetFinancialActivityClientCoveragePlanChangeLog @ClientId, @StaffId, @FromDate, @ToDate
			END			
			
			IF ISNULL(@EligibilityVerification,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],EligibilityVerificationRequestId)
				EXEC ssp_SCGetFinancialActivityClientEligibilitVerification @ClientId, @StaffId, @FromDate, @ToDate
			END	
			
			IF ISNULL(@ClientFlag,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ClientNoteId,NoteType,NoteLevel,NoteCreatedBy)
				EXEC ssp_SCGetFinancialActivityClientFlags @ClientId, @StaffId, @FromDate, @ToDate, 'CREATED'
				
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff)
				EXEC ssp_SCGetFinancialActivityClientFlags @ClientId, @StaffId, @FromDate, @ToDate, 'REMOVED'
			END
			
			IF ISNULL(@ClientStaffContacts,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ClientContactNoteId)
				EXEC ssp_SCGetFinancialActivityClientContactNotes @ClientId, @StaffId, @FromDate, @ToDate
			END
			
			IF ISNULL(@Collections,'N') = 'Y'
			BEGIN
				INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff)
				EXEC ssp_SCGetFinancialActivityCollections @ClientId, @StaffId, @FromDate, @ToDate
			END
		END
		ELSE
		BEGIN
			INSERT INTO #ResultSet (ActivityDate,Activity,[Description],Staff,ChargeId,ClientStatementId,ClientNoteId,NoteType,NoteLevel,NoteCreatedBy,ClientContactNoteId,PaymentID,FinancialActivityId,EligibilityVerificationRequestId,AuthorizationId,AuthorizationDocumentId,ClientCoveragePlanId)
			SELECT ActivityDate,Activity,[Description],Staff,ChargeId,ClientStatementId,ClientNoteId,NoteType,NoteLevel,NoteCreatedBy,ClientContactNoteId,PaymentID,FinancialActivityId,EligibilityVerificationRequestId,AuthorizationId,AuthorizationDocumentId,ClientCoveragePlanId FROM #CustomFilters
		END
			

		;WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT ActivityDate
				,Activity
				,REPLACE([Description],'orMissing','or Missing') AS [Description]
				,Staff
				,ChargeId
				,ClientStatementId
				,ClientNoteId
				,NoteType
				,NoteLevel
				,NoteCreatedBy
				,ClientContactNoteId
				,PaymentID
				,FinancialActivityId
				,EligibilityVerificationRequestId
				,AuthorizationId
				,AuthorizationDocumentId
				,ClientCoveragePlanId
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ActivityDate'
								THEN ActivityDate
							END
						,CASE 
							WHEN @SortExpression = 'ActivityDate desc'
								THEN ActivityDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Activity'
								THEN Activity
							END
						,CASE 
							WHEN @SortExpression = 'Activity desc'
								THEN Activity
							END DESC
						,CASE 
							WHEN @SortExpression = 'Description'
								THEN [Description]
							END
						,CASE 
							WHEN @SortExpression = 'Description desc'
								THEN [Description]
							END DESC
						,CASE 
							WHEN @SortExpression = 'Staff'
								THEN Staff
							END
						,CASE 
							WHEN @SortExpression = 'Staff desc'
								THEN Staff
							END DESC
						,FinancialActivityHistoryId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) ActivityDate
			,Activity
			,[Description]
			,Staff
			,ChargeId
			,ClientStatementId
			,ClientNoteId
			,NoteType
			,NoteLevel
			,NoteCreatedBy
			,ClientContactNoteId
			,PaymentID
			,FinancialActivityId
			,EligibilityVerificationRequestId
			,AuthorizationId
			,AuthorizationDocumentId
			,ClientCoveragePlanId
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)


		IF (SELECT Isnull(Count(*), 0) FROM #FinalResultSet) < 1 OR @PageNumber = -1
		BEGIN
			SELECT 0 AS PageNumber,0 AS NumberOfPages,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber,CASE (Totalcount % @PageSize) WHEN 0 THEN Isnull((Totalcount / @PageSize), 0) ELSE Isnull((Totalcount / @PageSize), 0) + 1 END AS NumberOfPages,Isnull(Totalcount, 0) AS NumberofRows FROM #FinalResultSet
		END

		SELECT convert(VARCHAR, ActivityDate, 101) AS ActivityDate
			,Activity
			,[Description]
			,Staff
			,ChargeId
			,ClientStatementId
			,ClientNoteId
			,NoteType
			,NoteLevel
			,NoteCreatedBy
			,ClientContactNoteId
			,PaymentID
			,FinancialActivityId
			,EligibilityVerificationRequestId
			,AuthorizationId
			,AuthorizationDocumentId
			,ClientCoveragePlanId
		FROM #FinalResultSet
		ORDER BY RowNumber
		
		DROP TABLE #ResultSet
		DROP TABLE #CustomFilters
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCListPageFinancialActivity') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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