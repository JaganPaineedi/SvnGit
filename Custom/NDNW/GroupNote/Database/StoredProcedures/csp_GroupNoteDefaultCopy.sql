/****** Object:  StoredProcedure [dbo].[csp_GroupNoteDefaultCopy]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GroupNoteDefaultCopy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GroupNoteDefaultCopy]
GO


/****** Object:  StoredProcedure [dbo].[csp_GroupNoteDefaultCopy]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
/***ModifiedDate       ModifiedBy      Comment ***/
/** 04/21/2015         Vichee Humane   Modified the code as it was updating the same value twice 
                                       NDNW-Setup #4.09  **/
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
--SET Narration = CAST(ISNULL(@NoteText, '') AS VARCHAR(MAX)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CAST(ISNULL(m.Narration, '') AS VARCHAR(MAX)) 
SET Narration = CAST(ISNULL(@NoteText, '') AS VARCHAR(MAX))  
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


