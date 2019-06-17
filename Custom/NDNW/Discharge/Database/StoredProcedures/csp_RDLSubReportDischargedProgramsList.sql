IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportDischargedProgramsList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLSubReportDischargedProgramsList]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportDischargedProgramsList]    Script Date: 07/28/2016 10:08:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLSubReportDischargedProgramsList] 
	@DocumentVersionId INT
AS
/***************************************************************************************************/
/* Stored Procedure: [csp_RDLSubReportDischargedProgramsList]   */
/*       Date              Author                  Purpose                   */
/*      10-08-2014     Dhanil Manuel               To Retrieve Data  for RDL   */
/*		07-26-2016	   Ting-Yu Mu				   Addes the RecordDelete check in the where clause*/
/***************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

		SELECT @ClientId = d.ClientId
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		SELECT P.ProgramCode
			,CASE 
				WHEN CP.[Status] = 5
					THEN 'Discharge'
				ELSE 'Remain Open'
				END ActionTaken
			,CASE 
				WHEN CP.PrimaryAssignment = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS PrimaryAssignment
			,CP.ClientProgramId
			,CASE CP.STATUS
				WHEN '1'
					THEN NULL
				ELSE CONVERT(VARCHAR(10), CP.EnrolledDate, 101)
				END AS EnrolledDate
		FROM ClientPrograms CP
		INNER JOIN Programs P ON cp.ProgramId = P.ProgramId
		INNER JOIN Clients C ON C.ClientId = CP.ClientId
		WHERE c.ClientId = @ClientId
			AND CP.[Status] IN (
				1
				,4
				)
			AND IsNull(CP.RecordDeleted, 'N') = 'N'
			AND IsNull(P.RecordDeleted, 'N') = 'N'
			AND IsNull(C.RecordDeleted, 'N') = 'N'
			OR (
				CP.ClientProgramId IN (
					SELECT ClientProgramId
					FROM CustomDischargePrograms
					WHERE DocumentVersionId = @DocumentVersionId
						AND IsNull(RecordDeleted, 'N') = 'N'
					)
				AND IsNull(CP.RecordDeleted, 'N') = 'N'
				) -- tmu modification here
		ORDER BY CP.ClientProgramId ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) 
		+ '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLSubReportDischargedProgramsList') 
		+ '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) 
		+ '*****' + Convert(VARCHAR, ERROR_STATE())

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


