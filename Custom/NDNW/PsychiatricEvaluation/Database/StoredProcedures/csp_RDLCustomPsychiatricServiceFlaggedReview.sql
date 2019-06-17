IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceFlaggedReview]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceFlaggedReview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceFlaggedReview]
 (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015    Revathi      What:Get PsychiatricService Flagged Review information
                             Why:task #823 Woods-Customizations
************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @ServiceId int;
		DECLARE @EffectiveDate DATETIME

		SELECT @ClientId = D.ClientId,@ServiceId = D.ServiceId 
		FROM Documents D
		WHERE D.InProgressDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		SELECT s.ServiceId
			,s.DateOfService
			,(CONVERT(VARCHAR(20), s.DateOfService, 101) + ' ' + RIGHT(CONVERT(VARCHAR, s.DateOfService, 0), 6)) AS DOS
			,gcs.CodeName AS [Status]
			,pc.ProcedureCodeName AS [ProcedureCode]
			,pc.ProcedureCodeName AS [Document]
			,(st.FirstName + ', ' + st.LastName) AS Clinician
			,p.ProgramName
			,s.Comment
		FROM Services s
		INNER JOIN CustomServices cs ON cs.ServiceId = s.ServiceId
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
		INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = s.STATUS
		INNER JOIN Programs p ON p.ProgramId = s.ProgramId
		LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
		LEFT JOIN Locations loc ON s.LocationId = loc.LocationId
		LEFT JOIN documents d ON d.ServiceId = s.ServiceId
		WHERE s.ClientId = @ClientId
			AND cs.PsychiatristReview = 'Y'
			AND isnull(s.RecordDeleted, 'N') <> 'Y'
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND d.Status = 22
			AND s.ServiceId <>@ServiceId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' +
		 CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + 
		 ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomPsychiatricServiceFlaggedReview')
		  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +
		   CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' 
		   + CONVERT(VARCHAR, ERROR_STATE())

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

