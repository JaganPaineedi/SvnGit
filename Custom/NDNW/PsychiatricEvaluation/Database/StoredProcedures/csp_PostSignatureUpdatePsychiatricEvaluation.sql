/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdatePsychiatricEvaluation]    Script Date: 02/17/2014 12:23:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdatePsychiatricEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureUpdatePsychiatricEvaluation]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdatePsychiatricEvaluation]    Script Date: 02/17/2014 12:23:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PostSignatureUpdatePsychiatricEvaluation] --  11                       
	(@DocumentVersionId INT)
AS
/*************************************************************************** */
/* Stored Procedure: [csp_PostSignatureUpdatePsychiatricEvaluation]          */
/* Creation Date:  12/JAN/2015                                               */
/* Called By: Psychiatric Evaluations Service Note Post signature updates    */
/* Data Modifications:                                                       */
/*   Updates:                                                                */
/*  12/JAN/2015 	Akwinass		Post update SP for Psychiatric Evaluations Service Note*/
/*****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @ClientName VARCHAR(250)
		DECLARE @DocumentId INT
		DECLARE @NotifyStaff1 INT
		DECLARE @NotifyStaff2 INT
		DECLARE @NotifyStaff3 INT
		DECLARE @Staffs TABLE (StaffId INT)

		SELECT TOP 1 @ClientId = C.ClientId
			,@ClientName = C.LastName + ', ' + C.FirstName
			,@DocumentId = Dv.DocumentId
			,@NotifyStaff1 = CD.NotifyStaff1
			,@NotifyStaff2 = CD.NotifyStaff2
			,@NotifyStaff3 = CD.NotifyStaff3
		FROM CustomDocumentPsychiatricEvaluations CD
		INNER JOIN Documents Dv ON Dv.CurrentDocumentVersionId = CD.DocumentVersionId
		INNER JOIN Clients C ON C.ClientId = Dv.ClientId
		INNER JOIN Services S ON S.ServiceId = DV.ServiceId
		INNER JOIN Programs P ON P.ProgramId = S.ProgramId
		INNER JOIN DocumentCodes DC ON DC.DocumentCodeid = Dv.DocumentCodeId
		LEFT JOIN Staff st ON st.StaffId = C.ProviderPrimaryClinicianId
		WHERE ISNULL(CD.RecordDeleted, 'N') = 'N'
			AND ISNULL(Dv.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND CD.DocumentVersionId = @DocumentVersionId

		IF ISNULL(@NotifyStaff1, 0) > 0
		BEGIN
			IF NOT EXISTS (SELECT StaffId FROM @Staffs WHERE StaffId = @NotifyStaff1)
			BEGIN
				INSERT INTO @Staffs (StaffId)
				VALUES (@NotifyStaff1)
			END
		END

		IF ISNULL(@NotifyStaff2, 0) > 0
		BEGIN
			IF NOT EXISTS (SELECT StaffId FROM @Staffs WHERE StaffId = @NotifyStaff2)
			BEGIN
				INSERT INTO @Staffs (StaffId)
				VALUES (@NotifyStaff2)
			END
		END

		IF ISNULL(@NotifyStaff3, 0) > 0
		BEGIN
			IF NOT EXISTS (SELECT StaffId FROM @Staffs WHERE StaffId = @NotifyStaff3)
			BEGIN
				INSERT INTO @Staffs (StaffId)
				VALUES (@NotifyStaff3)
			END
		END

		INSERT INTO [Alerts] (
			 [ToStaffId]
			,[ClientId]
			,[Unread]
			,[DateReceived]
			,[Subject]
			,[Message]
			,[AlertType]
			,[DocumentId]
			,[TabId]
			)
		SELECT StaffId
			,@ClientId
			,'Y'
			,GETDATE()
			,'Psychiatric Evaluation Service Note'
			,'Client "' + @ClientName + '" reported suicidal or homicidal ideation during a service and the psychiatrist asked that you be notified.  Click on the document name in this message to view the details.'
			,81
			,@DocumentId
			,2
		FROM @Staffs
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomRegistrations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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



