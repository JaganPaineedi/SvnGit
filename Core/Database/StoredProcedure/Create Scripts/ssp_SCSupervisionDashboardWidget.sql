
/****** Object:  StoredProcedure [dbo].[ssp_SCSupervisionDashboardWidget]    Script Date: 08/19/2016 16:49:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSupervisionDashboardWidget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSupervisionDashboardWidget]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCSupervisionDashboardWidget]    Script Date: 08/19/2016 16:49:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCSupervisionDashboardWidget]
    (
      @StaffId INT ,
      @MainOrganizationLevelId INT = NULL ,
      @OrganizationLevelId INT = NULL    
    )
    WITH RECOMPILE
AS --=============================================    
-- Author:  Sudhir Singh  
-- Create date: 5/21/2012    
-- exec ssp_SCSupervisionDashboardWidget 92,'',''  
-- Description: Used to get all recordsets related to Supervision Document widget.  
-- Modified Date: 19/2/2013  
-- Modified By: Maninder  
-- Purpose: What- Now those documents counted whose Author has their PrimaryProgramId assigned at the Team Level  
--          Earlier documents which are added to OrganizationLevelStaff were being used to count the documents  
--          Why-  As per task#2764 in Thresholds Bugs/Fetaure   
-- Mar 08,2013 Manjit Singh		Added temporary table("#OrganizationLevelDocuments") for optimization  
-- Sep 24,2013 Dhanil Manuel	Commented 'GROUP BY d.DocumentId' for getting CoSign,Assigned columns for task #246 Thresholds support  
-- Feb 13,2014 Venkatesh MR		Merge the CSP_SCSupervisionDashboardWidget to SSP_SCSupervisionDashboardWidget for task 454 in Core Bugs.  
-- Feb 26,2014 Gautam			Removed the Staff.Active='Y' condition. Document should be also counted for InActive staff for task 454 in Core Bugs.   
-- Jun 08,2015 NJain			Updated to handle scenarios when Program is defined at a level other than 4 (2 or 3), MFS Set Up #27 
-- 13/oct/2015	Revathi			what:Added ProgramName in Level 2 to  show in hierarchical order
-- 								why:task #466 Valley Client Acceptance Testing Issues	
-- 19/Aug/2016	Irfan			What: Changed the document.CurrentVersionstatus value from 22 to 21 to show count of all the documents whose status is having Co-sign
--								Why:  Pathway - Support Go Live Task - #215
-- 29/SEP/2016	Akwinass		What: Included record deleted condition for services
--								Why:  Task #563 in Key Point - Support Go Live.

--10/Nov/2016  Chita Ranjan		What:Added Status!=76 to restrict all the services whose status is "Error"
--                              Why:Key Point - Support Go Live Task #668
--01/22/2019	Gautam			What: Changed the logic not to display Inactive staff if document count is zero
--								Why: Spring River-Support Go Live Task #293
--01/24/2019	Anto			What: Added an active client check to match the number of records displayed in Dashboard and the list page.
--								Why: Spring River-Support Go Live #369
 
--=============================================       
BEGIN
	BEGIN TRY
		--------> First RecordSet-> getting values for dropdown all level associated with staff <---------    
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
					FROM OrganizationLevelStaff
					WHERE a.OrganizationLevelId = OrganizationLevelId
						AND ISNULL(RecordDeleted, 'N') = 'N'
						AND StaffId = @StaffId
					)
				OR ManagerId = @StaffId
				)
			AND ISNULL(a.RecordDeleted, 'N') = 'N'
		ORDER BY b.LevelTypeId

		SELECT OrganizationLevelId
			,LevelName
			,OrganizationLevelLevelName
			,LevelTypeName
		FROM #tempStaffOrgLevel;

		IF ISNULL(@MainOrganizationLevelId, '') = ''
		BEGIN
			SELECT TOP 1 @MainOrganizationLevelId = OrganizationLevelId
			FROM #tempStaffOrgLevel
		END
		ELSE
			IF NOT EXISTS (
					SELECT 'X'
					FROM #tempStaffOrgLevel
					WHERE OrganizationLevelId = @MainOrganizationLevelId
					)
			BEGIN
				SELECT TOP 1 @MainOrganizationLevelId = OrganizationLevelId
				FROM #tempStaffOrgLevel

				SET @OrganizationLevelId = NULL
			END

		IF ISNULL(@OrganizationLevelId, '') = ''
		BEGIN
			SET @OrganizationLevelId = @MainOrganizationLevelId
		END

		--------> Second RecordSet-> SiteMap creation <------------------      
		DECLARE @MainLevelNumber INT
			,@LevelNumber INT

		SELECT @MainLevelNumber = ISNULL(LevelNumber, 0)
		FROM OrganizationLevelTypes
		WHERE LevelTypeId = (
				SELECT LevelTypeId
				FROM OrganizationLevels
				WHERE OrganizationLevelId = @MainOrganizationLevelId
				)

		SELECT @LevelNumber = ISNULL(LevelNumber, 0)
		FROM OrganizationLevelTypes
		WHERE LevelTypeId = (
				SELECT LevelTypeId
				FROM OrganizationLevels
				WHERE OrganizationLevelId = @OrganizationLevelId
				)

		IF (@MainOrganizationLevelId = @OrganizationLevelId)
		BEGIN
			SELECT OrganizationLevelId
				,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
			FROM OrganizationLevels
			LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
			WHERE OrganizationLevelId = @MainOrganizationLevelId
		END
		ELSE
			IF (@LevelNumber - @MainLevelNumber = 1)
			BEGIN
				SELECT OrganizationLevelId
					,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
				FROM OrganizationLevels
				LEFT JOIN programs ON OrganizationLevels.ProgramId = programs.ProgramId
				WHERE OrganizationLevelId = @MainOrganizationLevelId
				
				UNION
				
				SELECT OrganizationLevelId
					,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
				FROM OrganizationLevels
				LEFT JOIN programs ON OrganizationLevels.ProgramId = programs.ProgramId
				WHERE OrganizationLevelId = @OrganizationLevelId
				ORDER BY OrganizationLevelId
			END
			ELSE
				IF (@LevelNumber - @MainLevelNumber = 2)
				BEGIN
					SELECT OrganizationLevelId
						,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
					FROM OrganizationLevels
					LEFT JOIN programs ON OrganizationLevels.ProgramId = Programs.ProgramId
					WHERE OrganizationLevelId = @MainOrganizationLevelId
					
					UNION
					
					SELECT OrganizationLevelId
						,ISNULL(LevelName, ISNULL(Programs.ProgramName, '')) AS LevelName
					FROM OrganizationLevels
					LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
					WHERE OrganizationLevelId = (
							SELECT ParentLevelId
							FROM OrganizationLevels
							WHERE OrganizationLevelId = @OrganizationLevelId
							)
					
					UNION
					
					SELECT OrganizationLevelId
						,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
					FROM OrganizationLevels
					LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
					WHERE OrganizationLevelId = @OrganizationLevelId
					ORDER BY OrganizationLevelId
				END
				ELSE
					IF (@LevelNumber - @MainLevelNumber = 3)
					BEGIN
						SELECT OrganizationLevelId
							,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
						FROM OrganizationLevels
						LEFT JOIN programs ON OrganizationLevels.ProgramId = programs.ProgramId
						WHERE OrganizationLevelId = @MainOrganizationLevelId
						
						UNION
						
						SELECT OrganizationLevelId
							,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
						FROM OrganizationLevels
						LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
						WHERE OrganizationLevelId = (
								SELECT ParentLevelId
								FROM OrganizationLevels
								WHERE OrganizationLevelId = (
										SELECT ParentLevelId
										FROM OrganizationLevels
										WHERE OrganizationLevelId = @OrganizationLevelId
										)
								)
						
						UNION
						
						SELECT OrganizationLevelId
							,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
						FROM OrganizationLevels
						LEFT JOIN programs ON OrganizationLevels.ProgramId = programs.ProgramId
						WHERE OrganizationLevelId = (
								SELECT ParentLevelId
								FROM OrganizationLevels
								WHERE OrganizationLevelId = @OrganizationLevelId
								)
						
						UNION
						
						SELECT OrganizationLevelId
							,ISNULL(LevelName, ISNULL(programs.ProgramName, '')) AS LevelName
						FROM OrganizationLevels
						LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
						WHERE OrganizationLevelId = @OrganizationLevelId
						ORDER BY OrganizationLevelId
					END
					ELSE
					BEGIN
						SELECT OrganizationLevelId
							,LevelName
						FROM OrganizationLevels
						WHERE OrganizationLevelId = - 1
					END

		--------->Third RecorSet-> Bind Grid Data <--------------------------      
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
		-- 6/8/2015 njain Updated the logic to handle cases when Program is defined at Levels 2 or 3
		DECLARE @ProgramLevel CHAR(1)

		SELECT @ProgramLevel = ISNULL(b.ProgramLevel, 'N')
		FROM dbo.OrganizationLevels a
		JOIN dbo.OrganizationLevelTypes b ON b.LevelTypeId = a.LevelTypeId
		WHERE a.OrganizationLevelId = @OrganizationLevelId
			AND ISNULL(a.RecordDeleted, 'N') = 'N'
			AND ISNULL(b.RecordDeleted, 'N') = 'N'

		IF @levelNumber = 4 -- This is always going to be Program so no updates necessary here
		BEGIN
			INSERT INTO #OrganisationSubLevels (
				OrganizationLevelId
				,LevelName
				)
			SELECT DISTINCT Staff.staffid AS OrganizationLevelId
				,ISNULL(LastName + ', ', '') + FirstName AS LevelName
			FROM OrganizationLevels
			INNER JOIN Staff ON ISNULL(Staff.RecordDeleted, 'N') = 'N'
				AND OrganizationLevels.ProgramId = Staff.PrimaryProgramId
			WHERE OrganizationLevels.OrganizationLevelId = @OrganizationLevelId

			INSERT INTO #OrganisationSubLevelStaffs (
				staffId
				,OrganizationLevelId
				)
			SELECT DISTINCT Staff.staffid
				,Staff.staffid AS OrganizationLevelId
			FROM OrganizationLevels
			INNER JOIN Staff ON ISNULL(Staff.RecordDeleted, 'N') = 'N'
				AND OrganizationLevels.ProgramId = Staff.PrimaryProgramId
			WHERE OrganizationLevels.OrganizationLevelId = @OrganizationLevelId
		END
		ELSE
			IF @levelNumber = 3
				AND @ProgramLevel = 'N' --Added by Revathi 13/oct/2015
			BEGIN
				INSERT INTO #OrganisationSubLevels (
					OrganizationLevelId
					,LevelName
					)
				SELECT DISTINCT OrganizationLevels.OrganizationLevelId
					,ISNULL(LevelName, programs.ProgramName) AS LevelName
				FROM OrganizationLevels
				LEFT JOIN Programs ON OrganizationLevels.ProgramId = Programs.ProgramId
					AND ISNULL(Programs.RecordDeleted, 'N') = 'N'
				WHERE ISNULL(OrganizationLevels.RecordDeleted, 'N') = 'N'
					AND OrganizationLevels.ParentLevelId = @OrganizationLevelId

				INSERT INTO #OrganisationSubLevelStaffs (
					StaffId
					,OrganizationLevelId
					)
				SELECT DISTINCT Staff.StaffId
					,OrganizationLevels.OrganizationLevelId
				FROM OrganizationLevels
				INNER JOIN Staff ON ISNULL(Staff.RecordDeleted, 'N') = 'N'
					--AND OrganizationLevelStaff.Staffid = Staff.Staffid          
					AND OrganizationLevels.ProgramId = Staff.PrimaryProgramId
				WHERE ISNULL(OrganizationLevels.RecordDeleted, 'N') = 'N'
					AND OrganizationLevels.ParentLevelId = @OrganizationLevelId
			END
			ELSE
				IF (
						@levelNumber = 3
						OR @levelNumber = 2
						)
					AND @ProgramLevel = 'Y'
				BEGIN
					INSERT INTO #OrganisationSubLevels (
						OrganizationLevelId
						,LevelName
						)
					SELECT DISTINCT Staff.staffid AS OrganizationLevelId
						,ISNULL(LastName + ', ', '') + FirstName AS LevelName
					FROM OrganizationLevels
					INNER JOIN Staff ON ISNULL(Staff.RecordDeleted, 'N') = 'N'
								AND OrganizationLevels.ProgramId = Staff.PrimaryProgramId
								WHERE OrganizationLevels.OrganizationLevelId = @OrganizationLevelId

					INSERT INTO #OrganisationSubLevelStaffs (
						staffId
						,OrganizationLevelId
						)
					SELECT DISTINCT Staff.staffid
						,Staff.staffid AS OrganizationLevelId
					FROM OrganizationLevels
					INNER JOIN Staff ON ISNULL(Staff.RecordDeleted, 'N') = 'N'
						AND OrganizationLevels.ProgramId = Staff.PrimaryProgramId
					WHERE OrganizationLevels.OrganizationLevelId = @OrganizationLevelId
				END
				ELSE
					IF @levelNumber = 2
						AND @ProgramLevel = 'N' --Added by Revathi 13/oct/2015
					BEGIN
						INSERT INTO #OrganisationSubLevels (
							OrganizationLevelId
							,LevelName
							)
						SELECT DISTINCT b.OrganizationLevelId
							,ISNULL(b.LevelName, programs.ProgramName) AS --Added by Revathi 13/oct/2015 
							LevelName
						FROM OrganizationLevels a
						RIGHT JOIN OrganizationLevels b ON a.ParentLevelId = b.OrganizationLevelId
							AND ISNULL(a.RecordDeleted, 'N') = 'N'
						LEFT JOIN Programs ON b.ProgramId = Programs.ProgramId
							AND ISNULL(Programs.RecordDeleted, 'N') = 'N'
						WHERE b.ParentLevelId = @OrganizationLevelId
							AND ISNULL(b.RecordDeleted, 'N') = 'N'

						INSERT INTO #OrganisationSubLevelStaffs (
							StaffId
							,OrganizationLevelId
							)
						SELECT DISTINCT Staff.StaffId
							,b.OrganizationLevelId
						FROM OrganizationLevels a
						RIGHT JOIN OrganizationLevels b ON a.ParentLevelId = b.OrganizationLevelId
							AND ISNULL(a.RecordDeleted, 'N') = 'N'
						INNER JOIN Staff ON (
								Staff.PrimaryProgramId = a.ProgramId
								OR Staff.PrimaryProgramId = b.ProgramId
								)
						WHERE b.ParentLevelId = @OrganizationLevelId
							AND ISNULL(a.RecordDeleted, 'N') = 'N'
					END
					ELSE
						IF @levelNumber = 1
						BEGIN
							INSERT INTO #OrganisationSubLevels (
								OrganizationLevelId
								,LevelName
								)
							SELECT DISTINCT c.OrganizationLevelId
								,ISNULL(c.LevelName, programs.ProgramName) AS --Added by Revathi 13/oct/2015
								LevelName
							FROM OrganizationLevels a
							RIGHT JOIN OrganizationLevels b ON a.ParentLevelId = b.OrganizationLevelId
								AND ISNULL(a.RecordDeleted, 'N') = 'N'
							RIGHT JOIN OrganizationLevels c ON b.ParentLevelId = c.OrganizationLevelId
								AND ISNULL(b.RecordDeleted, 'N') = 'N'
							LEFT JOIN Programs --Added by Revathi 13/oct/2015
								ON c.ProgramId = Programs.ProgramId
								AND ISNULL(Programs.RecordDeleted, 'N') = 'N'
							WHERE c.ParentLevelId = @OrganizationLevelId
								AND ISNULL(c.RecordDeleted, 'N') = 'N'

							INSERT INTO #OrganisationSubLevelStaffs (
								StaffId
								,OrganizationLevelId
								)
							SELECT DISTINCT Staff.StaffId
								,c.OrganizationLevelId
							FROM OrganizationLevels a
							RIGHT JOIN OrganizationLevels b ON a.ParentLevelId = b.OrganizationLevelId
								AND ISNULL(a.RecordDeleted, 'N') = 'N'
							RIGHT JOIN OrganizationLevels c ON b.ParentLevelId = c.OrganizationLevelId
								AND ISNULL(b.RecordDeleted, 'N') = 'N'
							INNER JOIN Staff ON (
									Staff.PrimaryProgramId = a.ProgramId
									OR Staff.PrimaryProgramId = b.ProgramId
									OR Staff.PrimaryProgramId = c.ProgramId
									)
								AND ISNULL(Staff.RecordDeleted, 'N') = 'N'
							WHERE c.ParentLevelId = @OrganizationLevelId
								AND ISNULL(c.RecordDeleted, 'N') = 'N'
						END

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
		JOIN Clients C ON d.Clientid = C.Clientid 
        AND ISNULL(C.Active,'N')='Y'
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
			-- 29/SEP/2016	Akwinasss
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

		Select O.OrganizationLevelId,
				O.LevelName, O.levelNumber,
				O.DueNow,O.InProgress,O.DueInFourteen,O.CoSign,
				O.Assigned,O.Programlevel
		From
		(
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
					AND d.CurrentVersionStatus = 21 -- 19/Aug/2016	Irfan
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
		FROM #OrganisationSubLevels a)O
		Where ( (isnull(@ProgramLevel,'N') = 'N' ) or-- case for other than programLevel
				(@ProgramLevel = 'Y' and -- case for programLevel and InActiveStaff and any document should be more than 0
				 exists(Select 1 from #OrganisationSubLevelStaffs S join Staff S1 
								on S.OrganizationLevelId= S1.StaffId 
								where o.OrganizationLevelId= S.OrganizationLevelId and isnull(S1.Active,'Y')='N')
		        and (O.DueNow >0 or O.InProgress >0 or O.DueInFourteen >0 or O.CoSign >0 or O.Assigned >0))
		        or 
		        (@ProgramLevel = 'Y' and -- case for programLevel and ActiveStaff and any document should be more than or euual to 0
				 exists(Select 1 from #OrganisationSubLevelStaffs S join Staff S1 
								on S.OrganizationLevelId= S1.StaffId 
							where o.OrganizationLevelId= S.OrganizationLevelId and isnull(S1.Active,'Y')='Y')
		        and (O.DueNow >=0 or O.InProgress >=0 or O.DueInFourteen >=0 or O.CoSign >=0 or O.Assigned >=0))
		        )
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
GO


