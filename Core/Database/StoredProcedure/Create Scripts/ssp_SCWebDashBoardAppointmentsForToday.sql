/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardAppointmentsForToday]    Script Date: 12/18/2014 09:36:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardAppointmentsForToday]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebDashBoardAppointmentsForToday]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardAppointmentsForToday]    Script Date: 12/18/2014 09:36:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDashBoardAppointmentsForToday] 
	@StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	/********************************************************************************
-- Stored Procedure: dbo.ssp_SCWebDashBoardAppointmentsForToday
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: used by dashboard Documents widget
--
-- Updates:
-- Date              Author               Purpose
-------------------------------------------------------------------------------
-- 02.05.2011        DamanpreetKaur       Created
-- 19/Jan/2012       Rohit Katoch         Modify:- Change ascending order as " time, subject/client asc"
-- 22Mar2012	     Shifali			  Modify - Added Check for RecurringAppointments twice in widget (changes approved by SHS)	
-- 24/Sep/2012       Maninder             Added condition for GroupService Selection
-- 16 Jan 2015	     Avi Goyal			  What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks 
									      Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations
-- 10/Oct/2015       MD Hussain Khusro	  Modify - Added condition to check for the start date of the flag (client note) w.r.t task #263 Allegan Support
-- 18/Nov/2015       Aravind              Modify - Modified the Left Join Check from LEFT JOIN GroupServices gs ON gs.GroupId = g.GroupId to LEFT JOIN GroupServices gs ON gs.GroupServiceId = g.GroupServiceId 
										  Why :Appointments for Today Widget is showing old cached group appointments - Task #188 - WMU - Support Go Live
			  
									  
*********************************************************************************/
AS
-- To Get Services and Notes for Today logic is same as StoredProcedure ssp_SCWebDashBoardScheduledServices
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

CREATE TABLE #GroupService (
	GroupServiceId INT
	,GroupId INT
	)

CREATE TABLE #Appointments (
	AppointmentId INT
	,[subject] VARCHAR(max)
	)

----Services----
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

----Notes----
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
	AND DATEDIFF(dd, cn.StartDate, GETDATE()) >= 0 -- Added on 10/29/2015 by MD Hussain
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

---GroupService----
INSERT INTO #GroupService (
	GroupServiceId
	,GroupId
	)
SELECT gss.GroupServiceId
	,gs.GroupId	
FROM GroupServiceStaff gss
INNER JOIN GroupServices gs ON gss.GroupServiceId = gs.GroupServiceId
	AND gss.StaffId = @LoggedInStaffId
WHERE gs.STATUS IN (
		70
		,71
		,72
		,73
		)
	AND datediff(dd, gss.DateofService, getdate()) = 0
	AND gs.ClinicianId = @StaffId
	AND isnull(gss.RecordDeleted, 'N') <> 'Y'

---Appointments---
INSERT INTO #Appointments (
	AppointmentId
	,[Subject]
	)
SELECT a.AppointmentId
	,a.[Subject]
FROM Appointments a
WHERE datediff(dd, a.StartTime, getdate()) = 0
	AND a.StaffId = @StaffId
	AND a.ShowTimeAs = 4342
	AND a.ServiceId IS NULL
	AND a.GroupServiceId IS NULL
	AND a.RecurringGroupServiceId IS NULL
	AND (
		ISNULL(RecurringAppointment, 'N') = 'N'
		OR RecurringAppointmentId IS NOT NULL
		)
	AND isnull(a.RecordDeleted, 'N') <> 'Y'

