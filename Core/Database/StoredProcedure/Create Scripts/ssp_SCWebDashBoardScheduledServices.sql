IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardScheduledServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebDashBoardScheduledServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDashBoardScheduledServices] @StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	/********************************************************************************                                        
-- Stored Procedure: ssp_SCWebDashBoardScheduledServices                                         
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by dashboard Documents widget                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose
---------------------------------------------------------------------------------
-- 01.08.2005  Vikas       Created  
-- 06.12.2008  Sony        Modified added order by cn.clientid,cn.ClientNoteId  
-- 03.30.2009  AVoss       Use datediff for excluding expired notes  
-- 10.22.2010  SFarber     Redesigned.  
-- 10.31.2011  Rohit Katoch #Services Temp Table Add ISNULL Value For Columns 
--						    And ADD Try Catch With Error Handling Message
-- 16 Jan 2015 Avi Goyal	What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks
							Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations
-- 10/Oct/2015 MD Hussain 	Modify - Added condition to check for the start date of the flag (client note) w.r.t task #263 Allegan Support
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #Services (
			ServiceId INT
			,ClientId INT
			)

		CREATE TABLE #Notes (
			NoteId INT identity NOT NULL
			,ClientId INT NULL
			,ClientNoteId INT NULL
			,GlobalCodeId INT NULL
			,NoteType INT NULL
			,Bitmap VARCHAR(200) NULL
			,NoteNumber INT NULL
			,Note VARCHAR(100) NULL
			)

		INSERT INTO #Services (
			ServiceId
			,ClientId
			)
		SELECT s.ServiceId
			,s.ClientId
		FROM Services s
		INNER JOIN StaffClients sc ON sc.ClientId = s.ClientId
			AND sc.StaffId = @LoggedInStaffId
		WHERE s.STATUS IN (
				70
				,71
				,72
				,73
				)
			AND datediff(dd, s.DateofService, getdate()) = 0
			AND s.ClinicianId = @StaffId
			AND isnull(s.RecordDeleted, 'N') <> 'Y'

		INSERT INTO #Notes (
			ClientId
			,ClientNoteId
			,GlobalCodeId
			,NoteType
			,Bitmap
			,Note
			)
		SELECT cn.ClientId
			,cn.ClientNoteId
			,
			--gc.GlobalCodeId,		-- Commented by Avi Goyal, on 16 Jan 2015                   
			FT.FlagTypeId
			,-- Added by Avi Goyal, on 16 Jan 2015 
			cn.NoteType
			,
			--gc.Bitmap,				-- Commented by Avi Goyal, on 16 Jan 2015
			FT.Bitmap
			,-- Added by Avi Goyal, on 16 Jan 2015 
			cn.Note
		FROM ClientNotes cn
		--left join GlobalCodes gc on gc.GlobalCodeId = cn.NoteType		-- Commented by Avi Goyal, on 16 Jan 2015
		-- Added by Avi Goyal, on 16 Jan 2015
		INNER JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
			AND ISNULL(FT.RecordDeleted, 'N') = 'N'
			AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
			AND (
				ISNULL(FT.PermissionedFlag, 'N') = 'N'
				OR (
					ISNULL(FT.PermissionedFlag, 'N') = 'Y'
					AND (
						(
							EXISTS (
								SELECT 1
								FROM PermissionTemplateItems PTI
								INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
									AND ISNULL(PT.RecordDeleted, 'N') = 'N'
									AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
								INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
									AND ISNULL(SR.RecordDeleted, 'N') = 'N'
								WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
									AND PTI.PermissionItemId = FT.FlagTypeId
									AND SR.StaffId = @StaffId
								)
							OR EXISTS (
								SELECT 1
								FROM StaffPermissionExceptions SPE
								WHERE SPE.StaffId = @StaffId
									AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
									AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
									AND SPE.PermissionItemId = FT.FlagTypeId
									AND SPE.Allow = 'Y'
									AND (
										SPE.StartDate IS NULL
										OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
										)
									AND (
										SPE.EndDate IS NULL
										OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
										)
								)
							)
						AND NOT EXISTS (
							SELECT 1
							FROM StaffPermissionExceptions SPE
							WHERE SPE.StaffId = @StaffId
								AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
								AND SPE.PermissionItemId = FT.FlagTypeId
								AND SPE.Allow = 'N'
								AND (
									SPE.StartDate IS NULL
									OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
									)
								AND (
									SPE.EndDate IS NULL
									OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
									)
							)
						)
					)
				)
		WHERE cn.Active = 'Y'
			AND DATEDIFF(dd, cn.StartDate, getdate()) >= 0 -- Added on 10/29/2015 by MD Hussain
			AND (
				dateDiff(dd, cn.EndDate, getdate()) <= 0
				OR cn.EndDate IS NULL
				)
			AND isnull(cn.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT *
				FROM #Services s
				WHERE s.ClientId = cn.ClientId
				)
		ORDER BY cn.clientid
			,cn.ClientNoteId

		UPDATE n
		SET NoteNumber = n.NoteId - fn.FirstNoteId + 1
		FROM #Notes n
		INNER JOIN (
			SELECT ClientId
				,min(NoteId) AS FirstNoteId
			FROM #Notes
			GROUP BY ClientId
			) fn ON fn.ClientId = n.ClientId

		SELECT rtrim(c.LastName) AS ClientLastName
			,rtrim(c.FirstName) AS ClientFirstName
			,sv.DateOfService
			,'Note' AS DocumentName
			,pc.DisplayAs
			,p.ProgramCode
			,sv.AuthorizationsNeeded
			,sv.ServiceId
			,isnull(d.DocumentId, 0) AS DocumentId
			,c.Clientid
			,gcs.CodeName AS STATUS
			,n.BitmapNo
			,ISNULL(n.ClientNoteId1, 0) AS ClientNoteId1
			,ISNULL(n.NoteType1, 0) AS NoteType1
			,ISNULL(n.Bitmap1, 0) AS Bitmap1
			,ISNULL(n.Note1, 0) AS Note1
			,ISNULL(n.BitmapId1, 0) AS BitmapId1
			,ISNULL(n.ClientNoteId2, 0) AS ClientNoteId2
			,ISNULL(n.NoteType2, 0) AS NoteType2
			,ISNULL(n.Bitmap2, 0) AS Bitmap2
			,ISNULL(n.Note2, 0) AS Note2
			,ISNULL(n.BitmapId2, 0) AS BitmapId2
			,ISNULL(n.ClientNoteId3, 0) AS ClientNoteId3
			,ISNULL(n.NoteType3, 0) AS NoteType3
			,ISNULL(n.Bitmap3, 0) AS Bitmap3
			,ISNULL(n.Note3, 0) AS Note3
			,ISNULL(n.BitmapId3, 0) AS BitmapId3
			,ISNULL(n.ClientNoteId4, 0) AS ClientNoteId4
			,ISNULL(n.NoteType4, 0) AS NoteType4
			,ISNULL(n.Bitmap4, 0) AS Bitmap4
			,ISNULL(n.Note4, 0) AS Note4
			,ISNULL(n.BitmapId4, 0) AS BitmapId4
			,ISNULL(n.ClientNoteId5, 0) AS ClientNoteId5
			,ISNULL(n.NoteType5, 0) AS NoteType5
			,ISNULL(n.Bitmap5, 0) AS Bitmap5
			,ISNULL(n.Note5, 0) AS Note5
			,ISNULL(n.BitmapId5, 0) AS BitmapId5
			,ISNULL(n.ClientNoteId6, 0) AS ClientNoteId6
			,ISNULL(n.NoteType6, 0) AS NoteType6
			,ISNULL(n.Bitmap6, 0) AS Bitmap6
			,ISNULL(n.Note6, 0) AS Note6
			,ISNULL(n.BitmapId6, 0) AS BitmapId6
			,
			/*                             
       n.ClientNoteId1, n.NoteType1, n.Bitmap1,n.Note1,n.BitmapId1,                                  
       n.ClientNoteId2, n.NoteType2, n.Bitmap2,n.Note2,n.BitmapId2,                                   
       n.ClientNoteId3, n.NoteType3, n.Bitmap3,n.Note3,n.BitmapId3,                                    
       n.ClientNoteId4, n.NoteType4, n.Bitmap4,n.Note4,n.BitmapId4 ,                                   
       n.ClientNoteId5, n.NoteType5, n.Bitmap5,n.Note5,n.BitmapId5,                                    
       n.ClientNoteId6, n.NoteType6, n.Bitmap6,n.Note6,n.BitmapId6,
       */
			n.clientid
			,rtrim(c.Lastname) + ', ' + rtrim(c.FirstName) AS ClientDisplayName
		FROM #Services s
		INNER JOIN Services sv ON sv.ServiceId = s.ServiceId
		INNER JOIN Clients c ON c.ClientId = sv.ClientId
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = sv.ProcedureCodeId
		INNER JOIN Programs p ON p.ProgramId = sv.ProgramId
		LEFT JOIN Documents d ON d.ServiceId = sv.ServiceId
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = sv.STATUS
		LEFT JOIN (
			SELECT ClientId
				,max(NoteNumber) AS BitmapNo
				,max(CASE NoteNumber
						WHEN 1
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId1
				,max(CASE NoteNumber
						WHEN 1
							THEN NoteType
						ELSE NULL
						END) AS NoteType1
				,max(CASE NoteNumber
						WHEN 1
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap1
				,max(CASE NoteNumber
						WHEN 1
							THEN Note
						ELSE NULL
						END) AS Note1
				,max(CASE NoteNumber
						WHEN 1
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId1
				,max(CASE NoteNumber
						WHEN 2
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId2
				,max(CASE NoteNumber
						WHEN 2
							THEN NoteType
						ELSE NULL
						END) AS NoteType2
				,max(CASE NoteNumber
						WHEN 2
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap2
				,max(CASE NoteNumber
						WHEN 2
							THEN Note
						ELSE NULL
						END) AS Note2
				,max(CASE NoteNumber
						WHEN 2
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId2
				,max(CASE NoteNumber
						WHEN 3
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId3
				,max(CASE NoteNumber
						WHEN 3
							THEN NoteType
						ELSE NULL
						END) AS NoteType3
				,max(CASE NoteNumber
						WHEN 3
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap3
				,max(CASE NoteNumber
						WHEN 3
							THEN Note
						ELSE NULL
						END) AS Note3
				,max(CASE NoteNumber
						WHEN 3
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId3
				,max(CASE NoteNumber
						WHEN 4
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId4
				,max(CASE NoteNumber
						WHEN 4
							THEN NoteType
						ELSE NULL
						END) AS NoteType4
				,max(CASE NoteNumber
						WHEN 4
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap4
				,max(CASE NoteNumber
						WHEN 4
							THEN Note
						ELSE NULL
						END) AS Note4
				,max(CASE NoteNumber
						WHEN 4
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId4
				,max(CASE NoteNumber
						WHEN 5
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId5
				,max(CASE NoteNumber
						WHEN 5
							THEN NoteType
						ELSE NULL
						END) AS NoteType5
				,max(CASE NoteNumber
						WHEN 5
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap5
				,max(CASE NoteNumber
						WHEN 5
							THEN Note
						ELSE NULL
						END) AS Note5
				,max(CASE NoteNumber
						WHEN 5
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId5
				,max(CASE NoteNumber
						WHEN 6
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId6
				,max(CASE NoteNumber
						WHEN 6
							THEN NoteType
						ELSE NULL
						END) AS NoteType6
				,max(CASE NoteNumber
						WHEN 6
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap6
				,max(CASE NoteNumber
						WHEN 6
							THEN Note
						ELSE NULL
						END) AS Note6
				,max(CASE NoteNumber
						WHEN 6
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId6
			FROM #Notes
			WHERE NoteNumber <= 6
			GROUP BY ClientId
			) n ON n.ClientId = sv.ClientId
		WHERE isnull(sv.RecordDeleted, 'N') <> 'Y'
		ORDER BY sv.DateOfService
			,c.LastName
			,c.FirstName
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebDashBoardScheduledServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

