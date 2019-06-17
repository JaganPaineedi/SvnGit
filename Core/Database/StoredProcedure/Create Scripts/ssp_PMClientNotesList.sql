/****** Object:  StoredProcedure [dbo].[ssp_PMClientNotesList]    Script Date: 09/29/2017 10:57:32 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientNotesList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMClientNotesList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClientNotesList]    Script Date: 09/29/2017 10:57:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMClientNotesList] --'','',0,200,'', 1, '', -1, 202476, '', 550, -1
	@SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@Active INT
	,@StartDate DATETIME
	,@NoteType INT
	,@ClientID INT
	,@OtherFilter INT
	,@StaffId INT
	--Added by Veena on 05/18/2016   
	,@WorkGroup INT
AS
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMClientNotesList
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to return data for the Client Notes list page.
--
-- Author:  Girish Sanaba
-- Date:    25 July 2011
--
-- *****History****
-- 19/09/2011		MSUma		Fix :Modified NoteTypeName,NoteLevelName to VARCHAR(250)
-- 19/01/2012		MSUma		Included additional filter when @EffectiveDate is NULL
-- 12.03.2012		PSelvan		Removed default @PageNumber 
-- 4.04.2012		Pelvan		Conditions added for Export 
-- 12.04.2012		MSuma		Removed temp table
-- 13.04.2012		PSelvan     Added Conditions for NumberOfPages.
-- 08 Jan 2015		Avi Goyal	What : Changed Client NoteType from GlobalCode to FlagTypes
								Why : Task 600 Security Alerts of Network-180 Customizations
-- 06 Apr 2016		Neelima		What : Added convert to the startdate condition
								Why : Camino - Environment Issues Tracking - #1.08	
-- 18 May 2016      Veena       What And Why: Adding workGroup EI #340  
-- 06 Apr 2016		Neelima			What : Reverted old changes and modified date condition
									Why : Bradford - Environment Issues Tracking #58							
-- 05 31 2016		Pradeep		What: FlagTypes.Active check is added
								Why : Bradford EIT #36		
-- 03 15 2017		Bibhu		What: Modified Active check Condition AND INNER Join with FlagTypes
								Why : Key Point - Support Go Live #991
-- 15-March-17     Sachin       What : When Flags are Denied in Staff Details,those should not be display in Client Flag Details.
   								Why :  Network180 Support Go Live #922
-- 8/16/2017        Hemant   	What:Included the flag types.Project:Network180 Support Go Live #307 						
---9/29/2017		Shankha     Why: Bear River - Support Go Live # 338/Bradford SGL# 748  
-- 8/07/2018		Vijay		Why:This "Client Flags" List Page ssp is modified to implement Client Tracking functionality
								What:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ClientNoteId INT NOT NULL)

		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @EffectiveDate DATETIME

		IF @StartDate = ''
			SET @EffectiveDate = NULL
		ELSE
			SET @EffectiveDate = @StartDate

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'NoteTypeName'
		-- 
		-- New retrieve - the request came by clicking on the Apply Filter button                   
		--
		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'

		--SET @PageNumber = 1
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ClientNoteId)
			EXEC scsp_PMClientNotesList @Active = @Active
				,@StartDate = @StartDate
				,@NoteType = @NoteType
				--Added by Veena on 05/18/2016   
				,@WorkGroup = @WorkGroup
				,@ClientID = @ClientID
				,@OtherFilter = @OtherFilter
				,@StaffId = @StaffId
		END
				--
				-- User Selections
				--		    
				--ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
				--          (
				--          [ClientNoteId] ASC
				--          ) 
				;

		WITH ListPagePMClientNotesList
		AS (
			SELECT CN.ClientNoteId
				,CN.ClientId
				,CN.NoteType
				,FT.FlagType AS NoteTypeName
				,CN.NoteLevel
				,GC2.CodeName AS NoteLevelName
				,CN.Note
				,CN.StartDate
				,CN.EndDate
				,CN.CreatedBy
				,CN.CreatedDate
				,CN.Active
				,CN.NoteType AS BitMapId
				,CN.WorkGroup  
				,GC3.CodeName AS WorkGroupName 
				,CN.TrackingProtocolId
				,CN.TrackingProtocolFlagId
				,CN.FlagRecurs
			FROM ClientNotes CN
			--LEFT JOIN TrackingProtocolFlags PTF ON PTF.TrackingProtocolFlagId = CN.TrackingProtocolFlagId AND ISNULL(PTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN TrackingProtocols PTD ON PTD.TrackingProtocolId = CN.TrackingProtocolId --AND ISNULL(PTD.RecordDeleted, 'N') = 'N' AND ISNULL(PTD.Active,'Y') = 'Y' 
			--LEFT JOIN FlagTypes FT1 ON FT1.FlagTypeId = PTF.FlagTypeId AND ISNULL(FT1.Active,'Y') = 'Y' AND ISNULL(FT1.RecordDeleted, 'N') = 'N' 
			LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType --AND ISNULL(FT.Active,'Y') = 'Y' AND ISNULL(FT.RecordDeleted, 'N') = 'N'  
			LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CN.NoteLevel
			LEFT JOIN GlobalCodes GC3 ON GC3.GlobalcodeId = CN.WorkGroup
			WHERE (
					(
						@CustomFiltersApplied = 'Y'
						AND EXISTS (
							SELECT *
							FROM #CustomFilters cf
							WHERE cf.ClientNoteId = CN.ClientNoteId
							)
						)
					OR (
						@CustomFiltersApplied = 'N'
						AND CN.ClientID = @ClientID
						AND (
							@Active = - 1
							OR -- All Category states  
							(
								@Active = 1
								AND ISNULL(CN.Active, 'N') = 'Y'
								)
							OR -- Active               
							(
								@Active = 2
								AND ISNULL(CN.Active, 'N') = 'N'
								)
							) -- InActive     
						AND (
							@NoteType = - 1
							OR (@NoteType = CN.NoteType)
							)
						--Added by Veena on 05/18/2016   
						AND (
							@WorkGroup = - 1
							OR (@WorkGroup = CN.WorkGroup)
							)
						AND (
							@EffectiveDate IS NULL
							OR (
								--@EffectiveDate >= isnull(CONVERT(DATE,CN.StartDate,101), GETDATE())  -- Added by Neelima
								--AND @EffectiveDate <= isnull(DATEADD(Day, 1, CONVERT(DATE,CN.EndDate,101)), '01/01/2070') -- Added by Neelima
								@EffectiveDate >= convert(VARCHAR(10), isnull(CN.StartDate, GETDATE()), 101) -- Added by Neelima
								AND @EffectiveDate <= DATEADD(Day, 1, convert(VARCHAR(10), isnull(CN.EndDate, '01/01/2070'), 101)) -- Added by Neelima								
								)
							)
						AND ISNULL(CN.RecordDeleted, 'N') = 'N'
						--AND ISNULL(FT.Active, 'N') = 'Y' -- 03 15 2017		Bibhu
						)
					-- Added By Sachin 
					-- When Flags are Denied in Staff Details,those should not be display in Client Flag List     
					AND (
						EXISTS (
							SELECT 1
							FROM viewstaffpermissions V
							WHERE V.permissiontemplatetype = 5928
								AND V.permissionitemid = FT.flagtypeid
								AND V.staffid = @StaffId
							)
						OR ISNULL(FT.PermissionedFlag, 'N') = 'N' -- added by Shankha for Bear River# 338/Bradford SGL# 516
						)
					-- END
					)
			)
			,counts
		AS (
			SELECT count(*) AS totalrows
			FROM ListPagePMClientNotesList
			)
			,RankResultSet
		AS (
			SELECT ClientNoteId
				,ClientId
				,NoteType
				,NoteTypeName
				,NoteLevel
				,NoteLevelName
				,Note
				,StartDate
				,EndDate
				,CreatedBy
				,CreatedDate
				,Active
				,BitMapId
				,WorkGroup
				,WorkGroupName
				,TrackingProtocolId
				,TrackingProtocolFlagId
				,FlagRecurs
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'NoteTypeName'
								THEN NoteTypeName
							END
						,CASE 
							WHEN @SortExpression = 'NoteTypeName desc'
								THEN NoteTypeName
							END DESC
						,CASE 
							WHEN @SortExpression = 'NoteLevelName'
								THEN NoteLevelName
							END
						,CASE 
							WHEN @SortExpression = 'NoteLevelName desc'
								THEN NoteLevelName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Note'
								THEN Note
							END
						,CASE 
							WHEN @SortExpression = 'Note desc'
								THEN Note
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
						,CASE 
							WHEN @SortExpression = 'CreatedBy'
								THEN CreatedBy
							END
						,CASE 
							WHEN @SortExpression = 'CreatedBy desc'
								THEN CreatedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'CreatedDate'
								THEN CreatedDate
							END
						,CASE 
							WHEN @SortExpression = 'CreatedDate desc'
								THEN CreatedDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'WorkGroup'
								THEN WorkGroup
							END
						,CASE 
							WHEN @SortExpression = 'WorkGroup desc'
								THEN WorkGroup
							END DESC
						,CASE 
							WHEN @SortExpression = 'TrackingProtocolId'
								THEN TrackingProtocolId
							END
						,CASE 
							WHEN @SortExpression = 'TrackingProtocolId desc'
								THEN TrackingProtocolId
							END DESC
						,CASE 
							WHEN @SortExpression = 'TrackingProtocolFlagId'
								THEN TrackingProtocolFlagId
							END
						,CASE 
							WHEN @SortExpression = 'TrackingProtocolFlagId desc'
								THEN TrackingProtocolFlagId
							END DESC
						,CASE 
							WHEN @SortExpression = 'FlagRecurs'
								THEN FlagRecurs
							END
						,CASE 
							WHEN @SortExpression = 'FlagRecurs desc'
								THEN FlagRecurs
							END DESC
							
						,ClientNoteId
					) AS RowNumber
			FROM ListPagePMClientNotesList
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
				) ClientNoteId
			,ClientId
			,NoteType
			,NoteTypeName
			,NoteLevel
			,NoteLevelName
			,Note
			,StartDate
			,EndDate
			,CreatedBy
			,CreatedDate
			,Active
			,BitMapId
			,WorkGroup
			,WorkGroupName
			,TrackingProtocolId
			,TrackingProtocolFlagId 
			,FlagRecurs
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
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

		SELECT ClientNoteId
			,ClientId
			,NoteType
			,NoteTypeName
			,NoteLevel
			,NoteLevelName
			,Note
			,StartDate
			,EndDate
			,CreatedBy
			,CreatedDate
			,Active
			,BitMapId
			,WorkGroup
			,WorkGroupName
			,TrackingProtocolId
			,TrackingProtocolFlagId
			,FlagRecurs 
		FROM #FinalResultSet
		ORDER BY RowNumber

		DROP TABLE #CustomFilters
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientNotesList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + 
			'*****' + CONVERT(VARCHAR, ERROR_STATE())

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


