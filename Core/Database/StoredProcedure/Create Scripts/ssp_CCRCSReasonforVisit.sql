/****** Object:  StoredProcedure [dbo].[ssp_CCRCSReasonforVisit]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSReasonforVisit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSReasonforVisit] @ClientId BIGINT
	,@ServiceID INT = NULL
	,@DocumentVersionId INT = NULL
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @IsProgressNote CHAR(1)
		DECLARE @DocumentCodeId INT
		DECLARE @AppointmentType INT

		IF (@DocumentVersionId IS NULL)
		BEGIN
			SET @IsProgressNote = ''N''
		END
		ELSE
		BEGIN
			SELECT TOP 1 @DocumentCodeId = DocumentCodeId
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, ''N'') = ''N''

			IF (@DocumentCodeId = 300)
			BEGIN
				SET @IsProgressNote = ''Y''
			END
			ELSE
			BEGIN
				SET @IsProgressNote = ''N''
			END
		END

		IF (@IsProgressNote = ''N'')
		BEGIN
			SELECT pc.ProcedureCodeName AS ReasonforVisit
			FROM Services s
			INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId
			WHERE s.ServiceId = @ServiceId
		END
		ELSE
		BEGIN
			SELECT TOP 1 @AppointmentType = AppointmentID
			FROM Documents
			WHERE InprogressdocumentVersionid = @DocumentVersionId
				AND ISNULL(RecordDeleted, ''N'') = ''N''

			IF (@AppointmentType IS NOT NULL)
			BEGIN
				SELECT G.CodeName AS ReasonforVisit
				FROM Globalcodes G
				INNER JOIN Appointments A ON A.AppointmentType = G.GlobalcodeId
				WHERE A.AppointmentId = @AppointmentType
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSReasonforVisit'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
' 
END
GO
