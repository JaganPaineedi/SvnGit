/****** Object:  StoredProcedure [dbo].[ssp_SCSuperviseesDocumentDashboardWidget]    Script Date: 08/19/2018 10:51:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSuperviseesDocumentDashboardWidget]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_SCSuperviseesDocumentDashboardWidget
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSuperviseesDocumentDashboardWidget]    Script Date: 08/19/2018 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [DBO].[ssp_SCSuperviseesDocumentDashboardWidget] (@StaffId INT)
	WITH RECOMPILE
AS --=============================================        
-- Author:  Vandana Ojha    
-- Create date: 8/18/2018        
-- exec ssp_SCSuperviseesDocumentDashboardWidget 550   
-- Description: Used to get all recordsets related to Supervisees Document widget.      
--=============================================           
BEGIN
	BEGIN TRY
		DECLARE @MainOrganizationLevelId INT = NULL
		DECLARE @OrganizationLevelId INT = NULL

		SELECT a.OrganizationLevelId
			,ISNULL(a.LevelName, ISNULL(d.ProgramName, '')) + '(' + b.LevelTypeName + ')' AS 'LevelName'
			,ISNULL(a.LevelName, ISNULL(d.ProgramName, '')) AS 'OrganizationLevelLevelName'
			,b.LevelTypeName
		INTO #tempStaffOrgLevel
		FROM OrganizationLevels a
		INNER JOIN OrganizationLevelTypes b ON a.LevelTypeId = b.LevelTypeId
		LEFT JOIN programs d ON a.ProgramId = d.ProgramId
		WHERE (
				EXISTS (
					SELECT 'X'
					FROM OrganizationLevelStaff OL
					WHERE a.OrganizationLevelId = OL.OrganizationLevelId
						AND ISNULL(RecordDeleted, 'N') = 'N'
						AND EXISTS (
							SELECT 1
							FROM StaffSupervisors SS
							WHERE SS.StaffId = OL.StaffId
								AND SS.SupervisorId = @StaffId
								AND ISNULL(SS.RecordDeleted, 'N') = 'N'
							)
						AND StaffId = @StaffId
					)
				OR ManagerId = @StaffId
				)
			AND ISNULL(a.RecordDeleted, 'N') = 'N'
		ORDER BY b.LevelTypeId
		-------->  SiteMap creation <------------------          
		DECLARE @MainLevelNumber INT
			,@LevelNumber INT

		--------->Bind Grid Data <--------------------------          
		CREATE TABLE #OrganisationSubLevels (
			OrganizationLevelId INT
			,LevelName VARCHAR(250)
			)

		CREATE TABLE #OrganisationSubLevelStaffs (
			StaffId INT
			,OrganizationLevelId INT
			)

		CREATE TABLE #DocumentCodeFilters (DocumentCodeId INT)

		INSERT INTO #DocumentCodeFilters (DocumentCodeId)
		EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = 0

		-------- Getting the documentcode from document nevigations           
		DECLARE @Today DATETIME;

		SET @Today = CONVERT(CHAR(10), GETDATE(), 101)

		---------> getting all programid's <----------------          
		--------------  
		INSERT INTO #OrganisationSubLevels (
			OrganizationLevelId
			,LevelName
			)
		SELECT DISTINCT S.staffid AS OrganizationLevelId
			,ISNULL(LastName + ', ', '') + FirstName AS LevelName
		FROM Staff S
		INNER JOIN StaffSupervisors SS ON SS.StaffId=S.StaffId
		WHERE SS.SupervisorId=@StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(SS.RecordDeleted, 'N') = 'N'
	
         
		INSERT INTO #OrganisationSubLevelStaffs (
			staffId
			,OrganizationLevelId
			)
		SELECT DISTINCT S.staffid
			,S.staffid AS OrganizationLevelId
			FROM Staff S
		INNER JOIN StaffSupervisors SS ON SS.StaffId=S.StaffId
		WHERE SS.SupervisorId=@StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(SS.RecordDeleted, 'N') = 'N'
	
		-----------------  
		-- 6/8/2015 njain Updated the logic to handle cases when Program is defined at Levels 2 or 3    
		DECLARE @ProgramLevel CHAR(1)


		---------- Added by Manjit for Optimization        
		CREATE TABLE #OrganizationLevelDocuments (
			DocumentId INT
			,OrganizationLevelId INT
			)

		INSERT INTO #OrganizationLevelDocuments
		SELECT d.DocumentId
			,a.OrganizationLevelId
		FROM Documents d WITH (NOLOCK)
		JOIN #OrganisationSubLevelStaffs OSLS ON (
				d.AuthorId = OSLS.StaffId
				OR d.ProxyId = OSLS.StaffId
				)
		JOIN #OrganisationSubLevels a ON OSLS.OrganizationLevelId = a.OrganizationLevelId
		JOIN StaffClients sc ON sc.ClientId = d.ClientId
			AND sc.StaffId = @StaffId
		WHERE EXISTS (
				SELECT 1
				FROM #DocumentCodeFilters DCF
				WHERE DCF.DocumentCodeId = d.DocumentCodeId
				)
			AND d.CurrentVersionStatus IN (
				20
				,21
				,25
				)
			-- 29/SEP/2016 Akwinasss    
			AND (
				d.ServiceId IS NULL
				OR EXISTS (
					SELECT ServiceId
					FROM [Services]
					WHERE ServiceId = d.ServiceId
						AND STATUS != 76
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				) --Added by Chita Ranjan 10/Nov/2016      
			--AND d.EffectiveDate IS NOT NULL        
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
		GROUP BY d.DocumentId
			,a.OrganizationLevelId
		OPTION (RECOMPILE);

		SELECT OrganizationLevelId
			,LevelName
			,@levelNumber AS levelNumber
			,(
				SELECT COUNT(DISTINCT d.DocumentId)
				FROM Documents d WITH (NOLOCK)
				WHERE EXISTS (
						SELECT 1
						FROM #OrganizationLevelDocuments OLD
						WHERE d.DocumentId = OLD.DocumentId
							AND OLD.OrganizationLevelId = a.OrganizationLevelId
						)
					AND d.CurrentVersionStatus = 20
					AND (d.DueDate <= @today)
				) AS DueNow
			,(
				SELECT COUNT(DISTINCT d.DocumentId)
				FROM Documents d WITH (NOLOCK)
				WHERE EXISTS (
						SELECT 1
						FROM #OrganizationLevelDocuments OLD
						WHERE d.DocumentId = OLD.DocumentId
							AND OLD.OrganizationLevelId = a.OrganizationLevelId
						)
					AND (
						d.CurrentVersionStatus = 21
						OR d.CurrentVersionStatus = 25
						)
				) AS InProgress
			,(
				SELECT COUNT(DISTINCT d.DocumentId)
				FROM Documents d WITH (NOLOCK)
				WHERE EXISTS (
						SELECT 1
						FROM #OrganizationLevelDocuments OLD
						WHERE d.DocumentId = OLD.DocumentId
							AND OLD.OrganizationLevelId = a.OrganizationLevelId
						)
					AND d.CurrentVersionStatus = 20
					AND d.DueDate >= @today
					AND d.DueDate < CONVERT(VARCHAR(10), DATEADD(dd, 15, GETDATE()), 101)
				) AS DueInFourteen
			,(
				SELECT COUNT(DISTINCT d.DocumentId)
				FROM Documents d WITH (NOLOCK)
				JOIN DocumentSignatures ds WITH (NOLOCK) ON ds.DocumentId = d.DocumentId
					AND ds.signaturedate IS NULL
					AND ISNULL(ds.RecordDeleted, 'N') = 'N'
					AND d.AuthorId <> ds.StaffId
					AND ISNULL(ds.declinedsignature, 'N') = 'N'
				WHERE EXISTS (
						SELECT 1
						FROM #OrganizationLevelDocuments OLD
						WHERE d.DocumentId = OLD.DocumentId
							AND OLD.OrganizationLevelId = a.OrganizationLevelId
						)
					AND d.CurrentVersionStatus = 21 -- 19/Aug/2016 Irfan    
				) AS CoSign
			,(
				SELECT COUNT(DISTINCT d.DocumentId)
				FROM Documents AS d WITH (NOLOCK)
				JOIN DocumentAssignedTasks AS DAT WITH (NOLOCK) ON d.InProgressDocumentVersionId = DAT.DocumentVersionId
				WHERE EXISTS (
						SELECT 1
						FROM #OrganizationLevelDocuments OLD
						WHERE d.DocumentId = OLD.DocumentId
							AND OLD.OrganizationLevelId = a.OrganizationLevelId
						)
					AND DAT.AssignmentStatus <> 6822
					AND ISNULL(DAT.RecordDeleted, 'N') = 'N'
				) AS Assigned
			,@ProgramLevel AS Programlevel --Added by Revathi 13/oct/2015    
		FROM #OrganisationSubLevels a
		OPTION (RECOMPILE);

		IF OBJECT_ID('tempdb..#tempStaffOrgLevel') IS NOT NULL
			DROP TABLE #tempStaffOrgLevel
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSupervisionDashboardWidget') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) --Added by Chita Ranjan 10/Nov/2016                                               

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
END
