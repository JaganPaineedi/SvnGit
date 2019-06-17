/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientHealthMaintenance]    Script Date: 08/27/2012 16:32:05 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCClientHealthMaintenance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageSCClientHealthMaintenance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientHealthMaintenance]    Script Date: 08/27/2012 16:32:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCClientHealthMaintenance] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(20)
	,@Status VARCHAR(10)
	,@FromDate VARCHAR(20)
	,@TODate VARCHAR(20)
	,@ClientID INT
	,@OtherFilter INT
	/*********************************************************************************/
	/* Stored Procedure: ssp_ListPageSCClientHealthMaintenance         */
	/* Copyright: Streamline Healthcare Solutions          */
	/* Creation Date:  16-AUG-2012               */
	/* Purpose: used by Health Data Maintenance List Page For Client        */
	/* Input Parameters:                */
	/* Output Parameters:PageNumber,PageSize,SortExpression,@HealthDataCategory,@DataTypeId  */
	/*      OtherFilter*/
	/* Return:                      */
	/* Called By:         */
	/* Calls:                   */
	/* Data Modifications:                */
	/* Updates:                   */
	/* Date              Author                  Purpose        */
	/* 27-AUG-2012       Rakesh Garg			 Created        */
	/* 11//19/2012       Vishant Garg           What--Add the check of createddate <= @Todate*/
	/*                                          Why--We need to check that start date is in between from createddate and end date with ref task #725 primary care bugs/features */
	/* 30/07/2014        Veena                  Change of table Names as per new DM  Meaningful Use #31.1 */
	/* 22-Nov-2016       Pavani			         What:Added  UserDecision, AcceptedRejectedDate,Staff columns and joining                                                                 ClientHealthMaintenanceDecisions table and changed start date,end date logic and Status                                                  condition 
                                                 Why : Meaningful Stage-3 Task#37  */
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		--  
		--Declare table to get data if Other filter exists -------  
		--  
		CREATE TABLE #ClientHealthMaintenanceTemplate (HealthMaintenacneTemplateId INT)

		--Get custom filters                                                  
		IF @OtherFilter > 10000
		BEGIN
			INSERT INTO #ClientHealthMaintenanceTemplate
			EXEC scsp_ListPageSCHealthDataAttributes @OtherFilter = @OtherFilter
		END
				--                                 
				--Insert data in to temp table which is fetched below by appling filter.   -- Current get data for testing Purpose  
				--   
				;

		WITH TotalClientHealthDataMaintenance
		AS (
			SELECT HMT.HealthMaintenanceTemplateId
				,Isnull(HMT.TemplateName, '') AS TemplateName
				,
				--ISNULL(PCC.Active,'N') as Status,
				CASE 
					WHEN CHMD.UserDecision = 'Y'
						THEN CASE 
								WHEN HMCT.Active = 'Y'
									THEN 'Yes'
								ELSE 'No'
								END
					ELSE ''
					END AS [Status]
				,
				--27-Nov-2016       Pavani
				CASE 
					WHEN CHMD.UserDecision = 'Y'
						THEN Convert(VARCHAR(10), HMCT.CreatedDate, 101)
					ELSE Convert(VARCHAR(10), CHMD.ModifiedDate, 101)
					END AS StartDate
				--End
				,CASE 
					WHEN HMCT.EndDate IS NOT NULL
						THEN Convert(VARCHAR(10), HMCT.EndDate, 101)
					ELSE ''
					END AS EndDate
				,--27-Nov-2016  Pavani
				CASE 
					WHEN CHMD.UserDecision = 'Y'
						THEN 'Accepted'
					ELSE 'Rejected'
					END AS UserDecision
				,CASE 
					WHEN CHMD.UserDecision = 'Y'
						THEN Convert(VARCHAR(10), HMCT.CreatedDate, 101)
					ELSE Convert(VARCHAR(10), CHMD.ModifiedDate, 101)
					END AS AcceptedRejectedDate
				,CHMD.ModifiedBy AS Staff
			FROM ClientHealthMaintenanceDecisions CHMD
			LEFT JOIN HealthMaintenanceClientTemplates HMCT ON CHMD.HealthMaintenanceTemplateId = HMCT.HealthMaintenanceTemplateId
				AND CHMD.ClientId = HMCT.ClientId AND ISNULL(HMCT.RecordDeleted, 'N') = 'N'
			INNER JOIN HealthMaintenanceTemplates HMT ON HMT.HealthMaintenanceTemplateId = CHMD.HealthMaintenanceTemplateId
			WHERE ISNULL(HMT.RecordDeleted, 'N') = 'N'
				AND ISNULL(CHMD.RecordDeleted, 'N') = 'N'
				
				--End
				AND CHMD.ClientId = @ClientID
				--27-Nov-2016    Pavani			
				AND CHMD.UserDecision IS NOT NULL
				AND (
					(
						CHMD.UserDecision = 'N'
						AND (cast(CHMD.ModifiedDate AS DATE) >= cast(@FromDate AS DATE))
						)
					OR (
						CHMD.UserDecision = 'Y'
						AND (
							cast(HMCT.CreatedDate AS DATE) >= cast(@FromDate AS DATE)
							AND cast(HMCT.CreatedDate AS DATE) <= cast(@TODate AS DATE)
							)
						AND (
							cast(HMCT.EndDate AS DATE) <= cast(@TODate AS DATE)
							OR HMCT.ENDDate IS NULL
							)
						)
					)
				AND (
					(
						CHMD.UserDecision = 'Y'
						AND (
							@Status = '0'
							OR HMCT.Active = @Status
							)
						)
					OR (CHMD.UserDecision = 'N')
					)--END
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalClientHealthDataMaintenance
			)
			,LisClientHealthDataMaintenance
		AS (
			SELECT HealthMaintenanceTemplateId
				,TemplateName
				,[Status]
				,StartDate
				,EndDate
				,UserDecision
				,AcceptedRejectedDate
				,Staff
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'TemplateName'
								THEN TemplateName
							END
						,CASE 
							WHEN @SortExpression = 'TemplateName desc'
								THEN TemplateName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Status'
								THEN STATUS
							END
						,CASE 
							WHEN @SortExpression = 'Status desc'
								THEN STATUS
							END DESC
						,CASE 
							WHEN @SortExpression = 'StartDate'
								THEN StartDate
							END
						,CASE 
							WHEN @SortExpression = 'StartDate desc'
								THEN StartDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'EndDate'
								THEN EndDate
							END
						,CASE 
							WHEN @SortExpression = 'EndDate desc'
								THEN EndDate
							END DESC
						,--27-Nov-2016  Pavani
						CASE 
							WHEN @SortExpression = 'UserDecision'
								THEN UserDecision
							END
						,CASE 
							WHEN @SortExpression = 'UserDecision desc'
								THEN UserDecision
							END DESC
						,CASE 
							WHEN @SortExpression = 'ARD'
								THEN AcceptedRejectedDate
							END
						,CASE 
							WHEN @SortExpression = 'ARD desc'
								THEN AcceptedRejectedDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Staff'
								THEN Staff
							END
						,CASE 
							WHEN @SortExpression = 'Staff desc'
								THEN Staff
							END DESC
						--End
					) AS RowNumber
			FROM TotalClientHealthDataMaintenance
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) HealthMaintenanceTemplateId
			,TemplateName
			,[Status]
			,StartDate
			,EndDate
			--27-Nov-2016  Pavani
			,UserDecision
			,AcceptedRejectedDate
			,Staff
			--End
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM LisClientHealthDataMaintenance
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT HealthMaintenanceTemplateId
			,TemplateName
			,[Status]
			,StartDate
			,EndDate
			--27-Nov-2016   Pavani
			,UserDecision
			,AcceptedRejectedDate
			,Staff
		--End
		FROM #FinalResultSet
		ORDER BY RowNumber

		DROP TABLE #FinalResultSet

		DROP TABLE #ClientHealthMaintenanceTemplate
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageSCClientHealthMaintenance') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