--- Services ---
SELECT rtrim(c.LastName) AS ClientLastName
	,rtrim(c.FirstName) AS ClientFirstName
	,sv.DateOfService AS DateOfService
	,'Note' AS DocumentName
	,pc.DisplayAs
	,p.ProgramCode
	,sv.AuthorizationsNeeded
	,sv.ServiceId
	,isnull(d.DocumentId, 0) AS DocumentId
	,c.Clientid
	,gcs.CodeName AS STATUS
	,isnull(n.BitmapNo, 0) AS BitmapNo
	,isnull(n.ClientNoteId1, 0) AS ClientNoteId1
	,isnull(n.NoteType1, 0) AS NoteType1
	,isnull(n.Bitmap1, '0') AS Bitmap1
	,isnull(n.Note1, '0') AS Note1
	,isnull(n.BitmapId1, 0) AS BitmapId1
	,isnull(n.ClientNoteId2, 0) AS ClientNoteId2
	,isnull(n.NoteType2, 0) AS NoteType2
	,isnull(n.Bitmap2, '0') AS Bitmap2
	,isnull(n.Note2, '0') AS Note2
	,isnull(n.BitmapId2, 0) AS BitmapId2
	,isnull(n.ClientNoteId3, 0) AS ClientNoteId3
	,isnull(n.NoteType3, 0) AS NoteType3
	,isnull(n.Bitmap3, '0') AS Bitmap3
	,isnull(n.Note3, '0') AS Note3
	,isnull(n.BitmapId3, 0) AS BitmapId3
	,isnull(n.ClientNoteId4, 0) AS ClientNoteId4
	,isnull(n.NoteType4, 0) AS NoteType4
	,isnull(n.Bitmap4, '0') AS Bitmap4
	,isnull(n.Note4, '0') AS Note4
	,isnull(n.BitmapId4, 0) AS BitmapId4
	,isnull(n.ClientNoteId5, 0) AS ClientNoteId5
	,isnull(n.NoteType5, 0) AS NoteType5
	,isnull(n.Bitmap5, '0') AS Bitmap5
	,isnull(n.Note5, '0') AS Note5
	,isnull(n.BitmapId5, 0) AS BitmapId5
	,isnull(n.ClientNoteId6, 0) AS ClientNoteId6
	,isnull(n.NoteType6, 0) AS NoteType6
	,isnull(n.Bitmap6, '0') AS Bitmap6
	,isnull(n.Note6, '0') AS Note6
	,isnull(n.BitmapId6, 0) AS BitmapId6
	,isnull(n.clientid, 0)
	,rtrim(c.Lastname) + ', ' + rtrim(c.FirstName) + '(' + pc.DisplayAs + ')' AS ClientDisplayName
	,'Services' AS PageName
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
				ELSE 0
				END) AS ClientNoteId1
		,max(CASE NoteNumber
				WHEN 1
					THEN NoteType
				ELSE 0
				END) AS NoteType1
		,max(CASE NoteNumber
				WHEN 1
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap1
		,max(CASE NoteNumber
				WHEN 1
					THEN Note
				ELSE '0'
				END) AS Note1
		,max(CASE NoteNumber
				WHEN 1
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId1
		,max(CASE NoteNumber
				WHEN 2
					THEN ClientNoteId
				ELSE 0
				END) AS ClientNoteId2
		,max(CASE NoteNumber
				WHEN 2
					THEN NoteType
				ELSE 0
				END) AS NoteType2
		,max(CASE NoteNumber
				WHEN 2
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap2
		,max(CASE NoteNumber
				WHEN 2
					THEN Note
				ELSE '0'
				END) AS Note2
		,max(CASE NoteNumber
				WHEN 2
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId2
		,max(CASE NoteNumber
				WHEN 3
					THEN ClientNoteId
				ELSE 0
				END) AS ClientNoteId3
		,max(CASE NoteNumber
				WHEN 3
					THEN NoteType
				ELSE 0
				END) AS NoteType3
		,max(CASE NoteNumber
				WHEN 3
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap3
		,max(CASE NoteNumber
				WHEN 3
					THEN Note
				ELSE '0'
				END) AS Note3
		,max(CASE NoteNumber
				WHEN 3
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId3
		,max(CASE NoteNumber
				WHEN 4
					THEN ClientNoteId
				ELSE 0
				END) AS ClientNoteId4
		,max(CASE NoteNumber
				WHEN 4
					THEN NoteType
				ELSE 0
				END) AS NoteType4
		,max(CASE NoteNumber
				WHEN 4
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap4
		,max(CASE NoteNumber
				WHEN 4
					THEN Note
				ELSE '0'
				END) AS Note4
		,max(CASE NoteNumber
				WHEN 4
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId4
		,max(CASE NoteNumber
				WHEN 5
					THEN ClientNoteId
				ELSE 0
				END) AS ClientNoteId5
		,max(CASE NoteNumber
				WHEN 5
					THEN NoteType
				ELSE 0
				END) AS NoteType5
		,max(CASE NoteNumber
				WHEN 5
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap5
		,max(CASE NoteNumber
				WHEN 5
					THEN Note
				ELSE '0'
				END) AS Note5
		,max(CASE NoteNumber
				WHEN 5
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId5
		,max(CASE NoteNumber
				WHEN 6
					THEN ClientNoteId
				ELSE 0
				END) AS ClientNoteId6
		,max(CASE NoteNumber
				WHEN 6
					THEN NoteType
				ELSE 0
				END) AS NoteType6
		,max(CASE NoteNumber
				WHEN 6
					THEN Bitmap
				ELSE '0'
				END) AS Bitmap6
		,max(CASE NoteNumber
				WHEN 6
					THEN Note
				ELSE '0'
				END) AS Note6
		,max(CASE NoteNumber
				WHEN 6
					THEN GlobalCodeId
				ELSE 0
				END) AS BitmapId6
	FROM #Notes
	WHERE NoteNumber <= 6
	GROUP BY ClientId
	) n ON n.ClientId = sv.ClientId
WHERE isnull(sv.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
	AND sv.GroupServiceId IS NULL

UNION ALL

SELECT isnull(gr.GroupName, 'Group Service') AS ClientLastName
	,'' AS ClientFirstName
	,gs.DateOfService AS DateOfService
	,'' AS DocumentName
	,'' AS DisplayAs
	,'' AS ProgramCode
	,'' AS AuthorizationsNeeded
	,gs.GroupServiceId AS ServiceId
	,'' AS DocumentId
	,gs.GroupId AS Clientid
	,gcs.CodeName AS STATUS
	,0 AS BitmapNo
	,0 AS ClientNoteId1
	,0 AS NoteType1
	,'0' AS Bitmap1
	,'0' AS Note1
	,0 AS BitmapId1
	,0 AS ClientNoteId2
	,0 AS NoteType2
	,'0' AS Bitmap2
	,'0' AS Note2
	,0 AS BitmapId2
	,0 AS ClientNoteId3
	,0 AS NoteType3
	,'0' AS Bitmap3
	,'0' AS Note3
	,0 AS BitmapId3
	,0 AS ClientNoteId4
	,0 AS NoteType4
	,'0' AS Bitmap4
	,'0' AS Note4
	,0 AS BitmapId4
	,0 AS ClientNoteId5
	,0 AS NoteType5
	,'0' AS Bitmap5
	,'0' AS Note5
	,0 AS BitmapId5
	,0 AS ClientNoteId6
	,0 AS NoteType6
	,'0' AS Bitmap6
	,'0' AS Note6
	,0 AS BitmapId6
	,0 AS clientid
	,isnull(gr.GroupCode, '') AS ClientDisplayName
	,'GroupService' AS PageName
FROM #GroupService g
 LEFT JOIN GroupServiceStaff gss ON gss.GroupServiceId = g.GroupServiceId
	AND gss.StaffId = @LoggedInStaffId
LEFT JOIN GroupServices gs ON gs.GroupServiceId = g.GroupServiceId  --- Added on 18/Nov/2015  by Aravind
INNER JOIN Groups gr ON gr.GroupId = gs.GroupId
LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = gs.STATUS
WHERE isnull(gss.RecordDeleted, 'N') <> 'Y'

UNION ALL

SELECT a.[Subject] AS ClientLastName
	,'' AS ClientFirstName
	,ap.StartTime AS DateOfService
	,'' AS DocumentName
	,'' AS DisplayAs
	,'' AS ProgramCode
	,'' AS AuthorizationsNeeded
	,'' AS ServiceId
	,'' AS DocumentId
	,'' AS Clientid
	,'' AS STATUS
	,0 AS BitmapNo
	,0 AS ClientNoteId1
	,0 AS NoteType1
	,'0' AS Bitmap1
	,'0' AS Note1
	,0 AS BitmapId1
	,0 AS ClientNoteId2
	,0 AS NoteType2
	,'0' AS Bitmap2
	,'0' AS Note2
	,0 AS BitmapId2
	,0 AS ClientNoteId3
	,0 AS NoteType3
	,'0' AS Bitmap3
	,'0' AS Note3
	,0 AS BitmapId3
	,0 AS ClientNoteId4
	,0 AS NoteType4
	,'0' AS Bitmap4
	,'0' AS Note4
	,0 AS BitmapId4
	,0 AS ClientNoteId5
	,0 AS NoteType5
	,'0' AS Bitmap5
	,'0' AS Note5
	,0 AS BitmapId5
	,0 AS ClientNoteId6
	,0 AS NoteType6
	,'0' AS Bitmap6
	,'0' AS Note6
	,0 AS BitmapId6
	,0 AS clientid
	,isnull(ap.[Subject], '') AS ClientDisplayName
	,'Appointments' AS PageName
FROM #Appointments a
INNER JOIN Appointments ap ON ap.AppointmentId = a.AppointmentId
WHERE isnull(ap.RecordDeleted, 'N') <> 'Y'
ORDER BY DateOfService
	,ClientDisplayName
GO



