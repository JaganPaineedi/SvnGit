/****** Object:  StoredProcedure [dbo].[csp_PostSignatureDischarge]    Script Date: 3/7/2017 8:46:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_PostSignatureDischarge]
	@ScreenKeyId INT,
	@StaffId INT,
	@CurrentUser VARCHAR(30),
	@CustomParameters XML
/****************************************************************/
-- PROCEDURE: csp_PostSignatureDischarge
-- PURPOSE: Post New Directions Northwest discharge signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		3.7.2017 - Robert Caffrey - Created.
/****************************************************************/

AS

BEGIN TRY
begin TRAN

--Set the Variables and get Client ID
declare @DocumentVersionId int, @EffectiveDate datetime, @ClientId int, @AuthorId int

select @DocumentVersionId = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate, @ClientId = ClientId, @AuthorId = AuthorId
from Documents
where DocumentId = @ScreenKeyId

--Mark all To Do Documents as Record Deleted for the Client being Discharged
UPDATE d SET 
RecordDeleted = 'Y',
DeletedDate = GETDATE(),
DeletedBy = 'Discharge PostUpdate'
FROM documents d
WHERE d.Status = 20
AND d.ClientId = @ClientId


COMMIT TRAN
END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0 ROLLBACK TRAN

DECLARE @errorMessage NVARCHAR(4000)
SET @errorMessage = ERROR_MESSAGE()

RAISERROR(@errorMessage, 16, 1)

END CATCH



GO


--SELECT * FROM dbo.Screens
--WHERE DocumentCodeId = 46225

--BEGIN TRAN
--UPDATE dbo.Screens SET PostUpdateStoredProcedure = 'csp_PostSignatureDischarge'
--WHERE DocumentCodeId = 46225

--COMMIT

