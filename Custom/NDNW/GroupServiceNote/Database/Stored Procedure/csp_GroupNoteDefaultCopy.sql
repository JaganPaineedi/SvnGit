IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_GroupNoteDefaultCopy')
	BEGIN
		DROP PROCEDURE csp_GroupNoteDefaultCopy
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

 
CREATE PROCEDURE [dbo].[csp_GroupNoteDefaultCopy]
	@GroupServiceId INT,
	@StaffId INT

AS

/************************************************
* csp_GroupNoteDefaultCopy
* 03/18/2015
* New Directions North West
* Tyler Ryan
*
* Selects note text for field narration in both 
* the group note and the client note
*
*************************************************/

DECLARE @NoteText VARCHAR(MAX)

SELECT @NoteText = m.Narration
FROM dbo.CustomMiscellaneousNotes m
JOIN Documents d ON d.CurrentDocumentVersionId = m.DocumentVersionId
WHERE d.GroupServiceId = @GroupServiceId
	AND d.AuthorId = @StaffId
	AND d.ClientId IS NULL
	AND ISNULL(m.RecordDeleted, 'N') = 'N'
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	
UPDATE m
SET Narration = CAST(ISNULL(@NoteText, '') AS VARCHAR(MAX)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CAST(ISNULL(m.Narration, '') AS VARCHAR(MAX))
FROM dbo.CustomMiscellaneousNotes m
JOIN Documents d ON d.CurrentDocumentVersionId = m.DocumentVersionId
JOIN Services s ON s.ServiceId = d.ServiceId
					AND s.ClinicianId = d.AuthorId
WHERE s.GroupServiceId = @GroupServiceId
AND d.AuthorId = @StaffId
AND d.Status <> 22
AND ISNULL(m.RecordDeleted, 'N') = 'N'
AND ISNULL(d.RecordDeleted, 'N') = 'N'
AND ISNULL(s.RecordDeleted, 'N') = 'N'

GO
