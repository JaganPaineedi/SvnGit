/*************************************************************************************                                                   
-- Purpose: Insert Script for GroupStandAloneDocuments table for Existing Data.
--  
-- Author:  Akwinass
-- Date:    14-APRIL-2016
--  
-- *****History****  
-- 24-May-2016       Vamsi         What: Added Serviceid is null condition to insert into GroupStandAloneDocuments again
--								   Why: Valley - Support Go Live # 492
**************************************************************************************/
DELETE FROM GroupStandAloneDocuments
DBCC CHECKIDENT('GroupStandAloneDocuments', RESEED, 0)

DECLARE @GroupServiceId INT
DECLARE @DocumentId INT
DECLARE @StaffId INT

DECLARE @ServiceId INT
	,@DateOfService DATETIME
	,@ClientId INT
	,@ClinicianId INT
	,@GroupId INT
	,@ScreenId INT
	,@GroupNoteType INT
	,@ClientName VARCHAR(1000)
	,@GroupNoteDocumentCodeId INT
	,@GroupName VARCHAR(1000)

DECLARE attendance_cursor CURSOR
FOR
SELECT DISTINCT s.ServiceId
	,s.DateOfService
	,s.ClientId
	,s.ClinicianId
	,g.GroupId
	,g.AttendanceScreenId
	,g.GroupNoteType
	,C.LastName + ', ' + C.FirstName
	,g.GroupNoteDocumentCodeId
	,g.GroupName
FROM GroupServices gs
JOIN Groups g ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N' AND ISNULL(g.UsesAttendanceFunctions, 'N') = 'Y'
JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'
JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N'
JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId
JOIN Clients C ON s.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'
JOIN StaffClients SC ON C.ClientId = SC.ClientId AND SC.StaffId = s.ClinicianId
LEFT JOIN Staff ST ON s.ClinicianId = ST.StaffId
LEFT JOIN Locations L ON g.LocationId = L.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = s.CancelReason AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
WHERE ISNULL(gs.RecordDeleted, 'N') = 'N'	
ORDER BY s.ServiceId ASC

OPEN attendance_cursor

FETCH NEXT
FROM attendance_cursor
INTO @ServiceId
	,@DateOfService
	,@ClientId
	,@ClinicianId
	,@GroupId
	,@ScreenId
	,@GroupNoteType
	,@ClientName
	,@GroupNoteDocumentCodeId
	,@GroupName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @GroupServiceId = NULL
	SET @DocumentId = 0

	IF ISNULL(@GroupNoteDocumentCodeId, 0) > 0 AND @GroupNoteType = 9383
	BEGIN
		SELECT TOP 1 @GroupServiceId = s.GroupServiceId,@GroupId = gs.GroupId
		FROM GroupServices gs LEFT JOIN Groups g ON g.GroupId = gs.GroupId 	AND ISNULL(g.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = g.GroupType AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		LEFT JOIN Programs p ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'
		JOIN Services s ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId
		LEFT JOIN GroupServiceStaff ON GroupServiceStaff.GroupServiceId = gs.GroupServiceId AND ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N'
		CROSS APPLY [dbo].[ssf_SCGetGroupServiceStatus](gs.GroupServiceId) svcstatus 
		LEFT OUTER JOIN dbo.GlobalCodes svcstatusgc ON svcstatusgc.GlobalCodeId = svcstatus.[Status] AND ISNULL(svcstatusgc.RecordDeleted, 'N') = 'N' WHERE ISNULL(gs.RecordDeleted, 'N') = 'N' AND s.ServiceId = @ServiceId
	END

	IF ISNULL(@ServiceId, 0) > 0 AND ISNULL(@GroupNoteType, 0) = 9383 AND ISNULL(@ScreenId, 0) = 0
	BEGIN
		SET @DocumentId = 0
	END
	ELSE
	BEGIN
		IF ISNULL(@GroupNoteType, 0) = 9384 OR ISNULL(@GroupNoteType, 0) = 9385
		BEGIN
			DECLARE @DocumentCodeId INT = 0

			SELECT TOP 1 @DocumentCodeId = ServiceNoteCodeId
			FROM GroupNoteDocumentCodes
			WHERE GroupNoteDocumentCodeId = @GroupNoteDocumentCodeId
				AND ISNULL(Active, 'N') = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SET @DocumentId = 0
			

			SELECT TOP 1 @DocumentId = d.DocumentId,@StaffId = d.AuthorId
			FROM Documents d
			INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
			INNER JOIN Staff a ON a.StaffId = d.AuthorId
			INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
			WHERE d.ClientID = @ClientId
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'
				AND d.DocumentCodeId = @DocumentCodeId
				AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
				AND d.[Status] = 22
				AND d.AuthorId = @ClinicianId
				AND d.ServiceId IS NULL
			ORDER BY d.ModifiedDate DESC
			
			IF ISNULL(@DocumentId, 0) = 0
			BEGIN
				SELECT TOP 1 @DocumentId = d.DocumentId,@StaffId = d.AuthorId
				FROM Documents d
				INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
				INNER JOIN Staff a ON a.StaffId = d.AuthorId
				INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
				WHERE d.ClientID = @ClientId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(sr.RecordDeleted, 'N') = 'N'
					AND d.DocumentCodeId = @DocumentCodeId
					AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
					AND d.[Status] NOT IN(20,23)
					AND d.AuthorId = @ClinicianId
					AND d.ServiceId IS NULL
				ORDER BY d.ModifiedDate DESC
			END			

			IF ISNULL(@DocumentId, 0) > 0 AND NOT EXISTS (SELECT 1 FROM GroupStandAloneDocuments WHERE GroupId = @GroupId AND ClientId = @ClientId AND StaffId = @StaffId AND ServiceId = @ServiceId AND DocumentId = @DocumentId)
			BEGIN
				INSERT INTO GroupStandAloneDocuments ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[GroupId],[ClientId],[StaffId],[ServiceId],[DocumentId])
				VALUES ('429_VSGL_CONVERSION',GETDATE(),'429_VSGL_CONVERSION',GETDATE(),@GroupId,@ClientId,@StaffId,@ServiceId,@DocumentId)
			END
		END
	END


	FETCH NEXT
	FROM attendance_cursor
	INTO @ServiceId
		,@DateOfService
		,@ClientId
		,@ClinicianId
		,@GroupId
		,@ScreenId
		,@GroupNoteType
		,@ClientName
		,@GroupNoteDocumentCodeId
		,@GroupName
END

CLOSE attendance_cursor

DEALLOCATE attendance_cursor