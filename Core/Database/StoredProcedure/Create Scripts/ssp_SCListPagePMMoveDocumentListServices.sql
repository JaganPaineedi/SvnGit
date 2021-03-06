/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePMMoveDocumentListServices]    Script Date: 11/18/2011 16:25:58 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPagePMMoveDocumentListServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPagePMMoveDocumentListServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPagePMMoveDocumentListServices] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@AuthorIdFilter INT
	,@ProgramIdFilter INT
	,@StatusFilter INT
	,@DateOfServiceFromDate DATETIME
	,@DateOfServiceToDate DATETIME
	,@DocumentBannerFilter CHAR(1)
	,@OtherFilter INT
	,@ClientId INT
	,@ClinicianId INT
	,@ServiceId INT
	/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_ListPagePMMoveDocumentListService                                                                                       
                                                                         
-- Copyright: Streamline Healthcate Solutions                                                                                      
                                                                                     
-- Purpose: used by Move Document Service List page                                                
--                                                                                       
-- Updates:                                                                                                                                             
-- Date         Author      Purpose                                                                                      
-- 23.03.2010   Sandeep      used to implement Move document Services List Page 
-- 20 Jan 2013  Rohith		Services DateOfService format modified to compare with Fromdate and Todate                                                                                           
-- 27 Jan 2013  Gautam		Removed the ListPagePMMoveServiceDocuments and implemented temporary table Why :  task#1364 - Corebugs   
-- 29 June 2015	MD Hussain  Added StatusName in final result set w.r.t Core Bugs #2199  
--  21 Oct 2015 Revathi  what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--							why:task #609, Network180 Customization  /                                                                      
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFilters TABLE (ServiceId INT)
		DECLARE @Today DATETIME
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)

		SET @SortExpression = rtrim(ltrim(@SortExpression))

		IF isnull(@SortExpression, '') = ''
			SET @SortExpression = 'DateOfService desc'
		SET @ApplyFilterClicked = 'N'
		SET @ApplyFilterClicked = 'Y'
		SET @PageNumber = 1
		SET @Today = convert(CHAR(10), getdate(), 101)
		SET @CustomFiltersApplied = 'N'

		-- Apply custom filters                                                                        
		--                                            
		IF @StatusFilter > 10000
			OR @OtherFilter > 10000
		BEGIN
			INSERT INTO @CustomFilters (ServiceId)
			EXEC scsp_ListPageSCMoveDocumentServiceList @StatusFilter = @StatusFilter
				,@OtherFilter = @OtherFilter
		END;

		WITH ListDocumentServices
		AS (
			SELECT DISTINCT s.ServiceId
				,s.ProgramId
				,p.ProgramName
				,s.ProcedureCodeId
				,pro.DisplayAs AS ProcedureCodeName
				,
				-- sr.ScreenId,                        
				s.ClientId
				,s.DateOfService
				,s.STATUS
				,gcs.CodeName AS StatusName
				,s.ClinicianId AS AuthorId
				,a.LastName + ', ' + a.FirstName AS AuthorName
				,
				--Added by Revathi 21 Oct 2015
				CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END ClientName
				,d.DocumentId
				,d.CurrentDocumentVersionId AS 'Version'
				,DV.DocumentVersionId
				,d.DocumentCodeId
			FROM [Services] s
			INNER JOIN Programs p ON p.ProgramId = s.ProgramId
			INNER JOIN ProcedureCodes pro ON pro.ProcedureCodeId = s.ProcedureCodeId
			--Moified here                                        
			INNER JOIN Documents d ON d.ServiceId = s.ServiceId
			INNER JOIN DocumentVersions DV ON DV.DocumentId = d.DocumentId
				AND DV.DocumentVersionId = d.CurrentDocumentVersionId
				AND ISNULL(DV.RecordDeleted, 'N') <> 'Y'
			--end                                        
			INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = s.STATUS
			LEFT JOIN Staff a ON a.StaffId = s.ClinicianId
				AND isnull(s.RecordDeleted, 'N') = 'N'
			LEFT JOIN Clients c ON c.ClientId = s.ClientId
				AND isnull(c.RecordDeleted, 'N') = 'N'
			WHERE s.ClientID = @ClientId
				AND s.ServiceId <> @ServiceId
				AND s.STATUS <> 76
				AND pro.AssociatedNoteId IS NOT NULL
				AND (
					s.ClinicianId = @AuthorIdFilter
					OR isnull(@AuthorIdFilter, 0) = 0
					)
				AND (
					s.ProgramId = @ProgramIdFilter
					OR ISNULL(@ProgramIdFilter, 0) = 0
					)
				AND (
					isnull(convert(VARCHAR, s.DateOfService, 101), @DateOfServiceFromDate) >= @DateOfServiceFromDate
					AND isnull(convert(VARCHAR, s.DateOfService, 101), @DateOfServiceFromDate) <= @DateOfServiceToDate
					)
				AND (
					NOT EXISTS (
						SELECT 'X'
						FROM @CustomFilters
						)
					OR d.ServiceId IN (
						SELECT ServiceId
						FROM @CustomFilters
						)
					)
				AND (
					@StatusFilter = 0
					OR -- All Statuses                                                                        
					@StatusFilter > 10000
					OR -- Custom Status                                                                 
					(
						@StatusFilter = 70
						AND s.STATUS = 70
						)
					OR -- Scheduled                                                                       
					(
						@StatusFilter = 71
						AND s.STATUS = 71
						)
					OR -- Show                                                                        
					(
						@StatusFilter = 72
						AND s.STATUS = 72
						)
					OR -- No Show                                                                        
					(
						@StatusFilter = 73
						AND s.STATUS = 73
						)
					OR -- Cancel                                                                       
					(
						@StatusFilter = 75
						AND s.STATUS = 75
						)
					OR -- Complete                                                                                                     
					(
						@StatusFilter = 76
						AND s.STATUS = 76
						)
					) --Error                                                                                                                                    
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(DV.RecordDeleted, 'N') = 'N'
				AND isnull(a.RecordDeleted, 'N') = 'N'
				AND isnull(pro.RecordDeleted, 'N') = 'N'
			)
			,counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM ListDocumentServices
			)
			,rankresultset
		AS (
			SELECT ServiceId
				,ProgramId
				,ProgramName
				,ProcedureCodeId
				,ProcedureCodeName
				,
				--DocumentScreenId ,                                                                                  
				ClientId
				,DateofService
				,STATUS
				,StatusName
				,AuthorId
				,AuthorName
				,ClientName
				,DocumentId
				,[Version]
				,DocumentVersionId
				,DocumentCodeId
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'DateofService'
								THEN DateofService
							END
						,CASE 
							WHEN @SortExpression = 'DateofService desc'
								THEN DateofService
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProcedureName'
								THEN ProcedureCodeName
							END
						,CASE 
							WHEN @SortExpression = 'ProcedureName desc'
								THEN ProcedureCodeName
							END DESC
						,CASE 
							WHEN @SortExpression = 'StatusName'
								THEN StatusName
							END
						,CASE 
							WHEN @SortExpression = 'StatusName desc'
								THEN StatusName
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClinicianName'
								THEN AuthorName
							END
						,CASE 
							WHEN @SortExpression = 'ClinicianName desc'
								THEN AuthorName
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProgramName'
								THEN ProgramName
							END
						,CASE 
							WHEN @SortExpression = 'ProgramName desc'
								THEN ProgramName
							END DESC
					) AS RowNumber
			FROM ListDocumentServices
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ServiceId
			,ProgramId
			,ProgramName
			,ProcedureCodeId
			,ProcedureCodeName
			,
			--DocumentScreenId ,                                                                                  
			ClientId
			,DateofService
			,STATUS
			,StatusName
			,AuthorId
			,AuthorName
			,ClientName
			,DocumentId
			,[Version]
			,DocumentVersionId
			,DocumentCodeId
			,totalcount
			,rownumber
		INTO #finalresultset
		FROM rankresultset
		WHERE rownumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #finalresultset
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (totalcount % @PageSize)
					WHEN 0
						THEN Isnull((totalcount / @PageSize), 0)
					ELSE Isnull((totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(totalcount, 0) AS NumberOfRows
			FROM #finalresultset
		END

		SELECT ServiceId
			,ProgramName
			,ProcedureCodeName
			,ClientId
			,DateofService AS DateofService
			,STATUS
			,StatusName
			,AuthorName AS ClinicianName
			,DocumentId
			,[Version]
			,DocumentVersionId
			,DocumentCodeId
		FROM #finalresultset
		ORDER BY rownumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCListPagePMMoveDocumentListServices') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                           
				16
				,-- Severity.                                           
				1 -- State.                                           
				);
	END CATCH
END