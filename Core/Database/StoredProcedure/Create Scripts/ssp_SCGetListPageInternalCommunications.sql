/****** Object:  StoredProcedure [dbo].[ssp_SCGetListPageInternalCommunications]    Script Date: 08/14/2015 12:48:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetListPageInternalCommunications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetListPageInternalCommunications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetListPageInternalCommunications]    Script Date: 08/14/2015 12:48:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetListPageInternalCommunications] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@Status INT
	,@Reason INT
	,@Type INT
	,@ClientId INT
	,@OtherFilter INT
	,@CurrentUserId INT
	/* *******************************************************************************/
	-- Stored Procedure: dbo.ssp_SCGetListPageInternalCommunications                                                                                                          
	-- Copyright: Streamline Healthcate Solutions                                                                          
	--                                                                          
	-- Purpose: used by Internal Collections Communications List page Tab.           
	--    
	--                                                                          
	-- Updates:                                                                                                                                 
	-- Date				Author			Purpose                                                                          
	-- 14.AUG.2015		Akwinass		 Created.  
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ClientContactNoteId INT)
		CREATE TABLE #ContactNoteReason (ContactReason INT)
		
		DECLARE @FromNoteDate DATE
		DECLARE @ToNoteDate DATE
		SET @FromNoteDate = CASE WHEN ISNULL(@FromDate,'1900-01-01') = '1900-01-01' THEN NULL ELSE CAST(@FromDate AS DATE) END
		SET @ToNoteDate = CASE WHEN ISNULL(@ToDate,'1900-01-01') = '1900-01-01' THEN NULL ELSE CAST(@ToDate AS DATE) END
		
		INSERT INTO #ContactNoteReason(ContactReason)
		SELECT R.IntegerCodeId
		FROM Recodes R JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
		WHERE ISNULL(R.RecordDeleted, 'N') = 'N' and ISNULL(RC.RecordDeleted, 'N') = 'N'
		and ISNULL(RC.CategoryCode,'') = 'InternalCollectionsCommunications'
				
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		CREATE TABLE #ResultSet (
			ContactDateTime DATETIME
			,ContactReason VARCHAR(250)
			,ContactType VARCHAR(250)
			,ContactStatus VARCHAR(250)
			,ContactQuickDetails VARCHAR(250)
			,ContactDetails VARCHAR(MAX)
			,ClientContactNoteId INT
			)

		SET @SortExpression = rtrim(ltrim(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'DateTime desc'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ClientContactNoteId)
			EXEC scsp_SCGetListPageInternalCommunications @PageNumber = @PageNumber
				,@PageSize = @PageSize
				,@SortExpression = @SortExpression
				,@FromDate = @FromDate
				,@ToDate = @ToDate
				,@Status = @Status
				,@Reason = @Reason
				,@Type = @Type
				,@ClientId = @ClientId
				,@OtherFilter = @OtherFilter
				,@CurrentUserId = @CurrentUserId
		END

		INSERT INTO #ResultSet (
			ContactDateTime
			,ContactReason
			,ContactType
			,ContactStatus
			,ContactQuickDetails
			,ContactDetails
			,ClientContactNoteId
			)
		SELECT CCN.ContactDateTime
			,GCR.CodeName
			,GCT.CodeName
			,GCS.CodeName
			,GCQ.CodeName
			,CCN.ContactDetails
			,CCN.ClientContactNoteId
		FROM ClientContactNotes CCN
		INNER JOIN Clients C ON C.ClientId = CCN.ClientId AND CCN.ClientId = @ClientId AND ISNULL(C.RecordDeleted, 'N') <> 'Y' AND ISNULL(CCN.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GCR ON CCN.ContactReason = GCR.GlobalCodeId
		LEFT JOIN GlobalCodes GCT ON CCN.ContactType = GCT.GlobalCodeId
		LEFT JOIN GlobalCodes GCS ON CCN.ContactStatus = GCS.GlobalCodeId
		LEFT JOIN GlobalCodes GCQ ON CCN.ContactQuickDetails = GCQ.GlobalCodeId
		WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #CustomFilters cf WHERE cf.ClientContactNoteId = CCN.ClientContactNoteId))
					OR (@CustomFiltersApplied = 'N'
						AND (CAST(CCN.ContactDateTime AS DATE) >= @FromNoteDate OR @FromNoteDate IS NULL)
						AND (CAST(CCN.ContactDateTime AS DATE) <= @ToNoteDate OR @ToNoteDate IS NULL)
						AND (CCN.ContactType = @Type OR @Type = 0)	  
						AND (CCN.ContactStatus = @Status OR @Status = 0)
						AND (CCN.ContactReason = @Reason OR @Reason = 0)
						AND EXISTS(SELECT 1 FROM #ContactNoteReason CNS WHERE CNS.ContactReason = CCN.ContactReason)
						))
					
		;WITH Counts
		AS (SELECT Count(*) AS TotalRows FROM #ResultSet)
			,RankResultSet
		AS (SELECT ContactDateTime
				,ContactReason
				,ContactType
				,ContactStatus
				,ContactQuickDetails
				,ContactDetails
				,ClientContactNoteId
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (ORDER BY   CASE WHEN @SortExpression = 'DateTime' THEN ContactDateTime END
										,CASE WHEN @SortExpression = 'DateTime DESC' THEN ContactDateTime END DESC
										,CASE WHEN @SortExpression = 'Reason' THEN ContactReason END
										,CASE WHEN @SortExpression = 'Reason DESC' THEN ContactReason END DESC
										,CASE WHEN @SortExpression = 'Type' THEN ContactType END
										,CASE WHEN @SortExpression = 'Type DESC' THEN ContactType END DESC
										,CASE WHEN @SortExpression = 'Status' THEN ContactStatus END
										,CASE WHEN @SortExpression = 'Status DESC' THEN ContactStatus END DESC										
										,CASE WHEN @SortExpression = 'ContactQuickDetails' THEN ContactQuickDetails END
										,CASE WHEN @SortExpression = 'ContactQuickDetails DESC' THEN ContactQuickDetails END DESC
										,CASE WHEN @SortExpression = 'Comments' THEN ContactDetails END
										,CASE WHEN @SortExpression = 'Comments DESC' THEN ContactDetails END DESC										
					,ClientContactNoteId) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)THEN (SELECT Isnull(TotalRows, 0) FROM Counts)ELSE (@PageSize)END) ClientContactNoteId
			,ContactDateTime
			,ContactReason
			,ContactType
			,ContactStatus
			,ContactQuickDetails
			,ContactDetails
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

		SELECT ClientContactNoteId
			,ContactDateTime
			,ContactReason
			,ContactType
			,ContactStatus
			,ContactQuickDetails
			,ContactDetails
			,@ClientId AS ClientId
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetListPageInternalCommunications') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


