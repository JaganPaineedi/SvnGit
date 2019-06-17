IF OBJECT_ID('dbo.ssp_ListPageSCAlert', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[ssp_ListPageSCAlert]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCAlert] 
(
	@SessionId VARCHAR(30),
	@InstanceId INT,
	@PageNumber INT,
	@PageSize INT,
	@SortExpression VARCHAR(100),
	@StaffId INT,
	@ClientId INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@Type INT,
	@OtherFilter INT,
	@SeletedAlertId INT = NULL
)
/***********************************************************************************************************************
	Stored Procedure:	dbo.ssp_ListPageSCAlert  
	Copyright:			Streamline Healthcate Solutions L.L.C.
	Purpose:			Alert Page
========================================================================================================================
	Modification Log
========================================================================================================================
	[Date]		[Author]		[Purpose]
	----------	--------------	--------------------------------------------------------------------
	7.1.2010	Mohit Madaan	Created. 
	2.13.2012	T. Remisoski	added RecordDeleted checks on joins 
	05.23.2012	Vikas Kashyap	(a.reference=DC.DocumentId) Convert to Statement (a.DocumentId=DC.DocumentId)  
	06.04.2012	A. Kumar Srivastava	#49, Alerts: Document Reference Link Does Not Open Correct Document,SmartcareWeb 
								Phase 3 Development  
	06-Jan-2014	Revathi			what: Added join with StaffClients table to display associated Clients for Login staff  
								why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should 
								always have StaffID as an input parameter  
	29-07-2014	scooter			revised Revathi's JOIN from "JOIN" to "LEFT JOIN" to correct "Van Buren - Support #318"  
	30-09-2014	scooter			removed Revathi's JOIN and added StaffClients logic per Slavik                          
	10-12-2015  Basudev Sahu	Modified  For Task #609 Network180 Customization .  
	05-06-2016  Ravichandra     Removed the physical table ListPageSCAlerts from SP  
								Why:Task #108, Engineering Improvement Initiatives- NBL(I) 108 - Do NOT use list page 
								tables for remaining list pages (refer #107)  
	02-09-2016  Akwinass        What: ClientAccess Rules check implemented.
								Why: Not displaying client records, when staff has permission from ClientAccess Rules.
								ACE Task: #127 in Key Point - Support Go Live. 
	25-05-2017  K.Soujanya      What:Added PrimaryKey column and CASE condition logic to redirect the user to Detail 
								Page, when click on reference hyperlink on alert page.
                                Why:AspenPointe-Customizations,Task#564.11
	04/30/2018	Ting-Yu Mu		What: Modified the INSERT INTO #ResultSet statement with limited CHARs to comply with 
								the temp table declaration 
								Why: Spring River - Support Go Live # 243
***********************************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ResultSet (
			RowNumber INT
			,PageNumber INT
			,AlertId INT
			,AlertType VARCHAR(100)
			,[Message] VARCHAR(MAX)
			,DateReceived DATETIME
			,ClientId INT
			,ClientName VARCHAR(100)
			,[Subject] VARCHAR(100)
			,FollowUp VARCHAR(3)
			,PrimaryKey VARCHAR(250)
			,ReferenceId INT
			,ReferenceName VARCHAR(100)
			,ReferenceScreenId INT
			,ReferenceDocumentCodeId INT
			,RecordDeleted CHAR(1)
			)

		INSERT INTO #ResultSet (
			AlertId
			,AlertType
			,[Message]
			,DateReceived
			,ClientId
			,ClientName
			,[Subject]
			,FollowUp
			,PrimaryKey
			,ReferenceId
			,ReferenceName
			,ReferenceScreenId
			,ReferenceDocumentCodeId
			,RecordDeleted
			)
		SELECT a.alertid AS AlertId
			,LEFT(d.CodeName, 100) AS AlertType									-- ==== TMU modified on 04/30/2018 =====
			,a.message AS [Message]
			,cast(convert(VARCHAR, a.DateReceived, 101) AS DATETIME) AS DateReceived
			,b.clientid AS ClientId
			,LEFT(CASE 
				WHEN ISNULL(b.ClientId, 0) <> 0
					THEN CASE -- modify by Basudev  for  network 180 task #609  
							WHEN ISNULL(b.ClientType, 'I') = 'I'
								THEN ISNULL(b.LastName, '') + ', ' + ISNULL(b.FirstName, '')
							ELSE ISNULL(b.OrganizationName, '')
							END
				ELSE ''
				END, 100) AS ClientName											-- ==== TMU modified on 04/30/2018 =====
			--, isnull(rtrim(b.lastname) + ', ' + rtrim(b.firstname), '') AS ClientName  
			,LEFT(a.[Subject], 100)												-- ==== TMU modified on 04/30/2018 =====
			,a.FollowUp
			--25-May-2017  K.Soujanya
			--Starts---
			,CASE 
				WHEN a.PrimaryKeyName IS NOT NULL
					THEN a.PrimaryKeyName
				ELSE 'DocumentId'
				END AS PrimaryKey
			--c.staffid,  
			,CASE 
				WHEN a.PrimaryKeyValue IS NOT NULL
					THEN a.PrimaryKeyValue
				ELSE DC.DocumentId
				END AS ReferenceId
			,LEFT(CASE 
				WHEN a.PrimaryKeyValue IS NOT NULL
					THEN a.Reference
				ELSE isnull(doc.documentname, '')
				END, 100) AS ReferenceName										-- ==== TMU modified on 04/30/2018 =====
			,CASE 
				WHEN a.PrimaryKeyValue IS NOT NULL
					THEN a.ReferenceLink
				ELSE Screens.ScreenId
				END AS ReferenceScreenId
			--End 
			,DC.DocumentCodeId AS ReferenceDocumentCodeId
			,
			--isnull(rtrim(c.lastname)+ ', '+ rtrim(c.firstname),'') as StaffName,  
			a.RecordDeleted
		FROM alerts a
		LEFT JOIN clients b ON a.clientid = b.clientid
			AND isnull(b.recorddeleted, 'N') <> 'Y' --and b.active='Y'  
		INNER JOIN staff c ON a.tostaffid = c.staffid
		LEFT JOIN GlobalCodes d ON a.alerttype = d.GlobalCodeId
		--left join Documents DC on a.reference=DC.DocumentId  
		LEFT JOIN Documents DC ON a.DocumentId = DC.DocumentId
		LEFT JOIN documentcodes doc ON dc.documentcodeid = doc.documentcodeid
			AND ISNULL(doc.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Screens ON Screens.DocumentCodeId = doc.DocumentCodeId
			AND ISNULL(Screens.RecordDeleted, 'N') <> 'Y'
		WHERE (
				b.ClientId = @ClientId
				OR @ClientId = 0
				)
			AND (
				a.DateReceived >= @FromDate
				AND a.DateReceived <= DATEADD(day, 1, @ToDate)
				)
			--and  (a.AlertType=@Type or @Type=183)  
			AND (
				@Type = 183
				OR -- All Type  
				(
					@Type = 172
					AND a.AlertType = 80
					)
				OR (
					@Type = 173
					AND a.AlertType = 81
					)
				OR (
					@Type = 174
					AND a.AlertType = 82
					)
				OR (
					@Type = 175
					AND a.AlertType = 83
					)
				OR (
					@Type = 176
					AND a.AlertType = 84
					)
				OR (
					@Type = 177
					AND a.AlertType = 85
					)
				OR (
					@Type = 178
					AND a.AlertType = 86
					)
				OR (
					@Type = 179
					AND a.AlertType = 10992
					)
				OR (
					@Type = 180
					AND a.AlertType = 10993
					)
				OR (
					@Type = 181
					AND a.AlertType = 11021
					)
				OR (
					@Type = 182
					AND a.AlertType = 11509
					)
				)
			AND (
				c.StaffId = @StaffId
				OR @StaffId = 0
				)
			--  BEGIN added by scooter per Slavik, VB #318  
			AND (
				a.ClientId IS NULL
				OR EXISTS (
					SELECT '*'
					FROM StaffClients sc
					WHERE sc.ClientId = a.ClientId
						AND sc.StaffId = @StaffId
					)
				--  02-SEP-2016 ---- Akwinass
				OR EXISTS (
					SELECT *
					FROM ViewStaffPermissions
					WHERE StaffId = @StaffId
						AND PermissionTemplateType = 5705
						AND PermissionItemId = 5741
					)
				) --  END added by scooter per Slavik, VB #318  
			AND ISNULL(a.recorddeleted, 'N') = 'N';

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT AlertId
				,AlertType
				,[Message]
				,DateReceived
				,ClientId
				,ClientName
				,[Subject]
				,FollowUp
				,PrimaryKey
				,ReferenceId
				,ReferenceName
				,ReferenceScreenId
				,ReferenceDocumentCodeId
				,RecordDeleted
				,Count(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'AlertType'
								THEN AlertType
							END
						,CASE 
							WHEN @SortExpression = 'AlertType desc'
								THEN AlertType
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateReceived'
								THEN DateReceived
							END
						,CASE 
							WHEN @SortExpression = 'DateReceived desc'
								THEN DateReceived
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName desc'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Subject'
								THEN Subject
							END
						,CASE 
							WHEN @SortExpression = 'Subject desc'
								THEN Subject
							END DESC
						,CASE 
							WHEN @SortExpression = 'FollowUp'
								THEN FollowUp
							END
						,CASE 
							WHEN @SortExpression = 'FollowUp desc'
								THEN FollowUp
							END DESC
						,CASE 
							WHEN @SortExpression = 'ReferenceName'
								THEN ReferenceName
							END
						,CASE 
							WHEN @SortExpression = 'ReferenceName desc'
								THEN ReferenceName
							END DESC
						,AlertId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) AlertId
			,AlertType
			,[Message]
			,DateReceived
			,ClientId
			,ClientName
			,[Subject]
			,FollowUp
			,PrimaryKey
			,ReferenceId
			,ReferenceName
			,ReferenceScreenId
			,ReferenceDocumentCodeId
			,RecordDeleted
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(Count(*), 0)
				FROM #FinalResultSet
				) < 1
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
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT	AlertId
				,AlertType
				,[Message]
				,DateReceived
				,ClientId
				,ClientName
				,[Subject]
				,FollowUp
				,PrimaryKey
				,ReferenceId
				,ReferenceName
				,ReferenceScreenId
				,ReferenceDocumentCodeId
				,RecordDeleted
		FROM	#FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageSCAlert') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR 
		(
			@error,-- Message text.  
			16,-- Severity.  
			1 -- State.  
		);
	END CATCH
END
