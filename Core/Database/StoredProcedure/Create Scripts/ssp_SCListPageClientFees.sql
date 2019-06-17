 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCListPageClientFees')
	BEGIN
		DROP  Procedure  ssp_SCListPageClientFees
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageClientFees] --0,200,'BeginDate desc','','',0,0,0,-1,314947,50501 
(
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FeeBeginDate DATETIME
	,@FeeEndDate DATETIME
	,@ProgramId INT
	,@LocationId INT
	,@EnteredBy INT
	,@OtherFilter INT
	,@ClientId int
	,@ClientFeeTypeId INT=null
	)
	/********************************************************************************                                                 
** Stored Procedure: ssp_SCListPageClientFees                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 27-JULY-2015	   Akwinass			   What:Get Client Fee Data     
**									   Why:Task #995 in Valley - Customizations 
   21-OCT-2015    Manikandan		   What:Added ClientFeeTypeid to filter the data
									   Why:Task #367.2 Network 180 - Customizations

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		
		IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL
			DROP TABLE #FinalResultSet

		IF OBJECT_ID('tempdb..#ClientFees') IS NOT NULL
			DROP TABLE #ClientFees

		IF OBJECT_ID('tempdb..#tempStandardRatePercentage') IS NOT NULL
			DROP TABLE #tempStandardRatePercentage

		IF OBJECT_ID('tempdb..#tempStandardRate') IS NOT NULL
			DROP TABLE #tempStandardRate
			
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'BeginDate desc'

		CREATE TABLE #tempStandardRatePercentage (
			PerSessionRatePercentage DECIMAL(18, 2)
			,PerDayRatePercentage DECIMAL(18, 2)
			,PerWeekRatePercentage DECIMAL(18, 2)
			,PerMonthRatePercentage DECIMAL(18, 2)
			,PerYearRatePercentage DECIMAL(18, 2)
			,ClientId INT
			,ClientFeeId INT
			--,ClientFeeTypeName VARCHAR(100)
			)

		INSERT INTO #tempStandardRatePercentage
		SELECT DISTINCT CCF.PerSessionRatePercentage
			,CCF.PerDayRatePercentage
			,CCF.PerWeekRatePercentage
			,CCF.PerMonthRatePercentage
			,CCF.PerYearRatePercentage
			,CCF.ClientId
			,CCF.ClientFeeId
			--,CCF.ClientFeeType
			
		FROM ClientFees CCF

		CREATE TABLE #tempStandardRate (
			PerSessionRateAmount DECIMAL(18, 2)
			,PerDayRateAmount DECIMAL(18, 2)
			,PerWeekRateAmount DECIMAL(18, 2)
			,PerMonthRateAmount DECIMAL(18, 2)
			,PerYearRateAmount DECIMAL(18, 2)
			,ClientId INT
			,ClientFeeId VARCHAR(100)
			)

		INSERT INTO #tempStandardRate
		SELECT DISTINCT CCF.PerSessionRateAmount
			,CCF.PerDayRateAmount
			,CCF.PerWeekRateAmount
			,CCF.PerMonthRateAmount
			,CCF.PerYearRateAmount
			,CCF.ClientId
			,CCF.ClientFeeId
		FROM ClientFees CCF

		--        
		--Declare table to get data if Other filter exists -------        
		--        
		CREATE TABLE #ClientFees (ClientFeeId INT NOT NULL)

		--        
		--Get custom filters         
		--                                                    
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_GetClientFeeListData', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #ClientFees (ClientFeeId)
				EXEC scsp_GetClientFeeListData @OtherFilter = @OtherFilter
			END
		END;

		WITH TotalClientFees
		AS (
			SELECT DISTINCT CCF.ClientFeeId
				,CCF.ClientId
				,CONVERT(VARCHAR(10), CCF.StartDate, 101) AS StartDate
				,CONVERT(VARCHAR(10), CCF.EndDate, 101) AS EndDate
				,CASE WHEN ISNULL(CCF.AllPrograms,'N') = 'N' THEN [dbo].[ssf_SCGetClientFeePrograms](CCF.ClientFeeId,'TEXT') ELSE 'All Selected' END Programs
				,CASE WHEN ISNULL(CCF.AllLocations,'N') = 'N' THEN [dbo].[ssf_SCGetClientFeeLocations](CCF.ClientFeeId,'TEXT') ELSE 'All Selected' END Locations
				--Manikandan 10-21-2015 
				,isnull(dbo.csf_GetGlobalCodeNameById(CCF.ClientFeeType),'')  ClientFeeType
			
				,CASE WHEN ISNULL(CCF.AllProcedureCodes,'N') = 'N' THEN [dbo].[ssf_SCGetClientFeeProcedureCodes](CCF.ClientFeeId,'TEXT') ELSE 'All Selected' END ProcedureCodes
				,(SELECT TOP 1 S.LastName + ',' + S.FirstName FROM Staff S WHERE S.UserCode = CCF.CreatedBy AND ISNULL(S.RecordDeleted,'N') = 'N') AS EnteredBy
				,(
					SELECT STUFF((
								SELECT  + CASE 
										WHEN ISNULL(CCF.PerSessionRatePercentage, .00) = .00
											THEN ''
										ELSE (',' + ' ' + CAST(CCF.PerSessionRatePercentage AS VARCHAR) + '%' )
										END + CASE 
										WHEN ISNULL(CCF.PerDayRatePercentage, .00) = .00
											THEN ''
										ELSE (',' + ' '+ CAST(CCF.PerDayRatePercentage AS VARCHAR) + '%')
										END + CASE 
										WHEN ISNULL(CCF.PerWeekRatePercentage, .00) = .00
											THEN ''
										ELSE (',' + ' '+ CAST(CCF.PerWeekRatePercentage AS VARCHAR) + '%')
										END + CASE 
										WHEN ISNULL(CCF.PerMonthRatePercentage, .00) = .00
											THEN ''
										ELSE (',' + ' '+ CAST(CCF.PerMonthRatePercentage AS VARCHAR) + '%')
										END + CASE 
										WHEN ISNULL(CCF.PerYearRatePercentage, .00) = .00
											THEN ''
										ELSE (',' + ' '+ CAST(CCF.PerYearRatePercentage AS VARCHAR) + '%')
										END
								FROM #tempStandardRatePercentage t1
								WHERE t1.ClientId = CCF.ClientId
									AND t1.ClientFeeId = CCF.ClientFeeId
								FOR XML PATH('')
									,type
								).value('.', 'varchar(max)'), 1, 2, '') AS PerSessionRatePercentage
					) AS PerSessionRatePercentage
				,(
					SELECT STUFF((
								SELECT CASE 
										WHEN ISNULL(CCF.PerSessionRateAmount, .00) = .00
											THEN ''
										ELSE ('$' + CAST(CCF.PerSessionRateAmount AS VARCHAR) + ' Per Session')
										END + CASE 
										WHEN ISNULL(CCF.PerDayRateAmount, .00) = .00
											THEN ''
										ELSE (',' + '$' + CAST(CCF.PerDayRateAmount AS VARCHAR) + ' Per Day' )
										END + CASE 
										WHEN ISNULL(CCF.PerWeekRateAmount, .00) = .00
											THEN ''
										ELSE(',' +'$' + CAST(CCF.PerWeekRateAmount AS VARCHAR) + ' Per Week' )
										END + CASE 
										WHEN ISNULL(CCF.PerMonthRateAmount, .00) = .00
											THEN ''
										ELSE (',' + '$' + CAST(CCF.PerMonthRateAmount AS VARCHAR) + ' Per Month')
										END + CASE 
										WHEN ISNULL(CCF.PerYearRateAmount, .00) = .00
											THEN ''
										ELSE (',' +'$' + CAST(CCF.PerYearRateAmount AS VARCHAR) + ' Per Year')
										END
								FROM #tempStandardRate t
								WHERE t.ClientId = CCF.ClientId
									AND t.ClientFeeId = CCF.ClientFeeId
								FOR XML PATH('')
									,type
								).value('.', 'varchar(max)'), 1,1, '') AS PerSessionRateAmount
					) AS PerSessionRateAmount
				,CCF.Comments
				,CCF.CreatedBy
				,CONVERT(VARCHAR(10), CCF.CreatedDate, 101) AS CreatedDate
			FROM ClientFees CCF
			WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #ClientFees cf WHERE cf.ClientFeeId = CCF.ClientFeeId)) 
					OR (@CustomFiltersApplied = 'N'
						AND (ISNULL(@ProgramId, 0) = 0 OR EXISTS(SELECT 1 FROM ClientFeePrograms CFP JOIN Programs P ON CFP.ProgramId = P.ProgramId WHERE P.ProgramId = @ProgramId AND CFP.ClientFeeId = CCF.ClientFeeId AND isnull(P.RecordDeleted, 'N') = 'N' AND isnull(CFP.RecordDeleted, 'N') = 'N'))
						AND (ISNULL(@FeeBeginDate, '') = '' OR CAST(CCF.StartDate AS DATE) >= CAST(@FeeBeginDate AS DATE))
						AND (ISNULL(@FeeEndDate, '') = '' OR CAST(CCF.EndDate AS DATE) <= CAST(@FeeEndDate AS DATE))
						AND (ISNULL(@EnteredBy, 0) = 0 OR EXISTS(SELECT 1 FROM Staff S WHERE S.StaffId = @EnteredBy AND S.UserCode = CCF.CreatedBy AND ISNULL(S.RecordDeleted,'N') = 'N'))
						AND (ISNULL(@LocationId, 0) = 0 OR EXISTS(SELECT 1 FROM ClientFeeLocations CFL JOIN Locations L ON CFL.LocationId = L.LocationId WHERE L.LocationId = @LocationId AND CFL.ClientFeeId = CCF.ClientFeeId AND isnull(L.RecordDeleted, 'N') = 'N' AND isnull(CFL.RecordDeleted, 'N') = 'N'))
						
						AND (ISNULL(@ClientFeeTypeId, 0) = 0  OR CCF.ClientFeeType=@ClientFeeTypeId)						
						AND ISNULL(CCF.RecordDeleted, 'N') = 'N' and CCF.ClientId = @ClientId
					))
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalClientFees
			)
			,ClientFeeList
		AS (
			SELECT DISTINCT ClientFeeId
				,ClientId
				,StartDate
				,EndDate
				,Programs
				,Locations
				--Manikandan 10-21-2015 
				,ClientFeeType
				,ProcedureCodes
				,EnteredBy
				,PerSessionRatePercentage
				,PerSessionRateAmount
				,Comments
				,CreatedBy
				,CreatedDate				
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY
					 --CASE 
						--	WHEN @SortExpression = 'Programs'
						--		THEN Programs
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'BeginDate'
						--		THEN StartDate
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'EndDate'
						--		THEN EndDate
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'StandardRate'
						--		THEN PerSessionRatePercentage
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'Amount'
						--		THEN PerSessionRateAmount
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'EnteredBy'
						--		THEN EnteredBy
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'Locations'
						--		THEN Locations
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'ProcedureCodes'
						--		THEN ProcedureCodes
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'Comment'
						--		THEN Comments
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'CreatedBy'
						--		THEN CreatedBy
						--	END
						--,CASE 
						--	WHEN @SortExpression = 'CreatedOn'
						--		THEN CreatedDate
						--	END
						CASE 
							WHEN @SortExpression = 'Programs'
								THEN Programs
							END
					
						,CASE 
							WHEN @SortExpression = 'Programs desc'
								THEN Programs
							END DESC
							--Manikandan 10-21-2015
						,CASE 
							WHEN @SortExpression = 'ClientFeeType'
								THEN ClientFeeType
							END
						,CASE 
							WHEN @SortExpression = 'ClientFeeType desc'
								THEN ClientFeeType
							END
						,CASE 
						
							WHEN @SortExpression = 'BeginDate'
								THEN StartDate
							END
						,CASE 
							WHEN @SortExpression = 'BeginDate desc'
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
						,CASE 
							WHEN @SortExpression = 'StandardRate'
								THEN PerSessionRatePercentage
							END
						,CASE 
							WHEN @SortExpression = 'StandardRate desc'
								THEN PerSessionRatePercentage
							END DESC
						,CASE 
							WHEN @SortExpression = 'Amount'
								THEN PerSessionRateAmount
							END
						,CASE 
							WHEN @SortExpression = 'Amount desc'
								THEN PerSessionRateAmount
							END DESC
						,CASE 
							WHEN @SortExpression = 'EnteredBy'
								THEN EnteredBy
							END
						,CASE 
							WHEN @SortExpression = 'EnteredBy desc'
								THEN EnteredBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'Locations'
								THEN Locations
							END
						,CASE 
							WHEN @SortExpression = 'Locations desc'
								THEN Locations
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProcedureCodes'
								THEN ProcedureCodes
							END
						,CASE 
							WHEN @SortExpression = 'ProcedureCodes desc'
								THEN ProcedureCodes
							END DESC
						,CASE 
							WHEN @SortExpression = 'Comment'
								THEN Comments
							END 						
						,CASE 
							WHEN @SortExpression = 'Comment desc'
								THEN Comments
							END DESC
						,CASE 
							WHEN @SortExpression = 'CreatedBy'
								THEN CreatedBy
							END 
						,CASE 
							WHEN @SortExpression = 'CreatedBy desc'
								THEN CreatedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'CreatedOn'
								THEN CreatedDate
							END 
						,CASE 
							WHEN @SortExpression = 'CreatedOn desc'
								THEN CreatedDate
							END DESC,ClientFeeId
					) AS RowNumber
			FROM TotalClientFees
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
				) ClientFeeId
			,ClientId
			,StartDate
			,EndDate
			,Programs
			,Locations
			--Manikandan 10-21-2015 
			,ClientFeeType			
			,ProcedureCodes
			,EnteredBy
			,PerSessionRatePercentage
			,PerSessionRateAmount
			,Comments
			,CreatedBy
			,CreatedDate			
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM ClientFeeList
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
		
		IF @PageSize=0 OR @PageSize=-1
		BEGIN
			SELECT @PageSize=COUNT(*) FROM #FinalResultSet
		END

		IF (SELECT ISNULL(COUNT(*), 0) FROM #FinalResultSet) < 1
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

		SELECT ClientFeeId
			,ClientId
			,StartDate
			,EndDate
			,PerSessionRatePercentage
			,PerSessionRateAmount
			,Locations
			--Manikandan 10-21-2015
			,ClientFeeType			
			,Programs			
			,ProcedureCodes
			,EnteredBy			
			,Comments
			,CreatedBy
			,CreatedDate			
		FROM #FinalResultSet
		ORDER BY RowNumber
		
		IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL
			DROP TABLE #FinalResultSet

		IF OBJECT_ID('tempdb..#ClientFees') IS NOT NULL
			DROP TABLE #ClientFees

		IF OBJECT_ID('tempdb..#tempStandardRatePercentage') IS NOT NULL
			DROP TABLE #tempStandardRatePercentage

		IF OBJECT_ID('tempdb..#tempStandardRate') IS NOT NULL
			DROP TABLE #tempStandardRate
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCListPageClientFees') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
 